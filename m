Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0B324E4C6
	for <kvmarm@lists.linux.dev>; Thu,  4 Jun 2026 12:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574433; cv=none; b=TyyojuRFNwVgp8LvoWAMrXPqxl3Ah40CmvCns7J15EOZpyAjiXeLXWwe5oYOSXWCTOaBdUuM2ZkKSBVHFgDRDQfcZNTtuzUSMbOG8h84c/rEhlI758FyHN/F0aSZojXP2kHont3h3WEWswQs/AHY4gov6+t81tMdYpjwsowQeMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574433; c=relaxed/simple;
	bh=lowk/hoTl/6dv664hXbIeey3iTFpJ6dV6v3wvWQK1Jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TtMyu6Pu3mMaEZaserhElR3yO2Y2QfTcx5fQdFRNUaTI1qQ4/H1Pbgu6/5VT7nGC0J5gwvUupRLcI8dFFog9OE/8BuuQz9gRmgmsrNNS+iwe9ztLucDSv9uhJzj0Fmp0bg4ZNrh49CEqMscV3fK1dKONDrIuLPYSsDPK7IinXFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=dbiDXSBA; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="dbiDXSBA"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=F8nmwbzNKOkK6Lf8Bm1FPkjQs63hUlv7sCQpS5epyPs=;
	b=dbiDXSBAxbyMCQu1k2Roodw6gtwp87+r7CWDzdkWP8oy80pMIWBy9kBN+sfPBn3vdndZ01gaT
	Rsawh8h3l9tCjPNoO28PT0Q1p33zO7dR/jXTRpBr1nyHnWcFFc7IHP+HjSf7gjf45RD7+vRqVmJ
	NZY5YENplJEMyEXaqq9wbo8=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gWNGj2ng7zKm69;
	Thu,  4 Jun 2026 19:52:29 +0800 (CST)
Received: from dggpemf500013.china.huawei.com (unknown [7.185.36.188])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A0DB40572;
	Thu,  4 Jun 2026 20:00:22 +0800 (CST)
Received: from [10.67.121.183] (10.67.121.183) by
 dggpemf500013.china.huawei.com (7.185.36.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Jun 2026 20:00:20 +0800
Message-ID: <b6cf3c71-f267-4f9b-9fe3-547859a3594b@huawei.com>
Date: Thu, 4 Jun 2026 20:00:19 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/18] kvm/arm: Introduce a customizable aarch64 KVM
 host model
To: <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
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
 <1bdf5296-874b-488e-8a34-d6f8d23ddcae@huawei.com>
 <68090ea2-fe45-4935-80f2-1a4201b5c148@redhat.com>
From: Jinqian Yang <yangjinqian1@huawei.com>
In-Reply-To: <68090ea2-fe45-4935-80f2-1a4201b5c148@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500013.china.huawei.com (7.185.36.188)



