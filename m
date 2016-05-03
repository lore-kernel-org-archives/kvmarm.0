From: Tom Hanson <thomas.hanson@linaro.org>
Subject: Re: [PATCH v2 14/54] KVM: arm/arm64: vgic-new: Implement virtual IRQ
 injection
Date: Tue, 3 May 2016 17:46:12 -0600
Message-ID: <57293844.1060802@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-15-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A8E49B2F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 19:43:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GslKcW37msU1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2016 19:43:43 -0400 (EDT)
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
 [209.85.220.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A151549B2E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2016 19:43:43 -0400 (EDT)
Received: by mail-pa0-f53.google.com with SMTP id bt5so16254441pac.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2016 16:46:20 -0700 (PDT)
In-Reply-To: <1461861973-26464-15-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/28/2016 10:45 AM, Andre Przywara wrote:
...
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index fb45537..92b78a0 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -19,8 +19,31 @@
...  
> +/*
> + * Locking order is always:
> + *   vgic_cpu->ap_list_lock
> + *     vgic_irq->irq_lock
> + *
> + * (that is, always take the ap_list_lock before the struct vgic_irq lock).
> + *
> + * When taking more than one ap_list_lock at the same time, always take the
> + * lowest numbered VCPU's ap_list_lock first, so:
> + *   vcpuX->vcpu_id < vcpuY->vcpu_id:
> + *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
> + *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
> + */

The code would be safer and easier to maintain in the long run if there were functions provided which implement these 2 rules.  Something along the line of:

   void vgic_lock_aplist_irq(spinlock_t ap_list_lock, spinlock_t irq_lock){
       spin_lock(ap_list_lock);
       spin_lock(irq_lock);
   }

and  (borrowing from patch 16/54):

   void vgic_lock_cpu_aplist_pair(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2){
       struct kvm_vcpu *vcpuA, *vcpuB;
       /*
        * Ensure locking order by always locking the smallest
        * ID first.
        */
      if (vcpu1->vcpu_id < vcpu2->vcpu_id) {
           vcpuA = vcpu1;
           vcpuB = vcpu2;
       } else {
           vcpuA = vcpu2;
           vcpuB = vcpu1;
       }

       spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
       spin_lock(&vcpuB->arch.vgic_cpu.ap_list_lock);
   }

With, of course the matching unlock functions.

Then, as long as new code calls the correct function, the order is always correct.  Easy to write, easy to review.  And beats the heck out of chasing a deadlock at some point in the future.
