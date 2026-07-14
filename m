Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB3736654F
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 10:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784025596; cv=none; b=OOIWyKsY/+l90VKZfyEACPLbZb72qUyEPuyzx4tTb3BgVkER0WeqTG6N+/N8W03M3UaMF5mpdNnt+4n8athy1KiIeJirJC+SYRO7cH0j9iux9nRnwFmWEY8lVmFBjPshZ45GtLDfN8c63C7Pp7n+Sj4QBoWAYP+xBWEuCUX0p5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784025596; c=relaxed/simple;
	bh=qT5a7Scog9EUGrCpIaqnQGOjmudqKzb4AQhKnThKJgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eqZQnLkhWlZYPpFcUJwRb9PNVTIBx8zg0Slho6wVCwY2Od34Ht6H5V0B9Alc9r8I/gGf1djPVNzFgDdR2M93PdrcLz7QUpYNzItzZZ+DS7bMOvirt5oYQz3baieqZLO1lkSSk+LvKH7MeHFu1H/MPrWs5u+w9HTTGOwkjrwCuxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=SYsJTEr+; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="SYsJTEr+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IAete8H1tlB3Grr61O7HDMsWxM2tK05k7s9wYG7n6Ik=;
	b=SYsJTEr+k8ZNLMgYoSmtR9yUpBvNsHkdUaN01/RublG7P0jjYMoxn4G+ImU8pYBuf6gmY+ZjY
	oTobNEUCqX8IdUQiBG1rNr08ROnHObcfPm3fOIGAF0ZidzdK4A/0w4w29lZZTchwlokkcIJB66R
	hwawGRpUlLl6y2NeNxBZphw=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gzwYh22LWz1K96b;
	Tue, 14 Jul 2026 18:30:32 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id CADCF40563;
	Tue, 14 Jul 2026 18:39:48 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 14 Jul 2026 18:39:47 +0800
