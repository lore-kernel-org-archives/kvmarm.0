Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C344C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:58:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C53F24B22A;
	Tue, 19 Apr 2022 02:58:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aoDFQCyeF6lS; Tue, 19 Apr 2022 02:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 642364B28A;
	Tue, 19 Apr 2022 02:58:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB6F74B266
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:58:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PVbXcU9kzRlT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:58:11 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A4974B20C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:58:08 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 m12-20020a170902d18c00b001589ea4e0d6so9240481plb.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mjj9/ZURjjtGQaz2LLl2krlBnNho3fyEfvR2R+fnkyk=;
 b=Cx/niwv6W7Y06XURKByUCxiOI2JS42u8ZRsB4Jd/xNk9tuJcTxkf6DGO2ozYf4I2US
 ZU5gnlaHf3BOrOeCv/etuwgapIvL2bqk3oDXaueadh0neyRo+SRUNGL8votl7vplAKIM
 sHEcbNzdEG1JDsorZDIsYKh0benCQF67aJbA83qbMyT0rAqvaaie74ccZbn2UKz7aKPj
 rdih6zJ2hBj5+wcu/NsMPytHpAWF1ZDLiIr+vMhcou+4/o0JwtMNZ0uLdoKh4FJr+/Aw
 2l9wU0ZAeDtDkWgA6X6SW5F7yr+BUmvcruGK7QcRMj4E99qkjqwTBZGm703z1PFKPYWV
 fU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mjj9/ZURjjtGQaz2LLl2krlBnNho3fyEfvR2R+fnkyk=;
 b=su9juLDUv4W2PqC3ki2QNGivNsY4sqf8h14fbF1Kjeu2N705IuK8HehQlddcW4JoxU
 E/aByfZJzN3KE47AyTrmXnQX32bSEVc8Fc7QlVXXtVVyVBT1Ajd+2igwNxMWaM9MercM
 3c5PuNmm7zKCzafP/U+/D3mYBqBUpiblXMFDvYLb1cSbpra+3Fojk5tGR90ID0rOnppG
 sgvFC2jL9bWOOWjc2N1MnZuMMa96sqLeKBhpuBpyLnjeVha3U2CFyRkSVbjoSX/p0nFu
 T2veK5BkzfnEiJw+HTXQtnDYe1lbtbkffkykBwePxfIDVLNb5BEXfbfd71ICsPQBy5oB
 ojBg==
X-Gm-Message-State: AOAM533pDBqIW/dsTqrBEyoT/WeromiF+VHR/VQYSlXPAaPtDdGmOkVi
 OwiSDD0rdLvmd2utiPxvXCKTXWd+KiY=
X-Google-Smtp-Source: ABdhPJxetHGB4V+UPVW7WLQKsn2PTcz1+SOcEmT+cqxyd2F8wg7N+PKJyvCJRL8FQa0pqjwk4Zbwsa8b0eQ=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr276931pjb.1.1650351487187; Mon, 18 Apr
 2022 23:58:07 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:44 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-39-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 38/38] KVM: arm64: selftests: Test breakpoint/watchpoint
 changing ID_AA64DFR0_EL1
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

Add test cases that uses every breakpoint/watchpoint with various
combination of ID_AA64DFR0_EL1.BRPs, WRPs, and CTX_CMPs
configuration to the debug-exceptions test.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 52 ++++++++++++++++---
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 829fad6c7d58..d8ebbb7985da 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -701,18 +701,19 @@ static void check_debug_regs(struct kvm_vm *vm, uint32_t vcpu,
 	}
 }
 
-void run_test(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
+void run_test(uint64_t aa64dfr0, uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
 {
 	struct kvm_vm *vm;
 	struct ucall uc;
 	int stage;
-	uint64_t aa64dfr0;
 	uint8_t nbps, nwps;
 	bool debug_reg_test = false;
 
-	pr_debug("%s bpn:%d, wpn:%d, ctx_bpn:%d\n", __func__, bpn, wpn, ctx_bpn);
-
+	pr_debug("%s aa64dfr0:0x%lx, bpn:%d, wpn:%d, ctx_bpn:%d\n", __func__,
+		 aa64dfr0, bpn, wpn, ctx_bpn);
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	set_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), aa64dfr0);
+
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
@@ -810,15 +811,33 @@ void test_debug(uint64_t aa64dfr0)
 	for (c = ctx_brp_base; c < ctx_brp_base + ctx_brp_num; c++) {
 		for (b = 0; b < normal_brp_num; b++) {
 			for (w = 0; w < wrp_num; w++)
-				run_test(b, w, c);
+				run_test(aa64dfr0, b, w, c);
 		}
 	}
 }
 
+uint64_t update_aa64dfr0_bwrp(uint64_t dfr0, uint8_t brps, uint8_t wrps,
+			      uint8_t ctx_brps)
+{
+	/* Clear brps/wrps/ctx_cmps fields */
+	dfr0 &= ~(ARM64_FEATURE_MASK(ID_AA64DFR0_BRPS) |
+		  ARM64_FEATURE_MASK(ID_AA64DFR0_WRPS) |
+		  ARM64_FEATURE_MASK(ID_AA64DFR0_CTX_CMPS));
+
+	/* Set new brps/wrps/ctx_cmps fields */
+	dfr0 |= ((uint64_t)brps << ID_AA64DFR0_BRPS_SHIFT) |
+		((uint64_t)wrps << ID_AA64DFR0_WRPS_SHIFT) |
+		((uint64_t)ctx_brps << ID_AA64DFR0_CTX_CMPS_SHIFT);
+
+	return dfr0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	uint64_t aa64dfr0;
+	uint64_t aa64dfr0, test_aa64dfr0;
+	uint8_t max_brps, max_wrps, max_ctx_brps;
+	int bs, ws, cs;
 
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	get_reg(vm, VCPU_ID, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &aa64dfr0);
@@ -831,5 +850,26 @@ int main(int argc, char *argv[])
 
 	/* Run debug tests with the default configuration */
 	test_debug(aa64dfr0);
+
+	if (!kvm_check_cap(KVM_CAP_ARM_ID_REG_CONFIGURABLE))
+		return 0;
+
+	/*
+	 * Run debug tests with various number of breakpoints/watchpoints
+	 * configuration.
+	 */
+	max_brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_BRPS_SHIFT);
+	max_wrps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_WRPS_SHIFT);
+	max_ctx_brps = cpuid_extract_uftr(aa64dfr0, ID_AA64DFR0_CTX_CMPS_SHIFT);
+	for (cs = 0; cs <= max_ctx_brps; cs++) {
+		for (bs = cs + 1; bs <= max_brps; bs++) {
+			for (ws = 1; ws <= max_wrps; ws++) {
+				test_aa64dfr0 = update_aa64dfr0_bwrp(aa64dfr0,
+								    bs, ws, cs);
+				test_debug(test_aa64dfr0);
+			}
+		}
+	}
+
 	return 0;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
