Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2CC0C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Oct 2022 00:34:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B4614A49C;
	Wed,  5 Oct 2022 20:34:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rTXV0qPTF7NY; Wed,  5 Oct 2022 20:34:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 413014B0E6;
	Wed,  5 Oct 2022 20:34:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD5A49EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Oct 2022 20:34:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id riMv5EnaqSEI for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Oct 2022 20:34:24 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 20E8E49673
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Oct 2022 20:34:24 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 t7-20020a62ea07000000b005619a832f68so237856pfh.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Oct 2022 17:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=eUXWhUifdFgPJT3sQ8fpiBb9+qu4qBNF8BnbaeQdQUo=;
 b=p2BatyqMgXXkXbOjvLhV7fxp0EF7XWicDzfoMUNR41CezxoLYz18bZIGEDY2zV8hYn
 JJg6vZyzvDWSfJtlIHvDh3gA14Cefb/4Gpkm51svaI2lZ37gv5+aR5MinucRDoTw6MdO
 YUb9zARhBKxZe4Dz0TIb5chOmV9/7eHayMK0DSYMsbM44+4KauUiOJwG2P5IDMmCHswp
 pxqTs2lVNBzva+uy8Ftf8XHoHzWP9ri+2hOnO9vmijy2lTqWpgs5w/CTQcbU2UnKdDmJ
 UjUApQiqkhvk/9DkTlJKAutOFtZuaYi9VyIJZkMo0cl/zBHBYVOnsfHkhbXD+2CiWszM
 xksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=eUXWhUifdFgPJT3sQ8fpiBb9+qu4qBNF8BnbaeQdQUo=;
 b=Mtys3R4L2189/FZMLTV1z0x7Okom0FmcLpIBc8MRldQSf3QN1ACitJBR40FtFFDrPT
 6p3btV1G39HtDgHh5Db2u3FH4dDRZuSBwKUTkxA2Lkq1gZRs/ZR1jN+Ddc/Q52G/ubTC
 5hX5mqhM/NjF0NatbkMs9q1pavRXE7JOMNe24xWNKbUrHMrxupLI/74ybckdJtHDeSXX
 pDUYBcvRPDoGpCKtK3Sj8iVRaHR0PWEDZi8V3FOwDdXTi963mXWvpwOnjs7PaAzJXolC
 cqcgCLhb2tzXrTEiItjR4rRX7triZsPeqlDGjYW96ikX11PqQ6rlytjtLeIx+CD6EsGY
 sVLQ==
X-Gm-Message-State: ACrzQf1hN9JvxYoPC7bzyXmjbiekYiSmYGc+rHJ+nxoc76t3XP4DwZMA
 0s9vC8pI8dXiu5RALkE9nNXzHnwMNgY=
X-Google-Smtp-Source: AMsMyM7UAoMVSHijtFGDsOKK4XAARFhwG5lyokCvp6D5lkB3pZXlx5dzYqQY7QntGmdGYLz1xS0Sr9AZvPs=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8bc5:b0:17f:79f2:21e8 with SMTP id
 r5-20020a1709028bc500b0017f79f221e8mr2202413plo.63.1665016463355; Wed, 05 Oct
 2022 17:34:23 -0700 (PDT)
Date: Thu,  6 Oct 2022 00:34:08 +0000
In-Reply-To: <20221006003409.649993-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006003409.649993-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006003409.649993-7-seanjc@google.com>
Subject: [PATCH v6 6/7] KVM: selftest: Drop now-unnecessary ucall_uninit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>
Cc: llvm@lists.linux.dev, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Tom Rix <trix@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 Peter Gonda <pgonda@google.com>, linux-kselftest@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Tested-by: Peter Gonda <pgonda@google.com>
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
index b458a2701634..a38c4369fb8e 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -811,7 +811,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
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
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
