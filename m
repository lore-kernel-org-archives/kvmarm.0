Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C6A509EE9
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 12:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789649846; cv=pass; b=Pz6bLA+7uSdMcr3PTjksGhcDCX8oy9/XuL2IBQW8CMNGHmJkpg8N/WVTCe8fA7cZANWCIXXZKW4+6NzMzndJOYTfubdddHjaBTV/CTe2N+sQKDESoz6chz7hqu1dke/OEq5qcQ73F9yFeafiEGiU0HZSHrO26oER2lB6G5eGoKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789649846; c=relaxed/simple;
	bh=yjGleyBftL4mc4+T7OaOkxuKfXAcAseCzpwWbCEkYR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kHP4xPObtpu///SDzcJU1xfqpM7eONIVqQ08yFW6ceOmsOWfvJ/j5tG1P7VhCUUgWsfh9XenF0s2Oj1NCiRsAsJIkkGYBXq/AKhIPmyhAmHx+xUS2sMrAWjldNWfVaU+8WHCJ7bAxZOTtIzOjUC9V5Z9QUomN5P+s+3xOfqbLkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rlcACcQu; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rlcACcQu"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso1631e87.1
        for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 05:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789649840; cv=none;
        d=google.com; s=arc-20260327;
        b=EU6R7WJFTFZV/Xp3T/tuRCMEdnrS2wKqilTtE2Pv754LsftJkx/i6obvbDgpFoXBPk
         apBJFDpuNi36POsd/3a9gTuEhOJPvKdzQXJfVtuNQ1r06WsqMrYruyY9hAL76Q+Ob10a
         dw2BznUAp6LxwoJ1RN/1noUBNmpBLgOwEsDNZ28smmpd0TWJn9GXzNUeN4o+111V4dWE
         glUUzbfLxK6plX4XJ/HfVpLrCgXiHKq32h1tfqIZTVrsyTVdQOAU64G/DCj/bKmJsxmN
         01juIot5aTxc94OY5kIkEIKNuljZSJsRp36ea+iDtJLmx/siNO7D/bejxXkhNvDyeKeC
         ABOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wCB7kYcnG02MJOJXUn6C/taoVXipNbSEcZ1HCYhjZfo=;
        fh=8iznHpIECrpQKD5k6IOiX/nY8Kk9W/Fll68oDY95iFY=;
        b=CnDTyOGMYd3k0dgYsk+XXgebUcMjMmombm1BxWBetUOZSE6HMnWBNBcH1NyFnrpfMI
         vubYwvaLT1z9JtvYoiw89DqBkNZKNr1s2zAh0omT1BiXGJ4x3njMKl5xa/4l5H404v9s
         hrFgIih+GYz5dTDzVWl7gN0XOFejLf9OetwJop3ZiWPmGNLK6l0YQs8C/AT7PzpPD/C3
         +Jte6oWbUKcW/2z0+1OyGSB0NEGQgZBBYzkm3sPP3ohuQGpY619pTSW7/qZYWBYQnBk4
         IGYBXVMRe8ZBSjdnPKKnpUSwAFy8BB57hhtq1u+hwSokdkEtZ3Ro3wbjZ4QkYhROLF7u
         Tlsg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789649840; x=1790254640; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wCB7kYcnG02MJOJXUn6C/taoVXipNbSEcZ1HCYhjZfo=;
        b=rlcACcQuIZURHu+UgUXo15rg6D4xY4BtfJNAii0A7W6jN/HXlq5rMNoVyH6xNrM0ci
         16rVthC7T204OzNOBcrudWll3GDLEN8Y4Y1vMpV30V7fz6SjXEZyGI+yTmgeHKcYALDC
         VDh4h6QIBBSjeJu5APurH0rhoGW427ZB1smBUgS2ciCCQviIYji7Q1ZnVdSpevSbz1e9
         NqV+sy0Z0qlph+Q/0Vb0SmyqrhXrcr49gL8xYRcu7c+LSVBXPNQ8n8X4nCtraueMR3c6
         S4CEt8B5XPxPbz6m6oeubnMPETPx0wScFIZNGd2G2BVQLFlRWVADTtnTQEVEeAo4DIeV
         cspg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789649840; x=1790254640;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wCB7kYcnG02MJOJXUn6C/taoVXipNbSEcZ1HCYhjZfo=;
        b=ZSAkf/s4DezkDCYq9+HDueDNTX9ywqXlW+4ehZ5iWn+j+tX62M+677Kzsz2V1sgkzn
         Na222UyxCn3prRRiTplx972hghalKwH4ucj82WqExwKDfiYNWKm6S4WGB8Q5NXNZk/v3
         hByD4JG1MRlfTMaQShnnFCG85ByDVq1m29HAzr2j/EXkVTvgTDloztoFuz+glrlYiAHg
         oniN7zO7EY7QLdd0SmA5ZlJ0psSgn8ofzKu/3t8eJzqI6MuKhtXOBiZziq0OwumZRTas
         1neoQ32Yllmv5XUloj+bbAas/FJzPWaDvjYPtSy8gDoM+vSFTlShy+jNPFFpfB7k36Bh
         QEZw==
