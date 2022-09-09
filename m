Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B799ECAAD3
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 04:46:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D87B4C9D6;
	Fri,  9 Sep 2022 00:46:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e2gd1sN38Ql1; Fri,  9 Sep 2022 00:46:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3614B4CA1B;
	Fri,  9 Sep 2022 00:46:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A24F44C998
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:46:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4JxkPqiviQvX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 00:46:44 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 77BE84C278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 00:46:44 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 o23-20020a17090aac1700b002006b02384fso2587942pjq.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Sep 2022 21:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date; bh=QJB73MLDhafVA5mzk0y7NRG1yy1AsLNoloEV+fqwUaA=;
 b=IYHa6MwCs2cLrpdrnCoumxBXe9npI1GWJqBc7iHtrCKZGdhnamRw7ygg7mk67IFO0D
 CTL0FLaT9eObj1mrMFt9EryTVC8NUm+WsK2nG+L+xWJy6RrH6NGeAhl2DkdWJWiM/HKM
 BqRTFp2qkCawdUae1SBp+qy9ipxtkEOPUcwU0wjr3ilxXjXGeANeV3GbE2es41/wZlDP
 0YlrUFK80JucWbwCSrMpX4K4tmUJxN4Zquvt9ecAylsdxe//KfHKhmyodN8wYOlgCJ8f
 5HJyE1c/clPUjzMKSiRThQFUAOOt1leM62vSiTuvcF0Vm7eqxUndojfAZxjm14DQtJJV
 xoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date;
 bh=QJB73MLDhafVA5mzk0y7NRG1yy1AsLNoloEV+fqwUaA=;
 b=w34LKvUeO52+RURYei5f4DWYC55XbGCPpyn0ULoOgrJwQ8BzEHg8oTUDVYL3ae3L9m
 aF6KbZbOAq2UnUoLtmb67vs6dM0uZfGezHX9lrgCte18ML7/fNi+1XZolD69hXXWm7ak
 NnqqxBS19r84+2jmjNyK6C13duFY0yBegvQhitP98Ok/FBbDewsg5M3D3lN42wjsYwHn
 HlvFXXok57NurYAVsiUv17yrb51K7v1pmRODEpSFnXamlHvuKuMDE/UiPqg0DeaGoF1y
 UXq9CGLp9MIY7DutirwR/7b/lfeBabJZBKpyAMUsamYE150wWbjYeg7YvqLyOqxQA/zX
 lqhA==
X-Gm-Message-State: ACgBeo3662OxeXfIe0a59tFTaVH+4MCPVdztJbFfTywQSU9/7OsptPUd
 csYniKpClUpbrbsyqBoEp3LBdOmc9ms=
X-Google-Smtp-Source: AA6agR67XHqJPDelywKoy02FeiedN0d6WTuCg15FUtrlXR/yHe1DDpqixxtKRWyEF/Iu/+vIeepM+t92WtM=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a65:68c8:0:b0:438:744d:b340 with SMTP id
 k8-20020a6568c8000000b00438744db340mr3297212pgt.142.1662698803471; Thu, 08
 Sep 2022 21:46:43 -0700 (PDT)
Date: Thu,  8 Sep 2022 21:46:33 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220909044636.1997755-1-reijiw@google.com>
Subject: [PATCH 0/3] KVM: arm64: Fix a bug of single-step execution enabled by
 userspace
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

Fix a bug that KVM could erroneously perform an extra single step
execution (without returning to userspace) due to setting PSTATE.SS
to 1 on every guest entry, when single-step execution is enabled for
the vCPU by userspace.

Add a test for KVM_GUESTDBG_SINGLESTEP to the debug-exception test
to verify the single-step behavior.

The series is based on 6.0-rc4.

Reiji Watanabe (3):
  KVM: arm64: Don't set PSTATE.SS when Software Step state is
    Active-pending
  KVM: arm64: selftests: Refactor debug-exceptions to make it amenable
    to new test cases
  KVM: arm64: selftests: Add a test case for KVM_GUESTDBG_SINGLESTEP

 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/debug.c                        |  19 ++-
 arch/arm64/kvm/guest.c                        |   1 +
 arch/arm64/kvm/handle_exit.c                  |   2 +
 .../selftests/kvm/aarch64/debug-exceptions.c  | 149 +++++++++++++++++-
 5 files changed, 169 insertions(+), 5 deletions(-)


base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
