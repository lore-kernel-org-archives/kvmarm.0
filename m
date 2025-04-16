Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3568F211A38
	for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819754; cv=none; b=KpGxYZkWUR+gWVPd8etRj6yWY6UrvFFxUXsMD7q4w6BDcyVuEb2vymZ2V0yierIVdfY7bCUEKOlPKdPxRyot4fqX5wf73TrNgBw4TLoJwhfUmALL4+i3TT8UEpEVpRbSRuvUQoeGTWaRNiqGUA4EwoN8rHDmo+WvyN3pfpJpngE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819754; c=relaxed/simple;
	bh=f7rKsYLxVEDkcwBjeJizVeYDa7FJpyKUWA8MZrDtyWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SG1ZfHSOvuFrq1h92FJdZKv4cTpudE3wyiTGfzP4T/VpIzlNwNNBugOBMc7kySvXDie4wLlxoJsWTj4inQCUxJvGfcE8AlNEsPdvA9vDIHjsW3+TTplWk1VUmgP9GAAW5zhaxNIe5xnCg11twcMGrprejLo0GpsmExXSJQUQsco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TjiTKbZt; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TjiTKbZt"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5e5cc488f27so5489170a12.3
        for <kvmarm@lists.linux.dev>; Wed, 16 Apr 2025 09:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744819750; x=1745424550; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bDcOKwVW00nNGG4NyR6ISobI0N8ZjJsPjdepkGhedWo=;
        b=TjiTKbZtxkrDdGdrd0rNfNf+uef/yOooNIgV3bR5V68zdwks+xtRP9OoYK6jLiHx/b
         eDEFO1Yvs78CiykJWMx+yl0fIf0/bDttA+AI7lT+gEtRH88WHNOoY1EdP8T/YxkDyYTf
         fQXyUgQId/ZN18WFhUC40B42maEzs6+i0awDe1lyO8zxXnrBHUHZkbCf23+ke/25egRH
         CjJL/UuCS3RximMzy2PV/KxVKWuWaG1wBkBepJJB4PnltGTLBIKIl1MV/qS+na4XVyLi
         8+DAlYENHYVuaiQCI81uBa5LNFwe5FvWvi2evYm39eqzufx3mhJGFa9SuchMzAC2PY9c
         GUDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744819750; x=1745424550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bDcOKwVW00nNGG4NyR6ISobI0N8ZjJsPjdepkGhedWo=;
        b=lq9cZ7TPPYK47GBoE7+lZoCjgtZmGdUpnmSPu5U+PtCsH76XTUr4VZFwuS1dGEtovh
         ZC0EUImgF6bSQ+NHpILiolIKylZwI+tyhxtyCYV2jfGnODChdPvMjz34k90N6veA4DaO
         iMjH41rERSfSvy2fufxxZ0ym/rEitP1XrtyqmO/YRHWrUzVwbCAGOWTz4S8UxDFIMBU5
         aXkNaH1I8fvdKoyh8DM8gHeZKykvLVc/nTnTmyDGNHY54CkAb3til7OvatWuVGiE1/FS
         qQl754KBwrmRIU734NB6duPCvNkDChDGUQ++CdiY3aKwgwcLRZ1ZZQs2gkDqxcY6RBgM
         hqug==
X-Forwarded-Encrypted: i=1; AJvYcCVZT1FwwXjL7NhKJLtq2yKg/PWYDB1Vb2qeX6qSPZj2hHZcizVPyZR2qdQpEo5lTMx1KebeM/o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDjRlQzOamNPsUVGwEElHDFgho0BOuFKJZb6gj/uwrdGx65PgN
	0kTpWSkUNTX9XAdgRS3b+jQ0Ir9jmXUIsPseKs3likw67DVusaX0GK6CO9ffe+KOmQVUon/mNYy
	zSKT/JA==
X-Google-Smtp-Source: AGHT+IH44M1oUP6au2Aa62Uwe3W7YocYkvgokTJLiLufvbBovB2uSIcZxzrsLQa0fm+cjgs2UKBEThpNgR1E
X-Received: from eduf26.prod.google.com ([2002:a05:6402:5a:b0:5ed:19b4:3ce])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27ce:b0:5f3:5863:64b5
 with SMTP id 4fb4d7f45d1cf-5f4b747b2c6mr2174230a12.12.1744819750663; Wed, 16
 Apr 2025 09:09:10 -0700 (PDT)
