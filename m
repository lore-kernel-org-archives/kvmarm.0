Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1181D372056
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 12:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792152469; cv=none; b=Hk5wV5fYKIaMPQVRFdp2+9fJl5mdXmPjaJcbiBxGvuUZhrbB1SygIf2u63obgexbavYGfDXcU38Zx7AJ2D5RG/1c9ON4BHl3HcfpbVbYqMxoYoW/N97PFS2E+57GS9msSYABOFsUuOJ9VWU9/+7bnH/wXC78baHNxECGK/TD534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792152469; c=relaxed/simple;
	bh=xdjFSIWWSkFIgVBsQgrAy3JLQPI+VvTpvScAmtF2sdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ov4Oe8fmEsxYlQgQ6oiom8+FX2RqpexFtLUq8GiRQUKr64R3NmJFiaN8IK3BKHIinyI0boG3pXxOed/PvKJOIY3B650/Z24cg9mZgCUgVUZFehI4Xve1+Ek4EC0iF3zTrOC7dHGnVsURCiPR1u243WtZoKNaTPckOmPx4XFLjoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Euil4mvT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Euil4mvT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792152465;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ju0nFAYOk2Czky0zNl7ufn2mbubdX/H/KKmBDyLc6mA=;
	b=Euil4mvThnqVnsn+6sTNSmk3JqDl/NKW8bTDtAFtyYcXA3jkrlKRWu5w0keejlb7ucZUMc
	tHi55lA/rjt3K0FUUHGnhI8wfPAUOkjhKBYC5qrzAxadU1Yl/X0lhlPyiEe3mahcZPCLdo
	iAvjSj/F2ifC+tl/Vt/D3wQEyZp5yds=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-g3L1lExnP-OEt2inRxRArA-1; Fri, 16 Oct 2026 12:07:43 +0000
X-MC-Unique: g3L1lExnP-OEt2inRxRArA-1
X-Mimecast-MFC-AGG-ID: g3L1lExnP-OEt2inRxRArA_1792152462
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4870142f030so3864078f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 05:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792152462; x=1792757262;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ju0nFAYOk2Czky0zNl7ufn2mbubdX/H/KKmBDyLc6mA=;
        b=1jvqbXOfmObDL4rFZNHpttN2UvLi4eHNn9W3IpeKN2yw5tR2lNKi6lFMRxhfk50ACg
         LAg0RLhpJVuGMJ2GIaB1ywRt+949pHld55+RDQidFjeQbWrlYJowXqfACheE8sW7CoV5
         cY4FAs+Cke5+7oDAhzsmbAh3dO6gPeKJAeeEbUcRVnvOfBuBQG1EqH0oG3kvj+fJBxOQ
         VUescDR4t6KBYv6Nm346TfDD/yNBjNxpjqjK9BaeyoJN+Ma9Ers+951zmyzaPCx1SiIP
         QR3taBw1h5BO2RjYg/aizMO0E0kzwBhKF5hZhEY1TuTx70T1Sq8ql/Vmxx30ubWJEc7h
         t+SQ==
X-Forwarded-Encrypted: i=1; AKwUvBzBnVIX5vJm+pwwKDyNu008oOnNuzoWEMFDjMpy0zKO/wz5docWPFWcUI5txCodjkEa6gybnuM=@lists.linux.dev
X-Gm-Message-State: AFq9FYLddT16oMP/zOR6FRAGMs2LB3dBKQQzgPImzA4omyxrXcb00H+U
	OrlN5nxNoGDKELEiVATtMRsgxlxil5bV3Jhl9N2uUnOIADvHjsnf5tt4w224bGw4eH5+zX0k5fd
	K3aC1l1hW7NWngypuvb3KD5m3haooUiZ0m8ryBXfq0BACiC8Z8CY74TqXww==
X-Gm-Gg: AYBFou201XHwoiHu/dWSSTb+UUhlk1fYUFOuHn3vQOryfqO/3HGvsvMTs3fxd/m1zFE
	vkhg5XOyQ18H+cvKKpWMaOpRlE4UYHQhe30VPHScxlF7LEw8ltt6CgziZqNFdGSZx/fg0jkaJ+t
	FX2RokCf+cwFa4HcU7L6V/eivLlKmei42yq9Bz4LwTQ+o+DeN4x60SUtcUrG3zix4GubEgo0yRI
	M4R0LHhCG2hL+SKjnxEM2CCMWUD6x1e7DBhGgFB+6NoEgLUPkYJCtFNApwD2nE/IN9XppmaElQb
	KwmiJCnxL79UW1VORAHcpN9MpmQXBCThVkNcvMVtSXAziOfJRdgJg7fudEvgtEEOhBoQvMwABis
	226evbEtsnGh3W1p/sDkGFIT64+CphY9egHMR9VtcghlqkBfF
