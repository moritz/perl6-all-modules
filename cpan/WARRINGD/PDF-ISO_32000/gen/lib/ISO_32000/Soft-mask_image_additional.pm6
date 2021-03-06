use v6;
# generated by: ../../etc/make-modules.p6 --role-name=ISO_32000::Soft-mask_image_additional ../../resources/ISO_32000/Soft-mask_image_additional_entries.json

#| PDF 32000-1:2008 Table 146 – Additional entry in a soft-mask image dictionary
role ISO_32000::Soft-mask_image_additional {
    method Matte {...};
}

=begin pod

=head1 Methods (Entries)

=head2 Matte [array]
- (Optional; PDF 1.4) An array of component values specifying the matte colour with which the image data in the parent image has been preblended. The array shall consist of n numbers, where n is the number of components in the colour space specified by the ColorSpace entry in the parent image’s image dictionary; the numbers is valid colour components in that colour space. If this entry is absent, the image data is not preblended.

=end pod
