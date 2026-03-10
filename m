Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F97D2949E0
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146994; cv=none; b=coDXiQYJqZwFRup05+etpTbeLyqsTu5Ll7bn4WCW2WNcAYJsaok9XK+COpukUbf8GocWUfM/U+SeQ9W8fxOoSSeIM2U3bpcinlFcDZ36wsmQehJhmAaWEPYCxhm1jgIEdGRZ7mJZMGtQRI7S/mWilN0DdNK1dhuOeYCPxL1H/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146994; c=relaxed/simple;
	bh=4RNc/OGsbdz6eLCOaogz9AGsi/fOhXZQXST7Qa4L1Qg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W/YmRooVc87p9LMDUTM1XXroGTy7Q2MbyokCjqrGbHkCubGo57wMENtYRRDv+mGfJNs0LqWLiDqKZXhAsKKaV4E+pUhSur68uN8y8TyhZt+JXdY0g7MSaobW4PQo0ytDZYfUuSpRaTDkOmJuu6jUATq4jyNfEvZ0SWA/NRQWEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TyH/5zfd; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TyH/5zfd"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439c4bde453so4868514f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146990; x=1773751790; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DKVeba1O2GNqI9y6nMRgrPtXZ5F94kglcm0NO/0FYK4=;
        b=TyH/5zfduQ6XR1mOi/y4qJGQoEnSVtha6muc4ka54V5yHYxO2uYxeqnOwWUmhEEfO/
         eVlk/rOQVrmfJwDZ5hM3MxlgrhSR03CJMt2q6oQR28n4dZNAA6nlW6uXNgaWTMCQxsQz
         EQaag8q0cOH30wEmn0sig9LcBqHOYJ3O0j5BTZQz2ZvGVim/XcJF4GDWEPmLp9P4BclH
         o93CGjWehxCCOK9M/wh2WTH2nJSByaFkj4GBmU9AcML1eDpqBbExG6jNVkesHXh5xp4b
         9mnNXaqDQyVi155CkJBp+R+hkh4Sz7Sw3ZJ2Fmc/s+Wj+UesDEO6nsQwaxQ57oPntGYd
         1bew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146990; x=1773751790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DKVeba1O2GNqI9y6nMRgrPtXZ5F94kglcm0NO/0FYK4=;
        b=Y1RbxaYZWavDJR/lPOyreF+OZqQhU2gCpa8otpKJegz1G7vuKgnAgNT8RHEJFWmv98
         r2zBNcTwEL5tk1EFa6C/fxMCFcipn7MSBAFMsBdFrTFdwC71HfPD2ElOcTp+xZH9oWMy
         wzMHs7coY1DNGYB5qdf4rbi5Zu5DpJ6kHljHS0lXLuko2TJjPJ2rjOBaAnpcgj145r5g
         +sRRXFHIwSUF8W05Fmk14IE9CNfXOH/PFaji4rvSkwQlD4ywnl2ePp3nRE4tu7C6c/WZ
         UuVgME31U+/fFcWG8zrlkKzQNSGV6HbuPdMP4g0PGijvnM9O1Mei59lA16DMsnS02ND0
         yYWw==
X-Forwarded-Encrypted: i=1; AJvYcCUpvIxAstLY7gZiN2tsuEVREc0dV+MAa3ta0TOzzdeB1oWEnBMtCxJFeiIGamLw3nkBkgEcAkM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWmq9vfODKvKRswfjkAnEx21SKBtLPEiKsiwsmp5L+LTicwdia
	w1wsi0z+ElwfOIMWCQEYVJs/dwPbe0A4W2K9OHyW1Ex/Vgo43ykgalzqk2uNTdVe3D3CmUdUVnS
	WM1UP5lz/TK49twkI0HMPzWV+XK+WzQ==
X-Received: from wrmz10.prod.google.com ([2002:adf:e54a:0:b0:439:b120:9eeb])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:608:b0:439:ad90:389e with SMTP id ffacd0b85a97d-439da8861bdmr24755811f8f.36.1773146990477;
 Tue, 10 Mar 2026 05:49:50 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:26 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-8-sebastianene@google.com>
Subject: [PATCH 07/14] KVM: arm64: Restrict host access to the ITS tables
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Setup shadow structures for ITS indirect tables held in
the GITS_BASER<n> registers.
Make the last level of the Device Table and vPE Table
inacessible to the host.
In a direct layout configuration, donate the table to
the hypervisor since the software is not expected to
program them directly.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 143 ++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 4a3ccc90a1a9..865a5d6353ed 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -141,6 +141,145 @@ static struct pkvm_protected_reg *get_region(phys_addr_t dev_addr)
 	return NULL;
 }
 
