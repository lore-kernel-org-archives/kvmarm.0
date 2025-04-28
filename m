Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EC02AD04
	for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745854780; cv=none; b=f2+2S+XqaPDtFq2awXdSwuIBLRfos8fos+7SGS1sr7pqI3+r/pNtG4HQc6H4QO1eoyiX3PIP10B5Ym3ZVKCj2Z1s+7U8gGgCQXn1+sRZn6sCEefshLZzRJOlvUPiPPnSYwkWWuvfTINnIAdJJlyqVln3FJpNTXLoCzfVMNKLXsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745854780; c=relaxed/simple;
	bh=/mXnq+fJ1sG3h5nxOg/JYpR1ValNnrMmPQFPQU8807s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e0aHw5CTBzxZnzaCgWrqdVL0YYHLcWfT9LV/MeHHM8VrF9k1luT3tJ7HiJJtuK594lce20BSBboi8ui8LU00IQX57W5Z0rz9s2TnMik19s26AWKeapanFjytWpwxfjtBqrU9Gke18YX1r4HfkoPXAO8V7fyr5eUi8OILUdo1Smk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IM4s2zij; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IM4s2zij"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745854776;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXapd7NYWRzmDUaMVe+P8NaSGjdrTACqXbLK+NUx8aA=;
	b=IM4s2zij68gJTSVvK0S/mvPHR2Hxqm/NQhCYiVQLAbNoAMhaCXQjze6iTTr/UmoJVsIPUq
	l6Hssk3uVc1IcH47zUrsQr4ISXFpPfiDvTN5BxYqqmfL461EiHU0xeH6oXE2YDOOROV6O6
	jnjXxaSSbHsmbihq1FYE0VmSmcylCKk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-WB9uHQeNMreAbtM_azL8lQ-1; Mon, 28 Apr 2025 11:39:32 -0400
X-MC-Unique: WB9uHQeNMreAbtM_azL8lQ-1
X-Mimecast-MFC-AGG-ID: WB9uHQeNMreAbtM_azL8lQ_1745854771
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43cf446681cso28592515e9.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Apr 2025 08:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745854771; x=1746459571;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RXapd7NYWRzmDUaMVe+P8NaSGjdrTACqXbLK+NUx8aA=;
        b=EnlbG+zHnvRN4ZiK+sXcxOwwKbSqvz76un6KXUeJ9HbD/RtaQmUAOc52VtsGpa0fsa
         /OOLaIqQtXMBUsa0DIp1eLEB4cOSTvPNoiG5lQSbm8eGbCi8N5bUuB/t2MyR+w1rSaMp
         +CAeIqx/LW9t1UUJc8ewaSo3fWgOCL5jPgo2iQnFX3WHbbYArz/E8qgqaZigu7xLG+Ye
         /2V6gNQVimq9RolWU51Zp4AisI2r+S1OyZCA0mkon/IV2v3GLrZHP7/CAKIQrp+y4uQ7
         O1jPnNGLQT+QR43YyI13u3nPNjEOh3WBy9e3gFAWHJYUF/c2+4fkeqijBUL3QxVtR75l
         ze3A==
X-Forwarded-Encrypted: i=1; AJvYcCWpaPgpmpDZJjP7UQO6L08K5n9JD0uut8XGV56/QQ1R+QJET4uqDs761rkYAwBTn2bu/4hCPhg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0fj9tPPDupUdX5b0vZUOwjoi14zCuFOJTnZ7iASrhZcdKgW44
	qhIJXXCWOXUd1aibcte3hrio1gW3wxKA8aCEUlVc4DtVe4zKiXvftq9NbjkD0JL5ez2i1v3/p7X
	DKx9bXs8Rv73umFAsSi0RaIkyKHpMpecfGubhvDQvI+TAffxcslX5Pw==
