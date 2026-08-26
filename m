Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CB43CB8E2
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785532; cv=none; b=b4SlIoaa5AyRuZYPujO6+5QK38N5v0lM38vJmksUOU/C/M3ZP8eia34/4QXhdJVhjMeVnf+3YwDtU8hsMLLF/kRcAlwYRdpPAIFGnNYQffzDnZXfJ6VpWnLfsvBwmS6KxN3MDEIc6qLIi0vaKRsCU0J2oVCm6ISyG7JwZp9inTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785532; c=relaxed/simple;
	bh=2YaoAsq23eoCnu/IpgcXayUjh+EDns6Bt+cLNLec880=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eM1Cb0XaKPesy7yG3KpfePYG9MgvIQqDDYzh2txJrQvwGDPzl2AjO1mnBxLFFHzNdp5WCMxRK4wGrARYKTVHEqm5TZqNQ/7q94JRjlsp0MKr/4jqIFdS1+sR4UyK8El18pQMg84sfi4oU8ifb/G3iIgHqsqVj8/qyLC1baCrWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CdABeQBN; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CdABeQBN"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1c18c775eso410643a12.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785530; x=1788390330; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=N89bCfABJreQrIt289fAG+G+a6K8qwfLKTGSVLeSHrg=;
        b=CdABeQBNwNL35P9EOq32mWmk4gyOvzaWc5omhrLrkgvt7X9TrujtEmPXpaNbl0Cgjw
         m9UED8qx1Gh3IDaEp4Lr4gDIuuYhWiM3txdYofT3tATQXpOzvtZSrzHB0xN+U46/G3a1
         kiV1BMqSXQMa3hJDm1bj7R0pIuwtJ8wNp5c1Sz+j4kXSAaDrD8PLHECDb29XVl8iMBaq
         H1M32Iw8fSmbA2Ty90t5SUNWrlDfYeBYFw5aQdtfS8XPsElAig2Xm13SUIGEc18/Kgbf
         TfzXlmD5aAulpEUBeXvKIuouszQ7AfoAPzlwRtbwN8AZ0baZ3fae8GxTCbmZqjiGRDMP
         MYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785530; x=1788390330;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N89bCfABJreQrIt289fAG+G+a6K8qwfLKTGSVLeSHrg=;
        b=Pa37Aq/qpydcWeofHQ1rHmBEiWnhgif6VraJoim6ALrIACbwIiKfwcrPjdyzlgKwBE
         YTYbBpSUMsOpjAHqO67Qo4pGFS8X2YvOmuLxIKeIQnla2pOcvmR8ZpCSmgxfEGa1Ac4R
         DF8Wc1Y+WSObU+VUXWyykTe1J/IkRmqroJ9yb1eEw1uhifDqen5QE5Z7gHLd+7vIQK1g
         OKxDuabV7w6/vqlaE9XyhxH7vOBq9T8o1s7fjv5cawyECC9/RiZmp0dnGYbhZF5MnICt
         BFfpqCaKHiAmePNOKpVXcJv66KxTCSFt4WcVg/DNBLDVniERmtvsrvx7xIe37wOtOLNi
         QIYA==
X-Forwarded-Encrypted: i=1; AHgh+RpENNaN4Kqvz//ymx2lDKp9Z/24U7zLFAQ5Ty/WdaP2vSkcEGLLoHHkYS9JEFQsWrsNawDFufs=@lists.linux.dev
X-Gm-Message-State: AFuF++kcjDiAM+Jn1QCc4LhDAEDcOnjscRTWi0aQMu0EEa1/Pbi9mXYo
	0pW/tlatLNmgIb/9WjQ04H13+rEHc8tUreMRBcIHuDjwE12Uj3Qf9nddTlXHhKiMZh8nzOZ+g91
	EApI4pA==
X-Received: from pgkj19.prod.google.com ([2002:a63:e753:0:b0:cc1:517a:d29])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4388:b0:3b2:8674:9830
 with SMTP id adf61e73a8af0-3d0f6d2abaemr2865141637.14.1787785529701; Wed, 26
 Aug 2026 16:05:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:02 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-12-seanjc@google.com>
Subject: [PATCH 11/20] KVM: selftests: Initialize vm->memslots[] with invalid
 memslots during creation
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

Initialize vm->memslots[] with an invalid memslots value during very
initial VM creation so that failure to configure the core memory regions
generates an immediate assert instead of potential weirdness, e.g. if slot0
is coincidentally valid.  This will also allow hardening the region APIs to
guard overriding a region's memslot multiple times.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h  | 2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c      | 5 +++++
 tools/testing/selftests/kvm/lib/x86/processor.c | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 21354434de0a..70e77992dd2f 100644
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
2.55.0.887.g758fc8c411-goog

