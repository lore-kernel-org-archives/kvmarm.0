Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE2BCCA479
	for <kvmarm@archiver.kernel.org>; Sat, 18 Jun 2022 00:16:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C0034B38F;
	Fri, 17 Jun 2022 20:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id chDaI1v7LIqs; Fri, 17 Jun 2022 20:16:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8614B4B3A0;
	Fri, 17 Jun 2022 20:16:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E933B4B389
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 20:16:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bIvc40JvbbQJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 20:16:27 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD4804B38D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 20:16:27 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 cd16-20020a056a00421000b00520785db095so2575807pfb.15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 17:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=reply-to:date:in-reply-to:message-id:mime-version:references
 :subject:from:to:cc;
 bh=+kEOXupEgF3LEKaQ7ETtoR1RHv4ePLtA8ZhkwBe1RYk=;
 b=Dn05cv6fq5texyrcU+sgiFL6XElkOLr41OAqA7yu/YCnT3xe/CdMaKCDUb1d0e5uXg
 lMPAVJ0reAvcdyRvnIfWoeDL9sd1vhVHkOGHHlgWb1QdAt9GlJOd94PvMY4miywZXe7Y
 idwx5fC1h/wFYKMk0dPdRDEO+xMQ9WvDcMHgED/GS8UD68D98jVJWN4BUMbgzmlEVAhS
 2dIQkU0V/dN0ooZLh037pFfG6H3PI9Z2Wa32o3Jt2pzVHBd8EFgHlKGw6jEM6KaXI4Q+
 /6bGTvgNdYj3gmtIbUzGeExDloxJPM10xvcTCVAWHovIzmFD1dWbvQBhIlwBQPpmdPUz
 vNBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:date:in-reply-to:message-id
 :mime-version:references:subject:from:to:cc;
 bh=+kEOXupEgF3LEKaQ7ETtoR1RHv4ePLtA8ZhkwBe1RYk=;
 b=a2b5wAVzECX8us6tDzYHPpVHXHdSGGgaOinsPGsxBz5my3F2szpGD8hxPP51Bqog9c
 MXTK+mrA5jpv4MF1DEfyEjXWYD4nlZ7pFmIgZdLJieHQMoxb1EwlQx+ua+eEbEtzCSEo
 zQzSAcGs9OGvGsyuojnFwygG6JU128KDIGJ9e9KTz18j+E2dgUC11LMXXI8CGqdCX/eu
 Uw/0DoxQP+nlVsTCwDQwYKMZoQ+Uvx0vOq6nOWhB9rUPpUu8I9Naqc4QQOejQXKBuv0k
 YdwCWID0UBCgK4LMnLG/Xa25BUpe6JjPTAKnX11NnbWM8U6zYVf9CWlLo7KbPiHSEJB8
 rYDA==
X-Gm-Message-State: AJIora81r0YEc/Mhhae8HSU1u+rNXi2k2rTwM1KJOiWP07f1+VgcA3XV
 uMXcewhVjm6cr+j+KENMXLOhN30GQcM=
X-Google-Smtp-Source: AGRyM1tH2/eIDP/hPfMRCm8Pd53yxKYarOYPiOjvNi7PZ3OcG2KrqTiKgCQWjn0rLrRXuxKbVTARh+hJDQU=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1584:b0:51c:7932:975a with SMTP id
 u4-20020a056a00158400b0051c7932975amr12598033pfk.80.1655511386752; Fri, 17
 Jun 2022 17:16:26 -0700 (PDT)
Date: Sat, 18 Jun 2022 00:16:18 +0000
In-Reply-To: <20220618001618.1840806-1-seanjc@google.com>
Message-Id: <20220618001618.1840806-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220618001618.1840806-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH 3/3] KVM: selftest: Add __weak stubs for ucall_arch_(un)init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>,
 kvm-riscv@lists.infradead.org, Atish Patra <atishp@atishpatra.org>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
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

Provide __weak stubs for (un)initializing ucall, aarch64 is the only
architecture that actually needs to do work.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/riscv/ucall.c  |  8 --------
 tools/testing/selftests/kvm/lib/s390x/ucall.c  |  8 --------
 tools/testing/selftests/kvm/lib/ucall_common.c | 10 ++++++++++
 tools/testing/selftests/kvm/lib/x86_64/ucall.c |  8 --------
 4 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index 37e091d4366e..1c6c0432bdd7 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -10,14 +10,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 			unsigned long arg1, unsigned long arg2,
 			unsigned long arg3, unsigned long arg4,
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 0f695a031d35..3e8d4275c9e4 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -6,14 +6,6 @@
  */
 #include "kvm_util.h"
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index c488ed23d0dd..a1e563fd8fcc 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -1,6 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include "kvm_util.h"
 
+void __weak ucall_arch_init(struct kvm_vm *vm, void *arg)
+{
+
+}
+
+void __weak ucall_arch_uninit(struct kvm_vm *vm)
+{
+
+}
+
 void ucall(uint64_t cmd, int nargs, ...)
 {
 	struct ucall uc = {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index ec53a406f689..2f724f0bed32 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -8,14 +8,6 @@
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
-void ucall_arch_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_arch_uninit(struct kvm_vm *vm)
-{
-}
-
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
 	asm volatile("in %[port], %%al"
-- 
2.37.0.rc0.104.g0611611a94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
