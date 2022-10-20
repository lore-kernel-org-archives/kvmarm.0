Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E56DC4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:43:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA06A4B92D;
	Thu, 20 Oct 2022 01:43:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lTSLs-FxZh4f; Thu, 20 Oct 2022 01:43:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 657CF4B94C;
	Thu, 20 Oct 2022 01:43:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59E5D4B933
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1FVUuYLBPoVw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:43:51 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A96E4B91C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:43:51 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 o14-20020a056a00214e00b0056238ef46ebso10509978pfk.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=B5VialaYDd/5nDZq2FGZQSkkeS3yDmkJ8xITb2jtJu4=;
 b=JCQN7ZN/2N0cWyp8F8z9Q/AWQsvHJudQPiteYqEIcj7XfWugeQhVkTmnP0ARsWsoks
 ucgnIuxwkVOi6HfufXCOivOoWc0OAfMaQ5LcZ7LoJDphUF5BD661KNYr13g9b8M69Wg5
 sYWriD3ommK1rvL7wYoQei3CW09bn2tk9bumU08bD2tbJvn7h2d3n2uBe3lkScwHMXo/
 +pgtGuA2YWI5nKvdUoxnT816Q+TSg6g4SRqRLOa1HBJbbymWGCLYzRrE86VGWUgxGIhh
 fAoVU8gmlDs5BJ+XuOZSg+xtcNGDwIO9ya/KVTRPWvkUMcFeE/PKg4uoGNBwomtfA+sz
 SrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=B5VialaYDd/5nDZq2FGZQSkkeS3yDmkJ8xITb2jtJu4=;
 b=sa+yC7CeFs9NklgHb8Wy4LSPN1VdLp7r50gJ0me5sCaas9MKFOjVTaWEEi4/PWwhvj
 cfj1jkdkcHtfw+kMVSV4j1nQfLLvpPaKprXwk0/s+x8l8ypZna2NSdBVBjc3zp4N+z9o
 P+TyYTc72JnxHMDz+9dedykpRnsS0U99ue245ztVDnJvYP3W3Kq7c+Gkej8f2jqL7ASh
 xPom48YfYscaRlr+IT42TCsBMW0c6Bp/z0E/agC3zcYuG06TN1f6lp4IU/6E3+ZIywdd
 pooky7XyJYdm5ZTHj+wYvUDwh7zCoLiWKsMsYLpHBli/R5i0ZTVjBYfXGCUi5dLeSoDf
 2yRQ==
X-Gm-Message-State: ACrzQf2BCwrtOl76g9ovRC3uJSW6xs7QbtD2qrA/lNuw3sIHTWSZXQ28
 9Dk8suZ85OqcNBC5QGzOkEk5SEXJiCU=
X-Google-Smtp-Source: AMsMyM4nwPtJ6JpQSfu86pZslSfGKYI7Hejk4DKn49pB5qd4AvXEqW2ZJclxhcgitaqs9lCMA2XixsTUavc=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a17:90a:b794:b0:20a:eab5:cf39 with SMTP id
 m20-20020a17090ab79400b0020aeab5cf39mr2379113pjr.1.1666244629981; Wed, 19 Oct
 2022 22:43:49 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:42:02 -0700
In-Reply-To: <20221020054202.2119018-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221020054202.2119018-1-reijiw@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-10-reijiw@google.com>
Subject: [PATCH v2 9/9] KVM: arm64: selftests: Test with every
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
 .../selftests/kvm/aarch64/debug-exceptions.c  | 54 ++++++++++++++-----
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 73a95e6b345e..b30add3e7726 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -420,12 +420,11 @@ static int debug_version(uint64_t id_aa64dfr0)
 	return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_DEBUGVER), id_aa64dfr0);
 }
 
-static void test_guest_debug_exceptions(uint64_t aa64dfr0)
+static void test_guest_debug_exceptions(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	uint8_t brp_num;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	ucall_init(vm, NULL);
@@ -444,15 +443,9 @@ static void test_guest_debug_exceptions(uint64_t aa64dfr0)
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_SVC64, guest_svc_handler);
 
-	/* Number of breakpoints */
-	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), aa64dfr0) + 1;
-	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
-
-	/*
-	 * Run tests with breakpoint#0, watchpoint#0, and the higiest
-	 * numbered (context-aware) breakpoint.
-	 */
-	vcpu_args_set(vcpu, 3, 0, 0, brp_num - 1);
+	/* Specify bpn/wpn/ctx_bpn to be tested */
+	vcpu_args_set(vcpu, 3, bpn, wpn, ctx_bpn);
+	pr_debug("Use bpn#%d, wpn#%d and ctx_bpn#%d\n", bpn, wpn, ctx_bpn);
 
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
@@ -535,6 +528,43 @@ void test_single_step_from_userspace(int test_cnt)
 	kvm_vm_free(vm);
 }
 
+/*
+ * Run debug testing using the various breakpoint#, watchpoint# and
+ * context-aware breakpoint# with the given ID_AA64DFR0_EL1 configuration.
+ */
+void test_guest_debug_exceptions_all(uint64_t aa64dfr0)
+{
+	uint8_t brp_num, wrp_num, ctx_brp_num, normal_brp_num, ctx_brp_base;
+	int b, w, c;
+
+	/* Number of breakpoints */
+	brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS), aa64dfr0) + 1;
+	__TEST_REQUIRE(brp_num >= 2, "At least two breakpoints are required");
+
+	/* Number of watchpoints */
+	wrp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS), aa64dfr0) + 1;
+
+	/* Number of context aware breakpoints */
+	ctx_brp_num = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_CTX_CMPS), aa64dfr0) + 1;
+
+	pr_debug("%s brp_num:%d, wrp_num:%d, ctx_brp_num:%d\n", __func__,
+		 brp_num, wrp_num, ctx_brp_num);
+
+	/* Number of normal (non-context aware) breakpoints */
+	normal_brp_num = brp_num - ctx_brp_num;
+
+	/* Lowest context aware breakpoint number */
+	ctx_brp_base = normal_brp_num;
+
+	/* Run tests with all supported breakpoints/watchpoints */
+	for (c = ctx_brp_base; c < ctx_brp_base + ctx_brp_num; c++) {
+		for (b = 0; b < normal_brp_num; b++) {
+			for (w = 0; w < wrp_num; w++)
+				test_guest_debug_exceptions(b, w, c);
+		}
+	}
+}
+
 static void help(char *name)
 {
 	puts("");
@@ -569,7 +599,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	test_guest_debug_exceptions(aa64dfr0);
+	test_guest_debug_exceptions_all(aa64dfr0);
 	test_single_step_from_userspace(ss_iteration);
 
 	return 0;
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
