Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099F43ACA65
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360467; cv=none; b=tvvjediIlGv9hyhs+1Ol3AzB+O6cTKWO3t6hnApm9Q5aHXYDuIZoylhk0jr+OxgfPEOLw4WUSS+C6QeF3iZ/zJ49qHJFW3LQVPy6Fpr2Ni84mI/h4YuK79Dk1Hr2IWdrN6klMRwNu1k3FGxFI9kOXLxcaGjQ3ycv81bOFQkUpLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360467; c=relaxed/simple;
	bh=vU4zzSUghHshdHFifgf6GF2mkbYzUgkrVqLkIvwIRx0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r36jd26CUK1qeIDXqsfubdi8T7X2y+rPrUMMiz5/UZiUN2fhWH/0JTpQ7rMgAUb4C61ReaVj+8DUWkQIzbekhXwHP6GY3unn+GoYXvDXhuJkgX1Zf7E09NGHkJXIFwoz5rn1R1/idG5ADHcP//Lr8sOlYqKbj5XlDT4OQ3Sc5t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VyhXNzvR; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VyhXNzvR"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-698883d0621so2785620a12.1
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360464; x=1783965264; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+msO2PWgDlQXt9g2yg/b9J1El+V+LtPBdFDy0rxh0Ng=;
        b=VyhXNzvRkoWiAyvmRqIbMeJXmDoVyOD7FylZ4+ds1HTcxfrYvNSVHvatadOiORSUGu
         Bbox/ce6ghDOplCm/Z6XAxhuTzKzPrVRA+4A/76Zt3Ea0K3AcOODfL8yZiRstvY3yuBh
         nzbBeYu6BGhUzwRV/b5nZYOSmzsnQb5a/Mg+kvJiE9HoYKiCRWvLGEupoq3v3ny7HmYr
         KqDnO5/FqtlU74v1u4UvMQazhF1nhtQg+KMdJKS893WDO3J/nlVu25Zczi7Rpw+wiCEY
         rv0V2mZsmk9JRgNcB9Rt/GHn0EywXE6mL1Ksi82jkCJ+XubdOkm8l8rXJe9+HHMJzQRf
         vp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360464; x=1783965264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+msO2PWgDlQXt9g2yg/b9J1El+V+LtPBdFDy0rxh0Ng=;
        b=HFI5nM9RrvFlrfDismKVOLA3WVtbZG8DaUBcLxdjv1XBiwbiFU6di3cB9CnBvvg0Fb
         gqxRrzwYJ7B1eg2YVRIeAc0jnQsFY/W8OOB9S4vw6H9Nv7PprqpHRt0/YnOA1P2pqie9
         ZirDd/MM02Ix/QFQnyPfAORKmqtr2GjSNto+F9onfk8hON6MWsdv90tdRNNQbP6Dobt7
         M/YWcQc24gYKwtjEB+m2o6Ubihek6elwdoA9GMrhQbtpGV+3U7JCCR7SHfQwGU4fuD3Y
         GKaIsUu26fodWEisdS5B8Hwq6yc8TQoMDQO7fblCMxUjLZ8zA2YoDJxfqz9e2dUmNuBm
         bOyQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzNwASq4s3kMkZvVupxmI43Zl4+EE6OUn5JxpoZmY8s+Ga1qEzwlVA/fi71fVcsXv9X5rHEr4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9UL46rfJA3/8C83ihqKWoao/PiF150sGuWR0Exyw/FTghGUR+
	/2low3boNZNmHO9n0ECARLsxuF9P+gyCdO/DsFLsQ1yZ1rNU8x/OXHljrIlNwIeH3xzX50JCkHR
	cPeJyNqGCat4Rw9EFby16pg==
X-Received: from edsr22.prod.google.com ([2002:aa7:da16:0:b0:699:839b:3e61])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:13ca:b0:698:6084:db7f with SMTP id 4fb4d7f45d1cf-69a85a8d0bdmr922862a12.10.1783360464030;
 Mon, 06 Jul 2026 10:54:24 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:53:59 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-3-vdonnefort@google.com>
Subject: [PATCH v2 02/18] KVM: arm64: Add pkvm_remove_mappings
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add the counterpart to pkvm_create_mappings(), allowing previously
mapped ranges to be removed. This will be useful for the upcoming pKVM
heap allocator to manage its private mappings.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index d3137c16b632..725bb0fb941d 100644
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
index 773426a68d2d..ec59da1322a7 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -146,6 +146,20 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
+void pkvm_remove_mappings(void *from, void *to)
+{
+	u64 size;
+
+	to = PTR_ALIGN(to, PAGE_SIZE);
+	from = PTR_ALIGN_DOWN(from, PAGE_SIZE);
+	size = (u64)to - (u64)from;
+	WARN_ON(from > to);
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) != size);
+	hyp_spin_unlock(&pkvm_pgd_lock);
+}
+
 int hyp_back_vmemmap(phys_addr_t back)
 {
 	unsigned long i, start, size, end = 0;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

