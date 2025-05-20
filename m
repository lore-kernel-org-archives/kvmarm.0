Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3850268C62
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731198; cv=none; b=UNLq3j8BDxdXQntOqR59lk2egyA4+f2Cci/ynBhCYE1dE7M7xRMP9ZHDVRSmzdKfqN0HCZPsf/YjqJZOQf4qO6XvuBj/PbcPCKsJ6nDuJxkze7WAnYlNIMiwJLass87tMrHxilV6dbIIABzzS/geeg6+8QBn8TVcflsEAz+dLOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731198; c=relaxed/simple;
	bh=hPOMBWnOUvxfs71h6DqG8XcRcD6839MahtJxJVD2WVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O4vi2aolD46E0kSrILvE610+LHGjbflD+hdoqOwOXFCYGiSeFpfWdwTV1/cxKARPgRWHYnURlyUQ6FZM80/lmNQU5fWu+ZM0WuWly2EtzT5dP+ynVVdkIU+NYBD/6jJAwYoitLADSSexsj8MthilxfDPPtZE+TmtzS9IhQ4nAgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rNcC34wg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rNcC34wg"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43d007b2c79so42103405e9.2
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731195; x=1748335995; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iaiebv1iUlPjNsuMmhJjesUK4sbc8xArY8P1OHZ/a4c=;
        b=rNcC34wgtddG+L/DW98Ak61DVvvNELAleu3CLlE+Cuc7yU9W+/+ArOBXi4Gr56DfIz
         fGpgYasjJEouQ1iUCZa2pS1xSz0VT7rg+sWB9aTzcFr12gJkCrD2C4LQHECG0KK6VZUF
         uVJ87/H2d/Q0KxQyh/wdG74dH8HzIfx/kEbzJaYayeM1crL1LLePWqdCmxbi5SRFrOdZ
         dNX8LYsatLePBY/432O2idOh/lCdNlcIjdteCIDD4LQuiFJdDNKUtJsWMs9QV4R1grvh
         ARzcmMi60ITFhHqTcDDWPoud1wBcgy2Z8Cmb1DijY6xOxmwZC09oNWNwslZ1YGyUbsur
         t9uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731195; x=1748335995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iaiebv1iUlPjNsuMmhJjesUK4sbc8xArY8P1OHZ/a4c=;
        b=mUmJMWIr74H7zqmLNXxFEqaBzeJ0oWi5vX5BJlUK0K4LF+DDUoT+JAIFlpUuoOMB/0
         3T7S/NrWJmzb3xBEiijpfT1G2ID+MF6gPE/JimtV4uNGjzxdRWMRLWEl2EJ+fdUt3uO+
         U6Z6CTLCsYo2RXZ2W7B4risDg/i2yOI6UPVvoF9X8kv6kdnJuIGHEmVRVYd2vAUvwiMq
         b2kHHRQTVwrplSGVapIqGTbAYkMGiVAe9nlLxH6g7bCWUymMEzt9zPi82HYbX0ACS9iZ
         mWQoyd+30AVft1yVNCm7NBfMORGlOFfgNw5YfLpsjDeyRvSkP1dDwWk+oMu/pi4sVdrc
         48qg==
X-Forwarded-Encrypted: i=1; AJvYcCVQpi4ynfgSpty0fie9qAtrtVqgZcPmu7Tn5H6ROHdPZbGWQ2sVRoqtNQuGL8z2SpqkYefZt80=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyxmkW3muYFoxAAV7OFWL0Ful3yyYfyN6V+cQr+woUxDtSdMeX
	iU/3Qktx+lGd9DZAHx9qSPdgSwJpqIYatboSDcvQUDi1O7VLXRaOEab93qMf2bkgLaGnhakw94n
	qBDo0nyPhLtvr/FEluMlSaQ==
X-Google-Smtp-Source: AGHT+IHpkZxdcW0elwcmz1T5vd4Wk49F8B5i3CFYJRUb7n4RGyA8tbVGoOAC7m8rZnfR1snVQ+54871TJKr2vkjF
X-Received: from wmqb3.prod.google.com ([2002:a05:600c:4e03:b0:43d:1ef1:b314])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:468f:b0:440:6a37:be09 with SMTP id 5b1f17b1804b1-442fd6312f8mr169931545e9.16.1747731195203;
 Tue, 20 May 2025 01:53:15 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:59 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-9-vdonnefort@google.com>
Subject: [PATCH v5 08/10] KVM: arm64: Add a range to pkvm_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

In preparation for supporting stage-2 huge mappings for np-guest, add a
nr_pages member for pkvm_mappings to allow EL1 to track the size of the
stage-2 mapping.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index da75d41c948c..ea58282f59bb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -173,6 +173,7 @@ struct pkvm_mapping {
 	struct rb_node node;
 	u64 gfn;
 	u64 pfn;
+	u64 nr_pages;
 	u64 __subtree_last;	/* Internal member for interval tree */
 };
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8a1a2faf66a8..b1a65f50c02a 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -264,7 +264,7 @@ static u64 __pkvm_mapping_start(struct pkvm_mapping *m)
 
 static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
 {
-	return (m->gfn + 1) * PAGE_SIZE - 1;
+	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
 }
 
 INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
@@ -305,7 +305,8 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 		return 0;
 
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			return ret;
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
@@ -335,16 +336,32 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		return -EINVAL;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, 1, prot);
-	if (ret) {
-		/* Is the gfn already mapped due to a racing vCPU? */
-		if (ret == -EPERM)
+
+	/*
+	 * Calling stage2_map() on top of existing mappings is either happening because of a race
+	 * with another vCPU, or because we're changing between page and block mappings. As per
+	 * user_mem_abort(), same-size permission faults are handled in the relax_perms() path.
+	 */
+	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, addr + size - 1);
+	if (mapping) {
+		if (size == (mapping->nr_pages * PAGE_SIZE))
 			return -EAGAIN;
+
+		/* Remove _any_ pkvm_mapping overlapping with the range, bigger or smaller. */
+		ret = __pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
+		if (ret)
+			return ret;
+		mapping = NULL;
 	}
 
+	ret = kvm_call_hyp_nvhe(__pkvm_host_share_guest, pfn, gfn, size / PAGE_SIZE, prot);
+	if (WARN_ON(ret))
+		return ret;
+
 	swap(mapping, cache->mapping);
 	mapping->gfn = gfn;
 	mapping->pfn = pfn;
+	mapping->nr_pages = size / PAGE_SIZE;
 	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
 
 	return ret;
@@ -366,7 +383,8 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
-		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
+					mapping->nr_pages);
 		if (WARN_ON(ret))
 			break;
 	}
@@ -381,7 +399,8 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
-		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn), PAGE_SIZE);
+		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
+					  PAGE_SIZE * mapping->nr_pages);
 
 	return 0;
 }
@@ -396,7 +415,7 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
-					   1, mkold);
+					   mapping->nr_pages, mkold);
 
 	return young;
 }
-- 
2.49.0.1143.g0be31eac6b-goog

