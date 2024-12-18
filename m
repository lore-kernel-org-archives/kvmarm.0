Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471E21FDE3A
	for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 19:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734550892; cv=none; b=n2DuL8bLfIHyvyKoOdA8BDyC0skOnVJI8N5QDBax+8FCwIDOkqIihP51Kc1KYp4E1AykhD2ImGpRoLqVR6zyHjiHe6xjiciTh5eIK05BhJeaNhE7ClIqlNLGdiLYr7Fm14lZsiudKr7/pUqk+ZMv1D38dmtSIinQZX+bV4am8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734550892; c=relaxed/simple;
	bh=uIq+BBI5a9d3kwdVkRR5DiS/O//XXFMVqp1OznIY4UA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LQplMFsQ7Vd88zCx6GV4Bz353tm9id8EvFGCLQfy/WJOavjejNxTCLazb0hOPocbm43Z0mrZU3A/zjhWRLnhwTEUOcWjc8cmi42MldwRKC9/2H9aHt+lU/LpZ2e1pQObwKJsOJBBTE0nrsuP10BZMz/Ap8+B3urlZ/5fxXbTw4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMZJptgZ; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMZJptgZ"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d3ff30b566so6976667a12.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Dec 2024 11:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734550889; x=1735155689; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDPUkbv296iWYan9Z5++FJBPBOfCRdoKnkMuk2JBHhs=;
        b=vMZJptgZFfF+4s1aZG6YneclW8iYOzLBoVCQSjQ4FOQVqyUiqF9IkmtIBlbQJJ3G2E
         ssNsjn7N2ji6Athv1uyQ65eKNOeuaL5kULWM7lUzfI8F2YCbm04BQnk4iBcEd1JZswAy
         LS1gtRYhiMwFMdmW0Y7DF6pOyKZMoHdCKw1vrQctW0Yh58JJZ1OEUpGJ3fvG4kFamsE5
         vmfTiF0Y9vEQvqWiJGPBWvVkeQUURDyH5hWajz03UhJBONrQjGgvPLjVVRbmTJM2XNgP
         fBUGaRTaeQQLBqAW5TYwL9q8CsrZc9u8KuQRaSENHpiTwEmIGqKjFPiYQ9I8x5nttMRq
         qhJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734550889; x=1735155689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDPUkbv296iWYan9Z5++FJBPBOfCRdoKnkMuk2JBHhs=;
        b=IFzeb+M61YovvxtKEp0VlnLNEoi3+Bz185+DRsJAp/ZKDTLNUKHHF7dDJRJO5nbrMO
         7tfqU5RY9s3pNkUyLifYGmjQKXY1KRKkSnaJJuJoS485OB7nsdK4Rl3BkJwS3q3UWfoG
         gPg2XBJFLzaA52JMCcu6LwABDd9fKA26PL76Y4f82lC3qLNaew5rxQrGO2qpwRf4Yr0k
         jiiMlUd7sN9rhMJsQrLRZPLjPF8aDX2dTH6HKw9vIPl4FBzpSVKQWYfBJD7Ef2tn27ew
         Lgf80DG6OurOESbolv8YuoDXiq34pKlXA2OWRXZ7HW4WUGf+GxKYPcq60ptcGrLWVpX7
         4XAw==
X-Forwarded-Encrypted: i=1; AJvYcCWs0Zyz8Pj9oTURMUcY+dRKMBnZ4rKkxwSNUFxV5WS0CKho+dhOSTLkURX5jF5AOseqRkAEoxM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx9cjEFc5/hCl0NO8wptv0MiJHde+d8SizB0GuLaPmxZySmavr4
	Nsa5f1/qq5vNXkuAoWlKenxmmKdYdvpjazHSc/imwG4sJnDBGr/NXWnu6FOXzpcZLeqqPG8xsip
	nY+N5dg==
X-Google-Smtp-Source: AGHT+IE7/e9KoTrxRJDGtgOfqDEtYC47rptGi8yOrodHJhAQ85i/v+sfJS1qFdI61ia7HmO/sjzRCdIREpzo
X-Received: from edb1.prod.google.com ([2002:a05:6402:2381:b0:5d0:2a58:40c4])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:524d:b0:5d0:d183:cc05
 with SMTP id 4fb4d7f45d1cf-5d7ee3a2948mr4239362a12.5.1734550888759; Wed, 18
 Dec 2024 11:41:28 -0800 (PST)
Date: Wed, 18 Dec 2024 19:40:53 +0000
In-Reply-To: <20241218194059.3670226-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241218194059.3670226-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241218194059.3670226-13-qperret@google.com>
Subject: [PATCH v4 12/18] KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Introduce a new hypercall allowing the host to relax the stage-2
permissions of mappings in a non-protected guest page-table. It will be
used later once we start allowing RO memslots and dirty logging.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 20 ++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 23 +++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 0b6c4d325134..66ee8542dcc9 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -67,6 +67,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index e6d080b71779..181aec2d5bc1 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -42,6 +42,7 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
+int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3c3a27c985a2..287e4ee93ef2 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -264,6 +264,25 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, gfn, host_ctxt, 1);
+	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 2);
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
+	ret = __pkvm_host_relax_perms_guest(gfn, hyp_vcpu, prot);
+out:
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -475,6 +494,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
+	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 30243b7922f1..aa8e0408aebb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1488,3 +1488,26 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 
 	return ret;
 }
+
+int __pkvm_host_relax_perms_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	u64 phys;
+	int ret;
+
+	if (prot & ~KVM_PGTABLE_PROT_RWX)
+		return -EINVAL;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = __check_host_shared_guest(vm, &phys, ipa);
+	if (!ret)
+		ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
+
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.1.613.gc27f4b7a9f-goog

