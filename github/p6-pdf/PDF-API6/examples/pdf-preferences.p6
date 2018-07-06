use v6;
use PDF::API6;
use PDF::Page;

my PDF::API6 $pdf .= new;
use PDF::Destination :Fit;

for 1..2 -> $page-no {
    my PDF::Page $page = $pdf.add-page;
    $page.media-box = [0, 0, 450, 400];
    $page.text: {
        .font = .core-font( :family<Courier>, :weight<bold> );
        .text-position = [10, 350];

        .say: "Page $page-no/2";
        .say;
        .say: "This PDF have preferences:";
        .say: " :hide-toolbar    (toolbar should not appear in reader)";
        .say: " :page(2)         (document should open on page 2)";
        .say: " :fit(FitWindow)  (contents should scale to fit window)";
    }
}

$pdf.preferences: :hide-toolbar, :start{ :page(2), :fit(FitWindow) };
$pdf.save-as: "preferences.pdf";


