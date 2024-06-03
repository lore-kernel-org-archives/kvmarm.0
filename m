Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235D977118
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417753; cv=none; b=g7gnZpS8MPMd3PBIHxXw+p5vysaYwRCmQDaQOKsvKyoYv2V/cWPg2LQraNdY1TKJf80SNCiwENmueZK8SkOZiXAwLN9qQRdfqa5SY+eVUEDFU3cDRrmOzOuijB3p/+2RhX6NoFUKtcAeoBA/i8oXOBNQmJekgI28D8+e8JzXhPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417753; c=relaxed/simple;
	bh=ZobilgW+nIO1t/n5DQN0tBmI9ip8tCFHG2F3WTdbopE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bLZBrl/VlVK3itLMLE9bfc6es06RE81df2ezREnqinKqEWKS7ZcoArhM8F0W0d79AYwRUZSbyVRuUGH2U6F4KsvDQtwYz9CegWJ9Rne7mzV3HXRVTdEVI6513+EeW7gm/Q3YB/b/nuFuKizYj2UihXjSKDnI/Yla7YFZcoPHB6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJmwFoxw; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJmwFoxw"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4212a4bb9d7so30361535e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417750; x=1718022550; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U42arwuWsMiHE66qzXZnxwdOUgD9GbRPo4yP26HiIzg=;
        b=fJmwFoxwMGKpIv6pUc/rCbcYZEQEP8oKP07y6rkfhpYqN55TIvfAGX5YT9LJynMPAS
         ebp1B82od2F5onn6gZB53uI1p2oyYM8NwDa2Hs2dzbDfk9J/GXi0TYhwqN5slkpYX0yq
         CxVyJoo/jXyXnmoPUOpKptct2hOoGzdUXbJLBBVJoCYZu9ELZ+QqsKze96BKuw/S2WSK
         arKJT+S4kBX89BykQXoKxy9TEu6NfDKgWUs/kZQ3PulH1JZTDYUQh4bhZZ7GUvq0038c
         yl++mZNxfp3VatMeWc8x0BHd9kOjpUhDcUj95HlXa+s/bYYT7QZEK4QTnrjJIPyDz4+a
         EWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417750; x=1718022550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U42arwuWsMiHE66qzXZnxwdOUgD9GbRPo4yP26HiIzg=;
        b=OCN4Zqlxnw6gOdRmVSONq2cd/WGcUQlEg/spi+InB2+FV5Y6DNumLO/CC+zN3c7QmZ
         HKHX+qYotJCV5EzzNhXA+JRd7dRrKjopypX+jp5kZFAPk3DXAt8XXSeWj4AQrXWab96S
         WQEl/a+MogHCw5ILz8bSWscvKU9BVXNWboQ2LkTCspG+toaKX+3+9kQha24sWIeCjF0q
         MtSWLdrzNguedW5SXdWoJFNGPHzD560pkTPNToQqBYUfdL5KzY5cEAQN2lIsPxbk2pex
         Xf6qE3x9aByEKB4Zvlxe5yYXIzTWsbKUaL6PUJk6Q9F0dIdVUPFFFKEsrsD0QvqBE0ag
         Bo4w==
X-Gm-Message-State: AOJu0YzqPzsP9mxz0qUhMdmlJCXCi8MUL1/uB0qoAozRCvKVAQhdqbrT
	bAE0v9sIdlXefYiiABi0nM1CxeBsWPosW1qTufL1BC1Ok6hdmimFTQ7t5O1EpS0hRpO79MXgK5E
	JqrF5e+4hy7+dRO55suPe8HC7WDaY+rOcHTMBz+vNw25tsziPuxW/fVntwZ+FvHFPnnLHTl739T
	O9Li+U4bKLThDqZzd7I6L6DLl9grg=
X-Google-Smtp-Source: AGHT+IGO7jTM5E9IKZ1m5EqdbMKWV26ViD5BIiFLPbythaPnVe/itjF5Rf9NW4Q562jRTh229fvP4hKtlA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c0a:b0:41e:a0ab:f964 with SMTP id
 5b1f17b1804b1-4212e0be57amr400775e9.7.1717417750147; Mon, 03 Jun 2024
 05:29:10 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:49 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-8-tabba@google.com>
Subject: [PATCH v4 7/9] KVM: arm64: Consolidate initializing the host data's
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

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
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

