Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7431BC433FE
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC4B160F55
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC4B160F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E4CA4B0CE;
	Sun, 10 Oct 2021 10:56:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id adHqMtsBmi0p; Sun, 10 Oct 2021 10:56:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41A994B091;
	Sun, 10 Oct 2021 10:56:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CE114A531
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KgpAg12BuXOU for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 10:56:39 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1B7B4A500
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:39 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 l6-20020adfa386000000b00160c4c1866eso11182758wrb.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 07:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=0IALRDz6Tre84NinIHTYzESK4wmCcI5wtlY2yCjYCUY=;
 b=XFtspDwNvHx3OaaLUkgTBRzozA11W2KOc2oj9Ffr5nL7uiZpcykfK4WXNfLGWyd0j7
 iQq9wIihaUCErX7b0sNwuTx0OINH8vTgcA6mraLwFVngsVwSvMnYV2LyfQ8ei8FFJjRl
 pDaW5b1j+sjA4dLq5Tg9+zqxA1O/NxBVU4SSsY4lKjRP1Ej9BgNyVq9OfeunQTjO+y8R
 7S5APWKp2BdXqRJxn9qT1QWfRzHpF7Uy+TN0RlMC0Nb+kZcinW5q8QKbaC3MHZf2iuo/
 whBWKBYadxOSTT/w9qYgrHMjH2ErwOOt82iV6YuiWBfSmm2aarKKIaTqd9PjjmfEkfNt
 WIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=0IALRDz6Tre84NinIHTYzESK4wmCcI5wtlY2yCjYCUY=;
 b=uiYehK/rYsVKLPvTeguhVNs2v3xknRJbap9iJpKGFBwJh5XxCIoN3Bfe6RmYaQV61E
 TREs+b7YEAp49wWQAE62c7nJfC4uUjx0dETRv1wuStxtJJLOrwDgZh/sPET+P6fPXRGi
 5nV1/7A0OQT4egjA41V55nNZ2G8CVYnCcxEGKWWY7PEpMRnk35UiYZElMYUK+G24lPb2
 IJjW+ntsEKXqNm3HPva1Pen5MjqsmmUJM/qVdkcOHB3a5639Xn1AIGyIHhoP1a5FjIq9
 xZs+wprdVwC4z4M8Xi9YiMWPBizclEYBFRxjCgyiJ8/L8U0liSLCMdKodnKjBtjHV0rQ
 hK4A==
X-Gm-Message-State: AOAM530HVsa1/PDFKPwHw0f1v4hB9JRwFjPJcZUm68tRt+uAyEjVYiij
 Csrz5zOg6h3nxA+D3LfLxMt6b8HcsleBoHbnZa1OM70Nqbp/3PEmk7zeZNNpMYGU+fYmyuXUhdH
 ioUWu+jjvcghZnXFSngQg8md9lJ6NOphofb+s6NAXlmyXQWrMYlCm/VJdlEVbhYAO0bY=
X-Google-Smtp-Source: ABdhPJzVKpI391DGIxy4EJmP42G66znpH547K7u6BG5q03NUhe2ylAPuiZia7WvbkXH0DxZIT5XKvi6ykA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:cf03:: with SMTP id
 l3mr15528139wmg.25.1633877798476; 
 Sun, 10 Oct 2021 07:56:38 -0700 (PDT)
Date: Sun, 10 Oct 2021 15:56:25 +0100
Message-Id: <20211010145636.1950948-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 00/11] KVM: arm64: Fixed features for protected VMs
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

Changes since v7 [1]:
- Fix build warnings

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM). For more background, please refer to the previous series [2].

This series is based on 5.15-rc4. You can find the applied series here [3].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20211008155832.1415010-1-tabba@google.com/

[2] https://lore.kernel.org/kvmarm/20210827101609.2808181-1-tabba@google.com/

[3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v8

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
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 186 +++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c              | 108 ++++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 500 ++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c               |  16 +
 arch/arm64/kvm/sys_regs.c                     |  10 +-
 19 files changed, 1243 insertions(+), 145 deletions(-)
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
