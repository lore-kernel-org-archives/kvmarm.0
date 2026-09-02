Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF24AA562
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367292; cv=none; b=frQDkC7hYCNMcdF2nltLojTZcnVYR/Gk9PJ/3iFBRQZMIM5u+eDD43Vd4MuYqTq2qQMAn9FwYBA9sdDF6xgM1aEYZi6TevQalZdZ9yirDdHKNoJ7ejcCGDeAXvbd/T7GnwSeSIxkeAhI02XOUivktVippsapu8GCaXnCFqvg0mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367292; c=relaxed/simple;
	bh=PqikAw/eC5X3KNqAbORwNmmWfNDuPm6CNtLB+01JjLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=usDLqFTCOIJFvkOfUVQgoqDR8iALJhbbMU8JN7GWGsndRPEczsH54Nq1qrWJSHj6cpiAOxgnjcto0PdAFc3/yzpIXrRmvNtNhJr5cxBSBWZpNqZ7OBOHnvmfUi8BUym0tK2KZHON01mOJmtI1vzqCU/8qr1+eYxt0VYgyGQ0WIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ni4jE2FM; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ni4jE2FM"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc132709c76so2102604a12.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367288; x=1788972088; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0zhVxUyRpRhnHXbQLMxjoc4Ys+BN3Anj09sDDnw94v8=;
        b=ni4jE2FMmctrUk9aP0bKJPfz45XSe2McLOUfL4WM4LpQSkde4nRQ+zQQ3r2IcqDWGQ
         YoZcD9Wx9dQL8GcC1mlRh7W14EMqZ4QgGYxaFnWOULauEJVTladyhQPOoaWFoa4LUQx+
         4SyS/pRXFdPguCtnw6CtizsOsZHXqIENmRfY4tBwrDb8lDt0i1n2uryuDJY2k65tf5Ub
         acX3mWLP6JjXWbnglgRQz0XwGnYCz4X5OUdPW61j9gWjy1Ma/P0hlEb3kD2n1iQIQ60+
         EQ9NL6iKS61w5r1MpsGOaBQXrtZ77dCgBflaYvf3DUDlACMUv2JjV2gdpYC3IbKwhif+
         Z71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367288; x=1788972088;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0zhVxUyRpRhnHXbQLMxjoc4Ys+BN3Anj09sDDnw94v8=;
        b=gxGMQCdGc7SbeEyUSurzYMsl1/Hr5nZ4sxAR9cr3V+08YdD87jZIsalBX6azMO7oo4
         O2hwCBvs/Qf1N+9nl0Fi/DnlKxWEaGlIld8B1gHNIq7Yi63IvxwUZt/IqnYK15YCXAfQ
         1yAlhdKd6zN5rH03+exl6JjYMLVSzbWRipfRi/gSciOXAINd2dlkrXyZgEFqFs//cipo
         UKO52UonNkjPsdvNT9L4h+i0WX0gE71uAUOymGBtVEL+vmmqlgZFzRmDqmUh66ABsJmb
         7cvnZm3AxHqTJvlKVifN3OVDcDgfsJzYQfw1oi7wIB2tHyynfJJ0ZaJgJXOv780zKEFB
         Lr+Q==
X-Forwarded-Encrypted: i=1; AKwUvByNxMf1s6i/Db6m5D0Tf4sW7ox3yJM1s+Gno21RfLrlBbVkQUvIyKCVSgoiK1OayRWsOmiJ4JE=@lists.linux.dev
X-Gm-Message-State: AFuF++ltfI0WSj8vylqdJPPyfVzNHdKWlGRJ0Pdh2cdL+v7FjxokHuZQ
	fsqSiGWTTi8elzeDdqIxiJlgBkyW5j2q81xMkpxEmAchgJ7iHbLOfl5L3vNq/c/NgzIIvnYngty
	JPwUAoA==
X-Received: from pgbd10-n1.prod.google.com ([2002:a05:6a02:64ca:10b0:cc4:2728:8938])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f82:b0:3cc:2552:ddd7
 with SMTP id adf61e73a8af0-3d9adaba731mr8793167637.5.1788367287815; Wed, 02
 Sep 2026 09:41:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:06 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-4-seanjc@google.com>
Subject: [PATCH v2 03/20] KVM: selftests: Use vm_alloc_page_table() to
 allocate LoongArch page tables
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
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Now that LoongArch uses KVM_GUEST_PAGE_TABLE_MIN_PADDR for its page table
page allocations, use the common vm_alloc_page_table() instead of open
coding the same.

Opportunistically drop the assert that the allocation succeeded, as the
allocator itself guarantees success.

No functional change intended.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/loongarch/processor.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 057a77713542..fcd41bc6fbda 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -56,9 +56,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	child = table = 0;
 	for (i = 0; i < vm->mmu.pgtable_levels; i++) {
 		invalid_pgtable[i] = child;
-		table = vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				vm->memslots[MEM_REGION_PT]);
-		TEST_ASSERT(table, "Fail to allocate page tale at level %d\n", i);
+		table = vm_alloc_page_table(vm);
 		virt_set_pgtable(vm, table, child);
 		child = table;
 	}
-- 
2.55.0.966.g6673acef38-goog

