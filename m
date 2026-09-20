Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D7847207B
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933043; cv=none; b=vDwxZE6JaomrU4IKA7sLVLOd/uCcHYEWNYEJ4C6o6qWbXmTaNnGP43qHcO8+4PoRyfiyaDl+oXc8vhWQ9KwDVbE9QG3gS6jQ090u/yTQdm43JxopTGX1qGJq2m9khHkwDUkRRBP7EJdXU8E2O4KHQtsmLJGw3cW6rLeYoWGtcMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933043; c=relaxed/simple;
	bh=wgzzxsy58BvqCqX/ilqt4T5Q9dkczW+R9c2r7pwHm7M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyLfB5/xL0zeQ6w/AAKf4sngxnnbrbKEE7PJMv56oTF/Ic+ZVXZcZvVaPO+ehkNum8t4+L2WQO6NTW99yPVmZOJVNqCKWDTSaxKhBaOMTKkbQju8o/h/yVNa3lwmSQmDD2hD2D9v2+kqLDRgESZ18t14Stmf7bhTnl8/7BsEb7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=TgOnHAXp; arc=none smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="TgOnHAXp"
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-8961cca9193so28158727b3.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933039; x=1790537839; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0WQSV2M4dYwT0nemuMW5I3vbKfQKNkPtdhJ2W+zZzFM=;
        b=TgOnHAXpBZhzDRWsKIFKrL3NIh3JCwWKOimNgpS9rMz0YYnf9rkqtnTugfCJXpKSja
         X8wMkF0HkyCoorvnXB1XJRIK6OUlBHuaRR/RAnHVtjxUQA55XMs2+66hhEeIs4K8sCx6
         ab5vBi86lkzZBBVivW67913MJlsL7l236FWZ7s85bFJVhCRxpW12/wREsrlhMYhr5cJu
         YEhrw4gcCsJPooRCX3E2+raNzV+dyS9Qz7u4AqzVokH4pFUIt4/ssKe7hbKFd1rY0iMD
         HH3rLJgNqA/yGHJPNJ04CgDsgBOLUL3CV4VOVk4iQF7zU6xnTUybNI13/Yt7bpLhlrWC
         7z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933039; x=1790537839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0WQSV2M4dYwT0nemuMW5I3vbKfQKNkPtdhJ2W+zZzFM=;
        b=QSvJ3H/6dpEMYsJovivZzJG2iflWZiKRMZQ2a2Patfv18qMKdTuSOlkqifE2hFS29O
         o0AjTL9s57W/W7lsKGC9b4LPnLyqPKweJQM8YdYRO2R3cq2qijp2j8ZcWoEltMbCfQ9k
         dNgz/SCMUekFIc+bN0099tMOegvalTTO5cFcX97lf72lPvv55HBR6wlQHXKuO3jWROQB
         D/kYLYBRH9XGZik7e9oXX2tJhtkF8yrZxPT7toaKh+/BhgT1LrDaVZ1FzS4SK9a/y597
         VnetQrTOvLjYuerQslKkC4RYPZKdRDBDOILkjOhaPss0URA7b4tC6bcNGHAoDu+ory2+
         VF7w==
X-Forwarded-Encrypted: i=1; AKwUvBztE7K3fQ+oTt8DhW8giFN+q9WrQGOFp9gLQKJ/KPcG6OQ1S78y7YrXrYS339gEWgEd994kW78=@lists.linux.dev
X-Gm-Message-State: AFuF++lK6/g3WJG9oTsRKuWA84U+HqFzI1NjhMx4dvvndj6VIJtawAzf
	y7pnaYbVTI+HP1+DpU3tcBcvXSCNJbaG6yRr+xwK6i2k14C4gzgs/bmmQYYQx4kauN0=
X-Gm-Gg: AYBFou0QoYl5tSlCMZkIC85kC0nrDeqMYonIs+FYSR8C9NqwTfvqFrn5+ZjzGIh8CFU
	4T1RIBmW4Q+en76QvfwTiC2r0bwk4PEthscMaDkbpcXXYCSvEb0vjiXoJJOxiwcqRlZCElkzkL6
	iSELr3aVSYdDsOgUyNzGCMZbmhsrdQYJdd5h4gRKRNWS5EfufLr0l8YhMCc+qSr/2qHm0YSfNMv
	XpU55dqEdE27iMiQkjBoctVUxqhjCCXvyu8Puyo64DlJQVI+KFm6KtAJzmM0ar7PRVOdS1mc7eY
	K3cIAO51bR1BZnm12NstW/GBPxT/4BXmePXMUfmiDEpaF9e91LYB6v/zDc8NJKbT8vtXYjMJj4o
	CzpzBDER8vPQ/JatEnrZBMr62hpxzpFIB9w4FMpzJFRVSU90qNZZSeyWYmvXPHw9bOTCU/IXkq3
	849bjQTrLsaQ5YFJWk/gB4aK2y540i+zDNH6WLzqMZokPYsLTqCNit8RGb8Ac23sXmLmpMgA+7z
	dyL7dZ39G1/polK2zkpolBDmtlpBuWNgikmOm/uKWiXWc9atWcgoUZpygAPkJ7uD9hLhDDdz7kf
	5vTCNEXREiEaMocLHxA=