X-Gm-Gg: ASbGnctpuGVARm+5TnP1jzx1pKTkP7DyYdSh8O4iTZKDjF0rmKSSZbCxFG3PENJQ6BY
	zCEKMpnNzzGkBc4IvBM3jRXYvjsXvpboLNA+VP1/tTFRHthOky63TtZdzZCqfoccz1tCGf2tjxl
	CJA33kZv+n1aMTtB0Ly2WhWlUzkpwEGU+9wIsOlaFk3eRr9X5+soXe19B3NsS/OJwQWK/HeclyI
	877iG8fmrJyNwKTw2wgvwmCJZ9qEcBDYO5vLS9abWfujXaDeYk2CKaTDRwVW8t6jRsPsjscZyIp
	AiRqSi9If55aoCjAFENtGAN11yO/oeg372qLfpzrD1P/IJhUzE/a55lj/Es=
X-Received: by 2002:a05:600c:1e1c:b0:434:fa55:eb56 with SMTP id 5b1f17b1804b1-440a65b6faemr107909555e9.7.1745854771317;
        Mon, 28 Apr 2025 08:39:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6CUDPbszbTgz7yxt/b1M+rx+a0zOI3YH4Qj6KZVsOIJpC+ek3oFHf8QMpY9pIE56rzLmenQ==
X-Received: by 2002:a05:600c:1e1c:b0:434:fa55:eb56 with SMTP id 5b1f17b1804b1-440a65b6faemr107909015e9.7.1745854770691;
        Mon, 28 Apr 2025 08:39:30 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d29b990sm165131835e9.4.2025.04.28.08.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 08:39:29 -0700 (PDT)
Message-ID: <07b785e0-431d-40ba-ab04-56336fdac483@redhat.com>
Date: Mon, 28 Apr 2025 17:39:28 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH for-10.1 v5 04/13] arm/cpu: Store aa64pfr0/1 into the
 idregs array
To: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
 peter.maydell@linaro.org, richard.henderson@linaro.org,
 alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
 sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
 berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
 agraf@csgraf.de
Cc: shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
 pbonzini@redhat.com
