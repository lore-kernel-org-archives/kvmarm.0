Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108B516E88C
	for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716901173; cv=none; b=IERQr7qd0lmq3X2ow1jVOMp66qZCa3UyGI47wZ2buAdZ0rCT3G/k2usqZqyE9eHAA3hBtv9Z3gWLWxcZdFK1QbrSfCKVxmrXDBLQbuVvzhew71z7zwqAVvikIAG9NHRo7EzkZ8Jv+W4Lk4tTPaC2tN1FKPfAdd/Z8ivuCai/P1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716901173; c=relaxed/simple;
	bh=L/FdCz8LjUAZrpsq+i/7Q10bmysizsOAD1MGbfogZQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jUd0zUwr8loiixqSw73mhk9gkMv31t1M84u/Ug0+pRJ2Tg2IMAECERJHCJPzSFsRSSBWQ8cK40PCsTA5Or/dfh0OBG9mJct1kpXJyW+RuJlDlfWjXwEM9Fmwg1+IDbxGRIUF70YBfZMTDepA7lBNViqw2wURCrCcj0k+LvvzPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y0NHxGac; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y0NHxGac"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a0eb1c809so15384267b3.2
        for <kvmarm@lists.linux.dev>; Tue, 28 May 2024 05:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716901171; x=1717505971; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TVBmqCbqXVk+ht4sucH/CNZwTOqlBjeUdtdnIaIZsU0=;
        b=y0NHxGacuu7olfpMPRllz2TJGiy8RMKffatVRx5P93Q1yQGKxL4bx8/IpA97G7j4xx
         0UKTAd4nGyZdKbDodN1MhbBJSadtR9AOtzYsvWOTvnIPoG8CiA0f3oi9aMESXhIYFN5j
         JmPqltcRhSJ2+pPcbBpXNPDGkTxgI47qrCmjeFNQUjirxRCaeljacu5VR+1119n8KkEo
         dj5d/OhsGTquTEVUmlnZ/FXuGWJcOJD5whLKl/5bEbnh73VsNy9SQzPyTDufoqekA2gC
         vxAxuL7K3BP5FNWqvG8LmYfNUiLTacHfa6QjfIJBGne8xsOJe4+AzSm/S4Jqpmufk1fC
         g12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716901171; x=1717505971;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TVBmqCbqXVk+ht4sucH/CNZwTOqlBjeUdtdnIaIZsU0=;
        b=tU1btrA8aPk2jXrpY9+JSWaLTkMismtLWzThUEC7Zo8mf1MCoPxNdwj7hsMQrfB9sW
         OoaFneSdL4SiypY5dp4rJe7+8cCs+p+876O/9eHRULdrWT6Dbg+LpusmQPNGwptTNXXS
         fC+mCrsfNsOIHXOIfLKicrOVVgHcNCOCn6AAzhD0d7ODD/eMIHwq506laKwMgynh7z1n
         JQj5hv6A61XIHIyQdavTsHvbChjx4kuaSU6LJ22r35Tt1RPKu3+1789FAqtGgW3SEMCj
         aKpesSVVvE6hEgRDnVc533OvF4CCOF2otPvi2z0jFERfn/sJngfi4ej/IhuCxWlwBLpW
         6FsA==
X-Gm-Message-State: AOJu0YxxYaiP5SAJ/LPgBOTsZy1ScE4WGOCHYGGkTXNjnWGbwnrE/0k5
	7Xzlh/lZZYQ5VtJzqyf4IWglgYYFb/OiRHLVzI6sBMvrWylGsJa6ZtG/R5+jgjpcmwL03Lmh/uC
	i/pX5VKpBFbS+RAF+nQxRd+ZHzLLOO6g2mtPSpOTEmSnuIG+SlBSkYeUiqwr2PXH1yXBT0nllBF
	8WJjwdclGKmCWPbqoJgzSti+HQMYQ=
X-Google-Smtp-Source: AGHT+IFE+CYLjYyT9q2cgM5wGNs51LJxqlRyTobmAVK3eopHmd0iel8FrlT5YF756fpXurQpQU1O52EHoQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:6f8f:b0:627:6431:caa8 with SMTP id
 00721157ae682-62a08d92592mr35398287b3.3.1716901170826; Tue, 28 May 2024
 05:59:30 -0700 (PDT)
Date: Tue, 28 May 2024 13:59:09 +0100
In-Reply-To: <20240528125914.277057-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240528125914.277057-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240528125914.277057-7-tabba@google.com>
Subject: [PATCH v3 06/11] KVM: arm64: Consolidate initializing the host data's
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
 arch/arm64/kvm/arm.c                   | 20 ++++++++++++++------
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 -----------
 arch/arm64/kvm/hyp/nvhe/setup.c        |  1 -
 5 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 90df7ccec5f4..36b8e97bf49e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -550,8 +550,14 @@ struct cpu_sve_state {
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
 
-	struct user_fpsimd_state *fpsimd_state;	/* hyp VA */
-	struct cpu_sve_state *sve_state;	/* hyp VA */
+	/*
+	 * All pointers in this union are hyp VA.
+	 * sve_state is only used in pKVM and if system_supports_sve().
+	 */
+	union {
+		struct user_fpsimd_state *fpsimd_state;
+		struct cpu_sve_state *sve_state;
+	};
 
 	/* Ownership of the FP regs */
 	enum {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1acf7415e831..59716789fe0f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2444,14 +2444,22 @@ static void finalize_init_hyp_mode(void)
 {
 	int cpu;
 
-	if (!is_protected_kvm_enabled() || !system_supports_sve())
-		return;
+	if (system_supports_sve() && is_protected_kvm_enabled()) {
+		for_each_possible_cpu(cpu) {
+			struct cpu_sve_state *sve_state;
 
-	for_each_possible_cpu(cpu) {
-		struct cpu_sve_state *sve_state;
+			sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
+			per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state =
+				kern_hyp_va(sve_state);
+		}
+	} else {
+		for_each_possible_cpu(cpu) {
+			struct user_fpsimd_state *fpsimd_state;
 
-		sve_state = per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state;
-		per_cpu_ptr_nvhe_sym(kvm_host_data, cpu)->sve_state = kern_hyp_va(sve_state);
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
index 3fae42479598..f4350ba07b0b 100644
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
2.45.1.288.g0e0cd299f1-goog

