Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878B26D4CA
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 12:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066396; cv=none; b=BVKI6P5q2Uv6LImZTMks24e50Il6RRp+8lGcnXoXNUhC/PHw9rfygqYU90cDQF2r1TOp0jpZvUWim/7HUJeGZy9LzaTFMwI1Uwq9gymVQONg9OEkptffNiUOavRhlc3gDPvwjw/Cnt96czyQcRacvTrIzZdax6nn5adEj6Y3rAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066396; c=relaxed/simple;
	bh=l8HFTJFDQdhif4/Tf4TtgZJsFwrHmvWlajdrX975XZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=maR7G7W105PMkt+HltGQvJpwnTaCJ4BSa0mjyOlCZA8VaT+hAoFrI5/OMq/n07lX4kGZc7ipIzuMCNHVwygxrjuCGR9u/RsXw4tQqKJY2mNibu6zPYrqTycgW8izYxb6p9+NUVdbHhmtt6ZKiD2CbYy9HPpsuZV1ltgO+btsRrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TBK8eZB0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TBK8eZB0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792066394;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ZS8O6pAKs14B2vAv0EVl9bnzCeWoqf8Dh1MzJORQ00=;
	b=TBK8eZB0bw+dyDKRLYIoHX5JkCU+H07tjwOSJpH9QtRTyx5p3cnpQZ9JFRe1LDIsOID63T
	9e33wjM05SOc+brSOD5yogwZ67BpG9x86ocoAdTcFSfjg0iV2YRhihTF8juecmEPbghaYW
	XcsI01k86Kd41618NswFyrLJR1/DYwk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-LTE2vwOCMfa4UyBbrAGVrg-1; Thu, 15 Oct 2026 12:13:12 +0000
X-MC-Unique: LTE2vwOCMfa4UyBbrAGVrg-1
X-Mimecast-MFC-AGG-ID: LTE2vwOCMfa4UyBbrAGVrg_1792066391
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a0761224e1so18116765e9.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 05:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792066391; x=1792671191;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ZS8O6pAKs14B2vAv0EVl9bnzCeWoqf8Dh1MzJORQ00=;
        b=MpdR3D3AWtKvVVQCVJX8U3/T2/6cxAcigkABHmAQiV4lF3miVlBxM5rizmNPjxsLv1
         xA7/gvqH3051dwmEsE1Xd/S2NfWGWOhY2nBhvVMggFSgo75Zfp2SlOEiCAMJnkdPlG89
         M0B7GZ9Mt6GhptVfsS/Qu6akslhPA7XBxHMOR+8wo6g4pU84AndS9pQwSf3FyE6ulHEz
         MXXEdM2Zv3NNcBvZqRmRe/4KIE5ynpMUigcGFBaxFC1yM4aSlcN3xI6+4wzXtaOLVoJU
         K/WZBNOJ1g8Y6fLthmj+J+D/uzygA28h+TRunGp9sdM9IufvEih40Q2A7Hd9k31d15cp
         xtuQ==
X-Forwarded-Encrypted: i=1; AKwUvByHd8mn/lJPPW8jkjPYCCCj6K2GSjuIHWq+bE1SWCLn1WQR6drxi8WbqlYukOAvsyqlRnyFrHI=@lists.linux.dev
X-Gm-Message-State: AFq9FYIqEayolFYaajrL3np2Rgxv0fMhuPt+1LrlcSuYEs5yBWvFsGwE
	GsushIE8Lr3MaHVr80pAblxmsudm5AjsXZ3g3GAY6wREv7bQbKlAIJ/SS4Yhuf98yXOPaN5lx2X
	Sg1eFCZkC7IoMb1idAxQh9WRzSN2k0fuMqHsq/cblaiMzAATALSNkGwYIRT/4bEYpWw==
X-Gm-Gg: AYBFou2i7yJdkLeSiD+gXRKlMPwMrVjh5l+VsE9T7GEg8vaJ0uiGkrwqMxH1sz8+Xbk
	cSi2zaxSKwRZlwtwOjUv7+kY9rbTY4EOByROzIv6mcTKEF3vXHD1M8kyrpOizVqOE2o8gaoqLsy
	xbX0jEsxCpl13On7IQx9n/R52QFO02fggsvVHs602CtguyvimJeJGWbxn8h9kYD1aessdtb/SHv
	Wbb8W07ovj0EO9fzCFiZGDMSpvALcPgiI2a6FuSV+OlnU4+kITwNhN6RIlP2AXMJxvmzEQzv9kY
	GvZTMGnYJsZsKGC1e0Cv0JFNMnqAii5or3o5LK444ykBoiddaLicNicX6nQTr6A0SUJTmd+eY+Y
	vtlnmdU4KByqiLDveMhQp1YuXJy/SjND4YRbnAmm3ImjnfGJT
X-Received: by 2002:a05:600c:3b98:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-4a18e49886amr424420935e9.10.1792066390213;
        Thu, 15 Oct 2026 05:13:10 -0700 (PDT)
X-Received: by 2002:a05:600c:3b98:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-4a18e49886amr424420585e9.10.1792066389771;
        Thu, 15 Oct 2026 05:13:09 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd99faf3sm66449875e9.14.2026.10.15.05.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 05:13:09 -0700 (PDT)
Message-ID: <395b66c9-4173-401b-b469-8972b710aae2@redhat.com>
Date: Thu, 15 Oct 2026 14:13:07 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH v4 14/25] target/arm: add neoverse-v2-v2 named CPU
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
 <20260921123249.1708067-15-khushit.shah@nutanix.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20260921123249.1708067-15-khushit.shah@nutanix.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -fw5DxOvLaDYuS57IK3owkT0lLuD9UUq9TAzJRWlMMA_1792066391
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Khushit,

