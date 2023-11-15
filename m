Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B792BCE8
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="znXTvIDe"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-da2b8af7e89so8334915276.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 09:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700068628; x=1700673428; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YQSSCNEgEIVwDuGH6x1IyDnQkcpfK9nBZRdIMr0v9JQ=;
        b=znXTvIDeXfLtOl+w595PHiPKC0eL7ap62hHMXvFZnu3O8hahyw0LtEheIGNsK43KNt
         8sqBCBeYFj4GaPHYB/bFqWj3CJy0uHewhc3FDJr+6BdlNycNRSDctB3nue0SrLzB4Kyz
         Q22dI5G1V35tU6ZWzRijMZDzNL5x/BSM/HMrv3nvCI2nahzt0azme1h1pcFPI6bXf9RO
         Ewyn3HQiCWhx8T6n+2hHZueeq2mz6Axwk4qf+t5GY/9XVeGOX3v5vf9tf39EiUHltcVg
         v7VrB/NjdWvdj7shIIJCjCu3BH/z32OJ5LtrN7jC5qzIG1s411awYjcEEWi0tnMeE/87
         A3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700068628; x=1700673428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YQSSCNEgEIVwDuGH6x1IyDnQkcpfK9nBZRdIMr0v9JQ=;
        b=xACUwJwt1jEFDcohhH6emxeI54xPWJiHckB53di/Da6IEYvJ6NLutbekgoxXaoP3zO
         O1taD6o8th1/1rsrfW3fdsjpFvTIaU9X+exsHxGlTi2Vzit8QCgM9G5B0BOJRHHVk5uV
         4OQe1uXd4e1Jc9JzKNmRWL/0VWE1foEHiy1dt1IcVTVMAgP2bz85/eDSAFGmSebpyYMf
         CNaFeOphlXE41UCHHxG3AGX3U53bn4L/05aLpGfv92SVi21BHGnIrwFd+xbFwXmf8gSn
         Frj5blGjFLwYzivr+38cvsPa/w1Zx3sHH/7H9/aqRB41BrJby7PUcvOx6W/YjKPh6T/z
         mBjw==
X-Gm-Message-State: AOJu0YxIqNXu8GdW35l9RKOMmVyCM71kjnDA1Qtcxly9BkAca8mHAxwK
	1LKGuWGAPYAVwl7NhfeO8Fn9LXwwfZu8T3TwPKg=
X-Google-Smtp-Source: AGHT+IErn3bzCF0DX9XJB6QzS6DBzs7DLSSORQ60b11cbij8ap/mm1M6uedlPRtG3MZC6j1NjkHThkYCWTUAznPoE6k=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:4:b0:d9a:68de:16a1 with SMTP
 id l4-20020a056902000400b00d9a68de16a1mr369425ybh.0.1700068628077; Wed, 15
 Nov 2023 09:17:08 -0800 (PST)
Date: Wed, 15 Nov 2023 17:16:36 +0000
In-Reply-To: <20231115171639.2852644-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231115171639.2852644-2-sebastianene@google.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
Message-ID: <20231115171639.2852644-8-sebastianene@google.com>
Subject: [PATCH v3 06/10] arm64: ptdump: Register a debugfs entry for the host
 stage-2 tables
From: Sebastian Ene <sebastianene@google.com>
To: will@kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com, mark.rutland@arm.com, 
	akpm@linux-foundation.org, maz@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, vdonnefort@google.com, 
	qperret@google.com, smostafa@google.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

Initialize a structures used to keep the state of the host stage-2 ptdump
walker when pKVM is enabled. Create a new debugfs entry for the host
stage-2 pagetables and hook the callbacks invoked when the entry is
accessed. When the debugfs file is opened, allocate memory resources which
will be shared with the hypervisor for saving the pagetable snapshot.
On close release the associated memory and we unshare it from the
hypervisor.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/include/asm/ptdump.h |  12 +++
 arch/arm64/kvm/Kconfig          |  13 +++
 arch/arm64/kvm/arm.c            |   2 +
 arch/arm64/mm/ptdump.c          | 168 ++++++++++++++++++++++++++++++++
 arch/arm64/mm/ptdump_debugfs.c  |   8 +-
 5 files changed, 202 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index 9b2bebfcefbe..de5a5a0c0ecf 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -22,6 +22,7 @@ struct ptdump_info {
 	void (*ptdump_walk)(struct seq_file *s, struct ptdump_info *info);
 	int (*ptdump_prepare_walk)(void *file_priv);
 	void (*ptdump_end_walk)(void *file_priv);
+	size_t				mc_len;
 };
 
 void ptdump_walk(struct seq_file *s, struct ptdump_info *info);
