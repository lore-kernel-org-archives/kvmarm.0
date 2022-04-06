Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1BBC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  6 Apr 2022 23:56:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05DEB4B1A2;
	Wed,  6 Apr 2022 19:56:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MloHOCgbEPiX; Wed,  6 Apr 2022 19:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95AB4B21C;
	Wed,  6 Apr 2022 19:56:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66C674B1EC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id apGrrU5XsI0u for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2022 19:56:26 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 623234B1D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2022 19:56:26 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 j1-20020a056e020ee100b002ca5f068c8fso2754313ilk.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2022 16:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
 b=SzJkCsZV7iMptbeHI6SunPJiVnXUQJsGsvB3EBMHTQhojiWMdyE3B/pfzOPMhedu0u
 OmjdVa4Lek6+jecHKQATT9mNii32Oo1kFhrG4QCstEBMVPNiL24y7OBfjRPA9wUhdRbA
 TAeB+mX1bc+TzRM6ne/WhlZq4XBLaHRKGejrM8I2ujdW/m8+EoB42jAXHLzGSV6cQQ+s
 riOWVn4yLnlNd/SyoucnJAS05H14Mk9xZheCP9DQVf8ivm5s8/I2K3POTNfZgmfxpJb9
 IbOTnSOlGW76Kk118l5vziFY9iX3OH4rZkouN2yrL80iW8lU17cmw4IdwL/McIe4gmIi
 UcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
 b=2JLCE7wVWXqkTP1A+9MaNHXJFSmcY/LN4fgDIRwQl18Ii8etaqKmBu+hs8FCzMsGEq
 2AkCCOiBWTDTsVOlVDheXAlMIAEGZTH0HcSwVX288aDC4yRNv3bSfYI56CO1fUSf72OZ
 m/SvtFb3rBU/tywYZQbZL4EjxbYol+rkuti1jLBqfcARAzeHBeD6RYF8EnH9U7Esf7sM
 IXgTmzBCL37twznAr67dYV8XR7iOQno0PcDSIEY5ad8sFa+W5ic1kTInFkIDT8Q3zjQf
 kZqJtPY9rjU69nvN7qnmy7Qd2DXQWBfMu7n7S5tvu3thNRwQgtZqKmYmYJtbFzaCrvYj
 QBuA==
X-Gm-Message-State: AOAM533t7+0gYBerfSbRbcSMo9a/jhBdCp3LH79R0To7TWipQRgzoM/9
 PsmeD/ldVl6mywHjN4trViXsXW65Npo2pbtE4VWOpofhbhCnW4cybsvdsaBOcAi4NbxKk23ff8v
 vtA9GJdnS9yrbzTv3izgqaDUuTHrSo0drDBR/vZAVIShWjcUehn7t1z1Q9LIWAph9uWBWcA==
X-Google-Smtp-Source: ABdhPJzGNrYJp2IFGjhmrFmxuYB89kWWkYo6WwdyQZ1lPeVi+kRKHzYARL8aZVq18I7pX0Q/UZ3gqbn08tg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:5af:b0:2ca:396f:9d with
 SMTP id
 k15-20020a056e0205af00b002ca396f009dmr5221608ils.216.1649289385863; Wed, 06
 Apr 2022 16:56:25 -0700 (PDT)
Date: Wed,  6 Apr 2022 23:56:15 +0000
In-Reply-To: <20220406235615.1447180-1-oupton@google.com>
Message-Id: <20220406235615.1447180-4-oupton@google.com>
Mime-Version: 1.0
References: <20220406235615.1447180-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 3/3] selftests: KVM: Free the GIC FD when cleaning up in
 arch_timer
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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

In order to correctly destroy a VM, all references to the VM must be
freed. The arch_timer selftest creates a VGIC for the guest, which
itself holds a reference to the VM.

Close the GIC FD when cleaning up a VM.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index b08d30bf71c5..3b940a101bc0 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -362,11 +362,12 @@ static void test_init_timer_irq(struct kvm_vm *vm)
 	pr_debug("ptimer_irq: %d; vtimer_irq: %d\n", ptimer_irq, vtimer_irq);
 }
 
+static int gic_fd;
+
 static struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
 	unsigned int i;
-	int ret;
 	int nr_vcpus = test_args.nr_vcpus;
 
 	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
@@ -383,8 +384,8 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
-	if (ret < 0) {
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	if (gic_fd < 0) {
 		print_skip("Failed to create vgic-v3");
 		exit(KSFT_SKIP);
 	}
@@ -395,6 +396,12 @@ static struct kvm_vm *test_vm_create(void)
 	return vm;
 }
 
+static void test_vm_cleanup(struct kvm_vm *vm)
+{
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
 static void test_print_help(char *name)
 {
 	pr_info("Usage: %s [-h] [-n nr_vcpus] [-i iterations] [-p timer_period_ms]\n",
@@ -478,7 +485,7 @@ int main(int argc, char *argv[])
 
 	vm = test_vm_create();
 	test_run(vm);
-	kvm_vm_free(vm);
+	test_vm_cleanup(vm);
 
 	return 0;
 }
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
