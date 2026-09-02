Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800284AD4D2
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367306; cv=none; b=Gfjm8EbYM/APi1kR2aSgi90HO4n/wvC4jUuZ82EC1+ezqEM3ExRZfhKlN5q0XEJ9/zA7QSK7FJ/xq2TGFQqeHaw2762a3adOFQgw1lRsuQZZsgSjG59HVP9PQTqwpMfYAQHO1T/EqdPEnqcUrAek6Glu/aZPF41OBUn8YDJadrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367306; c=relaxed/simple;
	bh=IooTrDugbi730db2Qdv2j1/bfHJilOastYDRCxIfQLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PkQAYbjXBFjYWYFmdpzvBBncKVBNDtc5vtiMrnHumeuT+HpDh/30G7ACoXlIZ7DaB4q36UP0hFhCVbl0yFqiRIpZr0rRdpP2wXNxG6UNKAzFNLR7K0wjpb9gmF8Z1MnExS1Z4Eij+i/BxUQ+Ptvs35Sd8j5TU6Bpkj/JVKuHhyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=movAV3YO; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="movAV3YO"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8535cdc2433so37841b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367298; x=1788972098; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OWxwiZu3iI1BKMOXY9Ac60kPARcqOSTNs6vsc+7jhyU=;
        b=movAV3YOik0K87hmIXBSx5HurwfeRzpoJAu0uQgYvgJpu7BO/rSwb1HxVJxV+gvw2D
         OuP43sfPzqd1WCiZhd+2dtWehkVEknVKKHAj2arTIdga9ObybkdADfLY42PPI38iVd2n
         PRDMkBKUpqSjE/FUmY4TrL0q/VKiUlAEaR+BwukNV1OLnG0aTlk8HZfPYg7lxp/H6Ix7
         p77S/oNbXbb3hDMyxyhdaQq6hiGKdH3ivxQAcWQ58zqPxmtOJr5M2LuPU9evu99KzlZ/
         qmmrxMb/wyj2/OJp4wRrMMJJGcet31LI2ItAm+SnSmtawjBwHKTxmcVWykPvXzTuXBRQ
         IWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367298; x=1788972098;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OWxwiZu3iI1BKMOXY9Ac60kPARcqOSTNs6vsc+7jhyU=;
        b=bsbSoEtuQ0/9Ywg7dq2MdtwNAObQXpYmVouHF1FnCLfGPVokU7CFSFShop+22nRvF4
         wPqYu84mLcC4UPjEi24bdvmGRswVxprmSUe/iNZCkYDOMcjL2AgHMhuRflt992A+mUhy
         CCc+cYbkX/YjmLRAX/zH1UESyjWsgwx3q7dgNhy8LrcHFaTOg5rLB8H6TEgK4Vo56R4Y
         E2cR7+czSfL0VxMvWdV+s7COZn5eo1/an8DBtfC9z/tjlsxqUOHUS26TsMU/bLlH8XNh
         ktu/sF61ykwM2XAoAyN9Aj0m6NLf6XwjgDXf6D/01sVvjmCoaoi2n0jfZ6ipZyoCO3bF
         E4Yw==
X-Forwarded-Encrypted: i=1; AKwUvBwGbsUtNuzqYrnwFxf75mUctcBwgZQv7Vhd6ed6Fx+1JZeUdTL2z+ge2De3XaEpGdleM8txIKQ=@lists.linux.dev
X-Gm-Message-State: AFuF++m3KqxaJxnPh5jmrkN21uyA25noGgd94ngZDD8JbSKOSl/prxTm
	VByjRkRRU4FUcQLkKmmw6kDtK0Z36mqbzppmMsWU6QwMHval22m8M8NxADq3a7i61JPFXwkY/+/
	QVdK1Og==
X-Received: from pfbbm14.prod.google.com ([2002:a05:6a00:320e:b0:84c:2e88:693d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d55:b0:84e:cd14:aeba
 with SMTP id d2e1a72fcca58-85ffbe960f2mr374778b3a.6.1788367298091; Wed, 02
 Sep 2026 09:41:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:14 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-12-seanjc@google.com>
Subject: [PATCH v2 11/20] KVM: selftests: Initialize vm->memslots[] with
 invalid memslots during creation
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

Initialize vm->memslots[] with an invalid memslots value during very
initial VM creation so that failure to configure the core memory regions
generates an immediate assert instead of potential weirdness, e.g. if slot0
is coincidentally valid.  This will also allow hardening the region APIs to
guard overriding a region's memslot multiple times.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h  | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 tools/testing/selftests/kvm/lib/x86/processor.c | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c56f342b16fd..304ef6af3268 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -33,6 +33,8 @@
 
 #define NSEC_PER_SEC 1000000000L
 
+#define KVM_INVALID_MEMSLOT UINT_MAX
+
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ce0d8fba4624..56df5b1d9c79 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -288,6 +288,7 @@ __weak void vm_populate_gva_bitmap(struct kvm_vm *vm)
 struct kvm_vm *____vm_create(struct vm_shape shape)
 {
 	struct kvm_vm *vm;
+	int i;
 
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
@@ -296,6 +297,8 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	vm->regions.gpa_tree = RB_ROOT;
 	vm->regions.hva_tree = RB_ROOT;
 	hash_init(vm->regions.slot_hash);
+	for (i = 0; i < NR_MEM_REGIONS; i++)
+		vm->memslots[i] = KVM_INVALID_MEMSLOT;
 
 	vm->mode = shape.mode;
 	vm->type = shape.type;
@@ -1190,6 +1193,8 @@ memslot2region(struct kvm_vm *vm, u32 memslot)
 {
 	struct userspace_mem_region *region;
 
+	TEST_ASSERT(memslot != KVM_INVALID_MEMSLOT, "vm->memslots[] unpopulated?");
+
 	hash_for_each_possible(vm->regions.slot_hash, region, slot_node,
 			       memslot)
 		if (region->region.slot == memslot)
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index d31fa81ea075..ea5fa59888af 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -529,7 +529,10 @@ void tdp_identity_map_default_memslots(struct kvm_vm *vm)
 
 	/* Only memslot 0 is mapped here, ensure it's the only one being used */
 	for (s = 0; s < NR_MEM_REGIONS; s++)
-		TEST_ASSERT_EQ(vm->memslots[s], 0);
+		TEST_ASSERT(!vm->memslots[s] ||
+			    vm->memslots[s] == KVM_INVALID_MEMSLOT,
+			    "Unhandled memslot '%u' for type '%u'",
+			    vm->memslots[s], s);
 
 	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
 	last = i + (region->region.memory_size >> vm->page_shift);
-- 
2.55.0.966.g6673acef38-goog

