Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4073FC43461
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A13D521D7A
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="pCW2Jq+4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A13D521D7A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 335434B330;
	Tue, 15 Sep 2020 06:46:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id n9euZF10T-b8; Tue, 15 Sep 2020 06:46:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C0034B328;
	Tue, 15 Sep 2020 06:46:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D42974B319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JId0T6IrItbo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:46:49 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7234A4B311
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:49 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id x81so750129wmg.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:message-id:mime-version:subject:from:to:cc;
 bh=q5iRRAj0SUsthOjBN2PJyc/yoW5r5Y3Rs945BK5S73I=;
 b=pCW2Jq+48EDIL/IC3ltwztUgjn5uEm1sV1tWhQgE1gH7ucq9gjhcdRebL2+yTmA+mK
 LFjoS8sKttmOQ+Eh4XSr0ceVlG4N4wje9xS/1557tc/Uv3CzaOO1LRd7nP/PJtYgNp7/
 emwcmQHNfKwTZndNc412CUolKjToAutTlPim3TEOnJUXEfnOTfGiSuke9kDX6QUgKubQ
 yLzdxsucyAagIdbyTW98OlA6z7884I79DFdK2XvB4bax3jfd85Zqepy+U+R5jgWx1Rcq
 hhvGCA/vT9Fj93j1N3oVy2h2q0CEMnNQFUe+1+0yQqqmC20kvOa2VFIIJGpkQFBzc/Sv
 /sog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
 :to:cc;
 bh=q5iRRAj0SUsthOjBN2PJyc/yoW5r5Y3Rs945BK5S73I=;
 b=GYyH9xQTGFFrtkyt42CvKcsL5sYVpYe+AUrf/tQrdeZSq5uhEdeAh7UehL58QKcpg6
 axrdZVGMnk1vuTi/Tvvo9Fs7yiPsOAviJ0cPZxyC6zuoTWOS+msw9jl/Qymq6EhCzuYh
 U261kV1r873JNyWVu6xB15TQKLfPO02m0XrUU4UlrZyRt/PGHgWqCuYmSWcw+9Fw2Xgu
 bjJVtwZM7gb/+7+eyHAl4PgJmDC7D42Q+3/XZgfu+LZkMrMF8Lh/8xUvIoF6IAWDbius
 8Psd9RjyK9WObHhoqYAyh8oG3UuBcraVNH1iShLhS3ZtSGstrq+hge1oN7178OgMfBk1
 CJzQ==
X-Gm-Message-State: AOAM5307GmM7pk1sTJjRR1O6uWw1lFSUCc3ZDQIEO67wq+Kk7JyoLDTT
 j1hJ0ZGgEFirzwrdN+mAAFLaDNlZ4kmb0jZSKCDv7w7k/wbm7g8fWub3iS6QNWrkV2JMOKhXdEh
 ZJ/6eVD7h6sghOYBMtrYSVQDGbJbEEVIcVCo07UEYs36s0Ycg5djn8QdalcqvsNohfxjarg==
X-Google-Smtp-Source: ABdhPJwHZNc4IJ9YyBn/VOmidrd8JTUW1eIIQzrcOUj/V9w2IOUcSO1J6wpFQnqAWwHLRZTrZeCtrg//mOo=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a7b:c38f:: with SMTP id
 s15mr4180830wmj.16.1600166808236; 
 Tue, 15 Sep 2020 03:46:48 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:24 +0100
Message-Id: <20200915104643.2543892-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 00/19] Introduce separate nVHE hyp context
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

As a step on the way to isolating hyp from the host on nVHE as part of
Android's "Protected KVM" project, this series introduces a separate
register context. Topics include:

 - RAS for nVHE
 - Panicking from guest vectors with SCS
 - Switching to hyp context
 - Migrating hyp interface off of function pointers

First 4 patches are small refactors. Then an exception vector is added
just for the nVHE host to untangle the existing EL2 vector e.g. to
separate the RAS cases.

Hyp panics from the guest context, e.g. from an invalid vector, are
fixed so they have a chance of completely cleanly with features that
depend on register state such as x18 for shadow call stack (SCS) enabled
on VHE.

Finally, hyp is made to switch to its own context rather than borrowing the
host context before migrating the hyp interface from raw function
pointers to SMCCC based functions IDs.

From v3:
 - https://lore.kernel.org/kvmarm/20200903135307.251331-1-ascull@google.com/
 - Rebased onto 5.9-rc4
 - Addressed review comments

From v2:
 - https://lore.kernel.org/kvmarm/20200820103446.959000-1-ascull@google.com/
 - Rebased onto 5.9-rc3.
 - Removed some of the unused separation of host and hyp.

From v1:
 - https://lore.kernel.org/kvmarm/20200715184438.1390996-1-ascull@google.com/
 - HVC microbenchmark overhead cut from over 15% to under 6%.
 - Abandon the symmetry of a run loop in hyp and treating the host as a
   vCPU as there was little practical benefit for the overhead it
   introduced.

Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org

*** BLURB HERE ***

Andrew Scull (19):
  KVM: arm64: Remove __activate_vm wrapper
  KVM: arm64: Remove hyp_panic arguments
  KVM: arm64: Remove kvm_host_data_t typedef
  KVM: arm64: Choose hyp symbol based on context
  KVM: arm64: Save chosen hyp vector to a percpu variable
  KVM: arm64: nVHE: Use separate vector for the host
  KVM: arm64: nVHE: Don't consume host SErrors with ESB
  KVM: arm64: Introduce hyp context
  KVM: arm64: Update context references from host to hyp
  KVM: arm64: Restore hyp when panicking in guest context
  KVM: arm64: Share context save and restore macros
  KVM: arm64: nVHE: Switch to hyp context for EL2
  KVM: arm64: nVHE: Handle hyp panics
  KVM: arm64: nVHE: Pass pointers consistently to hyp-init
  smccc: Define vendor hyp owned service call region
  smccc: Use separate variables for args and results
  KVM: arm64: nVHE: Migrate hyp interface to SMCCC
  KVM: arm64: nVHE: Migrate hyp-init to SMCCC
  KVM: arm64: nVHE: Fix pointers during SMCCC convertion

 arch/arm64/include/asm/kvm_asm.h        | 100 ++++++++++++-
 arch/arm64/include/asm/kvm_host.h       |  26 ++--
 arch/arm64/include/asm/kvm_hyp.h        |   9 +-
 arch/arm64/include/asm/kvm_ptrauth.h    |   6 +-
 arch/arm64/kernel/image-vars.h          |   2 +
 arch/arm64/kvm/Makefile                 |   2 +-
 arch/arm64/kvm/arm.c                    |  34 ++++-
 arch/arm64/kvm/hyp.S                    |  34 -----
 arch/arm64/kvm/hyp/entry.S              |  95 +++++-------
 arch/arm64/kvm/hyp/hyp-entry.S          |  76 +---------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  15 +-
 arch/arm64/kvm/hyp/nvhe/Makefile        |   2 +-
 arch/arm64/kvm/hyp/nvhe/host.S          | 187 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S      |  67 +++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 117 +++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  41 +++---
 arch/arm64/kvm/hyp/nvhe/tlb.c           |   2 -
 arch/arm64/kvm/hyp/vhe/switch.c         |  24 +--
 arch/arm64/kvm/vgic/vgic-v3.c           |   4 +-
 include/linux/arm-smccc.h               |  74 ++++------
 20 files changed, 602 insertions(+), 315 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/host.S
 create mode 100644 arch/arm64/kvm/hyp/nvhe/hyp-main.c

-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
