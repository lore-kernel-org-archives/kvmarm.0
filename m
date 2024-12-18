Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D263B1FECA6
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550896; cv=none; b=eeGGOq2RpivM/RbMyxmob3NJ0UHPb5dQ+YyeQymjGG9vED6zPNUbdXhK1UBnLY16l32yrHpsCn5ROpDDw9Yak5HqEecRdx9caVqo3jnT3/I7sTJvL8sAD6I0tNVlul8vxnp2nYT7AOrnoc1JKBeBGlsuL12vCrSABLSRSBuvHyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550896; c=relaxed/simple;
	bh=0O0/9IxU6uN7FbHeQC6ErZUTjaSrbyp8oeoxx5FdXI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AH2MkcIs8Oy/Ena6NCAaitoz+LC+q6WP7trAZ0Si4UwDYbfZ59C7Ks2an26OYcW/XvnJHVS8ianHZlXbFd8pu9GBOGFjD9/e/j8WY9tGJmBjVS2WfGj+mejLjZiCm+fGjuK4B7Y0VtacgtAoVZYyXuWqAlynCwon0qnuxw7NFUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1I7V0IW1; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1I7V0IW1"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa68952272bso658105766b.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550893; x=1735155693; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FA16CpWSjw4J8hytyuNewMCyl42cawlROSmZZIo9OEU=;
        b=1I7V0IW1/WxKJbND4MeG6d2xLXM2lRtNTTsSiNd2mtuUcWMsvW8W1MCCjZiHl2XXKT
         eBxiSKhVPzBnURdFCkQcIP5cGT/5Tm5SZKOkkZkyagZChfbcw5p/zdxwcSOrxCD5HpOn
         RkzBiPmCaQhtKPIR2OQFzjKo5otQQy6ODtWMqgB272bAf3HyRgoMn0ymkmTwGjxR4BFy
         wY1dN4A224mGAYMW8p68ocEQ6KDgT5cDfKeI2IVnXhuyJ1zOqrIwL+cAOJwRHFGDPFK7
         Up0wR6PyqYLG6yBe7rqDoviEtU5+35Bj32hyBrZG9fJiQhdOr0FAzh+g8mqz5PkR3jql
         tnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550893; x=1735155693;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FA16CpWSjw4J8hytyuNewMCyl42cawlROSmZZIo9OEU=;
        b=LIWdkAs7FG6vrk4WpO04zTGm0VL5Q7aWaCOI2izRiI2+VYhxntNxXvgXpMVtd+nmoh
         2e+lLhYrN+hTG5NZZ73BcBct64TIlWeNkn6zuN+xgTCzYKLeby9y0S1n+JPHBL1dxB7V
         X9FennVa2JSfW8kiWvKTMfQ7LkJwC2SyVuk/trwHCdgXuT2KUdkYbKmAoJbyhLETVrT/
         U7TIuozjjZY9BDNTCLmLdYl33F38gPML9rYERkzyc3qfPgoEfo5ac3m5JXjg7w1rJwFU
         0Y+ILks3NXww87tFsgMHZgwTmQ559Dy1837h1IZNHehkzWmDBTZ5JJiFM7OS0x3r/rOk
         mtaw==
X-Forwarded-Encrypted: i=1; AJvYcCU7JC4YzftGhpyjgGV2LletMSriNvuqye2CwMnbh2o5bQcjAuL/+j7JFHrLoIAhsTOZXsP35+o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2b4jewMI823/70J02ypowPByzI9E1/7FKhBRqRwRYSEKX2gKR
	hfPQfVAhgOpRZFM/6XUxVwEvY0YPf0JEmoQ4zipvuNd0ZggRwJBIEA/6eIdbawt6pkAoNjk8TwS
	1qDZfww==
X-Google-Smtp-Source: AGHT+IG8EXE2W+9QfjAAeb4en8etMIJHTOmKwloyUtafN8OWJRimmwomZbfFp5X5CMVOuBoShjXizcAXD0pD
X-Received: from edbfi23.prod.google.com ([2002:a05:6402:5517:b0:5d4:8b0:1df0])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:3297:b0:aa6:66bc:8788
 with SMTP id a640c23a62f3a-aabf48cf088mr348264866b.45.1734550893196; Wed, 18
 Dec 2024 11:41:33 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:55 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-15-qperret@google.com>
Subject: [PATCH v4 14/18] KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Plumb the kvm_stage2_test_clear_young() callback into pKVM for
non-protected guest. It will be later be called from MMU notifiers.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 22 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 ++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 8663a588cf34..4f97155d6323 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -69,6 +69,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 0bbfb0e1734c..74bd6c72fff2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -44,6 +44,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 98d317735107..616e172a9c48 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -303,6 +303,27 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 	cpu_reg(host_ctxt, 1) = ret;
 }
 
+static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+	DECLARE_REG(bool, mkold, host_ctxt, 3);
+	struct pkvm_hyp_vm *hyp_vm;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vm = get_np_pkvm_hyp_vm(handle);
+	if (!hyp_vm)
+		goto out;
+
+	ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
+	put_pkvm_hyp_vm(hyp_vm);
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -516,6 +537,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
+	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 94e4251b5077..0e42c3baaf4b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1530,3 +1530,22 @@ int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 
 	return ret;
 }
+
+int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm)
+{
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_shared_guest(vm, &phys, ipa);
+	if (!ret)
+		ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.1.613.gc27f4b7a9f-goog

