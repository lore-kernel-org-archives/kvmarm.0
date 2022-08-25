Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314FAECAAA2
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 23:25:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD8C4E22C;
	Thu, 25 Aug 2022 19:25:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QnkuooF+kvWu; Thu, 25 Aug 2022 19:25:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A34574E243;
	Thu, 25 Aug 2022 19:25:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4379D4E224
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 19:25:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v7ZeTKFpFQDc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 19:25:39 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C45924E24D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 19:25:35 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 z18-20020a170903019200b00172dd6da065so78563plg.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 16:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc;
 bh=wdNV3+ho8idBWBHEEqE6kDcvd40fMYS/EbUHyIfKU5Q=;
 b=CKYBiYHJ82pvfrOtFxkSctUztyjBv9QzfL1QBjz6wSUJxFTA8yh9SzsSFGbntnf4od
 F/Oat7ZSbk5gO/5Gc4ghTVtAXAApqJC9rLu13N1YWI6pUNXE5G7grgUuQ8eC2Vi3MT+m
 rNe8mKwzTjUCNqf9bdnIBNXlIbKc1pCjgLRoeUkTKm3Fi9lyT0BhXoKg1lBBytmPTewf
 tWwG953CduQlb5wTuKMWnx98K1AENt6ZHvnWASztowlf5Au9swQHbjSJXKVxEZBn3VeE
 d84id4aNO9q2L/4a4LXD0Ox2bh9l7so+brK3JthsVa+Sap3JQnnZZhuXUFLQKGwAz6AU
 aGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc;
 bh=wdNV3+ho8idBWBHEEqE6kDcvd40fMYS/EbUHyIfKU5Q=;
 b=kEqyTEpoFBaMxdcTbp+G8YAJbF0PDS88dy1nc2ASlf+A3H4auzAja2Vewy6Esdb1AD
 AbyKa9OLyUfXJhpgfZjNs5UpGmRk/yi/hLivVrGeYEC8JbYlX5AAfjD7zEapylemwEfD
 rptcj9XE1FbRJpiIGjoAiNSPKS2VADeKNfsLziDqSfLdmdvH5HOKlZiaymCGV5vFhomf
 fFwN6NS6/gko5b5tzxizusefaQh5m4uaVsHfEyAC04oUceXyKRBAuCvP2lQpErAePHgJ
 2aoaIxf39m5hixMS8bxdlHsaUwVaJDIqkgNZkIGtYGUxCo2O1HormXIL3RQ212SQBfKy
 Lfng==
X-Gm-Message-State: ACgBeo2+/fZEuAvH5CCitl1JgPjSuNj8XmXUOG4uj/APK6NCbR27XSFP
 DnfJKLeYGXhKPCe6Xb180tw51w+quAg=
X-Google-Smtp-Source: AA6agR7i+ffJeGpr9+4H53W6fHkE29qzEvwZt9BQq1rOlKBXsxs1PkrupmUW6HxqMLCe/4BQMYmFP7WNDK8=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4c92:b0:536:ac94:e8b0 with SMTP id
 eb18-20020a056a004c9200b00536ac94e8b0mr1327350pfb.13.1661469934983; Thu, 25
 Aug 2022 16:25:34 -0700 (PDT)
Date: Thu, 25 Aug 2022 23:25:21 +0000
In-Reply-To: <20220825232522.3997340-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220825232522.3997340-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825232522.3997340-7-seanjc@google.com>
Subject: [PATCH v5 6/7] KVM: selftest: Drop now-unnecessary ucall_uninit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, Andrew Jones <andrew.jones@linux.dev>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Drop ucall_uninit() and ucall_arch_uninit() now that ARM doesn't modify
the host's copy of ucall_exit_mmio_addr, i.e. now that there's no need to
reset the pointer before potentially creating a new VM.  The few calls to
ucall_uninit() are all immediately followed by kvm_vm_free(), and that is
likely always going to hold true, i.e. it's extremely unlikely a test
will want to effectively disable ucall in the middle of a test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c       |  1 -
 tools/testing/selftests/kvm/include/ucall_common.h |  6 ------
 tools/testing/selftests/kvm/kvm_page_table_test.c  |  1 -
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    | 14 ++------------
 tools/testing/selftests/kvm/lib/perf_test_util.c   |  1 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |  4 ----
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |  4 ----
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |  4 ----
 8 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 583b46250d07..d418fef1653b 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -809,7 +809,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	free(bmap);
 	free(host_bmap_track);
-	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 8077a6d8b1ba..2662a4352a8c 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -25,7 +25,6 @@ struct ucall {
 };
 
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
-void ucall_arch_uninit(struct kvm_vm *vm);
 void ucall_arch_do_ucall(vm_vaddr_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
@@ -37,11 +36,6 @@ static inline void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	ucall_arch_init(vm, mmio_gpa);
 }
 
-static inline void ucall_uninit(struct kvm_vm *vm)
-{
-	ucall_arch_uninit(vm);
-}
-
 #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
 				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 20533c48ba3d..d77b1f634f29 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -416,7 +416,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	TEST_ASSERT(ret == 0, "Error in sem_destroy");
 
 	free(vcpu_threads);
-	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 1c38bd260f90..21d73afcb14f 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -12,23 +12,13 @@
  */
 static vm_vaddr_t *ucall_exit_mmio_addr;
 
-static void ucall_set_mmio_addr(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-	vm->ucall_mmio_addr = mmio_gpa;
-
-	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gpa);
-}
-
 void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 	virt_pg_map(vm, mmio_gpa, mmio_gpa);
 
-	ucall_set_mmio_addr(vm, mmio_gpa);
-}
+	vm->ucall_mmio_addr = mmio_gpa;
 
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-	ucall_set_mmio_addr(vm, (vm_paddr_t)NULL);
+	write_guest_global(vm, ucall_exit_mmio_addr, (vm_vaddr_t *)mmio_gpa);
 }
 
 void ucall_arch_do_ucall(vm_vaddr_t uc)
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 5161fa68cdf3..78e5be2c7f1a 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -217,7 +217,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 void perf_test_destroy_vm(struct kvm_vm *vm)
 {
-	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index c58ecb8a0981..78acdb084ab0 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -14,10 +14,6 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 208f0f04299b..cbee520a26f2 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -10,10 +10,6 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index 016a0487cf72..eb8bf55b359a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -12,10 +12,6 @@ void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 {
 }
 
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	asm volatile("in %[port], %%al"
-- 
2.37.2.672.g94769d06f0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
