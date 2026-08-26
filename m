Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D40B3C8C77
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785534; cv=none; b=JU+yhHqJLaf6b4llLy/jsxisAxhgfic2h0VDH/eWzh0glsqA9kWFoIUVZ6CZQVpCJjus6Hq+izQ6PRheDbEym7UdLt5BvWoCh7UJR7XHtciRLK3XVRMvIpvsrZFiepRDVnEOhSeSY+kgMyR901/UY8eUWnGp311hjFGWcd2cDa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785534; c=relaxed/simple;
	bh=huIHcszqZLipHy5mZfQG8RPYZOue7MV8WgHvk308HPs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=COmgJ6b1KmaOEMNSkEAXv+EDOKbI5XsQhxyYjgYB/UNgtfD8RSl2S2UhrEJO9WaTqzh2qWGwhs3DAlYdeqw3MzC0xEyOHoF71i07gVA5Hm/F2I/+SYxAxWvgorjo+iMqJjBmvnM38E5VFi9/MJJuaNDN+kpOmxlRB6hn1VGpEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MVPSJMiB; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MVPSJMiB"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1c18c775eso410584a12.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785529; x=1788390329; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GZ4MVTLP0goD2ecS0YI5oUFT+iv0vlU/KAAezn2Wgnw=;
        b=MVPSJMiBzhfbA2a8UDOncfJyfElKJCyl3oquNf7qvlY4/1wpLRUlD7XF6vehkex1U7
         RiAIGwkedct/2A1tu55GTN+jvIFWeYNu+r5GlAvIc58ohgY49JNV5l1G54CU7H3aPq8Y
         dK2MTOyFdZeOuZPtHGiq5ZMXWFdxHpE3OD0tMy/R4kAjUxxU5e6q/1FcJ9yrLjD9bEUG
         WxI8/HK11eEaWNifwRLdeI8AQKMt/IiHFDTKq1W3tx6WjCx3CErOtD18f+y/iwBUuZfk
         Dni3WV+JrWZuzVdxsop9DMPyESAXjMHaDyWPbjDueX0by2x6dbxQS+xkA/UKwzHMjBBI
         mg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785529; x=1788390329;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GZ4MVTLP0goD2ecS0YI5oUFT+iv0vlU/KAAezn2Wgnw=;
        b=lnooIgYTVU0Uof2RVa6z+MkKy5zubTHxePvo9MOHSPGYyUdsT9HXZTz2T+zu0sdwyw
         dLKugGelZ6on4aTunoQAWizcX0yUrlqf50TU6kKClDMjSWb81Hdd40A/g145XS5Iqinh
         tbUf5gRHkToZacK/9ljVMqQsdd15nwUCFFoSVg8SfZ6A2glfKffTx+W9Pdkfltxjdo8Q
         nHLLqwBM6VoeO5U8ubW8+NFTJSvHPU1vRyV7PhJB8TupkiLzVMgW464I1G0uwD2eZHDF
         +/B6wVrOdw/ARvxxOAh9DLq7Y0Nj6f8Sm4R01J8QodhicaLrHofboIogIgaCF6InPYKX
         z0nw==
X-Forwarded-Encrypted: i=1; AHgh+RpWQREgsx1JwgceUmBpKq/LvwxK7+hf25XYcZ5nGWDnyPc5vUSW5WiEJ9cuCyHCjlpR0zR5Txg=@lists.linux.dev
X-Gm-Message-State: AFuF++nVmHnMAqqsE5gW7tWnERE5BHfXzL4a8CB9GYwyTWD1I4t5q/5Z
	+P34ISLyc2vkjtUkYXLvAQTKCVSHYqMC52V2uXY3f85NcvjpnxaDuHSwzjie5Q8uovUiIxu7+CG
	2EdPLTA==
X-Received: from pgdt3.prod.google.com ([2002:a05:6a02:3003:b0:c9e:41e5:2eec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4388:b0:3b2:8674:9830
 with SMTP id adf61e73a8af0-3d0f6d2abaemr2865016637.14.1787785528406; Wed, 26
 Aug 2026 16:05:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:01 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-11-seanjc@google.com>
Subject: [PATCH 10/20] KVM: selftests: Add a wrapper API to allocate multiple
 page table pages
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add vm_alloc_page_table_pages() and use it throughout arch code to replace
open coded equivalents.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 9 +++++++--
 tools/testing/selftests/kvm/lib/arm64/processor.c | 4 +---
 tools/testing/selftests/kvm/lib/riscv/processor.c | 4 +---
 tools/testing/selftests/kvm/lib/s390/processor.c  | 8 ++------
 4 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 2525c2cacc22..21354434de0a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1013,10 +1013,15 @@ static inline gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa,
 	return vm_phy_pages_alloc(vm, 1, min_gpa, memslot);
 }
 
+static inline gpa_t vm_alloc_page_table_pages(struct kvm_vm *vm, size_t nr_pages)
+{
+	return vm_phy_pages_alloc(vm, nr_pages, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				  vm->memslots[MEM_REGION_PT]);
+}
+
 static inline gpa_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				 vm->memslots[MEM_REGION_PT]);
+	return vm_alloc_page_table_pages(vm, 1);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 01325bf4d36f..2dcaa2c4a038 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -115,9 +115,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	if (vm->mmu.pgd_created)
 		return;
 
-	vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
-					 KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-					 vm->memslots[MEM_REGION_PT]);
+	vm->mmu.pgd = vm_alloc_page_table_pages(vm, nr_pages);
 	vm->mmu.pgd_created = true;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index ded5429f3448..c175dcd14114 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -69,9 +69,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	if (vm->mmu.pgd_created)
 		return;
 
-	vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
-					 KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-					 vm->memslots[MEM_REGION_PT]);
+	vm->mmu.pgd = vm_alloc_page_table_pages(vm, nr_pages);
 	vm->mmu.pgd_created = true;
 }
 
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index fb9dab92d4d1..33f49d743b5f 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -20,9 +20,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	if (vm->mmu.pgd_created)
 		return;
 
-	gpa = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				   vm->memslots[MEM_REGION_PT]);
+	gpa = vm_alloc_page_table_pages(vm, PAGES_PER_REGION);
 	memset(addr_gpa2hva(vm, gpa), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	vm->mmu.pgd = gpa;
@@ -38,9 +36,7 @@ static u64 virt_alloc_region(struct kvm_vm *vm, int ri)
 {
 	u64 taddr;
 
-	taddr = vm_phy_pages_alloc(vm,  ri < 4 ? PAGES_PER_REGION : 1,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				   vm->memslots[MEM_REGION_PT]);
+	taddr = vm_alloc_page_table_pages(vm, ri < 4 ? PAGES_PER_REGION : 1);
 	memset(addr_gpa2hva(vm, taddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	return (taddr & REGION_ENTRY_ORIGIN)
-- 
2.55.0.887.g758fc8c411-goog

