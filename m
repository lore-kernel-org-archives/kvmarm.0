Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54239191
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 00:24:00 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso107969pjb.6
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 16:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OQIty0gkGvimYsfAtcoPy8df73fwY+kl22+jSnaHr3Q=;
        b=XawF3gkr8CSKZ24fVYfQH/likVJmqrI6J+VgfY0e5oCqzv9OjobeFrDLWibgksGjp1
         bpT/73ID8XYCUWtDkHG2HllTtEz582TclewSThnNE0l3c5yF0jvFHZ1/ZL/wudSFnfNc
         22czahecA+4YL4y5BIk2STkzJ4Sl4F0uiU6ADlDXxHmn4GtTD2LizNnfounT0TGHV1ul
         /PifA+5TNyMgrcAklqK6NQw2i1wpsS5JW7doMrokg2FmWTpQJbyYBuHmTEcGBLiW9ITd
         7j6WcKeXgdmwApf4zSyXL5jmPW52XoIa3JdjF+0UF72NtCpSP+95c3KKIAP0X74sDOd8
         MIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OQIty0gkGvimYsfAtcoPy8df73fwY+kl22+jSnaHr3Q=;
        b=kdSgUBBv2KEy1LJAV09B4mSlIkC5CYeV9zLfDGBJeWKP9pJrE/JKfyWa22u2XmB16z
         Y14HM2tAV032MNoDN71QfsloaCzxwJutlp+AQI9ET1BCOU4u2Z+BeqjpU8A6DGRCjtiH
         ai75jTUoDa2c2Vk4Cq5hm/YIAF7OmAhbaWPAnFE3/Ge+DoZd/SPZ9cE4hWv2kXq2e7Nm
         i0LCRHD5iOEb7bbVOVgnop60UhWnyzaBTDkr7Nq+rbo/5cS3lnsiLuv8CI/t7Va0r2Nc
         jEL0znh7RknHUWaz5XMORiERJ7c4Tzjq19PlEdaXvgV/TqsS/iigZZGkHj/2XBORVsDC
         L0TQ==
X-Gm-Message-State: ANoB5pmVTO6Vi1UuwfwUz3Y0o+BzR4ktLLbh5RSZK8YcdOvioLhjfTl3
	dn6ZsXpAHndLznq/Xqi/602vM6V15gA=
X-Google-Smtp-Source: AA0mqf6UG7Saff0XvDUGklOofeYsmwntM1MGQ71SgLhPhHqsgDLhnxcroheVO1wVLxnzQCCJ1Ru+MrMvNxE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:9628:0:b0:56d:c3af:2d7f with SMTP id
 r8-20020aa79628000000b0056dc3af2d7fmr464212pfg.64.1668644639816; Wed, 16 Nov
 2022 16:23:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 17 Nov 2022 00:23:50 +0000
In-Reply-To: <20221117002350.2178351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221117002350.2178351-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221117002350.2178351-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221117002350.rm8KA6GCFVfQWrdh6fezXA1dZjbXIgpAMNWFFOZ25Ck@z>

Automatically disable single-step when the guest reaches the end of the
verified section instead of using an explicit ucall() to ask userspace to
disable single-step.  An upcoming change to implement a pool-based scheme
for ucall() will add an atomic operation (bit test and set) in the guest
ucall code, and if the compiler generate "old school" atomics, e.g.

  40e57c:       c85f7c20        ldxr    x0, [x1]
  40e580:       aa100011        orr     x17, x0, x16
  40e584:       c80ffc31        stlxr   w15, x17, [x1]
  40e588:       35ffffaf        cbnz    w15, 40e57c <__aarch64_ldset8_sync+0x1c>

the guest will hang as the local exclusive monitor is reset by eret,
i.e. the stlxr will always fail due to the VM-Exit for the debug
exception.

Link: https://lore.kernel.org/all/20221006003409.649993-8-seanjc@google.com
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/debug-exceptions.c  | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 91f55b45dfc7..65cd7e4f07fa 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -241,7 +241,6 @@ static void guest_svc_handler(struct ex_regs *regs)
 
 enum single_step_op {
 	SINGLE_STEP_ENABLE = 0,
-	SINGLE_STEP_DISABLE = 1,
 };
 
 static void guest_code_ss(int test_cnt)
@@ -258,7 +257,7 @@ static void guest_code_ss(int test_cnt)
 		GUEST_SYNC(SINGLE_STEP_ENABLE);
 
 		/*
-		 * The userspace will veriry that the pc is as expected during
+		 * The userspace will verify that the pc is as expected during
 		 * single step execution between iter_ss_begin and iter_ss_end.
 		 */
 		asm volatile("iter_ss_begin:nop\n");
@@ -268,11 +267,9 @@ static void guest_code_ss(int test_cnt)
 		bvr = read_sysreg(dbgbvr0_el1);
 		wvr = read_sysreg(dbgwvr0_el1);
 
+		/* Userspace disables Single Step when the end is nigh. */
 		asm volatile("iter_ss_end:\n");
 
-		/* Disable Single Step execution */
-		GUEST_SYNC(SINGLE_STEP_DISABLE);
-
 		GUEST_ASSERT(bvr == w_bvr);
 		GUEST_ASSERT(wvr == w_wvr);
 	}
@@ -364,15 +361,12 @@ void test_single_step_from_userspace(int test_cnt)
 			TEST_ASSERT(cmd == UCALL_SYNC,
 				    "Unexpected ucall cmd 0x%lx", cmd);
 
-			if (uc.args[1] == SINGLE_STEP_ENABLE) {
-				debug.control = KVM_GUESTDBG_ENABLE |
-						KVM_GUESTDBG_SINGLESTEP;
-				ss_enable = true;
-			} else {
-				debug.control = KVM_GUESTDBG_ENABLE;
-				ss_enable = false;
-			}
+			TEST_ASSERT(uc.args[1] == SINGLE_STEP_ENABLE,
+				    "Unexpected ucall action 0x%lx", uc.args[1]);
 
+			debug.control = KVM_GUESTDBG_ENABLE |
+					KVM_GUESTDBG_SINGLESTEP;
+			ss_enable = true;
 			vcpu_guest_debug_set(vcpu, &debug);
 			continue;
 		}
@@ -385,6 +379,14 @@ void test_single_step_from_userspace(int test_cnt)
 			    "Unexpected pc 0x%lx (expected 0x%lx)",
 			    pc, test_pc);
 
+		if ((pc + 4) == (uint64_t)&iter_ss_end) {
+			test_pc = 0;
+			debug.control = KVM_GUESTDBG_ENABLE;
+			ss_enable = false;
+			vcpu_guest_debug_set(vcpu, &debug);
+			continue;
+		}
+
 		/*
 		 * If the current pc is between iter_ss_bgin and
 		 * iter_ss_end, the pc for the next KVM_EXIT_DEBUG should
-- 
2.38.1.431.g37b22c650d-goog

