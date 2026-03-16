Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE9333AD99
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773682536; cv=none; b=sqDWNdkxcrDv008zi4lgTmgUUTQsF8J+1OUHC1vaB5ib9RKCPXoipKMGInj7MqoyY+joI51byYRKytFdELn/p9iA0bkiSIXO/hIwHZAhPW4mSo3OJXkOlSV8DLnXLvTZ+CVobuViWcDEn6r2FHZuTS39vrKjRAgJ1KopQmvjLhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773682536; c=relaxed/simple;
	bh=mXyhSE1MRAfCl+4+ivhGrwWepMYiNO9lJZZ3zNL2X4E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CP52idC2+4UgNwn9U7PiJ1yWynw+h06U1HzXQLCGPEwikOhiVBSi9/mNRVwgxmGqt33xb2aI8ErfbMbW5EyxiqrpcXR4wdK//lmffMgiSOe7UgVT2BCvRSUn1R9k1OF+31YldwzDpyID+7jfVvc+oHzMuBMAPEvmo/4MBRFkM9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AsZw0jLO; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AsZw0jLO"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-663622c1eafso3282426a12.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 10:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773682533; x=1774287333; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHQqMyuuFlwpT2UE52Jtk7JCykj8I76gbQARj/JlEmo=;
        b=AsZw0jLO7eEWNJOVyFj/9O2y1U15WZ1iBSJ1NYFD1kdYrZn48j1soEwduHiNg4L61u
         5xNvPTxYk+h3hdMBgWFfGqBRGdkhFWy5uJy4UNT9JHCsOGqJLAEvIohoDBOxr/CXHe9S
         g7mYOnGhv13iNxJQh770RBSms3ONAMe5g+R7Hp8TpRDTp6HOxDd2HAVVMIXwRz34ojUW
         yJU+Hr+j7f2B6R6/BwZ78C2oJdJNylJmqYJYpzMnYFdlCIn4GNaCbSRzvQz7W+UFTGdh
         kWE5pu3tEMPHLsO4Z2NpLiRGoByz3I8iyoBdv4Z/vvqOCHutO0GLpopWrvxI5xdWOjaW
         RH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773682533; x=1774287333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tHQqMyuuFlwpT2UE52Jtk7JCykj8I76gbQARj/JlEmo=;
        b=Te3cLsMDgtcEm4fR2KJLZ4BkZKTYxrU2JFHynoqKXl8edcHmdSZ7l3/bUurK7i2e9D
         iRC0WBroal4dF2R5yWHFuS7OTvWE+U2PNxWlVNq7b3l10qBJtEo7JwUxrqJK/Oaj+Lja
         e3epK1UjF+r1NaXO5dNPFfAoLxicl6ezLeDIC2xXmd4YLjj3g26HkqedEtlur7NjXHOX
         GqtKvR1hfrJmhBDlrWhx0FMZq0WjDqn6JpS501pmrGukRKusU/DK9M5i3oaP0iHHBOM4
         8KGHEVUn6wDpQ9Z9ql8GUZs/aRu4LqwuodP6cxlcWD7gFZRw59cIGAe18jtPlk0GiOz8
         dpiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPE9qiaA2yJhSr/5QS66Fr0mOpqCNTIdhZY49YbnhptdpfL8h6GMuTBD/8xC07zyCvIr5WRSA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNfqKCso+NC0El/FYhPoZgscq+wHJV5rG2kZ/0Z+E/dv7nXNI0
	XN4H++tlzr6fdS+AYFl4kkI1cpyxLOLbJ0G5Zqy93MhxxMgrg8AA0iPPr9N+THPUItwt5Gooclg
	McQ==
X-Received: from edra16.prod.google.com ([2002:aa7:d910:0:b0:661:d31:27ba])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:13d5:b0:666:d8bb:85ec
 with SMTP id 4fb4d7f45d1cf-666d8bb8808mr1653788a12.0.1773682532416; Mon, 16
 Mar 2026 10:35:32 -0700 (PDT)
