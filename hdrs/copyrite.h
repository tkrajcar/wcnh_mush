/* copyrite.h */

/*
 * Copyright, License, and Credits for PennMUSH 1.x. Revised March 2006.
 *
 * I. Copyrights
 *
 * PennMUSH 1.x
 * Copyright (c) 1995-2006, T. Alexander Popiel <talek@pennmush.org>
 * and Shawn Wagner <raevnos@pennmush.org>
 * 
 * Some code used in this server may have been derived from the
 * TinyMUSH 2.2 source code, with permission. TinyMUSH 2.2 is
 * Copyright (c) 1994-2002, Jean Marie Diaz, Lydia Leong, and Devin Hooker.
 *
 * Some code used in this server may have been derived from TinyMUSH 2.0.
 * Copyright (c) 1995, Joseph Traub, Glenn Crocker.
 *
 * Some code used in this server may have been derived from TinyMUD.
 * Copyright (c) 1995, David Applegate, James Aspnes, Timothy Freeman
 * and Bennet Yee.
 *
 *------------------------------------------------------------------------*
 *
 * II. License
 *
 * Because PennMUSH includes parts of multiple works, you must comply
 * with all of the relevant licenses of those works. The portions derived
 * from TinyMUD/TinyMUSH 2.0 are licensed under the following terms:
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that: (1) source code distributions
 *   retain the above copyright notice and this paragraph in its entirety, and
 *   (2) distributions including binary code include the above copyright 
 *   notice and this paragraph in its entirety in the documentation or other 
 *   materials provided with the distribution.  The names of the copyright 
 *   holders may not be used to endorse or promote products derived from 
 *   this software without specific prior written permission.
 * 
 *   THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
 *   WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 *   MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 * Although not necessary given the above copyright, the TinyMUSH 2.0
 * developers, Joseph Traub and Glenn Crocker, confirmed in email to
 * Alan Schwartz in 2002 that they were willing to have any of their
 * code present in PennMUSH redistributed under the Artistic License.
 *
 * The portions derived from TinyMUSH 2.2 are used under the Artistic
 * License. Jean Marie Diaz, Lydia Leong, and Devin Hooker, the
 * TinyMUSH 2.2 copyright holders, explicitly agreed to relicense
 * their source code under the Artistic License in 2002, and TinyMUSH 2.2.5
 * was released under this license; Alan Schwartz has confirmatory email 
 * from them authorizing the redistribution of any portions of TinyMUSH 2.2
 * that may be present in PennMUSH under the Artistic License. 
 *
 * The Artistic License is also the license under which you
 * are granted permission to copy, modify, and redistribute PennMUSH:
 *
 * The Artistic License
 * 
 * Preamble
 * 
 * The intent of this document is to state the conditions under which a
 * Package may be copied, such that the Copyright Holder maintains some
 * semblance of artistic control over the development of the package,
 * while giving the users of the package the right to use and distribute
 * the Package in a more-or-less customary fashion, plus the right to make
 * reasonable modifications.
 * 
 * Definitions:
 * 
 * "Package" refers to the collection of files distributed by the Copyright
 * Holder, and derivatives of that collection of files created through
 * textual modification.
 * "Standard Version" refers to such a Package if it has not been modified,
 * or has been modified in accordance with the wishes of the Copyright
 * Holder.
 * "Copyright Holder" is whoever is named in the copyright or copyrights
 * for the package.
 * "You" is you, if you're thinking about copying or distributing this Package.
 * "Reasonable copying fee" is whatever you can justify on the basis of media
 * cost, duplication charges, time of people involved, and so on. (You will
 * not be required to justify it to the Copyright Holder, but only to the
 * computing community at large as a market that must bear the fee.)
 * "Freely Available" means that no fee is charged for the item itself,
 * though there may be fees involved in handling the item. It also means
 * that recipients of the item may redistribute it under the same conditions
 * they received it.
 * 
 * 1. You may make and give away verbatim copies of the source form of the
 * Standard Version of this Package without restriction, provided that
 * you duplicate all of the original copyright notices and associated
 * disclaimers.
 * 
 * 2. You may apply bug fixes, portability fixes and other modifications
 * derived from the Public Domain or from the Copyright Holder. A Package
 * modified in such a way shall still be considered the Standard Version.
 * 
 * 3. You may otherwise modify your copy of this Package in any way, provided
 * that you insert a prominent notice in each changed file stating how and
 * when you changed that file, and provided that you do at least ONE of
 * the following:
 * 
 *  a) place your modifications in the Public Domain or otherwise make them
 *  Freely Available, such as by posting said modifications to Usenet or an
 *  equivalent medium, or placing the modifications on a major archive site
 *  such as ftp.uu.net, or by allowing the Copyright Holder to include your
 *  modifications in the Standard Version of the Package.
 * 
 *  b) use the modified Package only within your corporation or organization.
 * 
 *  c) rename any non-standard executables so the names do not conflict with
 *  standard executables, which must also be provided, and provide a separate
 *  manual page for each non-standard executable that clearly documents how
 *  it differs from the Standard Version.
 * 
 *  d) make other distribution arrangements with the Copyright Holder.
 * 
 * 4. You may distribute the programs of this Package in object code or
 * executable form, provided that you do at least ONE of the following:
 * 
 *  a) distribute a Standard Version of the executables and library files,
 *  together with instructions (in the manual page or equivalent) on where
 *  to get the Standard Version.
 * 
 *  b) accompany the distribution with the machine-readable source of the
 *  Package with your modifications.
 * 
 *  c) accompany any non-standard executables with their corresponding
 *  Standard Version executables, giving the non-standard executables
 *  non-standard names, and clearly documenting the differences in manual
 *  pages (or equivalent), together with instructions on where to get the
 *  Standard Version.
 * 
 *  d) make other distribution arrangements with the Copyright Holder.
 * 
 * 5. You may charge a reasonable copying fee for any distribution of
 * this Package. You may charge any fee you choose for support of this
 * Package. You may not charge a fee for this Package itself. However, you
 * may distribute this Package in aggregate with other (possibly commercial)
 * programs as part of a larger (possibly commercial) software distribution
 * provided that you do not advertise this Package as a product of your own.
 * 
 * 6. The scripts and library files supplied as input to or produced as
 * output from the programs of this Package do not automatically fall under
 * the copyright of this Package, but belong to whomever generated them,
 * and may be sold commercially, and may be aggregated with this Package.
 * 
 * 7. C or perl subroutines supplied by you and linked into this Package
 * shall not be considered part of this Package.
 * 
 * 8. The name of the Copyright Holder may not be used to endorse or
 * promote products derived from this software without specific prior
 * written permission.
 * 
 * 9. THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 * MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 * 
 * The End
 * 
 *---------------------------------------------------------------------*
 *
 * III. Credits
 *
 * Many people have helped develop PennMUSH. In addition to the people
 * listed above, and the many people noted in the CHANGES file
 * for suggestions and patches, special mention is due to:
 *
 * Past and present PennMUSH development team members:
 *  T. Alexander Popiel, Ralph Melton, Thorvald Natvig, Luuk de Waard,
 *  Shawn Wagner, Ervin Hearn III, Alan "Javelin" Schwartz, Greg Millam
 * Past and present PennMUSH porters:
 *  Nick Gammon, Sylvia, Dan Williams, Ervin Hearn III
 * TinyMUSH 2.2, TinyMUSH 3.0, TinyMUX 2, and RhostMUSH developers
 * All PennMUSH users who've sent in bug reports and patches
 * The admin and players of DuneMUSH, Dune II, M*U*S*H, Rio:MdC, 
 *  and other places Javelin has beta-tested new versions
 * Lydia Leong (Amberyl), who maintained PennMUSH until 1995, and taught
 *  Javelin how to be a Wizard and a God of a MUSH.
 *
 */
