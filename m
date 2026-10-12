Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8279E3955C0
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 05:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791783015; cv=none; b=hrKXVPmbRo3aLnJRwLx70bocq5F0Gg3wD0o4xy1qsvXjD6AVHG5OZP1/bVQ/HawTkWnx1YR9/dj8rb2NvPB9hUEmyVYxlY1khLuPXETgP20fRgkkWes+mp3XWcQbyKXUrZ9FYjAhiBho/KStYdkdShFMuWqASqJdi8RzBwipm5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791783015; c=relaxed/simple;
	bh=76LXmpr23k1W0zH6FNt9uJozhc0z7FFQsSiA1rQU3Ww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fv2JNc1ajSzn5AtBguTgMpXDUgZvazGfBeMQZLlJzhItJzVZNGt4mFPuIdS2mo4akq/bU0Fnu4nIfDShqe7TQcJWo2Lr8E8Ln/YnqqZxc28eAvpPZ1+on/V0o3Yzc7zg91UCMJOG9rpMaJSPyn9FY1KAlz9OyOnEmTN05A/11bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dBHjZmNM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dBHjZmNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791783012;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=op4raY2X91Zzmn+1IR9+mOrnDYguBSIDkgH2qppWoGQ=;
	b=dBHjZmNMJcmThYosWEENogaXGsTFajOmMLs/I3EZODPxMIPCYRjvbUVgCQ4YEhdu84Vwtq
	knPiIp2tL852jYlHGftgP2HjinyihItGLB7W63wuYi4fOGhk/5XKSPX6QJaoaVEcAeyv0f
	sDau11uCMgyDKPf7nYa36aHbDmSMv6U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-Bzl65ZI1NG6RQeDwfK2gjA-1; Mon, 12 Oct 2026 05:30:10 +0000
X-MC-Unique: Bzl65ZI1NG6RQeDwfK2gjA-1
X-Mimecast-MFC-AGG-ID: Bzl65ZI1NG6RQeDwfK2gjA_1791783009
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49953abe51fso10775615e9.1
        for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 22:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791783009; x=1792387809;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RxD8Kncz8+fbuZzax4X5TUQtEW/CrJD3usSfsekNKE=;
        b=ghrMUK1XW1n4RRwzAbA7lMKSNx47jSLWzwTlZxWi4ledyaoFk4q5RHmOdldLeeMTwV
         kh+Md50kytVxM374X3qq/DZv1j6ewo+KXTyxjmPI7cf/EoU3cGE4HSe+fOVPla9WvlGA
         GfiQYsBafpuHilqqwmIG28OVFtBY+XNMZ/OTZ3MaDNPCWCU/vF1nVbYJDaDaf9qVeOa0
         jfI6sDMCZ9QKj0+fNpZe4ueOBkviWM0dd7tMIgA6NrKVP784cF+B4OVfRbyWP6HOuuDE
         mMuZHz63PsAPalzKSdamD+lbv9gsyqEasu7Jnr4jMZKHD6UZGe4vaR1mWdvv81GfE5TL
         m89w==
X-Forwarded-Encrypted: i=1; AKwUvBwX2mu+yiadrEgPlrpyP2zoYAxBAZXTy1GeG0AGJZkOT0CiMHuns2FsYwjPd4i53DA8PWibJrc=@lists.linux.dev
X-Gm-Message-State: AFq9FYK7UcaUfE11djp4zXd4UXkzhcJNXnSHiq6mGphQAjw82+lkmhM7
	DByYrnTcKaLZTAKCVFS0WJrKkXlw6O9a5Mw1GTa+BLssFChHeyDS3qV1zEV5yYrVgp4UdSMiLz8
	kOCsefylkVEgoThXIDKHewiAmMPqZAEzbvBqldCwPWa3OdPo912wvHlyhIQ==
