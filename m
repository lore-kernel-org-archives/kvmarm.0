Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87933C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  2 Apr 2022 17:40:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E47F4B2C8;
	Sat,  2 Apr 2022 13:40:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MGbZHzhj6zwo; Sat,  2 Apr 2022 13:40:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03B1B4B2DD;
	Sat,  2 Apr 2022 13:40:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99C624B285
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4gcSDEDE9gGB for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Apr 2022 13:40:53 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42A814B2C7
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Apr 2022 13:40:53 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 x16-20020a6bfe10000000b006409f03e39eso3635363ioh.7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 02 Apr 2022 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
 b=pRdr/FNL4DJ4+FDZfYXkJBtQDCsAq7uj4Emtow3IUaukx62QJi2YKu7pn/kogEODph
 Y+Ut0ZuenWviBdtaf3uK2ywut5KwfSCOLvuj4E4oRTQycEzaxb0DzPh8RMPK+LNVr1U9
 BeWnTU5Vzf7eMYH9M9yl+lnM/35IO89F+KiuVVUfxbFmL7DCH09Jixfk7rVjhOmUP+j6
 a/towLy19ro+gsEvXWFYQ/JDk+Ch7sQoSUNbTLyRyCqqiA9WSF46VI49YlqOoWC3xzcx
 XazJkCyLa9KKCF8rswY5B8VWHE3+GnUCNK6RnnP18kj5JH5MFdP1r61Sm0hEYI+A6ayv
 064w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uRmXUJJ9UlZ6s6G2CwiIknxpFh1oZyxCOBIJvLxa8r4=;
 b=lpIzY5uHwdSbhGP61LmbIEquM3vR1LHtGs5737pMpi69+czEN+ryWw7RS7+FytuRSh
 N6L0Jcg0npPNA88lTfcwof9HU100v03Hw7CLmGNVpEmGCEX4Eur3yao7Bqo6qwEewhhZ
 qpG9o4w33Xdl9uARvZRtSBgyfCzxwCg2+c6i0N4T7jZjh1AHLbNMEy17Mq/tKuTfNUZX
 Q+LElTypGSorW0vts9udfNV57lWYi7aKDUQl9beKVULarFrMxhA/ox8JK7f5QfM5HsuG
 2V/L79dOtStFGZlfYKpGn76ZqAw7ED/te78vCdokgz9Q6t9kxOrCOeDESJ5xgU/p+8m+
 I/BQ==
X-Gm-Message-State: AOAM533bN4jwZn2RYAk9jh//4nhKvPrLTAG4MK+1gOktHNuGfaWq7yy4
 Zu18HfdKH/hbgDJf5DC256oO+A57FnK4x7wuBYywN85dzP1PvZu7rfmM5MAtRzmSyCOxvW6etjU
 0dfB4UaufGmYFpIHnHz10jiPqYy4h/qwjMaCHakVrS8vdpMdqYOSKAWJG7nOo79rjXojX3A==
X-Google-Smtp-Source: ABdhPJxfhOuV+H0OWvhKyqVH+yGUG1Gyfq61aVtKlvvdZjUHlwISHe0FlEzqyL1csiERacH6j/kPsSDcnBY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:8d8b:0:b0:645:eb9e:6765 with
 SMTP id
 p133-20020a6b8d8b000000b00645eb9e6765mr2056322iod.215.1648921252570; Sat, 02
 Apr 2022 10:40:52 -0700 (PDT)
Date: Sat,  2 Apr 2022 17:40:44 +0000
In-Reply-To: <20220402174044.2263418-1-oupton@google.com>
Message-Id: <20220402174044.2263418-5-oupton@google.com>
Mime-Version: 1.0
References: <20220402174044.2263418-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH 4/4] selftests: KVM: Free the GIC FD when cleaning up in
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
