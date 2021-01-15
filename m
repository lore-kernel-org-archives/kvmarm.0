Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDBFC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:18:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B51E023976
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 17:18:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B51E023976
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9ED64B228;
	Fri, 15 Jan 2021 12:18:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mcAoHKH2KBPi; Fri, 15 Jan 2021 12:18:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D82F84B22D;
	Fri, 15 Jan 2021 12:18:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01B834B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L+hO0kFmpUiF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 12:18:45 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4187F4B171
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 12:18:45 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id r1so3226722wmn.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 09:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=PiTweHVaIWwM1Fes5h+y6wnV6pBG4D7sAqs6XrwD/WQ=;
 b=uryOYOvmlRLFF34f9bw5DcPeMa7fUPhnzb0V9TDTqAJ7Gyqcdsy8tLDdCIiMM7KpXP
 ZWMG0NpkZUrLs02mmuRkztZ+9mTUlTCH048QVnQCuqJHrgEWO2T4In7N07YBt7ehL4f0
 L0spBnK+XZW1sScs/zCKmedPD29bAV5XPo3UEW9dy5WCwBKtAROgks8el5MQANiFckDj
 4N3R6Qqj5gHLtz1uWLgdiNyW9rahx+K8UXLj37k80P6FrcH2H9BO15TiC2FKLk4Jb5O4
 nQCcXDLmjEizomkyHTzrq6uhKUn2DsAyIeMeN2sN7jtPOvi6pT0jhnKvlpBCJBVpE8DI
 OJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=PiTweHVaIWwM1Fes5h+y6wnV6pBG4D7sAqs6XrwD/WQ=;
 b=AtKPYn9Uu5kPNCxwlz+x/dr0zuotJBUK+DpSpApA+AKP9oo2Y7se2UaIUR7g/3JnaL
 Vqo6PUy231wZgyPcSPz9ASNybxaCJfF8YzmzqPfihNxrXMNxrk6VXDvIIouYFi4wpfKS
 zPWNd38f+5nBXGEb8qBPdJ3NNSxM8JjI6I7v9TY1/dXOpXnAH8x3c6dgPoqTATb4atzO
 dVkpVIxrW0qdRdL0q9vMt6+hRZi0jlUiuvvQ3oBkOCSv1m0qGNJqcf79G5aFYUH6S6uf
 9WU4ei+NiejVipkKdQtoOWR+m9Rg5+GSQrqeNa8VEWyv0PoY2+ExbWzmMU6P+TzDwlA7
 ghLQ==
X-Gm-Message-State: AOAM531censB8YcN8QJvupJMafIPhXbTsKg4stvOqQPmrkQHNtVDJuAw
 3ZDzs3Gc80uWGswR2CUQXKB8z3BP52PpHxqTCPHppG1eq+Nl0mFTTfvrwJ3zofOfPcF8AHIbJ9y
 c0g5z0s4fHYGna/ykLpCtJQRE9ip7qBJ7qKp88WkqnlTUH0XQnb9VrydM85j77cm8ymYRapAO
X-Google-Smtp-Source: ABdhPJx+biyMD+eyfOowD9aimiJnsnswVeW3C5SizJvHyfSyI7N9jNVg4Kuzg91Zu9ZnJNFCeUIc9HWxEgvO
X-Received: from beef.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1091])
 (user=lenaptr job=sendgmr) by 2002:a7b:c1c6:: with SMTP id
 a6mr9625527wmj.23.1610731123890; Fri, 15 Jan 2021 09:18:43 -0800 (PST)
Date: Fri, 15 Jan 2021 17:18:21 +0000
Message-Id: <20210115171830.3602110-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH v3 0/9] UBSan Enablement for hyp/nVHE code
From: Elena Petrova <lenaptr@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Elena Petrova <lenaptr@google.com>, Marc Zyngier <maz@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
 George Popescu <george.apopescu97@gmail.com>
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

Respin of George's patch series enabling UBSAN for hyp/nVHE code.

Updates in v3:
  * rebased onto v5.11-rc3
  * added base commit info

Updates in v2:
  * CONFIG_KVM_ARM_DEBUG_BUFFER removed; __kvm_check_ubsan_buffer is
    called directly instead of via __kvm_arm_check_debug_buffer.
  * Bugfixing commits removed as these are already upstream.
  * Some code brought up to date, i.e. moved from entry.S to host.S.
  * Merged "Add support for creating and checking a buffer" and
    "Add a buffer that can pass UBSan data from hyp/nVHE" into
    one commit as these changes don't work without each other.

George Popescu (9):
  KVM: arm64: Enable UBSan instrumentation in nVHE hyp code
  KVM: arm64: Add a buffer that can pass UBSan data from hyp/nVHE to
    kernel
  KVM: arm64: Enable UBSAN_BOUNDS for the both the kernel and hyp/nVHE
  KVM: arm64: Enable UBsan check for unreachable code inside hyp/nVHE
    code
  KVM: arm64: Enable shift out of bounds undefined behaviour check for
    hyp/nVHE
  KVM: arm64: __ubsan_handle_load_invalid_value EL2 implementation.
  KVM: arm64: Detect type mismatch undefined behaviour from hyp/nVHE
    code
  KVM: arm64: Detect arithmetic overflow is inside hyp/nVHE.
  KVM: arm64: Add UBSan tests for PKVM.

 arch/arm64/include/asm/assembler.h          |  10 ++
 arch/arm64/include/asm/kvm_debug_buffer.h   |  34 ++++
 arch/arm64/include/asm/kvm_host.h           |   8 +-
 arch/arm64/include/asm/kvm_ubsan.h          |  50 ++++++
 arch/arm64/kvm/Makefile                     |   2 +
 arch/arm64/kvm/arm.c                        |   9 ++
 arch/arm64/kvm/hyp/include/hyp/test_ubsan.h | 112 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/Makefile            |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S              |   4 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c          |   3 +
 arch/arm64/kvm/hyp/nvhe/ubsan.c             | 164 ++++++++++++++++++++
 arch/arm64/kvm/kvm_ubsan_buffer.c           |  81 ++++++++++
 12 files changed, 478 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_debug_buffer.h
 create mode 100644 arch/arm64/include/asm/kvm_ubsan.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/test_ubsan.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/ubsan.c
 create mode 100644 arch/arm64/kvm/kvm_ubsan_buffer.c


base-commit: 5ee88057889bbca5f5bb96031b62b3756b33e164
-- 
2.30.0.296.g2bfb1c46d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