Message-ID: <fcc9e842-a6fd-418e-93ff-0475a542f3df@huawei.com>
Date: Tue, 14 Jul 2026 18:39:48 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/6] Support the FEAT_HDBSS introduced in Armv9.5
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <alS-kcwvlASwPIzL@LeoBrasDK> <alUR3ez1EKeWb_pM@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <alUR3ez1EKeWb_pM@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 7/14/2026 12:27 AM, Leonardo Bras wrote:
> On Mon, Jul 13, 2026 at 11:31:46AM +0100, Leonardo Bras wrote:
>> On Thu, Jul 09, 2026 at 06:40:20PM +0800, Tian Zheng wrote:
>>> This series of patches add support to the Hardware Dirty state tracking
>>> Structure (HDBSS) feature, which is introduced by the ARM architecture
>>> in the DDI0601 (ID121123) version.
>>>
>>> The HDBSS feature is an extension to the architecture that enhances
>>> tracking translation table descriptors' dirty state, identified as
>>> FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
>>> page tracking, aiming to significantly reduce the overhead of scanning
>>> for dirty pages.
>>>
>>> The purpose of this feature is to make the execution overhead of live
>>> migration lower to both the guest and the host, compared to existing
>>> approaches (write-protect or search stage-2 tables).
>>>
>>> The required sysreg definitions for FEAT_HDBSS have been merged into
>>> arm64 /sysregs:
>>>    [1/5] arm64/sysreg: Add HDBSS related register information
>>>          https://git.kernel.org/arm64/c/72f7be0c2e30
>>>
>>>
>>> After these patches, the kernel automatically enables HDBSS when dirty
>>> logging is enabled on any memslot, and disables HDBSS when dirty logging
>>> is disabled on all memslots. This series does not support dirty ring
>>> mode.
>>>
>>> Depends-on: "KVM: arm64: Enable eager hugepage splitting if HDBSS is available"
>>> 	https://lore.kernel.org/linux-arm-kernel/20260629111820.1873540-3-leo.bras@arm.com/
>> On this, FYI, there have been some discussion on this:
>> https://lore.kernel.org/all/alETGFD2Ogx6N0HB@LeoBrasDK/
>>
>> Oliver's suggestion is that we don't automatically enable eager splitting,
>> but instead we have different behaviours if the user enables it.
>>
>> This is still under discussion there, but I think it can be useful reading.
>>
>>> This dependency is mandatory. Unlike v3, where DBM was added lazily on
>>> the first dirty access via a page fault, v4 injects DBM into pgt->flags
>>> at stage-2 MMU initialization time. Combined with HDBSS being auto-enabled
>>> during migration setup, the first dirty access no longer triggers a page
>>> fault. Consequently, if lazy hugepage splitting were relied upon (which
>>> requires a page fault to trigger splitting), hugepages would never be
>>> split, leading to guest hang after migration. Leonardo's patch above
>>> ensures eager hugepage splitting is enabled (chunk_size != 0) when HDBSS
>>> is available, guaranteeing that hugepages are properly split before
>>> migration starts.
>>>
>>> v3: https://lore.kernel.org/linux-arm-kernel/20260225040421.2683931-1-zhengtian10@huawei.com/
>>>
>>> v3->v4 changes:
>>> - Merge sysreg definitions into the FEAT_HDBSS detection patch (was a
>>>    separate patch in v3).
>>> - Add auto DBM (Dirty Bit Modifier) support as a new patch, suggested
>>>    by Leonardo Bras. DBM is now controlled as a page-table level flag
>>>    (KVM_PGTABLE_S2_DBM) rather than per-PTE. Note that DBM is injected
>>>    at stage-2 MMU creation time, not lazily on first dirty access. This
>>>    means the first write to a dirty-logged page does not generate a
>>>    page fault, which is a key reason for the mandatory dependency on
>>>    Leonardo's eager hugepage splitting patch (see Depends-on above).
>>> - Split the v3 "Enable HDBSS support and handle HDBSSF events" patch
>>>    into three patches: per-vCPU buffer management, fault handling and
>>>    buffer flush, and auto enable/disable on dirty logging change. This
>>>    implements kernel-managed automatic HDBSS enable/disable.
>>> - Remove the KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl for manual HDBSS
>>>    on/off. HDBSS is now automatically enabled/disabled based on dirty
>>>    logging state via kvm_arch_commit_memory_region().
>>> - Change HDBSS buffer flush triggers to vcpu_put, check_vcpu_requests,
>>>    and kvm_handle_guest_abort.
>>> - Store hdbss_order at VM level (kvm->arch.hdbss_order) instead of
>>>    per-vCPU, since all vCPUs share the same order.
>>> - Document patch is not included in this version; will be sent in a
>>>    follow-up series.
>>>
>>> Leonardo Bras (1):
>>>    KVM: arm64: Enable eager hugepage splitting if HDBSS is available
>>>
>>> Tian Zheng (2):
>>>    KVM: arm64: Add support for FEAT_HDBSS
>>>    KVM: arm64: Add auto DBM support for hardware dirty tracking
>>>
>>> eillon (3):
>>>    KVM: arm64: Add HDBSS per-vCPU buffer management
>>>    KVM: arm64: Add HDBSS fault handling and buffer flush
>>>    KVM: arm64: Add auto HDBSS enable/disable on dirty logging change
>>>
>>>   arch/arm64/include/asm/cpufeature.h    |   5 +
>>>   arch/arm64/include/asm/esr.h           |   5 +
>>>   arch/arm64/include/asm/kvm_dirty_bit.h |  29 ++++
>>>   arch/arm64/include/asm/kvm_host.h      |  14 ++
>>>   arch/arm64/include/asm/kvm_pgtable.h   |   4 +
>>>   arch/arm64/include/asm/sysreg.h        |  11 ++
>>>   arch/arm64/kernel/cpufeature.c         |  12 ++
>>>   arch/arm64/kvm/Makefile                |   1 +
>>>   arch/arm64/kvm/arm.c                   |  29 ++++
>>>   arch/arm64/kvm/dirty_bit.c             | 219 +++++++++++++++++++++++++
>>>   arch/arm64/kvm/hyp/pgtable.c           |  35 +++-
>>>   arch/arm64/kvm/hyp/vhe/switch.c        |  15 ++
>>>   arch/arm64/kvm/mmu.c                   |  19 ++-
>>>   arch/arm64/kvm/reset.c                 |   4 +
>>>   arch/arm64/tools/cpucaps               |   1 +
>>>   15 files changed, 399 insertions(+), 4 deletions(-)
>>>   create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
>>>   create mode 100644 arch/arm64/kvm/dirty_bit.c
>>>
>>> --
>>> 2.33.0
>>>
> Also, please remember to include the base commit, so it can be applied for
> testing/reviewing.


Thank you for the reminder.

This patch series is based on:
- Commit: 0e35b9b6ec0f
- Description: Merge tag 'mm-hotfixes-stable-2026-07-06-17-49' of 
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Welcome to test and review — please let me know if you encounter any 
issues or have suggestions for improvement.


