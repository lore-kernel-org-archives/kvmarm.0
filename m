Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78174ACC76
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367296; cv=none; b=DH3H1uZmOkSsQ+8i9nRNTlOHHtSZN4sGv4+W9bNIHohIXSuAmZ5JTP51rwBFRGjdVXEIVgpJ4PRZE7I9P10H1wF0OpTok+TAF0JKX3nRobphPDmD2vNVVv6eM9fPhvgXwjO2Y3MUnNDe65QQtMdnU0yRdkceS6AqyIBlj/b06KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367296; c=relaxed/simple;
	bh=sdY9q2BfDSeykJcP8/5Cy+uZ5jMK/dC9tNYwEHAyn2Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NNJmmsD2zDGkmyEyA3CdfM1rt992p4ejI3kpiSDdlka4yba3uLEjzCZbEmu8jZ3oxQQLagv8NFxQ+/GbqBLJ40+C+0Sz4mJ7o0XN0PbO7fJpkfJy1Wu6vn9rxc6fEGQjT6FTFMwooub9DZQsDtp+Tbn0HNrazvQQuKjJpcasLTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FQUOiJgZ; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FQUOiJgZ"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-396b9ef3070so2245192a91.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367291; x=1788972091; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wh/M14gjNPKIhJHces0NPAZ6Z3gj1daHrmdTKDJlvdI=;
        b=FQUOiJgZhqypHqL9DeSnc6Z+uhvZ5mpDCNnE9akBBLd6NGP067BBsaim6FPhjQeRZU
         sRxk1Q++yHWHWUqRu37O2sUGMh6mZB6LWgHag4e8xgDLqvcYxdFMwfil7OpHPL+bxryC
         1ui8d+11NcSEnHZOc7eFxd6ov8spDfR3E0Qbr+RKm4W7ldrFzD45ytUmn2ETitukm6T1
         8sL+vGvBnadJXnwlItO2E1eKIRPiUEM34p+mRsu0OiLR9vkY/kgX2rkxZH+vtM0O6s9Y
         7vfVGcDUd8X5hDypf/khXfr3LP5zRynyNt6kLUuW9TrJhPXjB+4sJbE9QFx3vVPDF6hv
         DJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367291; x=1788972091;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wh/M14gjNPKIhJHces0NPAZ6Z3gj1daHrmdTKDJlvdI=;
        b=Q1k5q52f7xSNBd9BUgDgLQJjbsrkFnZKUOHpfCY078fNi49kccSgmCEnrqz5Rdd0Vm
         1INEt26ZTuhdvtMBFdJO4AuT1PO6I+1eqAbpoIKuPxvY1gieCTMATyV5ycskt/S38Kds
         RyaMV9gWicsnh8XqGorwDnpVo+53FlV5yFUT9P99/ODaIZ4RNYLgopcoOLqDQJ5Ty8Er
         gnLzsijN1qeNhtP5B1qCeixA/4tQRH2LD7sJxtu7PPJa6JyriJ1FO3b5bH+SjaOZ/sNk
         Vt9BymqtEYunlfZxwPHZkt6mhgfd2Wpj5PP5b3ZB6UHJN23Nh0Vmn/5iMyr0t2hPaK/g
         P6Og==
X-Forwarded-Encrypted: i=1; AKwUvBwfxENZcU2H42/Rhd+pFmmhe9pomAH/xzMOcPc1mD0bJXMHAX5o6eAV/H/IymhBKLVVOIIWZ0M=@lists.linux.dev
X-Gm-Message-State: AFuF++lfB3FSMoynyJZjkNmU/DLyKN75gAhA3X0RrcN9unk1BsWu4E50
	5SqtV8cB6EE8L7gferEzOy0cymT1B1oX3XJYgIGk6waK98PKpcKa0SRpEjhfDUzZxKVsq45Zec4
	ZXoZE2A==
X-Received: from pjbbt18.prod.google.com ([2002:a17:90a:f012:b0:396:5f0e:9c23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c52:b0:38e:6aa7:68ad
 with SMTP id 98e67ed59e1d1-39aedf7c6aemr8714453a91.5.1788367291013; Wed, 02
 Sep 2026 09:41:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:08 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-6-seanjc@google.com>
Subject: [PATCH v2 05/20] KVM: selftests: Use goto instead of do-while to
 retry finding unused physical pages
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

From: Nicholas Piggin <npiggin@gmail.com>

Rework the core loop of the physical page allocator to use a goto instead
of do-while loop when retrying with a new base address.  The do-while loop
obviously works, but it obfuscates the success vs. failure paths, and in
general is convoluted.

For all intents and purposes, no functional change intended.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[Rebased to latest mainline tree]
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
[sean: separate from alignment change, use enomem label, write changelog]
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 32 +++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b071d77dd301..bbf6d7684c0c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2049,23 +2049,15 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 	TEST_ASSERT(!protected || region->protected_phy_pages,
 		    "Region doesn't support protected memory");
 
-	base = pg = min_gpa >> vm->page_shift;
-	do {
-		for (; pg < base + nr_pages; ++pg) {
-			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
-			}
+	base = min_gpa >> vm->page_shift;
+again:
+	for (pg = base; pg < base + nr_pages; ++pg) {
+		if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
+			base = sparsebit_next_set(region->unused_phy_pages, pg);
+			if (!base)
+				goto enomem;
+			goto again;
 		}
-	} while (pg && pg != base + nr_pages);
-
-	if (pg == 0) {
-		fprintf(stderr, "No guest physical page available, "
-			"min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
-			min_gpa, vm->page_size, memslot);
-		fputs("---- vm dump ----\n", stderr);
-		vm_dump(stderr, vm, 2);
-		abort();
 	}
 
 	for (pg = base; pg < base + nr_pages; ++pg) {
@@ -2075,6 +2067,14 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 	}
 
 	return base * vm->page_size;
+
+enomem:
+	fprintf(stderr, "No guest physical page available, min_gpa: 0x%lx page_size: 0x%x memslot: %u\n",
+		min_gpa, vm->page_size, memslot);
+	fputs("---- vm dump ----\n", stderr);
+	vm_dump(stderr, vm, 2);
+	abort();
+	__builtin_unreachable();
 }
 
 gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot)
-- 
2.55.0.966.g6673acef38-goog

