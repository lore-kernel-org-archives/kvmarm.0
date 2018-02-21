From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 01/40] KVM: arm/arm64: Avoid vcpu_load for other vcpu
 ioctls than KVM_RUN
Date: Wed, 21 Feb 2018 18:05:02 +0100
Message-ID: <20180221170502.5czjqewvmmprp4bm@kamzik.brq.redhat.com>
References: <20180215210332.8648-1-christoffer.dall@linaro.org>
 <20180215210332.8648-2-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC4EE402DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 11:58:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id flqmzCEqdKmR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Feb 2018 11:58:29 -0500 (EST)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A944D402D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Feb 2018 11:58:29 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20180215210332.8648-2-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Yury Norov <ynorov@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 10:02:53PM +0100, Christoffer Dall wrote:
> Calling vcpu_load() registers preempt notifiers for this vcpu and calls
> kvm_arch_vcpu_load().  The latter will soon be doing a lot of heavy
> lifting on arm/arm64 and will try to do things such as enabling the
> virtual timer and setting us up to handle interrupts from the timer
> hardware.
> 
> Loading state onto hardware registers and enabling hardware to signal
> interrupts can be problematic when we're not actually about to run the
> VCPU, because it makes it difficult to establish the right context when
> handling interrupts from the timer, and it makes the register access
> code difficult to reason about.
> 
> Luckily, now when we call vcpu_load in each ioctl implementation, we can
> simply remove the call from the non-KVM_RUN vcpu ioctls, and our
> kvm_arch_vcpu_load() is only used for loading vcpu content to the
> physical CPU when we're actually going to run the vcpu.
> 
> Reviewed-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
>  arch/arm64/kvm/guest.c | 3 ---
>  virt/kvm/arm/arm.c     | 9 ---------
>  2 files changed, 12 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
