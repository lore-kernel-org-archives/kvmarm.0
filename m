Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A04C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7279A6101A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7279A6101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A584B129;
	Fri,  8 Oct 2021 11:58:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pcg93gIRUMRy; Fri,  8 Oct 2021 11:58:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A77714B10E;
	Fri,  8 Oct 2021 11:58:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8CA4B0DE
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKW9dTw31YSy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:36 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 83E344B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:35 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 z2-20020a254c02000000b005b68ef4fe24so13043713yba.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=OhGTFF+wvS+RHrDxBXMcls6M7hE9mvNcy5n5nxdlojY=;
 b=UhDbVer3yTzCQuEnCVNCCwOJxroBSjeGrerPZQUnL9cSLTLWZM3WcLmHKtjpnB9H42
 4+MLmNwhYgZLSfRYqHvwMdpkPmhxPa0wHy03c+jxdQpFlGn/qfuRE6+r+AXnoqOj8+4e
 vbW8EjUhfr23GdmxGkqXMAEdxEylEw/4lSVq9KsaNs9IFfJyBemq5uVCgHnZHwwIlrgR
 3dR7J6sZkD7Dryb1tIb+9atF3DgzOcXpejRI2P/LT4BP/ftKIDUkkxMrp1QsH2aVR5c3
 qf+KjTx6Is/FLnOUPigUaJyHzddnzRFVNxlidDe4gzrGvYWQEs5u/MYkOCax/EABYnHo
 7pKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=OhGTFF+wvS+RHrDxBXMcls6M7hE9mvNcy5n5nxdlojY=;
 b=Gpx+MW/YMR1xGW0XgEF2d4ey3lD9uHkv5aqkoctosawxQkpe2HAwUlqv9kRuDncdxT
 8DZDYd2dqAKQfbl7ddUvLjPGKzQtpXREdYUrs2zyoBLPW+qV0KHReam4WrnToesrjwNZ
 o0MzzPAsCryJeiU1vZb7pxUe+5dO2lDksCjNEHsJbwks4G3KKEAraoLSN8ODD67YvUUS
 QC68E/3NB/Qv5MglCdsOvTJH4E2vk84kQ6+uVKWouP+pDSlYsHyXcjcvDFN5z1QonD/i
 N8ndGH5QSOiHOCvurPmLl0LZRrPeoiSnLxS8KLpvUkOkXMCQHnoQ6eS72rQzPw2A5Ehh
 GcPg==
X-Gm-Message-State: AOAM5303cFpo3AX01gDBvp67bMgGPOqZPkA+REPQR27s1gsfu6K16dcc
 jld/ABtvSkGzWmyUy7VgMFpGTLCD0Ll7Lyzmb6DXlNaznfb/iPAz2Rsru19VfCoo7YeGqv/zgFE
 W606FuOcq6nKYGdSVWYY9rxgLsBLWM5WxK5Pns+9jN6d+4rrRSN9y81pPrRw6c9LczZA=
X-Google-Smtp-Source: ABdhPJwSkEhANAXQ5JCD2NdWSpZq4SqWrw57ULj9YsrCO0+8ltUiACfmbzS/Tq1J1B3VPevPEONoAIAjbA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:6e06:: with SMTP id
 j6mr4604257ybc.311.1633708714429; 
 Fri, 08 Oct 2021 08:58:34 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:21 +0100
Message-Id: <20211008155832.1415010-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 00/11] KVM: arm64: Fixed features for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Hi,

Changes since v6 [1]:
- Rebase on 5.15-rc4
- Include Marc's updated early exception handlers in the series
- Refactoring and fixes (Drew, Marc)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM). For more background, please refer to the previous series [2].

This series is based on 5.15-rc4. You can find the applied series here [3].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210922124704.600087-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/

[3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v7

Fuad Tabba (8):
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add handlers for protected VM System Registers
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

Marc Zyngier (3):
  KVM: arm64: Move __get_fault_info() and co into their own include file
  KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
  KVM: arm64: Move early handlers to per-EC handlers

 arch/arm64/include/asm/kvm_arm.h              |   1 +
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_fixed_config.h     | 195 +++++++
 arch/arm64/include/asm/kvm_host.h             |   2 +
 arch/arm64/include/asm/kvm_hyp.h              |   5 +
 arch/arm64/kvm/arm.c                          |  13 +
 arch/arm64/kvm/hyp/include/hyp/fault.h        |  75 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       | 221 ++++----
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h    |  29 +
 .../arm64/kvm/hyp/include/nvhe/trap_handler.h |   2 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 185 +++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c              | 108 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 498 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
 arch/arm64/kvm/sys_regs.c                     |  10 +-
 19 files changed, 1240 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/fault.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: 1da38549dd64c7f5dd22427f12dfa8db3d8a722b
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
