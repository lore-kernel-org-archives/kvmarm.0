Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F39210EA
	for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 04:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673842163;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0qZnjnerpa+KpeW/HI5RMmgHX6mnqVnPsMFxOB3BvR0=;
	b=ZeuJ1VauHHHPOig+Ukk07H6DM2ssdU/57b8nBjN2xqYRFDvnHszbXA8t81XnqV/zxzDSrp
	OZk5qXP+pvSLd1J1/7pWcXgev5vrUaFRVokBdoeZH7SlQrlQu2SHn1D5cIyKKruRx7xH/j
	m6wf1KvpnHdFvkCH0PaDn9Wbjla3nmQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-1fawK7nqMNW092Z6_dHPeA-1; Sun, 15 Jan 2023 23:09:20 -0500
X-MC-Unique: 1fawK7nqMNW092Z6_dHPeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38336801779;
	Mon, 16 Jan 2023 04:09:19 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B63E2166B26;
	Mon, 16 Jan 2023 04:09:12 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 4/7] KVM: arm64: Enable ring-based dirty memory
 tracking
From: Gavin Shan <gshan@redhat.com>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, maz@kernel.org, seanjc@google.com, shuah@kernel.org,
 catalin.marinas@arm.com, andrew.jones@linux.dev, ajones@ventanamicro.com,
 bgardon@google.com, dmatlack@google.com, will@kernel.org,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, pbonzini@redhat.com,
 peterx@redhat.com, oliver.upton@linux.dev, zhenyzha@redhat.com,
 shan.gavin@gmail.com
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-5-gshan@redhat.com>
 <e28ede67-1bc4-fb1e-9bea-60cc9bd85190@huawei.com>
 <e3414ca2-c4a6-07b5-df41-9999fdb2445a@redhat.com>
Message-ID: <c974528c-17c2-b24e-d975-c0d82377b2b0@redhat.com>
Date: Mon, 16 Jan 2023 15:09:10 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <e3414ca2-c4a6-07b5-df41-9999fdb2445a@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

Hi Zenghui,

On 1/15/23 10:56 PM, Gavin Shan wrote:
> On 1/15/23 10:20 PM, Zenghui Yu wrote:
>> On 2022/11/10 18:49, Gavin Shan wrote:
>>> Enable ring-based dirty memory tracking on ARM64:
>>>
>>>   - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL.
>>>
>>>   - Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP.
>>>
>>>   - Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
>>>     offset.
>>>
>>>   - Add ARM64 specific kvm_arch_allow_write_without_running_vcpu() to
>>>     keep the site of saving vgic/its tables out of the no-running-vcpu
>>>     radar.
>>
>> And we have KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.. On receiving it, the
>> emulated VGIC will write all pending bits (if any) into pending tables
>> (which reside in guest memory) and doesn't require a running vcpu
>> context.
>>
>> The no-running-vcpu WARN can be triggered with the
>> kvm-unit-tests/its-pending-migration case. I run it using QEMU, which
>> has nothing to do with the dirty ring atm.
>>
>> Or are there already discussions about it that I haven't noticed?
>>
>> |void mark_page_dirty_in_slot(struct kvm *kvm,
>> |                 const struct kvm_memory_slot *memslot,
>> |                 gfn_t gfn)
>> |{
>> |    WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
>>
> 
> It's a new case we never noticed. Could you please share the QEMU command lines
> to start the guest? I need to reproduce the issue on my side firstly.
> 
> The fix would be simply to extending kvm->arch.vgic.save_its_tables_in_progress
> from 'bool' to a bit map (e.g. kvm->arch.vgic.dirty_guest_memory_flags) and introduce
> two separate flags for ITS table and VGIC3 pending bits separately. Alternatively,
> we can also introduce another 'bool kvm->arch.vgic.save_vgic_v3_tables_in_progress'
> to cover the new case.
> 

Please try the following series to see if the unexpected warning message disappears
or not.

https://lore.kernel.org/kvmarm/20230116040405.260935-1-gshan@redhat.com/T/#t

Thanks,
Gavin

