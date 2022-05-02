Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E51C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 19:12:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43BEF4B218;
	Mon,  2 May 2022 15:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1FHk6irC1XnE; Mon,  2 May 2022 15:12:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F584B139;
	Mon,  2 May 2022 15:12:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEE2E4B11C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:12:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PysT2SGpg-eN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 15:12:30 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFF6D4A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 15:12:30 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2f8bbaa6b16so81686937b3.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 12:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=uV3AMgXfaKdpLzrKDgt2Pftc7Y3s541BqTPcU4XvOsc=;
 b=f/f3SDrAnawn000xkOkHhrYZWDBT/8Cfw436AFLd7ZGxWqX2AndGj6iIOi9pFxg9Lu
 c33w4E0W3pJafd0pLQ7kM+38rflKqPdINJwxPvlkEcM9yPSifoU2cXy2eZQgwskzblUc
 ZHWFN5SCm40eX/3Ntni/B2HAKTUKBbTBwHvSx3ykdEb1t9AbkLnxKyabLTk4rSAUbfFz
 GpCR3RXHSIMIryrvEiju/VgLVKQQkM61eujNeTaggZt7ybDKDRRkndV5NPsx3+Cair4K
 fPXJuHxCkPpbMqLH8CProCushBiyS/Ic8u4Kne6k3YlaVo4L97+BQUR11iFgCmGvubgH
 je1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=uV3AMgXfaKdpLzrKDgt2Pftc7Y3s541BqTPcU4XvOsc=;
 b=st/gne/vg/RHSuCOJ5oTIxd+KvgVG4p4n3FX+bd5p70QkWDXYpzk5Es6zfdrlWZjsG
 uyL7JBdMkzEBaf7fZZLrEbdU1EO/lk9CV+89r+nsvhq5xEKLnFOt/FEa8bTHOdztX0XX
 He4NAQlU041WfJneRlGO1P8tedI+1aGJptOtQgHEHAH3+po4s2DGNfXFVY45iyj/jQgV
 KdAasbo7Ni7Y1FaAWHox2cnpAUJfEANbPEZtzgH77xQBmukCzdYYqO17UNIisWpQT5G6
 nWqIr0n05PhTwfhWMedW12JDCZHisNqbSqtGU+x1rx3N/aw9H3avowf8M5irl96FopAF
 uiWA==
X-Gm-Message-State: AOAM531Agsgl5k6TSmgL5r5pHB4FcPuOQ4huybFmQfs/RjFGX24oPnyD
 Rqe0DLEm8w+Y1IsM2R5y9+XWJ8gMlH9C630Fqg==
X-Google-Smtp-Source: ABdhPJw3anR5PV2AbjH4cWd8FKWezlG379Lha/KDbqGyzNif8TIgOLLb8qPZNat5PHuda44OzO6PJQ55Yf4E13DL8Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:55c:7548:7073:c14f])
 (user=kaleshsingh job=sendgmr) by 2002:a5b:b4a:0:b0:649:15ed:1b87 with SMTP
 id b10-20020a5b0b4a000000b0064915ed1b87mr10856706ybr.374.1651518750235; Mon,
 02 May 2022 12:12:30 -0700 (PDT)
Date: Mon,  2 May 2022 12:12:00 -0700
Message-Id: <20220502191222.4192768-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 0/5] KVM nVHE Hypervisor stack unwinder
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, broonie@kernel.org, Peter Collingbourne <pcc@google.com>,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
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

Hi all,

This v2 of the nVHE hypervisor stack unwinder. The previous version was
posted at:
v1: https://lore.kernel.org/lkml/20220427184716.1949239-1-kaleshsingh@google.com/

The series is based on arm64 for-next/core and is also dependent on
kvm-arm64/hyp-stack-guard [1].

The main changes in this version is splitting some patches into more
incremental changes, per Mark Brown

The relevant parts of the previous cover letter are copied below for
convenience.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/hyp-stack-guard

Thanks,
Kalesh

-------

This new version of the unwinder splits the unwinding and dumping
of the stack between the hypervisor and host:
  - The hypervisor unwinds its stack and dumps the address entries
    into a page shared with the host.
  - The host then symnolizes and prints the hyp stacktrace from
    the shared page.

The new approach doesn't depend on CONFIG_NVHE_EL2_DEBUG,
and allows dumping hyp stacktraces in prodcution environments
(!CONFIG_NVHE_EL2_DEBUG).

arm64/kernel/stacktrace.c is compiled twice: stacktrace.o for the
host kernel and stacktrace.nvhe.o for the hypervisor. This allows
reusing most of the host unwinding logic in the nVHE hypervisor.


Kalesh Singh (5):
  KVM: arm64: Factor out common stack unwinding logic
  KVM: arm64: Compile stacktrace.nvhe.o
  KVM: arm64: Add hypervisor overflow stack
  KVM: arm64: Allocate shared stacktrace pages
  KVM: arm64: Unwind and dump nVHE hypervisor stacktrace

 arch/arm64/include/asm/kvm_asm.h    |   1 +
 arch/arm64/include/asm/stacktrace.h |  58 +++++++++--
 arch/arm64/kernel/stacktrace.c      | 151 +++++++++++++++++++++++-----
 arch/arm64/kvm/arm.c                |  34 +++++++
 arch/arm64/kvm/handle_exit.c        |   4 +
 arch/arm64/kvm/hyp/nvhe/Makefile    |   3 +-
 arch/arm64/kvm/hyp/nvhe/host.S      |   9 +-
 arch/arm64/kvm/hyp/nvhe/setup.c     |  11 ++
 arch/arm64/kvm/hyp/nvhe/switch.c    |   4 +
 9 files changed, 231 insertions(+), 44 deletions(-)

-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
