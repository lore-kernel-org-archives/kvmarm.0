From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 06/10] KVM: arm64: guest debug, add SW break point
 support
Date: Wed, 29 Apr 2015 12:38:14 +0200
Message-ID: <20150429103814.GC4137@cbox>
References: <20150414082558.GS6186@cbox>
 <87y4li6hua.fsf@linaro.org>
 <20150427200407.GG23335@cbox>
 <CAFEAcA-Kh7Tn+kw9psL=gqme9ogAn+mM8Uco_HcJy=cqg72hbw@mail.gmail.com>
 <87wq0wr6dd.fsf@linaro.org>
 <CAFEAcA85i_1JybEFBg91NA3-LpAzYh4RSDnqryOd=rZN7gZP5A@mail.gmail.com>
 <20150428125645.GA4137@cbox>
 <87tww0qqh9.fsf@linaro.org>
 <20150429081047.GB4137@cbox>
 <87r3r31eed.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r3r31eed.fsf@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zhichao Huang <zhichao.huang@linaro.org>, "J. Kiszka" <jan.kiszka@siemens.com>, David Hildenbrand <dahi@linux.vnet.ibm.com>, Bharat Bhushan <r65777@freescale.com>, bp@suse.de, Gleb Natapov <gleb@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 29, 2015 at 10:18:18AM +0100, Alex Benn=E9e wrote:
>=20
> Christoffer Dall <christoffer.dall@linaro.org> writes:
>=20
> > On Tue, Apr 28, 2015 at 03:37:01PM +0100, Alex Benn=E9e wrote:
> >>=20
> >> Christoffer Dall <christoffer.dall@linaro.org> writes:
> >>=20
> >> > On Tue, Apr 28, 2015 at 10:34:12AM +0100, Peter Maydell wrote:
> >> >> On 28 April 2015 at 09:42, Alex Benn=E9e <alex.bennee@linaro.or=
g> wrote:
> >> >> > Peter Maydell <peter.maydell@linaro.org> writes:
> >> >> >> Does the kernel already have a conveniently implemented "inj=
ect
> >> >> >> exception into guest" lump of code? If so it might be less e=
ffort
> >> >> >> to do it that way round, maybe.
> >> >> >
> >> >> > So you pointed out we can't just re-inject the exceptions we =
get as we
> >> >> > need to map from things like ESR_ELx_EC_WATCHPT_LOW to
> >> >> > ESR_ELx_EC_WATCHPT_CUR before re-injection.
> >> >> >
> >> >> > Of course if it is as simple as modifying the ESR_EL1 registe=
r and
> >> >> > returning +ve in the handle_exit path then I can do that but =
I assumed
> >> >> > if any other wrangling needs doing it should be done in users=
pace.
> >> >>=20
> >> >> Well, somebody's got to do it, and it's the same amount of work
> >> >> either way (fiddling with ESR, making sure we direct the guest
> >> >> to the right exception vector entry point, maybe a few other
> >> >> things).
> >> >>=20
> >> > We already have code in the kernel to inject data/instruction ab=
orts,
> >> > but not sure how much benefit there is in re-using that.  It's u=
p to you
> >> > really, but I think the kernel code should be clear about what t=
he
> >> > intention is so that we don't end up in a situation where: (1) T=
he
> >> > intended behavior is unclear/vague, and (2) it doesn't actually =
work in
> >> > practice so nobody can follow the code.
> >>=20
> >> Certainly there are some cases where the kernel doesn't have all t=
he
> >> information. For example it doesn't know if the soft break was ins=
erted
> >> by the guest or the host. That to me favours the "let userspace de=
al
> >> with the ugly" approach.
> >>=20
> > Not sure I follow.
> >
> > If it's an exception for the guest, then that must be because the g=
uest
> > put in the breakpoint instruction, right?
>=20
> No the host can add breakpoint instructions as well. They both genera=
te
> the same (redirected) exception to the hypervisor which then has to
> figure out who planted the breakpoint and where the eventual exceptio=
n
> will be handled.

I understand this; let's just rewind here.

If you've concluded that the exception is for the guest, then the guest
must have placed the breakpoint instruction there, correct?  Otherwise,
the exception is for the hypervisor and the discussion about how to
inject an exception for the guest is invalid.

Or are you talking about the corner case where the host uses a soft
breakpoint to get a breakpoint on an instruction which is also a
breakpoint in the guest?

>=20
> > However, that's a separate discussion from that of *how* userspace =
or
> > the kernel then injects an exception to the guest.
> >
> > By using some QEMU TCG functionality or by QEMU calling back into K=
VM
> > and asking it to inject an exception for it.
>=20
> I don't know if there is explicit TCG functionality to use but QEMU c=
an
> set the registers and PC up for exception entry and re-enter KVM.
>=20

I also understand this.  I think Peter's point was exactly that if we
have existing code somewhere which we can reuse, then we should conside=
r
reusing it.

Again, I don't care particularly which way, I just want the expected
working behavior to be clearly defined.

-Christoffer