References: <20250409144304.912325-1-cohuck@redhat.com>
 <20250409144304.912325-5-cohuck@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250409144304.912325-5-cohuck@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sc4sRkAf81S-2yoVPa1u2apCfw4F6GZS97TTcKNEgSU_1745854771
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/25 4:42 PM, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-features.h | 40 ++++++++++++++++-----------------
>  target/arm/cpu.c          | 29 ++++++++----------------
>  target/arm/cpu.h          |  2 --
>  target/arm/cpu64.c        | 14 ++++--------
>  target/arm/helper.c       |  6 ++---
>  target/arm/hvf/hvf.c      |  9 ++++----
>  target/arm/kvm.c          | 24 +++++++++-----------
>  target/arm/tcg/cpu64.c    | 47 ++++++++++++++++++---------------------
>  8 files changed, 73 insertions(+), 98 deletions(-)
>
> diff --git a/target/arm/cpu-features.h b/target/arm/cpu-features.h
> index 37946d759375..5cc4721e6406 100644
> --- a/target/arm/cpu-features.h
> +++ b/target/arm/cpu-features.h
> @@ -606,68 +606,68 @@ static inline bool isar_feature_aa64_rpres(const ARMISARegisters *id)
>  static inline bool isar_feature_aa64_fp_simd(const ARMISARegisters *id)
>  {
>      /* We always set the AdvSIMD and FP fields identically.  */
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, FP) != 0xf;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, FP) != 0xf;
>  }
>  
>  static inline bool isar_feature_aa64_fp16(const ARMISARegisters *id)
>  {
>      /* We always set the AdvSIMD and FP fields identically wrt FP16.  */
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, FP) == 1;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, FP) == 1;
>  }
>  
>  static inline bool isar_feature_aa64_aa32(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, EL0) >= 2;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, EL0) >= 2;
>  }
>  
>  static inline bool isar_feature_aa64_aa32_el1(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, EL1) >= 2;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, EL1) >= 2;
>  }
>  
>  static inline bool isar_feature_aa64_aa32_el2(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, EL2) >= 2;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, EL2) >= 2;
>  }
>  
>  static inline bool isar_feature_aa64_ras(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, RAS) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, RAS) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_doublefault(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, RAS) >= 2;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, RAS) >= 2;
>  }
>  
>  static inline bool isar_feature_aa64_sve(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, SVE) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, SVE) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_sel2(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, SEL2) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, SEL2) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_rme(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, RME) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, RME) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_dit(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, DIT) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR0, DIT) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_scxtnum(const ARMISARegisters *id)
>  {
> -    int key = FIELD_EX64(id->id_aa64pfr0, ID_AA64PFR0, CSV2);
> +    int key = FIELD_EX64_IDREG(id, ID_AA64PFR0, CSV2);
>      if (key >= 2) {
>          return true;      /* FEAT_CSV2_2 */
>      }
>      if (key == 1) {
> -        key = FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, CSV2_FRAC);
> +        key = FIELD_EX64_IDREG(id, ID_AA64PFR1, CSV2_FRAC);
>          return key >= 2;  /* FEAT_CSV2_1p2 */
>      }
>      return false;
> @@ -675,37 +675,37 @@ static inline bool isar_feature_aa64_scxtnum(const ARMISARegisters *id)
>  
>  static inline bool isar_feature_aa64_ssbs(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, SSBS) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, SSBS) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_bti(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, BT) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, BT) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_mte_insn_reg(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, MTE) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, MTE) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_mte(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, MTE) >= 2;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, MTE) >= 2;
>  }
>  
>  static inline bool isar_feature_aa64_mte3(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, MTE) >= 3;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, MTE) >= 3;
>  }
>  
>  static inline bool isar_feature_aa64_sme(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, SME) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, SME) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_nmi(const ARMISARegisters *id)
>  {
> -    return FIELD_EX64(id->id_aa64pfr1, ID_AA64PFR1, NMI) != 0;
> +    return FIELD_EX64_IDREG(id, ID_AA64PFR1, NMI) != 0;
>  }
>  
>  static inline bool isar_feature_aa64_tgran4_lpa2(const ARMISARegisters *id)
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index f8783eff1d41..23be9ab97334 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -2126,14 +2126,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>      }
>  
>      if (!cpu->has_vfp) {
> -        uint64_t t;
>          uint32_t u;
>  
>          FIELD_DP64_IDREG(isar, ID_AA64ISAR1, JSCVT, 0);
>  
> -        t = cpu->isar.id_aa64pfr0;
> -        t = FIELD_DP64(t, ID_AA64PFR0, FP, 0xf);
> -        cpu->isar.id_aa64pfr0 = t;
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, FP, 0xf);
>  
>          u = cpu->isar.id_isar6;
>          u = FIELD_DP32(u, ID_ISAR6, JSCVT, 0);
> @@ -2188,9 +2185,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>          t = FIELD_DP64(t, ID_AA64ISAR1, I8MM, 0);
>          SET_IDREG(isar, ID_AA64ISAR1, t);
>  
> -        t = cpu->isar.id_aa64pfr0;
> -        t = FIELD_DP64(t, ID_AA64PFR0, ADVSIMD, 0xf);
> -        cpu->isar.id_aa64pfr0 = t;
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, ADVSIMD, 0xf);
>  
>          u = cpu->isar.id_isar5;
>          u = FIELD_DP32(u, ID_ISAR5, AES, 0);
> @@ -2332,12 +2327,10 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>           */
>          cpu->isar.id_pfr1 = FIELD_DP32(cpu->isar.id_pfr1, ID_PFR1, SECURITY, 0);
>          cpu->isar.id_dfr0 = FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, COPSDBG, 0);
> -        cpu->isar.id_aa64pfr0 = FIELD_DP64(cpu->isar.id_aa64pfr0,
> -                                           ID_AA64PFR0, EL3, 0);
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, EL3, 0);
>  
>          /* Disable the realm management extension, which requires EL3. */
> -        cpu->isar.id_aa64pfr0 = FIELD_DP64(cpu->isar.id_aa64pfr0,
> -                                           ID_AA64PFR0, RME, 0);
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, RME, 0);
>      }
>  
>      if (!cpu->has_el2) {
> @@ -2372,8 +2365,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>           * Disable the hypervisor feature bits in the processor feature
>           * registers if we don't have EL2.
>           */
> -        cpu->isar.id_aa64pfr0 = FIELD_DP64(cpu->isar.id_aa64pfr0,
> -                                           ID_AA64PFR0, EL2, 0);
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, EL2, 0);
>          cpu->isar.id_pfr1 = FIELD_DP32(cpu->isar.id_pfr1,
>                                         ID_PFR1, VIRTUALIZATION, 0);
>      }
> @@ -2394,8 +2386,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>           * This matches Cortex-A710 BROADCASTMTE input being LOW.
>           */
>          if (tcg_enabled() && cpu->tag_memory == NULL) {
> -            cpu->isar.id_aa64pfr1 =
> -                FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 1);
> +            FIELD_DP64_IDREG(isar, ID_AA64PFR1, MTE, 1);
>          }
>  
>          /*
> @@ -2403,7 +2394,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>           * enabled on the guest (i.e mte=off), clear guest's MTE bits."
>           */
>          if (kvm_enabled() && !cpu->kvm_mte) {
> -                FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
> +                FIELD_DP64_IDREG(isar, ID_AA64PFR1, MTE, 0);
>          }
>  #endif
>      }
> @@ -2442,13 +2433,11 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>          cpu->isar.id_dfr0 =
>              FIELD_DP32(cpu->isar.id_dfr0, ID_DFR0, MMAPTRC, 0);
>          /* FEAT_AMU (Activity Monitors Extension) */
> -        cpu->isar.id_aa64pfr0 =
> -            FIELD_DP64(cpu->isar.id_aa64pfr0, ID_AA64PFR0, AMU, 0);
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, AMU, 0);
>          cpu->isar.id_pfr0 =
>              FIELD_DP32(cpu->isar.id_pfr0, ID_PFR0, AMU, 0);
>          /* FEAT_MPAM (Memory Partitioning and Monitoring Extension) */
> -        cpu->isar.id_aa64pfr0 =
> -            FIELD_DP64(cpu->isar.id_aa64pfr0, ID_AA64PFR0, MPAM, 0);
> +        FIELD_DP64_IDREG(isar, ID_AA64PFR0, MPAM, 0);
>      }
>  
>      /* MPU can be configured out of a PMSA CPU either by setting has-mpu
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 4a143bc64b27..83ac125b97c5 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1097,8 +1097,6 @@ struct ArchCPU {
>          uint32_t dbgdidr;
>          uint32_t dbgdevid;
>          uint32_t dbgdevid1;
> -        uint64_t id_aa64pfr0;
> -        uint64_t id_aa64pfr1;
>          uint64_t id_aa64mmfr0;
>          uint64_t id_aa64mmfr1;
>          uint64_t id_aa64mmfr2;
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index b914f2ed58b5..111b2514218e 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -310,16 +310,13 @@ static bool cpu_arm_get_sve(Object *obj, Error **errp)
>  static void cpu_arm_set_sve(Object *obj, bool value, Error **errp)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> -    uint64_t t;
>  
>      if (value && kvm_enabled() && !kvm_arm_sve_supported()) {
>          error_setg(errp, "'sve' feature not supported by KVM on this host");
>          return;
>      }
>  
> -    t = cpu->isar.id_aa64pfr0;
> -    t = FIELD_DP64(t, ID_AA64PFR0, SVE, value);
> -    cpu->isar.id_aa64pfr0 = t;
> +    FIELD_DP64_IDREG(&cpu->isar, ID_AA64PFR0, SVE, value);
>  }
>  
>  void arm_cpu_sme_finalize(ARMCPU *cpu, Error **errp)
> @@ -370,11 +367,8 @@ static bool cpu_arm_get_sme(Object *obj, Error **errp)
>  static void cpu_arm_set_sme(Object *obj, bool value, Error **errp)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> -    uint64_t t;
>  
> -    t = cpu->isar.id_aa64pfr1;
> -    t = FIELD_DP64(t, ID_AA64PFR1, SME, value);
> -    cpu->isar.id_aa64pfr1 = t;
> +    FIELD_DP64_IDREG(&cpu->isar, ID_AA64PFR1, SME, value);
>  }
>  
>  static bool cpu_arm_get_sme_fa64(Object *obj, Error **errp)
> @@ -676,7 +670,7 @@ static void aarch64_a57_initfn(Object *obj)
>      cpu->isar.id_isar4 = 0x00011142;
>      cpu->isar.id_isar5 = 0x00011121;
>      cpu->isar.id_isar6 = 0;
> -    cpu->isar.id_aa64pfr0 = 0x00002222;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
>      cpu->isar.id_aa64dfr0 = 0x10305106;
>      SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64mmfr0 = 0x00001124;
> @@ -738,7 +732,7 @@ static void aarch64_a53_initfn(Object *obj)
>      cpu->isar.id_isar4 = 0x00011142;
>      cpu->isar.id_isar5 = 0x00011121;
>      cpu->isar.id_isar6 = 0;
> -    cpu->isar.id_aa64pfr0 = 0x00002222;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
>      cpu->isar.id_aa64dfr0 = 0x10305106;
>      SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64mmfr0 = 0x00001122; /* 40 bit physical addr */
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 548e51e82a8e..716d0570f6d6 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -6940,7 +6940,7 @@ static uint64_t id_pfr1_read(CPUARMState *env, const ARMCPRegInfo *ri)
>  static uint64_t id_aa64pfr0_read(CPUARMState *env, const ARMCPRegInfo *ri)
>  {
>      ARMCPU *cpu = env_archcpu(env);
> -    uint64_t pfr0 = cpu->isar.id_aa64pfr0;
> +    uint64_t pfr0 = GET_IDREG(&cpu->isar, ID_AA64PFR0);
>  
>      if (env->gicv3state) {
>          pfr0 |= 1 << 24;
> @@ -7914,7 +7914,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>                .access = PL1_R,
>  #ifdef CONFIG_USER_ONLY
>                .type = ARM_CP_CONST,
> -              .resetvalue = cpu->isar.id_aa64pfr0
> +              .resetvalue = GET_IDREG(isar, ID_AA64PFR0)
>  #else
>                .type = ARM_CP_NO_RAW,
>                .accessfn = access_aa64_tid3,
> @@ -7926,7 +7926,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 1,
>                .access = PL1_R, .type = ARM_CP_CONST,
>                .accessfn = access_aa64_tid3,
> -              .resetvalue = cpu->isar.id_aa64pfr1},
> +              .resetvalue = GET_IDREG(isar, ID_AA64PFR1)},
>              { .name = "ID_AA64PFR2_EL1_RESERVED", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 2,
>                .access = PL1_R, .type = ARM_CP_CONST,
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index 8d6852fd7a52..9d37ca6bbbde 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -862,8 +862,8 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>          int reg;
>          uint64_t *val;
>      } regs[] = {
> -        { HV_SYS_REG_ID_AA64PFR0_EL1, &host_isar.id_aa64pfr0 },
> -        { HV_SYS_REG_ID_AA64PFR1_EL1, &host_isar.id_aa64pfr1 },
> +        { HV_SYS_REG_ID_AA64PFR0_EL1, &host_isar.idregs[ID_AA64PFR0_EL1_IDX] },
> +        { HV_SYS_REG_ID_AA64PFR1_EL1, &host_isar.idregs[ID_AA64PFR1_EL1_IDX] },
>          { HV_SYS_REG_ID_AA64DFR0_EL1, &host_isar.id_aa64dfr0 },
>          { HV_SYS_REG_ID_AA64DFR1_EL1, &host_isar.id_aa64dfr1 },
>          { HV_SYS_REG_ID_AA64ISAR0_EL1, &host_isar.idregs[ID_AA64ISAR0_EL1_IDX] },
> @@ -910,7 +910,8 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>       * - fix any assumptions we made that SME implies SVE (since
>       *   on the M4 there is SME but not SVE)
>       */
> -    host_isar.id_aa64pfr1 &= ~R_ID_AA64PFR1_SME_MASK;
> +    SET_IDREG(&host_isar, ID_AA64PFR1,
> +              GET_IDREG(&host_isar, ID_AA64PFR1) & ~R_ID_AA64PFR1_SME_MASK);
>  
>      ahcf->isar = host_isar;
>  
> @@ -927,7 +928,7 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>      ahcf->reset_sctlr |= 0x00800000;
>  
>      /* Make sure we don't advertise AArch32 support for EL0/EL1 */
> -    if ((host_isar.id_aa64pfr0 & 0xff) != 0x11) {
> +    if ((GET_IDREG(&host_isar, ID_AA64PFR0) & 0xff) != 0x11) {
>          return false;
>      }
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index e8992348b27f..44a5e219b051 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -331,8 +331,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>      ahcf->dtb_compatible = "arm,arm-v8";
>      int fd = fdarray[2];
>  
> -    err = read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr0,
> -                         ARM64_SYS_REG(3, 0, 0, 4, 0));
> +    err = get_host_cpu_reg(fd, ahcf, ID_AA64PFR0_EL1_IDX);
>      if (unlikely(err < 0)) {
>          /*
>           * Before v4.15, the kernel only exposed a limited number of system
> @@ -350,11 +349,10 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>           * ??? Either of these sounds like too much effort just
>           *     to work around running a modern host kernel.
>           */
> -        ahcf->isar.id_aa64pfr0 = 0x00000011; /* EL1&0, AArch64 only */
> +        SET_IDREG(&ahcf->isar, ID_AA64PFR0, 0x00000011); /* EL1&0, AArch64 only */
>          err = 0;
>      } else {
> -        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr1,
> -                              ARM64_SYS_REG(3, 0, 0, 4, 1));
> +        err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64smfr0,
>                                ARM64_SYS_REG(3, 0, 0, 4, 5));
>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr0,
> @@ -380,10 +378,8 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>           * than skipping the reads and leaving 0, as we must avoid
>           * considering the values in every case.
>           */
> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr0,
> -                              ARM64_SYS_REG(3, 0, 0, 1, 0));
> -        err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_pfr1,
> -                              ARM64_SYS_REG(3, 0, 0, 1, 1));
> +        err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR0_EL1_IDX);
Hum I think we have a conversion mistake here:

