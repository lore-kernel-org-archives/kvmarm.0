Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D83383329
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787647359; cv=none; b=n3ot4Dn/X0h0VwBvifTyygWkkBdLyBYbe0Sr8CN7njUMGUUd1XbWxGfIwA+Om1ujW8ULIxnHg/4b/5ALvev/S7nC/gsZT+5QUe+ppn+DyT+jM3cgd193XTNVHcpTJXmWsUfNE0w34zo9i/n57nDZQS+eG2/nxm5Qa7joipmQvoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787647359; c=relaxed/simple;
	bh=zfDDH91MS2npdCFVV2i2qkKtsV6GrynjQzZdHUl7Swk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqU6vuVuloGZ4yXAtKSgGMXoCs9IzIM/G3APjwQ/JAm2LlD9pLqnkPyUTLKCmS6DG8caJaKX2urhjm04cnB6AwlpoEOZiP+QL1IaJZZIwNCwjNZ0wkosSl1lEymuvpU7JoXNxNXcMp0RIS8746WgrLpXNH//WcW2G7syksYfAVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hMMN8uVP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hMMN8uVP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787647356;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O7+VNjA+VJCSSZwgUobk0QB6O6Wj/beMRuMfiFxNe0=;
	b=hMMN8uVPr4HvYVX36TLT9uYwhpVPATA1MyVnGAhCsPrcp0T3L1Lf0HrLII1m9vAXBfecfc
	BxkDxiHh4/I8ay69vPjw6VUI1OaKtzVFHDKNaUaKIXNz2123QXOkFDQkZZbRJHicTYY0wH
	TORVfaGeKdZS6l/NsYQbokYetjwQhDQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-qi2k1LZQPwuD3RLQVXrkZA-1; Tue, 25 Aug 2026 04:42:34 -0400
X-MC-Unique: qi2k1LZQPwuD3RLQVXrkZA-1
X-Mimecast-MFC-AGG-ID: qi2k1LZQPwuD3RLQVXrkZA_1787647353
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c15e555a164so53377866b.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 01:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647353; x=1788252153;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3O7+VNjA+VJCSSZwgUobk0QB6O6Wj/beMRuMfiFxNe0=;
        b=P2b4vfa8XHZkLfr+DEo//YS3XU2jNXJsL5/IUcPOEL+Gh6EShQSqLwK39N6bexnK0j
         rBJ+rsk4AfVGWkBCPhBhIZsen87xPAzf/9QltMX5aLyQ4jWnr27NAcL2CqE0AysvP0jK
         u5jDFnPon9l6GBsAUqdHy7hVp8NHA8BWptMgHR448GJE/q6kTKWCvl2z5bhgNdKc86rk
         hYV4WrcXjblZlYz6ALxPNY4oX495bButp82DdSm45wmCliZDhIvz3RZwEQj/p0CDK4iG
         9Ld+uNQY/KEm6xM/dCf9Me/UjKpQ8Abj/Y/Wb1MQfb5+4TSZMdFCsKV0GllQwpxhdLPS
         rq3A==
X-Forwarded-Encrypted: i=1; AHgh+RqOpJTYmcuBAhHs18JE7211NCZfdvGAUgXE5dSFBI3mfz9UnUjC76A449wh42chvgW8e9aW7Dw=@lists.linux.dev
X-Gm-Message-State: AFuF++kn1IfjJKg2avvECnilUs2gEeHiF9di4In57x5AgaMn/nT6focr
	Kvk4XnFRJNl26HEJT3CoUjkPf0sKyvFbqY1uI9kj9Y3sPzqWWxASOO33s7+slva6z+WX902XR4S
	6SE6zQr6zcjuQWvGWZwhcjBu86m5NBCJUTN+OZtWrgB3ATQ8cswV+IApq8g==
