Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962726;
	b=fpy/i6WuRyq8FICX0FhxT6hMtsp04NxLh9e0tZfV5KSSEBGwC8Q3AI93W+Jx1pUk+gvK
	 NW1FlWH/elnk6fEK9Hl6oQLMOsvIPlDHP7zpW2PpuiCD0LyZiwwaPVO3NKkFFYOZ1IPpX
	 kl5EL1hcwUlq1Y6vqwY+aiBb6koyeYexiNXhHP4YgpKr5a1bS/CIWojnshEClx96xRKcj
	 FgFgO6+iMumyCjmC+A0cILl+3GLaLw3sO72rmgC/osqIZ9naKMPMvxj3Z/PMXMbYjPAg8
	 sBNQbhakJ06BEX6gWHwR/p8YE2EcStMD+dgHzQF8XfAF4DAPJTgGpIzNv4H1sK1whGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962726;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=sLxoX/xGM4YEFLDgABxSGGVYnv6fei/9Pdkk4WOrexg=;
	b=Rt83+Ah6JPmnpBbWk/VPDKKVs+rIhN+hoGXfa1MuqxLOCXTVs/nBMIKj4HUG65zLO6e1
	 CmoLwLiCmCYTxY8t/SfJvhwsL7eGWiRN1FVpacAh9t10lwrkKPQJbCfdQyJPHD2H939Q6
	 4Ophc0x1vTKF/te/BC7SxIkT8GWl3E2H5hUq7fhsnN2r0V2Vgn45mTXLi1Q04/T0cQqMZ
	 EGu0QVph9vqUfAmnsucIfA8gowrAamIPyvPs89JRligdCtY16V/kfZQeQ9pMkF79q8++C
	 Cbj7mzkkXZ4vAWAHgLx5Kdd9Op3qhhsREwHhLKPFSxw+jIueObml4JaVAmsy8OdKguA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B7606A329
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 10:58:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD2B7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sLxoX/xGM4YEFLDgABxSGGVYnv6fei/9Pdkk4WOrexg=;
	b=HfddygcsmSFjZ7r1uF9l62jBa/RqnD9fLiGkNdpef7L/WUg7dn1oZ6A8fS0gGE6RJVeZqy4NK
	mmjftzTjVFOkwAihzKUwb4iwmzsk0o75bt7+FF1O5P2jkjRmRbtdrG2NCBuTeJozhCN6wvW3vKF
	3ZQvflsXM3ZZtMUJ3H2dXyU=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jLbkl2XsRzLlrZ;
	Fri,  6 Nov 2026 18:58:23 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 74BC140565;
	Fri,  6 Nov 2026 18:58:35 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 6 Nov 2026 18:58:34 +0800
Message-ID: <dea2458f-067a-4712-87ca-c56abf69aadb@huawei.com>
Date: Fri, 6 Nov 2026 18:58:33 +0800
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
Subject: Re: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the
 HDBSS buffer
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-12-zhengtian10@huawei.com> <auikG0clmr19sAjh@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auikG0clmr19sAjh@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 11/2/2026 10:54 PM, Leonardo Bras wrote:
> On Tue, Sep 29, 2026 at 06:36:51PM +0800, Tian Zheng wrote:
>> The dirty ring reserves room for CPU-side dirty buffers via
>> kvm_cpu_dirty_log_size(). Report the HDBSS buffer entry count
>> through it, so a full buffer flush always fits in the ring.
>>
>> Pin the HDBSS buffer size to PAGE_SIZE when dirty-ring is enabled,
>> via kvm_arch_dirty_ring_size_updated(): a larger buffer only
>> shrinks the soft_limit and forces more frequent userspace drains.
>>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/kvm/arm.c | 8 ++++++++
>>   arch/arm64/kvm/mmu.c | 8 ++++++++
>>   2 files changed, 16 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 9d7bdece149a..5a7046acb62e 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -215,6 +215,14 @@ static int kvm_arm_default_max_vcpus(void)
>>   	return vgic_present ? kvm_vgic_get_max_vcpus() : KVM_MAX_VCPUS;
>>   }
>>
>> +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm)
>> +{
>> +	if (!system_supports_hdbss())
>> +		return;
>> +
>> +	kvm->arch.hdbss_buffer_size = KVM_ARM_HDBSS_DEFAULT_SIZE;
>> +}
>> +
> 
> On the same subject as a previous patch:
> I don't think this is the best approach, on top of adding a new weak
> function to take care.
> 
> Maybe during the dirty-ring allocation, on vcpu creation, we could take
> into account the requested dirty-ring size, and just allocate the HDBSS
> buffer taking that into account. That would make it simpler, don't you
> agree?
> 
> Thanks!
> Leo

Hi Leo,

Same answer as I explained in [1]. Anyway, I'll remove this function.

[1] 
https://lore.kernel.org/all/afcbf19b-bd13-4afc-ab56-8bc50c793e50@huawei.com/

Thanks,
Tian
