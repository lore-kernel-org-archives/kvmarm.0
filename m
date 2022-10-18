Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1037C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 18 Oct 2022 08:49:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 476FA4B85A;
	Tue, 18 Oct 2022 04:49:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Al6wRXOAu1Um; Tue, 18 Oct 2022 04:49:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFFBF4B85B;
	Tue, 18 Oct 2022 04:49:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26A5E4B85B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 04:49:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DLZ-W43WKYDA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Oct 2022 04:48:59 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19B194B85A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Oct 2022 04:48:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666082938;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=I71EikHKgf+Cumvg3ZhyuGvJzSPCx8y69uStaChXwig=;
 b=A2lnRai5u1KHlyftJVm28Qb/JjIF1y7wiZlmZtARxvvVG7fCSZwtKgfdNzal3B69Db2eSG
 SLKtOt8lTI6FDMchT9EhNmbrkglaPs5gLyzoxIvbFGN+bts3mVgkYhO+/M1vjzISF/kTZF
 jmKQdjslt/UjVNpWXseBhV40V6KRF5o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-EOXjjTozOO6CtfRjlIgsIw-1; Tue, 18 Oct 2022 04:48:53 -0400
X-MC-Unique: EOXjjTozOO6CtfRjlIgsIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97229857FAB;
 Tue, 18 Oct 2022 08:48:52 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4A1F2166B41;
 Tue, 18 Oct 2022 08:48:43 +0000 (UTC)
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com> <Y05aCJH+BBo+Y+nh@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <2aa1e089-7af1-24f8-e33c-b123f094f4c3@redhat.com>
Date: Tue, 18 Oct 2022 16:48:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y05aCJH+BBo+Y+nh@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, kvm@vger.kernel.org,
 maz@kernel.org, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 shan.gavin@gmail.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On 10/18/22 3:47 PM, Oliver Upton wrote:
> On Mon, Oct 17, 2022 at 10:08:48PM +0000, Sean Christopherson wrote:
>> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>>> +#define MEM_EXTRA_SIZE		0x10000
>>>
>>> Also, an expression like "(64 << 10)" is more readable than a "1"
>>> with a tail of zeroes (it's easy to add one zero too many or be one
>>> zero short).
>>
>> +1 to not open coding raw numbers.
>>
>> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
>> 16KB, 64K, 2MB, 1GB, etc...
>>
>> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
>> math off of those.
> 
> I mean I love boilerplate as much as the next guy, but we can just use
> tools/include/linux/sizes.h
> 

Nice point, I didn't realize we already had 'tools/include/linux/sizes.h'.
The suggested macros (KiB, MiB, GiB, TiB and their variants) have been added
to PATCH[v2 5/6]. I think it's reasonable to use 'tools/include/linux/sizes.h'
directly instead of reinventing the wheel.

I will go ahead to use 'tools/include/linux/sizes.h' directly in v3 if nobody
objects. I would like to receive comments on v2 before I'm going to post v3.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