On 2026/6/4 16:31, Eric Auger wrote:
> Hi Jinqian,
> 
> On 6/4/26 8:32 AM, Jinqian Yang wrote:
>>
>>
>> On 2026/6/4 14:08, Jinqian Yang wrote:
>>>
>>>
>>> On 2026/5/19 21:27, Eric Auger wrote:
>>>> This series enhances the current host KVM model with capability to
>>>> set writable ID reg fields.
>>>>
>>>> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
>>>> of a subset of ID regs. The list of writable fields continues to grow.
>>>> The feature ID range is defined as the AArch64 System register space
>>>> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>>>>
>>>> The end goal is to get more flexibility when migrating guests
>>>> between different host hardware.
>>>>
>>>> QEMU retrieves the writable ID fields from KVM UAPI [1] and
>>>> match them against a generated description of ID regs and their
>>>> named fields that stem from AARCHMRS Registers.json file.
>>>> Current description is based on latest 2026-03 edition.
>>>> The content of the generated files was compared against kernel
>>>> linux/arch/arm64/tools/sysreg file. It is not straightforward
>>>> to have unit tests for python scripts as there are many cases for
>>>> field extraction.
>>>>
>>>> For each writable named field a uint64 property is created
>>>> following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
>>>> FIELD names are those described in ARM ARM Reference manual.
>>>>
>>>> The list of SYSREG_ID properties can be retrieved through the qmp
>>>> monitor using query-cpu-model-expansion [2].
>>>>
>>>> Connie & Eric
>>>>
>>>> This series can be found at:
>>>> https://github.com/eauger/qemu/tree/arm-cpu-model-v5
>>>>
>>>> History:
>>>> --------
>>>>
>>>> v4 -> v5:
>>>> - generate target/arm/cpu-idregs.h.inc that look similar to
>>>>     the format used in [RFC PATCH v1 02/13] target/arm:
>>>>     named_cpu_model: Add ID Register Fields without the
>>>>     description of the value values nor safe policy/value.
>>>>     I guess valid values could be generated from the Registers.json
>>>>     file too. Safe policy/values cannot.
>>>>     I reused one patch from the above series.
>>>>     Let's see how both series can progress/coexist without any
>>>>     anticipated bias.
>>>> - Addressed all comments from Shameer on v4
>>>> - Addressed 2 comments from v4 that were missed including the
>>>>     issue of IDreg visibility affected by some other settings.
>>>>     Unfortunately I was not able to test it.
>>>> - Further look at overrides between low level id reg field
>>>>     properties versus legacy CPU options. I have the feeling they
>>>>     can coexist as long as we document the hierarchy between them:
>>>>     host kvm default -> ID reg field props -> legacy CPU options
>>>> - Noticed more writable fields that are RES0/RAZ
>>>> - Improved commit messages in general
>>>>
>>>> References:
>>>> -----------
>>>>
>>>> [1]
>>>> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES
>>>> KVM_ARM_GET_REG_WRITABLE_MASKS
>>>> Documentation/virt/kvm/api.rst
>>>>
>>>> [2]
>>>> qemu-system-aarch64 -qmp unix:/home/augere/TEST/QEMU/qmp-
>>>> sock,server,nowait -M virt --enable-kvm -cpu custom
>>>> sudo build/run qmp-shell /home/augere/TEST/QEMU/qmp-sock
>>>> Welcome to the QMP low-level shell!
>>>> Connected to QEMU 11.0.50
>>>> (QEMU) query-cpu-model-expansion type=full model={"name":"host"}
>>>>
>>>>
>>>> Cornelia Huck (3):
>>>>     target/arm/kvm: Introduce kvm_get_writable_id_regs
>>>>     arm-qmp-cmds: introspection for ID register props
>>>>     arm/cpu-features: document ID reg properties
>>>>
>>>> Eric Auger (14):
>>>>     scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
>>>>     target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
>>>>     target/arm/cpu-sysregs.h.inc: Update with automatic generation
>>>>     arm/cpu: Add infra to handle generated ID register definitions
>>>>     scripts: Introduce scripts/aarch64_sysreg_helpers module
>>>>     scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
>>>>     target/arm/cpu-idregs.h.inc: generate with script
>>>>     target/arm/cpu64: Retrieve writable ID reg map in
>>>>       aarch64_host_initfn()
>>>>     arm/kvm: Initialize all writable ID registers from host
>>>>     arm/kvm: write back modified ID regs to KVM
>>>>     target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
>>>>     target/arm/kvm: Special case REVIDR_EL1 and AIDR_EL1
>>>>     target/arm/kvm: Ignore some writable bits that shouldn't be
>>>>     target/arm/cpu: Expose writable ID reg field properties on the kvm
>>>>       host vcpu model
>>>>
>>>> Shaju Abraham (1):
>>>>     target/arm/cpu_idregs: generate tables for Arm64 ID registers and
>>>>       fields
>>>>
>>>>    docs/system/arm/cpu-features.rst              | 106 ++-
>>>>    scripts/aarch64_sysreg_helpers.py             | 109 ++++
>>>>    .../update-aarch64-cpu-sysreg-properties.py   | 168 +++++
>>>>    scripts/update-aarch64-cpu-sysregs-header.py  |  51 ++
>>>>    target/arm/arm-qmp-cmds.c                     |  19 +
>>>>    target/arm/cpu-idregs.c                       |  50 ++
>>>>    target/arm/cpu-idregs.h                       |  33 +
>>>>    target/arm/cpu-idregs.h.inc                   | 617
>>>> ++++++++++++++++++
>>>>    target/arm/cpu-sysregs.h.inc                  |  57 +-
>>>>    target/arm/cpu.h                              |   3 +
>>>>    target/arm/cpu64.c                            |  14 +
>>>>    target/arm/kvm-stub.c                         |   5 +
>>>>    target/arm/kvm.c                              | 320 ++++++++-
>>>>    target/arm/kvm_arm.h                          |  12 +
>>>>    target/arm/meson.build                        |   1 +
>>>>    target/arm/trace-events                       |   6 +
>>>>    16 files changed, 1539 insertions(+), 32 deletions(-)
>>>>    create mode 100644 scripts/aarch64_sysreg_helpers.py
>>>>    create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
>>>>    create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>>>    create mode 100644 target/arm/cpu-idregs.c
>>>>    create mode 100644 target/arm/cpu-idregs.h
>>>>    create mode 100644 target/arm/cpu-idregs.h.inc
>>>>
>>>
>>> Thanks for the patch series. I tested it, and it works as expected.
>>> After configuring the QEMU command, it was able to successfully migrate
>>> on Hisilicon KunPeng HIP09 and HIP12 chips.
>>>
>>> Tested-by: Jinqian Yang <yangjinqian1@huawei.com>
> Thank you very much Jinqian for the testing. If it does not contain
> anything confidential, could you paster the cmd line (restricted to the
> SUSREG_* props) you used to tune your host vcpu model. This would
> provide another example of usage for reviewers/maintainers?
> 

