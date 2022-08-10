Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E3AC19F2D
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 00:46:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69ACE4C723;
	Tue,  9 Aug 2022 20:46:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IQsWzXs9TRoL; Tue,  9 Aug 2022 20:46:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AF784C720;
	Tue,  9 Aug 2022 20:46:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A6DE4C717
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 20:46:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oqirfEyMDesI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 20:46:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC084C715
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 20:46:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660092360;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=S/MAn6qAg/Jsbs3sbj308t0Whag8V+DOtIapBcO490g=;
 b=YWqcgP3/yWWe7XCNFSpenqktsz6/13xHi0c5tcw+df2JZXkRZuSjESQCWn3c6nI/Od9jkS
 ll7N+Wisb1e9bPJjQ8D534nUZYkMUkdZHGe3+I3m/J3B8EfT4bgiCokfrhxVx6r4PGBU7+
 dN6/zldMEJTK7sRpKY0VbI0eCtTa1Qo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-XoWcY8H1PiqgLZYkjOgRSg-1; Tue, 09 Aug 2022 20:45:58 -0400
X-MC-Unique: XoWcY8H1PiqgLZYkjOgRSg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2ADD8039A1;
 Wed, 10 Aug 2022 00:45:57 +0000 (UTC)
Received: from [10.64.54.189] (vpn2-54-189.bne.redhat.com [10.64.54.189])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B797492C3B;
 Wed, 10 Aug 2022 00:45:53 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: selftests: Use getcpu() instead of
 sched_getcpu() in rseq_test
To: Sean Christopherson <seanjc@google.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-3-gshan@redhat.com>
 <87y1vxncv1.fsf@oldenburg.str.redhat.com>
 <87mtcdnaxe.fsf@oldenburg.str.redhat.com>
 <ea2ef1a2-0fd8-448b-d7ca-254603518823@redhat.com>
 <YvLJUEOcxaZKW0y1@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <2f8f9062-3e89-7a09-02c4-ab1b2dc07356@redhat.com>
Date: Wed, 10 Aug 2022 10:45:50 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YvLJUEOcxaZKW0y1@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Cc: Florian Weimer <fweimer@redhat.com>, shan.gavin@gmail.com,
 kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 andrew.jones@linux.dev, mathieu.desnoyers@efficios.com, yihyu@redhat.com,
 linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
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

On 8/10/22 6:53 AM, Sean Christopherson wrote:
> On Tue, Aug 09, 2022, Gavin Shan wrote:
>> On 8/9/22 5:17 PM, Florian Weimer wrote:
>>> * Florian Weimer:
>>>
>>>> * Gavin Shan:
>>>>
>>>>> sched_getcpu() is glibc dependent and it can simply return the CPU
>>>>> ID from the registered rseq information, as Florian Weimer pointed.
>>>>> In this case, it's pointless to compare the return value from
>>>>> sched_getcpu() and that fetched from the registered rseq information.
>>>>>
>>>>> Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
>>>>> suggested. The comments are modified accordingly.
>>>>
>>>> Note that getcpu was added in glibc 2.29, so perhaps you need to perform
>>>> a direct system call?
>>>
>>> One more thing: syscall(__NR_getcpu) also has the advantage that it
>>> wouldn't have to be changed again if node IDs become available via rseq
>>> and getcpu is implemented using that.
>>>
>>> Thanks,
>>> Florian
>>>
>>
>> Thanks, Florian. It makes sense to me to use syscall(__NR_getcpu) in
>> next revision. Thanks for your quick review :)
> 
> +1, and definitely add a comment to prevent future "cleanup".
> 

Yep, I will have something like below in next revision:

     /*
      * We have to perform direct system call for getcpu() because it's not
      * available until glic 2.29.
      */

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
