Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2410C43219
	for <kvmarm@archiver.kernel.org>; Sat, 19 Nov 2022 01:35:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FA0F4BB54;
	Fri, 18 Nov 2022 20:35:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1JrBl2kqmzDB; Fri, 18 Nov 2022 20:35:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4884A4BB8D;
	Fri, 18 Nov 2022 20:35:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6824BB4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5em4DSWxAMDM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 20:35:04 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B51154BB57
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 20:35:03 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 b13-20020a056a000a8d00b0057348c50123so1093153pfl.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 17:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=yrZp0Djf+nyn4dNgeVKpvxujZLza+5E14t16z5zmdQE=;
 b=GfhP7WVWA+MYs6WFdLXnOeFZv+EFlcBt9kUtLrizDVaNbbbRf+/hIQHM4mpfquOA2+
 etvmV4c5QMeLYA4HWv+3abWSna8UbhMZ5gnofZtt5cMW3uCwav0Vah3EfL1P69WtEOkh
 lNjWaDtI3rsomxW+cDzLIRNuWP9Nh9xkOAbHBolIJxm4bC+eDDAGhq6o6YsNoSo4Nl/y
 HvX50Vmi36E89jR0fyzcYpwnFWzwSoQieDiEDhejLlS7jB4bv08nyZznLcB4JrzMp5Mh
 F/G3B24MJR49AUAJ2TeBjEAt+tZPNfxObTq+bg7i/LNG/Ck/WoibSz1qBxwFnJo3MGuf
 XH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=yrZp0Djf+nyn4dNgeVKpvxujZLza+5E14t16z5zmdQE=;
 b=uId8bBR4esRc7XO/lKpPVjaLFKXqKfDI92HOyyKsPcsW7BL3Zu2At7a1gBKX/GWe6g
 RhoQt2PjY32Y2G+IvUZgB/NBhOXUSf8t/v18/SlkyX0QXqAo1ndrNUGmT7PBYiPZD7WN
 5H2fJaKMJlgfOdD0lVSDLlTB7RGWvj3sSuTU42hjtfLE38Q/tVYnJzfTeFP72y0PRsrS
 XIP4sA/6yQiqEhLfPRZdpRiN8moaNIIIsKBJOtAlgnxxTrNvIwrkIcSxvyR2ncz+JyrE
 kG+MqYyaBCj3N+/96oW5dEfx9sF819afdtLBuo+A0C4Isfz85LCO82fT5fXVb2DtN5oS
 rooQ==
X-Gm-Message-State: ANoB5pmZa33T6VsDgAL6gSBjJyT8ucw3ZeZVgli2t6LOrxF1x+4JCFgM
 PtK/RkmkjHGIW5uoj27GalHZP4daNw8=
X-Google-Smtp-Source: AA0mqf4F7zjmekYcCzO9zVxMtoWH8+ZW/nRPfBpqtmz4TLB8swAWq640uipjbD7rRbzs391daM0nYXErtD0=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:48c8:b0:213:2912:7a28 with SMTP id
 li8-20020a17090b48c800b0021329127a28mr10482060pjb.51.1668821702989; Fri, 18
 Nov 2022 17:35:02 -0800 (PST)
Date: Sat, 19 Nov 2022 01:34:47 +0000
In-Reply-To: <20221119013450.2643007-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221119013450.2643007-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221119013450.2643007-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: selftests: Use non-atomic clear/set bit helpers in
 KVM tests
From: Sean Christopherson <seanjc@google.com>
To: Yury Norov <yury.norov@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
 kvmarm@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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

Use the dedicated non-atomic helpers for {clear,set}_bit() and their
test variants, i.e. the double-underscore versions.  Depsite being
defined in atomic.h, and despite the kernel versions being atomic in the
kernel, tools' {clear,set}_bit() helpers aren't actually atomic.  Move
to the double-underscore versions so that the versions that are expected
to be atomic (for kernel developers) can be made atomic without affecting
users that don't want atomic operations.

Leave the usage in ucall_free() as-is, it's the one place in tools/ that
actually wants/needs atomic behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |  2 +-
 tools/testing/selftests/kvm/dirty_log_test.c  | 34 +++++++++----------
 .../selftests/kvm/x86_64/hyperv_evmcs.c       |  4 +--
 .../selftests/kvm/x86_64/hyperv_svm_test.c    |  4 +--
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index f2a96779716a..26556a266021 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -222,7 +222,7 @@ static void *test_vcpu_run(void *arg)
 
 	/* Currently, any exit from guest is an indication of completion */
 	pthread_mutex_lock(&vcpu_done_map_lock);
