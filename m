Return-Path: <SRS0=7ri5=BA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014BFC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 746DB20792
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jul 2020 13:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxePU75M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 746DB20792
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB8C24B1F6;
	Tue, 21 Jul 2020 09:31:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zlSWA+topwx8; Tue, 21 Jul 2020 09:31:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD8484B1CE;
	Tue, 21 Jul 2020 09:31:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 444354B22C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:17:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id owZ1E-5IHUSI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jul 2020 00:17:58 -0400 (EDT)
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com
 [209.85.215.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 227164B1BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jul 2020 00:17:58 -0400 (EDT)
Received: by mail-pg1-f194.google.com with SMTP id p3so11355609pgh.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jul 2020 21:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=NGaATuKDW25tfXnjy17rADeTuRjp0tV/vbWKKeWM86k=;
 b=FxePU75MyL2vEbevw6TtpxAoZ7al858qTZLgnulsvLtPDHAZfRUGdWc8xDb2P2/S9/
 bBc/PZv5oRmBtHu48J57hkDZoUPQczKHwLfygAQtWJAsbxUuyNPgQOhqoO7hnGwY2S1l
 BjCPVh9MaV1iO0wYglWEBL4YpgbhAKblNLO+R5ajQ6JgPxXfHsi5f7SvrdmclWZhjMtz
 Y+YCcQoTX72YN/GxWylHQAn1hpHmYUVKeFMHkT/mb0j446hxYU+dM2N7Iccf+4Enn9/u
 /BVQr+laVTtELgg68bMcctbJvSPmcvK0ISINvHZSf6qmhX8LdfPhs54QE7ulpgedx3ty
 BEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=NGaATuKDW25tfXnjy17rADeTuRjp0tV/vbWKKeWM86k=;
 b=FKNG/eV3C9DfpZcupxjQhHf7GdCuiL3SZCZg2RtddVClecMYauWmRbUUafeWDxgcSQ
 tHyG+x3UYA3iqBn4I/xuoo7Ii8NEXWmGcSyJLl4q94L6wretUtf5HvmrJuKWPQ9NuRs3
 C8dfnVpSDE6IfpABfaM1CTHASSj6hgwl8BPg1z2Y1sbfDozDhKiIcZAaDbWqbM0cmZAK
 mLZ5sYdTmNLR4i9/Xw5GRegR97NpUJI2aM6KRDzP76bBUu0ANFWW2hPSaM5RjN+N0mbW
 XFaOhJgC6/E8kfAuKZHQ9MNahwBfOhnoqgg8xpmLtGsfxpNOZeqposm0XCYbGnIQ8dJX
 0Ppg==
X-Gm-Message-State: AOAM530DRzs6FJrPQwnUxZ7nIrUJktdhq2QUz7iK6x7oF4XgG2iiPlqd
 eplmLfYtBq9uX88gvWOl69U=
X-Google-Smtp-Source: ABdhPJzYY7DsDQI2R2Hw96u5qdwyUqBzumqyzaOhAyEtXxWQuqRgXwtqQViAPRcRnUwjnAvM4sTsoQ==
X-Received: by 2002:a63:6884:: with SMTP id
 d126mr20548484pgc.341.1595305077188; 
 Mon, 20 Jul 2020 21:17:57 -0700 (PDT)
Received: from localhost.localdomain ([2409:10:2e40:5100:6e29:95ff:fe2d:8f34])
 by smtp.gmail.com with ESMTPSA id
 e28sm18467270pfm.177.2020.07.20.21.17.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Jul 2020 21:17:56 -0700 (PDT)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [RFC][PATCH 0/4] arm64:kvm: teach guest sched that VCPUs can be
 preempted
Date: Tue, 21 Jul 2020 13:17:38 +0900
Message-Id: <20200721041742.197354-1-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 21 Jul 2020 09:31:48 -0400
Cc: joelaf@google.com, linux-kernel@vger.kernel.org,
 Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, suleiman@google.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hello,

	RFC

	We noticed that in a number of cases when we wake_up_process()
on arm64 guest we end up enqueuing that task on a preempted VCPU. The culprit
appears to be the fact that arm64 guests are not aware of VCPU preemption
as such, so when sched picks up an idle VCPU it always assumes that VCPU
is available:

      wake_up_process()
       try_to_wake_up()
        select_task_rq_fair()
         available_idle_cpu()
          vcpu_is_preempted()    // return false;

Which is, obviously, not the case.

This RFC patch set adds a simple vcpu_is_preempted() implementation so
that scheduler can make better decisions when it search for the idle
(v)CPU.

I ran a number of sched benchmarks please refer to [0] for more
details.

[0] https://github.com/sergey-senozhatsky/arm64-vcpu_is_preempted

Sergey Senozhatsky (4):
  arm64:kvm: define pv_state SMCCC HV calls
  arm64: add guest pvstate support
  arm64: add host pvstate support
  arm64: do not use dummy vcpu_is_preempted() anymore

 arch/arm64/include/asm/kvm_host.h  |  23 ++++++
 arch/arm64/include/asm/paravirt.h  |  15 ++++
 arch/arm64/include/asm/spinlock.h  |  17 +++--
 arch/arm64/kernel/Makefile         |   2 +-
 arch/arm64/kernel/paravirt-state.c | 117 +++++++++++++++++++++++++++++
 arch/arm64/kernel/paravirt.c       |   4 +-
 arch/arm64/kernel/time.c           |   1 +
 arch/arm64/kvm/Makefile            |   2 +-
 arch/arm64/kvm/arm.c               |   4 +
 arch/arm64/kvm/hypercalls.c        |  11 +++
 arch/arm64/kvm/pvstate.c           |  58 ++++++++++++++
 include/linux/arm-smccc.h          |  18 +++++
 12 files changed, 262 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/kernel/paravirt-state.c
 create mode 100644 arch/arm64/kvm/pvstate.c

-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
