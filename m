From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] KVM: Remove deprecated create_singlethread_workqueue
Date: Wed, 31 Aug 2016 10:24:56 -0400
Message-ID: <20160831142456.GL12660@htj.duckdns.org>
References: <20160830175950.GA5958@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160830175950.GA5958@Karyakshetra>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
