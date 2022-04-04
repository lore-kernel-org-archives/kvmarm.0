Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23373C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 21:46:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A154B2D1;
	Mon,  4 Apr 2022 17:46:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tefmlga7mzPT; Mon,  4 Apr 2022 17:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A663B4B2B5;
	Mon,  4 Apr 2022 17:46:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A599E4B29D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lv+QNtYTXYnF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 17:46:50 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52E664B1B6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 17:46:50 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 mp4-20020a17090b190400b001ca7801fe4dso305362pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 14:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bgj4NZpJwoartOALBkABgI03/83ehDZ+dNPnSd5eEa8=;
 b=cFb4s+itgwCPDnzf1h7IWr8F+AYDXeQp9cHQo6gByutC9zEymjvH63Z7Nw4/sNshPb
 r/L8uoKBEXAOM4wgcJNw5vH0AXTa5GngBRNG2dxHOOoZm2X/2F2V6Nt+O8HdMMCm3H2K
 8+5lGF7i1HpxtucB/Um16EAqVNz9xQb8aNQHaGXIckJLkxiySGMFiPYTtar2GlaT9cPn
 82FhxJ+xRQm1VH1cuog+LXAa7//J8x/gCxjVxNjoqu25z4ey92COlrDA/TTlJ8NGpY8k
 /B33s76ZPQwp7chJfbMIlVq2hTzp+lF2MsFqW8+50mCfGlQH/dnsQjs/rs9eF43sMwFv
 RaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bgj4NZpJwoartOALBkABgI03/83ehDZ+dNPnSd5eEa8=;
 b=4TW6G3wZNkLfe0dKv0bb0Q+pvm2wtE0vqA8wp/vBKuSskO43nqL6dFpAlEBYbrPxRZ
 GYaS/aXlYGIul5e16aEloNJCWOsplEwFDXb/zch6XG5DQUkfjBnu9Zv6+6fzbL0OTkTM
 iPL8BVHL4Dr/IWtk9DWFQvbD37gpbzIUODUETQKqJ7a+U0J+GB8HiCo8VUW9+aUpp1Fk
 SAx3V/ivOUX0VkKLO0oDmix870cUfluispPQaIhS1ebzDCKc45fA7B0IVKy35C0hc8e+
 6jWTDz6vOD6m506YZcHOeCpCLCtxFBe/gMDWLFIpXYX4UyQkebwWDE96FjBzLIk/sYew
 w+Bw==
X-Gm-Message-State: AOAM531V86/vHdLIvL6HU2IwWBD0GPzCWHBN/P16UHkQws49LYHMFcFJ
 koqMLSRLNxoH4TYGi3Ocl/oVPn/YNyb4WQ==
X-Google-Smtp-Source: ABdhPJz5PNgnFZ3AfMQBuUBc7BAhXFMbNhPnmChySNjWMKVPyJyuUxWTzki/MWh6TI0Av7CTOmLsCv5ZfQA2tg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:2f41:0:b0:382:26ba:8855 with SMTP id
 v62-20020a632f41000000b0038226ba8855mr183442pgv.310.1649108809529; Mon, 04
 Apr 2022 14:46:49 -0700 (PDT)
Date: Mon,  4 Apr 2022 14:46:40 -0700
In-Reply-To: <20220404214642.3201659-1-ricarkol@google.com>
Message-Id: <20220404214642.3201659-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220404214642.3201659-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v4 2/4] KVM: selftests: add is_cpu_eligible_to_run() utility
 function
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
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

Add is_cpu_eligible_to_run() utility function, which checks whether the current
process, or one of its threads, is eligible to run on a particular CPU.
This information is obtained using sched_getaffinity.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/test_util.c   | 20 ++++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 99e0dcdc923f..a7653f369b6c 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -143,4 +143,6 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+bool is_cpu_eligible_to_run(int pcpu);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..7813a68333c0 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2020, Google LLC.
  */
+#define _GNU_SOURCE
 
 #include <assert.h>
 #include <ctype.h>
@@ -13,7 +14,9 @@
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <linux/mman.h>
-#include "linux/kernel.h"
+#include <linux/kernel.h>
+#include <sched.h>
+#include <sys/sysinfo.h>
 
 #include "test_util.h"
 
@@ -334,3 +337,18 @@ long get_run_delay(void)
 
 	return val[1];
 }
+
+bool is_cpu_eligible_to_run(int pcpu)
+{
+	cpu_set_t cpuset;
+	long i, nprocs;
+
+	nprocs = get_nprocs_conf();
+	sched_getaffinity(0, sizeof(cpu_set_t), &cpuset);
+	for (i = 0; i < nprocs; i++) {
+		if (i == pcpu)
+			return CPU_ISSET(i, &cpuset);
+	}
+
+	return false;
+}
-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
