From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Don't let userspace update CNTVOFF
 once guest is running
Date: Thu, 9 Jul 2015 14:08:54 +0200
Message-ID: <20150709120854.GM13530@cbox>
References: <558BC90B.4060806@huawei.com>
 <558CD9DE.3010609@web.de>
 <55917E5B.3030401@huawei.com>
 <CAFEAcA-vS8B8pJUSseFw0OaKJFPe-0rMT-XHxjNbSvyxaZ+9Tg@mail.gmail.com>
 <559D483A.40507@arm.com>
 <CAFEAcA-U1mEGy87ax4Cb1MLFcEP+sqc9BL_Q0hO6qg1J3FCMew@mail.gmail.com>
 <559D51C5.3070600@arm.com>
 <CAFEAcA-rWf5UkiP+5UbtjYihfhDOVaY4hVpXNRGMnYEhNWqwSQ@mail.gmail.com>
 <20150709102201.GH13530@cbox>
 <559E4FA7.2060307@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559E4FA7.2060307@web.de>
Sender: kvm-owner@vger.kernel.org
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Claudio Fontana <claudio.fontana@huawei.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Thu, Jul 09, 2015 at 12:40:39PM +0200, Jan Kiszka wrote:
> On 2015-07-09 12:22, Christoffer Dall wrote:
> > Hi Peter and Marc,
> >=20
> > [cc'ing Paolo for his input on x86 timekeeping]
> >=20
> > On Wed, Jul 08, 2015 at 08:13:59PM +0100, Peter Maydell wrote:
> >> On 8 July 2015 at 17:37, Marc Zyngier <marc.zyngier@arm.com> wrote:
> >>> On 08/07/15 17:06, Peter Maydell wrote:
> >>>> I'd prefer it if somebody could investigate to see why QEMU
> >>>> is actually doing this -- so far we just have speculation.
> >>>
> >>> I'd prefer that too, but so far people seem to be more comfortable
> >>> waiting for the issue to fix itself. In the meantime, VMs are broken =
in
> >>> weird and wonderful ways, and I don't think the current status-quo he=
lps
> >>> anyone.
> >>
> >> Putting in a patch which might not be the right fix isn't
> >> necessarily a good plan either...
> >>
> >> Does has_run_once get cleared if we do a re-VCPU_INIT
> >> of a CPU that's run before? (We need to allow rewriting
> >> of guest state at that point so that "reset VM and
> >> load migration state" behaves correctly.)
> >=20
> > no, it does not, has_run_once is set the first time a VCPU is run and is
> > currently *never* cleared.
> >=20
> >>
> >> I suspect Jan is right and we really need to distinguish
> >> the KVM_PUT_*_STATE levels in ARM QEMU. This probably
> >> implies some kind of whitelist/override mechanism, since
> >> by and large we neither know nor want to know the
> >> semantics for system registers, we leave that up to the
> >> kernel.
> >>
> >> Q: if you have a running VM, and you pause it for
> >> an hour, what should the CNTVCT register do? Presumably
> >> it should not advance, but how do we arrange for that
> >> to happen?
> >>
> >=20
> > I think the CNTVCT should not advance when the VM is not scheduled, so
> > if we pause the VM or starve all the VCPUs for enough time, the guest
> > should not see time progressing, since otherwise the guest scheduler
> > cannot maintain fairness and you're bound to see spurious RCU stalls
> > etc.
> >=20
> > That's exactly why a guest can read both a virtual and physical counter
> > and it is an area where you simply want some level of
> > paravirtualization.  I haven't studied how/if Linux deals with this at
> > all.
> >=20
> > So I think adjusting CNTVOFF should be managed by the kernel for the
> > pause/starvation scenario (which I think Avi once told me x86 does too -
> > does anyone know the current state of the art?).
> >=20
> > So the only situation where I think userspace should adjust the CNTVOFF
> > value is for migration where we are talking about a brand new VM with
> > has_run_once clear.
> >=20
> > Thus, if we were designing this from scratch now, the API should
> > be to return an error when trying to set KVM_REG_ARM_TIMER_CNT after the
> > VM has run once, but it's too late for that as we would break userspace.
> > The best alternative IMHO would be to merge Marc's patch and fix CNTVOFF
> > in the kernel side as well, and finally also fix QEMU so that it doesn't
> > try to do the thing that future kernels will ignore.
>=20
> Fixing QEMU to only write on KVM_PUT_FULL_STATE - yes, that should be
> done, but I don't think the approach for the kernel is generally right.
> The kernel should not do any policing on user space requests to change
> the VCPU or VM state unless
>=20
>  - security is affected
>  - userspace lacks information, thus cannot decide correctly
>  - legacy userspace has a bug, we can detect it and want to fix that up
>    without affecting future userspace that has a reason to do it
>    differently
>=20
> Regarding CNTVOFF, the first two criteria do not apply for sure. Maybe
> the last one, don't know. Just think of the hypothetical scenario that a
> userspace VM debugger wants to inject certain register manipulations. If
> you block this by some hidden VM state like proposed, that feature would
> no longer be implementable easily.
>=20
Hmm, I didn't think about this, I guess reverse execution and
record/replay scenarios would also want you to make time appear to be
going backwards?

But the third case kind of does apply, if we care about fixing legacy
userspace in the kernel.  We could define a new register index for the
ioctl that allows time to move forward that future userspace can use,
and impose the restriction of not making time go backwards with the
current index.  Would that break any currently working use cases on
arm64 with legacy userspace, such as migration?

Thanks,
-Christoffer

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJVnmRWAAoJEEtpOizt6ddyaCcH/RgL39ixiH7WCR/xFkP8Y4/H
4Ae4LJEXoBtda0PuzOBTOVv5NTz1RESrMa08Zwgkj87Qc4RkvEG0xEkkiNLDmaGn
TtTwm1kgHHPaqZrP5iV3Dyn2Jg2Nv+Iq071bm0HQWPqpp2O1KfCKn/oBANJuEMph
DAg1O/gPxBg6Um+QIdJc1/K5pef4f32o3moOJtz/zctzHoE9TmnPMxAeA6K7bXnw
jPDWudhQYQFhlCSm0Fds4bukG1rayujckUrTfmcR2a2mmld71Fv/hrkPYSpnKAss
IYX0ofC+kjIUYXsiWmZOLKpEj8Dr1PG5pC4Zw3cYki9v4z8fnpXkklPreBFCW9w=
=ZrfX
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
