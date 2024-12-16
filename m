Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9192E20E035
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371919; cv=none; b=VsPq+khcBYajF74WL7r0Z6+BFKJwpO+Th/pI33E9qxMLvyWt78PbFDNGYemtkPANlHYgHXKBC+PlOyTmhJcLDiPDpGN5EYf9Wq5BqOfYkik4MgSO1El+bMzxrixrfYoDqNYqXzsVoy5Ri2Kbt+uk1Own8eF2ZsT8R4kVHCO6ocM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371919; c=relaxed/simple;
	bh=rcoYPmb/53S8Gvor6OWXTcnIDC6gvecrrUk8ZXPefhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Pvjdk3bjy4e/ealkBFZyQgFh+OYjT50zXDtexJQDaqjiM2E+xV+WxdTvMUjFCAuIHUtjoRNPMwBbBYRaN33nyfdOK69/cf41UHqBu6D4aEG1MDeawD+doVD2o1VxIYbp5p0D6psubIDUN5yf9epV6bBTC9IzPMw4RdWZb4nvvbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4gkS1ZTm; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4gkS1ZTm"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa67f18cb95so477427866b.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371915; x=1734976715; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5r7yCnkAiK5kyLrxO0D/txvshFXcnr6nZkeqCQZICw=;
        b=4gkS1ZTmuYQ5MiIcvY6AIHRee3Ra8BNLUxZbeqOV3j9TPhwP7G3NSB4GpY1WApQpDC
         gFFCdofwR7ieaF9f4M1Y+JhfzcGZLMSM93LikhPNHSCnO6PLI+bxSav8mJA99Sui30N/
         v9VGPfwecb0/BhLcociOFoTwJNhYToPwCXuKhT8abCfFlxztq1veh05iywnQJRotmBLp
         QGzr6kyy3XE/u715UeJSOXqsWxbGbFY4eKQlMUDxomP1hb1Q+0VFc2Z4eTVFZERWNOAn
         RteL+okEMPtZn+38UtEv9k4dJ1hx5A/vcim8it6zHvcQ/4Ksd3bDCQl39XOuBAIm0/aC
         jPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371915; x=1734976715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b5r7yCnkAiK5kyLrxO0D/txvshFXcnr6nZkeqCQZICw=;
        b=jq8w8NbEH+g18RVYOCnR3HYxiDrk1nT8REMYw/Y1aWXesDWVqhbRkykt3GhXi8jA9O
         jMXP7bD+Y1ilTBD61CRPe1KF5F9Vo7h1jGNn+fppVkqlc/Uc/58VAMD69CXC02Y5RCQ9
         L1i+8j9ldsBBpT2E08GM8sn71mxb9L3GNs2TVecw0AJbwFyNe8eiglrL/ATJ/eYjmKL4
         XhRN9TiqLeOGqs5NuFl81WX+LHT6W0Hut0sylAfLFph4fsb48zszHf8d2cvu/quHn4CT
         R/0s1a1UnLbv4sGWepyEp3v7BmDlQ+nlFLVRknhQTyLWZv0nNinCTVuQkskoZHiZbgjX
         7JJw==
X-Forwarded-Encrypted: i=1; AJvYcCWH5CkjtrKez1hXa3CLnoy2Dtg3sWfSpkhUnCS9MkcU6gE8GNQb/uMrO56GWZjC5NXBDwKigX4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs8FxALYIj94qIuM/LTn+dTIC+TqdqzGZ9wrjtUN3p09fWB68v
	xFI5oyI6rLWMEt3UQ9PbdFpLuXYiHtSIThqXyOXyAaVR8gP7irKAmittwMyUHdY9WkM6JMs/xol
	XhJQfgw==
X-Google-Smtp-Source: AGHT+IETu+O3p1iOBFO9EmhBHTULF9iIkYmes1FbMSi6hvoepqbMqPvqpSwnKmEI7JcKZIr1ZyErBddwlhp2
X-Received: from edbek12.prod.google.com ([2002:a05:6402:370c:b0:5d0:225b:ed39])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4584:b0:5d4:5e4:1555
 with SMTP id 4fb4d7f45d1cf-5d63c3200acmr13094867a12.19.1734371915059; Mon, 16
 Dec 2024 09:58:35 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:59 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-15-qperret@google.com>
Subject: [PATCH v3 14/18] KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
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
index fc9fdd5b0a52..b3aaad150b3e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,6 +43,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum k
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

