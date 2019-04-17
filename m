From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v9 4/5] KVM: arm64: Add capability to advertise ptrauth
 for guest
Date: Wed, 17 Apr 2019 16:22:42 +0100
Message-ID: <20190417152242.GC3567@e103592.cambridge.arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-5-git-send-email-amit.kachhap@arm.com>
 <20190416163212.GX3567@e103592.cambridge.arm.com>
 <0070b1c2-07d6-7472-1bbc-c252710f6ca3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0070b1c2-07d6-7472-1bbc-c252710f6ca3@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 17, 2019 at 03:09:02PM +0530, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 4/16/19 10:02 PM, Dave Martin wrote:
> >On Fri, Apr 12, 2019 at 08:50:35AM +0530, Amit Daniel Kachhap wrote:
> >>This patch advertises the capability of two cpu feature called address
> >>pointer authentication and generic pointer authentication. These
> >>capabilities depend upon system support for pointer authentication and
> >>VHE mode.
> >>
> >>The current arm64 KVM partially implements pointer authentication and
> >>support of address/generic authentication are tied together. However,
> >>separate ABI requirements for both of them is added so that any future
> >>isolated implementation will not require any ABI changes.
> >>
> >>Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >>Cc: Mark Rutland <mark.rutland@arm.com>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Cc: Christoffer Dall <christoffer.dall@arm.com>
> >>Cc: kvmarm@lists.cs.columbia.edu
> >>---
> >>Changes since v8:
> >>*  Keep the capability check same for the 2 vcpu ptrauth features. [Dave Martin]
> >>
> >>  Documentation/virtual/kvm/api.txt | 2 ++
> >>  arch/arm64/kvm/reset.c            | 5 +++++
> >>  include/uapi/linux/kvm.h          | 2 ++
> >>  3 files changed, 9 insertions(+)
> >>
> >>diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> >>index 9d202f4..56021d0 100644
> >>--- a/Documentation/virtual/kvm/api.txt
> >>+++ b/Documentation/virtual/kvm/api.txt
> >>@@ -2756,9 +2756,11 @@ Possible features:
> >>  	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
> >>  	  for the CPU and supported only on arm64 architecture.
> >>  	  Must be requested if KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
> >>+	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
> >
> >What if KVM_CAP_ARM_PTRAUTH_ADDRESS is absent and
> >KVM_ARM_VCPU_PTRAUTH_GENERIC is requested?  By these rules, we have a
> >contradiction: userspace both must request and must not request
> >KVM_ARM_VCPU_PTRAUTH_ADDRESS.
> >
> >We could qualify as follows:
> >
> >	Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
> >	Must be requested if KVM_CAP_ARM_PTRAUTH_ADDRESS is present and
> >	KVM_ARM_VCPU_PTRAUTH_GENERIC is also requested.
> ok agree. This makes it clear.

[*]

> >>  	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
> >>  	  for the CPU and supported only on arm64 architecture.
> >>  	  Must be requested if KVM_ARM_VCPU_PTRAUTH_ADDRESS is also requested.
> >>+	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
> >
> >Similarly.
> >
> >Or, we go back to having a single cap and a single feature, and add
> >more caps/features later on if we decide it's possible to support
> >address/generic auth separately later on.
> >
> >Otherwise, we end up with complex rules that can't be tested.  This is a
> >high price to pay for forwards compatibility: userspace's conformance to
> >the rules can't be fully tested, so there's a fair chance it won't work
> >properly anyway when hardware/KVM with just one auth type appears.
> >
> >[...]
> >
> >Thoughts?
> I agree that single cpufeature/capability is a simple solution to implement.
> The bifurcation of feature was done to reflect the different ID register
> split up.
> 
> But the h/w implementation provides a same EL2 exception trap for both the
> features and hence current implementation ties both of the features
> together. I guess in future if this is limitation goes away then one auth
> type is possible. Here I am not sure if the future h/w will retain this
> merged exception trap and add 2 new separate exception trap in addition to
> it.
> 
> I guess it will be probably simple split-up of this merged exception trap.
> In this case there won't be any ABI change required as per current
> implementation.

OK, I'm not opposed to keeping the ABI as-is, with the above
clarification [*] spelled out appropriately for both cases.

Alternatively, or in addition, we could say something like:

"If KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC are
both present, then both KVM_ARM_VCPU_PTRAUTH_ADDRESS and
KVM_ARM_VCPU_PTRAUTH_GENERIC must be requested or neither must be
requested."

Cheers
---Dave
