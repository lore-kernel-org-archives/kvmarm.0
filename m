Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EBD3AFB03
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 11:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646207; cv=pass; b=Hf7NFQ4rAb/azWZhzez/gbeF+2x+dCtnrO+Imsh63+Y48iCxYKb2XVbsn/PygW/OiP0Tp7FFqwt8KgEayw8jcjwSqV71PLOZixSoMgjmRdabEit4b5SKPAcCXqkG+YxoBoeq0JELGZBdHk9lOCWTxgPr8SBConAu2Wht50vKAwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646207; c=relaxed/simple;
	bh=CU3ksfEGHWdCIaQTH2LQ60wY6nLY7ierlfjMVdlARvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LqKbxlBkl44J8Azf6LQ7mPiCwSJe34MjYfT47yXc5HanPWUweCAinnqK76nL/fK/sAunboD4SMv0TNs9pcV2VsXGLZQOS5a7cceXYUJyRYuRmLlbyCz8xo8/5b6HkwTJnHUf3g4b1EoYZwWTaPhl/fNMZQBHwTYWCmUB0MSKbzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LidfLsuJ; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LidfLsuJ"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b5e5aaf7deso1207e87.0
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 04:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789646172; cv=none;
        d=google.com; s=arc-20260327;
        b=GhO/7hiJj/HJ99vhNSLeGTCbga8vXr5KT9Ha/gzSTOJjFaFpCbZrOjVRoxZMz0Z585
         dGK9my09zTiVbXTIx8UDD7gkb/kjmvqQZTaIEdVW50NqJyDBCeeLcC8eWhdBkadBc2ZX
         /uc+ZFSjyGp0PTti5noGkxn6T0OE91Ya7Zc+q72aD0ReInPafEHU+iY0lcCIZtL6b2SL
         siKLe2zV1OHWAZ1ALPpAVijNw/ZoMpP5+o1xC4CfpUbWwydwbbbzGw8lFaCnWeRud1J+
         Y6iGAjm7p6aVTE2posqaWpuUTJoOKdy5szIPQVecUMOnJPRBiZMJjS7YRgJ1RUQxbeln
         PZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kosCb2yMfsMu2L7rZnHgF6oeDYnJPHYiEzUWC4os9nk=;
        fh=e9q96H5lDBz4rKlkUFYRky6j1B+DF+7JBWU9nFUBAKE=;
        b=ZD/dOAlR/UkE164VEHTVakS0UqfvSDB/yA0VuPcNohXRpmnD5/ire2p9/uab4Vw1hR
         piGZvYfwfd2j9+S9orUhDhiBwA3HtD9fkuFUkn5+LVRjdax6ycNh2hTTjdFWbe2CCvOa
         lz88QoKwLFUWftPyfrq+ygDVaeDt4IsWLp8WcH8SBGDrSjyJGOwt7dv3wYSm84x/8y5z
         B1MVM6QSh+OqqvM6ehdvBX4KbFr9WaXqsTEcrDxgNM8MRnUDeESLV3J1BTqV+fjN9dlm
         8zySKd4DFac5sGHOVAxKyJVkhANdOZacjnd689yoY3okH1dvHzhM8cSn+DPAzjKPqGQU
         SCjw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789646172; x=1790250972; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kosCb2yMfsMu2L7rZnHgF6oeDYnJPHYiEzUWC4os9nk=;
        b=LidfLsuJgtKMx7jIDCfWwJbq1hmRgrb4R95uAGWHGBh/IkpLl538JsxmWWONHrezfc
         WhT0BWDr6hALHGEO2LHWyftyZzWPrI5PbqP2mCfL9nXrek/G2Z/JAq5kpQG7TGlIlpL+
         3VQV6Kjw2iyOdbIgNMnZ/zuCcHPzJRT2ZUpIU8jQtJueKGarR0q4ugPULLhOesastyqK
         6lRdY0/04RCRBFufvZudZVcSqm5ZfaD2qXnWpTYsBLshMU1VCa6NFDiyPDoLchTzlfuI
         qxlLjeHYDCM5zjMsAXfZqVD7ixCodX12EGyeEOB2+yzoDrGkm4PByBT3IT0fQBIDWKzr
         dcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789646172; x=1790250972;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kosCb2yMfsMu2L7rZnHgF6oeDYnJPHYiEzUWC4os9nk=;
        b=TqMueQezsK+N95KYum2hHlBUvtx3s8cyAegUWSuUZZKq/VjHQQf0ApuVE9ZWSloinp
         vf0FUdIfvxoaNlpHNtjHW76iWccsUveYMDwSGbXd9pg8Mj2lvfzkFVMgFn+GMJn7SS6J
         Z4lBgXKLWC9SAxIXEAUjxCNqwI+qW9O9fugnOEzUdSEfkKDqARm0o2n1wWlUoplW3uoF
         JO58lfkb6iBJWqspl6tD2SluCqrOccrCYL2fpegEzTzfEyhVtroVeZg6hupp8DsbxoNi
         kazlZfl9Oq/F8bPFwAnwDpauOwugfSKTxbEoy8ozaUogZzqfirGSOIWEa7dBxAyX1LbN
         1rtw==