X-Forwarded-Encrypted: i=1; AKwUvByTcUWr3dHgakkKQ0zYJip7agk3/936VqcEn4C0v/L9GpzASVucVef1w5FE5GKgWtGAj/fPucE=@lists.linux.dev
X-Gm-Message-State: AFuF++mBw9gVc1Mj+/aUl1oYO+YMm3iV2wPe3W7U36kMzpi/Ws5F2u0E
	RxrVGfCwnjiuEVDz4OWAj+S31qhBUxJZh2Nt/eVyOwr+StWu/X6abYz6pdg/u8v0ChXiQjfW0fA
	vxKjTnwuK4hIE2C+6X9RzVsQqR6m7AXEN5muBcDUG
X-Gm-Gg: AYBFou0kyqTCCZl/5cRR+L1rV3xIBzvrOEjvxdB0V/jO7WgRXPTWPUBNGcgM/FCoTBl
	8v8sdXdQ1o3PR4igO0MJe6LC0KauiSFe43mHPuJn0wpfy+ACRVFbuNrGq9vB5SXKjWAq66ChEtm
	tAEIVxxsIfgRKNlfZdx8sFBSygVovquPl+l9SZ26H2Szuz1bVo+8zwYgtneEyXgtH0jW35FSFX0
	BfOb3udNkr1GfS+dkGAiBVBaC8riRMUq+oT8EjcsKdXp1lJC+1ndd/b++OQjP0YOyq5BrAK7KUw
	CeBD4Oi2bxY/OWyC4h5PmAuZBAp6pwKK1+P8ZBuOHzra4WsOXbu2hkcf/t3/a/IM+clrhi9veeI
	1WaF9Wt5rWkZimg==
X-Received: by 2002:a05:6512:b97:b0:5b1:571f:715f with SMTP id
 2adb3069b0e04-5b8bff16793mr25923e87.3.1789649839151; Thu, 17 Sep 2026
 05:57:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915160141.3543048-1-suzuki.poulose@arm.com> <20260915160141.3543048-19-suzuki.poulose@arm.com>
In-Reply-To: <20260915160141.3543048-19-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 17 Sep 2026 13:57:00 +0100
X-Gm-Features: AcwNN1X3rwZaClpg5QtpbmDuAi81nkVt-NA4XEMnqdzMUr4WqSiJJDooQvLcWZ4
Message-ID: <CA+EHjTzKjjEuAuoOuzGG0uKyVZE-r+CEreca2H2kEQYuRPpgUw@mail.gmail.com>
Subject: Re: [PATCH v18 18/23] KVM: arm64: CCA: Mandate VGIC_V3 for Realms
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

On Tue, 15 Sep 2026 17:01:36 +0100, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
[...]
> @@ -84,6 +84,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>                  !kvm_vgic_global_state.can_emulate_gicv2)
>                  return -ENODEV;
>
> +        /* Realms only support VGIC_V3 */
> +        if (kvm_vm_is_realm(kvm) && type != KVM_DEV_TYPE_ARM_VGIC_V3)
> +                return -ENODEV;

Could this be kvm_vm_hyp_is_distrusting(kvm) (with patch 13's compare
as >=) rather than a Realm-only check? A GICv2 isn't possible under
pKVM either, but there the v2 mapping is only rejected later, in
kvm_vgic_map_resources() at the first run; this would give both the
same -ENODEV at KVM_CREATE_DEVICE.

Cheers,
/fuad
