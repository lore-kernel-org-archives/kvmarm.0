Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D7C1E261C
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222290; cv=none; b=W9H1Vl+ewnke3UxvJHQSC15NhRzQMEq7dly8/PgQF85ObFUrA+a19YzZjWMJGFniUlQwLVO17d8wtrGTLwtg5WNdTb7G6viAKDHKQ+cPWqeOgUhBGZxtkq/rJKpVz6iqOCI5Ak6xA1LBSQR1D7j4vKG3dfd2ihCAF93ysYzHDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222290; c=relaxed/simple;
	bh=v51mhVbTFIEkY4CoyYzRXFRDHL8biEV8+73kWC1df90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pK+0Xjo5Uu1G8vqvQC1T/8flyeRDFME3Bpc67JjKsGbpL8SrueCD66F47sSnxAEz9IQ/W/JCkokLQrb/6CpX4znNSJpeTcEPB8tvoB5LwxGSTxrLNl/S7yz+5RkIiAP48YjezleP/bKMofWV4RDvzpHxU0l3gqsX/DJEv5NSOYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfhGrq1j; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfhGrq1j"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d0bde5e90fso3722521a12.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222287; x=1733827087; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9JsvIEZXCS7Jr+kmsJzau1fLfSngv5TQOi1bKyxyJ0=;
        b=SfhGrq1j18S35ruYFKgU5jPCVwu8i0Vnlwc5GBsBsYv0B5h5UW42Uenzk2c6b9Md7U
         lSKB6O1+pLksTuRgZ8/KmTIfrBE1RfVRkhM/rq7VNwOSjcl2gnblR+4xUDkObWDS2IQ+
         xRC3mW54nyma13pKs9UiydwKD02GZMpKjV1TQNVkGpiEu2ySJZ3Q1zQUfjIZtI/hCmBh
         Ljbhmg0xwYzxchN5HrIS4kQKvDqzxIUS/iFuF++ZA91DOPJMiJ+VrzZ2swOeZ1TbGwEB
         HpbNA6iwPysjfNfYA/6tIkq6+zK4C8Sm4NI8QB0yJfbXEZvAZ9Tl25QmfAyDThiUhXA7
         dlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222287; x=1733827087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I9JsvIEZXCS7Jr+kmsJzau1fLfSngv5TQOi1bKyxyJ0=;
        b=DGQQQA4EbogZozvd45dHcWREYL/ctotes0iW4KMRIwO9my76j2YU9BFPmK9NMOWs9O
         nlvOVh7zG8dBTlirmIA6y3mLJQHZqCGIraWmyzerbsckqWnoZ4GmTT4UHUjp+IdjJD4M
         9nZmRoP5SztGmEj5FDVf56ucclLZWAV6UGgEixLtgptBANJp0smT3sl+un/AmESpAyhR
         LOdNYglEx3EM7hIFVh9D80UP/iOfu6TCCHRrAoi1yrwZDd69YrVDtiPfcweQ73oy+kiT
         ZD41GRWmcu/76pUtwy/kbR4/F3suataHahUWvElVcoRYrqePW6al0x50e+3LenmZpmWW
         9WOA==
X-Forwarded-Encrypted: i=1; AJvYcCXBBR+w7dyFOxygGWLvMZZsdONhDaSj+1l9YXPZAlPKa/Ajc65Djpip8bkTXai2ehR1mt50lHs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzfudSTMZJyz83kmYZuzQy5ZTUq/8jKBx1wj0zyvvOGu2KEaE6
	MXAJ9y9Za7lr3rhPbQ2/Q6vojj2EHTvCEoOgq0XFus3bBddcHYfWN768BJ4z1qhduv+KtYuEC8b
	AlX3wOw==
X-Google-Smtp-Source: AGHT+IFdWegGcOuq4VNlCrIIkQlpyo4Z++Lp+kcClHAhjJ/QKpJll2AcCbmRcGxxqa+FPKwZaF2FsSqM5zPQ
X-Received: from edsw18.prod.google.com ([2002:aa7:da52:0:b0:5d0:6d5c:d4e4])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1ecf:b0:5d0:b4ea:9743
 with SMTP id 4fb4d7f45d1cf-5d10cb57048mr1964875a12.8.1733222287044; Tue, 03
 Dec 2024 02:38:07 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:31 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-15-qperret@google.com>
Subject: [PATCH v2 14/18] KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 25 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 ++++++++++++++
 4 files changed, 46 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 4d7d20ea03df..cb676017d591 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -69,6 +69,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 8658b5932473..554ce31882e6 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -43,6 +43,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum k
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3feaf2119e51..67cb6e284180 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -309,6 +309,30 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
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
+	hyp_vm = get_pkvm_hyp_vm(handle);
+	if (!hyp_vm)
+		goto out;
+	if (pkvm_hyp_vm_is_protected(hyp_vm))
+		goto put_hyp_vm;
+
+	ret = __pkvm_host_test_clear_young_guest(gfn, mkold, hyp_vm);
+put_hyp_vm:
+	put_pkvm_hyp_vm(hyp_vm);
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -522,6 +546,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__pkvm_host_relax_guest_perms),
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
+	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 89312d7cde2a..0e064a7ed7c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1522,3 +1522,22 @@ int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 
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
+	ret = __check_host_unshare_guest(vm, &phys, ipa);
+	if (!ret)
+		ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.0.338.g60cca15819-goog

