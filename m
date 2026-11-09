Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794206273;
	b=F/fDMFsW0pil/H0+yMigntIjvA2NASQ45mp5gESW3UsID+dVESdna7NyPrNiduxhjhcC
	 ZnuADR7zq0k/m50XL2/Tkv9JzXPfFYrZF7yCwR5HKkhw3u1L5LMxkYOhP8UKo/5VjenF7
	 +gDSQHDiAe2HNB1noZa3Kz+HkAHC8WoMW4oppPjcUw3sFz8JQ+KoAbNBPzZENeFdMeKZM
	 1Oztes5RT19ZX3cjbhMUf8OMCx3FPUSmaveMnsveMN4QzNjd8S7yrQvHL/6k+9AKFWGAn
	 HaiUaNd4V9tSgfDsSX4bQl+yfYJKqGWCuV+kwlNPqkhDg4x/v8KR28VKfoZeElO44dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794206273;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=M/P3nZUlrFGneC24aMKHBNIgNzRFeJqMlKbeTayIEIA=;
	b=SSMnCim8BgYEvsH/e6kUyyIjEHd7x6SnwbZGfRlJVJ2x0uLssIhbOoQFkFIjuTNUE9xx
	 gsusMOv2CO1wgCKAj+8W1o3w+/xhicffh6CpFoSg5c4ChngejweUiAiXLXsuRDgJZv77g
	 U6jtDRtLJtsqDc1Q8HeRk4aye8r2tYezi6IdVuZAE+Og0bnD/VmMxGyNUPIHALgyvHSXN
	 Uw5o+Sji6RRfGj8nb4E//niKvWi+V0xcBvTjC+ORhNlVDEdH8Da+E14B28hzTFkbwiUOK
	 D0KmNMBEN9ez8NHrtYxVt44iJzJ5iqyIkDyLxcXpNpiELzhyezCbErW9N7MArQVmgVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=KsfyCOJG;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651E4606A31C;
	Mon,  9 Nov 2026 06:37:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 651E4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=KsfyCOJG
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=M/P3nZUlrFGneC24aMKHBNIgNzRFeJqMlKbeTayIEIA=;
	b=KsfyCOJGtiNRpFJjcgoVwtHWHcYYl2M0rJcG4aTEiQ4vQN/T+AK5ESqu6qn6wq1eVQi6QOkaK
	U4QViRgwRg3zzCBvwrVbgSKybvs1835guGKNoV+4bV3diqSLYhXaZm+HQRe9hbiLi/IPn5niTG7
	RgKhQ+BmplOe9Sgp3twPCqo=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jNKnz4dslzcb4l;
	Mon,  9 Nov 2026 14:37:11 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 6333540538;
	Mon,  9 Nov 2026 14:37:47 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 14:37:46 +0800
Message-ID: <d69dd4b6-2590-4a9d-91a2-1ff24d55723f@huawei.com>
Date: Mon, 9 Nov 2026 14:37:46 +0800
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
Subject: Re: [PATCH v5 10/15] KVM: Add kvm_arch_dirty_ring_size_updated() hook
To: <sashiko-reviews@lists.linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>,
	<kvm@vger.kernel.org>, Oliver Upton <oupton@kernel.org>, liuyonglong
	<liuyonglong@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-11-zhengtian10@huawei.com>
 <20260929105253.0A2031F000FF@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260929105253.0A2031F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/29/2026 6:52 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] kvm: missing kvm_arch_dirty_ring_size_updated() stub causes build failure
> --
> 
> commit 78c5608c44701deb8c1679c3f53cbd1303655474
> Author: Tian Zheng <zhengtian10@huawei.com>
> 
> KVM: Add kvm_arch_dirty_ring_size_updated() hook
> 
> This commit adds a kvm_arch_dirty_ring_size_updated() hook called right
> after kvm->dirty_ring_size is recorded. It provides a weak no-op default
> implementation for architectures to override.
> 
>> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
>> index eb10d87adf7d5..c2b922791530d 100644
>> --- a/include/linux/kvm_dirty_ring.h
>> +++ b/include/linux/kvm_dirty_ring.h
>> @@ -73,6 +73,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
>>   #else /* CONFIG_HAVE_KVM_DIRTY_RING */
>>   
>>   int kvm_cpu_dirty_log_size(struct kvm *kvm);
>> +void kvm_arch_dirty_ring_size_updated(struct kvm *kvm);
> 
> [Severity: Low]
> Does this cause a build failure on architectures that do not define
> CONFIG_HAVE_KVM_DIRTY_RING?
> 
> The prototype is placed inside the #else block (when the feature is
> enabled), but there is no static inline stub provided in the #ifndef
> block. Furthermore, virt/kvm/dirty_ring.c (which contains the weak
> definition) is not linked when the config is disabled.
> 
> [ ... ]
> 
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 85f42289748dc..d109062f6a1cf 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -5011,6 +5011,7 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
>>   		r = -EINVAL;
>>   	} else {
>>   		kvm->dirty_ring_size = size;
>> +		kvm_arch_dirty_ring_size_updated(kvm);
>>   		r = 0;
>>   	}
> 
> [Severity: Low]
> Since kvm_vm_ioctl_enable_dirty_log_ring() is unconditionally compiled,
> will calling kvm_arch_dirty_ring_size_updated() here trigger an implicit
> function declaration and link error on architectures like s390x or powerpc
> that do not enable the dirty ring?
> 

Right. This hook is entirely dropped in the next version. The HDBSS
buffer size is initialized at VM creation with PAGE_SIZE and the ring
reservation reads it directly, so there is nothing left to notify. This
report can be ignored.