On 9/21/26 2:32 PM, Khushit Shah wrote:
> Add a KVM-only named CPU model for Neoverse V2 r0p1 (TRM 102375),
> inheriting from neoverse-v2-v1 (r0p0).
>
> r0p1 only changes MIDR_EL1.Revision and adds FEAT_ECBHB
> (ID_AA64MMFR1_EL1.ECBHB).
>
> Final ID register state requested from KVM for "neoverse-v2-v2":
> [  0] AIDR_EL1                 = 0x0000000000000000
> [  1] CLIDR_EL1                = 0x0000000000000000
> [  2] CTR_EL0                  = 0x000000009444c004
> [  3] DCZID_EL0                = 0x0000000000000004
> [  4] GMID_EL1                 = 0x0000000000000000
> [  5] ID_AA64AFR0_EL1          = 0x0000000000000000
> [  6] ID_AA64AFR1_EL1          = 0x0000000000000000
> [  7] ID_AA64DFR0_EL1          = 0x000000f010305009
> [  8] ID_AA64DFR1_EL1          = 0x0000000000000000
> [  9] ID_AA64DFR2_EL1          = 0x0000000000000000
> [ 10] ID_AA64FPFR0_EL1         = 0x0000000000000000
> [ 11] ID_AA64ISAR0_EL1         = 0x0221100010210000
> [ 12] ID_AA64ISAR1_EL1         = 0x0011111101211052
> [ 13] ID_AA64ISAR2_EL1         = 0x0000000000000000
> [ 14] ID_AA64ISAR3_EL1         = 0x0000000000000000
> [ 15] ID_AA64MMFR0_EL1         = 0x0000011100101125
> [ 16] ID_AA64MMFR1_EL1         = 0x1000000010312122
> [ 17] ID_AA64MMFR2_EL1         = 0x1221011110001011
> [ 18] ID_AA64MMFR3_EL1         = 0x0000000000000000
> [ 19] ID_AA64MMFR4_EL1         = 0x0000000000000000
> [ 20] ID_AA64PFR0_EL1          = 0x1101000120110011
> [ 21] ID_AA64PFR1_EL1          = 0x0000000000000021
> [ 22] ID_AA64PFR2_EL1          = 0x0000000000000000
> [ 23] ID_AA64SMFR0_EL1         = 0x0000000000000000
> [ 24] ID_AA64ZFR0_EL1          = 0x0000100000110001
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
> [ 44] MIDR_EL1                 = 0x00000000410fd4f1
> [ 45] MPIDR_EL1                = 0x0000000080000000
> [ 46] MVFR0_EL1                = 0x0000000000000000
> [ 47] MVFR1_EL1                = 0x0000000000000000
> [ 48] MVFR2_EL1                = 0x0000000000000000
> [ 49] REVIDR_EL1               = 0x0000000000000000
> [ 50] SMIDR_EL1                = 0x0000000000000000
>
> Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> ---
>  hw/arm/virt.c           |  1 +
>  target/arm/cpu-models.c | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index f5a8ea1145..90e818690c 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -4147,6 +4147,7 @@ static GPtrArray *virt_get_valid_cpu_types(const MachineState *ms)
>      if (kvm_enabled() && target_aarch64()) {
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("arm-v9.0-a-v1")));
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v1")));
> +        g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("neoverse-v2-v2")));
>      }
>      if (target_aarch64()) {
>          g_ptr_array_add(vct, g_strdup(ARM_CPU_TYPE_NAME("cortex-a53")));
> diff --git a/target/arm/cpu-models.c b/target/arm/cpu-models.c
> index 2de67f353b..af60924953 100644
> --- a/target/arm/cpu-models.c
> +++ b/target/arm/cpu-models.c
> @@ -16,6 +16,7 @@
>   * Current Hierarchy:
>   * arm-v9.0-a-v1
>   *   neoverse-v2-v1 (r0p0)
> + *     neoverse-v2-v2 (r0p1)
>   * SPDX-License-Identifier: GPL-2.0-or-later
>   */
>  
> @@ -212,9 +213,21 @@ static const ArmModelPropValue neoverse_v2_v1_props[] = {
>      MODEL_PROP_END
>  };
>  
> +/* Neoverse V2 CPU model (TRM 102375, r0p1), inherits from neoverse-v2-v1. */
> +static const ArmModelPropValue neoverse_v2_v2_props[] = {
> +    /* MIDR_EL1 */
> +    MODEL_PROP("SYSREG_MIDR_EL1_Revision", NUM, 0x1), /* r0p1 */
> +
> +    /* ID_AA64MMFR1_EL1 */
> +    MODEL_PROP("SYSREG_ID_AA64MMFR1_EL1_ECBHB", NUM, 1), /* FEAT_ECBHB */
> +
> +    MODEL_PROP_END,
> +};
> +
>  static const ArmNamedCpuModel arm_cpu_models[] = {
>      {"arm-v9.0-a-v1", NULL, arm_v9_0_a_v1_props},
>      {"neoverse-v2-v1", "arm-v9.0-a-v1", neoverse_v2_v1_props},
> +    {"neoverse-v2-v2", "neoverse-v2-v1", neoverse_v2_v2_props},
nit I would call it directly neoverse-v2-r0p1 and leave the -v<n> suffix
for potential fixes. Same for r0p0 obviously.

Thanks

Eric
>      {NULL, NULL, NULL}
>  };
>  

