Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B234B66EA
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864946; cv=none; b=Tlo+RXekT2fpXuFl6KnX+Tp/w+1ISOE25xa2YpheNDQrCjwKKxlapk07d2hRp+Q409lF55zuxbkAqHKYTRHF6f3X1eLkYMfgzzgP+Zz09Zsx3AFnBx5gNfDFpd2gBMFeoCH06iivHKD2s5xXPF2SK3wh9g3vkdK2Y9emjP28Yq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864946; c=relaxed/simple;
	bh=BliGAsoAy0DyS2h7TA22n1YGzMf49ByNjF1AkM9ZDnc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pZZDU+gOgEkSBD40gj0qv4pTTBsq0pZ/sVQ8MykzAzn8elgiWxdtYgH6dJNdfRc78DcpJpFfHU07kxdDvkjYkd+gDQARgKtV0M+DQ44Y7wd6xfoOiY48DT/6wReJmPcBtqVa71PM23/MItzhH4nWdj5OHAqpr/Lry2NqHM0NilM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gks93Cts; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gks93Cts"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a02607c21dso2014935e9.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864938; x=1791469738; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HXdW3KLWBNEvOd9ZzhOaPRcErPR/vT/YK+xCwxPIfYM=;
        b=Gks93CtsoKk3Tg/hL4SoCbBo0wY4CGRZirtWJIbJwUV/ZG4K6a4nWsMXjkwjEYWqSF
         3ARmzksKv5ZjEdb7HzCDoJwULk1SxyFqmrVF13vB+YcXoQrGXCMfBOFbjEEMKFi8Cz5L
         JZH0rfbOAyJ7WPC0D1nCnb+PaIehvOk5Hyn+nt5QlWsociqdnQZFQAU9C8NGow61SXRa
         uMN8UrMNSVToBJ8plLrJZ1OUT2xWkaRJF2VVf4o+etA9Qb2lK3j/ld8uIzNAijBS61Ah
         SZw5spjLU6G2P4kcELYASG1yZ48VDEF0McTcONxO7OVO8lxXTdqL1L8Ea6ptHhhtjOP6
         t0hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864938; x=1791469738;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HXdW3KLWBNEvOd9ZzhOaPRcErPR/vT/YK+xCwxPIfYM=;
        b=2ynGF+3eHjk1kLUW4U7wBHd0prwrT2xSSApHx1WdjBTLUAwhLcastlzVMiz7B3YLUe
         DXdXmOyv/FhTJ0EBM8h5y9SF8UjaU4Keo9Q9ankjwb4i2nLj98elbuqM9DlHKRryCr/L
         WjFLP8lz1cKrh0ImLLoV7PAF+Lnc74Cs+Xxbtqc43cSMzEWChchjSDFQd6E81MZmG+ko
         K2EKZDwAR7DQK4P03aGz8RTzbCEDX66tkR+TuoeRkvCt3zu/88rqsmaQg3HPtxFBJFS2
         1IRiA685rYcbX/mae9EDmwtJfUGDL7LjQErNFow5pRHtvZc04S8ziY9YDW0t0OSsJIXZ
         9FWQ==
X-Forwarded-Encrypted: i=1; AKwUvBysPu7jCvifzKMd5rhECam4SZz2Hn+s0tfQOWESS5u3/34tS7bhW39orCRNVCNm6ns1bsMeU0I=@lists.linux.dev
X-Gm-Message-State: AFuF++nnFviYEZ+ySTEBWJ2Gj2RmhBNphrC1xFBX6eevB1id6SXJ/X4e
	lkWGDf//FTVjk+JaK5cR3Rdo3V4130pF/WuJOmPsoG6tctziic5mBEzTcz9Sh4wzDCvrn1NutZo
	4U6NHdtE5+YYqv/wqXLptVw==
X-Received: from wmlm13.prod.google.com ([2002:a7b:ca4d:0:b0:49f:e41d:3d75])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c490:b0:49f:ce73:5e96 with SMTP id 5b1f17b1804b1-4a01b12d914mr82599505e9.34.1790864937470;
 Thu, 01 Oct 2026 07:28:57 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:33 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-3-vdonnefort@google.com>
Subject: [PATCH v6 02/18] KVM: arm64: Add pkvm_remove_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the counterpart to pkvm_create_mappings(), allowing previously
mapped ranges to be removed. This will be useful for the upcoming pKVM
heap allocator to manage its private mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mm.c         | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 85f1e3c711d9..00cadd13ee5d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -25,6 +25,7 @@ int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
+void pkvm_remove_mappings(void *from, void *to);
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 755630c0d15e..9ab7f613fa36 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -164,6 +164,24 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
+/**
+ * pkvm_remove_mappings - Remove mappings from the hypervisor page-table
+ * @from:	The starting virtual address of the range to remove
+ * @to:		The ending virtual address of the range to remove
+ */
+void pkvm_remove_mappings(void *from, void *to)
+{
+	u64 size;
+
+	WARN_ON(from > to);
+	to = PTR_ALIGN(to, PAGE_SIZE);
+	from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
+	size = (u64)to - (u64)from;
+
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