Date: Wed, 16 Apr 2025 16:08:59 +0000
In-Reply-To: <20250416160900.3078417-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250416160900.3078417-1-qperret@google.com>
X-Mailer: git-send-email 2.49.0.604.gff1f9ca942-goog
Message-ID: <20250416160900.3078417-4-qperret@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Selftest for pKVM transitions
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We have recently found a bug [1] in the pKVM memory ownership
transitions by code inspection, but it could have been caught with a
test.

Introduce a boot-time selftest exercising all the known pKVM memory
transitions and importantly checks the rejection of illegal transitions.

The new test is hidden behind a new Kconfig option separate from
CONFIG_EL2_NVHE_DEBUG on purpose as that has side effects on the
transition checks ([1] doesn't reproduce with EL2 debug enabled).

[1] https://lore.kernel.org/kvmarm/20241128154406.602875-1-qperret@google.com/

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   6 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 111 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   2 +
 3 files changed, 119 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ea0a704da9b8..535722cd8417 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -67,4 +67,10 @@ static __always_inline void __load_host_stage2(void)
 	else
 		write_sysreg(0, vttbr_el2);
 }
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+void pkvm_ownership_selftest(void);
+#else
+static inline void pkvm_ownership_selftest(void) { }
+#endif
 #endif /* __KVM_NVHE_MEM_PROTECT__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4a0f98943577..1912cc22c987 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -1092,3 +1092,114 @@ int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 
 	return 0;
 }
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+struct pkvm_expected_state {
+	enum pkvm_page_state host;
+	enum pkvm_page_state hyp;
+};
+
+static struct pkvm_expected_state selftest_state;
+static struct hyp_page *selftest_page;
+
+static void assert_page_state(void)
+{
+	void *virt = hyp_page_to_virt(selftest_page);
+	u64 size = PAGE_SIZE << selftest_page->order;
+	u64 phys = hyp_virt_to_phys(virt);
+
+	host_lock_component();
+	WARN_ON(__host_check_page_state_range(phys, size, selftest_state.host));
+	host_unlock_component();
+
+	hyp_lock_component();
+	WARN_ON(__hyp_check_page_state_range(phys, size, selftest_state.hyp));
+	hyp_unlock_component();
+}
+
+#define assert_transition_res(res, fn, ...)		\
+	do {						\
+		WARN_ON(fn(__VA_ARGS__) != res);	\
+		assert_page_state();			\
+	} while (0)
+
+void pkvm_ownership_selftest(void)
+{
+	void *virt = hyp_alloc_pages(&host_s2_pool, 0);
+	u64 phys, size, pfn;
+
+	WARN_ON(!virt);
+	selftest_page = hyp_virt_to_page(virt);
+	selftest_page->refcount = 0;
+
+	size = PAGE_SIZE << selftest_page->order;
+	phys = hyp_virt_to_phys(virt);
+	pfn = hyp_phys_to_pfn(phys);
+
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.hyp = PKVM_PAGE_OWNED;
+	assert_page_state();
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
+
+	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
+	selftest_state.hyp = PKVM_PAGE_SHARED_BORROWED;
+	assert_transition_res(0,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+
+	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
+	assert_transition_res(0,	hyp_pin_shared_mem, virt, virt + size);
+	hyp_unpin_shared_mem(virt, virt + size);
+	WARN_ON(hyp_page_count(virt) != 1);
+	assert_transition_res(-EBUSY,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+
+	hyp_unpin_shared_mem(virt, virt + size);
+	assert_page_state();
+	WARN_ON(hyp_page_count(virt));
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_unshare_hyp, pfn);
+
+	selftest_state.host = PKVM_PAGE_SHARED_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_donate_hyp, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_share_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_hyp, pfn);
+	assert_transition_res(-EPERM,	__pkvm_hyp_donate_host, pfn, 1);
+	assert_transition_res(-EPERM,	hyp_pin_shared_mem, virt, virt + size);
+
+	selftest_state.host = PKVM_PAGE_OWNED;
+	selftest_state.hyp = PKVM_NOPAGE;
+	assert_transition_res(0,	__pkvm_host_unshare_ffa, pfn, 1);
+	assert_transition_res(-EPERM,	__pkvm_host_unshare_ffa, pfn, 1);
+
+	selftest_state.host = PKVM_NOPAGE;
+	selftest_state.hyp = PKVM_PAGE_OWNED;
+	assert_transition_res(0,	__pkvm_host_donate_hyp, pfn, 1);
+
+	selftest_page->refcount = 1;
+	hyp_put_page(&host_s2_pool, virt);
+}
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 2050bb5a6de7..47294134cf1b 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -312,6 +312,8 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
+
+	pkvm_ownership_selftest();
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.49.0.604.gff1f9ca942-goog

