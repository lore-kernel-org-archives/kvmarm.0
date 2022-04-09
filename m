Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B169C433EF
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 352124B240;
	Sat,  9 Apr 2022 14:46:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aVhQF300592O; Sat,  9 Apr 2022 14:46:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4904C4B1FD;
	Sat,  9 Apr 2022 14:46:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C964B0ED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QLzE6RKf0qFE for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:10 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1FD7D4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:09 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 q9-20020a056e02106900b002ca9abc4281so1365463ilj.9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VidXWl4NH6Hry9qZzq5ca2VxcR9Odk6Nar4a4f+oWvU=;
 b=ek/S6WuWIb3shY/gBGZqdK34+t9TRPzxUssPucli2yqNkXS2MmMO6m5wmA2OvUDmOJ
 uTadVD976jZpe7AKO5trQKXOH+R28jTCX5S9Av8CR1TNeqWgYJ6DY5tZ+uQ865GoZEa/
 QIpxybUjAkgF94A4D0vFlesLwG4EIo3M23Q7Z9wugnwDCP8j7aHflpDIsckmCUBg0h15
 Vpz65XqnN9/baOg0f+a4KEF47Ihm5tlXvL58LoMD1igQlrmYJcTwZqmmY7ZsqUZdnDqP
 KEYmBEPxid8Q59tSZKWRMkUmZUVDbQm1B37OGxHL/FrLrqQia3cB4ewnlwKc5/5tuozV
 8CUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VidXWl4NH6Hry9qZzq5ca2VxcR9Odk6Nar4a4f+oWvU=;
 b=pird31I1kLoDuzt7UMpmM3zSeizpp8WKG1y/f+F0r3CxXK1obYX6AhkCKe1rTTnrMN
 yVeYQFlNppbo/wIK6OlpHBRXiUHVw2ocPL0v26E6+oOifnaIu2TXyxGCnERXAapIbuNg
 2tgvLR1Wsh7lPKmE0W6h+blP3VSwXhcNV15b++UQMZ7zT7A/6QNrRq1H0BAIPA2H83Uq
 JHMGqJYbYKnjVObXPIWe8VEy5bCzx/4FSQiejL6GfpkarkhVs8DDBaAc8Qd1wcs+bnRA
 hSrQbuioA6gTkAPyCko7sOF8/HwlzI0tBRLuLuG+kl2Aptk3oi24mHaqa4lH5Lt/yLTp
 WsFA==
X-Gm-Message-State: AOAM533K4ZLJ7BUcAK8eRgmdseGeUg/TO1Mxqycos9INEQd7mKbGXGiV
 dJrGUFMxloFgq/SdXiAWqSf8R9uQmK5fRlZshoqPkbWpfTQV9pJnVq5CU2MgSp6+Ir95Z/D9Pq/
 62bybSjV36zS7WBWL/997050quDrA+Fy1o5UBpYbTwdpnsYTQuIQ78PkpLQ3ViwYhQXiJ1g==
X-Google-Smtp-Source: ABdhPJyOlIPbNXBdcHXns5CIYQoET7JOk9HcIP8HQoCjskl12aloONe/ErTVMDy3hBxqIExT3j5Vo5p8lAo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:13d4:b0:649:934f:e957
 with SMTP id
 o20-20020a05660213d400b00649934fe957mr10624778iov.25.1649529968492; Sat, 09
 Apr 2022 11:46:08 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:45 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-10-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 09/13] selftests: KVM: Rename psci_cpu_on_test to psci_test
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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
index 573d93a1d61f..ee60f3cdc0bb 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -2,7 +2,7 @@
 /aarch64/arch_timer
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
-/aarch64/psci_cpu_on_test
+/aarch64/psci_test
 /aarch64/vcpu_width_config
 /aarch64/vgic_init
 /aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 681b173aa87c..c2cf4d318296 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -105,7 +105,7 @@ TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
-TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
similarity index 100%
rename from tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
rename to tools/testing/selftests/kvm/aarch64/psci_test.c
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
