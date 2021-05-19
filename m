Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54610C43460
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 14:07:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7E346135F
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 14:07:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7E346135F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B4FF4B53D;
	Wed, 19 May 2021 10:07:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EXx3j4eRfeGs; Wed, 19 May 2021 10:07:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 726814B6A8;
	Wed, 19 May 2021 10:07:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 450164B522
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 10:07:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vk3kAvFLHpNL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 10:07:42 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C8644B53D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 10:07:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1621433262;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=7GTQBNGZoTX0xb+GuNByFAV5LQVduIalFtZy8xJ1/rU=;
 b=Ej0oHLzdIwNrGYT4e/FC9TDATB3Yel9b30zf0jELqT+X2tniPLi9ApbJSr1MijxlcRnFCn
 4ENJwqY+sByNLJtsj4DbhPRPjX2HFSsUaMxIHPX9v7LZt4fTe/dyO5TYepXse/MJpsHpoT
 CNi+TW1geM2CqGznJHunHdpvqTt2Y8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-VkdFJco2M3uZy_aO1_Nmdg-1; Wed, 19 May 2021 10:07:40 -0400
X-MC-Unique: VkdFJco2M3uZy_aO1_Nmdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75FD8101371E;
 Wed, 19 May 2021 14:07:39 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 6B19810013C1;
 Wed, 19 May 2021 14:07:32 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 2/5] KVM: arm64: selftests: get-reg-list: Prepare to run
 multiple configs at once
Date: Wed, 19 May 2021 16:07:23 +0200
Message-Id: <20210519140726.892632-3-drjones@redhat.com>
In-Reply-To: <20210519140726.892632-1-drjones@redhat.com>
References: <20210519140726.892632-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
 .../selftests/kvm/aarch64/get-reg-list.c      | 68 ++++++++++++++-----
 1 file changed, 51 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index e5d9cb312717..06f737973511 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -53,8 +53,8 @@ struct vcpu_config {
 	struct reg_sublist sublists[];
 };
 
-static struct vcpu_config vregs_config;
-static struct vcpu_config sve_config;
+static struct vcpu_config *vcpu_configs[];
+static int vcpu_configs_n;
 
 #define for_each_sublist(c, s)							\
 	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
@@ -351,29 +351,20 @@ static void check_supported(struct vcpu_config *c)
 	}
 }
 
-int main(int ac, char **av)
+static bool print_list;
+static bool print_filtered;
+static bool fixup_core_regs;
+
+static void run_test(struct vcpu_config *c)
 {
-	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
 	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
-	bool print_list = false, print_filtered = false, fixup_core_regs = false;
 	struct kvm_vm *vm;
 	struct reg_sublist *s;
 
 	check_supported(c);
 
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
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
 	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
@@ -393,7 +384,7 @@ int main(int ac, char **av)
 				print_reg(c, id);
 		}
 		putchar('\n');
-		return 0;
+		return;
 	}
 
 	/*
@@ -492,6 +483,44 @@ int main(int ac, char **av)
 		    "%d registers failed get; %d registers failed set; %d registers failed reject",
 		    c->name, missing_regs, failed_get, failed_set, failed_reject);
 
+	pr_info("%s: PASS\n", c->name);
+	blessed_n = 0;
+	free(blessed_reg);
+	free(reg_list);
+	kvm_vm_free(vm);
+}
+
+int main(int ac, char **av)
+{
+	struct vcpu_config *c, *sel = NULL;
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
+		sel = vcpu_configs[0];
+	}
+
+	for (i = 0; i < vcpu_configs_n; ++i) {
+		c = vcpu_configs[i];
+		if (sel && c != sel)
+			continue;
+		run_test(c);
+	}
+
 	return 0;
 }
 
@@ -889,3 +918,8 @@ static struct vcpu_config sve_config = {
 	{0},
 	},
 };
+
+static struct vcpu_config *vcpu_configs[] = {
+	reg_list_sve() ? &sve_config : &vregs_config,
+};
+static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