X-Forwarded-Encrypted: i=1; AKwUvBygcmDZArhZC4ND1s/f5sxLM078GgWztJ2WP8fEkckHtmNpsPdAO3Zcg5RKSTHkSHDkL/d1O7g=@lists.linux.dev
X-Gm-Message-State: AFuF++n3YVxMuFaZEvTdmTK+C+Jg5GZOIUEQiYhPcaLSb5hROANW5pg2
	LddMA2HoNKWDplOuktaNwXq7cuf0IAsclegVN8LT+vTDcKHkai+Kvu8iKXi1kjCuuELAs9CYhaG
	o1vE9YS7k8PNeTwWkWAYyoF19ZFKPTm2GILdcMO++
X-Gm-Gg: AYBFou2ubAPGv1IwyZvo5nlHaNcvfZlyK3jywbJguWosym66gCzg/oKEXuuPLujNZQx
	Cg9uVl1dK0BK8SHlK+c29ZgnppKH3EEuOjlC88W46BGsfQubpS68GR9QYlLk1x3H/h656htzPFR
	aGZpGo7D7FMyLiMSenXBYGto7dIukOtKXyQEf1dp1uBUcMi/x8O+hnvuEBd7J301bzH9J5DI3Ak
	oBDgCFvjCgAp2WF0l9nB4Q4hwmlxPFxE6G3+P26RgoVdJJuKjUpYFwnfoclVMU0kKzRhiP2wX8S
	on3yB82zicMQP1fv+xfiQOn1BXVZwTIeBBHymzZ1XCt9orDpP66gkMYttczxyRxV3pEHC3zLKiD
	OyFyTq0wAumCvxA==
X-Received: by 2002:a05:6512:686:b0:5b4:74e2:4171 with SMTP id
 2adb3069b0e04-5b8bff1fc30mr29453e87.4.1789646171156; Thu, 17 Sep 2026
 04:56:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com> <20260915160141.3543048-14-suzuki.poulose@arm.com>
In-Reply-To: <20260915160141.3543048-14-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Sep 2026 12:55:35 +0100
X-Gm-Features: AcwNN1Und6z4n8NhcdREXtYfkYZKnB08V2Uvzr0E-uhaZeSThY7dario3kxcFlo
Message-ID: <CA+EHjTxe=UXnKR6DzTqL9d6O0aG+rO+nPKTxKKQ_-w6tpkGCVQ@mail.gmail.com>
Subject: Re: [PATCH v18 13/23] KVM: arm64: Add a helper for VMs running on hyp
 that don't trust the host
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Tue, 15 Sep 2026 17:01:31 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
[...]
>  enum kvm_arm_vm_flavor {
>          VM_NVHE,
>          VM_VHE,
> +        /* VMs running on a hyp that doesn't trust */
> +        MARKER(__VM_DISTRUSTING_HYP),
>          VM_PKVM,                /* Normal guests on pKVM */
[...]
> +#define kvm_vm_hyp_is_distrusting(kvm)        ((kvm)->arch.vm_flavor > __VM_DISTRUSTING_HYP)

I think this should be `>=`, as in kvm_vm_is_protected(): MARKER()
gives the marker the same value as the enumerator after it, so `>`
leaves out VM_PKVM. As posted, kvm_phys_addr_ioremap() no longer
returns -EPERM for non-protected VMs under pKVM (EL2 still rejects the
mapping, so it's only the errno that changes).

Cheers,
/fuad
