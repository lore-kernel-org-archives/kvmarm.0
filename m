Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CD6522D
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 23:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674862404;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M6k4SK0tssJUsReKgWrMbkASPa1DRov0Livqs+ZaJ88=;
	b=i/dsidR5X9ozL1ezDZSLDMF6nvugAqvOC1JxTOAnYE8Sjt+dmS9XhzMD1YVapMUylZAyPP
	5X0+TAWy1BUtJYiKPY7mRBRV805ndbRwXp9fDVG2aZGi4PvKSbMWBc+5hecNtLVJ5Cl9NC
	WXe9l/NAOYi5miISnaPlHIoG702CQcU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-Ybk-MWwANHCBmQf3YXeg-w-1; Fri, 27 Jan 2023 18:33:21 -0500
X-MC-Unique: Ybk-MWwANHCBmQf3YXeg-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 651E829AA3B9;
	Fri, 27 Jan 2023 23:33:20 +0000 (UTC)
Received: from [10.64.54.64] (vpn2-54-64.bne.redhat.com [10.64.54.64])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 497E52166B26;
	Fri, 27 Jan 2023 23:33:11 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v3 2/4] KVM: arm64: Add helper vgic_write_guest_lock()
To: Zenghui Yu <zenghui.yu@linux.dev>, kvmarm@lists.linux.dev
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, corbet@lwn.net,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, yuzhe@nfschina.com, isaku.yamahata@intel.com,
 seanjc@google.com, ricarkol@google.com, eric.auger@redhat.com,
 renzhengeek@gmail.com, reijiw@google.com, shan.gavin@gmail.com
References: <20230126235451.469087-1-gshan@redhat.com>
 <20230126235451.469087-3-gshan@redhat.com>
 <a4b3ee35-a0d7-80f6-c64f-f9056c5b6110@linux.dev>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <9a8260b1-15f9-f8c9-34a7-0cce8e62a386@redhat.com>
Date: Sat, 28 Jan 2023 10:33:09 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a4b3ee35-a0d7-80f6-c64f-f9056c5b6110@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

Hi Zenghui,

On 1/28/23 2:57 AM, Zenghui Yu wrote:
> [ just coming back from holiday, sorry for the late reply ]
> 

Hope you have a nice refresh. Thanks for your review.

> On 2023/1/27 07:54, Gavin Shan wrote:
>> Currently, the unknown no-running-vcpu sites are reported when a
>> dirty page is tracked by mark_page_dirty_in_slot(). Until now, the
>> only known no-running-vcpu site is saving vgic/its tables through
>> KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on KVM device
>> "kvm-arm-vgic-its". Unfortunately, there are more unknown sites to
>> be handled and no-running-vcpu context will be allowed in these
>> sites: (1) KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} command
>> on KVM device "kvm-arm-vgic-its" to restore vgic/its tables. The
>> vgic3 LPI pending status could be restored. (2) Save vgic3 pending
> 
> We typically write it as "VGICv3".
> 

Ok. I will fix by replacing 'vgic3' with 'VGICv3' in v4. However, the
term 'vgic/its' will be kept.

>> table through KVM_DEV_ARM_{VGIC_GRP_CTRL, VGIC_SAVE_PENDING_TABLES}
>> command on KVM device "kvm-arm-vgic-v3".
>>
>> In order to handle those unknown cases, we need a unified helper
>> vgic_write_guest_lock(). struct vgic_dist::save_its_tables_in_progress
>> is also renamed to struct vgic_dist::save_tables_in_progress.
> 
> How about renaming it to 'write_tables_in_progress' which would look a
> bit more generic? The rest looks good to me.
> 

'write_tables_in_progress' works for me. I will have it in v4, which
will be posted shortly.

Thanks,
Gavin

