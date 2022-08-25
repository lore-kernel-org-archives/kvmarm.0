Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5783C04AA5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:10:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 840364E2D3;
	Thu, 25 Aug 2022 01:10:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8ki4O5BJG62w; Thu, 25 Aug 2022 01:10:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398384E2E3;
	Thu, 25 Aug 2022 01:10:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3AD74E2CA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N86nUVJIj1Cq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:10:27 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 749DA4E2D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:10:27 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-33d356e7629so149813907b3.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=YHlnoTuvqCkIHNzVEvPhjo0XVRSspND21mglVFldtsg=;
 b=S4z6ByMKPaz7v0TqyBPudcw0RcL/LIRHleuf4PcPxUkw0lVnru6Bdvk/I6csdzNys9
 i95i3qO5w/JbpaEjD35NQZQta1f1kb4LdfeboJm99NQQys23YMVdjQjAJmOcZKVCXTJs
 zvVC9Nlwn5Y/iaySbFCJEiMHZSeygT7AjdovUTHx9btnsLyd4Ig2BeizYl5cOuknmKHK
 eZporwgkevI0ZITNmGKaY6gRjvJaDNEE92bHFa3GqxrBpzvLEFngo2Ak9mMDrF9pA+2S
 eoL6QPAlLOaDQfNGjRQAziKcsck0iRfSag7UeKPxS0LlE1/zPR+oQ5aUSzvHbv91ezBr
 oW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=YHlnoTuvqCkIHNzVEvPhjo0XVRSspND21mglVFldtsg=;
 b=AyB91fiX9q7SNSWdJJZLaYkDDcueitXTw529b3RwxmaABkXo+CSoaDLlIA6s7LxaXB
 4qj/sMfruZPZS8YcCB0g2czmKokXnZSCjh3EsPHqRQYjTsT4pzhdSvn9/WUyfrQeeBE6
 e/ioip4FKuuAQBDhAgbTl8ceCQ+uI7GHT6u2aIU4YQTvgIjsPD+sVQDmAOLTb4SE6PnH
 yCWDEKaIEm96Uts7WQ/mzVC3rFyBsEFiqqfg4sMDzJKMgHFKBDsbaN9dbv6935eMTEla
 yXUGnSeWFRJVenxNszMWZBxaAoV5cK41hbtop3Aso7ZuI+XbPbD6ebb6CMXg7FvtymN7
 YVag==
X-Gm-Message-State: ACgBeo0y43oXiOG9ZarMD+GYcuTcf3RIBr5paOacV342stKMcjXpdhPc
 wZXgXSe7fx4iVT9w1AHiowVxkHNG+A4=
X-Google-Smtp-Source: AA6agR60smgqTg7FqVsKr00Rx1ARhb9FLWG6n/rkbAzF0Rp9rt1QNn0dvCk9m1oXln0XP7RzE1TOPpoc+8w=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:58d:0:b0:695:ea5e:5311 with SMTP id
 135-20020a25058d000000b00695ea5e5311mr2069649ybf.370.1661404227271; Wed, 24
 Aug 2022 22:10:27 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:46 -0700
In-Reply-To: <20220825050846.3418868-1-reijiw@google.com>
Message-Id: <20220825050846.3418868-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 9/9] KVM: arm64: selftests: Test with every
 breakpoint/watchpoint
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

Currently, the debug-exceptions test always uses only
{break,watch}point#0 and the highest numbered context-aware
breakpoint. Modify the test to use all {break,watch}points and
context-aware breakpoints supported on the system.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 77 +++++++++++++++----
 1 file changed, 61 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index dc94c85bb383..7aeab6ae887a 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -397,14 +397,12 @@ static int debug_version(uint64_t id_aa64dfr0)
 	return cpuid_get_ufield(id_aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT);
 }
 
-int main(int argc, char *argv[])
+void run_test(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
-	uint64_t aa64dfr0;
-	uint8_t brps;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -412,10 +410,6 @@ int main(int argc, char *argv[])
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
 
-	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
-	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
-		       "Armv8 debug architecture not supported.");
-
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
@@ -427,15 +421,9 @@ int main(int argc, char *argv[])
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Number of breakpoints, minus 1 */
-	brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
-	__TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
-
-	/*
-	 * Run tests with breakpoint#0 and watchpoint#0, and the higiest
-	 * numbered (context-aware) breakpoint.
-	 */
-	vcpu_args_set(vcpu, 3, 0, 0, brps);
+	/* Specify bpn/wpn/ctx_bpn to be tested */
+	vcpu_args_set(vcpu, 3, bpn, wpn, ctx_bpn);
+	pr_debug("Use bpn#%d, wpn#%d and ctx_bpn#%d\n", bpn, wpn, ctx_bpn);
 
 	for (stage = 0; stage < 11; stage++) {
 		vcpu_run(vcpu);
@@ -458,5 +446,62 @@ int main(int argc, char *argv[])
 
 done:
 	kvm_vm_free(vm);
+}
+
+/*
+ * Run debug testing using the various breakpoint#, watchpoint# and
+ * context-aware breakpoint# with the given ID_AA64DFR0_EL1 configuration.
+ */
+void test_debug(uint64_t aa64dfr0)
+{
+	uint8_t brps, wrps, ctx_cmps;
+	uint8_t normal_brp_num, wrp_num, ctx_brp_base, ctx_brp_num;
+	int b, w, c;
+
+	brps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	__TEST_REQUIRE(brps > 0, "At least two breakpoints are required");
+
+	wrps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	ctx_cmps = cpuid_get_ufield(aa64dfr0, ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	pr_debug("%s brps:%d, wrps:%d, ctx_cmps:%d\n", __func__,
+		 brps, wrps, ctx_cmps);
+
+	/* Number of normal (non-context aware) breakpoints */
+	normal_brp_num = brps - ctx_cmps;
+
+	/* Number of watchpoints */
+	wrp_num = wrps + 1;
+
+	/* Number of context aware breakpoints */
+	ctx_brp_num = ctx_cmps + 1;
+
+	/* Lowest context aware breakpoint number */
+	ctx_brp_base = normal_brp_num;
+
+	/* Run tests with all supported breakpoints/watchpoints */
+	for (c = ctx_brp_base; c < ctx_brp_base + ctx_brp_num; c++) {
+		for (b = 0; b < normal_brp_num; b++) {
+			for (w = 0; w < wrp_num; w++)
+				run_test(b, w, c);
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	uint64_t aa64dfr0;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	kvm_vm_free(vm);
+
+	__TEST_REQUIRE(debug_version(aa64dfr0) >= 6,
+		       "Armv8 debug architecture not supported.");
+
+	/* Run debug tests with the default configuration */
+	test_debug(aa64dfr0);
 	return 0;
 }
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
