Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D361EC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 21:57:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F0F240ECE;
	Fri,  4 Nov 2022 17:57:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s3N+YhNWZ4Nh; Fri,  4 Nov 2022 17:57:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB48740F7C;
	Fri,  4 Nov 2022 17:57:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC22E40ECE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 17:57:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wvdrnf8oa0tq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 17:57:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7C3F40E76
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 17:57:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667599066;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=echi3gnEWFqiTz8OsdlvFnKn/n9jHbzMBcKU0UjomWA=;
 b=I05FcdRZaFeNIsxod5rVBujknzeJaSegB0Nnurv/CGr0WvjRxhU3QjFp2ceZlc+VMIwCMe
 DUTG3aaEX0RBrHKrWi89e7l5jStzyUlIl7eUFWiO+HHKJLw5gIFHqlkHRJ0MyfyKb6rCGN
 RWHhXf7oW4bginkXVH4XRno2r/itj78=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-R4Ug5tsJOii1Z79It740oQ-1; Fri, 04 Nov 2022 17:57:43 -0400
X-MC-Unique: R4Ug5tsJOii1Z79It740oQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36D9286E91C;
 Fri,  4 Nov 2022 21:57:42 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B64A040C835A;
 Fri,  4 Nov 2022 21:57:35 +0000 (UTC)
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
To: Oliver Upton <oliver.upton@linux.dev>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com> <Y2RPhwIUsGLQ2cz/@google.com>
 <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
 <Y2RlfkyQMCtD6Rbh@google.com>
 <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
 <Y2VyMwAlg7U9pXzV@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <f2d95d47-6411-8d01-14eb-5e17e1a16dbf@redhat.com>
Date: Sat, 5 Nov 2022 05:57:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2VyMwAlg7U9pXzV@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Cc: shuah@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org,
 maz@kernel.org, andrew.jones@linux.dev, dmatlack@google.com,
 shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, zhenyzha@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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

On 11/5/22 4:12 AM, Oliver Upton wrote:
> On Fri, Nov 04, 2022 at 02:57:15PM +0800, Gavin Shan wrote:
>> On 11/4/22 9:06 AM, Oliver Upton wrote:
> 
> [...]
> 
>>> Just to make sure we're on the same page, there's two issues:
>>>
>>>    (1) If DIRTY_LOG_RING is enabled before memslot creation and
>>>        RING_WITH_BITMAP is enabled after memslots have been created w/
>>>        dirty logging enabled, memslot->dirty_bitmap == NULL and the
>>>        kernel will fault when attempting to save the ITS tables.
>>>
>>>    (2) Not your code, but a similar issue. If DIRTY_LOG_RING[_ACQ_REL] is
>>>        enabled after memslots have been created w/ dirty logging enabled,
>>>        memslot->dirty_bitmap != NULL and that memory is wasted until the
>>>        memslot is freed.
>>>
>>> I don't expect you to fix #2, though I've mentioned it because using the
>>> same approach to #1 and #2 would be nice.
>>>
>>
>> Yes, I got your points. Case (2) is still possible to happen with QEMU
>> excluded. However, QEMU is always enabling DIRTY_LOG_RING[_ACQ_REL] before
>> any memory slot is created. I agree that we need to ensure there are no
>> memory slots when DIRTY_LOG_RING[_ACQ_REL] is enabled.
>>
>> For case (1), we can ensure RING_WTIH_BITMAP is enabled before any memory
>> slot is added, as below. QEMU needs a new helper (as above) to enable it
>> on board's level.
>>
>> Lets fix both with a new helper in PATCH[v8 4/9] like below?
> 
> I agree that we should address (1) like this, but in (2) requiring that
> no memslots were created before enabling the existing capabilities would
> be a change in ABI. If we can get away with that, great, but otherwise
> we may need to delete the bitmaps associated with all memslots when the
> cap is enabled.
> 

I had the assumption QEMU and kvm/selftests are the only consumers to
use DIRTY_RING. In this case, requiring that no memslots were created
to enable DIRTY_RING won't break userspace. Following your thoughts,
the tracked dirty pages in the bitmap also need to be synchronized to
the per-vcpu-ring before the bitmap can be destroyed. We don't have
per-vcpu-ring at this stage.

>>    static inline bool kvm_vm_has_memslot_pages(struct kvm *kvm)
>>    {
>>        bool has_memslot_pages;
>>
>>        mutex_lock(&kvm->slots_lock);
>>
>>        has_memslot_pages = !!kvm->nr_memslot_pages;
>>
>>        mutex_unlock(&kvm->slots_lock);
>>
>>        return has_memslot_pages;
>>    }
> 
> Do we need to build another helper for this? kvm_memslots_empty() will
> tell you whether or not a memslot has been created by checking the gfn
> tree.
> 

The helper was introduced to be shared when DIRTY_RING[_ACQ_REL] and
DIRTY_RING_WITH_BITMAP are enabled. Since the issue (2) isn't concern
to us, lets put it aside and the helper isn't needed. kvm_memslots_empty()
has same effect as to 'kvm->nr_memslot_pages', it's fine to use
kvm_memslots_empty(), which is more generic.

> On top of that, the memslot check and setting
> kvm->dirty_ring_with_bitmap must happen behind the slots_lock. Otherwise
> you could still wind up creating memslots w/o bitmaps.
> 

Agree.

> 
> Something like:
> 
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 91cf51a25394..420cc101a16e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4588,6 +4588,32 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>   			return -EINVAL;
>   
>   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
> +
> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP: {
> +		struct kvm_memslots *slots;
> +		int r = -EINVAL;
> +
> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
> +		    !kvm->dirty_ring_size)
> +			return r;
> +
> +		mutex_lock(&kvm->slots_lock);
> +
> +		slots = kvm_memslots(kvm);
> +
> +		/*
> +		 * Avoid a race between memslot creation and enabling the ring +
> +		 * bitmap capability to guarantee that no memslots have been
> +		 * created without a bitmap.
> +		 */
> +		if (kvm_memslots_empty(slots)) {
> +			kvm->dirty_ring_with_bitmap = cap->args[0];
> +			r = 0;
> +		}
> +
> +		mutex_unlock(&kvm->slots_lock);
> +		return r;
> +	}
>   	default:
>   		return kvm_vm_ioctl_enable_cap(kvm, cap);
>   	}
> 

The proposed changes look good to me. It will be integrated to PATCH[v8 4/9].
By the way, v8 will be posted shortly.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
