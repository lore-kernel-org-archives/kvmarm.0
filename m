Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC542C43334
	for <kvmarm@archiver.kernel.org>; Sun, 17 Jul 2022 01:12:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4913B4C66C;
	Sat, 16 Jul 2022 21:12:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EvfUuW8Ig8hh; Sat, 16 Jul 2022 21:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D352E4C6CA;
	Sat, 16 Jul 2022 21:12:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39D664C6C4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 21:12:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OWOP2GBIjnPE for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Jul 2022 21:12:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E96584C66C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 21:12:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658020327;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Yvkpx482WEOx0k7AE4fGPI+kXMmx+3JjLrAm+UsDHkI=;
 b=YxKIY4ULoeufN+OkFBFI9G4C+YwIVikNlwr2BeapEuCO3+usA682oRZG+R/dsE6vZt3p99
 9aWa9fx65z+4fLAXmPNHQHvXOrJCdYU5yaJDczhgfTNdS5D224iOR4EtWW5L3Duugf7qXl
 9w4hXqYtPobUcZg0QlWxHSfklVfJucw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-9s9Nyz0tNK2LeBZoTUn9Mw-1; Sat, 16 Jul 2022 21:12:03 -0400
X-MC-Unique: 9s9Nyz0tNK2LeBZoTUn9Mw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 521652932498;
 Sun, 17 Jul 2022 01:12:03 +0000 (UTC)
Received: from [10.64.54.37] (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F3C4A40E8B04;
 Sun, 17 Jul 2022 01:11:59 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: selftests: Fix target thread to be migrated in
 rseq_test
To: oliver.upton@linux.dev, kvmarm@lists.cs.columbia.edu
References: <20220716144537.3436743-1-gshan@redhat.com>
 <385aa28ad559874da8429c40a68570df@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <4bdaa1cd-39f4-97d7-ba33-ee5cdc7d609e@redhat.com>
Date: Sun, 17 Jul 2022 13:11:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <385aa28ad559874da8429c40a68570df@linux.dev>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, maz@kernel.org, pbonzini@redhat.com,
 shuah@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Oliver,

On 7/17/22 7:48 AM, oliver.upton@linux.dev wrote:
> 
> Thanks for cleaning this up.
> 

Thanks for your review.

> July 16, 2022 7:45 AM, "Gavin Shan" <gshan@redhat.com> wrote:
>> In rseq_test, there are two threads, which are thread group leader
>> and migration worker. The migration worker relies on sched_setaffinity()
>> to force migration on the thread group leader.
> 
> It may be clearer to describe it as a vCPU thread and a migration worker
> thread. The meat of this test is to catch a regression in KVM.
> 
>> Unfortunately, we have
> 
> s/we have/the test has the/
> 
>> wrong parameter (0) passed to sched_getaffinity().
> 
> wrong PID
> 

Yep, it's much clearer to describe it as vCPU thread and migration worker.

>> It's actually
>> forcing migration on the migration worker instead of the thread group
>> leader.
> 
> What's missing is _why_ the migration worker is getting moved around by
> the call. Perhaps instead it is better to state what a PID of 0 implies,
> for those of us who haven't read their manpages in a while ;-)
> 

Yes, it's good idea. I will have something like below in next revision :)

     In rseq_test, there are two threads, which are vCPU thread and migration
     worker separately. Unfortunately, the test has the wrong PID passed to
     sched_setaffinity() in the migration worker. It forces migration on the
     migration worker because zeroed PID represents the calling thread, which
     is the migration worker itself. It means the vCPU thread is never enforced
     to migration and it can migrate at any time, which eventually leads to
     failure as the following logs show.
         :
         :
     Fix the issue by passing correct parameter, TID of the vCPU thread, to
     sched_setaffinity() in the migration worker.


>> It also means migration can happen on the thread group leader
>> at any time, which eventually leads to failure as the following logs
>> show.
>>
>> host# uname -r
>> 5.19.0-rc6-gavin+
>> host# # cat /proc/cpuinfo | grep processor | tail -n 1
>> processor : 223
>> host# pwd
>> /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
>> host# for i in `seq 1 100`; \
>> do echo "--------> $i"; ./rseq_test; done
>> --------> 1
>> --------> 2
>> --------> 3
>> --------> 4
>> --------> 5
>> --------> 6
>> ==== Test Assertion Failure ====
>> rseq_test.c:265: rseq_cpu == cpu
>> pid=3925 tid=3925 errno=4 - Interrupted system call
>> 1 0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
>> 2 0x0000ffffb044affb: ?? ??:0
>> 3 0x0000ffffb044b0c7: ?? ??:0
>> 4 0x0000000000401a6f: _start at ??:?
>> rseq CPU = 4, sched CPU = 27
>>
>> This fixes the issue by passing correct parameter, tid of the group
>> thread leader, to sched_setaffinity().
> 
> Kernel commit messages should have an imperative tone:
> 
> Fix the issue by ...
> 

Ok. I've been having my style for long time. Actually, the style was
shared by some one when I worked for IBM long time ago. I will bear
it in mind to use imperative expression since now on :)

All your comments will be fixed in next revision, but I would delay
the posting a bit to see Sean or Paolo have more comments. In that
case, I can fix all of them at once.

>> Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
> 
> With the comments on the commit message addressed:
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 

Thanks again for your time on this.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
