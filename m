Return-Path: <SRS0=QomF=6E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0547FC3815B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 17:12:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92BF8208E4
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 17:12:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="QuJexw8m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92BF8208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 186BC4B125;
	Mon, 20 Apr 2020 13:12:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gv56OJj0MrRG; Mon, 20 Apr 2020 13:12:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D1BB04B11F;
	Mon, 20 Apr 2020 13:12:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0AEB4B11F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 13:12:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4dnkh6HNN7FB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 13:12:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DDDA4B118
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 13:12:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 53E89206D9;
 Mon, 20 Apr 2020 17:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587402741;
 bh=/ZHsHp1usqr/RF1hK0tLM3DblWJABJZwOeUQ1Q3+dcg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=QuJexw8mxsa6aipMVIAskHLERDvWC8yf7dQ5wFwoAQS0IDMAi1h0ee+ZqhAYOM+SC
 Z6c50HQJWMTaRJdVfgSIxO1Jt39h6i4hcPo+S2hNTrbb2zAaN87VtpHsjqV3M+rVN5
 svuEx2/DfNDpBJIppg/Nd/rIoCj9XD61yEc1et40=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jQZxz-004x1G-Mq; Mon, 20 Apr 2020 18:12:19 +0100
MIME-Version: 1.0
Date: Mon, 20 Apr 2020 18:12:19 +0100
From: Marc Zyngier <maz@kernel.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v2] kvm: Replace vcpu->swait with rcuwait
In-Reply-To: <20200420164132.tjzk5ebx35m66yce@linux-p48b>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <20200420164132.tjzk5ebx35m66yce@linux-p48b>
Message-ID: <418acdb5001a9ae836095b7187338085@misterjones.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2020-04-20 17:41, Davidlohr Bueso wrote:
> The use of any sort of waitqueue (simple or regular) for
> wait/waking vcpus has always been an overkill and semantically
> wrong. Because this is per-vcpu (which is blocked) there is
> only ever a single waiting vcpu, thus no need for any sort of
> queue.
> 
> As such, make use of the rcuwait primitive, with the following
> considerations:
> 
>  - rcuwait already provides the proper barriers that serialize
>  concurrent waiter and waker.
> 
>  - Task wakeup is done in rcu read critical region, with a
>  stable task pointer.
> 
>  - Because there is no concurrency among waiters, we need
>  not worry about rcuwait_wait_event() calls corrupting
>  the wait->task. As a consequence, this saves the locking
>  done in swait when modifying the queue. This also applies
>  to per-vcore wait for powerpc kvm-hv.
> 
> The x86-tscdeadline_latency test mentioned in 8577370fb0cb
> ("KVM: Use simple waitqueue for vcpu->wq") shows that, on avg,
> latency is reduced by around 15-20% with this change.
> 
> This patch also changes TASK_INTERRUPTIBLE for TASK_IDLE, as
> kvm is (ab)using the former such that idle vcpus do no contribute
> to the loadavg. Let use the correct semantics for this.
> 
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-mips@vger.kernel.org
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
> v2: Added missing semicolon in mips change.
> 
> The rest of the patches in this series continues to apply on tip,
> as such I am only sending a v2 for this particular patch.
> 
> arch/mips/kvm/mips.c                  |  6 ++----
> arch/powerpc/include/asm/kvm_book3s.h |  2 +-
> arch/powerpc/include/asm/kvm_host.h   |  2 +-
> arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++--------------
> arch/powerpc/kvm/powerpc.c            |  2 +-
> arch/x86/kvm/lapic.c                  |  2 +-
> include/linux/kvm_host.h              | 10 +++++-----
> virt/kvm/arm/arch_timer.c             |  2 +-
> virt/kvm/arm/arm.c                    |  9 +++++----
> virt/kvm/async_pf.c                   |  3 +--
> virt/kvm/kvm_main.c                   | 31 
> +++++++++++--------------------
> 11 files changed, 37 insertions(+), 54 deletions(-)

[...]

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70f03ce0e5c1..887efb39fb1a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -343,7 +343,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu,
> struct kvm *kvm, unsigned id)
> 	vcpu->kvm = kvm;
> 	vcpu->vcpu_id = id;
> 	vcpu->pid = NULL;
> -	init_swait_queue_head(&vcpu->wq);
> +	rcuwait_init(&vcpu->wait);
> 	kvm_async_pf_vcpu_init(vcpu);
> 
> 	vcpu->pre_pcpu = -1;
> @@ -2465,9 +2465,8 @@ static int kvm_vcpu_check_block(struct kvm_vcpu 
> *vcpu)
> void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> {
> 	ktime_t start, cur;
> -	DECLARE_SWAITQUEUE(wait);
> -	bool waited = false;
> 	u64 block_ns;
> +	int block_check = -EINTR;
> 
> 	kvm_arch_vcpu_blocking(vcpu);
> 
> @@ -2491,17 +2490,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> 		} while (single_task_running() && ktime_before(cur, stop));
> 	}
> 
> -	for (;;) {
> -		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> -
> -		if (kvm_vcpu_check_block(vcpu) < 0)
> -			break;
> -
> -		waited = true;
> -		schedule();
> -	}
> -
> -	finish_swait(&vcpu->wq, &wait);
> +	rcuwait_wait_event(&vcpu->wait,
> +			   (block_check = kvm_vcpu_check_block(vcpu)) < 0,
> +			   TASK_IDLE);
> 	cur = ktime_get();
> out:
> 	kvm_arch_vcpu_unblocking(vcpu);
> @@ -2525,18 +2516,17 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> 		}
> 	}
> 
> -	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
> +	trace_kvm_vcpu_wakeup(block_ns, !block_check, 
> vcpu_valid_wakeup(vcpu));

This looks like a change in the semantics of the tracepoint. Before this
change, 'waited' would have been true if the vcpu waited at all. Here, 
you'd
have false if it has been interrupted by a signal, even if the vcpu has 
waited
for a period of time.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
