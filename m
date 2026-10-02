Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81B7346FB3
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 09:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932531; cv=pass; b=guIQH2xrgvc2OPrCKDAra17kJTyV5OsJxewJOx29IAZGgzHA5HxV62lo7gjbKRzKcEixlAEeZk4tt9JATOdbbr+zeQ8rjTyfDd2LAwgOLbQ6LEBkie9NugL+SCHykDc/es+moewLGXlC+3wetRMmsCwy60+wPxpaElV/qIeuS1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932531; c=relaxed/simple;
	bh=hWB1QcQGFZjdtaZ+WkrO/eQNuOSYDk3BPt9FwXfnsYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Veelq2mfWIJL85YD8YU8XAJ6fruRVL5t98K4FjJ7VPPvEecjO9z4A8+6LBHtiEZv2rjXHigcrJXqFXib7cUatDL8f2iB3YeA9NijfrpjUkMQxv2H2TBfDw6zW5YuvfgH3fcWCfRuMcaTXdtm7uhDy6xzuT0Enrb/c8vyQzmHOJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mHYz+cGJ; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mHYz+cGJ"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ba4065fa07so6345e87.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Oct 2026 02:15:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790932528; cv=none;
        d=google.com; s=arc-20260327;
        b=aCOoLwsEHHHNJQHuziE0267GzqAVj6P/Jz4Cf27W4dQpROnYvkJNIXV82VrB7on/k+
         yIDPrw+pgJtUjHVv6xhwJNHtBR1C4Z7A9bXpsrk9CV0m+o9De0LS5/cHj2aBZZccZDut
         w/srQ+ohJxuOzGYwHglfdc/4zRaRK6+ykPsFcLLq4NNTo6hXR8M9MYGFUqsIBmyfNRN/
         xEUwypNEQGgG4F3G/mDC83fJnMdF3phgFJaDQj276WRaBiPT4jHPa9tS6qxoM21kyBME
         3h/E+p0uIYwh5b+4zdg+3yV/o+V6MrFDFp09RWrQiS0NE2kW9ZBi9PH7cZ8CtZgS9oyn
         dFwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hWB1QcQGFZjdtaZ+WkrO/eQNuOSYDk3BPt9FwXfnsYM=;
        fh=2QYy1Kzf1qExO4CZS0X5pP1QNtRWKy3sNYJ+DsDUNqA=;
        b=Kr16vXaeyowfaUxn2S8ZBrtQyTdaFYrRLo/aLZNgM3yD8T+DPU+eEd1P2zV7Yl+S6V
         TF8T73PwFCyME2/vObxtDC75VTjDul537HsKQBTvaXILoWtExWqrevBsd4UMT0p+kCF7
         vyHKG/9KlaqzBNfiCwVb6nLZ2nyDobF07HgtOMQN0rpAQ6F4K1BE3hJFVvZ5F06uQTGg
         DFVjZXajm+w8MO3ksQSkbDSVJFo18SCsiEILUAsMcOSeeHP2H4rAVguIMdY1g89ea5tm
         7hYcdgiDukZW2Vfs6LRvxIOleVml1fOXBdJqb+KdsToUmgL00SeSTxXXUrgvpRxuxAT0
         MiYQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790932528; x=1791537328; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hWB1QcQGFZjdtaZ+WkrO/eQNuOSYDk3BPt9FwXfnsYM=;
        b=mHYz+cGJCEsk8U/bfQOkjXwj5FIUKHvxnI5DJgfOvQbsY4G7X+T92ZoqLNWTLPiDjg
         +r1LLbRDwXMYFBR2JxOi/WIiot7+YryZnoFjZLWhK9i280bbf0sr13F7dhmvrG+B0shO
         Ddn6f9nczkgrLdqjVB3lGfizWMT0tGLbH3wSNDaYtEi3XyoiRcAw4FXuL1XRHeiXk5xR
         s2bIB3xiUVz7nf+ZWtActD7O9d6GSg4lSAvw9GacQldHIEOU1GQvtQ5n8nOgMJN+RSE3
         w9FkfT3LAVOHl2vYg6LqaXw5CYiluI4MAPbk0FujntvmhAUR43lvGKno1Oo7kG5hYRNi
         bRDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790932528; x=1791537328;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hWB1QcQGFZjdtaZ+WkrO/eQNuOSYDk3BPt9FwXfnsYM=;
        b=rxfzHG3QZ1KDl4t8RT5LsvR84HjjdCW08tDHvCqkUkzyaZ1aH329tSg+SbgjftvjgN
         iGfnavt1FX8e3ycfoS/DN01BNanKOYuvh7Uf0O6RWGI2lQMBLqNpsiFFIzuAzbLMs+Do
         s2oxSF3tRbJ3hPHUYaO3RhI7R8LYl7YNrYsNUOiOxAhmcruNYd00uR4Abp3+F0nGculH
         5EAegtab+Gbk9iqGR2VJomVqz2GpVNzdw8NZT2+/kD4fZo8I1Ui1sJS2GUB/uEbqfpAf
         DooGZkVejG1Wu1JUEXRfj5vHqItERxIKu3XtV9BqvZWRC5XmDMiSI/aYvgU6kFJvNgnU
         3S6w==
