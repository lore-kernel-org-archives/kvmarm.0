Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F9EC433ED
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9DB596141E
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 23:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DB596141E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5139F4B45B;
	Fri, 30 Apr 2021 19:24:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QblNijQ8G50w; Fri, 30 Apr 2021 19:24:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 075184B47F;
	Fri, 30 Apr 2021 19:24:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F844B458
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 54hJfLcxIa-h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 19:24:27 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 674314B4BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 19:24:23 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 l35-20020a635b630000b029020f1edbc5dfso5182056pgm.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 16:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ZyjdoDvj+0d1MrdvPreqK5eup22FMf+XNotdYUvQgRI=;
 b=mVFEcJIz8TqMr35h+/Q4+Dav2KYnjMb7ka5/Gc219hGHhFNsWibr/XuA/YPgX+YHCA
 NeqV+TgK7Yo40Do4rWs0FSy/f7DQXYjOid3a1piWerc8fAYFMONv/Xny8SzTye5CFkdu
 8UO6h2hEwmqxxb/nMC1eCrRL0GCG7JLy8rL2TxB6lsJcFj+nEOnkJ7oqynUSoat7ZCAj
 axu0v6pjMoecsg8X9qkeuwsozgIWn4HN2ajHRbMCEll5feWXxuNRWaVkgdp/OnOWR817
 nwjerzB/XdDGaABVwh7/aFrycJgqzKOIITDywOnNcXrzrlOM/7SnoNQIubrddxI85XBo
 HOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ZyjdoDvj+0d1MrdvPreqK5eup22FMf+XNotdYUvQgRI=;
 b=O2s0BzAQupGRdUWRkOCJ/IdgMKhoxWAFwY6IPldaFO64L+bSMEnFcmJR7Qgz1cpqOj
 OCH/zaMfykUlGELlCzenKReIUbI9RPqXlzqizqTxssK4ur32LQg721lEBgtjmMMeCo6C
 rqie36hlXsuNMvX2oVL0sttlMs9Djkx+/N7bN/Ae0tYlCieBccky0SGXDRRwDjjZZ3CF
 XMXikNrEqAovMvVOpnF+dvnYJQmW5s0VxPt9+vvenMcAJj/mRwjEwKcYQSllF+/Lb8tQ
 m3m8X75NttYC/b+9xNw++8eDHudXemMTQcHSVRHA4d8yHR6mRG30w0h7nJLlDudYwmVu
 R6Fg==
X-Gm-Message-State: AOAM533XhG15W4s+VinvXj0yLz1YzKvgxWMsiC/8WRTgNNOSxKpH4PPY
 LhUoqDbSPpi52CZplurnHn/1I4PdaKUW6w==
X-Google-Smtp-Source: ABdhPJw/WgOmany3vFjVOVJu6fs2Y1+1Pd0XL579JpPqAIrVqPNcaxkdQAkHOnqSS0bi/PanAPM14cJfMb63Xw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:853:b029:27b:7bf6:f322 with SMTP
 id q19-20020a056a000853b029027b7bf6f322mr7086773pfk.7.1619825052185; Fri, 30
 Apr 2021 16:24:12 -0700 (PDT)
Date: Fri, 30 Apr 2021 16:24:03 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 1/5] KVM: selftests: Rename vm_handle_exception
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pbonzini@redhat.com
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
clearly that it installs something: vm_install_vector_handler.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h    | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c        | 4 ++--
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c          | 2 +-
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c        | 8 ++++----
 tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..12889d3e8948 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -391,7 +391,7 @@ struct ex_regs {
 
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
-void vm_handle_exception(struct kvm_vm *vm, int vector,
+void vm_install_vector_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a8906e60a108..e156061263a6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1250,8 +1250,8 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
 
-void vm_handle_exception(struct kvm_vm *vm, int vector,
-			 void (*handler)(struct ex_regs *))
+void vm_install_vector_handler(struct kvm_vm *vm, int vector,
+			       void (*handler)(struct ex_regs *))
 {
 	vm_vaddr_t *handlers = (vm_vaddr_t *)addr_gva2hva(vm, vm->handlers);
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 732b244d6956..5ae5f748723a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -227,7 +227,7 @@ int main(void)
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	enter_guest(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 72c0d0797522..20c373e2d329 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -574,7 +574,7 @@ static void test_msr_filter_allow(void) {
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	vm_handle_exception(vm, GP_VECTOR, guest_gp_handler);
+	vm_install_vector_handler(vm, GP_VECTOR, guest_gp_handler);
 
 	/* Process guest code userspace exits. */
 	run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
@@ -588,12 +588,12 @@ static void test_msr_filter_allow(void) {
 	run_guest_then_process_wrmsr(vm, MSR_NON_EXISTENT);
 	run_guest_then_process_rdmsr(vm, MSR_NON_EXISTENT);
 
-	vm_handle_exception(vm, UD_VECTOR, guest_ud_handler);
+	vm_install_vector_handler(vm, UD_VECTOR, guest_ud_handler);
 	run_guest(vm);
-	vm_handle_exception(vm, UD_VECTOR, NULL);
+	vm_install_vector_handler(vm, UD_VECTOR, NULL);
 
 	if (process_ucall(vm) != UCALL_DONE) {
-		vm_handle_exception(vm, GP_VECTOR, guest_fep_gp_handler);
+		vm_install_vector_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
 		/* Process emulated rdmsr and wrmsr instructions. */
 		run_guest_then_process_rdmsr(vm, MSR_IA32_XSS);
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index 2f964cdc273c..ded70ff465d5 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -462,7 +462,7 @@ int main(int argc, char *argv[])
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, HALTER_VCPU_ID);
-	vm_handle_exception(vm, IPI_VECTOR, guest_ipi_handler);
+	vm_install_vector_handler(vm, IPI_VECTOR, guest_ipi_handler);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA, 0);
 
-- 
2.31.1.527.g47e6f16901-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
