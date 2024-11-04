Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F971BC07E
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727159; cv=none; b=aO2rGuDIfdJhRgS0O4zfQnort7PaeABV1WMPf0B8r5ugVv3H31wZ9YNK1/OuuG7lzeFxYhuraxr7QrgVgRrJgJYLHhktBDXja8kvqyuim6Q6oQaSpZdZo1XvPOU1o76pwP5ZwkEBKNrvQiVrUtK4LWnM6ORae5ks7LXSw+eGhiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727159; c=relaxed/simple;
	bh=yxI6nOj/2BlS35z5zeuNbWN5QGACUR0d82SG3HMgbro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aT2lXEAiyN5B/Wf630yqM/7gEDNSUrhZiEW/D6KIH1UaU2PS6QuHSNcL4jEuPU7sxIGBwm/tVNFDPw9W+C5CgHF1Vjqjj/CyYlXC2bJ20a7YD5C6YJBwpMeox3AiSjw7dODIRhXwlxCZNNulUrblyEKUt55JeTb+SYpK0k17fR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KRYP10Q7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KRYP10Q7"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea258fe4b6so83812767b3.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Nov 2024 05:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730727155; x=1731331955; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VRegJK0d/KTMFa1b8xxTA9sCjP756MDWGX2tZ8RiT/M=;
        b=KRYP10Q76KxrzQE4J6/Cgg5Eviu8O/96RVUDZN7WZqdHlQlLpmosZsZ0nu6UKICZyT
         RVa7a3WAf6VRyRrxfZjmb6cdw6o80mFwkR3GM7d7Lnzg621hv8/GihI5PNq0e1HPe4wQ
         5NhzpAoqH09FMGBMPLJB2qLmYoFVuK8VmKOiuPkTxd4FkVVAYDREpNqJf2JDR7Ix0imz
         QZxD5FSSJAVJvwUKv8Mnc3XO+bEz3FoDdgSlMkYXVPMR2ulkq5p1ynm1FT7aTpZA3WYY
         UAXH3Batgp/T0FrbfjAk3CiT5DgJBRbvaTvS7LTOv7Oq7iHmdwcYb2aEQXXl5hf54fMy
         QO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730727155; x=1731331955;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VRegJK0d/KTMFa1b8xxTA9sCjP756MDWGX2tZ8RiT/M=;
        b=mZNUtUFyKvwgmpqOmITokaeyl+XSrsB2gaFF5gIbvwnSP1lhLvtbUpt7NTvxkeXSvZ
         KBka2miJ9Y0UjiW9l35mR9AEH5DMmSJtZdIma2ZL41YBQMagRxqlNrg4M7gZUkqI/Umn
         I0R+K7bTaMfrYRYbmcJulgRd4yPw85XRrut+Ng848J4MIK5wSEP7isDNCrBvGm8yUObE
         1cjNDpRijjGDV7l+XDaEGBZ5jDAXT/yYj0NIszI2DvY3eueM5H0F2IOfpIS0VWUpx9ej
         /PIuLQeGVwSfa6d9GgB8UZNtU4jSBKxj/9ube85E0hbOGz9TfMCU4fAGkQNcLRSl5vAy
         Crsw==
X-Forwarded-Encrypted: i=1; AJvYcCXKtvthwUUJG4L+ltQgX14jWnFheM1cTorvGoUYTN4kBYd14m5hT5X3WMQchR50FHOEvXkp+7k=@lists.linux.dev
X-Gm-Message-State: AOJu0YysjvJL6gmN6FJnBIQNJUJ6x2SF10Y0PIoYMESVnFJoq7PFr8vL
	laQ5Dh2dfGBU2Z+/tPpA+oFFnfkL1TabvgufkkvLOFKOg0Z4YpUoutuYua+S/AuzjMZHNxVWLjs
	BctujyA==
X-Google-Smtp-Source: AGHT+IGR8bsfJ02p9vHy+seXY+BmxTKO7YUK2HiE8eFkkm9wUjhjecldaQfmnnOt9C+IS5sr/2xmgAJlbcZ8
X-Received: from big-boi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:129])
 (user=qperret job=sendgmr) by 2002:a25:c710:0:b0:e30:d61e:b110 with SMTP id
 3f1490d57ef6-e33025662cdmr10816276.5.1730727154895; Mon, 04 Nov 2024 05:32:34
 -0800 (PST)
Date: Mon,  4 Nov 2024 13:31:57 +0000
In-Reply-To: <20241104133204.85208-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241104133204.85208-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241104133204.85208-12-qperret@google.com>
Subject: [PATCH 11/18] KVM: arm64: Introduce __pkvm_host_unshare_guest()
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
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 24 ++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 78 +++++++++++++++++++
 5 files changed, 109 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b69390108c5a..e67efee936b6 100644
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
index 32bdf6b27958..68bbef69d99a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -242,6 +242,29 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
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
@@ -459,6 +482,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
 	HANDLE_FUNC(__pkvm_host_share_guest),
+	HANDLE_FUNC(__pkvm_host_unshare_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index a69d7212b64c..f7476a29e1a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1413,3 +1413,81 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 
 	return ret;
 }
+
+static int guest_get_valid_pte(struct pkvm_hyp_vm *vm, u64 *phys, u64 ipa, u8 order, kvm_pte_t *pte)
+{
+	size_t size = PAGE_SIZE << order;
+	s8 level;
+
+	if (order && size != PMD_SIZE)
+		return -EINVAL;
+
+	WARN_ON(kvm_pgtable_get_leaf(&vm->pgt, ipa, pte, &level));
+
+	if (kvm_granule_size(level) != size)
+		return -E2BIG;
+
+	if (!kvm_pte_valid(*pte))
+		return -ENOENT;
+
+	*phys = kvm_pte_to_phys(*pte);
+
+	return 0;
+}
+
+static int __check_host_unshare_guest(struct pkvm_hyp_vm *vm, u64 *phys, u64 ipa)
+{
+	enum pkvm_page_state state;
+	struct hyp_page *page;
+	kvm_pte_t pte;
+	int ret;
+
+	ret = guest_get_valid_pte(vm, phys, ipa, 0, &pte);
+	if (ret)
+		return ret;
+
+	state = guest_get_page_state(pte, ipa);
+	if (state != PKVM_PAGE_SHARED_BORROWED)
+		return -EPERM;
+
+	ret = range_is_allowed_memory(*phys, *phys + PAGE_SIZE);
+	if (ret)
+		return ret;
+
+	page = hyp_phys_to_page(*phys);
+	if (page->host_state != PKVM_PAGE_SHARED_OWNED)
+		return -EPERM;
+	WARN_ON(!page->host_share_guest_count);
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
2.47.0.163.g1226f6d8fa-goog

