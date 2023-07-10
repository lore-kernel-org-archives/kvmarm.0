Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BBE14296
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 18:04:10 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1b8b30f781cso60007785ad.2
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 11:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689012250; x=1691604250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYLqBZaOzItKfrZ7qkctl+bAW7Mt+I13t+2ynGF0UiY=;
        b=6Em8Ck8pY6H7hDftF5k/CCVkzxbaS7N4lV5OK+Ffe265Trlh+BahH5YWayzioUDpCx
         9iY1q8Vz2wSsf6tE3GQ8QEryG3FWftA5Yh/z8rQVFo7R0Hu6MZ1QyGlYjNC1bjU3v674
         0Ell1lskpcCObjlKpcc4ijxKU36LVV3ESUmVKHOT+GpahucrrNhiTISfmt88x9gL3J3c
         Ma3HWhwyvlyVKctsPIEq1iZ6KaX2qH6Dycz1M7G13T/R9XgSN8M+UKwaYsjSGa5GN7iA
         bhWJLa2DO3VY0TJCcvydGnhuj3NF5JTAkQjeQKaPtzzjT9hQ9CpwWRzsnyTtcZj5wO18
         GTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689012250; x=1691604250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FYLqBZaOzItKfrZ7qkctl+bAW7Mt+I13t+2ynGF0UiY=;
        b=Ce1RvoEfiGgMNLT8dr/MDw3uLHfjiIEvTbg9+18Lb3Ke3yjLbOjvbZ38PpGDVX7fxv
         wudv+L81adP+x46hBoi1ECRadjfU40NS9jkYL2KmlpXxMSq1xRq8vIDiAUdeVWSvhBP7
         vYCy5pm2V+9FNBIgSqcoT0+wMcr+wK+JDMPjrb3nZ9+8XQmVQqQj5dJFAF9ZBH3aQ9uQ
         vqWY0p0+4IS95bTmr8NhdKpw9hLSiqADEfq2lzxqzhe9CAqJpRy3pswPneDneeojcEXK
         oqNhix22T4SfxRaDw5Zoe01ybomuatB56/rJD13ZVrgmGXGlixPM5Jk14AcTcF54GjKy
         UvLA==
X-Gm-Message-State: ABy/qLZmjoh7kzmVM9l8njsKZLpnlvsMNjDQHXpYXwWggCurvCoCB+iP
	pMa+lKSKpBptbJTTJwhKtwqv+TdS/7Q=
X-Google-Smtp-Source: APBJJlFSH+yLARWOcKqEJKKiVaqNOQphp5bI5CS4BulNlpKXujS+z4/oFnINg8Jmh4rjEYd2oGsEDqv9UwM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1cc:b0:1b8:a54c:61ef with SMTP id
 e12-20020a17090301cc00b001b8a54c61efmr13097824plh.9.1689012250555; Mon, 10
 Jul 2023 11:04:10 -0700 (PDT)
Date: Mon, 10 Jul 2023 11:04:08 -0700
In-Reply-To: <20230703163548.1498943-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230703163548.1498943-1-maz@kernel.org>
Message-ID: <ZKxIGOAcQbknIcBL@google.com>
Subject: Re: [PATCH] KVM: arm64: Disable preemption in kvm_arch_hardware_enable()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com, pbonzini@redhat.com, 
	Kristina Martsenko <kristina.martsenko@arm.com>, stable@vger.kernek.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 03, 2023, Marc Zyngier wrote:
> Since 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect
> kvm_usage_count with kvm_lock"), hotplugging back a CPU whilst
> a guest is running results in a number of ugly splats as most
> of this code expects to run with preemption disabled, which isn't
> the case anymore.
> 
> While the context is preemptable, it isn't migratable, which should
> be enough. But we have plenty of preemptible() checks all over
> the place, and our per-CPU accessors also disable preemption.
> 
> Since this affects released versions, let's do the easy fix first,
> disabling preemption in kvm_arch_hardware_enable(). We can always
> revisit this with a more invasive fix in the future.
> 
> Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
> Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com
> Cc: stable@vger.kernek.org # v6.3, v6.4
> ---
>  arch/arm64/kvm/arm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index aaeae1145359..a28c4ffe4932 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
>  
>  int kvm_arch_hardware_enable(void)
>  {
> -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> +	int was_enabled;
>  
> +	/*
> +	 * Most calls to this function are made with migration
> +	 * disabled, but not with preemption disabled. The former is
> +	 * enough to ensure correctness, but most of the helpers
> +	 * expect the later and will throw a tantrum otherwise.
> +	 */
> +	preempt_disable();
> +
> +	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);

IMO, this_cpu_has_cap() is at fault.  E.g. why not do this?

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7d7128c65161..b862477de2ce 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3193,7 +3193,9 @@ static void __init setup_boot_cpu_capabilities(void)
 
 bool this_cpu_has_cap(unsigned int n)
 {
-       if (!WARN_ON(preemptible()) && n < ARM64_NCAPS) {
+       __this_cpu_preempt_check("has_cap");
+
+       if (n < ARM64_NCAPS) {
                const struct arm64_cpu_capabilities *cap = cpu_hwcaps_ptrs[n];
 
                if (cap)
