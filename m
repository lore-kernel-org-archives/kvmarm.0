Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C0BDC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 06:57:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C99C74B0D7;
	Fri,  4 Nov 2022 02:57:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4LcnyMXc3v+i; Fri,  4 Nov 2022 02:57:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6599149F51;
	Fri,  4 Nov 2022 02:57:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6892249F3B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:57:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NBeZDfQsepQs for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 02:57:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11E7840C58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:57:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667545058;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=XgC2GA9gQcQ5pTnjhTA9hl/UPKBxdliaQJWvev7RHDU=;
 b=CwZr29iQwFUiDp2aGAmQ/s9M7g7EXYXCbfqVEOrDxkqOYhwWU5IxuR/5H09PZD2z1rde+L
 uXIZ8UBDlUuhtQDhW7XrXs5TboJBcsKBr1rzekVKNuiUdN9KRFZJSQgKtl4G8O08zsXzoC
 pRVS6rIr7fqKD5cWOC4i4yls8a1xM1g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-xFocka1WNgyfl5fzJiGtAg-1; Fri, 04 Nov 2022 02:57:27 -0400
X-MC-Unique: xFocka1WNgyfl5fzJiGtAg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F11E1380451A;
 Fri,  4 Nov 2022 06:57:26 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 101CB1121320;
 Fri,  4 Nov 2022 06:57:18 +0000 (UTC)
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
To: Oliver Upton <oliver.upton@linux.dev>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com> <Y2RPhwIUsGLQ2cz/@google.com>
 <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
 <Y2RlfkyQMCtD6Rbh@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <d7e45de0-bff6-7d8c-4bf4-1a09e8acb726@redhat.com>
Date: Fri, 4 Nov 2022 14:57:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2RlfkyQMCtD6Rbh@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

On 11/4/22 9:06 AM, Oliver Upton wrote:
> On Fri, Nov 04, 2022 at 08:12:21AM +0800, Gavin Shan wrote:
>> On 11/4/22 7:32 AM, Oliver Upton wrote:
>>> On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
>>>> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
>>>> enabled. It's conflicting with that ring-based dirty page tracking always
>>>> requires a running VCPU context.
>>>>
>>>> Introduce a new flavor of dirty ring that requires the use of both VCPU
>>>> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
>>>> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
>>>> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
>>>> the VM to the target.
>>>>
>>>> Use an additional capability to advertise this behavior. The newly added
>>>> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
>>>> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
>>>> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
>>>
>>> Whatever ordering requirements we settle on between these capabilities
>>> needs to be documented as well.
>>>
>>> [...]
>>>
>>
>> It's mentioned in 'Documentation/virt/kvm/api.rst' as below.
>>
>>    After using the dirty rings, the userspace needs to detect the capability
>>    of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the ring structures
>>    need to be backed by per-slot bitmaps. With this capability advertised
>>    and supported, it means the architecture can dirty guest pages without
>>    vcpu/ring context, so that some of the dirty information will still be
>>    maintained in the bitmap structure.
>>
>> The description may be not obvious about the ordering. For this, I can
>> add the following sentence at end of the section.
>>
>>    The capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP can't be enabled
>>    until the capability of KVM_CAP_DIRTY_LOG_RING_ACQ_REL has been enabled.
>>
>>>> @@ -4588,6 +4594,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>>>    			return -EINVAL;
>>>>    		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>>>> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
>>>> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>>>> +		    !kvm->dirty_ring_size)
>>>
>>> I believe this ordering requirement is problematic, as it piles on top
>>> of an existing problem w.r.t. KVM_CAP_DIRTY_LOG_RING v. memslot
>>> creation.
>>>
>>> Example:
>>>    - Enable KVM_CAP_DIRTY_LOG_RING
>>>    - Create some memslots w/ dirty logging enabled (note that the bitmap
>>>      is _not_ allocated)
>>>    - Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
>>>    - Save ITS tables and get a NULL dereference in
>>>      mark_page_dirty_in_slot():
>>>
>>>                   if (vcpu && kvm->dirty_ring_size)
>>>                           kvm_dirty_ring_push(&vcpu->dirty_ring,
>>>                                               slot, rel_gfn);
>>>                   else
>>> ------->		set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>>
>>> Similarly, KVM may unnecessarily allocate bitmaps if dirty logging is
>>> enabled on memslots before KVM_CAP_DIRTY_LOG_RING is enabled.
>>>
>>> You could paper over this issue by disallowing DIRTY_RING_WITH_BITMAP if
>>> DIRTY_LOG_RING has already been enabled, but the better approach would
>>> be to explicitly check kvm_memslots_empty() such that the real
>>> dependency is obvious. Peter, hadn't you mentioned something about
>>> checking against memslots in an earlier revision?
>>>
>>
>> The userspace (QEMU) needs to ensure that no dirty bitmap is created
>> before the capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is enabled.
>> It's unknown by QEMU that vgic/its is used when KVM_CAP_DIRTY_LOG_RING_ACQ_REL
>> is enabled.
> 
> I'm not worried about what QEMU (or any particular VMM for that matter)
> does with the UAPI. The problem is this patch provides a trivial way for
> userspace to cause a NULL dereference in the kernel. Imposing ordering
> between the cap and memslot creation avoids the problem altogether.
> 
> So, looking at your example:
> 
>>     kvm_initialization
>>       enable_KVM_CAP_DIRTY_LOG_RING_ACQ_REL        // Where KVM_CAP_DIRTY_LOG_RING is enabled
>>     board_initialization                           // Where QEMU knows if vgic/its is used
> 
> Is it possible that QEMU could hoist enabling RING_WITH_BITMAP here?
> Based on your description QEMU has decided to use the vGIC ITS but
> hasn't yet added any memslots.
> 

