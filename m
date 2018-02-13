From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 14/41] KVM: arm64: Introduce VHE-specific kvm_vcpu_run
Date: Tue, 13 Feb 2018 09:52:45 +0100
Message-ID: <20180213085245.GD23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-15-christoffer.dall@linaro.org>
 <ddfccffb-b8ee-7601-1c19-e3a01bf9b75f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ddfccffb-b8ee-7601-1c19-e3a01bf9b75f@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Grall <julien.grall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 05:34:05PM +0000, Julien Grall wrote:
> Hi Christoffer,
> 
> On 01/12/2018 12:07 PM, Christoffer Dall wrote:
> >So far this is just a copy of the legacy non-VHE switch function, but we
> >will start reworking these functions in separate directions to work on
> >VHE and non-VHE in the most optimal way in later patches.
> >
> >Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >  arch/arm/include/asm/kvm_asm.h   |  5 +++-
> >  arch/arm/kvm/hyp/switch.c        |  2 +-
> >  arch/arm64/include/asm/kvm_asm.h |  4 ++-
> >  arch/arm64/kvm/hyp/switch.c      | 58 +++++++++++++++++++++++++++++++++++++++-
> >  virt/kvm/arm/arm.c               |  5 +++-
> >  5 files changed, 69 insertions(+), 5 deletions(-)
> >
> >diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> >index 36dd2962a42d..4ac717276543 100644
> >--- a/arch/arm/include/asm/kvm_asm.h
> >+++ b/arch/arm/include/asm/kvm_asm.h
> >@@ -70,7 +70,10 @@ extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
> >  extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
> >-extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
> >+/* no VHE on 32-bit :( */
> >+static inline int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu) { return 0; }
> 
> Should we return an error or add a BUG() to catch potential use of this
> function?
> 

That definitely can't hurt.

Thanks,
-Christoffer
