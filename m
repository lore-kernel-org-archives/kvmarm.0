Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3AFC55186
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 10:15:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 353CE2071E
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 10:15:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 353CE2071E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 905174B14D;
	Wed, 22 Apr 2020 06:15:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B3GaoklQ-uyi; Wed, 22 Apr 2020 06:15:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93ECC4B14F;
	Wed, 22 Apr 2020 06:15:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F694B124
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 06:15:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MksC-tBU0qDk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 06:15:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52FC64B0BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 06:15:06 -0400 (EDT)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@misterjones.org>)
 id 1jRCOi-005RP3-VM; Wed, 22 Apr 2020 11:14:29 +0100
MIME-Version: 1.0
Date: Wed, 22 Apr 2020 11:14:28 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
In-Reply-To: <20200422040739.18601-5-dave@stgolabs.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
 <20200422040739.18601-5-dave@stgolabs.net>
Message-ID: <a6e848e46f3c865f6b9d2771c8aad37a@misterjones.org>
X-Sender: maz@misterjones.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dave@stgolabs.net, tglx@linutronix.de, pbonzini@redhat.com,
 kvm@vger.kernel.org, dbueso@suse.de, peterz@infradead.org,
 torvalds@linux-foundation.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 paulus@ozlabs.org, joel@joelfernandes.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@misterjones.org
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

On 2020-04-22 05:07, Davidlohr Bueso wrote:
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

Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks,

         M.
-- 
Who you jivin' with that Cosmik Debris?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
