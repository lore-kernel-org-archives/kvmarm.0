From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [kvmtool PATCH v6 6/6] arm/kvm: arm64: Add a vcpu feature for
 pointer authentication
Date: Tue, 5 Mar 2019 11:11:51 +0000
Message-ID: <20190305111149.GK3567@e103592.cambridge.arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
 <1550568271-5319-7-git-send-email-amit.kachhap@arm.com>
 <20190221155409.GA3567@e103592.cambridge.arm.com>
 <048f772a-1faf-5fa3-d82c-25212a5104af@arm.com>
 <20190301112452.GS16031@e103592.cambridge.arm.com>
 <b21de5ed-197d-3ea7-021c-b3bca312e70c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b21de5ed-197d-3ea7-021c-b3bca312e70c@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kristina Martsenko <Kristina.Martsenko@arm.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 04, 2019 at 04:38:18PM +0530, Amit Daniel Kachhap wrote:
> 
> Hi Dave,
> 
> On 3/1/19 4:54 PM, Dave P Martin wrote:
> >On Fri, Mar 01, 2019 at 10:37:54AM +0000, Amit Daniel Kachhap wrote:
> >>Hi,
> >>
> >>On 2/21/19 9:24 PM, Dave Martin wrote:
> >>>On Tue, Feb 19, 2019 at 02:54:31PM +0530, Amit Daniel Kachhap wrote:
> >
> >[...]
> >
> >>>>diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> >>>>index 04be43d..2074684 100644
> >>>>--- a/arm/aarch64/include/kvm/kvm-config-arch.h
> >>>>+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> >>>>@@ -8,7 +8,9 @@
> >>>>   			"Create PMUv3 device"),				\
> >>>>   	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
> >>>>   			"Specify random seed for Kernel Address Space "	\
> >>>>-			"Layout Randomization (KASLR)"),
> >>>>+			"Layout Randomization (KASLR)"),		\
> >>>>+	OPT_BOOLEAN('\0', "ptrauth", &(cfg)->has_ptrauth,		\
> >>>>+			"Enable address authentication"),
> >>>
> >>>Nit: doesn't this enable address *and* generic authentication?  The
> >>>discussion on what capababilities and enables the ABI exposes probably
> >>>needs to conclude before we can finalise this here.
> >>ok.
> >>>
> >>>However, I would recommend that we provide a single option here that
> >>>turns both address authentication and generic authentication on, even
> >>>if the ABI treats them independently.  This is expected to be the common
> >>>case by far.
> >>ok
> >>>
> >>>We can always add more fine-grained options later if it turns out to be
> >>>necessary.
> >>Mark suggested to provide 2 flags [1] for Address and Generic
> >>authentication so I was thinking of adding 2 features like,
> >>
> >>+#define KVM_ARM_VCPU_PTRAUTH_ADDR		4 /* CPU uses pointer address
> >>authentication */
> >>+#define KVM_ARM_VCPU_PTRAUTH_GENERIC		5 /* CPU uses pointer generic
> >>authentication */
> >>
> >>And supply both of them concatenated in VCPU_INIT stage. Kernel KVM
> >>would expect both feature requested together.
> >
> >Seems reasonable.  Do you mean the kernel would treat it as an error if
> >only one of these flags is passed to KVM_ARM_VCPU_INIT, or would KVM
> >simply treat them as independent?
> If both flags are passed together then only start using ptrauth otherwise
> keep ptrauth disabled. This is just to finalize the user side abi as of now
> and KVM can be updated later.

If just flag is passed, I think KVM_ARM_VCPU_INIT should just fail.
Otherwise we risk userspace becoming accidentally reliant on behaviour
that may change in the future.

Cheers
---Dave