It's possible to add ARM specific helper kvm_arm_enable_dirty_ring_with_bitmap()
in qemu/target/arm.c, to enable RING_WITH_BITMAP if needed. The newly added
function can be called here when vgic/its is used.

>>       add_memory_slots
>>     kvm_post_initialization
>>       enable_KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
>>     :
>>     start_migration
>>       enable_dirty_page_tracking
>>         create_dirty_bitmap                       // With KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP enabled
> 
> Just to make sure we're on the same page, there's two issues:
> 
>   (1) If DIRTY_LOG_RING is enabled before memslot creation and
>       RING_WITH_BITMAP is enabled after memslots have been created w/
>       dirty logging enabled, memslot->dirty_bitmap == NULL and the
>       kernel will fault when attempting to save the ITS tables.
> 
>   (2) Not your code, but a similar issue. If DIRTY_LOG_RING[_ACQ_REL] is
>       enabled after memslots have been created w/ dirty logging enabled,
>       memslot->dirty_bitmap != NULL and that memory is wasted until the
>       memslot is freed.
> 
> I don't expect you to fix #2, though I've mentioned it because using the
> same approach to #1 and #2 would be nice.
> 

Yes, I got your points. Case (2) is still possible to happen with QEMU
excluded. However, QEMU is always enabling DIRTY_LOG_RING[_ACQ_REL] before
any memory slot is created. I agree that we need to ensure there are no
memory slots when DIRTY_LOG_RING[_ACQ_REL] is enabled.

For case (1), we can ensure RING_WTIH_BITMAP is enabled before any memory
slot is added, as below. QEMU needs a new helper (as above) to enable it
on board's level.

Lets fix both with a new helper in PATCH[v8 4/9] like below?

   static inline bool kvm_vm_has_memslot_pages(struct kvm *kvm)
   {
       bool has_memslot_pages;

       mutex_lock(&kvm->slots_lock);

       has_memslot_pages = !!kvm->nr_memslot_pages;

       mutex_unlock(&kvm->slots_lock);

       return has_memslot_pages;
   }

   static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
                                              struct kvm_enable_cap *cap)
   {
       :
       switch (cap->cap) {
       case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
           if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
               !kvm->dirty_ring_size || kvm_vm_has_memslot_pages(kvm))
               return -EINVAL;

           kvm->dirty_ring_with_bitmap = true;

           return 0;
       default:
           return kvm_vm_ioctl_enable_cap(kvm, cap);
       }
   }

   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
   {
       :
       /* We only allow it to set once */
       if (kvm->dirty_ring_size)
           return -EINVAL;

       if (kvm_vm_has_memslot_pages(kvm))
           return -EINVAL;
       :
   }

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
