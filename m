Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1C6C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Oct 2022 04:26:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CF3149F38;
	Tue,  4 Oct 2022 00:26:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A1GOYkMTy68P; Tue,  4 Oct 2022 00:26:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB10343C8C;
	Tue,  4 Oct 2022 00:26:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBB6F40E06
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Oct 2022 00:26:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pc+f7vIPc9nR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Oct 2022 00:26:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CB0D401DD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Oct 2022 00:26:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664857594;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=05h8B9w2V62qixWboLULG6QdqKZmIu7qdfGd+YVJUtQ=;
 b=dazYOllp79JUdlBGD/ihwST4/Q9wdM7dWuBiqyIZb5iF6FcRAIZZh0Vx+na1Gw95TxXnne
 nmB/yHiDQbZ2uZ22UX+u8q+PooNPcjld0E8W03F+RM462CTfhCoyBz9gtXbi1cv+dH4tIG
 kY1e2ODpKK8vS5lZ56PXAAug76rAo9M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-mt-LICemPEejFtyt_9QPdQ-1; Tue, 04 Oct 2022 00:26:33 -0400
X-MC-Unique: mt-LICemPEejFtyt_9QPdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41784811E67;
 Tue,  4 Oct 2022 04:26:32 +0000 (UTC)
Received: from [10.64.54.56] (vpn2-54-56.bne.redhat.com [10.64.54.56])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB24B40C6EC2;
 Tue,  4 Oct 2022 04:26:25 +0000 (UTC)
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory tracking
To: Marc Zyngier <maz@kernel.org>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com> <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org> <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org> <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
 <86fsga6y40.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <8b82ef3d-16ab-0aee-b464-8ad9b3718028@redhat.com>
Date: Tue, 4 Oct 2022 12:26:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <86fsga6y40.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 kvmarm@lists.linux.dev, will@kernel.org, shan.gavin@gmail.com,
 bgardon@google.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Marc,

