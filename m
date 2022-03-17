Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E9CC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 04:51:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC9A49F30;
	Thu, 17 Mar 2022 00:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HdvAtmOe7Xik; Thu, 17 Mar 2022 00:51:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F754A100;
	Thu, 17 Mar 2022 00:51:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3115649F26
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 00:51:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s95E7JY2qUoz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Mar 2022 00:51:32 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBC6149EAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Mar 2022 00:51:31 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 s20-20020a17090ad49400b001bf481fae01so3625297pju.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 21:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=gsRfKzq4vGn1YNn7YUeVAb6qtw1e/e04FOs1fz7BrH8=;
 b=JQG63yoRkgZtQa+AY5jQ61gQ21UrAkBQTDwjcqE2wayF+Aw4AE7+soI3KijdVqUYth
 PA+hEiVlLfeDxUnpYSSfvZYqpWIzC/cD7KxxMRRaidxbHfUUpjfNO++vp23aI8SxFNXQ
 VNz91cyBoLSLN/u8cEo327J4nZPFO4XQN6SUi8pt//hAX8OFAQtYftmQtWHYqMfE+Oh/
 3To00VP/WmW2h9NWj9TJ3SI4+LNL3gUxfXG60r9DWvtkrVBmfYJqVcS27uYuDIbO/qES
 XixXnDXWQ751hX8ejbeNt6RayBdIbk+kZshHHKYU/RrxBMcLdnI2MmN96lBOjX7ldQpI
 +YSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=gsRfKzq4vGn1YNn7YUeVAb6qtw1e/e04FOs1fz7BrH8=;
 b=pSi2B7ZBETzohc6qzzM8E++U2p59vaLD+QTf8ki/t2JBeHDfVpXsAoOObt9+OKuj+M
 WtDape7DQpPojFEeWANT5uX3zSw1fnz15Qjr7QLjNA/fGSpJYPwrb7ZnfsDEBXlPgjur
 Byw/bESAxYISrsbAHUb/vUOcP10Tn/IjWugPImmgcc7anWcHQeOtiyav1gFTjpeEO6y9
 aJvjgQU2jWrF5pyiIWyiZ2NwUE2ByvsR8QGWsT9lOK0ZSTqKaA51/RxmUEhbhJntxx80
 PeepxLSmgL8D+jB0L8iG1NeZABpZ0gq5iWnBxa4PeUKZ8cbzEqiKl1NvEqwKMYkqQuot
 TKvQ==
X-Gm-Message-State: AOAM533U2Iqh/fNcIii3HPSGTZJJ9+Po6rbk3nhHKjMXJUdtg7owNqHx
 aq1RQLXKLJB5/OE0yRawO3VX1HD5KORKjA==
X-Google-Smtp-Source: ABdhPJzy+EnjPuXkGb+ndtKs1lIVtKRwKk8qD6YEJzvqK1mx3sZTRli0/Bkp7MZ6poB8q45nifTmZHT0ufFTpQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:e541:b0:1c6:55e5:ae4b with SMTP
 id ei1-20020a17090ae54100b001c655e5ae4bmr9070079pjb.62.1647492690738; Wed, 16
 Mar 2022 21:51:30 -0700 (PDT)
Date: Wed, 16 Mar 2022 21:51:24 -0700
Message-Id: <20220317045127.124602-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 0/3] KVM: arm64: selftests: Add edge cases tests for the
 arch timer
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

v1 -> v2:
- Remove the checks for timers firing within some margin; only leave the
  checks for timers not firing ahead of time. Also remove the tests that
  depend on timers firing within some margin. [Oliver, Marc]
- Collect R-b tag from Oliver (first commit). [Oliver]
- Multiple nits: replace wfi_ functions with wait_, reduce use of macros,
  drop typedefs, use IAR_SPURIOUS from header, move some comments functions
  to top. [Oliver]
- Don't fail if the test has a single cpu available. [Oliver]
- Don't fail if there's no GICv3 available. [Oliver]

v1: https://lore.kernel.org/kvmarm/20220302172144.2734258-1-ricarkol@google.com/

There is a slight complication with where this series applies.  The test added
here fails without commit cc94d47ce16d ("kvm: selftests: aarch64: fix assert in
gicv3_access_reg") which lives in kvmarm/next.  However, it can't be built on
top of kvmarm/next as it depends on commit 456f89e0928a ("KVM: selftests:
aarch64: Skip tests if we can't create a vgic-v3") which is not in kvmarm/next.

Ricardo Koller (3):
  KVM: arm64: selftests: add timer_get_tval() lib function
  KVM: arm64: selftests: add arch_timer_edge_cases
  KVM: arm64: selftests: add edge cases tests into arch_timer_edge_cases

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/arch_timer_edge_cases.c       | 891 ++++++++++++++++++
 .../kvm/include/aarch64/arch_timer.h          |  18 +-
 4 files changed, 910 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/arch_timer_edge_cases.c

-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
