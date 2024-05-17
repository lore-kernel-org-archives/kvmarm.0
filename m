Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB4852F80
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951916; cv=none; b=j627PHA1NdEGmE7RSrG9lt0l8I8jFQ4MNQhIilJqD4VDjkzyfoYEOZ4pF6YPnq+nLOydgvKVO7MHPx+3Z1x5tYQmiyE9o0sfgI7Eq1hxPQ5d2fqzc1OO6TWJ3u5NScWwdfCXpls0h5AM3DZs5y6vHS3RxGLv67qdk8IAxejPrgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951916; c=relaxed/simple;
	bh=GSxybGoMcSedlOxu+FQeMWd86REkLVBByNaAR7m4Fbo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ty8bypZJ3JTomGXM7rGeclgO2XFQX++S/Ynk3giEKjILs3XGqBcx+hSNjopNaTGN2Bez6nCus+lwECLvq8+k3Kabl2Q19mcGHBh/Aa/0W9oYxFqMFS2YiyDQ6B6H3qflPBNkF9Vu2Aj/gG+oZw/0AN+ceOpwU5B/NXHNnph1BAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F8hbysTk; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F8hbysTk"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df1cfa720aaso5063723276.2
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951914; x=1716556714; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pU8haNdIz7OB9TYnuwypHCRh/8fgpVq13mut0PwIznY=;
        b=F8hbysTkmW7vZexvNLFZE4mivjsCSCMhDXhPtYpj3EW2z4P1zGFc1ppK16PmR6jlDm
         abVBr77DUB4kNFQC9WhFhDa/QNlbhzJFG9aAfitY+NmOOg8fRcdJjqu2PedrgGtzQhWk
         i6ASs51RAYMyUZXsSunBm1eDqk7e0TGA/H5pA/pFzdQyOPBvF3YSGTR2QxtLNFcBMmqe
         MIksY7CqmuwykKwVzdNackcbASmdaOpHxeSECiMUXqH+cC8VZxCgIIj1NMEyd+mf0Vu5
         H6t7SsuAJw72rHQ7yZBh6XSfEykuhtULSyjLppe9rNQ9PqHJqRCdYFnESZNFHhlLW+r0
         aXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951914; x=1716556714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pU8haNdIz7OB9TYnuwypHCRh/8fgpVq13mut0PwIznY=;
        b=fST/mza+4HHQi9+EHPxrEQ6qacOiqi5rdopbZxLZ3AasaDUxosVXkJ2m/TRxawnskt
         1/tWa6X63GVcElUSVP7r2EIzUKNftOL9A+yiA9JCUBsupHjY24Wqy2GNjPKhLkI4Omlf
         MXb1BzKADQcP7VegYR4sDwxzwm/CPWZ64wCwbXxntjY8/7o6hkZVzeEYIVZZxeag4Qlj
         KJYqnpC7K1WoABbFKpFUsZSLkjCrOwDWS36xT2D1fizKDtuGJGq9hIFAnRK9VIRwU0YJ
         GlDQPWCIY8NM5NxoU1XIzme0LH7CwjqCsPxMRmoUexp/sONxbRm1jivLj2r1ndU7ohUI
         tIUA==
X-Gm-Message-State: AOJu0YyIiJEZ99bhD5xBLWvCtTYYn11zT2DE5J2/p6AbdWsNiCNpOlzI
	zeErleGiWvBVCd6izb1HnaSohHkQzeWjZwRmitrlQ3lsvRxVtQZ6tDQ/tgp6E2QWgiAOfQG0HxO
	RxEjslnGRAE6Nf6xLjenHKyg9vVbTFGDkqFRfAmQyLjhFGmThdITAJnJEebZrg7SYRDYDGJKufW
	HQRhV748udDEq0e9hDD2KJfhhpqqs=
X-Google-Smtp-Source: AGHT+IE09CMmgxNqUbg2WeAEx1fobd03mz4IHrYZC/hAfFq8y6KNowZ4PndBeeYVUfE97cbyMBIXCRX0pg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1201:b0:dee:6f9d:b753 with SMTP id
 3f1490d57ef6-dee6f9dbdeamr1442555276.6.1715951914040; Fri, 17 May 2024
 06:18:34 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:14 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-8-tabba@google.com>
Subject: [PATCH v1 7/7] KVM: arm64: Consolidate initializing the host data's
 fpsimd_state/sve in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Now that we have introduced finalize_init_hyp_mode(), lets
consolidate the initializing of the host_data fpsimd_state and
sve state.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h      | 10 ++++++++--
 arch/arm64/kvm/arm.c                   | 18 ++++++++++++------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 -----------
 arch/arm64/kvm/hyp/nvhe/setup.c        |  1 -
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7b3745ef1d73..8a170f314498 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -536,8 +536,14 @@ struct kvm_cpu_context {
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
 
-	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
-	struct user_sve_state *sve_state;	/* hyp VA */
+	/*
+	 * All pointers in this union are hyp VA.
+	 * sve_state is only used in pKVM and if system_supports_sve().
+	 */
+	union {
+		struct user_fpsimd_state *fpsimd_state;
+		struct user_sve_state *sve_state;
+	};
 
 	/* Ownership of the FP regs */
 	enum {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a9b1b0e9c319..a1c7e0ad6951 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2445,14 +2445,20 @@ static void finalize_init_hyp_mode(void)
 {
 	int cpu;
 
-	if (!is_protected_kvm_enabled() || !system_supports_sve())
-		return;
-
 	for_each_possible_cpu(cpu) {
-		struct user_sve_state *sve_state;
+		if (system_supports_sve() && is_protected_kvm_enabled()) {
+			struct user_sve_state *sve_state;
 
-		sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
-		per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state = kern_hyp_va(sve_state);
+			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
+			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state =
+				kern_hyp_va(sve_state);
+		} else {
+			struct user_fpsimd_state *fpsimd_state;
+
+			fpsimd_state = &per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->host_ctxt.fp_regs;
+			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->fpsimd_state =
+				kern_hyp_va(fpsimd_state);
+		}
 	}
 }
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 22f374e9f532..24a9a8330d19 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -59,7 +59,6 @@ static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
 }
 
 void pkvm_hyp_vm_table_init(void *tbl);
-void pkvm_host_fpsimd_state_init(void);
 
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		   unsigned long pgd_hva);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index feb27b4ce459..ea67fcbf8376 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -249,17 +249,6 @@ void pkvm_hyp_vm_table_init(void *tbl)
 	vm_table = tbl;
 }
 
-void pkvm_host_fpsimd_state_init(void)
-{
-	unsigned long i;
-
-	for (i = 0; i < hyp_nr_cpus; i++) {
-		struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
-
-		host_data->fpsimd_state = &host_data->host_ctxt.fp_regs;
-	}
-}
-
 /*
  * Return the hyp vm structure corresponding to the handle.
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 5c8cd806efb9..84f766ab1810 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -324,7 +324,6 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
-	pkvm_host_fpsimd_state_init();
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

