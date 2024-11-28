Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53E2323D
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732811525; cv=none; b=BbbCAyzjLgoCrhBbHtTZ+qpl2U5T/HtBEXFItgWLABc1Ba4MrIRlKr1U9fd1K0YVgWjhGiL8q++I0b2uZNsYdyWaFTcUImn1D9b4ue8j53RgZP+0eWsGCfu+UovuwriPCevnUqAb6kGFYE03VN1QJtit6eV18qaUs+RqiIg37+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732811525; c=relaxed/simple;
	bh=hLx3ioAq+y5EV8cFtM6kcmzjDAMoSETbeBtwaU4oQIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CO2jK0p9au6+w0hrs0xPzex3RHqjSbO6BCI7vcreICnQ4TLy+7zkOc8OnWWZBRjVcWJp5CJliSGQaUgV5jNn7pNQvxpD1B1JND2zPCzPDAGClVNZtkJVQ+6XowM1cnyxr798p+P8ub+PlAyQ2eceLpsXhOaScYMnE027DxkVEN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dkyHH0qQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dkyHH0qQ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5cfcb7183deso3645807a12.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 08:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732811522; x=1733416322; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iII7uuf9TZj9VNCNY4gdmMB2ol1JIZlZLSXfQuGrzNY=;
        b=dkyHH0qQE8quQW4lkQbf6iyxkKoJ2c6xQJ9qv12eyElhKkugQ0I9vdcVB2WUZwEakI
         Ks6LqGRFWqSYgWndsLtnCC5royiL4CzxN7HvFR0zARfKceTF7blRLSJi9O7dAOdBSk2M
         9vPAfBpYKl07G/V6Bx1kWJj+lgJWf6VpfGH4qQ7Pmz0ozP9Uoy1ZpJE5auajiHcFN0Ot
         LfjNdZqTaRF3uCYSCteECbSatbHOHG8OoDwbzChSXNfKd1O0An5gPq216neQwV2yRiX3
         SaTG/wu8yH37lDuLGjO4vV3FYFN+/jvnlLh+rMD0ZvEB6qqitYIeg/muEgLfm+K+HuFv
         GjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732811522; x=1733416322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iII7uuf9TZj9VNCNY4gdmMB2ol1JIZlZLSXfQuGrzNY=;
        b=MeRbKU77qM49Q3icWdHpHsT5nr5JASh9oLCwJcXin1JoizuI5UE3LdHs2Yc5xr2kfC
         e+Ao7PPOReXLKx1J8bJLJ6j0IacX1nh5klbqVsRnh2ty/46TZCd0cq6Eb48L6FFoiOQd
         E4XDCksGU4O/GksMMgmG4O57ps06bYtHeTq+lOrv9C/2sHXXC+FskC2hCDauLG+bhqqZ
         bqIeGG3QJHbiQw3gXgIkF/+c79ucZzFt6OpTaX0PIII4PZeT98yTqHUAarJdEGfHCj2K
         FjzrcnhJ8BS/mPldU0fiZRmr0wNDfUQ3pxgztIabXdc3yF7NLRNd/wBFJ182ZThH0gzR
         VwDQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7cPepIBmLYaQEPP9vqLgNCvkIzxi+fpruzT/GHHnwz88Jd6F040n7w3yvYBxTvnnS1oAAU4E=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbJk/jtjMVXP5hnqsr4CuPQEgOeRKxmhJX1dzsox9/5T0RdkG1
	fKNK1hve38Y0RKQtuCdAARn8HYdJKLZnt8hQVOYcO+F9uet0ii4NnvdP1jjpM9Y=
X-Gm-Gg: ASbGncvLhz0YEcoQ69vNGxABe11DVvmYgq6L0z4SOU2q2qGuSVuEoVPIdkeh0qsoC2O
	OE7E6YWoWH3wP/iMWlL0KXc9psTV6th62nLDoycIkogjokx8N8/sbb3Gwc0gJyWx56AKiolZSw8
	obKxImUvOwBY92RLmZz65AiTHw61DcuoLw6LrUZZW4P7N4XOaskUqlFjv4sF7e2qqj3QgJMoE/V
	VKeb7ZrCrRhWf1xAKnMWEoopNzYvBfrNVEXjPInutyB+Vv/9Ce4inAAlcbe
X-Google-Smtp-Source: AGHT+IEueCSQe9pvckxqEsEWD3Nr65/94BTKV5/aVQ9y/9c4r7CKM/zYJ76EPGcECgL3+BEaIzTWmg==
X-Received: by 2002:a05:6402:401d:b0:5d0:840d:ed02 with SMTP id 4fb4d7f45d1cf-5d0950fb3d9mr4136529a12.4.1732811520883;
        Thu, 28 Nov 2024 08:32:00 -0800 (PST)