+static int pkvm_host_unmap_last_level(void *shadow, size_t num_pages, u32 psz)
+{
+	u64 *table = shadow;
+	int ret, i, end = (num_pages << PAGE_SHIFT) / sizeof(table);
+	phys_addr_t table_addr;
+
+	for (i = 0; i < end; i++) {
+		if (!(table[i] & GITS_BASER_VALID))
+			continue;
+
+		table_addr = table[i] & PHYS_MASK;
+		ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);
+		if (ret)
+			goto err_donate;
+	}
+
+	return 0;
+err_donate:
+	for (i = i - 1; i >= 0; i--) {
+		if (!(table[i] & GITS_BASER_VALID))
+			continue;
+
+		table_addr = table[i] & PHYS_MASK;
+		__pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT);
+	}
+	return ret;
+}
+
+static int pkvm_share_shadow_table(void *shadow, u64 nr_pages)
+{
+	u64 i, ret, start_pfn = hyp_virt_to_pfn(shadow);
+
+	for (i = 0; i < nr_pages; i++) {
+		ret = __pkvm_host_share_hyp(start_pfn + i);
+		if (ret)
+			goto unshare;
+	}
+
+	ret = hyp_pin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
+	if (ret)
+		goto unshare;
+
+	return ret;
+unshare:
+	for (i = i - 1; i >= 0; i--)
+		__pkvm_host_unshare_hyp(start_pfn + i);
+	return ret;
+}
+
+static void pkvm_unshare_shadow_table(void *shadow, u64 nr_pages)
+{
+	u64 i, start_pfn = hyp_virt_to_pfn(shadow);
+
+	hyp_unpin_shared_mem(shadow, shadow + (nr_pages << PAGE_SHIFT));
+
+	for (i = 0; i < nr_pages; i++)
+		WARN_ON(__pkvm_host_unshare_hyp(start_pfn + i));
+}
+
+static void pkvm_host_map_last_level(void *shadow, size_t num_pages, u32 psz)
+{
+	u64 *table;
+	int i, end = (num_pages << PAGE_SHIFT) / sizeof(table);
+	phys_addr_t table_addr;
+
+	for (i = 0; i < end; i++) {
+		if (!(table[i] & GITS_BASER_VALID))
+			continue;
+
+		table_addr = table[i] & ~GITS_BASER_VALID;
+		WARN_ON(__pkvm_hyp_donate_host(hyp_phys_to_pfn(table_addr), psz >> PAGE_SHIFT));
+	}
+}
+
+static int pkvm_setup_its_shadow_baser(struct its_shadow_tables *shadow)
+{
+	int i, ret;
+	u64 baser_val, num_pages, type;
+	void *base, *host_base;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		baser_val = shadow->tables[i].val;
+		if (!(baser_val & GITS_BASER_VALID))
+			continue;
+
+		base = kern_hyp_va(shadow->tables[i].base);
+		num_pages = (1 << shadow->tables[i].order);
+
+		ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(base), num_pages);
+		if (ret)
+			goto err_donate;
+
+		if (baser_val & GITS_BASER_INDIRECT) {
+			host_base = kern_hyp_va(shadow->tables[i].shadow);
+			ret = pkvm_share_shadow_table(host_base, num_pages);
+			if (ret)
+				goto err_with_donation;
+
+			type = GITS_BASER_TYPE(baser_val);
+			if (type == GITS_BASER_TYPE_COLLECTION)
+				continue;
+
+			ret = pkvm_host_unmap_last_level(base, num_pages,
+							 shadow->tables[i].psz);
+			if (ret)
+				goto err_with_share;
+		}
+	}
+
+	return 0;
+err_with_share:
+	pkvm_unshare_shadow_table(host_base, num_pages);
+err_with_donation:
+	__pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages);
+err_donate:
+	for (i = i - 1; i >= 0; i--) {
+		baser_val = shadow->tables[i].val;
+		if (!(baser_val & GITS_BASER_VALID))
+			continue;
+
+		base = kern_hyp_va(shadow->tables[i].base);
+		num_pages = (1 << shadow->tables[i].order);
+
+		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(base), num_pages));
+		if (baser_val & GITS_BASER_INDIRECT) {
+			host_base = kern_hyp_va(shadow->tables[i].shadow);
+			pkvm_unshare_shadow_table(host_base, num_pages);
+
+			type = GITS_BASER_TYPE(baser_val);
+			if (type == GITS_BASER_TYPE_COLLECTION)
+				continue;
+
+			pkvm_host_map_last_level(base, num_pages, shadow->tables[i].psz);
+		}
+	}
+
+	return ret;
+}
+
 static int pkvm_setup_its_shadow_cmdq(struct its_shadow_tables *shadow)
 {
 	int ret, i, num_pages;
@@ -205,6 +344,10 @@ int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
 	if (ret)
 		goto err_with_shadow;
 
+	ret = pkvm_setup_its_shadow_baser(shadow);
+	if (ret)
+		goto err_with_shadow;
+
 	its_reg->priv = priv_state;
 
 	hyp_spin_lock_init(&priv_state->its_lock);
-- 
2.53.0.473.g4a7958ca14-goog

