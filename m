Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2571534F7
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618268; cv=none; b=BfWO4BzExKsPFqRpLxpRQPHgcEAjL+jLNZ5G+PaQ9guJAk6W3rtKDVMaMWKLCYiMq+YC0wkVQQzy4XiKrq0wrxabG6U7M8FA/YF5yG5Mhi47R5wkA30KPhzdahhR+zJOfEtQRPh1jiUQVlXtqse6uLQixjbZW4qkH/dGWFO1sIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618268; c=relaxed/simple;
	bh=thrcBYxJpIov0ueUkK9xUJVnk7mGfhkTWP9cDj+zyXc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RNQd3XQ6s8LRmSWRRkRRCVotGyzvH+7VOJU1Gc2AasxIAq66OX5OPPdcSebnLh/ybZHO/7A4ZVh6z3eUHiAfrnJwLsgd1d+pfusTpOoOYPscbvpmmnmTv/DDoW2aFrjSnKaof7TbaQWRPOtZma4NASKzvYJntJDUwqpTMExf/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i0y0NXbD; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i0y0NXbD"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40fb505c97aso10475575e9.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618265; x=1709223065; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/cR/Yk//cCpUcqF45wtqjPoccwRQ5dc9zhX4CLbSuaM=;
        b=i0y0NXbDstzxXqcBJAIG9EuaO/8rcIh/9Ax1DC2r3JxjMNIQVXo59v/gs9FtaePNmN
         7r5A8xKxdORpX8ISNu3Bfrmk5QoMbFHQmXuGex0hbSbrmJ0vt/FNYKBleIoiZDPogSHd
         VT2Jl0s+Sg4spNqTAeBBgG4ZbrvfmpxgUs9X1RU+mmpW0jQhADY07BaWEv6Q3FY/F7eY
         VmyMFh9UCh0nVO11oDplgWSidWm04Pwp5oQJi/9BgzAt/F98DgoHTrL0R8Yd4aeK7sze
         IgzqGPpZlBfCc30J23xpFDroH6ZOkzvU5aWtSItrc+C0wXNXca2DNAeUtlVNlECWEQMD
         3wZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618265; x=1709223065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cR/Yk//cCpUcqF45wtqjPoccwRQ5dc9zhX4CLbSuaM=;
        b=SleDegbFkO33RVaHrbB7kHhlXFMa4BuVeQmeQlZjqlTdZfS7zgvHX5klAjHmlXpdf7
         2NaeervaU9w4jDBUP1/Z6P0zXJ1YAWHLYDFQDYyLV0JSyXh310Td9EJLltwEmf0hKQ5X
         /8miHkiPqfafhX/pgErFodk/4p7epa/O3+2DhCc6d9yWlfnIQtheymN16QNytP2ng72F
         7oNN5cYcFkGPgQO01Cx9/lRXiGYJ3nmu56TBmFAFt9F9HDk/c/y3Dymaqa9ST0232UwC
         N97LC8Vpj2yBselUEsm01mdD5j5wRBWUN63sFtvka/chVm0Zl6Oyi4aqHTEdf4q9gWHt
         EXWg==
X-Forwarded-Encrypted: i=1; AJvYcCVz7P1ewQZbogQP343FG9A1svWPuWC17xK0xAeF77tKxYgvWhlZDdRVwXZC1LnNcgJwoj4f8Ntd7+bHTZseLolGz5OZCf5h
X-Gm-Message-State: AOJu0YxslLgvQturYWxva3oyNCmRwLIPL/OIa2vAVGz914o2QAiwvQAl
	e8SPV79jbUbdvl6uDfaTT8A5/tn2owCHTMJLYEzx7kqDJbf+39dtE31nFD0cPjPovc5IXKGmJw=
	=
X-Google-Smtp-Source: AGHT+IHR+pszL4yvDO1W7/HLWaCbjn0hGceaWyc7avnwPEt4h67Y/r8Z82fKYEdOS79KKYK3ME6EYmrMaw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c2aa:0:b0:411:fa5a:151b with SMTP id
 c10-20020a7bc2aa000000b00411fa5a151bmr112085wmk.1.1708618264912; Thu, 22 Feb
 2024 08:11:04 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:27 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-7-tabba@google.com>
Subject: [RFC PATCH v1 06/26] KVM: Implement kvm_(read|/write)_guest_page for
 private memory slots
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Make __kvm_read_guest_page/__kvm_write_guest_page capable of
accessing guest memory if no userspace address is available.
Moreover, check that the memory being accessed is shared with the
host before attempting the access.