Received: from [192.168.68.163] ([145.224.90.200])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d097e8dc66sm873841a12.71.2024.11.28.08.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2024 08:31:59 -0800 (PST)
Message-ID: <910320d4-4c72-4962-8d74-1963a74a0c27@linaro.org>
Date: Thu, 28 Nov 2024 16:31:58 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/15] KVM: arm64: Rework guest VM fixed feature
 handling and trapping in pKVM
To: Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com,
 kristina.martsenko@arm.com
References: <20241128123515.1709777-1-tabba@google.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 28/11/2024 12:35 pm, Fuad Tabba wrote:
> Changes from v2 (Marc):
> - Added three patches that remove the per-vcpu flags of PtrAuth
> and SVE being enabled for guests, in favor of them being per VM
> - Tidying up
> 
> This patch series redoes how fixed features for protected guests
> are specified in pKVM, as well as how trapping is handled based
> on the features available for the VM. It also fixes a couple of
> existing bugs in the process.
> 
> For protected VMs, some features should be trapped if the guest
> tries to use them because they are not supported (e.g., SME), or
> if they are not enabled for the particular VM (e.g., SVE).
> 
> Initially, pKVM took the approach of specifying these features
> using macros and grouping their handling by feature id register.
> This proved to be difficult to maintain and bug prone. Moreover,
> since the nested virt work there is a framework in KVM for
> storing feature id register values per vm, as well as how to
> handle traps based on these values.
> 
> This patch series uses the vm's feature id registers to track the
> supported features, a framework similar to nested virt to set the
> trap values, and removes the need to store cptr_el2 per vcpu in
> favor of setting its value when traps are activated, as VHE mode
> does.
> 
> The changes should not affect the behavior of non-protected VMs
> nor the behavior of VMs outside of protected mode in general.
> 
> This series is based on kvmarm/next (60ad25e14ab5), since it
> requires the patches from the series that fixes initialization of
> trap register values in pKVM [2].
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20241122110622.3010118-1-tabba@google.com/
> [2] https://lore.kernel.org/all/20241018074833.2563674-1-tabba@google.com/
> 
> Fuad Tabba (15):
>    KVM: arm64: Consolidate allowed and restricted VM feature checks
>    KVM: arm64: Group setting traps for protected VMs by control register
>    KVM: arm64: Move checking protected vcpu features to a separate
>      function
>    KVM: arm64: Use KVM extension checks for allowed protected VM
>      capabilities
>    KVM: arm64: Initialize feature id registers for protected VMs
>    KVM: arm64: Set protected VM traps based on its view of feature
>      registers
>    KVM: arm64: Rework specifying restricted features for protected VMs
>    KVM: arm64: Remove fixed_config.h header
>    KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
>    KVM: arm64: Calculate cptr_el2 traps on activating traps
>    KVM: arm64: Refactor kvm_reset_cptr_el2()
>    KVM: arm64: Fix the value of the CPTR_EL2 RES1 bitmask for nVHE
>    KVM: arm64: Remove PtrAuth guest vcpu flag
>    KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
>    KVM: arm64: Renumber remaining vcpu guest configuration flags
> 
>   arch/arm64/include/asm/kvm_arm.h              |   2 +-
>   arch/arm64/include/asm/kvm_emulate.h          |  23 +-
>   arch/arm64/include/asm/kvm_host.h             |  21 +-
>   arch/arm64/include/asm/kvm_pkvm.h             |  25 ++
>   arch/arm64/kvm/arm.c                          |  30 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h       |   2 +-
>   .../arm64/kvm/hyp/include/nvhe/fixed_config.h | 223 ----------
>   arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   5 +
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   2 +-
>   arch/arm64/kvm/hyp/nvhe/pkvm.c                | 335 +++++----------
>   arch/arm64/kvm/hyp/nvhe/setup.c               |   1 -
>   arch/arm64/kvm/hyp/nvhe/switch.c              |  56 ++-
>   arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 402 ++++++++++--------
>   arch/arm64/kvm/hyp/vhe/switch.c               |   2 +-
>   arch/arm64/kvm/reset.c                        |   6 +-
>   15 files changed, 430 insertions(+), 705 deletions(-)
>   delete mode 100644 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> 
> 
> base-commit: 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df


Tested-by: James Clark <james.clark@linaro.org>

