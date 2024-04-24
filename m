Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C78C15748D
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713940822; cv=none; b=RWxW1GyvzOH/vNxxQj514pbdbCvMfVpSlxMS/yXvkCQVbBlxLKrl3t3TQrTs+SqzD2CzDbye7JpuVHiYfVj6DDxeBbqB/HUDrkQOBzqgF/VyGV0gXNylhAEA27cxnoJhmsOw0422djJ5nB4OEzesijvZALYUPRkcKYT6KPXw2dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713940822; c=relaxed/simple;
	bh=PyscbRWWlX/jNfgm1Frz1+aMZhlSuDJT5yV2KK/91JA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eTlKzOAUvQ7EJI4nPioE9gz699RkpTP1an//zcHwj5Z1uQmvv+l0jQxTtykxkgfkvGd/lJGpISjnBxE1LEs6/y9wFxhP9MmwbQ/tsopbMU+rrnRwAi8CnVcnQT/s9mIgZLF7Dpif7QDVLU59iEj9azchQunQpj8ftsAbz+eFC4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BlqAIz0c; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BlqAIz0c"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-41b0bc4ce39so1463375e9.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 23:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713940819; x=1714545619; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+AwBQ+eKRXV6NI2SzaOo77G8tp3BA441BCRVW6eLqhA=;
        b=BlqAIz0cLTW29u034b5cChPwz2Ne7/WA3dHuA7YpjZQseLwTHk9eERaZ71iFRjv4q2
         qYYzWNSzDSjV6FZnV3T1y1JzZkARgCG+Tx6VdP5EwOAahKcAB+6+dA5uzY+9KWY+xMGl
         G0tuWV+o8DMO6l0iXo81YPSj47VvNCcNqCWisSLLbh243QNTzt2F7lW2q7MaAhed3ysD
         snIPFNEcdcq00B5ag/68x90gHi3sqKyP1S+Mi1lxc69bLWlgib97IBwPjQ4EIeKMjbql
         tL0pi2Z38wBO/wpldP+IHoep6qf9GGO4RN0zW5ARnFTB/3AHzpPN2dYV/GPqX4VFouG/
         SNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713940819; x=1714545619;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+AwBQ+eKRXV6NI2SzaOo77G8tp3BA441BCRVW6eLqhA=;
        b=NxTrpffpX1jffHbJ0I+8z5eWbK7A6zyNCiE+le69uq0yZHmpB/TareSsaAWkKNVIn8
         xBb9SwmF2YBANCgN3Ov8idyk6WhMQh6AgCTgwYPDOFk9zBQezncb5GTKOTTtbihqSQ/K
         DGGVlV8/nvT/GJFW6HG8B/0FVYj72ZuMLTG2nghke9pgztwK2/BeOGAf6PK9DGwZHLh5
         4HvXJbZhMOfQ5TrOnZ4Mwo3qI45tLiY9Wp83Kcac2BBwF3WuMXHgJITo9HhtzBXoCmTE
         g2q/KS5j2HwSnIzSrkybC2og/8L+Ncj+rSkD8yyyomAbuznOVcBGY1pXmSyerCylawgI
         ng3g==
X-Gm-Message-State: AOJu0Yz7d4AyBU3pQ/uPmmPSAi8P96GJQWNCGD9A4Hk0KSpgvMxQ5S8I
	RDgPplq22W0EmNCse7I522ASiGzMzRHVxMj+Qo3E6vgkprMUbiE/H7X04UdduzQXESETh2YnwVt
	4
X-Google-Smtp-Source: AGHT+IF+dDyzpvBq01gVvfAksKPDGDjw9PbMW2gi/RPdIdtpNY6tdxSTUKSDjoOkTEPpdj4v6QttrQ==
X-Received: by 2002:a05:600c:1986:b0:418:4aac:a576 with SMTP id t6-20020a05600c198600b004184aaca576mr1294250wmq.39.1713940798665;
        Tue, 23 Apr 2024 23:39:58 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c35d200b00418d434ae4esm22669848wmq.10.2024.04.23.23.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 23:39:58 -0700 (PDT)
Date: Wed, 24 Apr 2024 09:39:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: maz@kernel.org
Cc: kvmarm@lists.linux.dev
Subject: [bug report] KVM: arm64: nv: Handle ERETA[AB] instructions
Message-ID: <e23f90d2-306d-4290-8247-845472eeb860@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Marc Zyngier,

Commit 213b3d1ea161 ("KVM: arm64: nv: Handle ERETA[AB] instructions")
from Apr 19, 2024 (linux-next), leads to the following Smatch static
checker warning:

	arch/arm64/kvm/emulate-nested.c:2209 kvm_emulate_nested_eret()
	error: uninitialized symbol 'elr'.

arch/arm64/kvm/emulate-nested.c
    2173 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
    2174 {
    2175         u64 spsr, elr, esr;
    2176 
    2177         /*
    2178          * Forward this trap to the virtual EL2 if the virtual
    2179          * HCR_EL2.NV bit is set and this is coming from !EL2.
    2180          */
    2181         if (forward_traps(vcpu, HCR_NV))
    2182                 return;
    2183 
    2184         /* Check for an ERETAx */
    2185         esr = kvm_vcpu_get_esr(vcpu);
    2186         if (esr_iss_is_eretax(esr) && !kvm_auth_eretax(vcpu, &elr)) {
    2187                 /*
    2188                  * Oh no, ERETAx failed to authenticate.  If we have
    2189                  * FPACCOMBINE, deliver an exception right away.  If we
    2190                  * don't, then let the mangled ELR value trickle down the
    2191                  * ERET handling, and the guest will have a little surprise.
    2192                  */
    2193                 if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
    2194                         esr &= ESR_ELx_ERET_ISS_ERETA;
    2195                         esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
    2196                         kvm_inject_nested_sync(vcpu, esr);
    2197                         return;
    2198                 }
    2199         }
    2200 
    2201         preempt_disable();
    2202         kvm_arch_vcpu_put(vcpu);
    2203 
    2204         spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
    2205         spsr = kvm_check_illegal_exception_return(vcpu, spsr);
    2206         if (!esr_iss_is_eretax(esr))
    2207                 elr = __vcpu_sys_reg(vcpu, ELR_EL2);

elr is unitialized on else path

    2208 
--> 2209         trace_kvm_nested_eret(vcpu, elr, spsr);
    2210 
    2211         /*
    2212          * Note that the current exception level is always the virtual EL2,
    2213          * since we set HCR_EL2.NV bit only when entering the virtual EL2.
    2214          */
    2215         *vcpu_pc(vcpu) = elr;
                                  ^^^

    2216         *vcpu_cpsr(vcpu) = spsr;
    2217 
    2218         kvm_arch_vcpu_load(vcpu, smp_processor_id());
    2219         preempt_enable();
    2220 }

regards,
dan carpenter
