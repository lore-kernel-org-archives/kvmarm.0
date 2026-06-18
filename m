Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88492E62D9
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781747601; cv=none; b=awB+0FbBOI2aW/q9x33UZ+2DYzA+n5SFp70bM8K+T0iYaKGwPiXH3+w2ouO4kMOf8gWJuOjlxhLLVeEqdLxOb8F7LvD+e+fkgg8u0Zfpf2uyQ2CnT3Yb72tipkhf3PZGZ/cfrnyrD4PYkiPi4U+9xjNwmhZ5U+itjq2+GaaZxO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781747601; c=relaxed/simple;
	bh=Hcc23D1q9nY6KeBD9c4ZLceM+isPNUT/sbG7Ak1FYks=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Or+nETrMrS5EY0V8Ms5WeDhSZyiyDvB8X9j3I4QccEzPS03n/Zf3Dfzit9nliyou4VJAG2Q6hH5Jum9aMERsiiokscpzLt4NtZRkqV5yKyTk2EzvT6vpi2nnpb7XO39aqk2aN3Crr/kLjXWG8gS53oeaI1CtSFOBgWafXAVDcXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ovFV3Jzh; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ovFV3Jzh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=baDTuvvK2rnBrTQYWqm7ATQZOTdxwB6p+v1mQB0ln0U=;
	b=ovFV3JzhO8N/0lbfun2Dcbo+s3uduzoqK6QFiVNFlaRGSRIEv7jpAN6XoJ/16TPzR05Bm0y3K
	q0Q304PdA32b4ir8vfHLLV/ktI355N4ho4ZwfONYG/0uu4IaRlj7h7Kg7ymGFOpS9QcGSyGrSLy
	tIfTWIw3ciHOxrbyGqYCBH8=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4ggk7d4TTKzRhRL;
	Thu, 18 Jun 2026 09:45:17 +0800 (CST)
Received: from kwepemo100012.china.huawei.com (unknown [7.202.195.139])
	by mail.maildlp.com (Postfix) with ESMTPS id 5E8B340538;
	Thu, 18 Jun 2026 09:53:16 +0800 (CST)
Received: from [10.67.120.222] (10.67.120.222) by
 kwepemo100012.china.huawei.com (7.202.195.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 18 Jun 2026 09:53:15 +0800
Message-ID: <6dca2d6e-54d0-42c4-95df-45a30a473e0b@huawei.com>
Date: Thu, 18 Jun 2026 09:53:15 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 15/20] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
To: Colton Lewis <coltonlewis@google.com>, <kvm@vger.kernel.org>
CC: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Russell King
	<linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, Joey Gouly
	<joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, Shuah Khan
	<shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	James Clark <james.clark@linaro.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-perf-users@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, wangyushan <wangyushan12@huawei.com>, Zhou
 Wang <wangzhou1@hisilicon.com>, <xuwei5@huawei.com>,
	<prime.zeng@hisilicon.com>, <fanghao11@huawei.com>
References: <20260504211813.1804997-1-coltonlewis@google.com>
 <20260504211813.1804997-16-coltonlewis@google.com>
From: wuyifan <wuyifan50@huawei.com>
In-Reply-To: <20260504211813.1804997-16-coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo100012.china.huawei.com (7.202.195.139)

Hi Colton,

On 5/5/2026 5:18 AM, Colton Lewis wrote:
>   static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>   {
> -	u64 pmovsr;
>   	struct perf_sample_data data;
>   	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
>   	struct pt_regs *regs;
> +	u64 host_set = kvm_pmu_host_counter_mask(cpu_pmu);
> +	u64 pmovsr;
kvm_pmu_host_counter_mask() is called from armv8pmu_handle_irq(). This
interrupt fires in both host and guest contexts.

However, kvm_pmu_host_counter_mask() dereferences
host_data_ptr(nr_event_counters). This indirection requires
kvm_arm_hyp_percpu_base[cpu] to be initialized, which only happens during
KVM hypervisor setup. When the interrupt fires in a guest kernel where 
KVM is
compiled but not active, the per-CPU base is NULL and the dereference 
faults.

Thanks,
Yifan