X-Gm-Gg: AR+sD12jDPiAdwFldJDxoJZrzWQ7SRycrcXOToACv38nAbCj5McgYXD9g/jCI38YxRq
	JnSRYWU80SMEuoSaKXm7NPMCuJr9ZZ8ZnMmCHqAphbRqJwq3NtDffdUfA1khTzmJ6BDQSI5HSg3
	c640Qbf8Y18ZDdf8ijJYTPWTrVxImqpAHpDySfhtIlrCrw9nWICsmixrhkGEqb5B4+izd3KJZbA
	wuTAVSrSB0Mq1TMkTbDA3awQPzD+qm5IztD0R+y6zvzxcOPqfGzhceTc/sUdlF5Io0GLqP2tvQ7
	fuNPxvwYs5f40k70f/AZbp4dFYNXjw5tZOx9vvTZKaMm+AHNpMGG7H8aBtFMX27RnPY85lAH1bO
	qZYML63lQVe6fJovNbLHjSLvYAJK/YcnJ6cPCWSiEv6YwqEpx
X-Received: by 2002:a17:907:e98a:b0:c20:7cb0:f33c with SMTP id a640c23a62f3a-c24e3005531mr502641166b.16.1787647352849;
        Tue, 25 Aug 2026 01:42:32 -0700 (PDT)
X-Received: by 2002:a17:907:e98a:b0:c20:7cb0:f33c with SMTP id a640c23a62f3a-c24e3005531mr502637366b.16.1787647352372;
        Tue, 25 Aug 2026 01:42:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f9cbcsm1883575466b.29.2026.08.25.01.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 01:42:31 -0700 (PDT)
Message-ID: <4b2eacfc-64cd-4604-8f23-56f5269550a5@redhat.com>
Date: Tue, 25 Aug 2026 10:42:29 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v7 00/18] kvm/arm: Introduce a customizable aarch64
 KVM host model
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
 "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
 Shaju Abraham <shaju.abraham@nutanix.com>,
 "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
 "cohuck@redhat.com" <cohuck@redhat.com>,
 "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
 "sebott@redhat.com" <sebott@redhat.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "philmd@oss.qualcomm.com" <philmd@oss.qualcomm.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "armbru@redhat.com" <armbru@redhat.com>,
 "berrange@redhat.com" <berrange@redhat.com>,
 "abologna@redhat.com" <abologna@redhat.com>,
 "jdenemar@redhat.com" <jdenemar@redhat.com>