X-Received: by 2002:a05:6000:987:b0:488:7787:469d with SMTP id ffacd0b85a97d-48df14ed887mr13718632f8f.25.1792152462151;
        Fri, 16 Oct 2026 05:07:42 -0700 (PDT)
X-Received: by 2002:a05:6000:987:b0:488:7787:469d with SMTP id ffacd0b85a97d-48df14ed887mr13718556f8f.25.1792152461547;
        Fri, 16 Oct 2026 05:07:41 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd503a24sm4678122f8f.49.2026.10.16.05.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:07:40 -0700 (PDT)
Message-ID: <45c37754-2244-4336-9aa8-12d0b89840d4@redhat.com>
Date: Fri, 16 Oct 2026 14:07:39 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 12/25] target/arm: add arm-v9.0-a-v1 named CPU
 model
To: Khushit Shah <khushit.shah@nutanix.com>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Cc: cohuck@redhat.com, peter.maydell@linaro.org,
 richard.henderson@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 gshan@redhat.com, skolothumtho@nvidia.com, sebott@redhat.com,
 armbru@redhat.com, philmd@linaro.org, yangjinqian1@huawei.com,
 shaju.abraham@nutanix.com, mark.caveayland@nutanix.com,
 ping@khushitshah.com, sandesh.patel@nutanix.com
