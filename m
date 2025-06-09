Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436D82163BB
	for <kvmarm@lists.linux.dev>; Mon,  9 Jun 2025 17:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489924; cv=none; b=ELcQuj6ytF+uofNELG/aQI7WRpdatJUgSOweHNi9joLvBd052WHInVPngsAiaBrPQvPLOPOjaKUNW+D2xi74L5O1TIco2R/SCLuSw2mrwS/ZJWDcxB/dRWPKLE+oIsiMYOnx9hyN/BrCPcAPYvO8XjnvJZy7YHwgahT0Mm6CUK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489924; c=relaxed/simple;
	bh=iKCzbFO1u3OBxISKMxioVdcXjsf1HtEXffACIwjwKWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfxtOMHfs1YIUyOy2wDLp+BUB01RmS2mEkX+oDWfGGiGkk9WopKVJij6d5tmxHztKR7THzw6BnejXXlNBeCIqPWjiCyqkkuQirBHuJlKTmvHTOwhx/8lIcIK04BbFPAICx+MiRaGDxcnSOB3o789GxxhnLWA4WREyzJZ9nzjw7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DV3kaBK0; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DV3kaBK0"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-450d726f61aso4895e9.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Jun 2025 10:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749489920; x=1750094720; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EgfIn5pyXrhKDKyy/DFnRR/WDzU1LorI0fXEYQK34SI=;
        b=DV3kaBK0zhIkEV32qKTjf674wcG1yj1tCgB2+AIstrw32vXijrr4JpcT/p7sB/McIm
         ZnJxHGX9jLu59Vm+pav4rtHRGGTUUbCQ4I0m2Ao8X2ZY+gaWIaV0G0M37RFPORvS6Xtq
         XnL93+oUiEYbhhTJtBNHV4t2hiE2shzrHyD6ezwEIpQUYOYOWeTGOJOSn3Q0H3GAL1Pv
         s3oSmvL9OcDqS6wdFI4NnzJNdNuxmj2QUaauF5Qvh5PhdRrIiEOEYyiIrT54PJ6ZJJs7
         US6Qdinm0mJ9pzdUR8Q0hJdKMgTTAWREABWJWyZVlkEuy3p7I6JE7f+xfrBJhvYoeHjs
         +GSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749489920; x=1750094720;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgfIn5pyXrhKDKyy/DFnRR/WDzU1LorI0fXEYQK34SI=;
        b=Jnir51PKKPBkQLSFnAFzZ2MbAPTiG+A5ghNlweWFyS4Pv4V050ErO890zCAbDV+SYD
         cEo8AtFoyCvIhdppmKOgT1jtXPk02uFD91pgnr0IVKlZl5/e+0KCy3Smm2x9lT3B5sI2
         qQrAA6FqbTsx+VG6G9bs6Sy3c9n+PNfzpOyQH/krisp5+JfGZ5w2RkRt1Qw4ngsBO36D
         T9OlcA6xEkv5Fl215n7g4GnchiY2sSlXu74C+y7k+aB9smpSTUe3bU6ltOcYjwlGEXA1
         +KH648B0A5fIC9XHC6/VblBLS2ozkki3byru+rUepVpVucQXTR2JwhgCBIwm+uA0QcUJ
         DEeQ==
X-Gm-Message-State: AOJu0YxVLHfgyDtUvqu4t1oTYBs9rCW3K1tLVuYiheElKXIUIxGmyGjo
	+1L9ikA11JPVKKOOXHVeqrZrGObWJURzLj6g6WX69QjA4UOgYJgO+wYi6j6t9/h+BxlcKQpUyS3
	/s/6Rrw==
X-Gm-Gg: ASbGncvp3+COJwY+lEs+41e9tSlQTnVzUzZhH1pJ1MlDRpCgFUUtJNer1Yhhgd/WG3o
	QErbRbe4ADZDvQohrsbHBMex/59/2wdC+1o5TTk/+VuuS5eE4MIfLIRkZvVw2A8Ak1CegdBhgcE
	6jVEvn9DxGGBMRmu7Yy3iWXqutD1rWYki2VEGTVaF4wa1Pvirx/LgDg9mj68CIITQFE+SkRuhgu
	kzGIqZWDu24LqR429i4uyekUXeC4uST/TrIgqPRou0vx88jH3Y3y2A7iZPzkNAPYUU0YA+IFNxl
	OmKGiBrubNRo2ykjgeYxywvIW1VnmhRCXyHZFEO/4uv7icMy1hwUuzocrhlTN3HsdzXOPiZeQMb
	6q0ijk62lsSA0Le9jnnODqct/e5lzWIws8UM=
X-Google-Smtp-Source: AGHT+IG7OEe8XVakf5BvT9bg/McMQlULLBqgoAc16jrn6FPrhelDc4EcTlGxudh7v7+LVuW7I6SDmQ==
X-Received: by 2002:a05:600c:cc:b0:450:cb25:ead with SMTP id 5b1f17b1804b1-4530111b3cbmr2535815e9.7.1749489920354;
        Mon, 09 Jun 2025 10:25:20 -0700 (PDT)
