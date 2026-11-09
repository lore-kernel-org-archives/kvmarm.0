Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794218589;
	b=Z7Srp8nHUfYh4w+QdBADAKWzbHzbnYx4bRyAWDhiCEB3f1iaHEc3Dl8vXxSD7N+c2Wqa
	 FgBVVGUt5g0n0740aensqVl1U5ylC8kUWzVSqcSx+LCiNxGMQ+9ld5mHjWHIdBltNsNdA
	 YV7sTEbQmARO3BzmGy7ZAnrDrsaP93eU14/GeJYQW2n5Gyi6rEg6xjw3kmzOFUlj4r+S6
	 q8/1uej04+StgQRjoDh3xBZYW7hNctCEWtQBnENw3v4I3+RzqHc48HX0N5F2ULCttpb1H
	 XMLV+g4NSdVnIEcqyCqqHlykX4MvaAXXKNDebaNLEn8ihL04vTHE+7F666F9eKhC9cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218589;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=iX4fPWJ3wrDyEYnWwThFMw7+RnX+XZ2JJyz/prHQrn8=;
	b=smldu8Z3t3Q0r3mW+S7V/Nx/cgxWH9tuW+V5KLAyFnMhPy1UqbFIUNlOYWzH0cTt6PoE
	 Vra5pxU+CF9DgPqCcFdOImozIc0U9JtbEIp3+oCPhM2TS4taPBAFPs589I23eDbuWes7R
	 6MPUNlRweKlZpi5uZ8wGwxYR/FHNNqb/AOG6bOOOYeTcTof9Ms4L9PnMYG4H/IBPE39kJ
	 SWM57HW1ZkElLGbh4ejscSod3Q8aW2zvfw8YhxwNemS4kjnUeoB3vEhkcso/F1G6GClCe
	 goMClcxaxws5PJot9zSwstEABqm9N3t1GvHdQgwGvAYDMMrAbyOoARk57JDSZIOh44g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ljy90uPK;
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5828606A321;
	Mon,  9 Nov 2026 10:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5828606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=ljy90uPK
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iX4fPWJ3wrDyEYnWwThFMw7+RnX+XZ2JJyz/prHQrn8=;
	b=ljy90uPKntm7T55bKR3e4cTetba6+gNcSADhPBlPJqqUlK7aWTFeelD/3OaOSBVmAkGvCO9L/
	S5bidux3AxJcc11fWhgnNND5o7tbByvTtUuR9dIC8OhTmLApFdJRoHezovu5FF6S86uKo81xSuu
	CUWpgIkXQPprGDDzw9yw5Us=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jNQMb5DDYz12LCl;
	Mon,  9 Nov 2026 18:03:07 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 00BDF4057F;
	Mon,  9 Nov 2026 18:03:04 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 18:03:03 +0800
Message-ID: <494abfd0-b19b-4ef3-a035-d21626828a6a@huawei.com>
Date: Mon, 9 Nov 2026 18:03:03 +0800
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
To: <sashiko-reviews@lists.linux.dev>, Leonardo Bras <leo.bras@arm.com>
CC: <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oupton@kernel.org>, liuyonglong
	<liuyonglong@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-12-zhengtian10@huawei.com>
 <20260929110035.71FB41F000FF@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260929110035.71FB41F000FF@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/29/2026 7:00 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm64: kvm: UAPI breakage for dirty ring size on 64KB page systems
> --
> 
> commit 38dde0ab2f10c37402c620c7b1328624808205ad
> Author: Tian Zheng <zhengtian10@huawei.com>
> 
> KVM: arm64: Reserve dirty ring space for the HDBSS buffer
> 
> This commit reserves space in the dirty ring for CPU-side dirty buffers by
> implementing kvm_cpu_dirty_log_size(). It also pins the HDBSS buffer size to
> PAGE_SIZE when the dirty ring is enabled.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 7bf82d65041c8..c1e09ba98d48a 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
> [ ... ]
>> @@ -2841,3 +2841,11 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>>   
>>   	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>>   }
>> +
>> +int kvm_cpu_dirty_log_size(struct kvm *kvm)
>> +{
>> +	if (!system_supports_hdbss())
>> +		return 0;
>> +
>> +	return kvm_hdbss_buffer_size(kvm) / sizeof(u64);
>> +}
> 
> [Severity: High]
> Does this calculation break the UAPI for standard dirty ring size requests on
> 64KB page systems?
> 
> Since KVM_ARM_HDBSS_DEFAULT_SIZE is tied to PAGE_SIZE, this calculation scales
> with the system page size. On a 64KB page system, kvm_hdbss_buffer_size() yields
> 65536 bytes, returning 8192 reserved entries (65536 / 8).
> 
> When a userspace process requests a standard dirty ring size of 65536 bytes
> (64KB) via KVM_ENABLE_CAP for KVM_CAP_DIRTY_LOG_RING, it seems the ioctl will
> now fail:
> 
> virt/kvm/kvm_main.c:kvm_vm_ioctl_enable_cap() {
>      ...
> 	if (size < kvm_dirty_ring_get_rsvd_entries(kvm) *
> 	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
> 		return -EINVAL;
>      ...
> }
> 
> Because (8192 + 64) * 16 = 132096 bytes is greater than the requested 65536
> bytes, the ioctl rejects previously valid userspace configurations with -EINVAL,
> which would cause QEMU and other VMMs to fail to start VMs.
> 
> Could this buffer size be decoupled from PAGE_SIZE to avoid the entry inflation
> and ABI breakage on 64KB page systems?
> 

You were right, this is a real UAPI break on 64KB-page kernels. The
PAGE_SIZE default made the ring reservation scale with the kernel page
size, so a standard 64KB ring request got rejected there.

Leo, the PAGE_SIZE default goes back to your suggestion in the v4
discussion at [1]:

 > That means 512 entries in 4kB pagesize, an 8K entries in 64kB
pagesize.

 > I mean, yes, maybe we could allocate a 64k page, and set SZ=4K in
HDBSSBR, but that would be a waste of memory, right?

If we keep PAGE_SIZE, the ring ABI stays broken on larger-page kernels,
since the reservation keeps scaling with the page size. With SZ_4K there
is still some breakage, the smallest ring sizes (4KB and 8KB), but that
is the smallest scope we can get, because 4KB is the smallest buffer the
hardware can encode. Defaulting to SZ_4K also brings our ring
requirements in line with x86, where PML reserves the same fixed 576
entries.

Do you think we should default to SZ_4K and accept the page waste you
pointed out, or keep PAGE_SIZE?

[1] https://lore.kernel.org/all/amocrs9ZiCi7uErp@LeoBrasDK/

Thanks,
Tian
