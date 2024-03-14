Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682E7603C
	for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447840; cv=none; b=C35rH5CtKdGi2EYXGsBT09UxER3V32E/vVvJ/NRkQhBtCdD/5FQZX0CazeKEKOwShRcjji1uaeMcAcUQNbEzI5X3RZlW94vL3QXArzzwfFqqPSq68N05G7kGlc/Rj7ZrlVJB+y76K8nec/g+DSC8fd8DTMP9W2k/XnmNGwO5g+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447840; c=relaxed/simple;
	bh=i2a49zzhhviQbMDBD+mz1nCXcS8PgLH45YTWytn4lgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5YUGglFLy0AVXPMdZrfN25Nuvfqa6so83VFyRSpG1kCVthFl4CpnNiDLcdUdCVLb43Vo3jqBuiu9RBnjWBgEfe3yB7a/8KeP+OVyuZ6P1c30nLhK5XctAuQ0+YnXUEdkivKqFh7Rvt89ln0jqUauKfcED13AbUsMPnAizj7PRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MHqayUo7; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MHqayUo7"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a4644bde1d4so179337266b.3
        for <kvmarm@lists.linux.dev>; Thu, 14 Mar 2024 13:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710447837; x=1711052637; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SuRgs8OupZSCiXLSHaIaVM3v2VB8UqXtWW7TcEnKPlc=;
        b=MHqayUo7PiWXF+rc00F8o0FwUIZL4niApdhkZWvOfTsUil1kxUR/YVSIMn9qUEfOAM
         /5sTkxD5mw/BPujyWbik2QlWwpGTwjbqXrVChLvbmNrbaaq8hP7qFklNzgcBCOSSNyRu
         U0NDJ3w1vrauai2Gd+KrhBa6uQj2qXTGKFzCOCdB952FRQ74Ovg7zJdhjyUuc5XNvCEp
         a90WTpeFJ4hIPx+TlQCP0a+JtEm8F+PBP9Q1pFlxJHtd+w6WK4gk7o5HL/1GBE9+tsdY
         oS52L3VkWEAMNnhR72E/UUxsT7OQv8f+s/3cRTcdKE7GfsbVQL/5rRDZbzYLYVWo7D4l
         A0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710447837; x=1711052637;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SuRgs8OupZSCiXLSHaIaVM3v2VB8UqXtWW7TcEnKPlc=;
        b=wDFMrgzkavwT7A16QdHfJmLdI/CvwcP4hLCDEEnr8K/twOXPhx4hLps8sJuuKxKJMw
         LNGgJPfdZ5Htg3p1JoG7+AyceKQTIrAS68orolk5QSSVpVciJq3Gg+oV/3H4gXorn0ND
         Fyz2lN0Muo/fzUMXJMVykA26dCSDo8A1FX+/Aovif+3NdWBKLzSSkOPBoH1aeqIdsCJc
         grw1xqV/vd+MsLsdo4rIjos7aJoeC0cMdGHQ3d1MD+bUs72kfhZwTcJvtvRH0UrhH3Op
         y4gtbgofZZpim0qnrxaWXEaxRaz+dxc90AWX88VTIk8vgKR8atZnwdo9wgGJTWVJLIYl
         zqGA==
X-Gm-Message-State: AOJu0YyLdH5KN/neGLz2CGL/S+FvUV7RvxM1GBOLL5I+ZAcdFz0KYkfH
	kAHZJ2GI85FP7smbvC/IvaMwrx2SzkymFZe8Bi+UhLTn4rzaofX1Rkkdg1QaJGWn3WcCU7XiKtS
	pAq1b
X-Google-Smtp-Source: AGHT+IFsZiG44+ltcDXnRY8E+FNEpm//GsTqieZeJfeGLiwfbk3sWb8YsaRi2GbAi6yCl23eklsVOw==
X-Received: by 2002:a17:907:968c:b0:a46:220c:a55 with SMTP id hd12-20020a170907968c00b00a46220c0a55mr107555ejc.73.1710447837274;
        Thu, 14 Mar 2024 13:23:57 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id r7-20020a1709067fc700b00a45fefe4fc5sm1007501ejs.135.2024.03.14.13.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 13:23:56 -0700 (PDT)
Date: Thu, 14 Mar 2024 20:23:53 +0000
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Subject: [PATCH 03/10] KVM: arm64: Pass pointer to __pkvm_init_switch_pgd
Message-ID: <c064d060fbc58fe6b589679487622e21275fd598.1710446682.git.ptosi@google.com>
References: <cover.1710446682.git.ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1710446682.git.ptosi@google.com>

Make the function take a VA pointer, instead of a phys_addr_t, to fully
take advantage of the high-level C language and its type checker.

Perform all accesses to the kvm_nvhe_init_params before disabling the
MMU, removing the need to access it using physical addresses, which was
the reason for taking a phys_addr_t.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 8 +++++---
 arch/arm64/kvm/hyp/nvhe/setup.c    | 4 +---
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 7a0082496d4a..32fb866d1229 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,7 +123,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void));
+void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
+			    void (*finalize_fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 2994878d68ea..8958dd761837 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -266,6 +266,10 @@ alternative_else_nop_endif
 SYM_CODE_END(__kvm_handle_stub_hvc)
 
 SYM_FUNC_START(__pkvm_init_switch_pgd)
+	/* Load the inputs from the VA pointer before turning the MMU off */
+	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
+	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
+
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x2, sctlr_el2
@@ -276,15 +280,13 @@ SYM_FUNC_START(__pkvm_init_switch_pgd)
 	tlbi	alle2
 
 	/* Install the new pgtables */
-	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
-	phys_to_ttbr x4, x3
+	phys_to_ttbr x4, x5
 alternative_if ARM64_HAS_CNP
 	orr	x4, x4, #TTBR_CNP_BIT
 alternative_else_nop_endif
 	msr	ttbr0_el2, x4
 
 	/* Set the new stack pointer */
-	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
 	mov	sp, x0
 
 	/* And turn the MMU back on! */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bcaeb0fafd2d..45b83f3ed012 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -314,7 +314,6 @@ void __noreturn __pkvm_init_finalise(void)
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 		unsigned long *per_cpu_base, u32 hyp_va_bits)
 {
-	struct kvm_nvhe_init_params *params;
 	void *virt = hyp_phys_to_virt(phys);
 	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
@@ -338,9 +337,8 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
 	update_nvhe_init_params();
 
 	/* Jump in the idmap page to switch to the new page-tables */
-	params = this_cpu_ptr(&kvm_init_params);
 	fn = (typeof(fn))__hyp_pa(__pkvm_init_switch_pgd);
-	fn(__hyp_pa(params), __pkvm_init_finalise);
+	fn(this_cpu_ptr(&kvm_init_params), __pkvm_init_finalise);
 
 	unreachable();
 }

-- 
Pierre
