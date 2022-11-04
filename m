Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68DC1C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 00:12:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C284340EEF;
	Thu,  3 Nov 2022 20:12:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hoOwe7amuDGW; Thu,  3 Nov 2022 20:12:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7893540DF4;
	Thu,  3 Nov 2022 20:12:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B5AA40D23
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 20:12:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vrc2Kuy2VJ5X for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 20:12:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C098B40D0B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 20:12:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1667520755;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X8V2P0sK6vg/zYa0nsGPDkqRLaIh/+PWOrDyxDJZDYA=;
 b=VwYmPc9ZWOUInqkqR8njtBa+sLb3/2MmdPfqJoSfY4KwoLMM/OntQN1543iXtkQOOH29Bj
 u5JGSSlwU9nrGphvn5iyeY3KWDonkGL0j2VGBcVcNtwYSQxsT8zUKIFhW1xzuAOjEXQukb
 qjIk4vJGLSxfMs59M5WnDQ3r3JngVnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-2BYngf1ePvWeqNd1CSCMNQ-1; Thu, 03 Nov 2022 20:12:31 -0400
X-MC-Unique: 2BYngf1ePvWeqNd1CSCMNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E68A98027EA;
 Fri,  4 Nov 2022 00:12:30 +0000 (UTC)
Received: from [10.64.54.56] (vpn2-54-56.bne.redhat.com [10.64.54.56])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73AC340C6E14;
 Fri,  4 Nov 2022 00:12:24 +0000 (UTC)
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
To: Oliver Upton <oliver.upton@linux.dev>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com> <Y2RPhwIUsGLQ2cz/@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <d5b86a73-e030-7ce3-e5f3-301f4f505323@redhat.com>
Date: Fri, 4 Nov 2022 08:12:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2RPhwIUsGLQ2cz/@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

On 11/4/22 7:32 AM, Oliver Upton wrote:
> On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
>> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
>> enabled. It's conflicting with that ring-based dirty page tracking always
>> requires a running VCPU context.
>>
>> Introduce a new flavor of dirty ring that requires the use of both VCPU
>> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
>> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
>> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
>> the VM to the target.
>>
>> Use an additional capability to advertise this behavior. The newly added
>> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
>> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
>> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
> 
> Whatever ordering requirements we settle on between these capabilities
> needs to be documented as well.
> 
> [...]
> 

It's mentioned in 'Documentation/virt/kvm/api.rst' as below.

   After using the dirty rings, the userspace needs to detect the capability
   of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP to see whether the ring structures
   need to be backed by per-slot bitmaps. With this capability advertised
   and supported, it means the architecture can dirty guest pages without
   vcpu/ring context, so that some of the dirty information will still be
   maintained in the bitmap structure.

The description may be not obvious about the ordering. For this, I can
add the following sentence at end of the section.

   The capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP can't be enabled
   until the capability of KVM_CAP_DIRTY_LOG_RING_ACQ_REL has been enabled.

>> @@ -4588,6 +4594,13 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>   			return -EINVAL;
>>   
>>   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>> +	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
>> +		if (!IS_ENABLED(CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP) ||
>> +		    !kvm->dirty_ring_size)
> 
> I believe this ordering requirement is problematic, as it piles on top
> of an existing problem w.r.t. KVM_CAP_DIRTY_LOG_RING v. memslot
> creation.
> 
> Example:
>   - Enable KVM_CAP_DIRTY_LOG_RING
>   - Create some memslots w/ dirty logging enabled (note that the bitmap
>     is _not_ allocated)
>   - Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
>   - Save ITS tables and get a NULL dereference in
>     mark_page_dirty_in_slot():
> 
>                  if (vcpu && kvm->dirty_ring_size)
>                          kvm_dirty_ring_push(&vcpu->dirty_ring,
>                                              slot, rel_gfn);
>                  else
> ------->		set_bit_le(rel_gfn, memslot->dirty_bitmap);
> 
> Similarly, KVM may unnecessarily allocate bitmaps if dirty logging is
> enabled on memslots before KVM_CAP_DIRTY_LOG_RING is enabled.
> 
> You could paper over this issue by disallowing DIRTY_RING_WITH_BITMAP if
> DIRTY_LOG_RING has already been enabled, but the better approach would
> be to explicitly check kvm_memslots_empty() such that the real
> dependency is obvious. Peter, hadn't you mentioned something about
> checking against memslots in an earlier revision?
> 

The userspace (QEMU) needs to ensure that no dirty bitmap is created
before the capability of KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is enabled.
It's unknown by QEMU that vgic/its is used when KVM_CAP_DIRTY_LOG_RING_ACQ_REL
is enabled.

    kvm_initialization
      enable_KVM_CAP_DIRTY_LOG_RING_ACQ_REL        // Where KVM_CAP_DIRTY_LOG_RING is enabled
    board_initialization                           // Where QEMU knows if vgic/its is used
      add_memory_slots
    kvm_post_initialization
      enable_KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
    :
    start_migration
      enable_dirty_page_tracking
        create_dirty_bitmap                       // With KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP enabled

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