Date: Mon, 16 Mar 2026 17:35:25 +0000
In-Reply-To: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316-tabba-el2_guard-v1-0-456875a2c6db@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260316-tabba-el2_guard-v1-4-456875a2c6db@google.com>
Subject: [PATCH 04/10] KVM: arm64: Use guard(hyp_spinlock) in mm.c
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <linux-arm-kernel@lists.infradead.org>, 
	"KERNEL VIRTUAL MACHINE FOR ARM64 KVM/arm64" <kvmarm@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Cc: Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="utf-8"

Migrate manual hyp_spin_lock() and hyp_spin_unlock() calls managing
pkvm_pgd_lock to use the guard(hyp_spinlock) macro.

This eliminates manual unlock calls on return paths and simplifies
error handling by replacing goto labels with direct returns.
Note: hyp_fixblock_lock spans across hyp_fixblock_map/unmap functions,
so it retains explicit lock/unlock semantics to avoid RAII violations.

Change-Id: I6bb3f4105e95480269e5bf8289d084c8f9981730
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mm.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 218976287d3f..7a15c9fc15e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -35,13 +35,8 @@ static DEFINE_PER_CPU(struct hyp_fixmap_slot, fixmap_slots);
 static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 				  unsigned long phys, enum kvm_pgtable_prot prot)
 {
-	int err;
-
-	hyp_spin_lock(&pkvm_pgd_lock);
-	err = kvm_pgtable_hyp_map(&pkvm_pgtable, start, size, phys, prot);
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
-	return err;
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	return kvm_pgtable_hyp_map(&pkvm_pgtable, start, size, phys, prot);
 }
 
 static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
@@ -80,10 +75,9 @@ int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 	unsigned long addr;
 	int ret;
 
-	hyp_spin_lock(&pkvm_pgd_lock);
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
 	addr = __io_map_base;
 	ret = __pkvm_alloc_private_va_range(addr, size);
-	hyp_spin_unlock(&pkvm_pgd_lock);
 
 	*haddr = addr;
 
@@ -137,13 +131,8 @@ int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot
 
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 {
-	int ret;
-
-	hyp_spin_lock(&pkvm_pgd_lock);
-	ret = pkvm_create_mappings_locked(from, to, prot);
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
-	return ret;
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
+	return pkvm_create_mappings_locked(from, to, prot);
 }
 
 int hyp_back_vmemmap(phys_addr_t back)
@@ -340,22 +329,17 @@ static int create_fixblock(void)
 	if (i >= hyp_memblock_nr)
 		return -EINVAL;
 
-	hyp_spin_lock(&pkvm_pgd_lock);
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
 	addr = ALIGN(__io_map_base, PMD_SIZE);
 	ret = __pkvm_alloc_private_va_range(addr, PMD_SIZE);
 	if (ret)
-		goto unlock;
+		return ret;
 
 	ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PMD_SIZE, phys, PAGE_HYP);
 	if (ret)
-		goto unlock;
+		return ret;
 
-	ret = kvm_pgtable_walk(&pkvm_pgtable, addr, PMD_SIZE, &walker);
-
-unlock:
-	hyp_spin_unlock(&pkvm_pgd_lock);
-
-	return ret;
+	return kvm_pgtable_walk(&pkvm_pgtable, addr, PMD_SIZE, &walker);
 #else
 	return 0;
 #endif
@@ -437,7 +421,7 @@ int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
 	size_t size;
 	int ret;
 
-	hyp_spin_lock(&pkvm_pgd_lock);
+	guard(hyp_spinlock)(&pkvm_pgd_lock);
 
 	prev_base = __io_map_base;
 	/*
@@ -463,7 +447,6 @@ int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
 		if (ret)
 			__io_map_base = prev_base;
 	}
-	hyp_spin_unlock(&pkvm_pgd_lock);
 
 	*haddr = addr + size;
 

-- 
2.53.0.851.ga537e3e6e9-goog

