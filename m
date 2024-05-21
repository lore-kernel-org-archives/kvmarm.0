Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A4282EE
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309463; cv=none; b=oCZRvT6j1on2Kltuw4Ld2oPfHYz2NWyI19vf02LvuNGPI2HFy/1P7NWhDV+JgNfmPNkoi8VJe8eZfjTkhzYvZEi1d+rC9vtgoMqaVottIvp09yzdAcgVbwTiLgDppK4QkoDA8Ju7V/s9XeEqUTOMtI6VyGiY7KqngJzCYp0fw2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309463; c=relaxed/simple;
	bh=Js2GW6/U4eDdLECOWnC1jmK/OE6uAfqxtcRg4+14ga0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RHc9jJ/G/ruqvh1i5hIWxfKXHFh4fqAq7pSwUWbi/83tQIzLadEQiwLUMupCgfFcFFFYzVdWFsn7X2GFaRw1aBdORasoqxKIOUbc9UmfGo3iK87T8Fv2ZIryt0fjmfJTDlHDGBEhTQA5LwMgXvNpDm7/f+D5BQMhuEV4Z3gQEsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L1c3t94W; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L1c3t94W"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-34f1b148725so6541746f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309460; x=1716914260; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oucVA1DPA/QWyj8v5qEUCbOrhaiIXPCmcqo1IHNRjPw=;
        b=L1c3t94WTrhqvkqd4Yjtgf6faRz5nZiXbb1fHNIuVJxw5wFm3ziqdniLjNhEr2kvYU
         SzM7wtA0qYqJupKv/WcFGfPfFWuyGGX+qpVyldR9pE60gsOJXzRV6faPWgOygQSjx9JW
         AiNjr2Ry76gTO18zf5b6ihsdfXf8xub1Wm6cMYSy5CwWS7XOeIosnFRnlpYar7QrVoA+
         XFcIwvLOHJLbdpuncD/bNpYtXFG0rN/xGchCrNLwucxy5y1qNru89bVKuJmsBjCcGQaL
         xpEpbvGwfOqWfIoQ3WN/Q0zFQarFgyyfJ4L2N8JdQh+8C2geWXjq2YpnEDcatOMd+Gm3
         Ajag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309460; x=1716914260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oucVA1DPA/QWyj8v5qEUCbOrhaiIXPCmcqo1IHNRjPw=;
        b=A0vT9nqG7RfU6LVWQH0xRm7rX5kUONp2AlKntK892AHSrNKdwbohOK2ETfR8aMnjiw
         BxFhCI1J2aj/OBdIfkICC+EuUhNIrosGOPx2zb2BFg915nvoPYAj8mqmwQA0NrD9tYlb
         nfmL398RB8qy39hZHbfp1fIAChxGeSza6nOKLwI1sKjUZjTRtBJjWPaLGvFwdvdaMVTl
         HdOPbIsjBwCTE3RDBxbomDRbExrajzYZNAKMawAMu+l+ozfRxWBlajWW/FxOA7kCQ3GO
         Rf7G2djbyJRePhOY6tAHPwRZaMS9KwZ40hh+yZ0rvIsxnVZWk4WZp2amuU5agTy/nJHh
         UMyQ==
X-Gm-Message-State: AOJu0YzajhNtWPH4tN7TSNJl5UN8US/dCZeKabmTkn3FvvKFenYGFeqY
	lnuxVt/6giKGXv8H31oaDnWsHuJDdot2k/JiZwNg2E/vT+PRT5qhX6+dQPinAfgl27s25Gb1IW5
	ceilbf0edPNOI0H2NnYjzzeoDkTs6OVCGdXXx6YnqPArEUrLnIJHCM+P6OMt0h9JWDigW1oxBZ7
	2UrlnySPGPgfAFUi6qCCsILu58AP4=
X-Google-Smtp-Source: AGHT+IHyFZJgKWdq16BmVgBbRvG2j05zbJdpH/4fdFpSKvt0fvaz7o1O3/pWUZMzY4eVSVO/g98BBLW56A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6000:1841:b0:354:cc7e:430d with SMTP id
 ffacd0b85a97d-354cc7e4499mr10119f8f.12.1716309460040; Tue, 21 May 2024
 09:37:40 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:20 +0100
In-Reply-To: <20240521163720.3812851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-8-tabba@google.com>
Subject: [PATCH v2 7/7] KVM: arm64: Consolidate initializing the host data's
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
2.45.0.215.g3402c0e53f-goog

