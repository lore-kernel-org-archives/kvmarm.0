Return-Path: <SRS0=c4fT=6H=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600B1C2BA19
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 08:41:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0F162084D
	for <kvmarm@archiver.kernel.org>; Thu, 23 Apr 2020 08:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZ5vrG/2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0F162084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 945D74B14D;
	Thu, 23 Apr 2020 04:41:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5GiVMMkCFjjo; Thu, 23 Apr 2020 04:41:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3F34B14F;
	Thu, 23 Apr 2020 04:41:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D8B4B14A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 04:41:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x1nGMaw8RkgI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Apr 2020 04:41:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2764B149
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 04:41:44 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B47CC20781;
 Thu, 23 Apr 2020 08:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587631303;
 bh=t8blW7Cv+bprujnr81ng6J5oRSYCzqyxB2PvmFe4IEE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=HZ5vrG/25ZmFh9rjigGIkPmroBlnVM/6xRqAYqanwgRawoBvTjqELTZ/B4NHmKLYV
 Djmy82a5+Ikl4ons0llnji98I7Ubcw1KqS1ziz2xVFmDcBhEeG1h0o5ZqOK8Lq9KWz
 DarluvpF7uoH2HrkkZpZtMY+LwZcap2ApXPSU+nM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRXQT-005ikb-Tu; Thu, 23 Apr 2020 09:41:42 +0100
Date: Thu, 23 Apr 2020 09:41:40 +0100
From: Marc Zyngier <maz@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200423094140.69909bbb@why>
In-Reply-To: <20200422040739.18601-5-dave@stgolabs.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
 <20200422040739.18601-5-dave@stgolabs.net>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: dave@stgolabs.net, tglx@linutronix.de, pbonzini@redhat.com,
 kvm@vger.kernel.org, dbueso@suse.de, peterz@infradead.org,
 torvalds@linux-foundation.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 paulus@ozlabs.org, joel@joelfernandes.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
 will@kernel.org, bigeasy@linutronix.de, linux-kernel@vger.kernel.org,
 rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org,
 pbonzini@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, 21 Apr 2020 21:07:38 -0700
Davidlohr Bueso <dave@stgolabs.net> wrote:

> The use of any sort of waitqueue (simple or regular) for
> wait/waking vcpus has always been an overkill and semantically
> wrong. Because this is per-vcpu (which is blocked) there is
> only ever a single waiting vcpu, thus no need for any sort of
> queue.
> 
> As such, make use of the rcuwait primitive, with the following
> considerations:
> 
>   - rcuwait already provides the proper barriers that serialize
>   concurrent waiter and waker.
> 
>   - Task wakeup is done in rcu read critical region, with a
>   stable task pointer.
> 
>   - Because there is no concurrency among waiters, we need
>   not worry about rcuwait_wait_event() calls corrupting
>   the wait->task. As a consequence, this saves the locking
>   done in swait when modifying the queue. This also applies
>   to per-vcore wait for powerpc kvm-hv.
> 
> The x86 tscdeadline_latency test mentioned in 8577370fb0cb
> ("KVM: Use simple waitqueue for vcpu->wq") shows that, on avg,
> latency is reduced by around 15-20% with this change.
> 
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-mips@vger.kernel.org
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  arch/mips/kvm/mips.c                  |  6 ++----
>  arch/powerpc/include/asm/kvm_book3s.h |  2 +-
>  arch/powerpc/include/asm/kvm_host.h   |  2 +-
>  arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++--------------
>  arch/powerpc/kvm/powerpc.c            |  2 +-
>  arch/x86/kvm/lapic.c                  |  2 +-
>  include/linux/kvm_host.h              | 10 +++++-----
>  virt/kvm/arm/arch_timer.c             |  2 +-
>  virt/kvm/arm/arm.c                    |  9 +++++----
>  virt/kvm/async_pf.c                   |  3 +--
>  virt/kvm/kvm_main.c                   | 19 +++++++++----------
>  11 files changed, 35 insertions(+), 44 deletions(-)

[...]

I should have tested it *before* acking it, really.

> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 93bd59b46848..b2805105bbe5 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -593,7 +593,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
>  	if (map.emul_ptimer)
>  		soft_timer_cancel(&map.emul_ptimer->hrtimer);
>  
> -	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
> +	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)

This doesn't compile (wrong function name, and rcu_dereference takes a
variable). But whatever it would do if we fixed it looks dodgy. it isn't
the rcuwait structure that you want to dereference, but rcuwait->task
(we are checking whether we are called because we are blocking or being
preempted).

>  		kvm_timer_blocking(vcpu);
>  
>  	/*
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77..f94a10bb1251 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -579,16 +579,17 @@ void kvm_arm_resume_guest(struct kvm *kvm)
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		vcpu->arch.pause = false;
> -		swake_up_one(kvm_arch_vcpu_wq(vcpu));
> +		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
>  	}
>  }
>  
>  static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>  {
> -	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
> +	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
>  
> -	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
> -				       (!vcpu->arch.pause)));
> +	rcuwait_wait_event(*wait,
> +			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
> +			   TASK_INTERRUPTIBLE);

As noticed by the kbuild robot, this doesn't compile either.

I fixed it as follow, and it survived a very basic test run in a model
(more testing later).

Thanks,

	M.

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index b2805105bbe56..2dbd14dcae9fb 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -569,6 +569,7 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct timer_map map;
 
@@ -593,7 +594,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
-	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)
+	if (rcu_dereference(wait->task))
 		kvm_timer_blocking(vcpu);
 
 	/*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index f94a10bb1251b..479f36d02418d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -587,7 +587,7 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
-	rcuwait_wait_event(*wait,
+	rcuwait_wait_event(wait,
 			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
 			   TASK_INTERRUPTIBLE);
 

-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
