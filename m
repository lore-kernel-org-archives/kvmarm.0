Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9B01E47D9
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222292; cv=none; b=V9Jtx1+xjJ5/Uj9BiCxNrUx2wnLWzJQcLbralNYxKA6L1r4PHTP8l2Y3tPuDc2JpdeKX9PdbXvqu9JN0c8V47IsP38qLT0+zXsAVkrjlfwVAad9K9KnWSEPWKHpcARjIW5PtiH2v/qXUOTAD6YaE+2FdEBW3YBV6RmQfNgRnGZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222292; c=relaxed/simple;
	bh=6OXhtXz+jkyWJorAsOieiOmrQijISKvstuW/2+G4Ad4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A8PBbXOp3wFygAfWRIJeenX2bZxNLg9XI2ocsjtv7AWDhmG8jCHbrtG7BVMilqK09QKtldgQUwalbOVj64t2etg9yX+UmBar6tnJgjBPqzZqdaAukxrxOS0brCyvP1EVFgkvtm3QeJJRG/W6XmfAKTyHZeiljBXJsNXwqZIKMIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZT/GVlOt; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZT/GVlOt"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-aa5462eb32aso188512266b.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222289; x=1733827089; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EgRs0HkjSCh59IZhf7+TrvM3b16VAv7mDc29HHStdgo=;
        b=ZT/GVlOtPHKmi8LST1b56utX7PkXqsTen3+W8UHEk6TiHnbKOQj4iMhnw/73i0wTSy
         h3gd8ieMJrybcrNkZ9i+P0KPKLPvNGbSwM1mZ+hxERXDydbDcLkOAPuhRBPMBAI46tSW
         LqByh1bduzh9XpbDtk7PoTl3vyrd/TEVY/NYU5kL3+pNYN8j7VyrtWRY+2IYj8B043/d
         ReN5cKreXxIcyGnI5h8P+2wi6a7zs+lmN6V5Z6y4xIkurbD/Md7FbxDJS4D6RpVajsAG
         wQHtmtdbKSwn598DMQEkVR3BF4dNNpeX/8rHZYcW9qowujmrF4ABQ0ITTqtbhI1jdpEn
         FMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222289; x=1733827089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgRs0HkjSCh59IZhf7+TrvM3b16VAv7mDc29HHStdgo=;
        b=XeLmsQUjJP2el2bpkFGnWqsXtkH9OdoyijZRBuN3ng3mxstiBraWv4YcbJAiOQtguC
         R/90jBsdx4KPHYn/SqMiHTkpJ1yTrcJxG12DhrlLp6Ot1RCGFoxJHwvsMnOyJ5t0cAjP
         L6HJGyiBObXa5gsQBh5TWCZerhQIzIDT5IhW3SFApbbfiMqrViWbmkbFz0C9pGEBYZJd
         PJwlcGyJG/COiNC65S00An8y7oY8iqAq/dztkY+3wvwOV3Vy0totVYsoyDAbqfcYqcBz
         veq1y4k2vI2rAk7KnDaVflVJ8VDbYRx+0DiwYk4b9DkDO6TO1NPmI48uzDl0CuXplaW4
         LHlA==
X-Forwarded-Encrypted: i=1; AJvYcCV9NmcuPNTzYyDi19q7/tQHZ+fvyh+jdQ5kOzLQcOBmMMNWiCgpOtqdrcqSx7oTsEBdT9YAlqY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4HK4D1zVRSvbapfIzcjKcC+hY0GfnPTbl/Dpb0uSBAfvbaLV9
	rhedks/we6rVzdouyv0EMsl6lty8y2QxtAPULLTSxD4qnPeNDOza9dcVzTG+P/QWlaBQgCOSriG
	lN+Wc2g==
X-Google-Smtp-Source: AGHT+IGowzrGpSC0FLSlw3WKUPPBp1evDjYqr9UC0mO5wZAxbWJofoXIaJzqMrV6fp0J8VpSR7nkc7pw29FT
X-Received: from edql9.prod.google.com ([2002:aa7:c309:0:b0:5cf:ad96:abb])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5243:b0:5d0:bf5e:eb8
 with SMTP id 4fb4d7f45d1cf-5d10cb800fcmr1839841a12.23.1733222289249; Tue, 03
 Dec 2024 02:38:09 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:32 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-16-qperret@google.com>
Subject: [PATCH v2 15/18] KVM: arm64: Introduce __pkvm_host_mkyoung_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Plumb the kvm_pgtable_stage2_mkyoung() callback into pKVM for
non-protected guests. It will be called later from the fault handling
path.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 19 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 20 +++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index cb676017d591..6178e12a0dbc 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -70,6 +70,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 554ce31882e6..3ae0c3ecff48 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -44,6 +44,7 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
 int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *vm);
+int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 67cb6e284180..de0012a75827 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -333,6 +333,24 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	cpu_reg(host_ctxt, 1) = ret;
 }
 
+static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, gfn, host_ctxt, 1);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int ret = -EINVAL;
+
+	if (!is_protected_kvm_enabled())
+		goto out;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		goto out;
+
+	ret = __pkvm_host_mkyoung_guest(gfn, hyp_vcpu);
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -547,6 +565,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_relax_guest_perms),
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
 	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
+	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0e064a7ed7c4..7605bd7f80b5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1541,3 +1541,23 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, bool mkold, struct pkvm_hyp_vm *
 
 	return ret;
 }
+
+int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_unshare_guest(vm, &phys, ipa);
+	if (!ret)
+		kvm_pgtable_stage2_mkyoung(&vm->pgt, ipa, 0);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.0.338.g60cca15819-goog

