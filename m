Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB37C43219
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 146C061269
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 146C061269
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE48C4B14D;
	Thu, 23 Sep 2021 15:16:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qEKpBphH0iEF; Thu, 23 Sep 2021 15:16:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E66FF4B164;
	Thu, 23 Sep 2021 15:16:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A04A54B0F5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DiO22n-I6ZWU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:24 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D3DF4A19A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:24 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 c27-20020a05620a165b00b003d3817c7c23so21661357qko.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=v6kM0fZgFnMyPqKLqGMM9XheburKn9OIi6ceURW+v10=;
 b=SxvLmQcN/i/qz9DPGEK003POrfs0mMcW82MLGenxyYOgKsjnbvZtZQ6Wpgks5XGJOE
 W5asMYsTjt+s3OgBeqJ2/1yKPGljqkXFAywEZ5hwj1p7R/XU1oh6zk2GtVfHXXFI0FE6
 ZvXmp5RhKJ1e2Lm/7c8z2l1DhzVC9T2fsO7DHaJi3H3c+3TvoGK8wy7SodQzP26Hv5L4
 jmO1VTEJLN9+zfEISbyg9chov7GbnmmMpRX3gpIqPrW8t0UkHQqf73l6CwsXApPsVoO9
 V37FzJS89cVsBUauJ9ca3SeLYfUom+mQRXoI6m9PNVKiDipyUpSU/M+9AEPlHUrPdLTi
 cMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=v6kM0fZgFnMyPqKLqGMM9XheburKn9OIi6ceURW+v10=;
 b=LH379xbHSdLOuSHPw0FZtEFhtI1y2NPWn/WgTgNS7xTAkM2e5mavvz8YuL5QRxeA8d
 o02Y5X210lKsRcNMyTu8Nb7tlVzDK3gnyY435qxvdUP/729Gb0pTa1/xbxbsRImKOYxT
 qgaps+32dNo70tQa+ilSuQj7GUBg7PEjoQcx/YqOhp7PT1qYjOPwJ9VQu/FRdTd64dIU
 /jLPB+glA+TTo0jkLgwtC8Mujtb30oVn9WM9rNSAA8L0K+ddniFiTIiI7j+tkpep7/eZ
 q2mXliyVITxRXL8bsui+KZObfyOU0bPWbcJtlDGlP5OH8CqjkUcNWPvCpQsjoeV72ATr
 wkYA==
X-Gm-Message-State: AOAM533QUqsDEz9J+B49fwH0F06oFDOvGCn+I4qrnBokLGlLsReQK0bw
 rrh7L+XTBn1bBdf9FNidbqzSNLuISybLsOltk1ZKbunImVrWPRKHcYkKzy8dWYc8rHAeWvCCxXu
 iPIagwrv3+PBe95heHb4ZQTwvdMi2VTow8pgfshB1e/8haRlIfMXSWarbOApGLte/3BZM/A==
X-Google-Smtp-Source: ABdhPJzkNSt2TQe/+BhleFUDyUx1HG5HAWzMvUvoxORmPFlzErhgqo3pu+ogu/d1eiq9Dtg0dRjls5m0EPU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:1271:: with SMTP id
 r17mr5988466qvv.48.1632424583699; Thu, 23 Sep 2021 12:16:23 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:06 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-8-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 07/11] selftests: KVM: Rename psci_cpu_on_test to psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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

There are other interactions with PSCI worth testing; rename the PSCI
test to make it more generic.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore                          | 2 +-
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 98053d3afbda..a11b89be744b 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vgic_init
 /s390x/memop
 /s390x/resets
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5d05801ab816..6907ee8f3239 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -86,7 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
