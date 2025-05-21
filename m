Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E5326FDA2
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831881; cv=none; b=IPhRFB0q6Vz4DNRPk3kBjpfgn150K7BX0aNwpHm0P22LaYxN+DGHXVZyDMnsFlq457+Dum/+Nwm9liad52xcvscHuAI7Uppd7MtnYmzzUztbSP5XFzC9a7ZILX1+i1uRi0lpTpAunLmeIl4CcaYgDsDJ7gRlAzKXRcpC+TqfCFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831881; c=relaxed/simple;
	bh=m9dI9Rg8h/c091GpkdF/1r+aT4iwGTUctJ0aDf1/BoU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UAPCz3hS3Tt0keSS1o5uQu+JddNAp1N4HLK0EEDpg4SIefDbGdvKnbnV8Kk3ZmDm/jQGk96yT+0vCPkORwfG1fiCQ3+YXu5O0piKgGl8cFbI+FKbi6bf55X2IHSRNRnuP9k0ACZqgPKb9V1Lnl421wB6jLZaBMEUTCVRYUO/JWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jLmzSHHQ; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jLmzSHHQ"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a3591c42d4so1961606f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831878; x=1748436678; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=THRS6RUOhVQKyz2pzkS3iWtym7smEtX3sb7fjdkvEcQ=;
        b=jLmzSHHQkpQdHC8pEgtjBm6GReQkQYqqaehaQA1MORRaZH7crK9eset51X4LUbiRs2
         RYYKYJkEgUnr6VgJg7K7bjpEeoQGGYCmi66ADtFsbxzPyaxqnKEfVd5bH5JiSRhPk0dR
         44iUcSwghI/Lyu0l2G4XESbdiZNpeJ9sPcjI2J92ocl/sN9Oy1AFIJVB96/gGO2w1ymT
         ywtOr9aSQnwDLzcmVaW9cDxLkNVWOT1r8CAzo+FqRMP5yVXJ9uQAGuhFMgdXp38mhvL3
         Jg+w7veYpNehZ0A2Ir/k71dKhlBcoPtf+b+X8I9tRxc4XK06FCOX0m11oNc9PxoN8OKj
         i0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831878; x=1748436678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=THRS6RUOhVQKyz2pzkS3iWtym7smEtX3sb7fjdkvEcQ=;
        b=IO0bSAESF/a7vg8EoeAr74tpCfRpoGIm6RtOJc4gd8AwTKtLUbusvMlJ3S0WubOx+z
         fcP8ZAGQHW85Yj6HFL/4cSoLbEnHW9QM0X0NcTVE3n4UpIWk0o0SNRPj9F1yPyecKJEc
         DdTfvtz9ViX4AgRyqJggo+3oLsTpr8/W6dKuwJdQn47enOFF347JnNfXP16udEtzhbPT
         C6z49k8W4fEvEpjzt9nB2SgSTOpKdhjBaHW+RYd99IQAmeAXIbfbPJ++0N8UoWe/pPSv
         aTVAueB3gLpn6l8SL63zIryUhiRphUuRbMiT6gHOWcdsjeFFg5yq7L5fQHUkg7JG7IoO
         1l2w==
X-Forwarded-Encrypted: i=1; AJvYcCWmkQ4Pdh//tm998JtYBguNwUiVEqOTYH6a5UqgV/X3WkribVT0Yokt7Co2EcR24YcY0qUbOrw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy7Rk50USNpqQuebShXXM5uG8O+reNd5wvIzE9Im8wKZ8PFOam
	JmsibitM6CiwgnCvhUt3DN5y+ShEgSOfOQ+UpHo0BJQaj7jqQIT91l7L7rWvj49lOIdzGGZe38e
	EI9qUjWNtheChuXLlhgv00A==
X-Google-Smtp-Source: AGHT+IGhYVIBRuADQr6WRByKd7PpHl5cm15NxpBtNtkX8ms0Vg3sLjAj+oF4iS4GtuyYvGveuHPK8YSVEQ+prz7R
X-Received: from wmbhc24.prod.google.com ([2002:a05:600c:8718:b0:441:bf4e:899c])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4304:b0:3a3:6ae4:6615 with SMTP id ffacd0b85a97d-3a36ae46750mr10498053f8f.13.1747831878332;
 Wed, 21 May 2025 05:51:18 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:32 +0100
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250521124834.1070650-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-9-vdonnefort@google.com>
Subject: [PATCH v6 08/10] KVM: arm64: Add a range to pkvm_mappings
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
2.49.0.1112.g889b7c5bd8-goog

