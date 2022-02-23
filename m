Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48FBC43219
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6414C3FA;
	Tue, 22 Feb 2022 23:19:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LZRemlvg8lll; Tue, 22 Feb 2022 23:19:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 303684C40B;
	Tue, 22 Feb 2022 23:19:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CA74C404
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nde6WhfjsAet for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:55 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F40E24C410
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:54 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 d194-20020a6bcdcb000000b0063a4e3b9da6so13061639iog.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=K05fvQicaJYGcAIRS+q3c6MkmVYlSOGtWB1E2Xpx9MY=;
 b=cOV3DkQSHq8C48kNwXLpNqrxnZk9U+32V6P3HSyML9YbmrhB9wp81h7jhwVl/BpCqp
 h2aaSCvunxnq2XwAtZ1NtbqBwAOrxpRa+eHfEcVwNrXoQNJbkv8NgvkZil8RZcCW8nhk
 LDHAd5hcLqQYYbTCQdwRCV8uOMAmmEvFy+HLNuti+JebtBhqTOXz1s5fXEXSzHMaCgiX
 QUlt5e2OX2lRDdyqZzb78bOqCS0ytqCucVdJQDSHaY4t/Zcdwnj/oVMNGNPD/rISo5Px
 McJaaBVKTXD6blSeU+rgmYUaKgXlnL9XpuREraZ4zPtR/EIt8cDCs6QfzazCuila0Qoy
 +BgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=K05fvQicaJYGcAIRS+q3c6MkmVYlSOGtWB1E2Xpx9MY=;
 b=h4ZbRUTtlc7TVC/UZs1i6mF5RTMvbCjQrXG/VKZ1f9BNnJQLr0Z1mgKT7c3fZno+y3
 jey3bQ+nmQbhtmIkhmRPVdY/7hj90Oo5U55no/amcY548a19Cy9zcdWC300Ntur7Btxm
 q33BjYCC+OaLDakCpRaZ1Da5wYILjCqSRqN6nYq8gTs3qUaLeAl7SZ06dQxbYj3GMa/5
 tUuIbD6WQ3qM7Jgt/XCTJB1AXswy4AUuqPtdUR1UV5wvRQqqBDj1y0CH42HqBhX4P0hM
 hrNMLXlygvD+SVdmZZs4884qnhdzgUaZy1hGzElFW6zRMyfpUBGdv0SCU4/5XSlt5qQ7
 ax/g==
X-Gm-Message-State: AOAM532odNdxD6nDfSaPmS2haeqaYo/Qa7PTL5/d6mB8wPvNjK8WyoMq
 aTTl3mg+11WT0lphGIowDZvATjOq3WRDbgmDgUZwkWuU9U3akw07F/vUSW2TsNijvpCikz11cnu
 3r86kDfJoB1JFnMKw1MwqWPEw3A+rUA/rPKIpejZLFVvbw4knCp+P+W0jjz1VPs1s02tMLA==
X-Google-Smtp-Source: ABdhPJx9EK42sxEH+BG+6tOThbTFf2MQuU87W3tqJAj/WLPK9D04S/Ht5IzLgrLm9XmGiETk6n0T50MIUic=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:9406:0:b0:2be:6ace:7510 with
 SMTP id
 c6-20020a929406000000b002be6ace7510mr22283790ili.291.1645589994488; Tue, 22
 Feb 2022 20:19:54 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:40 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-16-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 15/19] selftests: KVM: Rename psci_cpu_on_test to psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore                          | 2 +-
 tools/testing/selftests/kvm/Makefile                            | 2 +-
 .../selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c}   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename tools/testing/selftests/kvm/aarch64/{psci_cpu_on_test.c => psci_test.c} (100%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..ac69108d9ffd 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,7 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vgic_init
 /aarch64/vgic_irq
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..61e11e372366 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,7 +103,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
