From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v6 07/15] KVM: arm64: Optimise FPSIMD handling to reduce
 guest/host thrashing
Date: Wed, 9 May 2018 11:00:07 +0100
Message-ID: <20180509100007.GO7753@e103592.cambridge.arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
 <1525797900-5548-8-git-send-email-Dave.Martin@arm.com>
 <cd45aff8-66dd-b6bc-ada0-189b45e09d17@arm.com>
 <20180509091701.GM7753@e103592.cambridge.arm.com>
 <5010b106-4aa3-fb19-bbac-55cf261f9d30@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <5010b106-4aa3-fb19-bbac-55cf261f9d30@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 09, 2018 at 10:46:11AM +0100, Marc Zyngier wrote:
> On 09/05/18 10:17, Dave Martin wrote:
> > On Wed, May 09, 2018 at 09:24:36AM +0100, Marc Zyngier wrote:
> >> On 08/05/18 17:44, Dave Martin wrote:
> >>> This patch refactors KVM to align the host and guest FPSIMD
> >>> save/restore logic with each other for arm64.  This reduces the
> > 
> > [...]
> > 
> >>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> >>> index 9699c13..6429eb6 100644
> >>> --- a/arch/arm64/include/asm/kvm_asm.h
> >>> +++ b/arch/arm64/include/asm/kvm_asm.h
> >>> @@ -33,6 +33,8 @@
> >>>  /* vcpu_arch flags field values: */
> >>>  #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
> >>>  #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
> >>
> >> At some point, we could remove KVM_ARM64_DEBUG_DIRTY_SHIFT as it is not
> >> used anymore (since 1ea66d27e7b0). Do not respin on this account though.
> > 
> > I wondered about this...  I presume this was used from assembly once
> > upon a time.
> > 
> > Since I need to repost for something else anyway, shall I delete that
> > and move the defines to kvm_host.h?  There's no longer an obvious reason
> > for them to be in a different header.
> 
> Yes, please.

OK, will do.

> >>> diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c

[...]

> >>> +void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +	BUG_ON(system_supports_sve());
> >>> +	BUG_ON(!current->mm);
> >>> +
> >>> +	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED | KVM_ARM64_HOST_SVE_IN_USE);
> >>> +	if (test_thread_flag(TIF_SVE))
> >>> +		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
> >>> +
> >>> +	vcpu->arch.host_fpsimd_state =
> >>> +		kern_hyp_va(&current->thread.uw.fpsimd_state);
> >>
> >> ... what is the purpose of this assignment? I don't think it is harmful
> >> in any way, but I'm just wondering if I'm missing in the actual flow.
> > 
> > The pointer will be NULLed by __hyp_switch_fpsimd() when loading the
> > guest state in, to indicate that there is no longer any host state to
> > save.  Perhaps it would have been clearer to have a separate flag to
> > represent this change of state.
> > 
> > As things stand I think you're right: the assignments are redundant.  
> > We certainly need the pointer to reflect the current task, which is
> > the motivation for doing it here -- but in fact we need to do it
> > more often, at every vcpu_load().
> > 
> > I think the most appropriate thing is to delete the assignment from
> > _map_fp().
> > 
> > The alternative would be to add a flag for the "no host state to save"
> > case, and fpsimd_host_state only in the pid_change hook.
> 
> I think I'd prefer the latter. It makes the whole pointer stuff a lot
> easier to understand (the linkages are basically static), and using
> flags is consistent with the way the rest of the kernel works. I'm not
> sure whether we need to add a new flag or simply rely on the existing
> thread flag, but that for you to decide.

OK, agreed.  It should definitely help clarity.

[...]

> > Happy to keep your Reviewed-by with the discussed changes?
> Yes, no problem. I'll eyeball the changes and let you know if I spot
> anything.

OK, thanks.

I'll note the changes under the tearoff.

Cheers
---Dave
