Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBFCC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 17:21:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E984549E29;
	Wed,  2 Mar 2022 12:21:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4KbpJb3uGSB8; Wed,  2 Mar 2022 12:21:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF5B349EB1;
	Wed,  2 Mar 2022 12:21:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AA1C40E00
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:21:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2SvEiB2ArVbe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 12:21:49 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F279940D26
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 12:21:48 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 x25-20020a63b219000000b0037425262baeso1367575pge.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Mar 2022 09:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=9YqbKPgK/tnln+kDR4MCwrkXjLgcuv/9ke+y8jolErQ=;
 b=JJIwR4S1BUgY5vhRkYWvlg1aX6GMvEvVhU92JbsX52jBVdFceU5p6y3G/IgKMkPVcD
 oZ/VPIxu+kdHAtekC/PA5anN/lxyeBlkTP2n37/4izCp/waT7J4XKhWrJrvQM2QEbLTZ
 Zv757zxYDSuctL1b4yiGQNBIWuGtoAgiUJxj7XQH6bvQxXd0psfVfBMaYjVgV+7DkivL
 5rdbbFwAF50Rdt43ND3bqdLmKrRjEgmBGR9MapnLlr/HAMfo/4G0fYtWByHJfMOgxrGB
 JKx+sB9L48WdnwGw9JdIPJhEyuumgp0iba5DPWAUeNGYp2hY9sdAN5s06B0KKVsvSVzc
 +gcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=9YqbKPgK/tnln+kDR4MCwrkXjLgcuv/9ke+y8jolErQ=;
 b=NWyeShaCSgdAWRp4wmiSeHdbzA/vRSQUG9WRO1XW53U/5EJ1hVNuJscHfwQ0CGQOT5
 /otuNpMiaXDCzjV0pB0CRR/+v/rUDs3MntbvDHL1XDQOE+ChOBg9tBTa+1QyKW5Baz4X
 WLfPy/QvjXhQDnVZih3G2WsF2w5pzue1PR8r9JZ0Mmc8RuDYu6oB5xyTrPQkFKFzgV0T
 fNQqg3zRlCfVYSwC80aIwfgcRfS5hjQCG9sbl+An673g2OF0FEDtuwaFEeVzaNR4iW+y
 jQIA5V3bEwzqrG8QVC2CH221/BxJAfrAYDLcGfYb+MwRBpqTBg7SSjeBL+QdjxBeq+xN
 CXLg==
X-Gm-Message-State: AOAM533Ufsa8j7f0BgeFzOmHcKsac+pL6M5F7UboPQU9skbucg+M5asn
 Tf13u9FGrJIdZwG608jZrOwsufFsmLo7zw==
X-Google-Smtp-Source: ABdhPJzcVPPRUt45oQWrGlnE/6fSfAxoeOuL9L8e2CajgCORaLLzh7dZ8SvY7ZHhnxk0ohWDJdzH/VHb/XZaDA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:192:b0:14f:ff7c:33db with SMTP id
 z18-20020a170903019200b0014fff7c33dbmr31987796plg.75.1646241707938; Wed, 02
 Mar 2022 09:21:47 -0800 (PST)
Date: Wed,  2 Mar 2022 09:21:41 -0800
Message-Id: <20220302172144.2734258-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 0/3] KVM: arm64: selftests: Add edge cases tests for the arch
 timer
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, pbonzini@redhat.com
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

Add a new selftests that validates some edge cases related to the virtual
arch-timer, for example:
- timers above the max TVAL value.
- timers across counter roll-overs.
- moving counters ahead and behind pending timers.
- having the same timer condition firing multiple times.

The tests run while checking the state of the IRQs (e.g., pending when they
are supposed to be) and stressing things a bit by waiting for interrupts
while: re-scheduling the vcpu (with sched_yield()), by migrating the vcpu
between cores, or by sleeping in userspace (with usleep()).

The first commit adds a timer utility function.  The second commit adds
some sanity checks and basic tests for the timer. The third commit adds
the actual edge case tests (like forcing rollovers).

Ricardo Koller (3):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |    1 +
 tools/testing/selftests/kvm/Makefile          |    1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 1179 +++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |   18 +-
 4 files changed, 1198 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.574.g5d30c73bfb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
