Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F90D270
	for <kvmarm@lists.linux.dev>; Wed,  8 Nov 2023 09:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SQKqV1w8kzMmdW;
	Wed,  8 Nov 2023 17:41:58 +0800 (CST)
Received: from [10.174.185.210] (10.174.185.210) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 8 Nov 2023 17:45:52 +0800
Subject: Re: [RFC PATCH] KVM: arm/arm64: GICv4: Support shared VLPI
To: Marc Zyngier <maz@kernel.org>, <dongli.zhang@oracle.com>,
	<cohuck@redhat.com>, <jasowang@redhat.com>, <stefanha@redhat.com>,
	<mst@redhat.com>
CC: Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "open list:IRQCHIP DRIVERS"
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <wanghaibin.wang@huawei.com>
References: <20231102143507.840-1-jiangkunkun@huawei.com>
 <87msvt6cc7.wl-maz@kernel.org>
 <1fb8353e-e9c4-2570-c2ca-ec537c18ac4d@huawei.com>
 <86edh228xx.wl-maz@kernel.org>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <952bd5dc-dd20-acc3-d77e-c9b14e5728d3@huawei.com>
Date: Wed, 8 Nov 2023 17:45:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86edh228xx.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.185.210]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected

Hi Marc,

On 2023/11/6 23:33, Marc Zyngier wrote:
> On Mon, 06 Nov 2023 14:59:01 +0000,
> Kunkun Jiang <jiangkunkun@huawei.com> wrote:
>> The virtio-pci driver write entry1-6
>> massage.data in the msix-table and trap to QEMU for processing. The
>> massage.data is as follow:
>>> entry-0 0
>>> entry-1 1
>>> entry-2 1
>>> entry-3 1
>>> entry-4 1
>>> entry-5 1
>>> entry-6 1
> Urgh... is vp_modern_queue_vector() used in your configuration? This
> is ... terrible.
I encountered this problem using the 4.19 version kernel, but not the
5.10 version. This vp_modern_queue_vector() function does not exist
in 4.19, but it uses 'vp_iowrite16(msix_vec, &cfg->queue_msix_vector)',
the same as vp_modern_queue_vector().

In the past two days, I learned about the virtio driver and made some
new discoveries. When 'num_queues' is greater than maxcpus, it will
fall back into MSI-X with one shared for queues. The two patches[1],
submitted by Dongli, limits the number of hw queues used by
virtio-blk/virtio-scsi by 'nr_cpu_ids'. The two patches were merged
in 5.1-rc2. And the patch related virtio-blk was merged into the 4.19
stable branch.The patch related virtio-scsi was not merged.
[1] 
https://lore.kernel.org/all/1553682995-5682-1-git-send-email-dongli.zhang@oracle.com/

This is the earliest discussion.
https://lore.kernel.org/all/e4afe4c5-0262-4500-aeec-60f30734b4fc@default/

I don't know if there are other circumstances that would cause it to
fall back into MSI-X with one shared for queues. At least the hack
method is possible.
> I wonder if PCIe actually allows this sort of thing.
Do you think the virtio driver should be modified?
> In any case, this sort of behaviour breaks so many thing in KVM's
> implementation that I'd recommend you disable GICv4 until we have a
> good solution for that.
There seems to be no restriction in the GIC specification that multiple
host irqs cannot be mapped to the same vlpi. Or maybe I didn't notice.
Do you think there are any risks?

GICv3 does not have this issue, but is this configuration legal?

Thanks,
Kunkun Jiang