References: <20260921123249.1708067-1-khushit.shah@nutanix.com>
 <20260921123249.1708067-13-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-13-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4a9egyyf-aJuMJTGyM1ZMNxHsnnfTck98k8WTcmPPsY_1792152462
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Add a KVM-only named CPU model for the Armv9.0-A baseline, following
> DDI0487 revision M.c. The property list is the architecture-mandated
> ID-register field view.
>
> Pointer authentication is omitted because a v9.0-A core may implement
> any PAuth algorithm.
>
> Named models start from a zeroed ID-register view, so features whose
> "not implemented" encoding is non-zero (for example TGran64=0xF,
> DoubleLock=0xF) are set explicitly.
>
> The model is not realizable on its own; implementation-defined fields
> such as CTR_EL0.{CWG,ERG} and ID_AA64DFR0_EL1.CTX_CMPs still have to be
> supplied on the command line. However, this provides a useful baseline
> for upcoming reference core models.
>
> Final ID register state requested from KVM for "arm-v9.0-a-v1":
> [  0] AIDR_EL1                 = 0x0000000000000000
> [  1] CLIDR_EL1                = 0x0000000000000000
> [  2] CTR_EL0                  = 0x0000000080008000
> [  3] DCZID_EL0                = 0x0000000000000000
> [  4] GMID_EL1                 = 0x0000000000000000
> [  5] ID_AA64AFR0_EL1          = 0x0000000000000000
> [  6] ID_AA64AFR1_EL1          = 0x0000000000000000
> [  7] ID_AA64DFR0_EL1          = 0x000000f000000009
> [  8] ID_AA64DFR1_EL1          = 0x0000000000000000
> [  9] ID_AA64DFR2_EL1          = 0x0000000000000000
> [ 10] ID_AA64FPFR0_EL1         = 0x0000000000000000
> [ 11] ID_AA64ISAR0_EL1         = 0x0221100010210000
> [ 12] ID_AA64ISAR1_EL1         = 0x0000011100211002
> [ 13] ID_AA64ISAR2_EL1         = 0x0000000000000000
> [ 14] ID_AA64ISAR3_EL1         = 0x0000000000000000
> [ 15] ID_AA64MMFR0_EL1         = 0x000001110f000000
> [ 16] ID_AA64MMFR1_EL1         = 0x0000000000211000
> [ 17] ID_AA64MMFR2_EL1         = 0x1001001100000011
> [ 18] ID_AA64MMFR3_EL1         = 0x0000000000000000
> [ 19] ID_AA64MMFR4_EL1         = 0x000000000f000000
> [ 20] ID_AA64PFR0_EL1          = 0x1101000010110011
> [ 21] ID_AA64PFR1_EL1          = 0x0000000000000001
> [ 22] ID_AA64PFR2_EL1          = 0x0000000000000000
> [ 23] ID_AA64SMFR0_EL1         = 0x0000000000000000
> [ 24] ID_AA64ZFR0_EL1          = 0x0000000000000000
> [ 25] ID_AFR0_EL1              = 0x0000000000000000
> [ 26] ID_DFR0_EL1              = 0x0000000000000000
> [ 27] ID_DFR1_EL1              = 0x0000000000000000
> [ 28] ID_ISAR0_EL1             = 0x0000000000000000
> [ 29] ID_ISAR1_EL1             = 0x0000000000000000
> [ 30] ID_ISAR2_EL1             = 0x0000000000000000
> [ 31] ID_ISAR3_EL1             = 0x0000000000000000
> [ 32] ID_ISAR4_EL1             = 0x0000000000000000
> [ 33] ID_ISAR5_EL1             = 0x0000000000000000
> [ 34] ID_ISAR6_EL1             = 0x0000000000000000
> [ 35] ID_MMFR0_EL1             = 0x0000000000000000
> [ 36] ID_MMFR1_EL1             = 0x0000000000000000
> [ 37] ID_MMFR2_EL1             = 0x0000000000000000
> [ 38] ID_MMFR3_EL1             = 0x0000000000000000
> [ 39] ID_MMFR4_EL1             = 0x0000000000000000
> [ 40] ID_MMFR5_EL1             = 0x0000000000000000
> [ 41] ID_PFR0_EL1              = 0x0000000000000000
> [ 42] ID_PFR1_EL1              = 0x0000000000000000
> [ 43] ID_PFR2_EL1              = 0x0000000000000000
> [ 44] MIDR_EL1                 = 0x0000000000000000
> [ 45] MPIDR_EL1                = 0x0000000080000000
> [ 46] MVFR0_EL1                = 0x0000000000000000
> [ 47] MVFR1_EL1                = 0x0000000000000000
> [ 48] MVFR2_EL1                = 0x0000000000000000
> [ 49] REVIDR_EL1               = 0x0000000000000000
> [ 50] SMIDR_EL1                = 0x0000000000000000
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  hw/arm/virt.c           |  3 ++
>  target/arm/cpu-models.c | 75 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index e7a56e37f7..01381ab5e7 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -4144,6 +4144,9 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v1")));
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-n2")));
>      }
> +    if (kvm_enabled() && target_aarch64()) {
> +        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9.0-a-v1")));
> +    }
>      if (target_aarch64()) {
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a57")));
> diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
> index 153ee10ae6..7394dd358e 100644
> --- a/target/arm/cpu-models.c
> +++ b/target/arm/cpu-models.c
> @@ -39,7 +39,82 @@
>  /* Maximum parent-chain depth for named CPU models. */
>  #define ARM_NAMED_CPU_MODEL_MAX_DEPTH 16
>  
> +/* Arm-v9.0-a mandatory features. */
> +static const ArmModelPropValue arm_v9_0_a_v1_props[] = {
> +    /* ID_AA64PFR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL0", NUM, 1), /* only FEAT_AA64EL0 (Armv9.0) */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_EL1", NUM, 1), /* only FEAT_AA64EL1 (Armv9.0) */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_RAS", NUM, 1), /* FEAT_RAS (Armv8.2) */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_DIT", NUM, 1), /* FEAT_DIT (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV2", NUM, 1), /* FEAT_CSV2 (Armv8.5) */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_CSV3", NUM, 1), /* FEAT_CSV3 (Armv8.5) */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_FP", NUM, 1), /* FEAT_FP16 */
> +    MODEL_PROP("SYSREG_ID_AA64PFR0_EL1_AdvSIMD", NUM, 1), /* FEAT_FP16 */
I have not found that FP+AdvSIMD (ie FEAT_FP16) were mandated by v9.0
amybe you want this model to implement FP16 but it does not seems
strictly mandated in v9.0
so it might be distinguished from other settings that are truly mandated.

> +
> +    /* ID_AA64PFR1_EL1 */
> +    /* KVM zeroes out these field when MTE is not enabled. */
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_MTE_frac", NUM, 0),
useless as default is 0, no?
> +    MODEL_PROP("SYSREG_ID_AA64PFR1_EL1_BT", NUM, 1), /* FEAT_BTI (Armv8.5) */


> +
> +    /* ID_AA64MMFR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64", NUM, 0xF), /* not mandatory */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4", NUM, 0), /* 4K granular support */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran16_2", NUM, 1), /* not mandatory */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran64_2", NUM, 1), /* not mandatory */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR0_EL1_TGran4_2", NUM, 1), /* not mandatory */
so the top comment, ie. 