X-Forwarded-Encrypted: i=1; AKwUvBzijBr4TElXgUFZw9011PhoRiRoPdzNFbGoUjTSSx8NONFmdxeh3bSGW5ZJ3+7XU+QOATIklO8=@lists.linux.dev
X-Gm-Message-State: AFq9FYIBrWABji5phHaxpcDhzgJOMn8EBMTXR5pwtoYJZMhhY9ENjHmC
	Q9roBQgyJNPg5BjCVUiLWK2SD/neeyVA0poOS0QlSvzvGRNFyTEeH+lJauzJwiKOPrgJpG7BGJd
	b5C/fkAcimxkr2VYSUSzocs40/ltQsb4TUcJA6n5p
X-Gm-Gg: AYBFou0m/txe6lZrDN0+quWtZLthfaRECNL1x6AKB5QmfX21Ub2QslfL6BMHmy9QLpZ
	E7GI9RceFXgA0jNxZ+AfLkOta/hvgYN2ecECvt7WkO71+AUHxcEzuV2H4FKRACscdo7P0EiJHfS
	wGjoeS9hFrihoCyq+H7hdCYaFMOzmCkBnyODAtLnZ5rFojM1WMdsJvKmBBtTokHZN0joSGTJsXy
	RkkTY4WQHOHOQohaNTqRQbMWFeRbIrqT+hbE074QB9zwI6t5g3iS0nml3x6ST/UJTXlwMYIQHad
	19Ye7mjFmXvWJF8Ul2zaQUpwHntTCOUcPjv33DyQ95U64dvCAg7Wse1JKfqU2Eb/GErm2lKQHCJ
	5SPMytK+uGdLiYg==
X-Received: by 2002:a05:6512:1153:b0:5ba:3797:2359 with SMTP id
 2adb3069b0e04-5bb7c8d2f8cmr108813e87.2.1790932527310; Fri, 02 Oct 2026
 02:15:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261001210703.1597150-1-suzuki.poulose@arm.com> <20261001210703.1597150-12-suzuki.poulose@arm.com>
In-Reply-To: <20261001210703.1597150-12-suzuki.poulose@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 2 Oct 2026 10:14:51 +0100
X-Gm-Features: AclHuK81_w9T9KTmUVQvA6ovuNEn5Udf2ErB6CaTomYP4-WPob3E-hZqL0sp0qw
Message-ID: <CA+EHjTwM=5PXPVByVV75AuNVw5TJRiUqu5TNOcFNPOBmTiL-eg@mail.gmail.com>
Subject: Re: [PATCH v21 11/23] KVM: arm64: Use a local kvm pointer in kvm_handle_guest_abort()
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com, sudeep.holla@arm.com, 
	jonathan.cameron@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Oct 2026 at 22:08, Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>
> kvm_handle_guest_abort() repeatedly obtains the VM from vcpu->kvm.
>
> Introduce a local kvm pointer and use it throughout the function. While
> touching the code, fix the missing whitespace in the
> kvm_is_nested_s2_mmu() call.
>
> Suggested-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
