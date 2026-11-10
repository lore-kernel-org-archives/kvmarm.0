Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272836;
	b=d1AKpLmnfqaOQnwCc7+3q7SH1DdMoICchuctfV2r0OSvoDYbHn3pcR2gCMZWWK+h/vsJ
	 N0Ylq6XpTz6hPElHQ/i5vyBjEAbB1VAAaMUwrWL+EoSuTic4XBzIxfevryDvyEkKf6t66
	 SwE9eT186nLrokj4BbAK0tZ6cm1KQPhHTD33/2zL5pXLXBbAD7hg1dihMpL+Vj3zf/Ukv
	 5Tbm8eANfSGPRvDjuhl2fRdTxm3SssvjyU54FepMc9P7RVkZFWlc+bQhJAlJeF5XBGiSx
	 pgoo7WJyOlqozQiFZi7z/kOk2NR7gWVk7cqVMSQNjrReAZ9wWRgSmdpD0wG6QHIVNMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272836;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=AA4e/95fbAm29CcIL61TsgvVzn4oBxp+/bcnK79b1/I=;
	b=2y7xonp9xSf2Win6171bYM53tUF+8F6mCy/qDFWWnROzLJXyFn/WELSvxglbQCFb7Wdu
	 zsi2RueNhhZFyj2clAh7T+16hZ1/nRfl4504eeFPGOsKxKsANllVO+zipk/UCe1on/nMD
	 WuLQeBOiTTrVYyKsLZYVsFKxOfrq+m9s2BOFEMFrLuBjDWkKxnQQIPbqCoOlX9O+LcTQQ
	 AxtoGO4eTzIHcdF+3plom1NtCof/f+nLZ/WFxtBzBgtQMXpgALlDy62nEZXwOCw5Qa9/B
	 LomNmMKhInErATGu3ilZ8f9hSMcQy4rwTLI1q8prLCcTKcJ3+jGWJmOxokZuWmmueuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=za9EC74p;
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAB9606A331
	for <kvmarm@lists.linux.dev>; Tue, 10 Nov 2026 01:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DAB9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=za9EC74p
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AA4e/95fbAm29CcIL61TsgvVzn4oBxp+/bcnK79b1/I=;
	b=za9EC74pTHdI2rna0DdXk9IEvtvfJmWHwkIZSNcKEQeh1gjHQqInj0oAZv5qJOBMf/qsknc4D
	47+pqMBhc8NzrAmF+oq9MkAuvsBzk9cJ/bd14JRi0DwK8uJvud9Eb5qe/M+Rg70vrg3hF1h5/qA
	YEZKS8zpPRJ0shLwK4QPjCg=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jNpQS6DQsz1cySM;
	Tue, 10 Nov 2026 09:06:56 +0800 (CST)
Received: from kwepemk300013.china.huawei.com (unknown [7.202.194.231])
	by mail.maildlp.com (Postfix) with ESMTPS id 84FA34048B;
	Tue, 10 Nov 2026 09:07:11 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 kwepemk300013.china.huawei.com (7.202.194.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 10 Nov 2026 09:07:10 +0800
Message-ID: <2feaca55-e2f5-4494-b13a-3790efa1eb81@huawei.com>
Date: Tue, 10 Nov 2026 09:07:00 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Register irq_bypass consumers only with GICv4
To: Oliver Upton <oupton@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <maz@kernel.org>, <fuad.tabba@linux.dev>,
	<yuzenghui@huawei.com>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <liuyonglong@huawei.com>,
	<wangzhou1@hisilicon.com>, <prime.zeng@hisilicon.com>,
	<tangchengchang@huawei.com>, <zhengtian10@huawei.com>, <linuxarm@huawei.com>,
	<liujian222@huawei.com>
References: <20261109112018.241298-1-yangjinqian1@huawei.com>
 <avH9KJ99im5Z2wEb@kernel.org>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <avH9KJ99im5Z2wEb@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk300013.china.huawei.com (7.202.194.231)

Hi,

On 2026/11/10 1:04, Oliver Upton wrote:
> Hi,
> 
> On Mon, Nov 09, 2026 at 07:20:18PM +0800, Jinqian Yang wrote:
>> kvm_arch_has_irq_bypass() on arm64 returns true unconditionally, so
>> every irqfd assignment registers an irq_bypass consumer even when the
>> hardware cannot perform GICv4 direct MSI forwarding. In that case
>> kvm_vgic_v4_set_forwarding() bails out at its very first check, since
>> vgic_supports_direct_msis() is false without has_gicv4, and the
>> registration becomes pure overhead: every KVM_IRQFD ioctl takes the
>> global irq_bypass mutex, which becomes a contention point when many
>> VMs boot concurrently.
>>
>> Gate the registration on kvm_vgic_global_state.has_gicv4, the way x86
>> gates on enable_device_posted_irqs. Functionally this is a no-op:
>> without GICv4 the consumer registration never did anything beyond
>> acquiring the lock.  On a GICv3-only host booting 100 microVMs
>> concurrently this cuts the average boot time by ~5 ms, matching the
>> gain observed with CONFIG_HAVE_KVM_IRQ_BYPASS=n.
>>
>> Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 97332ffcb130..785d57388032 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -1744,7 +1744,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>>   
>>   static inline bool kvm_arch_has_irq_bypass(void)
>>   {
>> -	return true;
>> +	return kvm_vgic_global_state.has_gicv4;
>>   }
> 
> This should just take a pointer on struct kvm then use
> vgic_supports_direct_msis() since having an initialized irqchip is a
> precondition of kvm_irqfd_assign().
> 
Yes, vgic_supports_direct_msis() is used as the gate in
kvm_arch_irq_bypass_add_producer->kvm_vgic_v4_set_forwarding, and
kvm_arch_has_irq_bypass should be consistent. This will be modified
in the next version.

Thanks,
Jinqian