KVM at the host might need to access shared memory that is not
mapped in the host userspace but is in fact shared with the host,
e.g., when accounting for stolen time. This allows the access
without relying on the slot's userspace_addr being set.

This does not circumvent protection, since the access is only
attempted if the memory is shared with the host.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 virt/kvm/kvm_main.c | 130 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 114 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index adfee6592f6c..f5a0619cb520 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3446,17 +3446,107 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
-static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
-				 void *data, int offset, int len)
+#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE
+static int __kvm_read_private_guest_page(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn, void *data, int offset,
+					 int len)
+{
+	u64 pfn;
+	struct page *page;
+	int r = 0;
+
+	if (size_add(offset, len) > PAGE_SIZE)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+	if (kvm_any_range_has_memory_attribute(kvm, gfn, gfn + 1,
+		KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE)) {
+		r = -EPERM;
+		goto out_unlock;
+	}
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		goto out_unlock;
+
+	page = pfn_to_page(pfn);
+	memcpy(data, page_address(page) + offset, len);
+	unlock_page(page);
+	kvm_release_pfn_clean(pfn);
+out_unlock:
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+static int __kvm_write_private_guest_page(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, const void *data,
+					  int offset, int len)
+{
+	u64 pfn;
+	struct page *page;
+	int r = 0;
+
+	if (size_add(offset, len) > PAGE_SIZE)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+	if (kvm_any_range_has_memory_attribute(kvm, gfn, gfn + 1,
+		KVM_MEMORY_ATTRIBUTE_NOT_MAPPABLE)) {
+		r = -EPERM;
+		goto out_unlock;
+	}
+
+	r = kvm_gmem_get_pfn_locked(kvm, slot, gfn, &pfn, NULL);
+	if (r)
+		goto out_unlock;
+
+	page = pfn_to_page(pfn);
+	memcpy(page_address(page) + offset, data, len);
+	unlock_page(page);
+	kvm_release_pfn_dirty(pfn);
+out_unlock:
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+#else
+static int __kvm_read_private_guest_page(struct kvm *kvm,
+					 struct kvm_memory_slot *slot,
+					 gfn_t gfn, void *data, int offset,
+					 int len)
+{
+	BUG();
+	return -EIO;
+}
+
+static int __kvm_write_private_guest_page(struct kvm *kvm,
+					  struct kvm_memory_slot *slot,
+					  gfn_t gfn, const void *data,
+					  int offset, int len)
+{
+	BUG();
+	return -EIO;
+}
+#endif /* CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE */
+
+static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
+				 gfn_t gfn, void *data, int offset, int len)
 {
-	int r;
 	unsigned long addr;
 
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE) &&
+	    kvm_slot_can_be_private(slot)) {
+		return __kvm_read_private_guest_page(kvm, slot, gfn, data,
+						     offset, len);
+	}
+
 	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
-	r = __copy_from_user(data, (void __user *)addr + offset, len);
-	if (r)
+	if (__copy_from_user(data, (void __user *)addr + offset, len))
 		return -EFAULT;
 	return 0;
 }
@@ -3466,7 +3556,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 {
 	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest_page);
 
@@ -3475,7 +3565,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
 {
 	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 
-	return __kvm_read_guest_page(slot, gfn, data, offset, len);
+	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
 
@@ -3547,19 +3637,27 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
-			          const void *data, int offset, int len)
+				  const void *data, int offset, int len)
 {
-	int r;
-	unsigned long addr;
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM_MAPPABLE) &&
+	    kvm_slot_can_be_private(memslot)) {
+		int r = __kvm_write_private_guest_page(kvm, memslot, gfn, data,
+						       offset, len);
+
+		if (r)
+			return r;
+	} else {
+		unsigned long addr = gfn_to_hva_memslot(memslot, gfn);
+
+		if (kvm_is_error_hva(addr))
+			return -EFAULT;
+		if (__copy_to_user((void __user *)addr + offset, data, len))
+			return -EFAULT;
+	}
 
-	addr = gfn_to_hva_memslot(memslot, gfn);
-	if (kvm_is_error_hva(addr))
-		return -EFAULT;
-	r = __copy_to_user((void __user *)addr + offset, data, len);
-	if (r)
-		return -EFAULT;
 	mark_page_dirty_in_slot(kvm, memslot, gfn);
 	return 0;
 }
-- 
2.44.0.rc1.240.g4c46232300-goog

