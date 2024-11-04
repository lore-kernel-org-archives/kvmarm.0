Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92101C07DF
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727165; cv=none; b=e4rL/zFMcALAbeeM9ll92Ghcw6eUhQOzdOhvyucnw6CtKtHESgAod4GV0ufsLKaDXEWe0Wb39V1+ghCPUKRBo6ruukiCjvg1LaWG/ryz7C6KJFkuoWBvztN7nANamOyejuwwTKaTsFQ4MiVDaSJ/QNGLCreoVPZRxLbKy15QBUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727165; c=relaxed/simple;
	bh=KJS9XKZhhB+nMuymhZC7deLYta0BV1oHH+TAlmStQT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MEChpq3FFrH1JwW8z8bIXXcfZtiV6BzTzvOFb9kIZ+CBMir/X9rlQvrARbPnw0BRdLDx1i7bdo+pN6A2upZfqbyHPpMN4jJAR21eyaqJfCgS8UzjuMnWWnJhxxXvB01Jdpwbr0J4pNOAnmr5JD3YCKkAS1IOmgPpIR3fHNt8xXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T2bAshFr; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T2bAshFr"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-a9a2593e9e9so282918766b.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727162; x=1731331962; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BjjoLBvOkIdvqHKae2IJzaas4+AMPqzUZpsNH6gOsjs=;
        b=T2bAshFrbwaaDTB7356A2obXJ3iyUJE1JY8VXuPfIrPVERPAYbgD0zOi8L4GJ2+4r5
         hZ/bk8AzG6Sp7mZ96+LaQdW8M2g7T7Hy3oPc2jc4qeilAlCTWng7yVC3MpwXIm84O0qI
         B3eRrSNQrHuPIQmGOM2ZRGRe+zRb2jaf0bHM2jUQcf+/mByvkHoFV3lQ53s6CUC/a/v1
         CKJuXMmV60okFp5vtsJO56lDJLIkYz/0esJRS+ZaNJtmersSwwiEdrM1uday25q8DaVx
         7aUD/QntYdevHriH53T8XJo6exSerf1WnrCP0FOf1/ULsgMLaTEX7d8xfK5VEi4Bll54
         vz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727162; x=1731331962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BjjoLBvOkIdvqHKae2IJzaas4+AMPqzUZpsNH6gOsjs=;
        b=lf8hnSPutIHzzKVBVJs68pgMTUUoe0AV80FFbMbzQDAfR1hGNJ0YQUQ3ppRoS0vA0B
         8K6/oKYBliJ/La/pbJTi/NHMQylFGJK4nLe2Iy58Z3YIFVTr+cF8Rrl4dNq5tVwRXc3U
         mXth0ZxVEJm+otQJ4svplG0/O6zCZELsaEflW2XoldTnx6vXOIZxQBf8ILRGYYCov318
         npB5r/eIHzkGojKnIpLQp1qyCd7eRhcbrtlcAXDvfWpki6AqkwId5/UXF+a1RUZISthL
         gS6RE2EAy7nZ0BR/VP8ouaY3fHMQtcrmd60O7FxfkuqFoDQ15BHEZl16y9N7V+3VvrMo
         BnEg==
X-Forwarded-Encrypted: i=1; AJvYcCVZ+J++KxONW95gv9Ot/TwJnDs5DyizQjyXUcSHSHGTD6Ajt2D4S5FV7sFCO/58Njb5B+16FHc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxb8v2prNjQMwBuB7I0zvoj1F3KiNpLjLDYFvpdvplKTTHV3O+3
	Tt+GybHxZRJFAvBRE6UDcOnehcH34j5JAe3qxoUeL3yy56gbDLTHyrJBJ1tJS0ifgcpe5sklSXT
	KHjXSaQ==
X-Google-Smtp-Source: AGHT+IEbj6NqToXt4e9wVQWd4WMxb63nj/9jGxcZ0csUp26Lka3674D7FmXmXXn3NSLW/560C2CbSgE7ZVUz
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a17:906:ec2:b0:a9a:1e:d858 with SMTP id
 a640c23a62f3a-a9e6582233cmr306266b.11.1730727161943; Mon, 04 Nov 2024
 05:32:41 -0800 (PST)
Date: Mon,  4 Nov 2024 13:32:00 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-15-qperret@google.com>
Subject: [PATCH 14/18] KVM: arm64: Introduce __pkvm_host_test_clear_young_guest()
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
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 21 ++++++++++++++++
 4 files changed, 48 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3f1f0760c375..acb36762e15f 100644
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
index ce33079072c0..21c8a5e74d14 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -307,6 +307,30 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
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
@@ -527,6 +551,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__pkvm_host_relax_guest_perms),
 	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
+	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3a8751175fd5..7c2aca459deb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1537,3 +1537,24 @@ int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 
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
+	if (ret)
+		goto unlock;
+
+	ret = kvm_pgtable_stage2_test_clear_young(&vm->pgt, ipa, PAGE_SIZE, mkold);
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.0.163.g1226f6d8fa-goog

