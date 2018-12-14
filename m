From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH REPOST] KVM: arm64: Treat FPEXC32_EL2 as a regular guest
 system register
Date: Fri, 14 Dec 2018 19:54:47 +0000
Message-ID: <20181214195447.GI3505@e103592.cambridge.arm.com>
References: <1544554096-23451-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 745344A2BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Dec 2018 14:54:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VB2QSN3pgGWs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Dec 2018 14:54:52 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3314A1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Dec 2018 14:54:51 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1544554096-23451-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 11, 2018 at 06:48:16PM +0000, Dave Martin wrote:
> Currently FPEXC32_EL2 is handled specially when context-switching.
> 
> However, FPEXC has no architectural effect when running in AArch64.
> The only case where an arm64 host may execute in AArch32 is when
> running compat user code at EL0: the architecture explicitly
> documents FPEXC as having no effect in this case either when the
> kernel (EL2 in the VHE case; otherwise EL1) is AArch64.
> 
> So, we can just handle FPEXC32_EL2 (which is the AArch64 alias for
> this register) as a regular AArch32-only system register and switch
> it without any special handling or synchronisation.
> 
> This allows some gnarly special-case code to be eliminated from
> hyp.  The extra isb() in __activate_traps_fpsimd32() is dropped
> too: for the reasons explained above arm64 never required this
> anyway.
> 
> Note that the comment in the deleted __activate_traps_fpsimd32()
> function about the need to inhibit traps to EL1 is only meaningful
> if the guest's value for FPEXC is not restored (thus potentially
> causing an unexpected trap to EL1 in the guest unless we're careful
> to set the EN bit).  This arises from the treatment of FPEXC32_EL2
> as if it were part of the the FPSIMD state to be switched lazily,
> whereas it is really more natural to consider it as part of the EL1
> system register state to be switched eagerly at the appropriate
> times.
> 
> In fact, we explicitly don't care about seeing any trap until the
> guest accesses the FPSIMD registers for real, provided that the
> guest sees the behaviour it expects.  So ensuring that the guest's
> view of FPEXC is alawys up to date (as implemented by this patch)
> should be sufficient.  Since we always had to write FPEXC32_EL2
> anyway (in order to work around the possibility of not restoring it
> properly for the guest) this should not add significant cost.  In
> any case, this patch moves any cost off the hyp switch critical
> path, to vcpu_load/put().
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Alexander Graf <agraf@suse.de>
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> 
> ---
> 
> **Build-tested only**

Dang, it turns out that writing FPEXC32_EL2 from EL2 triggers a trap to
EL2 if FPSIMD traps to EL2 are enabled via CPTR_EL2.

This seems illogical, but I've seen it trigger a Hyp panic on Juno
(r0) (non-VHE, but looking at the Arm ARM it appears that something
equivalent happens for VHE too).

So this needs a rethink :|

I think we can still defer the save until vcpu_put(), and save a
sysreg write by not restoring it lazily (since we have to write it once
anyway to set EN bit if we want to trap FPSIMD to EL2).

Anyway, definitely not a priority for v4.21.

[...]

Cheers
---Dave