Hi, Eric

Sure, here is the QEMU command line I used for testing the SYSREG_*
properties.

```
-cpu host,pauth=off,pmu=off,sve=off,\
SYSREG_ID_AA64PFR1_EL1_NMI=0x0,\
SYSREG_ID_AA64ISAR1_EL1_LS64=0x0,\
SYSREG_ID_AA64ISAR1_EL1_XS=0x0,\
SYSREG_ID_AA64ISAR1_EL1_LRCPC=0x2,\
SYSREG_ID_AA64ISAR2_EL1_RPRFM=0x0,\
SYSREG_ID_AA64ISAR2_EL1_CLRBHB=0x0,\
SYSREG_ID_AA64ISAR2_EL1_PAC_frac=0x0,\
SYSREG_ID_AA64ISAR2_EL1_BC=0x0,\
SYSREG_ID_AA64ISAR2_EL1_RPRES=0x0,\
SYSREG_ID_AA64ISAR2_EL1_WFxT=0x0,\
SYSREG_ID_AA64MMFR0_EL1_FGT=0x0,\
SYSREG_ID_AA64MMFR0_EL1_BigEnd=0x0,\
SYSREG_ID_AA64MMFR1_EL1_ECBHB=0x0,\
SYSREG_ID_AA64MMFR1_EL1_CMOW=0x0,\
SYSREG_ID_AA64MMFR1_EL1_TIDCP1=0x0,\
SYSREG_ID_AA64MMFR1_EL1_nTLBPA=0x0,\
SYSREG_ID_AA64MMFR1_EL1_AFP=0x0,\
SYSREG_ID_AA64MMFR1_EL1_HCX=0x0,\
SYSREG_ID_AA64MMFR1_EL1_ETS=0x0,\
SYSREG_ID_AA64MMFR1_EL1_PAN=0x2,\
SYSREG_ID_AA64MMFR1_EL1_HAFDBS=0x2,\
SYSREG_ID_AA64MMFR2_EL1_CnP=0x0,\
SYSREG_ID_AA64MMFR3_EL1_TCRX=0x0,\
SYSREG_ID_AA64DFR0_EL1_PMUVer=0x6,\
SYSREG_ID_AA64DFR0_EL1_DebugVer=0x9,\
SYSREG_ID_AA64DFR0_EL1_DoubleLock=0xf,\
SYSREG_ID_AA64ZFR0_EL1_F64MM=0x0,\
SYSREG_ID_AA64ZFR0_EL1_F32MM=0x0,\
SYSREG_ID_AA64ZFR0_EL1_SM4=0x0,\
SYSREG_ID_AA64ZFR0_EL1_SHA3=0x0,\
SYSREG_ID_AA64ZFR0_EL1_BitPerm=0x0,\
SYSREG_ID_AA64ZFR0_EL1_AES=0x0,\
SYSREG_ID_AA64ZFR0_EL1_SVEver=0x0,\
SYSREG_CTR_EL0_L1Ip=0x2 \
```

Best regards,
Jinqian