+DEF(ID_PFR0_EL1, 3, 0, 0, 1, 0)
+DEF(ID_PFR1_EL1, 3, 0, 0, 1, 1)

Eric

> +        err |= get_host_cpu_reg(fd, ahcf, ID_AA64PFR1_EL1_IDX);
>          err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_dfr0,
>                                ARM64_SYS_REG(3, 0, 0, 1, 2));
>          err |= read_sys_reg32(fdarray[2], &ahcf->isar.id_mmfr0,
> @@ -434,14 +430,14 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>           * arch/arm64/kvm/sys_regs.c:trap_dbgidr() does.
>           * We only do this if the CPU supports AArch32 at EL1.
>           */
> -        if (FIELD_EX32(ahcf->isar.id_aa64pfr0, ID_AA64PFR0, EL1) >= 2) {
> -            int wrps = FIELD_EX64(ahcf->isar.id_aa64dfr0, ID_AA64DFR0, WRPS);
> -            int brps = FIELD_EX64(ahcf->isar.id_aa64dfr0, ID_AA64DFR0, BRPS);
> +        if (FIELD_EX32_IDREG(&ahcf->isar, ID_AA64PFR0, EL1) >= 2) {
> +            int wrps = FIELD_EX64(&ahcf->isar.id_aa64dfr0, ID_AA64DFR0, WRPS);
> +            int brps = FIELD_EX64(&ahcf->isar.id_aa64dfr0, ID_AA64DFR0, BRPS);
>              int ctx_cmps =
> -                FIELD_EX64(ahcf->isar.id_aa64dfr0, ID_AA64DFR0, CTX_CMPS);
> +                FIELD_EX64(&ahcf->isar.id_aa64dfr0, ID_AA64DFR0, CTX_CMPS);
>              int version = 6; /* ARMv8 debug architecture */
>              bool has_el3 =
> -                !!FIELD_EX32(ahcf->isar.id_aa64pfr0, ID_AA64PFR0, EL3);
> +                !!FIELD_EX32_IDREG(&ahcf->isar, ID_AA64PFR0, EL3);
>              uint32_t dbgdidr = 0;
>  
>              dbgdidr = FIELD_DP32(dbgdidr, DBGDIDR, WRPS, wrps);
> diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
> index f62e62595d8b..478ef839bafa 100644
> --- a/target/arm/tcg/cpu64.c
> +++ b/target/arm/tcg/cpu64.c
> @@ -63,8 +63,8 @@ static void aarch64_a35_initfn(Object *obj)
>      cpu->isar.id_isar3 = 0x01112131;
>      cpu->isar.id_isar4 = 0x00011142;
>      cpu->isar.id_isar5 = 0x00011121;
> -    cpu->isar.id_aa64pfr0 = 0x00002222;
> -    cpu->isar.id_aa64pfr1 = 0;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
> +    SET_IDREG(isar, ID_AA64PFR1, 0);
>      cpu->isar.id_aa64dfr0 = 0x10305106;
>      cpu->isar.id_aa64dfr1 = 0;
>      SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
> @@ -158,11 +158,8 @@ static bool cpu_arm_get_rme(Object *obj, Error **errp)
>  static void cpu_arm_set_rme(Object *obj, bool value, Error **errp)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> -    uint64_t t;
>  
> -    t = cpu->isar.id_aa64pfr0;
> -    t = FIELD_DP64(t, ID_AA64PFR0, RME, value);
> -    cpu->isar.id_aa64pfr0 = t;
> +    FIELD_DP64_IDREG(&cpu->isar, ID_AA64PFR0, RME, value);
>  }
>  
>  static void cpu_max_set_l0gptsz(Object *obj, Visitor *v, const char *name,
> @@ -228,8 +225,8 @@ static void aarch64_a55_initfn(Object *obj)
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
>      cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
> -    cpu->isar.id_aa64pfr0  = 0x0000000010112222ull;
> -    cpu->isar.id_aa64pfr1  = 0x0000000000000010ull;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x0000000010112222ull);
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000010ull);
>      cpu->id_afr0       = 0x00000000;
>      cpu->isar.id_dfr0  = 0x04010088;
>      cpu->isar.id_isar0 = 0x02101110;
> @@ -312,7 +309,7 @@ static void aarch64_a72_initfn(Object *obj)
>      cpu->isar.id_isar3 = 0x01112131;
>      cpu->isar.id_isar4 = 0x00011142;
>      cpu->isar.id_isar5 = 0x00011121;
> -    cpu->isar.id_aa64pfr0 = 0x00002222;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x00002222);
>      cpu->isar.id_aa64dfr0 = 0x10305106;
>      SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64mmfr0 = 0x00001124;
> @@ -361,8 +358,8 @@ static void aarch64_a76_initfn(Object *obj)
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
>      cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
> -    cpu->isar.id_aa64pfr0  = 0x1100000010111112ull; /* GIC filled in later */
> -    cpu->isar.id_aa64pfr1  = 0x0000000000000010ull;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000010ull);
>      cpu->id_afr0       = 0x00000000;
>      cpu->isar.id_dfr0  = 0x04010088;
>      cpu->isar.id_isar0 = 0x02101110;
> @@ -427,8 +424,8 @@ static void aarch64_a64fx_initfn(Object *obj)
>      cpu->revidr = 0x00000000;
>      cpu->ctr = 0x86668006;
>      cpu->reset_sctlr = 0x30000180;
> -    cpu->isar.id_aa64pfr0 =   0x0000000101111111; /* No RAS Extensions */
> -    cpu->isar.id_aa64pfr1 = 0x0000000000000000;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x0000000101111111); /* No RAS Extensions */
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000000);
>      cpu->isar.id_aa64dfr0 = 0x0000000010305408;
>      cpu->isar.id_aa64dfr1 = 0x0000000000000000;
>      cpu->id_aa64afr0 = 0x0000000000000000;
> @@ -609,8 +606,8 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
>      cpu->isar.id_aa64mmfr2 = 0x0000000000001011ull;
> -    cpu->isar.id_aa64pfr0  = 0x1100000010111112ull; /* GIC filled in later */
> -    cpu->isar.id_aa64pfr1  = 0x0000000000000020ull;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x1100000010111112ull); /* GIC filled in later */
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000020ull);
>      cpu->id_afr0       = 0x00000000;
>      cpu->isar.id_dfr0  = 0x04010088;
>      cpu->isar.id_isar0 = 0x02101110;
> @@ -688,8 +685,8 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
>      cpu->isar.id_aa64mmfr2 = 0x0220011102101011ull;
> -    cpu->isar.id_aa64pfr0  = 0x1101110120111112ull; /* GIC filled in later */
> -    cpu->isar.id_aa64pfr1  = 0x0000000000000020ull;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x1101110120111112ull); /* GIC filled in later */
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000020ull);
>      cpu->id_afr0       = 0x00000000;
>      cpu->isar.id_dfr0  = 0x15011099;
>      cpu->isar.id_isar0 = 0x02101110;
> @@ -925,8 +922,8 @@ static void aarch64_a710_initfn(Object *obj)
>      cpu->isar.mvfr1    = 0x13211111;
>      cpu->isar.mvfr2    = 0x00000043;
>      cpu->isar.id_pfr2  = 0x00000011;
> -    cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
> -    cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
>      SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
>      cpu->isar.id_aa64dfr0  = 0x000011f010305619ull;
>      cpu->isar.id_aa64dfr1  = 0;
> @@ -1027,8 +1024,8 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
>      cpu->isar.mvfr1    = 0x13211111;
>      cpu->isar.mvfr2    = 0x00000043;
>      cpu->isar.id_pfr2  = 0x00000011;
> -    cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
> -    cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
> +    SET_IDREG(isar, ID_AA64PFR0, 0x1201111120111112ull); /* GIC filled in later */
> +    SET_IDREG(isar, ID_AA64PFR1, 0x0000000000000221ull);
>      SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
>      cpu->isar.id_aa64dfr0  = 0x000011f210305619ull;
>      cpu->isar.id_aa64dfr1  = 0;
> @@ -1183,7 +1180,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, ID_AA64ISAR2, WFXT, 2);     /* FEAT_WFxT */
>      SET_IDREG(isar, ID_AA64ISAR2, t);
>  
> -    t = cpu->isar.id_aa64pfr0;
> +    t = GET_IDREG(isar, ID_AA64PFR0);
>      t = FIELD_DP64(t, ID_AA64PFR0, FP, 1);        /* FEAT_FP16 */
>      t = FIELD_DP64(t, ID_AA64PFR0, ADVSIMD, 1);   /* FEAT_FP16 */
>      t = FIELD_DP64(t, ID_AA64PFR0, RAS, 2);       /* FEAT_RASv1p1 + FEAT_DoubleFault */
> @@ -1192,9 +1189,9 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, ID_AA64PFR0, DIT, 1);       /* FEAT_DIT */
>      t = FIELD_DP64(t, ID_AA64PFR0, CSV2, 3);      /* FEAT_CSV2_3 */
>      t = FIELD_DP64(t, ID_AA64PFR0, CSV3, 1);      /* FEAT_CSV3 */
> -    cpu->isar.id_aa64pfr0 = t;
> +    SET_IDREG(isar, ID_AA64PFR0, t);
>  
> -    t = cpu->isar.id_aa64pfr1;
> +    t = GET_IDREG(isar, ID_AA64PFR1);
>      t = FIELD_DP64(t, ID_AA64PFR1, BT, 1);        /* FEAT_BTI */
>      t = FIELD_DP64(t, ID_AA64PFR1, SSBS, 2);      /* FEAT_SSBS2 */
>      /*
> @@ -1207,7 +1204,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, ID_AA64PFR1, SME, 1);       /* FEAT_SME */
>      t = FIELD_DP64(t, ID_AA64PFR1, CSV2_FRAC, 0); /* FEAT_CSV2_3 */
>      t = FIELD_DP64(t, ID_AA64PFR1, NMI, 1);       /* FEAT_NMI */
> -    cpu->isar.id_aa64pfr1 = t;
> +    SET_IDREG(isar, ID_AA64PFR1, t);
>  
>      t = cpu->isar.id_aa64mmfr0;
>      t = FIELD_DP64(t, ID_AA64MMFR0, PARANGE, 6); /* FEAT_LPA: 52 bits */

