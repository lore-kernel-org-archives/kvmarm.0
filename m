Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23C88F41
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918973; cv=none; b=UTO3Gcx3HJ38kKmXd9y/dTe2SfcjTiDnrOyMLDi8q6TURoyi1a3E/6lynYn7xapZmPuBA1zhvZR+r2p7J9ZtuG6br/RQ5n7g+xsRG0/YWM7hQFF38p5UPmXTF4j4BcKz9Gv6mxA8u2vy9EaZcGs9vnT7xhQU1z77iGlhAzbY9vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918973; c=relaxed/simple;
	bh=eEsuDAyYhqh0PRIkmb2mwUAqWJ2Pol0Ha6iX400H8fc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DzKOSTIUy5qTwO7bUYFfYXLbC7lLz/skpTIbSAa3v+439+NIR8pO0/dM+zlrkX/5ESXGkmrjZLBlM/uAEAX1C5+rAb5Hk6KmLEdPHED3Z892KVPs2/AdYobkQElFFPeQKh7LzSagHWfXHH84yjX1PCasGE82v71iIP99RXlBg1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CjHjTRXr; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CjHjTRXr"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6040a34c24bso45480137b3.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918971; x=1707523771; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5qit/ax01cjsi8jn+OF5XBDYnQC7hsp7dQaMdNEMAzo=;
        b=CjHjTRXrFwe4jzpVDC6vt+yLRrpzZQRi/5kkpIOeOi7wuubskFqwNJW1baxUgX7Unx
         4XzZLWVsqAhm7CIGmuICGe9+/MLdF3i+wYs0ku59g1he5fxOCU5k/IWrH1rjWROwhvRD
         puq7TWJYfA0Lsn3DX0FYCb8mPbYcyM1WpFo5U0otmkcdKblJcQIz5WdYyYE5itZvjZgv
         2nTryjU7O0n/YJNClIEgPbix9SiK8tTa/wFQUvAOn+sGq7NlpujtgOkJXn/268L+NOnX
         zQ1Ty/leApReSL3afD8EDDUR//JpfHvKeFnXrmuOPqj7tCsAsNbHJBfMGfSyz3pmsV+e
         7cFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918971; x=1707523771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5qit/ax01cjsi8jn+OF5XBDYnQC7hsp7dQaMdNEMAzo=;
        b=n4KcLwPZ1ItgSETfWVaShmcXwQl1Uen70AhHG7lCWiwcVBMREg1oj4HFczWlMkR1LL
         mYLsb2NSDXc98pkAKb9Cu3vAv7c3regYlgeBRfiw6GW1qc42hjyujob+B13AZv8/2Cyq
         DQLVFTssf2R23ekjyFdrNrROo40eC3qc2PGh88+BdBn9CedHqA0fW3EInweRXVvDgnl4
         X35UeObcewQPBaAZJog7CoPB39tv9OaW2+Otwx25P67+Riy6BsNEoRuW2uJOv+mqq7/2
         RLYIiRGbeS3TBUJVzGQeaoqT41cByu6TA6MAnoLwRlsXFCqtZU0rVhaZtYQ7E9rYSeaE
         ntNA==
X-Gm-Message-State: AOJu0YzJn1PDm8FQJRU51/8/Uvq7/Y/aD+UNehsEuA5+sYJPK6R85weM
	DdkHutAYp8olm6DhuzxOjUFTpWnVMSe2EqUyl6RojxROjFQEU/bV67YayXsEiXt8nwQKGFGmVOZ
	hcA==
X-Google-Smtp-Source: AGHT+IEn7SwzHm7K9kCm5lO4ksgfDS3a7ro7MEBhevB3F0wiSwy11y/YKaE4P41Zv85Ql7R3gAuHdPatt3E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4cd5:0:b0:602:d83f:bf36 with SMTP id
 z204-20020a814cd5000000b00602d83fbf36mr1585025ywa.0.1706918970863; Fri, 02
 Feb 2024 16:09:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:11 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-6-seanjc@google.com>
Subject: [PATCH v8 05/10] KVM: selftests: Add support for protected vm_vaddr_* allocations
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Michael Roth <michael.roth@amd.com>

Test programs may wish to allocate shared vaddrs for things like
sharing memory with the guest. Since protected vms will have their
memory encrypted by default an interface is needed to explicitly
request shared pages.

Implement this by splitting the common code out from vm_vaddr_alloc()
and introducing a new vm_vaddr_alloc_shared().

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a82149305349..cb3159af6db3 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -590,6 +590,9 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_mi
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			    enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
 				 enum kvm_mem_region_type type);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ea677aa019ef..e7f4f84f2e68 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1431,15 +1431,17 @@ vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type)
+static vm_vaddr_t ____vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+				     vm_vaddr_t vaddr_min,
+				     enum kvm_mem_region_type type,
+				     bool protected)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      vm->memslots[type]);
+	vm_paddr_t paddr = __vm_phy_pages_alloc(vm, pages,
+						KVM_UTIL_MIN_PFN * vm->page_size,
+						vm->memslots[type], protected);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1459,6 +1461,20 @@ vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	return vaddr_start;
 }
 
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type,
+				  vm_arch_has_protected_memory(vm));
+}
+
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type)
+{
+	return ____vm_vaddr_alloc(vm, sz, vaddr_min, type, false);
+}
+
 /*
  * VM Virtual Address Allocate
  *
-- 
2.43.0.594.gd9cf4e227d-goog

