Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2008485929
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261405; cv=none; b=fT71Koftj5hI+MGJEjFxvExJzSIfAeNsyK8WhXeX+QqDpNhSPznweE5l/1eoolDQGG1WYBc8rg9S6uBz1CFdgt8T13UCvsKqfoPM7iyR5S+CYbf3giwyGYig49Vyq2iaec06eYKX5Y6/5/6irhO8sTFmM+yAmmjUxeZdhHsWF3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261405; c=relaxed/simple;
	bh=xho9IFWx710gmg2B+pioHp5fgct7NvZPFTXSWV1TT/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N6CvXduyzEEirWVrjKFP7L6SKPiKI4kzt9VlSMVVFOnTQTmaVZuHupLgux0YkNqoZ07LnJt1OGSJATAA6EcJ1fo1HBrp+Ge7jMATkXK8fplA9VMOCV9tVwaGrn/aIxg+5KEumzAhyLDnJhdh2MnlnGHnvsKdPuPxED7P5EhPa1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zdu7TYTd; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zdu7TYTd"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so7293999276.2
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261403; x=1713866203; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVCmuVvEeePmMsrCljb07v6UeszqANODSfX3dRuDJNY=;
        b=zdu7TYTdgjQV1m7zmeY3AyjT+vVZhND98kCBoCl9q+DIoEBiYjszExEMnHZ4zJJU+b
         1WK/BB8awPbfZKSjjlW4fWH8e9DIymHSe7u/DTKFv1vHgv4euuxkSi1zONZrohgJWj0S
         Mqf9XWz8Swj9IHG7oC2WN7SX0tUXKAw7BeCEKFjkYjE5ajxaG+iEo+cgJFV2rquCYpkR
         VxnJfYDNVpFG3ZByv2Vo3wZYGpMuJKdqAEwy9mTV+Jra4bbE5IfGEtPXoT4TJdEMbydy
         I8FC0jzzFqQbJfmuc+NkZbUvPcJVqlezNNmhSz0YO1gzwWvR/nQR5dFkhpkrQTEvd4F9
         Rghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261403; x=1713866203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NVCmuVvEeePmMsrCljb07v6UeszqANODSfX3dRuDJNY=;
        b=P8ACW1w3iHYfi+cJigv/bb9Pw+WBDIhjj8rOJ9u23ZBJPklogaRb0IpkkVDtVRRAmy
         9g3K5btZHs0YO6VFK/k49q4esDQlBJQObkRPBaCo4W9EJxTSsGi6MMcRYBYfAmDaPSxc
         bJuzKH3orZDe4WoxBXR5dflZNklcZKzjlfpYxvbHPHWGVtu8MCKqiuzJpl3WueHbvHTk
         ZA31l6KtIqYJ4nqK/CTXtj6o/Lqcb0AxArvwG1LnXzQytfFA+4i+SADiCtJGl7eEjQwK
         kEdCnHkcUJYAgYxtJtvE94cMuJ1NPPgIO5PhvYkTsDjma1n2v3HHt/cltIt3IJg492CI
         PIhw==
X-Gm-Message-State: AOJu0Yy403nYtqMm5BABrCFTtVpmoobfMWClxLXMGLMCOjpe+UUKEsKf
	vtsUBUZ2GYiomzgyBTBsOsdIjEckQCxDlzOYB4F/qMgp4iNZTBwtCIZLS9IaNRYNK+WLyH3hsTX
	uBd/FtrfqQtC3jFv6k/lAAap87KS+fchbgqfjpiduc/1HdgiV/g6vENFsL+maOcWQdefkFJEJ08
	H4n/k9XFCm8DsiTMKYb2Or/rna0BY=
X-Google-Smtp-Source: AGHT+IExOZz1Z2TVdN7GjX0FUXmtnqVOe21aRrldS+w2mVLrX5mY2ehpluj7y+hggk27plygJiyZMfu4uQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2b0e:b0:dc6:5396:c0d4 with SMTP id
 fi14-20020a0569022b0e00b00dc65396c0d4mr4063669ybb.1.1713261403081; Tue, 16
 Apr 2024 02:56:43 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:52 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-2-tabba@google.com>
Subject: [PATCH v2 01/47] KVM: arm64: Allocate per-cpu memory for the host
 fpsimd state in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Allocate a per-cpu fpsimd_state to store the host's state when in
protected mode. Since the host_fpsimd_state pointer has been
excluded from kvm_vcpu_arch, no memory has been allocated to
store it in protected mode, and its value hasn't been set.

Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
 3 files changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 82b3d62538a6..20c3f6e13b99 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 }
 
 void pkvm_hyp_vm_table_init(void *tbl);
+void pkvm_host_fpsimd_state_init(void);
 
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		   unsigned long pgd_hva);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 26dd9a20ad6e..16ccb69e6479 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,6 +18,14 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
+/*
+ * Host FPSIMD state. Written to when the guest accesses its own FPSIMD state,
+ * and read when the guest state is live and we need to switch back to the host.
+ *
+ * Only valid when guest_owns_fp_regs() is true.
+ */
+DEFINE_PER_CPU(struct user_fpsimd_state, host_fpsimd_state);
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
@@ -247,6 +255,16 @@ void pkvm_hyp_vm_table_init(void *tbl)
 	vm_table = tbl;
 }
 
+void pkvm_host_fpsimd_state_init(void)
+{
+	unsigned long i;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		per_cpu_ptr(&kvm_host_data, i)->fpsimd_state =
+			per_cpu_ptr(&host_fpsimd_state, i);
+	}
+}
+
 /*
  * Return the hyp vm structure corresponding to the handle.
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index ae00dfa80801..859f22f754d3 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -300,6 +300,7 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
+	pkvm_host_fpsimd_state_init();
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.44.0.683.g7961c838ac-goog