Received: from google.com (206.39.187.35.bc.googleusercontent.com. [35.187.39.206])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4526e163447sm112959465e9.17.2025.06.09.10.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:25:19 -0700 (PDT)
Date: Mon, 9 Jun 2025 17:25:15 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Quentin Perret <qperret@google.com>
Subject: Re: pkvm boot failures
Message-ID: <aEcY-1Iv8S-e8LVi@google.com>
References: <yq5ah60pkq03.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5ah60pkq03.fsf@kernel.org>

On Mon, Jun 09, 2025 at 06:53:40PM +0530, Aneesh Kumar K.V wrote:
> 
> I am hitting the below failure with v6.15 (I tried other kernel versions
> with similar results). I disabled CONFIG_PROTECTED_NVHE_STACKTRACE
> because with CONFIG_NVHE_EL2_DEBUG, the stack was pointing at
> hyp_assert_lock_held() .
> 
> [    0.664457] kvm [1]: nVHE hyp panic at: [<ffff80008050b10c>] __kvm_nvhe_handle_trap+0x34/0x10c!
> [    0.664538] kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTECTED_NVHE_STACKTRACE
> [    0.664566] kvm [1]: Hyp Offset: 0xffff000007c00000
> [    0.664631] Kernel panic - not syncing: HYP panic:
> [    0.664631] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
> [    0.664631] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:0000000000000000
> [    0.664631] VCPU:0000000000000000
> [    0.664938] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.15.0-rc1 #594 NONE 
> [    0.665068] Hardware name: FVP Base RevC (DT)
> [    0.665140] Call trace:
> [    0.665196]  show_stack+0x18/0x24 (C)
> [    0.665346]  dump_stack_lvl+0x3c/0x80
> [    0.665468]  dump_stack+0x18/0x24
> [    0.665588]  panic+0x124/0x2d8
> [    0.665699]  nvhe_hyp_panic_handler+0x108/0x180
> [    0.665825]  do_pkvm_init+0xb0/0x124
> [    0.665957]  do_pkvm_init+0xb0/0x124
> [    0.666089]  kvm_hyp_init_protection+0x5c/0x6c
> [    0.666226]  init_hyp_mode+0x760/0x790
> [    0.666362]  kvm_arm_init+0xac/0x23c
> [    0.666492]  do_one_initcall+0xa0/0x1f0
> [    0.666617]  do_initcall_level+0x8c/0xac
> [    0.666753]  do_initcalls+0x54/0x94
> [    0.666885]  do_basic_setup+0x18/0x24
> [    0.667019]  kernel_init_freeable+0xc0/0x10c
> [    0.667157]  kernel_init+0x20/0x118
> [    0.667271]  ret_from_fork+0x10/0x20
> [    0.667400] SMP: stopping secondary CPUs
> [    0.667475] Kernel Offset: disabled
> [    0.667534] CPU features: 0x0000,00000140,064dc298,cb7a552f
> [    0.667619] Memory Limit: none
> [    0.667681] ---[ end Kernel panic - not syncing: HYP panic:
> [    0.667681] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
> [    0.667681] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:0000000000000000
> [    0.667681] VCPU:0000000000000000 ]
> 
> I was able to locate a .config that make the pkvm work, But i am not
> able to identify which config dependency is making the difference. I am
> attaching below the working and non working kernel configs. I am using
> FVP to test this.
> 

I had a look at this and tracked the issue to "CONFIG_JUMP_LABEL=n"
It seems that it panics at
	if (static_branch_unlikely(&kvm_protected_mode_initialized))
Where "kvm_protected_mode_initialized" is mapped in the initial PGD for the
hypervisor, but not mapped in the hypervisor created one.
As the variable is defined outside the hypervisor namespace, it doesn’t exist
in the hyp bss section.
And in case of "CONFIG_JUMP_LABEL=n" it  won't be patched in this case, causing
next access to read the variable and panicking.

I guess moving this key to hyp would cause problems with kernel access after
de-privilege as cases from kvm_share_hyp(), So I can only think of having a
different key for the hypervisor as

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8e8848de4d47..8945b335bcea 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -21,6 +21,7 @@
 #include <nvhe/trap_handler.h>
 
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
+DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized_hyp);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
@@ -626,7 +627,7 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	 * basis. This is all fine, however, since __pkvm_prot_finalize
 	 * returns -EPERM after the first call for a given CPU.
 	 */
-	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+	if (static_branch_unlikely(&kvm_protected_mode_initialized_hyp))
 		hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
 
 	id &= ~ARM_SMCCC_CALL_HINTS;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fcd70bfe44fb..af0854e98902 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -17,6 +17,7 @@
 #include "hyp_constants.h"
 
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
+DECLARE_STATIC_KEY_FALSE(kvm_nvhe_sym(kvm_protected_mode_initialized_hyp));
 
 static struct memblock_region *hyp_memory = kvm_nvhe_sym(hyp_memory);
 static unsigned int *hyp_memblock_nr_ptr = &kvm_nvhe_sym(hyp_memblock_nr);
@@ -229,6 +230,7 @@ static int __init pkvm_drop_host_privileges(void)
 	 * once the host stage 2 is installed.
 	 */
 	static_branch_enable(&kvm_protected_mode_initialized);
+	static_branch_enable(&kvm_nvhe_sym(kvm_protected_mode_initialized_hyp));
 	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
 	return ret;
 }

--

Can you please check if that helps in your case?

Thanks,
Mostafa

> 
> -aneesh

