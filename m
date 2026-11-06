Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960864;
	b=2bC0s1BD/Gsv8nm/2ry35tFcCz2Z7hsvUJNpR++KnHXUg4ULEvnD0MbauHKbPli0+afy
	 aYBUhOtg452OqZRtykgoCiQsiniwit7fVUdANnRxiF6t2bJyjdDb0qYcOJRmOjNGH/zjT
	 WE3+SAg2RAqPwnhDXmeYOm8WaiVoB4NE9dvtWx4b4zR2qpqHSbNpIIWQhKGNPLCXfCrMB
	 I/6luRuWVFDXWt5yjh0BmaWzi6B+hz7vOmfIkC6B64CrI3QRLqQtT6Y8kCtgonSK7kqmq
	 1Pcjbwrsv3j5yDo0fAHw3uo5piltB0HNxjbYI9RSL5H+MI6nLF9xx9SjakNigSxyQNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960864;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=SxUZdl1nxNmZdMNHl/mAId5VPOOSyhyBaIunfeJwQ5s=;
	b=U1j4+UWF6ZjxGBflDhnSuRUOMme5eBfeykuu7lfn7D9oWheup6H2LBz/EJPM5aZmqIXY
	 vleXLhfTdjWDZsMl8duUbJ4nMtl3QfbCqNA98QSD/B6vA4Jg/wSUdUExE9g+33JHrSSlY
	 y2Dbs9G9r4WqAZgHKi9/8wzHJZcE9ybZSqQj/AoKpgfkHD2YxrNwhYZax21rvGzRNwJtJ
	 5+H1vDMBkHAIRGRSnUPO90ZiOIIgKd1UCwPmw/yzaE/dhNbMxUIZ43BligyvQPxVEq3sH
	 D9pLJpBAEc6ZXnISIMwwyovq6Ym2XKHQaiMarxAhXqrCs9TInz0fH2HOyeIT7yAT4Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=h53tQAGQ;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A35C606A32D
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 10:27:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A35C606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=h53tQAGQ
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SxUZdl1nxNmZdMNHl/mAId5VPOOSyhyBaIunfeJwQ5s=;
	b=h53tQAGQkAc6oUDOj1QWs7jrAmp3A7l4aeZkvG4ny3FjBaa0BPtLnE9b1YH4Wi3QdvU+wQqJU
	R/iZycLsdkiiUeQ73aC4bqFkUWlwU65f0HQ+xed9nr0AW0Rx9rnG98M0+I7MjNm+oGkad21luYh
	jTSKQsEtgoATxj4BULMkQB0=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jLb2X2gsXzpSwn;
	Fri,  6 Nov 2026 18:27:00 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 0467B4063F;
	Fri,  6 Nov 2026 18:27:29 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 6 Nov 2026 18:27:27 +0800
Message-ID: <5a096cca-713a-4449-83dc-c763dc06c085@huawei.com>
Date: Fri, 6 Nov 2026 18:27:27 +0800
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
Subject: Re: [PATCH v5 13/15] KVM: arm64: Add HDBSS buffer size ioctl for
 dirty-bitmap mode
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
 <20260929103655.85107-14-zhengtian10@huawei.com> <auioRICO9Frhk-zT@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auioRICO9Frhk-zT@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 11/2/2026 11:12 PM, Leonardo Bras wrote:
> On Tue, Sep 29, 2026 at 06:36:53PM +0800, Tian Zheng wrote:
>> In dirty-bitmap mode, a larger HDBSS buffer lets the guest dirty more
>> pages between VM exits, at the cost of memory. The default of one page
>> per vCPU is a reasonable starting point, so allow userspace to opt
>> into a larger buffer via KVM_CAP_ARM_HDBSS_BUFFER_SIZE.
>>
>> The size is specified in bytes through KVM_ENABLE_CAP and must be a
>> power of two in [PAGE_SIZE, SZ_2M]: the upper bound is the largest
>> HDBSSBR_EL2.SZ encoding, and the power-of-two requirement matches the
>> buddy allocator. It must be set before any vCPU is created: -EINVAL
>> after vCPUs exist, -EBUSY if already set.
>>
>> The capability is rejected in dirty-ring mode, where the size is
>> pinned by kvm_arch_dirty_ring_size_updated().
>>
>> KVM_CHECK_EXTENSION returns the configured size for a VM, or SZ_2M
>> when queried globally with a NULL kvm.
>>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/kvm/arm.c     | 34 ++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h |  1 +
>>   2 files changed, 35 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 5a7046acb62e..eadbf3a88d31 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_irqfd.h>
>>   #include <linux/irqbypass.h>
>> +#include <linux/log2.h>
>>   #include <linux/sched/stat.h>
>>   #include <linux/psci.h>
>>   #include <trace/events/kvm.h>
>> @@ -203,6 +204,31 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   		r = 0;
>>   		set_bit(KVM_ARCH_FLAG_EXIT_SEA, &kvm->arch.flags);
>>   		break;
>> +	case KVM_CAP_ARM_HDBSS_BUFFER_SIZE: {
>> +		u64 size = cap->args[0];
>> +
>> +		if (!system_supports_hdbss())
>> +			break;
>> +		if (kvm->dirty_ring_size)
>> +			break;
>> +		if (size < KVM_ARM_HDBSS_DEFAULT_SIZE ||
>> +		    size > KVM_ARM_HDBSS_MAX_SIZE)
>> +			break;
>> +		if (!is_power_of_2(size))
>> +			break;
>> +
>> +		mutex_lock(&kvm->lock);
>> +		if (kvm->created_vcpus) {
>> +			r = -EINVAL;
>> +		} else if (kvm->arch.hdbss_buffer_size) {
>> +			r = -EBUSY;
>> +		} else {
>> +			kvm->arch.hdbss_buffer_size = size;
>> +			r = 0;
>> +		}
>> +		mutex_unlock(&kvm->lock);
>> +		break;
>> +	}
>>   	default:
>>   		break;
>>   	}
>> @@ -500,6 +526,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   		else
>>   			r = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
>>   		break;
>> +	case KVM_CAP_ARM_HDBSS_BUFFER_SIZE:
>> +		if (!system_supports_hdbss())
>> +			r = 0;
>> +		else if (kvm)
>> +			r = kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
> 
> This whole thing of allowing hdbss_buf_size to be set only once makes
> everything more complex. Why do we have this limitation again?
> 
> I mean, if we want to restrict size changes after the first hdbss buffer
> gets allocated, it makes sense, other than that, I would like to understand
> the reason for that.
> 
> Thanks!
> Leo

Hi Leo,

You're right, I re-examined the whole flow and the "set once"
restriction isn't actually needed. I'll remove it.

Thanks,
Tian

