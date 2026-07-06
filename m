Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB1B35839C
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 03:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783308637; cv=none; b=R+E2ng/MvyDV0VyuSkRXB1MtVM7qJCaaea+myAYEjIaAWIKCVETrOSbotcVvPFBkh++++pDhfmrOtczMs19GUiuC1UcvqjCv/V4Nf6LIKKKlVMtHDOWtwuMWgOu5Q6UpmJAgK96NxST/04mil0RCqVKSQKKM3Csrzk/nthk0Z64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783308637; c=relaxed/simple;
	bh=oeDFtJqPPkIfeXsJxq7Iw1OJTnUGE3bv41tKkXFbJkE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=chDYhBRjAKCF/idoQfVaoNTLhXhhv00lORUv0qp0pcgGmUD58PQJuLuW4tN+NAv0plzPjsXPqX9uE4dEkZxQgoJ/fePN7TqkUk9e1VIX2Ij9nTvvm7pGUOcmNWJkjNrjMScm7mz6LohRgrtnmhciMc6pbnT7EIw+GaAgkGMKgIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=tF3qCKhL; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="tF3qCKhL"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ni1f8BldCx7faqIHDSsy647pWPJEZK7CSd6Q/V6Yajg=;
	b=tF3qCKhLy8MJplT3WXZidmCJ9frXH7RmXhqPccoYAmfW6nQmPpIeLtqYa1ioADuyX/iYjZUps
	NvydI4k2aE7zY9yIYA9aD/UbHEyECECDMMEImMoWQVECzZcEFsrhbFj8BFd5CrUbMffh+iY2R5K
	7ZeSiixi5FMZIdnzNJaWR/M=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gtqQl3j7Qz12LJx;
	Mon,  6 Jul 2026 11:21:51 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 008FE40577;
	Mon,  6 Jul 2026 11:30:32 +0800 (CST)
Received: from kwepemq500001.china.huawei.com (7.202.195.224) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 11:30:31 +0800
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemq500001.china.huawei.com (7.202.195.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 11:30:31 +0800
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
To: Wei-Lin Chang <weilin.chang@arm.com>, Marc Zyngier <maz@kernel.org>,
	<oupton@kernel.org>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: "guoyang (C)" <guoyang2@huawei.com>, "huanglingyan (A)"
	<huanglingyan2@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
From: Tangnianyao <tangnianyao@huawei.com>
Message-ID: <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
Date: Mon, 6 Jul 2026 11:30:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500001.china.huawei.com (7.202.195.224)



On 7/6/2026 1:28, Wei-Lin Chang wrote:
> Hi,
>
> Let me try to answer this:
>
> On Sat, Jul 04, 2026 at 03:45:56PM +0800, Tangnianyao wrote:
>> Hi, all
>>
>> I'm trying to understand the TLB and I-cache invalidation in
>> `kvm_arch_vcpu_load()` that is intended to "guarantee that both TLBs and
>> I-cache are private to each vCPU".
>>
>> As I understand it, when `VTTBR_EL2.CnP == 1`, `__kvm_flush_cpu_context()`
>> only performs a local TLB and I-cache invalidation, which does not seem
>> sufficient to guarantee that property.
>>
>> In fact, even if the invalidation were extended to the Inner Shareable
>> domain, it still seems difficult to guarantee “TLBs and I-cache are
>> private to each vCPU”, when `VTTBR_EL2.CnP == 1`, as long as multiple
>> vCPUs from the same VM may be running concurrently on different PEs.
> I think you have missed that when 2 stages are involved, both stages
> have to set CnP == 1 in order to share TLB entries (Arm ARM R_ZVRZW).
> So if TLB entry sharing happens, the guest kernel must have allowed it
> in the first place (by setting TTBR0/1_EL1.CnP == 1), hence accidental
> sharing that you are worried about won't happen.
>
> __kvm_flush_cpu_context() is solving problems that occur when multiple
> vCPUs of a VM are multiplexed on a single physical CPU.

Thanks for you answer.

If guest kernel allow TLB shared across CPUs by setting TTBR0/1_EL1.CnP == 1,
does kvm still need to guarantee that TLBs are private to each vCPU?
 

>> So I have two questions:
>>
>> 1. What is the rationale behind the comment that "guarantee that both TLBs
>> and I-cache are private to each vCPU"?
> I assume you are asking why keeping both TLBs and I-cache private per
> each vCPU is required. The fundamental answer is that each physical CPU
> is expected to have its own TLB and I-cache, so we must uphold that
> property for vCPUs as well. vCPUs can be scheduled on the same physical
> CPU, and use the same physical TLB/I-cache, obviously, so extra
> invalidations need to be done.
Let's assume that both Stage-1 CnP and Stage-2 CnP are enabled.

As I understand it, the architecture permits TLB to be shared by multiple
PEs within an Inner Shareable domain. Right?

If an implementation allows TLB entries to be shared in this way, it seems
that the current invalidation performed by kvm would no longer be sufficient
to guarantee that TLBs are private to each vCPU.

>
> As for how this can go wrong without __kvm_flush_cpu_context(), you can
> look at commit 94d0e5980d67 ("arm/arm64: KVM: Perform local TLB
> invalidation when multiplexing vcpus on a single CPU") and commit
> 01dc9262ff57 ("VM: arm64: Ensure I-cache isolation between vcpus of a
> same VM"). The commit messages and the linked thread explained the
> problems pretty well for me.
>
>> 2. Should the effect of `VTTBR_EL2.CnP` be taken into account when
>> reasoning about this guarantee?
> Please see the first part of the answer.
>
> Hope this helps!
>
> Thanks,
> Wei-Lin Chang
>
>> Thanks
>> Nianyao Tang
>>
> .
>
Thanks
Nianyao Tang
