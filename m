From: Dave P Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 24 Apr 2019 14:30:43 +0000
Message-ID: <20190424143041.GF17864@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <20190424133903.GU3567@e103592.cambridge.arm.com>
 <4e475e1f-80f2-372a-2c16-a03ac947525a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF72C4A480
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0rzAJNvRRx5a for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 10:30:46 -0400 (EDT)
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr10079.outbound.protection.outlook.com [40.107.1.79])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D29B4A47A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 10:30:46 -0400 (EDT)
In-Reply-To: <4e475e1f-80f2-372a-2c16-a03ac947525a@arm.com>
Content-Language: en-US
Content-ID: <D2A58B168B45CC428E0A9CEAA7BD1BB8@eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kristina Martsenko <Kristina.Martsenko@arm.com>, Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>, Amit Kachhap <Amit.Kachhap@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 03:29:26PM +0100, Marc Zyngier wrote:
> On 24/04/2019 14:39, Dave Martin wrote:
> > On Tue, Apr 23, 2019 at 10:12:35AM +0530, Amit Daniel Kachhap wrote:
> >> From: Mark Rutland <mark.rutland@arm.com>
> >>
> >> When pointer authentication is supported, a guest may wish to use it.
> >> This patch adds the necessary KVM infrastructure for this to work, with
> >> a semi-lazy context switch of the pointer auth state.
> >>
> >> Pointer authentication feature is only enabled when VHE is built
> >> in the kernel and present in the CPU implementation so only VHE code
> >> paths are modified.
> >>
> >> When we schedule a vcpu, we disable guest usage of pointer
> >> authentication instructions and accesses to the keys. While these are
> >> disabled, we avoid context-switching the keys. When we trap the guest
> >> trying to use pointer authentication functionality, we change to eagerly
> >> context-switching the keys, and enable the feature. The next time the
> >> vcpu is scheduled out/in, we start again. However the host key save is
> >> optimized and implemented inside ptrauth instruction/register access
> >> trap.
> >>
> >> Pointer authentication consists of address authentication and generic
> >> authentication, and CPUs in a system might have varied support for
> >> either. Where support for either feature is not uniform, it is hidden
> >> from guests via ID register emulation, as a result of the cpufeature
> >> framework in the host.
> >>
> >> Unfortunately, address authentication and generic authentication cannot
> >> be trapped separately, as the architecture provides a single EL2 trap
> >> covering both. If we wish to expose one without the other, we cannot
> >> prevent a (badly-written) guest from intermittently using a feature
> >> which is not uniformly supported (when scheduled on a physical CPU which
> >> supports the relevant feature). Hence, this patch expects both type of
> >> authentication to be present in a cpu.
> >>
> >> This switch of key is done from guest enter/exit assembly as preparation
> >> for the upcoming in-kernel pointer authentication support. Hence, these
> >> key switching routines are not implemented in C code as they may cause
> >> pointer authentication key signing error in some situations.
> >>
> >> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> >> [Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
> >> , save host key in ptrauth exception trap]
> >> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@arm.com>
> >> Cc: kvmarm@lists.cs.columbia.edu
> >> ---
> >> Changes since v9:
> >>
> >> * Removed hardcoding of enum values[Mark Zyngier].
> >> * Changed kvm_ptrauth_asm.h to kvm_ptrauth.h[Mark Zyngier].
> >> * Removed macro __ptrauth_save_state and applied inline [Marc Zyngier].
> >> * Moved kvm_arm_vcpu_ptrauth_setup_lazy, kvm_arm_vcpu_ptrauth_enable and
> >>   kvm_arm_vcpu_ptrauth_disable from *.c to kvm_emulate.h file [Marc Zyngier].
> >> * Added/Modified comments at few places [Marc Zyngier].

[...]

> >  if (id == SYS_ID_AA64PFR0_EL1 && !vcpu_has_sve(vcpu)) {
> >  val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> > -} else if (id == SYS_ID_AA64ISAR1_EL1) {
> > -const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > - (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > - (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > - (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> > -if (!vcpu_has_ptrauth(vcpu)) {
> > -if (val & ptrauth_mask)
> > -kvm_debug("ptrauth unsupported for guests, suppressing\n");
> > -val &= ~ptrauth_mask;
> > -}
> > +} else if (id == SYS_ID_AA64ISAR1_EL1 && !vcpu_has_ptrauth(vcpu)) {
> > +val &= ~((0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> > + (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> > + (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> > + (0xfUL << ID_AA64ISAR1_GPI_SHIFT));
> >  }
> >
> >  return val;
> >
>
> Since the series isn't in -next yet, I've squashed the above with the
> other nits I had in -queue.

Okey doke.

Thanks
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