@@ -33,13 +34,24 @@ struct ptdump_info_file_priv {
 #ifdef CONFIG_PTDUMP_DEBUGFS
 #define EFI_RUNTIME_MAP_END	DEFAULT_MAP_WINDOW_64
 void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name);
+void ptdump_debugfs_kvm_register(struct ptdump_info *info, const char *name,
+				 struct dentry *d_entry);
 #else
 static inline void ptdump_debugfs_register(struct ptdump_info *info,
 					   const char *name) { }
+static inline void ptdump_debugfs_kvm_register(struct ptdump_info *info,
+					       const char *name,
+					       struct dentry *d_entry) { }
 #endif
 void ptdump_check_wx(void);
 #endif /* CONFIG_PTDUMP_CORE */
 
+#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
+void ptdump_register_host_stage2(void);
+#else
+static inline void ptdump_register_host_stage2(void) { }
+#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
+
 #ifdef CONFIG_DEBUG_WX
 #define debug_checkwx()	ptdump_check_wx()
 #else
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 83c1e09be42e..cf5b7f06b152 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -71,4 +71,17 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config PTDUMP_STAGE2_DEBUGFS
+	bool "Present the stage-2 pagetables to debugfs"
+	depends on NVHE_EL2_DEBUG && PTDUMP_DEBUGFS && KVM
+	default n
+	help
+	  Say Y here if you want to show the stage-2 kernel pagetables
+	  layout in a debugfs file. This information is only useful for kernel developers
+	  who are working in architecture specific areas of the kernel.
+	  It is probably not a good idea to enable this feature in a production
+	  kernel.
+
+	  If in doubt, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1085..987683650576 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -28,6 +28,7 @@
 
 #include <linux/uaccess.h>
 #include <asm/ptrace.h>
+#include <asm/ptdump.h>
 #include <asm/mman.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
@@ -2592,6 +2593,7 @@ static __init int kvm_arm_init(void)
 	if (err)
 		goto out_subs;
 
+	ptdump_register_host_stage2();
 	kvm_arm_initialised = true;
 
 	return 0;
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index d531e24ea0b2..0b4cb54e43ff 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -24,6 +24,9 @@
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptdump.h>
+#include <asm/kvm_pkvm.h>
+#include <asm/kvm_pgtable.h>
+#include <asm/kvm_host.h>
 
 
 enum address_markers_idx {
@@ -378,6 +381,170 @@ void ptdump_check_wx(void)
 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
 }
 