X-Gm-Gg: AYBFou13+LsG7bIE/iybDHGUjcdiBLcczrlU/hHgCvZeOg1T/58TXBpXLMlJM6TeX4V
	jCm5EVq/cDhQPhMqqoXY/8brpbTHdGIX6+QOsXqsXpaZgjc92dXcrC+oIFQFGU8qDJjk7A8kDc7
	vO650JlLAIcNnkCyF8ba+0aPSmADFxNV9Cw6UydzKpf4OXwvMT9I2Tp6qI7+6K1xm1MoXIHRuPr
	eTkHOl4Tqoy6Roqj7yFFEDSrIkNvwJ54BsTyIaPTJtEISHw11io7YUq/lROGH2CLIiLI8yDxMuI
	Ck+OVVAIPGH02i7D03rox+rZe+Pyv4rcA1lFOM140vAnPmKrc7u4iU5/sWmjzJFrddGSdPDH0Ck
	f6F5HxsLNtqCCOFp/mKEGG1Mw+y6egQR6rHpI3lCkkNPgDGWu
X-Received: by 2002:a05:600c:548e:b0:4a0:1aa0:7cfa with SMTP id 5b1f17b1804b1-4a18e4aa724mr159649105e9.12.1791783009024;
        Sun, 11 Oct 2026 22:30:09 -0700 (PDT)
X-Received: by 2002:a05:600c:548e:b0:4a0:1aa0:7cfa with SMTP id 5b1f17b1804b1-4a18e4aa724mr159648625e9.12.1791783008580;
        Sun, 11 Oct 2026 22:30:08 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9abda3csm18465898f8f.36.2026.10.11.22.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2026 22:30:08 -0700 (PDT)
Message-ID: <01fa7204-d309-4044-9fca-610c77ff9f7a@redhat.com>
Date: Mon, 12 Oct 2026 07:30:06 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v10 00/26] kvm/arm: Introduce a customizable aarch64 KVM
 host model
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
References: <20261010133725.642498-1-eric.auger@redhat.com>
 <2F29CAAF-744A-433B-AD42-DF1881E07548@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <2F29CAAF-744A-433B-AD42-DF1881E07548@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 74nUZFrcFW3uMdok4OeADjqqdSilcjFoovfoRAYZOHo_1791783009
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Khushit,

