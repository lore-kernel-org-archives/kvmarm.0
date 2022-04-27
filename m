Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA4BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:47:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41C854B183;
	Wed, 27 Apr 2022 14:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qMZzSezoOa9W; Wed, 27 Apr 2022 14:47:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24F7D4B192;
	Wed, 27 Apr 2022 14:47:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF1524B17C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:47:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 68rGe5Lckb1J for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:47:23 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B73CF4B156
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:47:23 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 w133-20020a25c78b000000b0064847b10a22so2432792ybe.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:cc;
 bh=cjRVYKae2NiccbEodN7hWWhpE8I2abxiXPIpZLMEvCU=;
 b=QYrapOUYASQ9wPScJ0plESi+FWuJgR3FWaISnPDEs6022eaR3vV/BPqwUR64TdyM+l
 Wok4jTZejpYCOeFYt2K4Q7995CZTXK6AfZT5+erp8eD13WZ1cOtbQF+ub5TmTdkfE10f
 ejzEp4XbKTmkExH/AsNZ6U2v3rpV393XABjlNHOZgfwoYRebwFUnQxrYBDPQR2R4RNl4
 7t9/68MkDJ/aZnHETqiwGR5Bq9aBcXVcIsMrkulvfgWJcVmPBdhyw9bnLzgDP78TQV1v
 j4+qZqHSOufl+3FNjWGD4rCP+FnNVxfgvqFg2GfS3GKX3eJ2UXeBNW6EL8bVS2ETLPsR
 XiAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
 bh=cjRVYKae2NiccbEodN7hWWhpE8I2abxiXPIpZLMEvCU=;
 b=C7V1yfpzid2x8CACuAiyGfyyfrMEc7FK3ZsrMY4FZFYyv/WV6Ud+GVtT8731LhSWof
 aE3vGWz+bKkRyeGqU00Q577HaUVlGBf3RTE61uk0/lQVMWoqXQUG+MtHg/5+G8W99var
 Ly1C/wxiz0GpLTf1Ct7YJCamh+FDQjhM6f07Jss9KX4bNC9fDxMCE2wKQmaMyCiCLbYO
 9XeyPLMpfYV5D+eyXJeubmRuOnrRCBPltiyHSjh3mgFfcvA1jEdfTysOcvNqkSzkVirG
 24QAkhwR3f8rnpdnysL8+yePM0oX/Nz9ViEY1vhT6ZA5JjUSIQcpIowM0+4pkQMgc486
 WbtA==
X-Gm-Message-State: AOAM533ZHHBSBNUxiy3Az5Sl3uA29nGPEfWwqxG+8VieriS60gtMLRtl
 m6LnklhQQyx353GcRXReL20hJ+x+nSXHt9Rypg==
X-Google-Smtp-Source: ABdhPJxoGqPPyZOA0Xpsq9Ey5x+bCBFLO5TtbxyriEJN+TpNdW/YWUQEtF/V42SaDoZ/QV2QlLorCHfiJ3QQObW7wA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:16ec:6da0:8cc5:5f24])
 (user=kaleshsingh job=sendgmr) by 2002:a25:a148:0:b0:641:d14b:ddd3 with SMTP
 id z66-20020a25a148000000b00641d14bddd3mr28186851ybh.402.1651085243194; Wed,
 27 Apr 2022 11:47:23 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:46:55 -0700
Message-Id: <20220427184716.1949239-1-kaleshsingh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 0/4] KVM nVHE Hypervisor stack unwinder
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexei Starovoitov <ast@kernel.org>,
 will@kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 surenb@google.com, Mark Brown <broonie@kernel.org>,
 Peter Collingbourne <pcc@google.com>, linux-kernel@vger.kernel.org,
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

This series is based on arm64 for-next/core and is also dependent
on the series at [1].

A previous version of hypervisor stack unwinding was included
in the series at [2].

This new version of the unwinder splits the unwinding and dumping
of the stack between the hypervisor and host:
  - The hyperviosr unwinds its stack and dumps the address entries
    into a page shared with the host.
  - The host then symnolizes and prints the hyp stacktrace from
    the shared page.

The new approach doesn't depend on CONFIG_NVHE_EL2_DEBUG,
and allows dumping hyp stacktraces in prodcution environments
(!CONFIG_NVHE_EL2_DEBUG).

arm64/kernel/stacktrace.c is compiled twice: stacktrace.o for the
host kernel and stacktrace.nvhe.o for the hypervisor: This allows
reusing most of the host unwinding logic in the nVHE hypervisor.

[1] https://lore.kernel.org/r/20220420214317.3303360-1-kaleshsingh@google.com/
[2] https://lore.kernel.org/r/20220314200148.2695206-1-kaleshsingh@google.com/

Thanks,
Kalesh


Kalesh Singh (4):
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
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
