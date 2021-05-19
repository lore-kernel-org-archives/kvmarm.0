Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C047C43470
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 14:07:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C076613BE
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 14:07:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C076613BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B40EA4B869;
	Wed, 19 May 2021 10:07:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nSLZs1WCclii; Wed, 19 May 2021 10:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E94874B8C9;
	Wed, 19 May 2021 10:07:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 964CE4B6A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 10:07:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OHNeHNWLeoqz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 10:07:51 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D022F4B896
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 10:07:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1621433269;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5dG51UGizLO9xpsnpk14nLMa4p/87iPLXVpM3MRlp6w=;
 b=cUHxLP6Lbi1G34kzZRLNl2JW6WTX0SZno1JyaFog+6GiQtHZCzol5+UdPoc69HHhsuie5n
 SABawZcMkbFRMzp7yDUsTCacxnPxzo/EImOqA6Z4vp+qWAEAMGZInBclXQ4C/WiR+eAOxQ
 PFNMlLDlRraWh4pXTNIJw4H2OQXhg/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-3yhXN_K6MyK7xJxslAQHbQ-1; Wed, 19 May 2021 10:07:45 -0400
X-MC-Unique: 3yhXN_K6MyK7xJxslAQHbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2290D80293C;
 Wed, 19 May 2021 14:07:44 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.192.248])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0F36910013C1;
 Wed, 19 May 2021 14:07:41 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 4/5] KVM: arm64: selftests: get-reg-list: Remove
 get-reg-list-sve
Date: Wed, 19 May 2021 16:07:25 +0200
Message-Id: <20210519140726.892632-5-drjones@redhat.com>
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

Now that we can easily run the test for multiple vcpu configs, let's
merge get-reg-list and get-reg-list-sve into just get-reg-list. We
also add a final change to make it more possible to run multiple
tests, which is to fork the test, rather than directly run it. That
allows a test to fail, but subsequent tests can still run.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 -
 tools/testing/selftests/kvm/Makefile          |  1 -
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |  3 --
 .../selftests/kvm/aarch64/get-reg-list.c      | 31 +++++++++++++------
 4 files changed, 21 insertions(+), 15 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index bd83158e0e0b..e3745c90d8b2 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/get-reg-list
-/aarch64/get-reg-list-sve
 /aarch64/vgic_init
 /s390x/memop
 /s390x/resets
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index e439d027939d..bf54fc23bcff 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -78,7 +78,6 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c b/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
deleted file mode 100644
index efba76682b4b..000000000000
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
+++ /dev/null
@@ -1,3 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#define REG_LIST_SVE
-#include "get-reg-list.c"
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index be1a2877d7fa..dc06a28bfb74 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -27,16 +27,13 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/wait.h>
 #include "kvm_util.h"
 #include "test_util.h"
 #include "processor.h"
 
-#ifdef REG_LIST_SVE
-#define reg_list_sve() (true)
-#else
-#define reg_list_sve() (false)
-#endif
-
 static struct kvm_reg_list *reg_list;
 static __u64 *blessed_reg, blessed_n;
 
@@ -539,7 +536,8 @@ static struct vcpu_config *parse_config(const char *config)
 int main(int ac, char **av)
 {
 	struct vcpu_config *c, *sel = NULL;
-	int i;
+	int i, ret = 0;
+	pid_t pid;
 
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
@@ -568,10 +566,22 @@ int main(int ac, char **av)
 		c = vcpu_configs[i];
 		if (sel && c != sel)
 			continue;
-		run_test(c);
+
+		pid = fork();
+
+		if (!pid) {
+			run_test(c);
+			exit(0);
+		} else {
+			int wstatus;
+			pid_t wpid = wait(&wstatus);
+			TEST_ASSERT(wpid == pid && WIFEXITED(wstatus), "wait: Unexpected return");
+			if (WEXITSTATUS(wstatus) && WEXITSTATUS(wstatus) != KSFT_SKIP)
+				ret = KSFT_FAIL;
+		}
 	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -970,6 +980,7 @@ static struct vcpu_config sve_config = {
 };
 
 static struct vcpu_config *vcpu_configs[] = {
-	reg_list_sve() ? &sve_config : &vregs_config,
+	&vregs_config,
+	&sve_config,
 };
 static int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
