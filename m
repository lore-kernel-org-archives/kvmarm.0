Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0572DC433FE
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 23:12:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8977261058
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 23:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8977261058
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E5334B265;
	Fri,  3 Sep 2021 19:12:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9WWd26Cm7pVF; Fri,  3 Sep 2021 19:12:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24A1C4B26B;
	Fri,  3 Sep 2021 19:12:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94B6A4B269
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 19:12:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rZ0Nw6eEGKpz for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 19:12:18 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77D534B265
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 19:12:18 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 z127-20020a633385000000b002618d24cfacso313037pgz.16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 16:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gq6h7Eo56XYa1ARu4AoG783Vndsp695exWEl2AMV2X8=;
 b=ZkR68gKiUcfrLDsvLcPh0BcfcTWbHCLIFSCCw/WuDHsDuEWnQ6U804KMcS+vyhn4Mp
 lHpY7odhU97mNIWo86KIL0TnSl7fj9uLyk5U2DHdMnaD7FRb/hi74uNau44ZIBqYT4nE
 LkI3OMUgh5u2iacIzCMlhjZnXx6aq5JC8VOh2LW6FLGjloXtmHxA/DOBLoZvq1bYJaP2
 Z3eJSX88GPehYQsh9Tag5g5ItQ24/VBrQrY9ogxLi+on6vAHKZHGXrg8j5qM6kdLxqQt
 MEef4xrRdqAGOuT023oQ5YvwKZ31fptzIEXIIVljrkkJjieT3EvPmRaJ77xf0XnaV6tV
 HxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gq6h7Eo56XYa1ARu4AoG783Vndsp695exWEl2AMV2X8=;
 b=kI7U/Pu49eeGa9NgDN9uBkVQq9g3tOHB4yIyhznODKqjshzq/nIy9QpAGTCE+xH6P3
 kdzyFcTqIjXLD/Yqe3D4YAfk660Leu56Cg+DnKhb+bJvSQU6KH7vdrutCQFtA5KPmjFO
 Qa2l0sYocFpVyD04M+JwhIMZXoekeVH6dHqUfJXkaxDlaxUhWHbctQSAyzMRkY0ohJi1
 EOXcTcgTwk6HqZwzQAT2Fv9jB3CCjGOAI5tmp0LZ/AzfyBBTI/m1kWDIQOUMpqi3GEUq
 1SO63BxatbHjgp4EUXFzWFf2efAuJ35HoUgzsR1z9tsE5CJjn2G+SvY9mUSJ8GyXpQp7
 HDZA==
X-Gm-Message-State: AOAM5324Gwthheur9VWBuXklNlY2QsjVcdGuTVWDaCeHoxlUP5cX6o7X
 c7zfl4Y6TYQj9d9Mh3d3a1CnVlqDPWkhbg==
X-Google-Smtp-Source: ABdhPJzkS2ggg1deQs/hZ76aK+S9ZNzY69uXp763MMgq27gs9X05cLTwvnREE5jg8QMMHRtfNnXPXfdNewKapw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:dcc9:b0:134:92c7:3cb6 with SMTP
 id t9-20020a170902dcc900b0013492c73cb6mr999233pll.79.1630710737476; Fri, 03
 Sep 2021 16:12:17 -0700 (PDT)
Date: Fri,  3 Sep 2021 16:11:53 -0700
In-Reply-To: <20210903231154.25091-1-ricarkol@google.com>
Message-Id: <20210903231154.25091-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210903231154.25091-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 1/2] KVM: selftests: make memslot_perf_test arch independent
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
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

memslot_perf_test uses ucalls for synchronization between guest and
host. Ucalls API is architecture independent: tests do not need know
what kind of exit they generate on a specific arch.  More specifically,
there is no need to check whether an exit is KVM_EXIT_IO in x86 for the
host to know that the exit is ucall related, as get_ucall() already
makes that check.

Change memslot_perf_test to not require specifying what exit does a
ucall generate. Also add a missing ucall_init.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index d6e381e01db7..1727f75e0c2c 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -127,43 +127,54 @@ static bool verbose;
 			pr_info(__VA_ARGS__);	\
 	} while (0)
 
+static void check_mmio_access(struct vm_data *vm, struct kvm_run *run)
+{
+	TEST_ASSERT(vm->mmio_ok, "Unexpected mmio exit");
+	TEST_ASSERT(run->mmio.is_write, "Unexpected mmio read");
+	TEST_ASSERT(run->mmio.len == 8,
+		    "Unexpected exit mmio size = %u", run->mmio.len);
+	TEST_ASSERT(run->mmio.phys_addr >= vm->mmio_gpa_min &&
+		    run->mmio.phys_addr <= vm->mmio_gpa_max,
+		    "Unexpected exit mmio address = 0x%llx",
+		    run->mmio.phys_addr);
+}
+
 static void *vcpu_worker(void *data)
 {
 	struct vm_data *vm = data;
 	struct kvm_run *run;
 	struct ucall uc;
-	uint64_t cmd;
 
 	run = vcpu_state(vm->vm, VCPU_ID);
 	while (1) {
 		vcpu_run(vm->vm, VCPU_ID);
 
-		if (run->exit_reason == KVM_EXIT_IO) {
-			cmd = get_ucall(vm->vm, VCPU_ID, &uc);
-			if (cmd != UCALL_SYNC)
-				break;
-
+		switch (get_ucall(vm->vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == 0,
+				"Unexpected sync ucall, got %lx",
+				(ulong)uc.args[1]);
 			sem_post(&vcpu_ready);
 			continue;
-		}
-
-		if (run->exit_reason != KVM_EXIT_MMIO)
+		case UCALL_NONE:
+			if (run->exit_reason == KVM_EXIT_MMIO)
+				check_mmio_access(vm, run);
+			else
+				goto done;
 			break;
-
-		TEST_ASSERT(vm->mmio_ok, "Unexpected mmio exit");
-		TEST_ASSERT(run->mmio.is_write, "Unexpected mmio read");
-		TEST_ASSERT(run->mmio.len == 8,
-			    "Unexpected exit mmio size = %u", run->mmio.len);
-		TEST_ASSERT(run->mmio.phys_addr >= vm->mmio_gpa_min &&
-			    run->mmio.phys_addr <= vm->mmio_gpa_max,
-			    "Unexpected exit mmio address = 0x%llx",
-			    run->mmio.phys_addr);
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld, val = %lu",
+					(const char *)uc.args[0],
+					__FILE__, uc.args[1], uc.args[2]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
 	}
 
-	if (run->exit_reason == KVM_EXIT_IO && cmd == UCALL_ABORT)
-		TEST_FAIL("%s at %s:%ld, val = %lu", (const char *)uc.args[0],
-			  __FILE__, uc.args[1], uc.args[2]);
-
+done:
 	return NULL;
 }
 
@@ -268,6 +279,7 @@ static bool prepare_vm(struct vm_data *data, int nslots, uint64_t *maxslots,
 	TEST_ASSERT(data->hva_slots, "malloc() fail");
 
 	data->vm = vm_create_default(VCPU_ID, mempages, guest_code);
+	ucall_init(data->vm, NULL);
 
 	pr_info_v("Adding slots 1..%i, each slot with %"PRIu64" pages + %"PRIu64" extra pages last\n",
 		max_mem_slots - 1, data->pages_per_slot, rempages);
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
