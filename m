Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A34BC54EE9
	for <kvmarm@archiver.kernel.org>; Fri, 23 Sep 2022 00:04:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB29D4B62C;
	Thu, 22 Sep 2022 20:04:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YHyKWRGVeUT1; Thu, 22 Sep 2022 20:04:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D5C04A1B0;
	Thu, 22 Sep 2022 20:04:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D129640DF4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 20:04:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 85EhIRlsz3Oz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 20:04:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F60040B59
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 20:04:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663891472;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Bsg3eiaL/uSnK7pLzXQPqxbW8JmQwG8hl+kFowkskPM=;
 b=IjGopr6IVEvxSowJgvmJoQvf2T400y6OP6aI9ZKyvkMiW5Cwt+4aWgXJC/lJ8CyBKgwion
 +DwnZnAYh9gODjn+ju8X89m+uC0QxnpOobcstjk++lvYdVpdLYoQd+QgjLhLLELwzUEg/Y
 1MWXiNCBdjZuQ6hHIbogCNqbz7rN0lE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-yxN0BAMyMbuEZLyoU6I2hQ-1; Thu, 22 Sep 2022 20:04:28 -0400
X-MC-Unique: yxN0BAMyMbuEZLyoU6I2hQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC8E43C138A0;
 Fri, 23 Sep 2022 00:04:27 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E75AE1121314;
 Fri, 23 Sep 2022 00:04:21 +0000 (UTC)
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
To: Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org> <YyzYI/bvp/JnbcxS@xz-m1.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <71ebc42f-7148-87e5-4bdc-47924e583a88@redhat.com>
Date: Fri, 23 Sep 2022 10:04:18 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YyzYI/bvp/JnbcxS@xz-m1.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
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

Hi Peter and Marc,

On 9/23/22 7:48 AM, Peter Xu wrote:
> On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
>> In order to differenciate between architectures that require no extra
>> synchronisation when accessing the dirty ring and those who do,
>> add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
>> the latter sort. TSO architectures can obviously advertise both, while
>> relaxed architectures most only advertise the ORDERED version.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   include/linux/kvm_dirty_ring.h |  6 +++---
>>   include/uapi/linux/kvm.h       |  1 +
>>   virt/kvm/Kconfig               | 14 ++++++++++++++
>>   virt/kvm/Makefile.kvm          |  2 +-
>>   virt/kvm/kvm_main.c            | 11 +++++++++--
>>   5 files changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
>> index 906f899813dc..7a0c90ae9a3f 100644
>> --- a/include/linux/kvm_dirty_ring.h
>> +++ b/include/linux/kvm_dirty_ring.h
>> @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
>>   	int index;
>>   };
>>   
>> -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
>> +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG
> 
> s/LOG/LOG_RING/ according to the commit message? Or the name seems too
> generic.
> 
> Pure question to ask: is it required to have a new cap just for the
> ordering?  IIUC if x86 was the only supported anyway before, it means all
> released old kvm binaries are always safe even without the strict
> orderings.  As long as we rework all the memory ordering bits before
> declaring support of yet another arch, we're good.  Or am I wrong?
> 

I have same questions. The name of CONFIG_HAVE_KVM_DIRTY_LOG is too
generic at least. I'm wandering why we even need other two kernel config
options, which are HAVE_KVM_DIRTY_{RING, RING_ORDER}.

- The ordering because of smp_load_acquire/smp_store_release is unconditionally
   applied to kvm_dirty_gfn_set_dirtied() and kvm_dirty_gfn_harvested() in PATCH[1/6].
- Both kernel config options are enabled on x86 in PATCH[3/6]

It means we needn't to differentiate strict/relaxed ordering by the extra
capability and kernel config options. If it makes sense, how about to let user
space decide strict ordering is needed base on the architecture (x86 vs ARM64 for now).


Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
