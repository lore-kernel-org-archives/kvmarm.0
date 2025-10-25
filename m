Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EC3129A78
	for <kvmarm@lists.linux.dev>; Sat, 25 Oct 2025 08:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761381739; cv=none; b=HVfup5OrAo9G/s+fpyEEBWP5lrK/5QbR2PamjEl0VEMLKO0MDFyBek2cgjgGnnI+FB0Ake/znu1gh/urUNPzQWCBncZDXTT4lgeUzQhHu67EIe7XCo7Gf5eLiwLqKZfuaiMN+9ZM980HhWvF/Ix6B6aNFD+EVa0+II8rp/FWjyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761381739; c=relaxed/simple;
	bh=luRicosIq9Qs1CooEWI2+9BgTdiuEQQ+a8ZQqsC/s2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SBQSIWRSDA5nRarW3+Fl6CXlmyhCfPUxlbtdIz/1P7eK+nBg8IYBh2f9DTWvANJT78IHZCgPE3Q//+6qhSgQw9fwBKC5gYKUXYS+LZsmpDd/X2Ggj10Rco3e+iBJMjRe336YncIsGc3mopqk0REjlRjouGaTqfBdA3p9Bgi/8sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cttXr5cXdznTVF;
	Sat, 25 Oct 2025 16:41:32 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 45481180044;
	Sat, 25 Oct 2025 16:42:12 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 16:42:12 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 16:42:11 +0800
Message-ID: <c29c67ce-8457-2545-ac1c-9ef00b92c7e4@hisilicon.com>
Date: Sat, 25 Oct 2025 16:42:10 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 0/7] Add support for FEAT_{LS64, LS64_V} and related
 tests
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	"Zhou Wang" <wangzhou1@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <2a880d79-9205-45d1-8f8d-9f028e0bbfb2@app.fastmail.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <2a880d79-9205-45d1-8f8d-9f028e0bbfb2@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/10/25 0:22, Arnd Bergmann wrote:
> On Fri, Oct 24, 2025, at 11:08, Zhou Wang wrote:
>> Armv8.7 introduces single-copy atomic 64-byte loads and stores
>> instructions and its variants named under FEAT_{LS64, LS64_V}.
>> Add support for Armv8.7 FEAT_{LS64, LS64_V}:
>> - Add identifying and enabling in the cpufeature list
>> - Expose the support of these features to userspace through HWCAP3 and cpuinfo
>> - Add related hwcap test
>> - Handle the trap of unsupported memory (normal/uncacheable) access in a VM
>>
>> A real scenario for this feature is that the userspace driver can make use of
>> this to implement direct WQE (workqueue entry) - a mechanism to fill WQE
>> directly into the hardware.
>>
>> Picked Marc's 2 patches form [1] for handling the LS64 trap in a VM on emulated
>> MMIO and the introduce of KVM_EXIT_ARM_LDST64B.
>>
>> As Yicong has left HiSilicon, I will help to continue to upstream this patchset.
>>
>> [1] 
>> https://lore.kernel.org/linux-arm-kernel/20240815125959.2097734-1-maz@kernel.org/
> 
> The patches all look reasonable to me, but I notice that you forgot
> to add your signoff below Yicong's, so the Arm maintainers won't be
> able to merge the series.>
> If nobody else has any comments on this version, please resend in
> a couple of days with your signoff added to each patch.

I will add my signoff in next version. In fact, comparing with v5, there is little
change, so I did not add my signoff.

Best,
Zhou

> 
>      Arnd
> .
