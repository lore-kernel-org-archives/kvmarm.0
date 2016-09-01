From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: Remove deprecated create_singlethread_workqueue
Date: Thu, 1 Sep 2016 11:59:47 +0200
Message-ID: <20160901095947.GA10162@cbox>
References: <20160830175950.GA5958@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD9E40FA2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 05:49:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Raj-LPrzfsbV for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Sep 2016 05:49:16 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4509840BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Sep 2016 05:49:16 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id 1so85169518wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Sep 2016 02:57:26 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160830175950.GA5958@Karyakshetra>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 11:29:51PM +0530, Bhaktipriya Shridhar wrote:
> The workqueue "irqfd_cleanup_wq" queues a single work item
> &irqfd->shutdown and hence doesn't require ordering. It is a host-wide
> workqueue for issuing deferred shutdown requests aggregated from all
> vm* instances. It is not being used on a memory reclaim path.
> Hence, it has been converted to use system_wq.
> The work item has been flushed in kvm_irqfd_release().
> 
> The workqueue "wqueue" queues a single work item &timer->expired
> and hence doesn't require ordering. Also, it is not being used on
> a memory reclaim path. Hence, it has been converted to use system_wq.
> 
> System workqueues have been able to handle high level of concurrency
> for a long time now and hence it's not required to have a singlethreaded
> workqueue just to gain concurrency. Unlike a dedicated per-cpu workqueue
> created with create_singlethread_workqueue(), system_wq allows multiple
> work items to overlap executions even on the same CPU; however, a
> per-cpu workqueue doesn't have any CPU locality or global ordering
> guarantee unless the target CPU is explicitly specified and thus the
> increase of local concurrency shouldn't make any difference.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
> ---
>  virt/kvm/arm/arch_timer.c | 11 ++---------
>  virt/kvm/eventfd.c        | 22 +++-------------------
>  virt/kvm/kvm_main.c       |  6 ------
>  3 files changed, 5 insertions(+), 34 deletions(-)
> 
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index e2d5b6f..56e0c15 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -31,7 +31,6 @@
>  #include "trace.h"
> 
>  static struct timecounter *timecounter;
> -static struct workqueue_struct *wqueue;
>  static unsigned int host_vtimer_irq;
> 
>  void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
> @@ -140,7 +139,7 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>  		return HRTIMER_RESTART;
>  	}
> 
> -	queue_work(wqueue, &timer->expired);
> +	schedule_work(&timer->expired);
>  	return HRTIMER_NORESTART;
>  }
> 
> @@ -455,12 +454,6 @@ int kvm_timer_hyp_init(void)
>  		goto out_free;
>  	}
> 
> -	wqueue = create_singlethread_workqueue("kvm_arch_timer");
> -	if (!wqueue) {
> -		err = -ENOMEM;
> -		goto out_free;
> -	}
> -
>  	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
>  	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
> 
> @@ -522,7 +515,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>  	 * VCPUs have the enabled variable set, before entering the guest, if
>  	 * the arch timers are enabled.
>  	 */
> -	if (timecounter && wqueue)
> +	if (timecounter)
>  		timer->enabled = 1;
> 
>  	return 0;

This was discussed when this stuff was originally added, and I think the
argument then was that it improved tracing somehow, to be able to tell
exactly which piece of work was being done.

That being said, I don't have any objections against this patch, so
unless others object, for the ARM part:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks,
-Christoffer

> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index e469b60..f397e9b 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -42,7 +42,6 @@
> 
>  #ifdef CONFIG_HAVE_KVM_IRQFD
> 
> -static struct workqueue_struct *irqfd_cleanup_wq;
> 
>  static void
>  irqfd_inject(struct work_struct *work)
> @@ -168,7 +167,7 @@ irqfd_deactivate(struct kvm_kernel_irqfd *irqfd)
> 
>  	list_del_init(&irqfd->list);
> 
> -	queue_work(irqfd_cleanup_wq, &irqfd->shutdown);
> +	schedule_work(&irqfd->shutdown);
>  }
> 
>  int __attribute__((weak)) kvm_arch_set_irq_inatomic(
> @@ -555,7 +554,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  	 * so that we guarantee there will not be any more interrupts on this
>  	 * gsi once this deassign function returns.
>  	 */
> -	flush_workqueue(irqfd_cleanup_wq);
> +	flush_work(&irqfd->shutdown);
> 
>  	return 0;
>  }
> @@ -592,7 +591,7 @@ kvm_irqfd_release(struct kvm *kvm)
>  	 * Block until we know all outstanding shutdown jobs have completed
>  	 * since we do not take a kvm* reference.
>  	 */
> -	flush_workqueue(irqfd_cleanup_wq);
> +	flush_work(&irqfd->shutdown);
> 
>  }
> 
> @@ -622,23 +621,8 @@ void kvm_irq_routing_update(struct kvm *kvm)
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  }
> 
> -/*
> - * create a host-wide workqueue for issuing deferred shutdown requests
> - * aggregated from all vm* instances. We need our own isolated single-thread
> - * queue to prevent deadlock against flushing the normal work-queue.
> - */
> -int kvm_irqfd_init(void)
> -{
> -	irqfd_cleanup_wq = create_singlethread_workqueue("kvm-irqfd-cleanup");
> -	if (!irqfd_cleanup_wq)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -
>  void kvm_irqfd_exit(void)
>  {
> -	destroy_workqueue(irqfd_cleanup_wq);
>  }
>  #endif
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 02e98f3..93506d2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3719,12 +3719,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	 * kvm_arch_init makes sure there's at most one caller
>  	 * for architectures that support multiple implementations,
>  	 * like intel and amd on x86.
> -	 * kvm_arch_init must be called before kvm_irqfd_init to avoid creating
> -	 * conflicts in case kvm is already setup for another implementation.
>  	 */
> -	r = kvm_irqfd_init();
> -	if (r)
> -		goto out_irqfd;
> 
>  	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
>  		r = -ENOMEM;
> @@ -3805,7 +3800,6 @@ out_free_0a:
>  	free_cpumask_var(cpus_hardware_enabled);
>  out_free_0:
>  	kvm_irqfd_exit();
> -out_irqfd:
>  	kvm_arch_exit();
>  out_fail:
>  	return r;
> --
> 2.1.4
> 
