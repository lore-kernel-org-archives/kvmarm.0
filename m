Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89088C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:58:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3954B1F1;
	Tue, 19 Apr 2022 02:58:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fodZdNQmD-hU; Tue, 19 Apr 2022 02:58:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9454B25A;
	Tue, 19 Apr 2022 02:58:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13F664B1F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:58:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id evC93kWgl-bb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:58:09 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BA8F4B242
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:58:06 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 s2-20020a17090302c200b00158ea215fa2so4279769plk.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q/YanX6EPfx+u+3OMqrYAFeJvrZlkb0TikNUTqVME1Y=;
 b=A9RjQxSTslkChFxxKJBdhdGh7KoE8jdKMtCpxERX/tBbu9UdykN6mkSjBGbvrYe0yp
 xBFHJ43ZJf4RR+MEhIlZ7ADb8RRTxk9EjoI4axpGew5mfnR/CZ+7Qc08BTxvdSIhMnEL
 S0VoLAtGwG0N9/MEUw8RgUNNusNRqxJ2rnhriVmUw0Daui4T115Gk7aB5kAT/K7Dy5ln
 Sqz+L0yKZ5Fwv8xGNj0xOmz6XDBQvxHX8WWsVY9iNm2YwZF/W72gKnWRD+fPNYWpGwuL
 Z7r0lVt6DSqTfiRLp6FxJ/jy9xJU8u1FN9hBZqz308wPv0h3JB04kzgRohXhz+W+dL4+
 fwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q/YanX6EPfx+u+3OMqrYAFeJvrZlkb0TikNUTqVME1Y=;
 b=Rsa3M8Xo92v+rd27+fMnVH9i/mMX4siXt8XZo9LuxzEeI3/93vRw85CUmp5pu3rcUO
 kv1ViLyoaiFs9ww5eopfGbopBu6VbLyDOoMfzZs1Dmx1J2zI9nj2TnhKyeSPw9jLrwte
 xlzLRqe1yhUAetADMSEQO9aV81On6xDkiFoKMsTSlNCKMicPGqYqpnKvLesHkueRxcFf
 N8pnqBtuoEsFp0gXGtKB0z/DI49l5UZ8Km7cvGQanjerj4bYOT2qLKWgVSfgCAKk9oiQ
 NJlKHXcvRDfyxyr4lzbsjYAJB6Yq9V/hct7/S6D0Y24FNiMApTIS8TP/QZPj+kkGkvAL
 ESoA==
X-Gm-Message-State: AOAM530YPobHlPtr92ZgdrmEG1siSCxdQzILsgKzxZAatXrLDwY4oTbL
 vnBqhah/nmQzAVHncAm7lQDlwXdTsMk=
X-Google-Smtp-Source: ABdhPJwE2z7KVThLseGHNOhepGcvcWOJLfCs0hdmn9Is1cTsX8Yz9n5jIjhtaxYpBfwuDusFcqDN9vQu4DQ=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a62:685:0:b0:50a:5870:10b1 with SMTP id
 127-20020a620685000000b0050a587010b1mr13751101pfg.61.1650351485348; Mon, 18
 Apr 2022 23:58:05 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:43 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-38-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 37/38] KVM: arm64: selftests: Test with every
 breakpoint/watchpoint
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

Add test cases that uses every breakpoint/watchpoint to the
debug-exceptions test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 70 ++++++++++++++++---
 1 file changed, 59 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 4e00100b9aa1..829fad6c7d58 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -701,7 +701,7 @@ static void check_debug_regs(struct kvm_vm *vm, uint32_t vcpu,
 	}
 }
 
-int main(int argc, char *argv[])
+void run_test(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -710,6 +710,8 @@ int main(int argc, char *argv[])
 	uint8_t nbps, nwps;
 	bool debug_reg_test = false;
 
+	pr_debug("%s bpn:%d, wpn:%d, ctx_bpn:%d\n", __func__, bpn, wpn, ctx_bpn);
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
@@ -717,11 +719,6 @@ int main(int argc, char *argv[])
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
 	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
-	if (cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT) < 6) {
-		print_skip("Armv8 debug architecture not supported.");
-		kvm_vm_free(vm);
-		exit(KSFT_SKIP);
-	}
 
 	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
 				ESR_EC_BRK_INS, guest_sw_bp_handler);
@@ -742,11 +739,7 @@ int main(int argc, char *argv[])
 	nwps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT) + 1;
 	TEST_ASSERT(nwps >= 2, "Number of watchpoints must be >= 2");
 
-	/*
-	 * Test with breakpoint#0 and watchpoint#0, and the higiest
-	 * numbered breakpoint (the context aware breakpoint).
-	 */
-	vcpu_args_set(vm, VCPU_ID, 4, &debug_regs, 0, 0, nbps - 1);
+	vcpu_args_set(vm, VCPU_ID, 4, &debug_regs, bpn, wpn, ctx_bpn);
 
 	for (stage = 0; stage < 13; stage++) {
 		/* First two stages are sanity debug regs read/write check */
@@ -783,5 +776,60 @@ int main(int argc, char *argv[])
 
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
+	brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	wrps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	ctx_cmps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_CTX_CMPS_SHIFT);
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
+	uint64_t aa64dfr0;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
+	kvm_vm_free(vm);
+
+	if (cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_DEBUGVER_SHIFT) < 6) {
+		print_skip("Armv8 debug architecture not supported.");
+		exit(KSFT_SKIP);
+	}
+
+	/* Run debug tests with the default configuration */
+	test_debug(aa64dfr0);
 	return 0;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
