Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7863EC54EE9
	for <kvmarm@archiver.kernel.org>; Sat, 17 Sep 2022 01:06:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DEC454BD22;
	Fri, 16 Sep 2022 21:06:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1tmbcjhSt+mG; Fri, 16 Sep 2022 21:06:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B04114BD2B;
	Fri, 16 Sep 2022 21:06:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 915804BD23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WabydsyiLn-K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2022 21:06:11 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CAC34BD22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 21:06:11 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-345482ec6adso204519067b3.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2022 18:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date; bh=FPmIZ20vcTUeBFUMKdaLzmUVq8vMch7/heQIwOJWf6I=;
 b=tAFTWGiHh8oW2k7UJWEM5Y3bG6bkwLfnpOBuOdCuxk+rZNbmhhM1l8IU4cBn4WFKrb
 f+bB///QmF1d/7+xnOluIe6aNNzsU/lygE9MKZ4u5pHcwCw01d1aCJb/eoO1IAQizUT1
 6U32afXpbaY8kj719kzrUygp/nfRYIjZ49AaIQimpwnLpBydSoAhrYNGHWF7BDK+beNY
 3wc+w1VqMEwZgog2px86mTYdBFIMt91uyhZLoqfnUawrlKGjR6xLgPAUPmuK2glEmm3u
 zEij4qYIZUMQyO+6hI7HsBWaQ/MSXHMgD1vc6NGkoxA3wz4TLKzIJUoeMbADXFusTCs1
 u5lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date;
 bh=FPmIZ20vcTUeBFUMKdaLzmUVq8vMch7/heQIwOJWf6I=;
 b=XNl8304Sk8A1zVklXo1afIgT2a1VTB2hLBcDhNWoWzZp4KHO3MJWZWnuu+1W0OhcWu
 JN/UirBKmxsMN87l+U1K7fdNVzP1WVKGHCwa3gAFtl/Q+RJai8y4s83ZOU4aLaDrXBso
 7RmKxYNkI2yNCcyyo3Os2JsMw2qhQJ+glHqZdZf0GeRtiQFqnMcxJsFlZWXsV6SKbTWY
 KIs4wA187GaTxnGNhJOhOLSVTfjY65/8X5mrW2YXD8WJEnbjusoev80+qESloyJ6fO7a
 WPubmY+aeJSOxLNTeZh+vAWV9jvsP6o7H5mAz2T9ragAvItosiIDyJTQaXE1KwqbodmQ
 /vtg==
X-Gm-Message-State: ACrzQf0YwHuW7caQPhPx0NguCHmcQI3Zt9cRF77Mf+kziyL0hqLxAStq
 A2kpCwL0k4Ty+CKFptvxR0RFOac0fxI=
X-Google-Smtp-Source: AMsMyM7+y1N9+gTgvFSbs1C1oHCJr2OfSIB0qnRQXA92Ps+jtzT3rtMrAlli+ZateJjndneNoW56QwXzWzI=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:8c07:0:b0:6af:ef09:be31 with SMTP id
 k7-20020a258c07000000b006afef09be31mr6435316ybl.285.1663376770905; Fri, 16
 Sep 2022 18:06:10 -0700 (PDT)
Date: Fri, 16 Sep 2022 18:05:56 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220917010600.532642-1-reijiw@google.com>
Subject: [PATCH v2 0/4] KVM: arm64: Fix bugs of single-step execution enabled
 by userspace
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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

This series fixes two bugs of single-step execution enabled by
userspace, and add a test case for KVM_GUESTDBG_SINGLESTEP to
the debug-exception test to verify the single-step behavior.

Patch 1 fixes a bug that KVM might unintentionally change PSTATE.SS
for the guest when single-step execution is enabled for the vCPU by
userspace.

Patch 2 fixes a bug that KVM could erroneously perform an extra
single step (without returning to userspace) due to setting PSTATE.SS
to 1 on every guest entry, when single-step execution is enabled for
the vCPU by userspace.

Patch 3-4 adds a test for KVM_GUESTDBG_SINGLESTEP to the
debug-exception test to verify the single-step behavior.

The series is based on 6.0-rc5.

v2:
 - Change kvm_handle_guest_debug() to use switch/case statement [Marc]
 - Clear PSTATE.SS on guest entry if the Software step state at the
   last guest exit was "Active-pending" to make DBG_SS_ACTIVE_PENDING
   and PSTATE.SS consistent [Marc]
 - Add a fix to preserve PSTATE.SS for the guest.

v1: https://lore.kernel.org/all/20220909044636.1997755-1-reijiw@google.com/

Reiji Watanabe (4):
  KVM: arm64: Preserve PSTATE.SS for the guest while single-step is
    enabled
  KVM: arm64: Clear PSTATE.SS when the Software Step state was
    Active-pending
  KVM: arm64: selftests: Refactor debug-exceptions to make it amenable
    to new test cases
  KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP

 arch/arm64/include/asm/kvm_host.h             |   4 +
 arch/arm64/kvm/debug.c                        |  34 +++-
 arch/arm64/kvm/guest.c                        |   1 +
 arch/arm64/kvm/handle_exit.c                  |   8 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 149 +++++++++++++++++-
 5 files changed, 190 insertions(+), 6 deletions(-)


base-commit: 80e78fcce86de0288793a0ef0f6acf37656ee4cf
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
