Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEC13911C6
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785529; cv=none; b=Kn3zo3KDpnXfbgCW0cdmExlefVZveAQkXBg6MUtfV7kd2AFcbUmoWIZWvyxLkU7Q6Z7uyzNO9lYqlRS6OIM7Wb1mRszqtHPWPNeltvJrxmRY4tvluhC2eQW2k2iGzLgoEdG4VFFi7JaAIhCe1/796iDOZtYDLG4VsQ8gSuZKFXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785529; c=relaxed/simple;
	bh=m3Lp8WMJLB/tampmgFN8ph5luv5ZjkhRNjnxAVae4ys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F902wPP0KxXRevA/ZXhyvcLwXySlo03b29GMbFaEE7d9U8uBvQanDaIPAWMKW/UJEbkn1JjrxnwRGVPTZn3LjMkLaQwf1Xk5w/EAo8tOU0qtOnwkCKF64DN1BbjEIP8IhmFuPXS9xk6a8Dk2lj1mu9lw15VLTKmB19k624j9Hck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ictt+ncy; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ictt+ncy"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c85798977dcso2110346a12.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785523; x=1788390323; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ypnv5ADnidmiHmk4i8NjwAmXQS3vAgk870JArYSva+A=;
        b=Ictt+ncyFhq0rhgS1qr4JL5jyrbsjgkLUj0iyzMAWzVw301O/C79Bg4iCE/arGGY9W
         GhVy1Db8qDJtm6IJydc0S/UUquLYzQoVt5tH+2DLV+V3GGxu3ux9fmJ33uB3pcGRu4wY
         6Ifqya2naXq45hn5X5UtQi4i5FY6RCSOB3lq1ZH8W2Jc8VhOQLbItHXcqJfnjO/Q7IU1
         pe/DJ5giTr+j5kztyKIyMMUH0KER4bCY/2lbq7t5IzeImjLVZyzLU7AdaKm0WPGajVqg
         i/gf38/rl3qMYAOIdzTgLiAcXgs7ITOIBNwYakWEY861mCsJ8rAIzwmD0UvNcH11EadA
         5ipQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785523; x=1788390323;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ypnv5ADnidmiHmk4i8NjwAmXQS3vAgk870JArYSva+A=;
        b=ODx9G5XCeyn8uaV78DZhB5nwPmSuIsbHqBjkeWGuuA4HIhwigAs01gzv0HomDzCho8
         KoaS21Gkz61Gn3bihYiYhS0c3oNOJVKbtH8opIxTlF65FnxK3nlQN1xFk/rXDqwyoyOc
         Zw1seNoPes5c/KSiqPs0TVRFFNK873BJDufKImYAcFe9yX9kVWnlrDiIXjGmk0+6rLqW
         ITtoIUVIrdgpyMZmKEad0EAMPQelVFDiTikCtyOdZp8J5ng7hLYsqMt8YxwJZPm2dKLW
         PQaPuTcDjRM8jqONT1r7/gs3GFkPgHIARhrb6AC8LKfszF4Y3EsboF8m5h5Nh2DXHtz1
         mtwA==
X-Forwarded-Encrypted: i=1; AHgh+Rqb5eon79k4lkmlBIx0/JdTYFOxMUih/kEijhSsEr9+tYAlhc4geH1+kFg03Qx+Nmnv3GWJRe0=@lists.linux.dev
X-Gm-Message-State: AFuF++kPOFasSUnehzZ9bU5P2sAZsUfbEC3iR4XOMll+9ZoQB9xhMZOm
	7VJKcGJ8hogq0IZ5U7XdfuVmnlS5IV51xfDCu5maEJi+hN1vfKNOotkLrxCij35zy8Akq/UyeiU
	pJhuB1Q==
X-Received: from pghz21.prod.google.com ([2002:a63:e115:0:b0:cbe:ddc9:c670])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a110:b0:3c3:33df:4d9a
 with SMTP id adf61e73a8af0-3cf7596a65cmr18790428637.1.1787785522980; Wed, 26
 Aug 2026 16:05:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:57 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-7-seanjc@google.com>
Subject: [PATCH 06/20] KVM: selftests: Extend page allocator to support
 naturally aligned allocations
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

Extend the page allocator to support naturally aligned allocations, as some
flavors of PowerPC page tables require multiple guest pages per table, and
those tables need to be naturally aligned.

Take care to align the potential base address *inside* the retry loop, i.e.
the base needs to be (re)aligned on every attempt.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index b1c5597b1def..96c8251c224a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -991,6 +991,8 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 const char *exit_reason_str(unsigned int exit_reason);
 
 gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot);
+gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
+			     u32 memslot, bool protected, bool naturally_aligned);
 gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 			   u32 memslot, bool protected);
 gpa_t vm_alloc_page_table(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bbf6d7684c0c..896da440659e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -17,6 +17,7 @@
 #include <sys/stat.h>
 #include <time.h>
 #include <unistd.h>
+#include <linux/align.h>
 #include <linux/kernel.h>
 
 #define KVM_UTIL_MIN_PFN	2
@@ -2032,9 +2033,10 @@ const char *exit_reason_str(unsigned int exit_reason)
  *
  * Note, success is guaranteed!
  */
-gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
-			   u32 memslot, bool protected)
+gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
+			     u32 memslot, bool protected, bool naturally_aligned)
 {
+	size_t alignment = naturally_aligned ? nr_pages : 1;
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
 
@@ -2051,6 +2053,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 
 	base = min_gpa >> vm->page_shift;
 again:
+	base = ALIGN(base, alignment);
 	for (pg = base; pg < base + nr_pages; ++pg) {
 		if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
 			base = sparsebit_next_set(region->unused_phy_pages, pg);
@@ -2077,6 +2080,12 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 	__builtin_unreachable();
 }
 
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
+			   u32 memslot, bool protected)
+{
+	return ____vm_phy_pages_alloc(vm, nr_pages, min_gpa, memslot, protected, false);
+}
+
 gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot)
 {
 	return vm_phy_pages_alloc(vm, 1, min_gpa, memslot);
-- 
2.55.0.887.g758fc8c411-goog