-	set_bit(vcpu_idx, vcpu_done_map);
+	__set_bit(vcpu_idx, vcpu_done_map);
 	pthread_mutex_unlock(&vcpu_done_map_lock);
 
 	switch (get_ucall(vcpu, &uc)) {
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index a38c4369fb8e..a75548865f6b 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -44,20 +44,20 @@
 # define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 # define test_bit_le(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
-# define set_bit_le(nr, addr) \
-	set_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
-# define clear_bit_le(nr, addr) \
-	clear_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
-# define test_and_set_bit_le(nr, addr) \
-	test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
-# define test_and_clear_bit_le(nr, addr) \
-	test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
+# define __set_bit_le(nr, addr) \
+	__set_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
+# define __clear_bit_le(nr, addr) \
+	__clear_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
+# define __test_and_set_bit_le(nr, addr) \
+	__test_and_set_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
+# define __test_and_clear_bit_le(nr, addr) \
+	__test_and_clear_bit((nr) ^ BITOP_LE_SWIZZLE, addr)
 #else
-# define test_bit_le		test_bit
-# define set_bit_le		set_bit
-# define clear_bit_le		clear_bit
-# define test_and_set_bit_le	test_and_set_bit
-# define test_and_clear_bit_le	test_and_clear_bit
+# define test_bit_le			test_bit
+# define __set_bit_le			__set_bit
+# define __clear_bit_le			__clear_bit
+# define __test_and_set_bit_le		__test_and_set_bit
+# define __test_and_clear_bit_le	__test_and_clear_bit
 #endif
 
 #define TEST_DIRTY_RING_COUNT		65536
@@ -305,7 +305,7 @@ static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 		TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
 			    "0x%llx >= 0x%x", cur->offset, num_pages);
 		//pr_info("fetch 0x%x page %llu\n", *fetch_index, cur->offset);
-		set_bit_le(cur->offset, bitmap);
+		__set_bit_le(cur->offset, bitmap);
 		dirty_ring_last_page = cur->offset;
 		dirty_gfn_set_collected(cur);
 		(*fetch_index)++;
@@ -560,7 +560,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 		value_ptr = host_test_mem + page * host_page_size;
 
 		/* If this is a special page that we were tracking... */
-		if (test_and_clear_bit_le(page, host_bmap_track)) {
+		if (__test_and_clear_bit_le(page, host_bmap_track)) {
 			host_track_next_count++;
 			TEST_ASSERT(test_bit_le(page, bmap),
 				    "Page %"PRIu64" should have its dirty bit "
@@ -568,7 +568,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				    page);
 		}
 
-		if (test_and_clear_bit_le(page, bmap)) {
+		if (__test_and_clear_bit_le(page, bmap)) {
 			bool matched;
 
 			host_dirty_count++;
@@ -661,7 +661,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				 * should report its dirtyness in the
 				 * next run
 				 */
-				set_bit_le(page, host_bmap_track);
+				__set_bit_le(page, host_bmap_track);
 			}
 		}
 	}
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
index ea58e5b436e8..ab51865c80be 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_evmcs.c
@@ -142,7 +142,7 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
 	/* Intercept RDMSR 0xc0000100 */
 	vmwrite(CPU_BASED_VM_EXEC_CONTROL, vmreadz(CPU_BASED_VM_EXEC_CONTROL) |
 		CPU_BASED_USE_MSR_BITMAPS);
-	set_bit(MSR_FS_BASE & 0x1fff, vmx_pages->msr + 0x400);
+	__set_bit(MSR_FS_BASE & 0x1fff, vmx_pages->msr + 0x400);
 	GUEST_ASSERT(!vmresume());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_MSR_READ);
 	current_evmcs->guest_rip += 2; /* rdmsr */
@@ -154,7 +154,7 @@ void guest_code(struct vmx_pages *vmx_pages, struct hyperv_test_pages *hv_pages,
 	current_evmcs->guest_rip += 2; /* rdmsr */
 
 	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
-	set_bit(MSR_GS_BASE & 0x1fff, vmx_pages->msr + 0x400);
+	__set_bit(MSR_GS_BASE & 0x1fff, vmx_pages->msr + 0x400);
 	/* Make sure HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP is set */
 	current_evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
 	GUEST_ASSERT(!vmresume());
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
index 3b3cc94ba8e4..68a7d354ea07 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_svm_test.c
@@ -103,7 +103,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 
 	/* Intercept RDMSR 0xc0000100 */
 	vmcb->control.intercept |= 1ULL << INTERCEPT_MSR_PROT;
-	set_bit(2 * (MSR_FS_BASE & 0x1fff), svm->msr + 0x800);
+	__set_bit(2 * (MSR_FS_BASE & 0x1fff), svm->msr + 0x800);
 	run_guest(vmcb, svm->vmcb_gpa);
 	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_MSR);
 	vmcb->save.rip += 2; /* rdmsr */
@@ -115,7 +115,7 @@ static void __attribute__((__flatten__)) guest_code(struct svm_test_data *svm,
 	vmcb->save.rip += 2; /* rdmsr */
 
 	/* Intercept RDMSR 0xc0000101 without telling KVM about it */
-	set_bit(2 * (MSR_GS_BASE & 0x1fff), svm->msr + 0x800);
+	__set_bit(2 * (MSR_GS_BASE & 0x1fff), svm->msr + 0x800);
 	/* Make sure HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP is set */
 	vmcb->control.clean |= HV_VMCB_NESTED_ENLIGHTENMENTS;
 	run_guest(vmcb, svm->vmcb_gpa);
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
