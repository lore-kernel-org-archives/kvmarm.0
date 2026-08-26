Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F13B777D
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785522; cv=none; b=iujylY2u7KEclku7sdK3bZtmIouuOBkcRp3y1k12YzFpSNJky9QNvWQrhQKGTljMCsNBDOSiG8HZhgVljsRmp/LNgSB8f3RzhsTclITNytY9rQhn1xP3t3CjccwnpbztNkxPMQUxmsdxsankofVveoL5g1By319VJJYdTd1MR68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785522; c=relaxed/simple;
	bh=ihEFNvdsKZLFllAnEFHRtIRIdEUMLnHYDqRmMESDYIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HxO5D3vmZdT1DpjD49KTEAfHeZoZrQoNaPeLviNZKnKMmuP5Sa4kzO6Pc4T+z7ldYZX95n8teA7tu6L+2AhM6IFuJeE3vpXz4yDvrADj/aAltCb7MTG6J0DybqNATeRd/AReGCvFCQIhW5AeqVfYNZauK8wquEdzPlO91+jtVLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PfpY1HM/; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PfpY1HM/"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb6cf425e86so1899314a12.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785519; x=1788390319; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7O76V/eNZATQNVf7YqKvmEoyxMF4aKASfVXbmkJmYVA=;
        b=PfpY1HM/jhwTJHop1Gka6MV8B9XLq46Dg5bxIWqEBtVHgkoYesa6pztaq+NRSJCyIb
         fQxOkUB8saVSqEGEI9Gx3YDCGJwbaaBExfrMMkIof6kIsICot18x4ohJ5lEWlx0eIs6S
         +FgqqHBJj/uqlpCVmcom5B76xRbqyq1H+XKRLM1sTIwpQxBo7HFkHR/wU1qCI954z2xG
         eTqMa0DmAw8RNvV0ijhBHwP/WX8xDDpTLVtWCCsZvZ7R7SY7ch1tvFBeCQlIQlhzwE7C
         OlD2+4DaDd+5iQTASCpwsrL0RlMJCEcKphB/mVK95vs89MZtu60cFQxdS+AlLHt/Srdm
         Nqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785519; x=1788390319;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7O76V/eNZATQNVf7YqKvmEoyxMF4aKASfVXbmkJmYVA=;
        b=Q6pSxqxw986c8ORXs6Y/jRItiApF5tpeDUpCzvPwckTGoi+X47AtOdewrOmqQ5KP0i
         F+raFTbv1Rzb24y2wAq0RaD6cpIES06qHx6SxM0u0pLCuLG4J9wozJNu4SeBSJVCl95E
         NlgC4EE64mCBGgNRI/WemZPYnX925Ih0mfzldR8BCEHCot78hS1NbwV/UWDVT1V5ZR9v
         gnPRQ+DCcULnTH63S6Ujwu72t3dUH6v5y8dbPP2m8RJ6sFJapIMbZUkucjZ82zJOrgjy
         b7t9EPRDxTaI3oa4EbEaD7wO0jEE0maDRry2aNbphp0YRWgci1yx5Wyd3wWqVEmYLolG
         Ctmw==
X-Forwarded-Encrypted: i=1; AHgh+RpY/PUecV0VO7rjTFtJU5XK3u3oMEp3hsL1xgbtT5UL00q9XU5qo+s2UwWrKQ6ySCHd140Ts/4=@lists.linux.dev
X-Gm-Message-State: AFuF++ng16XDyqMIoXVJ9LI28ogkdoPD8xbw8vE9Za8g50Xpyn1MR7cL
	8jX5uw2WYrnu4MGG3BROp86pwSw1/I7lles43cM98lloUImaWswPIt/Hi/UrdFaLznc6InKCq0E
	4HvbSbw==
X-Received: from pgby7-n2.prod.google.com ([2002:a05:6a02:6507:20b0:cbe:9dc7:9ee8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6f03:b0:3cd:9f0b:f788
 with SMTP id adf61e73a8af0-3cf83d1ef40mr22810769637.12.1787785518656; Wed, 26
 Aug 2026 16:05:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:54 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-4-seanjc@google.com>
Subject: [PATCH 03/20] KVM: selftests: Use vm_alloc_page_table() to allocate
 LoongArch page tables
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

Now that KVM_GUEST_PAGE_TABLE_MIN_PADDR == LOONGARCH_PAGE_TABLE_PHYS_MIN,
use the common vm_alloc_page_table() instead of open coding the same.

Opportunistically drop the assert that the allocation succeeded, as the
allocator itself guarantees success.

For all intents and purposes, no functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/loongarch/processor.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 47bbde3e205a..fcd41bc6fbda 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -9,7 +9,6 @@
 #include "processor.h"
 #include "ucall_common.h"
 
-#define LOONGARCH_PAGE_TABLE_PHYS_MIN		0x200000
 #define LOONGARCH_GUEST_STACK_VADDR_MIN		0x200000
 
 static gpa_t invalid_pgtable[4];
@@ -57,9 +56,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	child = table = 0;
 	for (i = 0; i < vm->mmu.pgtable_levels; i++) {
 		invalid_pgtable[i] = child;
-		table = vm_phy_page_alloc(vm, LOONGARCH_PAGE_TABLE_PHYS_MIN,
-				vm->memslots[MEM_REGION_PT]);
-		TEST_ASSERT(table, "Fail to allocate page tale at level %d\n", i);
+		table = vm_alloc_page_table(vm);
 		virt_set_pgtable(vm, table, child);
 		child = table;
 	}
-- 
2.55.0.887.g758fc8c411-goog