On 10/12/26 6:38 AM, Khushit Shah wrote:
>
>> On 10 Oct 2026, at 7:06=E2=80=AFPM, Eric Auger <eric.auger@redhat.com> w=
rote:
>>
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>
>> |-------------------------------------------------------------------!
>>
>> This series enhances the current host KVM model with capability to
>> set writable ID reg fields.
>>
>> Since v6.7 kernel, KVM/arm allows the userspace to overwrite the values
>> of a subset of ID regs. The list of writable fields continues to grow.
>> The feature ID range is defined as the AArch64 System register space
>> with op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=3D0, CRm=3D=3D{0-7}, op2=3D=
=3D{0-7}.
>>
>> The end goal is to get more flexibility when migrating guests
>> between different host hardware. This series is a prerequisite for
>> aarch64 named vcpu models.
>>
>> QEMU retrieves the writable ID fields from KVM UAPI and
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
>> SYSREG properties are applied at the end of the initialization
>> chain, after legacy composite options (sve, pauth, ...). They
>> do not substitute to them because legacy options do more than
>> just changing the value of ID registers. They may also interact
>> with KVM to init the vcpu with specific features or set some
>> VM capabilities. SYSREG properties just affect the corresponding
>> ID register field. Some checks are performed to make sure their
>> value is not inconsistent with legacy composite options.
>>
>> The list of SYSREG properties can be retrieved through the qmp
>> monitor using query-cpu-model-expansion. They return the current
>> value for the corresponding field. The qmp command also allows to
>> test  setting new values. In static mode, they are tested at qemu
>> level only, against field length, arch enum values if any and
>> consistency with legacy composite options. With full expansion,
>> the values are tested against KVM using a scratch vcpu initialized
>> with the right legacy composite property values.
>>
>> Connie & Eric
>>
> Hi Eric,=20
>
> Thanks for the quick respin!
>
> I tried to build the series but it fails with:
> FAILED: libqemu-aarch64_be-linux-user.a.p/linux-user_syscall.c.o=20
> cc -Ilibqemu-aarch64_be-linux-user.a.p -I. -I.. -Itarget/arm -I../target/=
arm -I../common-user/host/aarch64 -I../linux-user/include/host/aarch64 -I..=
/linux-user/include -Ilinux-user -I../linux-user -Ilinux-user/aarch64 -I../=
linux-user/aarch64 -Iqapi -Itrace -Iui -Iui/shader -I/usr/include/glib-2.0 =
-I/usr/lib64/glib-2.0/include -I/usr/include/sysprof-6 -fdiagnostics-color=
=3Dauto -Wall -Winvalid-pch -Werror -std=3Dgnu11 -O2 -g -D_GNU_SOURCE -D_FI=
LE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE -fno-strict-aliasing -fno-common -f=
wrapv -ftrivial-auto-var-init=3Dzero -fzero-call-used-regs=3Dused-gpr -fsta=
ck-protector-strong -Wempty-body -Wendif-labels -Wexpansion-to-defined -Wfo=
rmat-overflow=3D2 -Wformat-security -Wformat-y2k -Wignored-qualifiers -Wimp=
licit-fallthrough=3D2 -Winit-self -Wmissing-format-attribute -Wmissing-prot=
otypes -Wnested-externs -Wold-style-declaration -Wold-style-definition -Wre=
dundant-decls -Wshadow=3Dlocal -Wstrict-prototypes -Wtype-limits -Wundef -W=
vla -Wwrite-strings -Wno-missing-include-dirs -Wno-psabi -Wno-shift-negativ=
e-value -isystem /home/ahv/qemu-upstream/linux-headers -isystem linux-heade=
rs -iquote . -iquote /home/ahv/qemu-upstream -iquote /home/ahv/qemu-upstrea=
m/include -iquote /home/ahv/qemu-upstream/host/include/aarch64 -iquote /hom=
e/ahv/qemu-upstream/host/include/generic -iquote /home/ahv/qemu-upstream/tc=
g/aarch64 -pthread -fPIE -DWITH_GZFILEOP -isystem../linux-headers -isysteml=
inux-headers -DCOMPILING_PER_TARGET '-DCONFIG_TARGET=3D"aarch64_be-linux-us=
er-config-target.h"' -MD -MQ libqemu-aarch64_be-linux-user.a.p/linux-user_s=
yscall.c.o -MF libqemu-aarch64_be-linux-user.a.p/linux-user_syscall.c.o.d -=
o libqemu-aarch64_be-linux-user.a.p/linux-user_syscall.c.o -c ../linux-user=
/syscall.c
> In file included from /home/ahv/qemu-upstream/include/fpu/softfloat-types=
.h:83,
>                  from /home/ahv/qemu-upstream/include/qemu/cpu-float.h:4,
>                  from ../target/arm/cpu.h:24,
>                  from ../linux-user/qemu.h:4,
>                  from ../linux-user/syscall.c:133:
> ../linux-user/aarch64/../arm/target_proc.h: In function =E2=80=98open_cpu=
info=E2=80=99:
> ../linux-user/aarch64/../arm/target_proc.h:28:30: error: =E2=80=98ARMCPU=
=E2=80=99 {aka =E2=80=98struct ArchCPU=E2=80=99} has no member named =E2=80=
=98midr=E2=80=99
>    28 |     midr_rev =3D FIELD_EX32(cpu->midr, MIDR_EL1, REVISION);
>       |                              ^~
> /home/ahv/qemu-upstream/include/hw/core/registerfields.h:56:16: note: in =
definition of macro =E2=80=98FIELD_EX32=E2=80=99
>    56 |     extract32((storage), R_ ## reg ## _ ## field ## _SHIFT,      =
         \
>       |                ^~~~~~~
> ../linux-user/aarch64/../arm/target_proc.h:29:31: error: =E2=80=98ARMCPU=
=E2=80=99 {aka =E2=80=98struct ArchCPU=E2=80=99} has no member named =E2=80=
=98midr=E2=80=99
>    29 |     midr_part =3D FIELD_EX32(cpu->midr, MIDR_EL1, PARTNUM);
>       |                               ^~
> /home/ahv/qemu-upstream/include/hw/core/registerfields.h:56:16: note: in =
definition of macro =E2=80=98FIELD_EX32=E2=80=99
>    56 |     extract32((storage), R_ ## reg ## _ ## field ## _SHIFT,      =
         \
>       |                ^~~~~~~
> ../linux-user/aarch64/../arm/target_proc.h:30:30: error: =E2=80=98ARMCPU=
=E2=80=99 {aka =E2=80=98struct ArchCPU=E2=80=99} has no member named =E2=80=
=98midr=E2=80=99
>    30 |     midr_var =3D FIELD_EX32(cpu->midr, MIDR_EL1, VARIANT);
>       |                              ^~
> /home/ahv/qemu-upstream/include/hw/core/registerfields.h:56:16: note: in =
definition of macro =E2=80=98FIELD_EX32=E2=80=99
>    56 |     extract32((storage), R_ ## reg ## _ ## field ## _SHIFT,      =
         \
>       |                ^~~~~~~
> ../linux-user/aarch64/../arm/target_proc.h:31:31: error: =E2=80=98ARMCPU=
=E2=80=99 {aka =E2=80=98struct ArchCPU=E2=80=99} has no member named =E2=80=
=98midr=E2=80=99
>    31 |     midr_impl =3D FIELD_EX32(cpu->midr, MIDR_EL1, IMPLEMENTER);
>       |                               ^~
> /home/ahv/qemu-upstream/include/hw/core/registerfields.h:56:16: note: in =
definition of macro =E2=80=98FIELD_EX32=E2=80=99
>    56 |     extract32((storage), R_ ## reg ## _ ## field ## _SHIFT,      =
         \
>       |                ^~~~~~~
>
> (Seems like you missed the midr change ../linux-user/aarch64/../arm/targe=
t_proc.h)
>
> I will use a local change to bypass this for now.

thanks for the report. I missed that occurence. Will fix that asap

Eric
>
> Thanks,
> Khushit
>
>> This series can be found at:
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__github.com_eauger=
_qemu_tree_arm-2Dcpu-2Dmodel-2Dv10&d=3DDwIDAg&c=3Ds883GpUCOChKOHiocYtGcg&r=
=3DPGWMyignA0NiDmTlyP7vOTHozBws_VN86yrVmSMkBp0&m=3DEQ1t39vqC5VSSSw_jZuUnx8X=
XPMM-ahIV_dh7aGklyYX3735JsqABWwM82QHgpmJ&s=3Dmi86fJIDXGllId7EXkRflzOzb4Rajf=
_9mL4xlxG-6Jc&e=3D=20
>>
>> History:
>> --------
>> v9 -> v10:
>> addressed all Khushit's comments/suggestions. Here is the
>> list of main changes.
>>
>> - MIDR, REVIDIR, MPIDR storage move (this may be sent as a
>>  separate prerequisite series)
>> - rebase on demux register handler that has just landed
>>  - update the json extractor accordingly
>> - Generate conditional enum values
>> - reorganize script patches to have the generated header
>>  in the same patch which is much easier to maintain
>> - New macro to encode arch enum value and ValueRanges which
>>  gives a much more compact header. Also enabled to remove
>>  check-patch error
>> - Put a maximum of code in cpu64.c instead of kvm.c to
>>  pave the way for other acceleration support. Also
>>  changed the consistency check handling by skipping potential
>>  new props that are known to collide with legacy composite options
>> - add writable_only param to pave the way for exposing all fields
>>  as props
>> - fixes in the qmp expansion code
>>
>>
>> Cornelia Huck (3):
>>  target/arm/kvm: Retrieve writable ID reg map
>>  arm-qmp-cmds: introspection for ID register props
>>  arm/cpu-features: Document ID reg properties
>>
>> Eric Auger (22):
>>  target/arm: Move REVIDR into isar.idregs[] storage
>>  target/arm: Move MIDR into isar.idregs[] storage
>>  target/arm: Enforce MPIDR into isar.idregs[] storage
>>  target/arm/cpu-sysregs.h.inc: Update with automatic generation
>>  arm/cpu: Add infra to handle generated ID register definitions
>>  target/arm/cpu-idregs.h.inc: Generate with script
>>  target/arm/cpu-idregs.h.inc: Generate enum values
>>  target/arm/cpu-idregs.h.inc: Generate reserved fields
>>  hw/arm/virt: Make sure virt_get_caches() keeps on reading CLIDR_EL1 as
>>    0
>>  arm/kvm: Initialize isar.idregs[] with all writable host ID regs
>>  target/arm/cpu64: Add properties for writable IDReg fields
>>  target/arm/kvm: Implement SYSREG property setter and getter
>>  target/arm/kvm: Let kvm_arm_init_cpreg_list propagate an error handle
>>  target/arm/kvm: Pass an Error handle to kvm_arch_init_vcpu
>>  target/arm/kvm: Introduce kvm_arm_override_idreg_field helper
>>  target/arm/cpu64: Introduce arm_cpu_apply_sysreg_props
>>  target/arm/kvm: Apply SYSREG props
>>  target/arm/kvm: Add consistency checking for SYSREG props
>>  target/arm/cpu64: Add helper to test SYSREG props against a scratch
>>    vcpu
>>  target/arm/kvm: Add an error handle to
>>    kvm_arm_create_scratch_host_vcpu
>>  target/arm/kvm: Introduce kvm_arm_vcpu_prepare_init_features helper
>>  target/arm/kvm: Introduce kvm_arm_create_init_scratch_vcpu()
>>
>> Shaju Abraham (1):
>>  target/arm/cpu_idregs: Generate tables for Arm64 ID registers and
>>    fields
>>
>> docs/system/arm/cpu-features.rst              |  111 +-
>> include/system/kvm.h                          |    2 +-
>> target/arm/cpu-idregs.h                       |   76 +
>> target/arm/cpu.h                              |   12 +-
>> target/arm/kvm_arm.h                          |   26 +-
>> target/arm/cpu-idregs.h.inc                   | 1549 +++++++++++++++++
>> target/arm/cpu-sysregs.h.inc                  |   13 +
>> accel/kvm/kvm-all.c                           |   15 +-
>> hw/arm/virt.c                                 |   11 +
>> hw/intc/armv7m_nvic.c                         |    4 +-
>> target/arm/arm-qmp-cmds.c                     |  130 +-
>> target/arm/cpu-idregs.c                       |   93 +
>> target/arm/cpu-max.c                          |    4 +-
>> target/arm/cpu.c                              |   24 +-
>> target/arm/cpu64.c                            |  330 +++-
>> target/arm/helper.c                           |   29 +-
>> target/arm/hvf/hvf.c                          |    6 +-
>> target/arm/kvm-stub.c                         |   17 +
>> target/arm/kvm.c                              |  277 ++-
>> target/arm/tcg/cpu-v7m.c                      |   18 +-
>> target/arm/tcg/cpu32.c                        |   37 +-
>> target/arm/tcg/cpu64.c                        |   42 +-
>> target/arm/whpx/whpx-all.c                    |    6 +-
>> target/i386/kvm/kvm.c                         |   22 +-
>> target/loongarch/kvm/kvm.c                    |   27 +-
>> target/ppc/kvm.c                              |    6 +-
>> target/riscv/kvm/kvm-cpu.c                    |    3 +-
>> target/s390x/kvm/kvm.c                        |    2 +-
>> scripts/aarch64_sysreg_helpers.py             |  118 ++
>> .../update-aarch64-cpu-sysreg-properties.py   |  331 ++++
>> scripts/update-aarch64-cpu-sysregs-header.py  |   59 +
>> target/arm/meson.build                        |    1 +
>> target/arm/trace-events                       |    9 +
>> 33 files changed, 3232 insertions(+), 178 deletions(-)
>> create mode 100644 target/arm/cpu-idregs.h
>> create mode 100644 target/arm/cpu-idregs.h.inc
>> create mode 100644 target/arm/cpu-idregs.c
>> create mode 100644 scripts/aarch64_sysreg_helpers.py
>> create mode 100644 scripts/update-aarch64-cpu-sysreg-properties.py
>> create mode 100755 scripts/update-aarch64-cpu-sysregs-header.py
>>
>> --=20
>> 2.53.0
>>

