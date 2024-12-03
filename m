Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2181E3DE6
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222284; cv=none; b=TGf3c5fO+ClZimPu0PE2vEzHegLrsp6CoKUtj7uUPlHDG8vHKcCqjlLPwfO2G2sgci1YdVy4JtSBymSFfBaCvEkP24/O+SCJXbLjfCCwprJD+p9OriLCtIDNxQIE60EK3Lif3W2z8cCeqZkay/A8HODMFrIaUqWvs0tH88PqYY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222284; c=relaxed/simple;
	bh=IWVv8gtkHDdzM15kVyG/PIs80GKtGBvwVU0S6ATUTeg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qiUerimHVN717P0R2N4g0nMVN3N1jpFZmiM5b1vaykSvgD9Zj1IWgmQsmRTtyVQBm0gYRAz4vUavEuCEa2jUfa/8FXtfa7ax+Z90kIeR2Y2u+aBLxaHxT/LtIvYoFrOWUdfU30bh6e0V3/QzvVEb4qrEHLRcAQQc0174cMnFoiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fl29g+IV; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fl29g+IV"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-5d0c64ce365so2795641a12.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222281; x=1733827081; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Smbxsi8PbLTPu6HhJ3ZtrU1gOE8VT3JZi9oskB4fii8=;
        b=Fl29g+IV7eqAVfBLXV506tziwe5j5xCPYjGv7hqpqlZqvvc9Ut2MZoEqB6JNkcjy8x
         0OoGLmtOslXDpUEfF21PrVI4FMMdsktarUE2HQtZCsuPPGETmUoxapG8HXfO1SDzBZ/e
         A7KG5Y5z++WwQwqlKiiSMAMB01IVqAmFSJz+9Da278HQHH1v7EYXRUxDA+ZnmUoOYSvn
         BOihT794mSx921pXqqaN7yf/TIeQfGgQV46QXWXDz9HGn6rukAgr0rXVjK1IIWCM32VX
         vk39cetpucMPpr8yccwPxhtKlVwcnrGYdC+VrXSg9UW5funzUytsjCinG8hzwhe00wun
         JTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222281; x=1733827081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Smbxsi8PbLTPu6HhJ3ZtrU1gOE8VT3JZi9oskB4fii8=;
        b=P6/i1B9HHBgQTWUF95P/VuPpVYqIG0pI45g4K25tc1mvTjBpf6O8mZTe6H87Efo+29
         2L2yydSO08kn+p6xMOwTVOp0FpJMylqowAbh1zxw6Zq6iwlegUOGiMvku7TxaeCdNXdv
         8QJei2ynr7TZDpSWEvMacQN1vsFt9Dg6K4d29Ta2bD4qUlxIeDABBhre5rBMdLu7n0xR
         m/FAAZygIJOeILTCNBUed0UJxGqORqXzzKhDhruwzlP1RZqgkKpxz2aOwHN6pr2lWyQM
         Z+DJcMnWSSzpyUJ5IxPi6rxcImzcchECRIbSVzjh6k3bny2DUzgMIIETIaZIzW20K2CE
         YYrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAZJjZLQIOQl+MxRVTmZO35Mbk0dS7NXCTBK6jsULa0WimHi1mjb2Tt9rD5VT7fvcdNBdomPM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwjHes0ydM2n37wcKz6FdLp/KPmijWky0rtZZkrKYhgJ1RsxSWJ
	SoxFNzj/EwMIbabYiFLZaGmtBNLbFAYl4KVtnI7JJv3E0/x+enR+P06oDzJF1N+kJ54o1yVKbk1
	VXMkv2g==
X-Google-Smtp-Source: AGHT+IFpsely1W9hENzdoh4l+A3Db67CgMYOTTsCiRDVa8ZG99eLdQ3hckne6J6ZI5aiGA5XghWwWkBg4p9o
X-Received: from edql13.prod.google.com ([2002:aa7:c30d:0:b0:5d0:2139:dedd])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4301:b0:5d0:e243:8c57
 with SMTP id 4fb4d7f45d1cf-5d10cb5568dmr1255645a12.9.1733222280831; Tue, 03
 Dec 2024 02:38:00 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:28 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-12-qperret@google.com>
Subject: [PATCH v2 11/18] KVM: arm64: Introduce __pkvm_host_unshare_guest()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In preparation for letting the host unmap pages from non-protected
guests, introduce a new hypercall implementing the host-unshare-guest
transition.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  5 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 24 +++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 67 +++++++++++++++++++
 5 files changed, 98 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 449337f5b2a3..0b6c4d325134 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -66,6 +66,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index a7976e50f556..e528a42ed60e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -40,6 +40,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
+int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
 
 bool addr_is_memory(phys_addr_t phys);
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index be52c5b15e21..5dfc9ece9aa5 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -64,6 +64,11 @@ static inline bool pkvm_hyp_vcpu_is_protected(struct pkvm_hyp_vcpu *hyp_vcpu)
 	return vcpu_is_protected(&hyp_vcpu->vcpu);
 }
 
+static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
+{
+	return kvm_vm_is_protected(&hyp_vm->kvm);
+}
+
 void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d659462fbf5d..04a9053ae1d5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -244,6 +244,29 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  ret;
 }
 
+static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
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
+	ret = __pkvm_host_unshare_guest(gfn, hyp_vm);
+put_hyp_vm:
+	put_pkvm_hyp_vm(hyp_vm);
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
+}
+
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
@@ -454,6 +477,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__pkvm_host_share_guest),
+	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a69d7212b64c..aa27a3e42e5e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1413,3 +1413,70 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 
 	return ret;
 }
+
+static int __check_host_unshare_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ipa)
+{
+	enum pkvm_page_state state;
+	struct hyp_page *page;
+	kvm_pte_t pte;
+	u64 phys;
+	s8 level;
+	int ret;
+
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	if (ret)
+		return ret;
+	if (level != KVM_PGTABLE_LAST_LEVEL)
+		return -E2BIG;
+	if (!kvm_pte_valid(pte))
+		return -ENOENT;
+
+	state = guest_get_page_state(pte, ipa);
+	if (state != PKVM_PAGE_SHARED_BORROWED)
+		return -EPERM;
+
+	phys = kvm_pte_to_phys(pte);
+	ret = range_is_allowed_memory(phys, phys + PAGE_SIZE);
+	if (WARN_ON(ret))
+		return ret;
+
+	page = hyp_phys_to_page(phys);
+	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
+		return -EPERM;
+	if (WARN_ON(!page->host_share_guest_count))
+		return -EINVAL;
+
+	*__phys = phys;
+
+	return 0;
+}
+
+int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm)
+{
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	struct hyp_page *page;
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(hyp_vm);
+
+	ret = __check_host_unshare_guest(hyp_vm, &phys, ipa);
+	if (ret)
+		goto unlock;
+
+	ret = kvm_pgtable_stage2_unmap(&hyp_vm->pgt, ipa, PAGE_SIZE);
+	if (ret)
+		goto unlock;
+
+	page = hyp_phys_to_page(phys);
+	page->host_share_guest_count--;
+	if (!page->host_share_guest_count)
+		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_OWNED));
+
+unlock:
+	guest_unlock_component(hyp_vm);
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.47.0.338.g60cca15819-goog