+#ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
+static struct ptdump_info stage2_kernel_ptdump_info;
+
+static phys_addr_t ptdump_host_pa(void *addr)
+{
+	return __pa(addr);
+}
+
+static void *ptdump_host_va(phys_addr_t phys)
+{
+	return __va(phys);
+}
+
+static size_t stage2_get_pgd_len(void)
+{
+	u64 mmfr0, mmfr1, vtcr;
+	u32 phys_shift = get_kvm_ipa_limit();
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
+	vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
+
+	return kvm_pgtable_stage2_pgd_size(vtcr);
+}
+
+static int stage2_ptdump_prepare_walk(void *file_priv)
+{
+	struct ptdump_info_file_priv *f_priv = file_priv;
+	struct ptdump_info *info = &f_priv->info;
+	struct kvm_pgtable_snapshot *snapshot;
+	int ret, pgd_index, mc_index, pgd_pages_sz;
+	void *page_hva;
+	phys_addr_t pgd;
+
+	snapshot = alloc_pages_exact(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
+	if (!snapshot)
+		return -ENOMEM;
+
+	memset(snapshot, 0, PAGE_SIZE);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, virt_to_pfn(snapshot));
+	if (ret)
+		goto free_snapshot;
+
+	snapshot->pgd_len = stage2_get_pgd_len();
+	pgd_pages_sz = snapshot->pgd_len / PAGE_SIZE;
+	snapshot->pgd_hva = alloc_pages_exact(snapshot->pgd_len,
+					      GFP_KERNEL_ACCOUNT);
+	if (!snapshot->pgd_hva) {
+		ret = -ENOMEM;
+		goto unshare_snapshot;
+	}
+
+	for (pgd_index = 0; pgd_index < pgd_pages_sz; pgd_index++) {
+		page_hva = snapshot->pgd_hva + pgd_index * PAGE_SIZE;
+		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
+					virt_to_pfn(page_hva));
+		if (ret)
+			goto unshare_pgd_pages;
+	}
+
+	for (mc_index = 0; mc_index < info->mc_len; mc_index++) {
+		page_hva = alloc_pages_exact(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
+		if (!page_hva) {
+			ret = -ENOMEM;
+			goto free_memcache_pages;
+		}
+
+		push_hyp_memcache(&snapshot->mc, page_hva, ptdump_host_pa);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
+					virt_to_pfn(page_hva));
+		if (ret) {
+			pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
+			free_pages_exact(page_hva, PAGE_SIZE);
+			goto free_memcache_pages;
+		}
+	}
+
+	ret = kvm_call_hyp_nvhe(__pkvm_copy_host_stage2, snapshot);
+	if (ret)
+		goto free_memcache_pages;
+
+	pgd = (phys_addr_t)snapshot->pgtable.pgd;
+	snapshot->pgtable.pgd = phys_to_virt(pgd);
+	f_priv->file_priv = snapshot;
+	return 0;
+
+free_memcache_pages:
+	page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
+	while (page_hva) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
+					virt_to_pfn(page_hva));
+		WARN_ON(ret);
+		free_pages_exact(page_hva, PAGE_SIZE);
+		page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
+	}
+unshare_pgd_pages:
+	pgd_index = pgd_index - 1;
+	for (; pgd_index >= 0; pgd_index--) {
+		page_hva = snapshot->pgd_hva + pgd_index * PAGE_SIZE;
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
+					virt_to_pfn(page_hva));
+		WARN_ON(ret);
+	}
+	free_pages_exact(snapshot->pgd_hva, snapshot->pgd_len);
+unshare_snapshot:
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
+				  virt_to_pfn(snapshot)));
+free_snapshot:
+	free_pages_exact(snapshot, PAGE_SIZE);
+	f_priv->file_priv = NULL;
+	return ret;
+}
+
+static void stage2_ptdump_end_walk(void *file_priv)
+{
+	struct ptdump_info_file_priv *f_priv = file_priv;
+	struct kvm_pgtable_snapshot *snapshot = f_priv->file_priv;
+	void *page_hva;
+	int pgd_index, ret, pgd_pages_sz;
+
+	if (!snapshot)
+		return;
+
+	page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
+	while (page_hva) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
+					virt_to_pfn(page_hva));
+		WARN_ON(ret);
+		free_pages_exact(page_hva, PAGE_SIZE);
+		page_hva = pop_hyp_memcache(&snapshot->mc, ptdump_host_va);
+	}
+
+	pgd_pages_sz = snapshot->pgd_len / PAGE_SIZE;
+	for (pgd_index = 0; pgd_index < pgd_pages_sz; pgd_index++) {
+		page_hva = snapshot->pgd_hva + pgd_index * PAGE_SIZE;
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
+					virt_to_pfn(page_hva));
+		WARN_ON(ret);
+	}
+
+	free_pages_exact(snapshot->pgd_hva, snapshot->pgd_len);
+	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp,
+				  virt_to_pfn(snapshot)));
+	free_pages_exact(snapshot, PAGE_SIZE);
+	f_priv->file_priv = NULL;
+}
+
+void ptdump_register_host_stage2(void)
+{
+	if (!is_protected_kvm_enabled())
+		return;
+
+	stage2_kernel_ptdump_info = (struct ptdump_info) {
+		.mc_len			= host_s2_pgtable_pages(),
+		.ptdump_prepare_walk	= stage2_ptdump_prepare_walk,
+		.ptdump_end_walk	= stage2_ptdump_end_walk,
+	};
+
+	ptdump_debugfs_kvm_register(&stage2_kernel_ptdump_info,
+				    "host_stage2_page_tables",
+				    kvm_debugfs_dir);
+}
+#endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
+
 static int __init ptdump_init(void)
 {
 	address_markers[PAGE_END_NR].start_address = PAGE_END;
@@ -386,6 +553,7 @@ static int __init ptdump_init(void)
 #endif
 	ptdump_initialize();
 	ptdump_debugfs_register(&kernel_ptdump_info, "kernel_page_tables");
+
 	return 0;
 }
 device_initcall(ptdump_init);
diff --git a/arch/arm64/mm/ptdump_debugfs.c b/arch/arm64/mm/ptdump_debugfs.c
index 3bf5de51e8c3..4821dbef784c 100644
--- a/arch/arm64/mm/ptdump_debugfs.c
+++ b/arch/arm64/mm/ptdump_debugfs.c
@@ -68,5 +68,11 @@ static const struct file_operations ptdump_fops = {
 
 void __init ptdump_debugfs_register(struct ptdump_info *info, const char *name)
 {
-	debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
+	ptdump_debugfs_kvm_register(info, name, NULL);
+}
+
+void ptdump_debugfs_kvm_register(struct ptdump_info *info, const char *name,
+				 struct dentry *d_entry)
+{
+	debugfs_create_file(name, 0400, d_entry, info, &ptdump_fops);
 }
-- 
2.43.0.rc0.421.g78406f8d94-goog

