Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEBDC43334
	for <kvmarm@archiver.kernel.org>; Sat, 16 Jul 2022 12:46:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D7AC4CA6F;
	Sat, 16 Jul 2022 08:46:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dUGMsxEFrxbf; Sat, 16 Jul 2022 08:46:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433664CA78;
	Sat, 16 Jul 2022 08:46:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F28904CA07
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 08:46:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1EJ8vZ0TAjbW for <kvmarm@lists.cs.columbia.edu>;
 Sat, 16 Jul 2022 08:46:37 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8DCC4CA6E
 for <kvmarm@lists.cs.columbia.edu>; Sat, 16 Jul 2022 08:46:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657975597;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gdJrggoBajMyD7ZX4uOkVmmZPh8On8F/BnqfeaTVrkg=;
 b=iB8b5dzZzCSi8/RAkDjSEUQ5gVcDyWnHDBqqjcxrvkVEWVJWn0VA4h1SkBrIGh978ViqW/
 JOyY5/kCJTWhYDGvJl7k2ZyXEhl+xAh77YUYRZLK18wyqbTAm7jFM5U8wYtf8+oePyPhS8
 icA08X2fqh6WXpckbsrL4JW+yAsRZr0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-BcYhgWPOPneExPiVfr2R7A-1; Sat, 16 Jul 2022 08:46:33 -0400
X-MC-Unique: BcYhgWPOPneExPiVfr2R7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45A533C01DEC;
 Sat, 16 Jul 2022 12:46:33 +0000 (UTC)
Received: from [10.64.54.37] (vpn2-54-37.bne.redhat.com [10.64.54.37])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F3A40E8B04;
 Sat, 16 Jul 2022 12:46:29 +0000 (UTC)
Subject: Re: [PATCH] KVM: selftests: Double check on the current CPU in
 rseq_test
To: Sean Christopherson <seanjc@google.com>
References: <20220714080642.3376618-1-gshan@redhat.com>
 <cd5d029c-b396-45ef-917b-92e054659623@redhat.com>
 <YtA3s0VRj3x7vO7B@google.com>
 <be806f9c-861a-8da8-d42e-1d4271c3a326@redhat.com>
 <YtF6gVYgMhoiD0Pe@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ae6c6ad2-8211-6227-fa41-505ecc7df673@redhat.com>
Date: Sun, 17 Jul 2022 00:46:08 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YtF6gVYgMhoiD0Pe@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: shan.gavin@gmail.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev,
 mathieu.desnoyers@efficios.com, linux-kselftest@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Hi Sean,

On 7/16/22 12:32 AM, Sean Christopherson wrote:
> On Fri, Jul 15, 2022, Gavin Shan wrote:
>> On 7/15/22 1:35 AM, Sean Christopherson wrote:
>>> On Thu, Jul 14, 2022, Paolo Bonzini wrote:
>> Well, I don't think migration_worker() does correct thing, if I'm understanding
>> correctly. The intention seems to force migration on 'main' thread by 'migration'
>> thread?  If that is the case, I don't think the following function call has correct
>> parameters.
>>
>>      r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
>>
>>      it should be something like:
>>
>>      r = sched_setaffinity(getpid(), sizeof(allowed_mask), &allowed_mask);
>>
>> If we're using sched_setaffinity(0, ...) in the 'migration' thread, the CPU
>> affinity of 'main' thread won't be affected. It means 'main' thread can be
>> migrated from one CPU to another at any time, even in the following point:
>>
>>      int main(...)
>>      {
>>            :
>>            /*
>>             * migration can happen immediately after sched_getcpu(). If
>>             * CPU affinity of 'main' thread is sticky to one particular
>>             * CPU, which 'migration' thread supposes to do, then there
>>             * should have no migration.
>>             */
>>            cpu = sched_getcpu();
>>            rseq_cpu = READ_ONCE(__rseq.cpu_id);
>>            :
>>      }
>>
>> So I think the correct fix is to have sched_setaffinity(getpid(), ...) ?
>> Please refer to the manpage.
>>
>>     https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html
>>     'If pid is zero, then the calling thread is used'
> 
> Oof, and more explicitly the rest of that sentence clarifies that the result of
> getpid() will target the main thread (I assume "main" means thread group leader).
> 
>     Specifying pid as 0 will set the attribute for the calling thread, and passing
>     the value returned from a call to getpid(2) will set the attribute for the main
>     thread of the thread group.
> 
> I'm guessing my test worked (in that it reproduced the bug) by virtue of the
> scheduler trying to colocate all threads in the process.
> 
> In my defense, the die.net copy of the manpages quite clearly uses "process"[1],
> but that was fixed in the manpages in 2013[2]!?!!?  So I guess the takeaway is
> to use only the official manpages.
> 
> Anyways, for the code, my preference would be to snapshot gettid() in main() before
> spawning the migration worker.  Same result, but I would rather the test explicitly
> target the thread doing rseq instead of relying on (a) getpid() targeting only the
> main thread and (b) the main thread always being the rseq thread.  E.g. if for some
> reason a future patch moves the rseq code to its own worker thread, then getpid()
> would be incorrect.
> 
> Thanks for figuring this out!
> 
> [1] https://linux.die.net/man/2/sched_setaffinity
> [2] 6a7fcf3cc ("sched_setaffinity.2: Clarify that these system calls affect a per-thread attribute")
> 

Thanks for your confirm. The suggested way, to cache tid of the thread group
leader in advance, makes sense to me. The code has been modified accordingly
in below patch, which was just posted. Please help to review when you get a
chance.

[PATCH v2] KVM: selftests: Fix target thread to be migrated in rseq_test

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
