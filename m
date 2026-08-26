Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545783DD87F
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785542; cv=none; b=NwYD8THst7Qgu5nEbv6va2s2cnleqlj6XJP+lnBufvvEJ+0pEdRlej9LLhJNDbglz0SBLYsxjgIO2ZeiI23OtdlsHaM/42DavLvDej/nJnwHGsyfm39L3ii08zyNOekZX2jjHdd0f3fYNJ/brZgMg4/CvEfe91C2yAwfh+/ns10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785542; c=relaxed/simple;
	bh=bJoLfA+0qEYrAo6wQU+rvnm+D1emBZbhqzRHzei4wo8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q9/HEEvVzwP+b0BctT9bG9xQkSfSIDF8yAnGIZKNYOVMyyy6T7fKjaA2BX/Qv23UCZVQbZ/R7Q0KfyiMxKOSGoPpPI5ZVPggxVEmoLepxorq10Hy+9hJgd/xKbzZ20sb2LfOBpaA6pV+bufrJa0XG6JaHrg6cEk7kY3tjfXu7fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vKDEdBd2; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vKDEdBd2"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cbedf42f199so1613905a12.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785536; x=1788390336; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=GKwDIzPdhs+/PUMGOrKYMYY0J2+uedR4TSeAqB3q+w0=;
        b=vKDEdBd2ELcAnfb+5zg/12zs7B9WzSXcVG4LdRnPvBwDyuYGIkVaeNUGvpec4IHxkm
         mK4KOU6a1QJEpfdglsjqlOKKK0zb4UOaQhsRl0NttVT8XcsxQvZUFdV8g+MjyNWAChNp
         kPJUJ/L7sxK8Y7vYjcG2/z4BOFF111Wgy/AMNzyvEgua2B/Lk+kDstxmsHyrQJDwYfVA
         dpZXC/fTozF//LcS17tozNPrwNgh+yMc1RUBISlNG45+fD6fnnrwqE3DEBQ20l0oDwgT
         ZXIUNrakZC49utSLClORTDptX8pGMUOOxOh3d/nuex5MI3Osr9yG+pAmoi4SxANpYNDG
         iBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785536; x=1788390336;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GKwDIzPdhs+/PUMGOrKYMYY0J2+uedR4TSeAqB3q+w0=;
        b=AhDkAFTbPDtb2iAdIOaHi0pLH/YMyCZjq2rzl2r6TavULCQuUQX96S1JxmNiYf10nf
         2QW5UWtXfePhhmgvGMV2OOCLMTfMHG3mxCKNwm5R31fUL3w+PwXKQvppm0zhwt8R/LFf
         Lnw40HdI8Iqv1nQJXe6cC96EHRNHbxn4U9cFVQ6kTaN8xGRd9kL1H29mE+8R/wy/aXeP
         aOlS+rcIZqYysFpb3AsXs7GTii4I6APOKEpEZMDrtetOH3gFp6FYIOyyeNI56QthK0X5
         Navu1xM5KO4CcB/kash48Jg3+fpqh4uzFZ050cyLpKFpRxTNZ8KoTBblS2dJd6mdDo07
         rApg==
X-Forwarded-Encrypted: i=1; AHgh+Rprn8rtgO+4JHQh9CalWXNHsHIqLhgrwq5oASk0UUwHH/0+YDWWuI8z3kqnQXnQoINnDMFTf4o=@lists.linux.dev
X-Gm-Message-State: AFuF++lIpbHfrsGunJl9dFn0uXuJrp7SxyGVXyd8KCcBsiu8z+C6UBYY
	U1MCtwIam7wU33AGC6mtRaOLqQz/JieUkvJ3/flYOCF3ani8Og//S6roko0JPgu68xAFFuKgTav
	MgUFnYA==
X-Received: from pgcq30.prod.google.com ([2002:a63:751e:0:b0:cc1:c78b:a2fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4a97:b0:3cc:f0c7:5999
 with SMTP id adf61e73a8af0-3cf84348241mr20316754637.16.1787785535770; Wed, 26
 Aug 2026 16:05:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:07 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-17-seanjc@google.com>
Subject: [PATCH 16/20] KVM: selftests: Use TEST_EXTRA region in set memory
 region test
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

Use the TEST_EXTRA region/memslot in the "set memory region" test instead
of a custom memslot, so that the primary vm_phy_pages_alloc() APIs can be
reworked to take a region type instead of a raw memslot.

For all intents and purposes, no functional change intended, as
vm_override_mem_region() is barely more than a wrapper for
vm_userspace_mem_region_add().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index dffe9654f45b..9d21594e2f81 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -116,9 +116,9 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP,
-				    MEM_REGION_GPA, MEM_REGION_SLOT,
-				    MEM_REGION_SIZE / getpagesize(), 0);
+	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS_THP,
+			       MEM_REGION_GPA, MEM_REGION_SLOT,
+			       MEM_REGION_SIZE / getpagesize());
 
 	/*
 	 * Allocate and map two pages so that the GPA accessed by guest_code()
-- 
2.55.0.887.g758fc8c411-goog

