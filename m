Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B170C25B08
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 00:37:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C9BF4D0F1;
	Tue,  9 Aug 2022 20:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zg7-cb8d8WkC; Tue,  9 Aug 2022 20:37:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3959D4D0F2;
	Tue,  9 Aug 2022 20:37:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 591E24D0E9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 20:37:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 90X7rTfE77ZB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 20:37:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 222494D0E4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 20:37:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660091872;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gI8W3vKU6gx264pJaXZH00m10/hIkZkbLO7K9QwADAU=;
 b=WdL1C2KHqbNSspyWOQMej4YplNjwarQJO771wPaRpuV7ppHWZU6nCY9KSnSrbp75LOiUmR
 /eMvcEBeTTzYQfr84oRMLqUnodsNlEZCdyjv2qh2ql+QyTTn+lK3S8h2Nb52Tii448uBmu
 gcmO2hQcXzHwfquwCgGcFmWRI8meAgE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-eDbrPmK5OK6ImuSrx8J66w-1; Tue, 09 Aug 2022 20:37:48 -0400
X-MC-Unique: eDbrPmK5OK6ImuSrx8J66w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA5863802AC2;
 Wed, 10 Aug 2022 00:37:47 +0000 (UTC)
Received: from [10.64.54.189] (vpn2-54-189.bne.redhat.com [10.64.54.189])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10C089459C;
 Wed, 10 Aug 2022 00:37:42 +0000 (UTC)
Subject: Re: [PATCH 1/2] KVM: selftests: Make rseq compatible with glibc-2.35
To: Sean Christopherson <seanjc@google.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-2-gshan@redhat.com>
 <8735e6ncxw.fsf@oldenburg.str.redhat.com>
 <7844e3fa-e49e-de75-e424-e82d3a023dd6@redhat.com>
 <87o7wtnay6.fsf@oldenburg.str.redhat.com>
 <616d4de6-81f6-9d14-4e57-4a79fec45690@redhat.com>
 <797306043.114963.1660047714774.JavaMail.zimbra@efficios.com>
 <1014177394.115022.1660052656961.JavaMail.zimbra@efficios.com>
 <YvLT1fd8ddybF5Uw@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8c1f33b4-a5a1-fcfa-4521-36253ffa22c8@redhat.com>
Date: Wed, 10 Aug 2022 10:37:40 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YvLT1fd8ddybF5Uw@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu@redhat.com,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, shuah <shuah@kernel.org>,
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

Hi Mathieu and Sean,

On 8/10/22 7:38 AM, Sean Christopherson wrote:
> On Tue, Aug 09, 2022, Mathieu Desnoyers wrote:
>> ----- On Aug 9, 2022, at 8:21 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
>>> ----- Gavin Shan <gshan@redhat.com> wrote:
>>>> On 8/9/22 5:16 PM, Florian Weimer wrote:
>>>>>>> __builtin_thread_pointer doesn't work on all architectures/GCC
>>>>>>> versions.
>>>>>>> Is this a problem for selftests?
>>>>>>>
>>>>>>
>>>>>> It's a problem as the test case is running on all architectures. I think I
>>>>>> need introduce our own __builtin_thread_pointer() for where it's not
>>>>>> supported: (1) PowerPC  (2) x86 without GCC 11
>>>>>>
>>>>>> Please let me know if I still have missed cases where
>>>>>> __buitin_thread_pointer() isn't supported?
>>>>>
>>>>> As far as I know, these are the two outliers that also have rseq
>>>>> support.  The list is a bit longer if we also consider non-rseq
>>>>> architectures (csky, hppa, ia64, m68k, microblaze, sparc, don't know
>>>>> about the Linux architectures without glibc support).
>>>>>
>>>>
>>>> For kvm/selftests, there are 3 architectures involved actually. So we
>>>> just need consider 4 cases: aarch64, x86, s390 and other. For other
>>>> case, we just use __builtin_thread_pointer() to maintain code's
>>>> integrity, but it's not called at all.
>>>>
>>>> I think kvm/selftest is always relying on glibc if I'm correct.
>>>
>>> All those are handled in the rseq selftests and in librseq. Why duplicate all
>>> that logic again?
>>
>> More to the point, considering that we have all the relevant rseq registration
>> code in tools/testing/selftests/rseq/rseq.c already, and the relevant thread
>> pointer getter code in tools/testing/selftests/rseq/rseq-*thread-pointer.h,
>> is there an easy way to get test applications in tools/testing/selftests/kvm
>> and in tools/testing/selftests/rseq to share that common code ?
>>
>> Keeping duplicated compatibility code is bad for long-term maintainability.
> 
> Any reason not to simply add tools/lib/rseq.c and then expose a helper to get the
> registered rseq struct?
> 

There are couple of reasons, not to share tools/testing/selftests/rseq/librseq.so
or add tools/lib/librseq.so. Please let me know if the arguments making sense
to you?

- By design, selftests/rseq and selftests/kvm are parallel. It's going to introduce
   unnecessary dependency for selftests/kvm to use selftests/rseq/librseq.so. To me,
   it makes the maintainability even harder.

- What selftests/kvm needs is rseq-thread-pointer.h, which accounts for ~5% of
   functionalities, provided by selftests/rseq/librseq.so.

- I'm not too much familiar with selftests/rseq, but it seems it need heavy
   rework before it can become tools/lib/librseq.so. However, I'm not sure if
   the effort is worthwhile. The newly added library is fully used by
   testtests/rseq. ~5% of that is going to be used by selftests/kvm.
   In this case, we still have cross-dependency issue.

I personally prefer not to use selftests/rseq/librseq.so or add tools/lib/librseq.so,
but I need your feedback. Please share your thoughts.
Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