On 9/29/22 10:42 PM, Marc Zyngier wrote:
> On Thu, 29 Sep 2022 10:50:12 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>> On 9/29/22 12:52 AM, Peter Xu wrote:
>>> On Wed, Sep 28, 2022 at 09:25:34AM +0100, Marc Zyngier wrote:
>>>> On Wed, 28 Sep 2022 00:47:43 +0100,
>>>> Gavin Shan <gshan@redhat.com> wrote:
>>>>
>>>>> I have rough idea as below. It's appreciated if you can comment before I'm
>>>>> going a head for the prototype. The overall idea is to introduce another
>>>>> dirty ring for KVM (kvm-dirty-ring). It's updated and visited separately
>>>>> to dirty ring for vcpu (vcpu-dirty-ring).
>>>>>
>>>>>      - When the various VGIC/ITS table base addresses are specified, kvm-dirty-ring
>>>>>        entries are added to mark those pages as 'always-dirty'. In mark_page_dirty_in_slot(),
>>>>>        those 'always-dirty' pages will be skipped, no entries pushed to vcpu-dirty-ring.
>>>>>
>>>>>      - Similar to vcpu-dirty-ring, kvm-dirty-ring is accessed from userspace through
>>>>>        mmap(kvm->fd). However, there won't have similar reset interface. It means
>>>>>        'struct kvm_dirty_gfn::flags' won't track any information as we do for
>>>>>        vcpu-dirty-ring. In this regard, kvm-dirty-ring is purely shared buffer to
>>>>>        advertise 'always-dirty' pages from host to userspace.
>>>>>           - For QEMU, shutdown/suspend/resume cases won't be concerning
>>>>> us any more. The
>>>>>        only concerned case is migration. When the migration is about to complete,
>>>>>        kvm-dirty-ring entries are fetched and the dirty bits are updated to global
>>>>>        dirty page bitmap and RAMBlock's dirty page bitmap. For this, I'm still reading
>>>>>        the code to find the best spot to do it.
>>>>
>>>> I think it makes a lot of sense to have a way to log writes that are
>>>> not generated by a vpcu, such as the GIC and maybe other things in the
>>>> future, such as DMA traffic (some SMMUs are able to track dirty pages
>>>> as well).
>>>>
>>>> However, I don't really see the point in inventing a new mechanism for
>>>> that. Why don't we simply allow non-vpcu dirty pages to be tracked in
>>>> the dirty *bitmap*?
>>>>
>>>>   From a kernel perspective, this is dead easy:
>>>>
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 5b064dbadaf4..ae9138f29d51 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -3305,7 +3305,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>>    	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>>>      #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>>>> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>>>> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>>>>    		return;
>>>>    #endif
>>>>    @@ -3313,10 +3313,11 @@ void mark_page_dirty_in_slot(struct kvm
>>>> *kvm,
>>>>    		unsigned long rel_gfn = gfn - memslot->base_gfn;
>>>>    		u32 slot = (memslot->as_id << 16) | memslot->id;
>>>>    -		if (kvm->dirty_ring_size)
>>>> +		if (vpcu && kvm->dirty_ring_size)
>>>>    			kvm_dirty_ring_push(&vcpu->dirty_ring,
>>>>    					    slot, rel_gfn);
>>>> -		else
>>>> +		/* non-vpcu dirtying ends up in the global bitmap */
>>>> +		if (!vcpu && memslot->dirty_bitmap)
>>>>    			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>>>    	}
>>>>    }
>>>>
>>>> though I'm sure there is a few more things to it.
>>>
>>> Yes, currently the bitmaps are not created when rings are enabled.
>>> kvm_prepare_memory_region() has:
>>>
>>> 		else if (!kvm->dirty_ring_size) {
>>> 			r = kvm_alloc_dirty_bitmap(new);
>>>
>>> But I think maybe that's a solution worth considering.  Using the rings
>>> have a major challenge on the limitation of ring size, so that for e.g. an
>>> ioctl we need to make sure the pages to dirty within an ioctl procedure
>>> will not be more than the ring can take.  Using dirty bitmap for a last
>>> phase sync of constant (but still very small amount of) dirty pages does
>>> sound reasonable and can avoid that complexity.  The payoff is we'll need
>>> to allocate both the rings and the bitmaps.
>>>
>>
>> Ok. I was thinking of using the bitmap to convey the dirty pages for
>> this particular case, where we don't have running vcpu. The concern I had
>> is the natural difference between a ring and bitmap. The ring-buffer is
>> discrete, comparing to bitmap. Besides, it sounds a little strange to
>> have two different sets of meta-data to track the data (dirty pages).
> 
> The problem is that the dirty ring mechanism is a bit blinkered, and
> cannot consider a source of dirty pages other than from the vcpus.
> 

Ok.

>> However, bitmap is easier way than per-vm ring. The constrains with
>> per-vm ring is just as Peter pointed. So lets reuse the bitmap to
>> convey the dirty pages for this particular case. I think the payoff,
>> extra bitmap, is acceptable. For this, we need another capability
>> (KVM_CAP_DIRTY_LOG_RING_BITMAP?) so that QEMU can collects the dirty
>> bitmap in the last phase of migration.
> 
> Why another capability? Just allowing dirty logging to be enabled
> before we saving the GIC state should be enough, shouldn't it?
> 

The GIC state would be just one case where no vcpu can be used to push
dirty page information. As you mentioned, SMMMU HTTU feature could possibly
be another case to ARM64. It's uncertain about other architectures where
dirty-ring will be supported. In QEMU, the dirty (bitmap) logging is enabled
at the beginning of migration and the bitmap is synchronized to global
dirty bitmap and RAMBlock's dirty bitmap gradually, as the following
backtrace shows. What we need to do for QEMU is probably retrieve the
bitmap at point (A).

Without the new capability, we will have to rely on the return value
from ioctls KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG to detect the
capability. For example, -ENXIO is returned on old kernels.

    migration_thread
      qemu_savevm_state_setup
        ram_save_setup
          ram_init_all
            ram_init_bitmaps
              memory_global_dirty_log_start(GLOBAL_DIRTY_MIGRATION)   // dirty logging enabled
              migration_bitmap_sync_precopy(rs)
        :
      migration_iteration_run                                         // iteration 0
        qemu_savevm_state_pending
          migration_bitmap_sync_precopy
        qemu_savevm_state_iterate
          ram_save_iterate
      migration_iteration_run                                        // iteration 1
        qemu_savevm_state_pending
          migration_bitmap_sync_precopy
        qemu_savevm_state_iterate
          ram_save_iterate
      migration_iteration_run                                        // iteration 2
        qemu_savevm_state_pending
          migration_bitmap_sync_precopy
        qemu_savevm_state_iterate
          ram_save_iterate
        :
      migration_iteration_run                                       // iteration N
        qemu_savevm_state_pending
          migration_bitmap_sync_precopy
        migration_completion
          qemu_savevm_state_complete_precopy
            qemu_savevm_state_complete_precopy_iterable
              ram_save_complete
                migration_bitmap_sync_precopy                      // A
                <send all dirty pages>

Note: for post-copy and snapshot, I assume we need to save the dirty bitmap
       in the last synchronization, right after the VM is stopped.

>> If all of us agree on this, I can send another kernel patch to address
>> this. QEMU still need more patches so that the feature can be supported.
> 
> Yes, this will also need some work.
> 
>>>>
>>>> To me, this is just a relaxation of an arbitrary limitation, as the
>>>> current assumption that only vcpus can dirty memory doesn't hold at
>>>> all.
>>>
>>> The initial dirty ring proposal has a per-vm ring, but after we
>>> investigated x86 we found that all legal dirty paths are with a vcpu
>>> context (except one outlier on kvmgt which fixed within itself), so we
>>> dropped the per-vm ring.
>>>
>>> One thing to mention is that DMAs should not count in this case because
>>> that's from device perspective, IOW either IOMMU or SMMU dirty tracking
>>> should be reported to the device driver that interacts with the userspace
>>> not from KVM interfaces (e.g. vfio with VFIO_IOMMU_DIRTY_PAGES).  That even
>>> includes emulated DMA like vhost (VHOST_SET_LOG_BASE).
>>>
>>
>> Thanks to Peter for mentioning the per-vm ring's history. As I said above,
>> lets use bitmap instead if all of us agree.
>>
>> If I'm correct, Marc may be talking about SMMU, which is emulated in host
>> instead of QEMU. In this case, the DMA target pages are similar to those
>> pages for vgic/its tables. Both sets of pages are invisible from QEMU.
> 
> No, I'm talking about an actual HW SMMU using the HTTU feature that
> set the Dirty bit in the PTEs. And people have been working on sharing
> SMMU and CPU PTs for some time, which would give us the one true
> source of dirty page.
> 
> In this configuration, the dirty ring mechanism will be pretty useless.
> 

Ok. I don't know the details. Marc, the dirty bitmap is helpful in this case?

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
