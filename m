From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Clean up some obsolete code
Date: Thu, 8 Oct 2015 14:33:09 +0200
Message-ID: <20151008123309.GB20936@cbox>
References: <cover.1443796321.git.p.fedin@samsung.com>
 <20151008101408.GA20936@cbox>
 <56164BC4.80104@arm.com>
 <5616503A.7060504@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5616503A.7060504@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Pavel Fedin <p.fedin@samsung.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 08, 2015 at 12:15:06PM +0100, Andre Przywara wrote:
> Hi,
>=20
> On 08/10/15 11:56, Marc Zyngier wrote:
> > On 08/10/15 11:14, Christoffer Dall wrote:
> >> Hi Pavel,
> >>
> >> On Fri, Oct 02, 2015 at 05:44:27PM +0300, Pavel Fedin wrote:
> >>> Current KVM code has lots of old redundancies, which can be clean=
ed up.
> >>> This patchset is actually a better alternative to
> >>> http://www.spinics.net/lists/arm-kernel/msg430726.html, which all=
ows to
> >>> keep piggy-backed LRs. The idea is based on the fact that our cod=
e also
> >>> maintains LR state in elrsr, and this information is enough to tr=
ack LR
> >>> usage.
> >>>
> >>> This patchset is made against linux-next of 02.10.2015. Thanks to=
 Andre
> >>> for pointing out some 4.3 specifics.
> >>>
> >> I'm not opposed to these changes, they clean up the data structure=
s
> >> which is definitely a good thing.
> >>
> >> I am a bit worries about how/if this is going to conflict with the=
 ITS
> >> series and other patches in flight touchignt he vgic.
> >>
> >> Marc/Andre, any thoughts on this?
> >=20
> > I don't mind the simplification (Andre was already removing the
> > piggybacking stuff as part of his ITS series). I'm a bit more cauti=
ous
> > about the sync_elrsr stuff, but that's mostly because I've only rea=
d the
> > patch in a superficial way.
> >=20
> > But yes, this is probably going to clash, unless we make this part =
of an
> > existing series (/me looks at Andr=E9... ;-)
>=20
> Yes, I am looking at merging this. From the discussion with Pavel I
> remember some things that I disagreed with, so I may propose a follow=
-up
> patch. I will give this a try tomorrow.
>=20
=46rom a maintainer perspective I'd much prefer Andre take these patche=
s
as part of his series and send everything together in one go.

Thanks,
-Christoffer
