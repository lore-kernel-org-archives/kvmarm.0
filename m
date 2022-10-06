Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B561EC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Oct 2022 23:38:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09D0949E18;
	Thu,  6 Oct 2022 19:38:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wXJUqSuwTPsW; Thu,  6 Oct 2022 19:38:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87901405AA;
	Thu,  6 Oct 2022 19:38:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30E31405AA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 19:38:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lKdVUGfah6GI for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Oct 2022 19:38:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5313404CD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Oct 2022 19:38:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665099512;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3YZJeFTA/Tj+Wqb3gKBQ3wuXJ9QktL5f9e36mUvVsCQ=;
 b=dwvCEWtY0g75no6FxavXPxbp3LCS4sE+JgeppssLit+iG8jgcaviDabgTst3XFU7QyXtXt
 2NaCxamSbbvfxDz8KkEF6ztIDqMdLc8n+BklMLf9JwKiDLIq5W+f1CdHon4w/6KgVX8j6p
 0WCPSq8SyzqkPF+KVapV2o1HdQ6dmTE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-jvIBj9zXMiaDV3J6q88Osg-1; Thu, 06 Oct 2022 19:38:29 -0400
X-MC-Unique: jvIBj9zXMiaDV3J6q88Osg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6601E3C0F434;
 Thu,  6 Oct 2022 23:38:28 +0000 (UTC)
Received: from [10.64.54.52] (vpn2-54-52.bne.redhat.com [10.64.54.52])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 89A821457F36;
 Thu,  6 Oct 2022 23:38:22 +0000 (UTC)
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
To: Peter Xu <peterx@redhat.com>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
Date: Fri, 7 Oct 2022 07:38:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Yz86gEbNflDpC8As@x1n>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Peter,

On 10/7/22 4:28 AM, Peter Xu wrote:
> On Wed, Oct 05, 2022 at 08:41:50AM +0800, Gavin Shan wrote:
>> -8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>> -----------------------------------------------------------
>> +8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
>> +--------------------------------------------------------------
> 
> Shall we make it a standalone cap, just to rely on DIRTY_RING[_ACQ_REL]
> being enabled first, instead of making the three caps at the same level?
> 
> E.g. we can skip creating bitmap for DIRTY_RING[_ACQ_REL] && !_ALLOW_BITMAP
> (x86).
> 

Both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LONG_RING_ACQ_REL are available
to x86. So KVM_CAP_DIRTY_LONG_RING_ACQ_REL can be enabled on x86 in theory.
However, the idea to disallow bitmap for KVM_CAP_DIRTY_LOG_RING (x86) makes
sense to me. I think you may be suggesting something like below.

- bool struct kvm::dirty_ring_allow_bitmap

- In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL

   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
   {
     :
     mutex_lock(&kvm->lock);

     if (kvm->created_vcpus) {
        /* We don't allow to change this value after vcpu created */
        r = -EINVAL;
     } else {
        kvm->dirty_ring_size = size;
        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
        r = 0;
     }

     mutex_unlock(&kvm->lock);
     return r;
   }
   
- In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.

   static long kvm_vm_ioctl_check_extension_generic(...)
   {
     :
     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
         return kvm->dirty_ring_allow_bitmap ? 1 : 0;
   }

- The suggested dirty_ring_exclusive() is used.

>> @@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>>   	unsigned long n;
>>   	unsigned long any = 0;
>>   
>> -	/* Dirty ring tracking is exclusive to dirty log tracking */
>> -	if (kvm->dirty_ring_size)
>> -		return -ENXIO;
> 
> Then we can also have one dirty_ring_exclusive(), with something like:
> 
> bool dirty_ring_exclusive(struct kvm *kvm)
> {
>          return kvm->dirty_ring_size && !kvm->dirty_ring_allow_bitmap;
> }
> 
> Does it make sense?  Thanks,
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
