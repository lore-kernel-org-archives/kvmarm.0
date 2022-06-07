Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B589C43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 16:51:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 574744B116;
	Tue,  7 Jun 2022 12:51:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B8k3BNDnrU6h; Tue,  7 Jun 2022 12:51:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBDA84B283;
	Tue,  7 Jun 2022 12:51:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65E944B1E1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3kk0JEiRQnJZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 12:51:17 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E06F04B116
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 12:51:16 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-30c99cb3d4dso151948877b3.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2022 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=o0iZsHQ0w1pzGlhdlimhaec4r2w9hzpwWG2GpMn3EMQ=;
 b=OmbO1I14NanBrKt0FdpC2NTCDJpwz34ZNg+udo7ufulw4wzH8+6qdwXmzYiRud8dgl
 H4fGd9ztV7KGrTzVhGt0BfeRhSMqmrEzAXKdjHlXNA8QMGX11NdyFs69PTFZuos98kzq
 UuMzL9aKp3DDEeBnd6ry89HY9wlen6rOWsSYi6ecHKyigI+ITpBGik/BsMoJ4zA2uH2Q
 ZWvpcg89RtVbZ//Dr6NHFj6hkIkOkYWGgZQHoVsMXwslo48H2dhOd6ACZD+Z5TwKkWUh
 fPKaPVoeSC5DDDBZAFB2wHobe264YygSL7/nPsaMEx50lZwXm9Ab0CyQLzyMVVSSqC+7
 sHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=o0iZsHQ0w1pzGlhdlimhaec4r2w9hzpwWG2GpMn3EMQ=;
 b=zEIOGsJCud3agvC6UMsd1MGWKvnIk9rWPsH864YKAVTXVeSVeot1tnZx7XGZTUH8vJ
 dTUhtTx5HMjo076G+eh2r5mgLdcXG5zehnPtkfbXCfz5TfeNVhHzF4D2BzL1Ha+GtVM4
 Y5VCXIQ+z0nPqWhOTeh0tamk/oQ1v5UUCCuKMNk0VlMUOZdwy8J77PJC6TRW/W8POuJr
 AW5EiJPs5+RPEZBoZs5hGoIM6BHMEEoiXMZ9guFxKnI3X4gPTAYIyjWuktBzehtssVyh
 x0q6XCzVPWs+NJSIuY9ej3wVFaq7R7o1vfJ5ve3UdioZW8pGqMhzEclr1BBTjthISTSI
 aMgA==
X-Gm-Message-State: AOAM530vP8qyV8miSCPV0q8Q9ZL+Gan2vQgaYLqvnoEs8jryZ7pi0sfI
 50bHZIJx0yMTG3ndWL0MgTHWML4IedLHdCKv9w==
X-Google-Smtp-Source: ABdhPJysQZgWCIBcQcZgbAPodFjVXMmm6FLeZKxkdgidkgdm9q/dWOw/xW0kfcLA9ACqPsqnVIIHO6siNslKHvzWdA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:7091:8518:ec1e:93dc])
 (user=kaleshsingh job=sendgmr) by 2002:a81:1615:0:b0:30c:245e:71ff with SMTP
 id 21-20020a811615000000b0030c245e71ffmr33123428yww.406.1654620676147; Tue,
 07 Jun 2022 09:51:16 -0700 (PDT)
Date: Tue,  7 Jun 2022 09:50:42 -0700
Message-Id: <20220607165105.639716-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v3 0/5] KVM nVHE Hypervisor stack unwinder
From: Kalesh Singh <kaleshsingh@google.com>
To: mark.rutland@arm.com, broonie@kernel.org, maz@kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, surenb@google.com, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 kernel-team@android.com, tjmercier@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>
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

This v3 of the nVHE hypervisor stack unwinder. The previous versions were
posted at:
v2: https://lore.kernel.org/r/20220502191222.4192768-1-kaleshsingh@google.com/
v1: https://lore.kernel.org/r/20220427184716.1949239-1-kaleshsingh@google.com/

The version is rebased on 5.19-rc1 which resolves the previously unmerged
dependencies, and adds some reviewed tags from Mark Brown.

The cover letter are copied below for convenience.

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


base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.36.1.255.ge46751e96f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
