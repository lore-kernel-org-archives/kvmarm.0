Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843A4C48BE0
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1BF9461359
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 01:10:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BF9461359
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B044B09B;
	Thu, 10 Jun 2021 21:10:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KhoxtM4HT4oj; Thu, 10 Jun 2021 21:10:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1D44B092;
	Thu, 10 Jun 2021 21:10:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9035849FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5azNPw6mCVIH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jun 2021 21:10:26 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 619EE4AC78
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 21:10:26 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 j18-20020a17090a5892b029016e79c56ccbso446972pji.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jun 2021 18:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6B9KqosZW76/1EMVfhWTsUzi+G/pNj/0Z9xOYz9yDQc=;
 b=GAwPtc8CHR9Gr+VtSKHnJAsgeg8tvymKXdtyrqZVVpVhyFPC4aDdJHeumC3MsKK1En
 t2V4wHSwcIyd+ook/PA6bf6raSkx8Lh+wYGgshBgyA97jVDTPjMyAQjTYasVZws0zdJU
 lZaIBGOADVXXzKr6fY5hxM/DAgNkXUGp9scgaSPOjC5zO37xdO79xrZ000Igmd5RrOZp
 DMbj+vEYB3Fq+oB/nRURaapwNBM6zYLQ3qPz0MXRiGBeXocnliZ/46Qu6fhFDVzjlTOh
 th5l0M4Xd8JJeTxkKrveRuLVFuR3Qmx+e7I0bu/ck7gSLULn0agUeDBW0ssQMS/oV4sI
 xb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6B9KqosZW76/1EMVfhWTsUzi+G/pNj/0Z9xOYz9yDQc=;
 b=VrfMeD81jR87oCxwDcdCYwaHKeiDlg3BD6bONrdhjYCn/5JfKNqUJuFpQrBRfKv5BB
 0BjXOfG4Yh/8duRe/Gl+YgFFlzpJeclmVN6VWPHezTDENCK0t/XJd1O2vHuWOG6CqMGs
 OwPzIVlIuEAPv96PGRq2NYzxEbRH505aFaJxu/mePzEF5rpTX+U5lZF4hyfYiGYcdj1q
 5avK7v2cum33gaNAIaITOFHi3hDPqYa2l4i0+xo+mMixNQetEvlj4CzgzDT+nxnrhZgQ
 uvDAAYQ798pO5vmRXcXR963T1Ryt0rSX8GP0AOuzsqzIjRFi2xdWkxsDLT4lT972iqCZ
 ZnQw==
X-Gm-Message-State: AOAM5322nDhlPhH5hTKjmaIaNisDpMShn5lOZGqTMIiOODu/cA1q5Xq/
 B7k8e/vN8gxzPpyDjli3sbs0A5rygZuE4w==
X-Google-Smtp-Source: ABdhPJy6JJ9czr6WUVzln8gQQGALKDKrCqS8h4hNm7E8wu1hMBCdyByHyMcahySZBy96/6PZAuJL4nhzZpbc0A==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:a983:b029:fb:973:956a with SMTP
 id bh3-20020a170902a983b02900fb0973956amr1414711plb.79.1623373825413; Thu, 10
 Jun 2021 18:10:25 -0700 (PDT)
Date: Thu, 10 Jun 2021 18:10:15 -0700
In-Reply-To: <20210611011020.3420067-1-ricarkol@google.com>
Message-Id: <20210611011020.3420067-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210611011020.3420067-1-ricarkol@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v4 1/6] KVM: selftests: Rename vm_handle_exception
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel test robot <oliver.sang@intel.com>,
 pbonzini@redhat.com, vkuznets@redhat.com
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

Rename the vm_handle_exception function to a name that indicates more
clearly that it installs something: vm_install_exception_handler.

Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
 tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 4 ++--
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..e9f584991332 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -391,7 +391,7 @@ struct ex_regs {
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
-void vm_handle_exception(struct kvm_vm *vm, int vector,
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index efe235044421..257c5c33d04e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1244,8 +1244,8 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
-void vm_handle_exception(struct kvm_vm *vm, int vector,
-			 void (*handler)(struct ex_regs *))
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+			       void (*handler)(struct ex_regs *))
 {
 	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
 
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 63096cea26c6..0864b2e3fd9e 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -154,8 +154,8 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
-	vm_handle_exception(vm, NMI_VECTOR, guest_nmi_handler);
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
 
 	pr_info("Running L1 which uses EVMCS to run L2\n");
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 732b244d6956..04ed975662c9 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -227,7 +227,7 @@ int main(void)
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	enter_guest(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 72c0d0797522..e3e20e8848d0 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -574,7 +574,7 @@ static void test_msr_filter_allow(void) {
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_exception_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	/* Process guest code userspace exits. */
 	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
@@ -588,12 +588,12 @@ static void test_msr_filter_allow(void) {
 	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
 	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
 
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 	run_guest(vm);
-	vm_handle_exception(vm, UD_VECTOR, NULL);
+	vm_install_exception_handler(vm, UD_VECTOR, NULL);
 
 	if (process_ucall(vm) != UCALL_DONE) {
-		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
+		vm_install_exception_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
 		/* Process emulated rdmsr and wrmsr instructions. */
 		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 2f964cdc273c..ed27269a01bb 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -462,7 +462,7 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
-	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
+	vm_install_exception_handler(vm, IPI_VECTOR, guest_ipi_handler);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
 
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
