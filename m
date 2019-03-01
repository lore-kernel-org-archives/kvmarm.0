From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [kvmtool PATCH v6 6/6] arm/kvm: arm64: Add a vcpu feature for
 pointer authentication
Date: Fri, 1 Mar 2019 11:24:54 +0000
Message-ID: <20190301112452.GS16031@e103592.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-7-git-send-email-amit.kachhap@arm.com>
 <20190221155409.GA3567@e103592.cambridge.arm.com>
 <048f772a-1faf-5fa3-d82c-25212a5104af@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <048f772a-1faf-5fa3-d82c-25212a5104af@arm.com>
Content-Language: en-US
Content-ID: <EAE43C6DD55A704C8A230EA1AB7EEF68@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Kachhap <Amit.Kachhap@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Kristina Martsenko <Kristina.Martsenko@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 01, 2019 at 10:37:54AM +0000, Amit Daniel Kachhap wrote:
> Hi,
>
> On 2/21/19 9:24 PM, Dave Martin wrote:
> > On Tue, Feb 19, 2019 at 02:54:31PM +0530, Amit Daniel Kachhap wrote:

[...]

> >> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/i=
nclude/kvm/kvm-config-arch.h
> >> index 04be43d..2074684 100644
> >> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> >> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> >> @@ -8,7 +8,9 @@
> >>   "Create PMUv3 device"),\
> >>   OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,\
> >>   "Specify random seed for Kernel Address Space "\
> >> -"Layout Randomization (KASLR)"),
> >> +"Layout Randomization (KASLR)"),\
> >> +OPT_BOOLEAN('\0', "ptrauth", &(cfg)->has_ptrauth,\
> >> +"Enable address authentication"),
> >
> > Nit: doesn't this enable address *and* generic authentication?  The
> > discussion on what capababilities and enables the ABI exposes probably
> > needs to conclude before we can finalise this here.
> ok.
> >
> > However, I would recommend that we provide a single option here that
> > turns both address authentication and generic authentication on, even
> > if the ABI treats them independently.  This is expected to be the commo=
n
> > case by far.
> ok
> >
> > We can always add more fine-grained options later if it turns out to be
> > necessary.
> Mark suggested to provide 2 flags [1] for Address and Generic
> authentication so I was thinking of adding 2 features like,
>
> +#define KVM_ARM_VCPU_PTRAUTH_ADDR4 /* CPU uses pointer address
> authentication */
> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC5 /* CPU uses pointer generic
> authentication */
>
> And supply both of them concatenated in VCPU_INIT stage. Kernel KVM
> would expect both feature requested together.

Seems reasonable.  Do you mean the kernel would treat it as an error if
only one of these flags is passed to KVM_ARM_VCPU_INIT, or would KVM
simply treat them as independent?

[...]

> >> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> >> index 7780251..4ac80f8 100644
> >> --- a/arm/kvm-cpu.c
> >> +++ b/arm/kvm-cpu.c
> >> @@ -68,6 +68,12 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm,=
 unsigned long cpu_id)
> >>   vcpu_init.features[0] |=3D (1UL << KVM_ARM_VCPU_PSCI_0_2);
> >>   }
> >>
> >> +/* Set KVM_ARM_VCPU_PTRAUTH if available */
> >> +if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH)) {
> >> +if (kvm->cfg.arch.has_ptrauth)
> >> +vcpu_init.features[0] |=3D ARM_VCPU_PTRAUTH_FEATURE;
> >> +}
> >> +
> >
> > I'm not too keen on requiring a dummy #define for AArch32 here.  How do
> > we handle other subarch-specific feature flags?  Is there something we
> > can reuse?
> I will check it.

OK

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