X-Received: by 2002:a05:690c:e1ca:20b0:854:9062:73ae with SMTP id 00721157ae682-89736b3f795mr32929267b3.33.1789933039155;
        Sun, 20 Sep 2026 12:37:19 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a48d99122sm18294247b3.48.2026.09.20.12.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:17 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 04/46] x86/mm/ident_map: Add force_pte to support 4K PTE identity mappings
Date: Sun, 20 Sep 2026 15:36:08 -0400
Message-ID: <20260920193650.3373435-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend kernel_ident_mapping_init() with ident_pte_init() and a force_pte
flag in struct x86_mapping_info so callers can request 4K PTE leaf
mappings instead of 2M PMD or 1G PUD leaves.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/x86/include/asm/init.h |  3 +-
 arch/x86/mm/ident_map.c     | 72 ++++++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 01ccdd168df0..d9caed494e7d 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -6,10 +6,11 @@ struct x86_mapping_info {
 	void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
 	void (*free_pgt_page)(void *, void *); /* free buf for page table */
 	void *context;			 /* context for alloc_pgt_page */
-	unsigned long page_flag;	 /* page flag for PMD or PUD entry */
+	unsigned long page_flag;	 /* page flag for PTE, PMD or PUD entry */
 	unsigned long offset;		 /* ident mapping offset */
 	bool direct_gbpages;		 /* PUD level 1GB page support */
 	unsigned long kernpg_flag;	 /* kernel pagetable flag override */
+	bool force_pte;			 /* force 4K PTE mappings */
 };
 
 int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
index 5a15bffe6574..83013513ba94 100644
--- a/arch/x86/mm/ident_map.c
+++ b/arch/x86/mm/ident_map.c
@@ -77,24 +77,73 @@ void kernel_ident_mapping_free(struct x86_mapping_info *info, pgd_t *pgd)
 	info->free_pgt_page(pgd, info->context);
 }
 
-static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
-			   unsigned long addr, unsigned long end)
+static int ident_pte_init(struct x86_mapping_info *info, pte_t *pte_page,
+			  unsigned long addr, unsigned long end)
 {
-	addr &= PMD_MASK;
-	for (; addr < end; addr += PMD_SIZE) {
+	addr &= PAGE_MASK;
+	for (; addr < end; addr += PAGE_SIZE) {
+		pte_t *pte = pte_page + pte_index(addr);
+
+		if (pte_present(*pte))
+			continue;
+
+		set_pte(pte, __pte(((addr - info->offset) | info->page_flag) & ~_PAGE_PSE));
+	}
+
+	return 0;
+}
+
+static int ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
+			  unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	int result;
+
+	for (; addr < end; addr = next) {
 		pmd_t *pmd = pmd_page + pmd_index(addr);
+		pte_t *pte;
 
-		if (pmd_present(*pmd))
+		next = pmd_addr_end(addr, end);
+
+		if (!info->force_pte) {
+			if (pmd_present(*pmd))
+				continue;
+
+			set_pmd(pmd, __pmd(((addr & PMD_MASK) - info->offset) | info->page_flag));
 			continue;
+		}
 
-		set_pmd(pmd, __pmd((addr - info->offset) | info->page_flag));
+		/* if this is already a 2MB page, this portion is already mapped */
+		if (pmd_leaf(*pmd))
+			continue;
+
+		if (pmd_present(*pmd)) {
+			pte = pte_offset_kernel(pmd, 0);
+			result = ident_pte_init(info, pte, addr, next);
+			if (result)
+				return result;
+			continue;
+		}
+
+		pte = (pte_t *)info->alloc_pgt_page(info->context);
+		if (!pte)
+			return -ENOMEM;
+
+		result = ident_pte_init(info, pte, addr, next);
+		if (result)
+			return result;
+
+		set_pmd(pmd, __pmd(__pa(pte) | info->kernpg_flag));
 	}
+
+	return 0;
 }
 
 static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			  unsigned long addr, unsigned long end)
 {
 	unsigned long next;
+	int result;
 
 	for (; addr < end; addr = next) {
 		pud_t *pud = pud_page + pud_index(addr);
@@ -108,7 +157,7 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 			continue;
 
 		/* Is using a gbpage allowed? */
-		use_gbpage = info->direct_gbpages;
+		use_gbpage = info->direct_gbpages && !info->force_pte;
 
 		/* Don't use gbpage if it maps more than the requested region. */
 		/* at the beginning: */
@@ -129,13 +178,17 @@ static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
 
 		if (pud_present(*pud)) {
 			pmd = pmd_offset(pud, 0);
-			ident_pmd_init(info, pmd, addr, next);
+			result = ident_pmd_init(info, pmd, addr, next);
+			if (result)
+				return result;
 			continue;
 		}
 		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
 		if (!pmd)
 			return -ENOMEM;
-		ident_pmd_init(info, pmd, addr, next);
+		result = ident_pmd_init(info, pmd, addr, next);
+		if (result)
+			return result;
 		set_pud(pud, __pud(__pa(pmd) | info->kernpg_flag));
 	}
 
@@ -189,6 +242,7 @@ int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
 
 	/* Filter out unsupported __PAGE_KERNEL_* bits: */
 	info->kernpg_flag &= __default_kernel_pte_mask;
+	info->page_flag &= __default_kernel_pte_mask;
 
 	for (; addr < end; addr = next) {
 		pgd_t *pgd = pgd_page + pgd_index(addr);
-- 
2.55.0.1082.g2b9226bbc0-goog

