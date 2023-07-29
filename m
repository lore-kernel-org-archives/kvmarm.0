Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29DD7C
	for <kvmarm@lists.linux.dev>; Sat, 29 Jul 2023 00:37:38 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1bb982d2603so24266745ad.3
        for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690591058; x=1691195858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=d6kPm0n7T96ze0vTa8ShFMVzebNGtyTcvv6LKWWyQ1s=;
        b=mNWoL49dXz7kBVeZOHaDyTy/zraK+QVvzn42Z1wrwdXeVmWi9TMkoxp5EUCeIZqqzg
         8e+SY7YdMasojLMex/KT9dAX+fDpq/iyy9Lc8uD+hw98LOiix2IVuhkuUXPsd3LL0xWM
         Ilu6N+XlcBQDISa8h7UPeLte1BtN+Hdkzv0/PBCBqOeFYUuliYz9MVgPnDpR1bO6z23n
         Cz5dxP9aeSp0M6WMQ4b2ympz8NAJ+EqJc+7Vrt16Jp6kD70nR7CjOqa9GxEuagAC2i0i
         hcc/wmI2OqHNUTPlNPMyYvAQJWpoLxN536MFWH5yEIZpL4rEyDFUowQHMrMgchg0x0r4
         QVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690591058; x=1691195858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d6kPm0n7T96ze0vTa8ShFMVzebNGtyTcvv6LKWWyQ1s=;
        b=g6oacIcClHGncurO53eWTM+ZqWE80fod5Kcxnx3G0XPA03HWd3Q2n1GtY320rFi4Z4
         EM6lY9M5D7E2vOHaNHYkWAzTK+P9HMvqrMZjTdyANUeKdxt8d3v23LAaSTaoab7aOf/7
         ayE3dgl3GuJPifU/LidM5IN+HvIVoSe//5EnIECE0z5xvGWXlxNLFnQ6r66ovd/8YOtg
         mzurQTR/wMesX6wG/4p8wFj63FuWAnD0c5gopPQpqCKxIro2IHtFlL2wpfOTfROXC/55
         JmepbwpkO7r8xDcfITYiRJ5xkc06P3mIQ+zbpEcag+JKgMOsqIENBVDESgiQ9W/Toeb5
         RKEA==
X-Gm-Message-State: ABy/qLbWRN7A5R9bs3yIvAoUJ9RPc4wfwwNZ/K2iHMCL0JmaHikmQoa6
	MAsZq8vpuAWaRV4qhyrFG4icNXcUDYA=
X-Google-Smtp-Source: APBJJlEsPWXMm4T+vBuVDUfsR5ZZLTSdnKHrNFWTcYVVY3L5FvVfK6Dbl7NvcayNsyAKrAwqbLimeD4tSt4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa0d:b0:1bb:a13a:c21e with SMTP id
 la13-20020a170902fa0d00b001bba13ac21emr11804plb.10.1690591058164; Fri, 28 Jul
 2023 17:37:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 28 Jul 2023 17:36:36 -0700
In-Reply-To: <20230729003643.1053367-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729003643.1053367-28-seanjc@google.com>
Subject: [PATCH v4 27/34] KVM: selftests: Convert the nSVM software interrupt
 test to printf guest asserts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Thomas Huth <thuth@redhat.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Convert x86's nested SVM software interrupt injection test to use printf-
based guest asserts.  Opportunistically use GUEST_ASSERT() and
GUEST_FAIL() in a few locations to spit out more debug information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 22 ++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index 4e2479716da6..c908412c5754 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -8,6 +8,7 @@
  *   Copyright (C) 2021, Red Hat, Inc.
  *
  */
+#define USE_GUEST_ASSERT_PRINTF 1
 
 #include <stdatomic.h>
 #include <stdio.h>
@@ -34,13 +35,12 @@ static void l2_guest_code_int(void);
 static void guest_int_handler(struct ex_regs *regs)
 {
 	int_fired++;
-	GUEST_ASSERT_2(regs->rip == (unsigned long)l2_guest_code_int,
-		       regs->rip, (unsigned long)l2_guest_code_int);
+	GUEST_ASSERT_EQ(regs->rip, (unsigned long)l2_guest_code_int);
 }
 
 static void l2_guest_code_int(void)
 {
-	GUEST_ASSERT_1(int_fired == 1, int_fired);
+	GUEST_ASSERT_EQ(int_fired, 1);
 
 	/*
          * Same as the vmmcall() function, but with a ud2 sneaked after the
@@ -53,7 +53,7 @@ static void l2_guest_code_int(void)
                              : "rbx", "rdx", "rsi", "rdi", "r8", "r9",
                                "r10", "r11", "r12", "r13", "r14", "r15");
 
-	GUEST_ASSERT_1(bp_fired == 1, bp_fired);
+	GUEST_ASSERT_EQ(bp_fired, 1);
 	hlt();
 }
 
@@ -66,9 +66,9 @@ static void guest_nmi_handler(struct ex_regs *regs)
 
 	if (nmi_stage_get() == 1) {
 		vmmcall();
-		GUEST_ASSERT(false);
+		GUEST_FAIL("Unexpected resume after VMMCALL");
 	} else {
-		GUEST_ASSERT_1(nmi_stage_get() == 3, nmi_stage_get());
+		GUEST_ASSERT_EQ(nmi_stage_get(), 3);
 		GUEST_DONE();
 	}
 }
@@ -104,7 +104,8 @@ static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t i
 	}
 
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+	__GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+		       "Expected VMMCAL #VMEXIT, got '0x%x', info1 = '0x%llx, info2 = '0x%llx'",
 		       vmcb->control.exit_code,
 		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
 
@@ -112,7 +113,7 @@ static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t i
 		clgi();
 		x2apic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_NMI);
 
-		GUEST_ASSERT_1(nmi_stage_get() == 1, nmi_stage_get());
+		GUEST_ASSERT_EQ(nmi_stage_get(), 1);
 		nmi_stage_inc();
 
 		stgi();
@@ -133,7 +134,8 @@ static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t i
 	vmcb->control.next_rip = vmcb->save.rip + 2;
 
 	run_guest(vmcb, svm->vmcb_gpa);
-	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_HLT,
+	__GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_HLT,
+		       "Expected HLT #VMEXIT, got '0x%x', info1 = '0x%llx, info2 = '0x%llx'",
 		       vmcb->control.exit_code,
 		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
 
@@ -185,7 +187,7 @@ static void run_test(bool is_nmi)
 
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT_3(uc, "vals = 0x%lx 0x%lx 0x%lx");
+		REPORT_GUEST_ASSERT(uc);
 		break;
 		/* NOT REACHED */
 	case UCALL_DONE:
-- 
2.41.0.487.g6d72f3e995-goog

