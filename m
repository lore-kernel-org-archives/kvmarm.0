Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5155C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 19:42:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE4949DED;
	Wed,  2 Mar 2022 14:42:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hNUM98UrOdj8; Wed,  2 Mar 2022 14:42:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D93C49EDE;
	Wed,  2 Mar 2022 14:42:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA8E49E20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 14:42:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qCNtwE5tZUYz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 14:42:27 -0500 (EST)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C87C49DED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 14:42:27 -0500 (EST)
Received: by mail-il1-f202.google.com with SMTP id
 r4-20020a92d444000000b002c26d0c9354so2007850ilm.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 11:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=PCKbeMGnbMeKELdpOCOC6blFVgcWYPGEsQUKnbyj5go=;
 b=G0al7m5j2pHc4CKpHFPbAvY1Su3hfl9KYNhpUHasUGXkhZjiwnSE+L077x7HJGzxhc
 cXxJ4JwUSVkKnpf8t/HmJRhM/x7wMALqVExeShd5thY955fKWd0ZT1UDe9XqFSzvPOO8
 quu5C+hjVXWH6BPLfsrW7fsKuxo5LMd5VcUVYQ/a875oeBm6weKOwER47OXLQcfoom3E
 bvCqMHgoxfudytYMYZfl6faLp+vBLT32Hovs7p8zi5DP/ZWtvHNqV16WAWPYBIh3Z99M
 bsZpxeOWhQsHz0W9mZQX15ftuqL6gvEKdG4nUEodgpIE6yZgiKjw9azLE0aScrTir43i
 RNkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=PCKbeMGnbMeKELdpOCOC6blFVgcWYPGEsQUKnbyj5go=;
 b=sGzZdFW2QEDdnGrRUzUiwQK5lx3pBCiAVx9qYxefDSOf7E8igtU0nq+tStGXnd0uXu
 Rf+ZI7R6mMkbeYQzL3krcHZHuv//uheI7Jj3mjIEdRhES+PSB8bzjpxUfyNb3QaTIJxj
 Ewm7JifQckwpdvu19Ys9P8P8bk43b9Gsv8Lb4uNlgJBzfIoPFOybAK/H0F0mVDmkJwCx
 cRmeDnuP6VrY0uxAzPpcsAas71tqiNgAaGk8GGE44+b3/1lA3qEQpZ8pnKb8/by29Kr6
 MmPfKWZRbH060mWnkVkU97wjAxCbcc6czzusSH+tY3KsVYaW/nDgoUlMHlswSfgBRPhf
 zKYA==
X-Gm-Message-State: AOAM531889zPHHUhwfBTaxWCnED9LMrbEzjIh+Ahol0nkNIJ3HSbN0Ci
 IfVt6hgaykoDsophKtRj1SrnmnCbnJ8skztb8TD2P6WSJR4ynWZwEHpB2kQvNzeyVysglxoLrvI
 PWFSYHxCeMu0Ee8//NxP2BFa7QMPHee/pPWXyHMy5IZUs0CPIKgPyp0aQSGuumBIihHxaQw==
X-Google-Smtp-Source: ABdhPJzREjaDgmMlO/8NJ9+/tMKnX5excwPLRFEHZ26PVrArvstUOygEWptrPRZ3dGEPxnpxWkN+HOgNpHE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:a594:0:b0:314:365c:3a4f with
 SMTP id
 b20-20020a02a594000000b00314365c3a4fmr24710782jam.162.1646250147094; Wed, 02
 Mar 2022 11:42:27 -0800 (PST)
Date: Wed,  2 Mar 2022 19:42:21 +0000
In-Reply-To: <20220302194221.1774513-1-oupton@google.com>
Message-Id: <20220302194221.1774513-3-oupton@google.com>
Mime-Version: 1.0
References: <20220302194221.1774513-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 2/2] Documentation: KVM: Move KVM/arm64 docs into aptly named
 directory
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

ARM64 is the only supported ARM archiecture for KVM now. Move all the
documentation into a new directory, arm64, making the file structure
consistent with this change.

While we're at it, rename hyp-abi.rst to el2-abi.rst for the sake of
consistency with the architecture as well.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../virt/kvm/{arm/hyp-abi.rst => arm64/el2-abi.rst}       | 0
 Documentation/virt/kvm/{arm => arm64}/index.rst           | 8 ++++----
 Documentation/virt/kvm/{arm => arm64}/psci.rst            | 0
 Documentation/virt/kvm/{arm => arm64}/ptp_kvm.rst         | 0
 Documentation/virt/kvm/{arm => arm64}/pvtime.rst          | 0
 Documentation/virt/kvm/devices/vcpu.rst                   | 2 +-
 Documentation/virt/kvm/index.rst                          | 2 +-
 7 files changed, 6 insertions(+), 6 deletions(-)
 rename Documentation/virt/kvm/{arm/hyp-abi.rst => arm64/el2-abi.rst} (100%)
 rename Documentation/virt/kvm/{arm => arm64}/index.rst (76%)
 rename Documentation/virt/kvm/{arm => arm64}/psci.rst (100%)
 rename Documentation/virt/kvm/{arm => arm64}/ptp_kvm.rst (100%)
 rename Documentation/virt/kvm/{arm => arm64}/pvtime.rst (100%)

diff --git a/Documentation/virt/kvm/arm/hyp-abi.rst b/Documentation/virt/kvm/arm64/el2-abi.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/hyp-abi.rst
rename to Documentation/virt/kvm/arm64/el2-abi.rst
diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm64/index.rst
similarity index 76%
rename from Documentation/virt/kvm/arm/index.rst
rename to Documentation/virt/kvm/arm64/index.rst
index 78a9b670aafe..b0110fcf5eb1 100644
--- a/Documentation/virt/kvm/arm/index.rst
+++ b/Documentation/virt/kvm/arm64/index.rst
@@ -1,13 +1,13 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-===
-ARM
-===
+=====
+ARM64
+=====
 
 .. toctree::
    :maxdepth: 2
 
-   hyp-abi
+   el2-abi
    psci
    pvtime
    ptp_kvm
diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm64/psci.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm64/psci.rst
diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm64/ptp_kvm.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/ptp_kvm.rst
rename to Documentation/virt/kvm/arm64/ptp_kvm.rst
diff --git a/Documentation/virt/kvm/arm/pvtime.rst b/Documentation/virt/kvm/arm64/pvtime.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/pvtime.rst
rename to Documentation/virt/kvm/arm64/pvtime.rst
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 92942440a9e7..ab9d81421488 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -159,7 +159,7 @@ Returns:
 
 Specifies the base address of the stolen time structure for this VCPU. The
 base address must be 64 byte aligned and exist within a valid guest memory
-region. See Documentation/virt/kvm/arm/pvtime.rst for more information
+region. See Documentation/virt/kvm/arm64/pvtime.rst for more information
 including the layout of the stolen time structure.
 
 4. GROUP: KVM_VCPU_TSC_CTRL
diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index b6833c7bb474..4bf7e0eef6a1 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -25,7 +25,7 @@ KVM
 
    review-checklist
 
-   arm/index
+   arm64/index
 
    devices/index
 
-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