+/* Arm-v9.0-a mandatory features. */

should really be updated accordingly. None of that is mandated by v9.0
spec, right?

|
|
> +
> +    /* ID_AA64DFR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DebugVer", NUM, 9), /* FEAT_Debugv8p4 (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_DoubleLock", NUM, 0xF), /* not implemented */
I understand this is mandated by v9.0, ie v9Ap0 ==> (!FEAT_DoubleLock)
> +    /* no PMU for named models */
> +    MODEL_PROP("SYSREG_ID_AA64DFR0_EL1_PMUVer", NUM, 0),
not needed? 

> +
> +    /* CTR_EL0 */
> +    MODEL_PROP("SYSREG_CTR_EL0_L1Ip", NUM, 2), /* FEAT_IVIPT: VIPT cache impl. */
ARMv8.0
> +
> +    /* ID_AA64MMFR4_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR4_EL1_E2H0", NUM, 0xF), /* FEAT_E2H0 not mandatory */
not mandatory. All the non mandatory settings might rather go in the
neoverse child, no? That way it is easier to understand the role of this
parent which enforce mandatory features only
> +
> +    /* ID_AA64ISAR0_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_CRC32", NUM, 1), /* FEAT_CRC32 (Armv8.1) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_Atomic", NUM, 2), /* FEAT_LSE (Armv8.1) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TS", NUM, 2), /* FEAT_FlagM2 (Armv9.0 & FP) */
this is required because FP was opt-in. Otherwise v9.0 does not require
2. As far as I understand there is no  v9Ap0 ==> FEAT_FP

> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_TLB", NUM, 2), /* FEAT_TLBIRANGE (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_RDM", NUM, 1), /* FEAT_RDM (Armv9.0 & FP) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_DP", NUM, 1), /* FEAT_DotProd (Armv9.0 & FP) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR0_EL1_FHM", NUM, 1), /* FEAT_FHM (Armv9.0 & FP) */
> +
> +    /* ID_AA64ISAR1_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_LRCPC", NUM, 2), /* FEAT_LRCPC2 (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FRINTTS", NUM, 1), /* FEAT_FRINTTS (v9.0 & FP) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_FCMA", NUM, 1), /* FEAT_FCMA (Armv9.0 & FP) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_JSCVT", NUM, 1), /* FEAT_JSCVT (Armv9.0 & FP) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_DPB", NUM, 2), /* FEAT_DPB2 (Armv8.5) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_SB", NUM, 1), /* FEAT_SB (Armv8.5) */
> +    MODEL_PROP("SYSREG_ID_AA64ISAR1_EL1_SPECRES", NUM, 1), /* FEAT_SPECRES (Armv8.5) */

For readability please groups all fields that are mandated if v9.0 + FP
+ AdvSIMD. This is still arguable if this shall be part of this model
though
> +    /*
> +     * FEAT_PAuth is mandated by Armv8.3 but is excluded here as reference
> +     * core can choose to implement any PAuth algorithm (APA/API/APA3).
Can you set a default value then? GPI/API <= 1 or GPA3/APA3.  This mens
the child will need to override.
Without that you cannot claim this model to ve v9.0 compliant.

I guess you need to document all named vcpu models in either
docs/system/arm/cpu-features.rst
There is also docs/system/qemu-cpu-models.rst
> +     */
> +
> +    /* ID_AA64MMFR1_EL1 */
nit reorder after AA64_MFR0. All values below look good to me
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_HPDS", NUM, 1), /* FEAT_HPDS (Armv8.1) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_LO", NUM, 1), /* FEAT_LOR (Armv8.1) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_PAN", NUM, 2), /* FEAT_PAN2 (Armv8.2) */
> +
> +    /* ID_AA64MMFR2_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_UAO", NUM, 1), /* FEAT_UAO (Armv8.2) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_CnP", NUM, 1), /* FEAT_TTCNP (Armv8.2) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_TTL", NUM, 1), /* FEAT_TTL (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_AT", NUM, 1), /* FEAT_LSE2 (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_IDS", NUM, 1), /* FEAT_IDST (Armv8.4) */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR2_EL1_E0PD", NUM, 1), /* FEAT_E0PD (Armv8.5) */
> +
> +    MODEL_PROP_END,
> +};
> +
>  static const ArmNamedCpuModel arm_cpu_models[] = {
> +    {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
>      {NULL, NULL, NULL}
>  };
>  
Thanks

Eric

