Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8439C3815B
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 730E720775
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 09:23:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 730E720775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA7A34B231;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7l+JDoleAwJq; Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0103A4B209;
	Wed, 15 Apr 2020 05:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5CBA4B211
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:15:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iyfsizjdP8q3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 17:15:00 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECCC64B107
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 17:14:59 -0400 (EDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
 by mx2.suse.de (Postfix) with ESMTP id 45390ABBE;
 Tue, 14 Apr 2020 21:14:57 +0000 (UTC)
Date: Tue, 14 Apr 2020 14:12:43 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/4] kvm: Replace vcpu->swait with rcuwait
Message-ID: <20200414211243.7vehybdrvbzmbduu@linux-p48b>
References: <20200324044453.15733-1-dave@stgolabs.net>
 <20200324044453.15733-4-dave@stgolabs.net>
 <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a6b23828-aa50-bea0-1d2d-03e2871239d4@redhat.com>
User-Agent: NeoMutt/20180716
X-Mailman-Approved-At: Wed, 15 Apr 2020 05:23:47 -0400
Cc: kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>, peterz@infradead.org,
 torvalds@linux-foundation.org, bigeasy@linutronix.de,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, joel@joelfernandes.org, tglx@linutronix.de,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Wed, 25 Mar 2020, Paolo Bonzini wrote:

>On 24/03/20 05:44, Davidlohr Bueso wrote:
>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>> index 71244bf87c3a..e049fcb3dffb 100644
>> --- a/arch/mips/kvm/mips.c
>> +++ b/arch/mips/kvm/mips.c
>> @@ -290,8 +290,7 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
>>	kvm_mips_callbacks->queue_timer_int(vcpu);
>>
>>	vcpu->arch.wait = 0;
>> -	if (swq_has_sleeper(&vcpu->wq))
>> -		swake_up_one(&vcpu->wq);
>> +	rcuwait_wake_up(&vcpu->wait)
>
>This is missing a semicolon.  (KVM MIPS is known not to compile and will
>be changed to "depends on BROKEN" in 5.7).

Do you want me to send another version with this fix or do you prefer
fixing it when/if picked up?

Thanks,
Davidlohr
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