References: <20260726153221.24773-1-eric.auger@redhat.com>
 <3057A3BC-2BE9-4D2B-9D04-E3B31A6D0599@nutanix.com>
 <2C1E0EFD-7BD3-4177-90F8-14894B34F726@nutanix.com>
 <bb73e5bd-d64b-490e-9f2a-958b3105e962@redhat.com>
 <FBA80E7F-3FB6-4FF2-AE8E-716F79DAB4A6@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <FBA80E7F-3FB6-4FF2-AE8E-716F79DAB4A6@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0eGNeKvuhBk5DuamRQg8YUpbXGQZK82M8tKjLJBsbto_1787647353
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/25/26 8:49 AM, Khushit Shah wrote:
>
>> On 25 Aug 2026, at 12:05 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>>
>>
>> On 8/24/26 10:19 AM, Khushit Shah wrote:
>>>> On 20 Aug 2026, at 11:57 AM, Khushit Shah <khushit.shah@nutanix.com> wrote:
>>>>
>>>>
>>>>
>>>>> On 26 Jul 2026, at 8:59 PM, Eric Auger <eric.auger@redhat.com> wrote:
>>>>>
>>>>> !-------------------------------------------------------------------|
>>>>> CAUTION: External Email
>>>>>
>>>>> |-------------------------------------------------------------------!
>>>>>
>>>>> This series enhances the current host KVM model with capability to
>>>>> set writable ID reg fields. 
>>>>>
>>>>> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
>>>>> of a subset of ID regs. The list of writable fields continues to grow.
>>>>> The feature ID range is defined as the AArch64 System register space
>>>>> with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
>>>>>
>>>>> The end goal is to get more flexibility when migrating guests
>>>>> between different host hardware.
>>>>>
>>>>> QEMU retrieves the writable ID fields from KVM UAPI [1] and
>>>>> match them against a generated description of ID regs and their
>>>>> named fields that stem from AARCHMRS Registers.json file.
>>>>> Current description is based on latest 2026-03 edition.
>>>>> The content of the generated files was compared against kernel
>>>>> linux/arch/arm64/tools/sysreg file. It is not straightforward
>>>>> to have unit tests for python scripts as there are many cases for
>>>>> field extraction. 
>>>>>
>>>>> For each writable named field a uint64 property is created
>>>>> following the "SYSREG_<REG>_<FIELD>" naming convention. REG and
>>>>> FIELD names are those described in ARM ARM Reference manual.
>>>>>
>>>>> The list of SYSREG_ID properties can be retrieved through the qmp
>>>>> monitor using query-cpu-model-expansion [2].
>>>>>
>>>>> For the record, Jinqian was able to migrate between Hisilicon KunPeng
>>>>> HIP09 and HIP12 chips with this series using this kind of command:
>>>>>
>>>>> -cpu host,pauth=off,pmu=off,sve=off,\
>>>>> SYSREG_ID_AA64PFR1_EL1_NMI=0x0,\
>>>>> SYSREG_ID_AA64ISAR1_EL1_LS64=0x0,\
>>>>> SYSREG_ID_AA64ISAR1_EL1_XS=0x0,\
>>>>> SYSREG_ID_AA64ISAR1_EL1_LRCPC=0x2,\
>>>>> SYSREG_ID_AA64ISAR2_EL1_RPRFM=0x0,\
>>>>> SYSREG_ID_AA64ISAR2_EL1_CLRBHB=0x0,\
>>>>> SYSREG_ID_AA64ISAR2_EL1_PAC_frac=0x0,\
>>>>> SYSREG_ID_AA64ISAR2_EL1_BC=0x0,\
>>>>> SYSREG_ID_AA64ISAR2_EL1_RPRES=0x0,\
>>>>> SYSREG_ID_AA64ISAR2_EL1_WFxT=0x0,\
>>>>> SYSREG_ID_AA64MMFR0_EL1_FGT=0x0,\
>>>>> SYSREG_ID_AA64MMFR0_EL1_BigEnd=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_ECBHB=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_CMOW=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_TIDCP1=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_nTLBPA=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_AFP=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_HCX=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_ETS=0x0,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_PAN=0x2,\
>>>>> SYSREG_ID_AA64MMFR1_EL1_HAFDBS=0x2,\
>>>>> SYSREG_ID_AA64MMFR2_EL1_CnP=0x0,\
>>>>> SYSREG_ID_AA64MMFR3_EL1_TCRX=0x0,\
>>>>> SYSREG_ID_AA64DFR0_EL1_PMUVer=0x6,\
>>>>> SYSREG_ID_AA64DFR0_EL1_DebugVer=0x9,\
>>>>> SYSREG_ID_AA64DFR0_EL1_DoubleLock=0xf,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_F64MM=0x0,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_F32MM=0x0,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_SM4=0x0,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_SHA3=0x0,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_BitPerm=0x0,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_AES=0x0,\
>>>>> SYSREG_ID_AA64ZFR0_EL1_SVEver=0x0,\
>>>>> SYSREG_CTR_EL0_L1Ip=0x2 \
>>>>>
>>>>> Connie & Eric
>>>>>
>>>>> This series can be found at:
>>>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_eauger_qemu_tree_arm-2Dcpu-2Dmodel-2Dv7&d=DwIDAg&c=s883GpUCOChKOHiocYtGcg&r=PGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=xh5u7-r6auXiWQScafdj-0wW70mXB4FhClh58GryHmExkx8uZN-h9j4B2c90Lowd&s=Ro4v_mjoNaLsznyxm781lzXBcRtXTudjibmgIhoJsNM&e= 
>>>>>
>>>>> History:
>>>>> --------
>>>>> v6 -> v7:
>>>>> - query-cpu-model-expansion now applies the sysreg props
>>>>> onto a scratch vcpu (POC) allowing a finer validation of settings
>>>>> (not perfect though as init may be revisited depending on
>>>>> settings)
>>>>> - Properly handle ValueRange (Khushit)
>>>>> - Remove cpu parameter in get_host_cpu_idregs call chain
>>>>> (Khushit)
>>>>>
>>>>> v5 -> v6:
>>>>> v6 is mostly for Khushit to see how he may work on top
>>>>> of this series. It fulfills some of his requirements:
>>>>> - Upon Khushit request I added description for enum values
>>>>> and reserved fields
>>>>> - set_sysreg_prop checks the input value against enum values
>>>>> if any
>>>>> - writable_bitmap is now dispatched into the sysreg descripton
>>>>> and not stored in vcpu state anymore (besides it is VM wide)
>>>>> - implemented write for qmp inspection. However this is not
>>>>> yet checked against KVM. That's the next step I think, ie.
>>>>> instantiate a scratch vcpu to test if the field value can be
>>>>> applied?
>>>>> - if some inconsistencies between writable mask and idreg
>>>>> field, reserved fields only produce traces
>>>>> - this version does not yet fix some reported issues about host
>>>>> supporting nested virt. I will further sync with Khushit.
>>>>> so this is definitively not candidate to be applied, hence the
>>>>> RFC tag.
>>>>>
>>>>> Cornelia Huck (3):
>>>>> target/arm/kvm: Retrieve writable ID reg map
>>>>> arm/cpu-features: document ID reg properties
>>>>> arm-qmp-cmds: introspection for ID register props
>>>>>
>>>>> Eric Auger (14):
>>>>> scripts: introduce scripts/update-aarch64-cpu-sysregs-header.py
>>>>> target/arm/cpu-sysregs.h.inc: Sort by name alphabetical order
>>>>> target/arm/cpu-sysregs.h.inc: Update with automatic generation
>>>>> arm/cpu: Add infra to handle generated ID register definitions
>>>>> scripts: Introduce scripts/aarch64_sysreg_helpers module
>>>>> scripts: Introduce scripts/update-aarch64-cpu-sysreg-properties.py
>>>>> target/arm/cpu-idregs.h.inc: generate with script
>>>>> target/arm/cpu-idregs.h.inc: Generate enum values
>>>>> arm/kvm: Initialize all writable ID registers from host
>>>>> target/arm/kvm: Introduce kvm_arm_expose_idreg_properties
>>>>> target/arm/cpu: Expose writable ID reg field properties on the kvm
>>>>>  host vcpu model
>>>>> target/arm/cpu-idregs.h.inc: Generate reserved fields
>>>>> target/arm/kvm: Ignore and trace unexpected writable reserved fields
>>>>> target/arm/kvm: add utility to write idregs in scratch vcpu
>>>>>
>>>>> Shaju Abraham (1):
>>>>> target/arm/cpu_idregs: generate tables for Arm64 ID registers and
>>>>>  fields
>>>>>
>>>>> docs/system/arm/cpu-features.rst              |  106 +-
>>>>> target/arm/cpu-idregs.h                       |   41 +
>>>>> target/arm/kvm_arm.h                          |   13 +
>>>>> target/arm/cpu-idregs.h.inc                   | 2164 +++++++++++++++++
>>>>> target/arm/cpu-sysregs.h.inc                  |   57 +-
>>>>> target/arm/arm-qmp-cmds.c                     |   98 +
>>>>> target/arm/cpu-idregs.c                       |   96 +
>>>>> target/arm/cpu64.c                            |    5 +
>>>>> target/arm/kvm-stub.c                         |    6 +
>>>>> target/arm/kvm.c                              |  360 ++-
>>>>> scripts/aarch64_sysreg_helpers.py             |  109 +
>>>>> .../update-aarch64-cpu-sysreg-properties.py   |  290 +++
>>>>> scripts/update-aarch64-cpu-sysregs-header.py  |   51 +
>>>>> target/arm/meson.build                        |    1 +
>>>>> target/arm/trace-events                       |    8 +
>>>>> 15 files changed, 3373 insertions(+), 32 deletions(-)
>>>>> create mode 100644 target/arm/cpu-idregs.h
>>>>> create mode 100644 target/arm/cpu-idregs.h.inc
>>>>> create mode 100644 target/arm/cpu-idregs.c
>>>>> create mode 100644 scripts/aarch64_sysreg_helpers.py
>>>>> create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
>>>>> create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>>>>
>>>>> -- 
>>>>> 2.53.0
>>>>>
>>>> Hi,
>>>>
>>>> On my box the build is failing with:
>>>> [97/2192] Linking target qemu-system-arm
>>>> FAILED: qemu-system-arm
>>>> cc @qemu-system-arm.rsp
>>>> /usr/bin/ld: libsystem_arm.a.p/target_arm_arm-qmp-cmds.c.o: in function `qmp_query_cpu_model_expansion':
>>>> /home/ahv/qemu/build/../target/arm/arm-qmp-cmds.c:144:(.text+0x4d4): undefined reference to `kvm_check_extension'
>>>> /usr/bin/ld: /home/ahv/qemu/build/../target/arm/arm-qmp-cmds.c:145:(.text+0x4e4): undefined reference to `kvm_check_extension'
>>>> /usr/bin/ld: /home/ahv/qemu/build/../target/arm/arm-qmp-cmds.c:151:(.text+0x514): undefined reference to `kvm_check_extension'
>>>> /usr/bin/ld: /home/ahv/qemu/build/../target/arm/arm-qmp-cmds.c:168:(.text+0x554): undefined reference to `kvm_arm_create_scratch_host_vcpu'
>>>> /usr/bin/ld: /home/ahv/qemu/build/../target/arm/arm-qmp-cmds.c:152:(.text+0x7d4): undefined reference to `kvm_check_extension'
>>>> /usr/bin/ld: /home/ahv/qemu/build/../target/arm/arm-qmp-cmds.c:247:(.text+0x8f4): undefined reference to `kvm_arm_destroy_scratch_host_vcpu'
>>>> collect2: error: ld returned 1 exit status
>>> If I add appropriate stubs, Following test fails:
>>>  30/1079 qemu:qtest+qtest-aarch64 / qtest-aarch64/device-introspect-test         ERROR            1.58s   killed by signal 6 SIGABRT
>>> 126/1079 qemu:qtest+qtest-aarch64 / qtest-aarch64/qom-test                       ERROR           46.65s   killed by signal 6 SIGABRT
>>> 426/1079 qemu:qtest+qtest-aarch64 / qtest-aarch64/arm-cpu-features               ERROR            0.51s   killed by signal 6 SIGABRT
>>> 467/1079 qemu:qtest+qtest-arm / qtest-arm/arm-cpu-features                       ERROR            0.46s   killed by signal 6 SIGABRT
>> all the above are fixed now.
> Is it available on the same GitHub repo?
Not yet. Soon ;-)
>
> Also may I know what are your thoughts on cpu-model-expansion schematics?

do you refer to your last comment in
https://lore.kernel.org/all/C950721B-25A3-477F-ABF0-56491A2C968F@nutanix.com/#t
if so, I will reply on this msg instead

Thanks

Eric
>
>>> 966/1079 qemu:block / io-qcow2-161                                               ERROR            1.95s   exit status 1
>> this one looks unrelated to this series. I did not encounter it.
> Acked.
>
>> Thanks
>>
>> Eric
>

