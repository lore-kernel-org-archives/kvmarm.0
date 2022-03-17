Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4EB0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 08:52:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 321BF49F33;
	Thu, 17 Mar 2022 04:52:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 03owqfTvpYKf; Thu, 17 Mar 2022 04:52:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB75849ED7;
	Thu, 17 Mar 2022 04:52:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CEB949E1E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 04:52:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qvngDodOKYUt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 04:52:43 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D72B49E0E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 04:52:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC3D615E9;
 Thu, 17 Mar 2022 08:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C22C340EE;
 Thu, 17 Mar 2022 08:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1647507161;
 bh=3MOnGAbOL7YWzZCDMztCvhjS2KbSf1PeCFSM6JMUXls=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=iEPxF6MGs+uvzyw5A6CoxPTpHsWYPHTrNECLD5jcnd9UzfhFrvPYj4YYfalB0n5MM
 Bz1n5vTMVMKSuqUGE1KiK0FzUxi169Ks5Nl0ro8rtflzqrUCwUkRchc4FvnJaWyD0i
 0ccnd4ukGDArpUZlwFCRJzLyK2blpvY+lMjtHtRLePx0EvGYzTOUWc9laXdaR5QDP6
 3fgySvDkxE67sCdS8votp2PVjRVHaVfC0xdBPGzX0i8qAy6bsYWXAonuRz47C72mtB
 BB1Xyd38gSfgCZy07XDE/ZgXagsoIfT+5M0QhAp3Rtaq5yXjQKuVCBxo2luNeod9s6
 HJNIMyQ10LuhQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nUls6-00F7oq-II; Thu, 17 Mar 2022 08:52:38 +0000
MIME-Version: 1.0
Date: Thu, 17 Mar 2022 08:52:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
In-Reply-To: <YjLY5y+KObV0AR9g@google.com>
References: <20220317045127.124602-1-ricarkol@google.com>
 <20220317045127.124602-3-ricarkol@google.com> <YjLY5y+KObV0AR9g@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oupton@google.com, ricarkol@google.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com, pbonzini@redhat.com,
 alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
 rananta@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On 2022-03-17 06:44, Oliver Upton wrote:
> On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
>> Add an arch_timer edge-cases selftest. For now, just add some basic
>> sanity checks, and some stress conditions (like waiting for the timers
>> while re-scheduling the vcpu). The next commit will add the actual 
>> edge
>> case tests.
>> 
>> This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
>> interrupts for suspended vCPU".
>> 
>> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>> Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
>> Signed-off-by: Ricardo Koller <ricarkol@google.com>

[...]

>> +		asm volatile("wfi\n"
>> +			     "msr daifclr, #2\n"
>> +			     /* handle IRQ */
> 
> I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
> having a hard time finding the same language in the H.a revision of the
> manual :-/

D1.3.6 probably is what you are looking for.

"Context synchronization event" is the key phrase to remember
when grepping through the ARM ARM. And yes, the new layout is
a nightmare (as if we really needed an additional 2800 pages...).

> 
>> +			     "msr daifset, #2\n"
>> +			     : : : "memory");
>> +	}
>> +}

[...]

>> +	/* tval should keep down-counting from 0 to -1. */
>> +	SET_COUNTER(DEF_CNT, test_args.timer);
>> +	timer_set_tval(test_args.timer, 0);
>> +	if (use_sched)
>> +		USERSPACE_SCHEDULE();
>> +	/* We just need 1 cycle to pass. */
>> +	isb();
> 
> Somewhat paranoid, but:
> 
> If the CPU retires the ISB much more quickly than the counter ticks, 
> its
> possible that you could observe an invalid TVAL even with a valid
> implementation.

Worse than that:

- ISB doesn't need to take any time at all. It just needs to ensure
   that everything is synchronised. Depending on how the CPU is built,
   this can come for free.

- There is no relation between the counter ticks and CPU cycles.

> What if you spin waiting for CNT to increment before the assertion? 
> Then
> you for sureknow (and can tell by reading the test) that the
> implementation is broken.

That's basically the only way to implement this. You can't rely
on any other event.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
