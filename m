Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA66337CD32
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 06:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780554777; cv=none; b=c0D9kAHHLN1axdd0MN4n7vX9B9ERQNsOCdlC21qE5UMDoN0GB/g4fEv3zsqPbOwytG/SfIfWANlnoWB+PXz4U6fb4lZlWFxr265orrL78y+tr8K5Fj9AZPdQV0fr8Y5beyiZx9OgAmiipMszWq9B+PF3KJjYeQJeUbJTUDz63OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780554777; c=relaxed/simple;
	bh=Oq67/ekAxSmlEO8Eo1GFQHj2gqE5o4g1TRGNTm7oyX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bUhT9cfcloYgX2PtzhNizuTNwuRZuou0QxotETX4sHYEKL7zaPwF02g5l0GtzexQBgJV3mGVkXXpnKmgzooB4pnxLbSmDpczyAHJPa+e0H3XXjILiBPqCw7hf6Vs90XoDBDKpbuOgVtcLSUAGSJUR+mDStfJVWfT7+otDcGBgnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=g6RQT3Lh; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="g6RQT3Lh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lICtzYs1mFPyTgDgLvlv3mIWdxDor5vCLT7iU63YAAc=;
	b=g6RQT3LhK2h92E7yJwV+wcxrBQ2eQAWlJrEFlg0oES1pxDgS5G6hPMIJYuv5moi1X+1tnt3OR
	9N+PeUbz9SIKdISPFPLDcgEOfoPFqdYwtWnAARtSId1UU3Gp7KRSwv6+9/uONgLCBLIEf6aM+GH
	N8rpWDbU8ykaaQryh4ddzKU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gWF0l4hK4znTVh;
	Thu,  4 Jun 2026 14:24:55 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 486344048B;
	Thu,  4 Jun 2026 14:32:48 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 dggpemf500013.china.huawei.com (7.185.36.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Jun 2026 14:32:47 +0800
Message-ID: <1bdf5296-874b-488e-8a34-d6f8d23ddcae@huawei.com>
Date: Thu, 4 Jun 2026 14:32:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
	<qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>, <kvmarm@lists.linux.dev>,
	<peter.maydell@linaro.org>, <shaju.abraham@nutanix.com>,
	<khushit.shah@nutanix.com>, <cohuck@redhat.com>,
	<richard.henderson@linaro.org>, <sebott@redhat.com>,
	<skolothumtho@nvidia.com>, <philmd@linaro.org>
CC: <maz@kernel.org>, <oliver.upton@linux.dev>, <pbonzini@redhat.com>,
	<armbru@redhat.com>, <berrange@redhat.com>, <abologna@redhat.com>,
	<jdenemar@redhat.com>
References: <20260519132905.145643-1-eric.auger@redhat.com>
 <5a533932-06fe-4401-abfe-66546c15c4ec@huawei.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <5a533932-06fe-4401-abfe-66546c15c4ec@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500013.china.huawei.com (7.185.36.188)



On 2026/6/4 14:08, Jinqian Yang wrote:
> 
> 
> On 2026/5/19 21:27, Eric Auger wrote:
>> This series enhances the current host KVM model with capability to
>> set writable ID reg fields.
>>
>> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
>> of a subset of ID regs. The list of writable fields continues to grow.
>> The feature ID range is defined as the AArch64 System register space
>> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>>
>> The end goal is to get more flexibility when migrating guests
>> between different host hardware.
>>
>> QEMU retrieves the writable ID fields from KVM UAPI [1] and
>> match them against a generated description of ID regs and their
>> named fields that stem from AARCHMRS Registers.json file.
>> Current description is based on latest 2026-03 edition.
>> The content of the generated files was compared against kernel
>> linux/arch/arm64/tools/sysreg file. It is not straightforward
>> to have unit tests for python scripts as there are many cases for
>> field extraction.
>>
>> For each writable named field a uint64 property is created
>> following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
>> FIELD names are those described in ARM ARM Reference manual.
>>
>> The list of SYSREG_ID properties can be retrieved through the qmp
>> monitor using query-cpu-model-expansion [2].
>>
>> Connie & Eric
>>
>> This series can be found at:
>> https://github.com/eauger/qemu/tree/arm-cpu-model-v5
>>
>> History:
>> --------
>>
>> v4 -> v5:
>> - generate target/arm/cpu-idregs.h.inc that look similar to
>>    the format used in [RFC PATCH v1 02/13] target/arm:
>>    named_cpu_model: Add ID Register Fields without the
>>    description of the value values nor safe policy/value.
>>    I guess valid values could be generated from the Registers.json
>>    file too. Safe policy/values cannot.
>>    I reused one patch from the above series.
>>    Let's see how both series can progress/coexist without any
>>    anticipated bias.
>> - Addressed all comments from Shameer on v4
>> - Addressed 2 comments from v4 that were missed including the
>>    issue of IDreg visibility affected by some other settings.
>>    Unfortunately I was not able to test it.
>> - Further look at overrides between low level id reg field
>>    properties versus legacy CPU options. I have the feeling they
>>    can coexist as long as we document the hierarchy between them:
>>    host kvm default -> ID reg field props -> legacy CPU options
>> - Noticed more writable fields that are RES0/RAZ
>> - Improved commit messages in general
>>
>> References:
>> -----------
>>
>> [1]
>> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
>> KVM_ARM_GET_REG_WRITABLE_MASKS
>> Documentation/virt/kvm/api.rst
>>
>> [2]
>> qemu-system-aarch64 -qmp unix:/home/augere/TEST/QEMU/qmp- 
>> sock,server,nowait -M virt --enable-kvm -cpu custom
>> sudo build/run qmp-shell /home/augere/TEST/QEMU/qmp-sock
>> Welcome to the QMP low-level shell!
>> Connected to QEMU 11.0.50
>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>
>>
>> Cornelia Huck (3):
>>    target/arm/kvm: Introduce kvm_get_writable_id_regs
>>    arm-qmp-cmds: introspection for ID register props
>>    arm/cpu-features: document ID reg properties
>>
>> Eric Auger (14):
>>    scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
>>    target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
>>    target/arm/cpu-sysregs.h.inc: Update with automatic generation
>>    arm/cpu: Add infra to handle generated ID register definitions
>>    scripts: Introduce scripts/aarch64_sysreg_helpers module
>>    scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
>>    target/arm/cpu-idregs.h.inc: generate with script
>>    target/arm/cpu64: Retrieve writable ID reg map in
>>      aarch64_host_initfn()
>>    arm/kvm: Initialize all writable ID registers from host
>>    arm/kvm: write back modified ID regs to KVM
>>    target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
>>    target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
>>    target/arm/kvm: Ignore some writable bits that shouldn't be
>>    target/arm/cpu: Expose writable ID reg field properties on the kvm
>>      host vcpu model
>>
>> Shaju Abraham (1):
>>    target/arm/cpu_idregs: generate tables for Arm64 ID registers and
>>      fields
>>
>>   docs/system/arm/cpu-features.rst              | 106 ++-
>>   scripts/aarch64_sysreg_helpers.py             | 109 ++++
>>   .../update-aarch64-cpu-sysreg-properties.py   | 168 +++++
>>   scripts/update-aarch64-cpu-sysregs-header.py  |  51 ++
>>   target/arm/arm-qmp-cmds.c                     |  19 +
>>   target/arm/cpu-idregs.c                       |  50 ++
>>   target/arm/cpu-idregs.h                       |  33 +
>>   target/arm/cpu-idregs.h.inc                   | 617 ++++++++++++++++++
>>   target/arm/cpu-sysregs.h.inc                  |  57 +-
>>   target/arm/cpu.h                              |   3 +
>>   target/arm/cpu64.c                            |  14 +
>>   target/arm/kvm-stub.c                         |   5 +
>>   target/arm/kvm.c                              | 320 ++++++++-
>>   target/arm/kvm_arm.h                          |  12 +
>>   target/arm/meson.build                        |   1 +
>>   target/arm/trace-events                       |   6 +
>>   16 files changed, 1539 insertions(+), 32 deletions(-)
>>   create mode 100644 scripts/aarch64_sysreg_helpers.py
>>   create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
>>   create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>   create mode 100644 target/arm/cpu-idregs.c
>>   create mode 100644 target/arm/cpu-idregs.h
>>   create mode 100644 target/arm/cpu-idregs.h.inc
>>
> 
> Thanks for the patch series. I tested it, and it works as expected.
> After configuring the QEMU command, it was able to successfully migrate
> on Hisilicon KunPeng HIP09 and HIP12 chips.
> 
> Tested-by: Jinqian Yang <yangjinqian1@huawei.com>
> 
> Thanks,
> Shameer
> 

Sorry, I forgot to update the salutation name at the end.

Thanks,
Jinqian
