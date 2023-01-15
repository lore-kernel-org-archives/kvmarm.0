Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D910FB
	for <kvmarm@lists.linux.dev>; Sun, 15 Jan 2023 11:37:54 +0000 (UTC)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Nvt1q4MlQz16Mbr;
	Sun, 15 Jan 2023 19:18:23 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Sun, 15 Jan 2023 19:20:01 +0800
Subject: Re: [PATCH v10 4/7] KVM: arm64: Enable ring-based dirty memory
 tracking
To: Gavin Shan <gshan@redhat.com>
CC: <kvmarm@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
	<kvm@vger.kernel.org>, <maz@kernel.org>, <seanjc@google.com>,
	<shuah@kernel.org>, <catalin.marinas@arm.com>, <andrew.jones@linux.dev>,
	<ajones@ventanamicro.com>, <bgardon@google.com>, <dmatlack@google.com>,
	<will@kernel.org>, <suzuki.poulose@arm.com>, <alexandru.elisei@arm.com>,
	<pbonzini@redhat.com>, <peterx@redhat.com>, <oliver.upton@linux.dev>,
	<zhenyzha@redhat.com>, <shan.gavin@gmail.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-5-gshan@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e28ede67-1bc4-fb1e-9bea-60cc9bd85190@huawei.com>
Date: Sun, 15 Jan 2023 19:20:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221110104914.31280-5-gshan@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected

Hi Gavin,

On 2022/11/10 18:49, Gavin Shan wrote:
> Enable ring-based dirty memory tracking on ARM64:
> 
>   - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL.
> 
>   - Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP.
> 
>   - Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
>     offset.
> 
>   - Add ARM64 specific kvm_arch_allow_write_without_running_vcpu() to
>     keep the site of saving vgic/its tables out of the no-running-vcpu
>     radar.

And we have KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.. On receiving it, the
emulated VGIC will write all pending bits (if any) into pending tables
(which reside in guest memory) and doesn't require a running vcpu
context.

The no-running-vcpu WARN can be triggered with the
kvm-unit-tests/its-pending-migration case. I run it using QEMU, which
has nothing to do with the dirty ring atm.

Or are there already discussions about it that I haven't noticed?

|void mark_page_dirty_in_slot(struct kvm *kvm,
|			     const struct kvm_memory_slot *memslot,
|			     gfn_t gfn)
|{
|	WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
