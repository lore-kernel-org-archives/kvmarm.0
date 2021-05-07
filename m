Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB907C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 20:04:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D5DC6144F
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 20:04:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D5DC6144F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E3C14B6BF;
	Fri,  7 May 2021 16:04:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oo2UUcc3lTjc; Fri,  7 May 2021 16:04:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D399E4B743;
	Fri,  7 May 2021 16:04:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 418634B6BF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 16:04:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1K2otTP+yXWY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 16:04:35 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28CF44B1D9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 16:04:35 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620417875;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hF4RU+mW6w91UiYAvJJFN81TYJXmTJV1RSQ9fzh5Kxk=;
 b=PpocKXhXMRirLxF5IFdF55LbOe29hf+tcECqs2+ua3Ja4xeVyiETIDDOQt3dU6j4587BRO
 psVFG0jFAmklrvAUkyL9QnbR4rkIpIXwp6hSvaBvo2o2XcwGtYRSMheSRKNDjy2OpE/zib
 kCaEIVfMqUInJ2uFBIpZJYOisArUaEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-LKN17DpHNASvNB1sfGESpA-1; Fri, 07 May 2021 16:04:33 -0400
X-MC-Unique: LKN17DpHNASvNB1sfGESpA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E978E1854E24;
 Fri,  7 May 2021 20:04:31 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.135])
 by smtp.corp.redhat.com (Postfix) with ESMTP id D690A1A26A;
 Fri,  7 May 2021 20:04:29 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 3/6] KVM: arm64: selftests: get-reg-list: Prepare to run
 multiple configs at once
Date: Fri,  7 May 2021 22:04:13 +0200
Message-Id: <20210507200416.198055-4-drjones@redhat.com>
In-Reply-To: <20210507200416.198055-1-drjones@redhat.com>
References: <20210507200416.198055-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

We don't want to have to create a new binary for each vcpu config, so
prepare to run the test for multiple vcpu configs in a single binary.
We do this by factoring out the test from main() and then looping over
configs. When given '--list' we still never print more than a single
reg-list for a single vcpu config though, because it would be confusing
otherwise.

No functional change intended.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 72 +++++++++++++------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index fbbeee634722..68d3be86d490 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -54,8 +54,7 @@ struct vcpu_config {
 	struct reg_sublist sublists[];
 };
 
-static struct vcpu_config vregs_config;
-static struct vcpu_config sve_config;
+static struct vcpu_config *vcpu_configs[];
 
 #define for_each_sublist(c, s)							\
 	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
@@ -386,35 +385,18 @@ static void print_reg_list(struct vcpu_config *c, bool print_list, bool print_fi
 			print_reg(c, id);
 	}
 	putchar('\n');
+
+	free(reg_list);
+	kvm_vm_free(vm);
 }
 
-int main(int ac, char **av)
+static void run_test(struct vcpu_config *c)
 {
-	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
-	bool print_list = false, print_filtered = false;
 	struct kvm_vm *vm;
 	struct reg_sublist *s;
 
-	check_supported(c);
-
-	for (i = 1; i < ac; ++i) {
-		if (strcmp(av[i], "--core-reg-fixup") == 0)
-			fixup_core_regs = true;
-		else if (strcmp(av[i], "--list") == 0)
-			print_list = true;
-		else if (strcmp(av[i], "--list-filtered") == 0)
-			print_filtered = true;
-		else
-			TEST_FAIL("Unknown option: %s\n", av[i]);
-	}
-
-	if (print_list || print_filtered) {
-		print_reg_list(c, print_list, print_filtered);
-		return 0;
-	}
-
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	reg_list_init(vm, c);
 
@@ -514,6 +496,45 @@ int main(int ac, char **av)
 		    "%d registers failed get; %d registers failed set; %d registers failed reject",
 		    c->name, missing_regs, failed_get, failed_set, failed_reject);
 
+	blessed_n = 0;
+	free(blessed_reg);
+	free(reg_list);
+	kvm_vm_free(vm);
+}
+
+int main(int ac, char **av)
+{
+	struct vcpu_config *c;
+	bool print_list = false, print_filtered = false;
+	int i;
+
+	for (i = 1; i < ac; ++i) {
+		if (strcmp(av[i], "--core-reg-fixup") == 0)
+			fixup_core_regs = true;
+		else if (strcmp(av[i], "--list") == 0)
+			print_list = true;
+		else if (strcmp(av[i], "--list-filtered") == 0)
+			print_filtered = true;
+		else
+			TEST_FAIL("Unknown option: %s\n", av[i]);
+	}
+
+	if (print_list || print_filtered) {
+		/*
+		 * We only want to print the register list of a single config.
+		 * TODO: Add command line support to pick which config.
+		 */
+		c = vcpu_configs[0];
+		check_supported(c);
+		print_reg_list(c, print_list, print_filtered);
+		return 0;
+	}
+
+	for (i = 0, c = vcpu_configs[0]; c; ++i, c = vcpu_configs[i]) {
+		check_supported(c);
+		run_test(c);
+	}
+
 	return 0;
 }
 
@@ -911,3 +932,8 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+
+static struct vcpu_config *vcpu_configs[] = {
+	reg_list_sve() ? &sve_config : &vregs_config,
+	NULL
+};
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
