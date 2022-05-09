Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4562CC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 09:55:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84FC14B2DC;
	Mon,  9 May 2022 05:55:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kQs12---ThE2; Mon,  9 May 2022 05:55:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0004B2E0;
	Mon,  9 May 2022 05:55:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 397F04B2A1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d19lQ8jMfllL for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 05:55:03 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6D084B25F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 05:55:03 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 v124-20020a1cac82000000b003948b870a8dso1826173wme.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 02:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=YW1pGc97VG7+w25sCvimR02dEMnUe2KZ+odKI2ArMeU=;
 b=RkytZLUFgKmmRLNPqBXtTKaZMdMmNAKYw3+HM0MXx/1yex7gDSCKzNlK0bLsECObX0
 N6MpbeP362kVaUSM3R2gLoNKvaXzDUNXtA+AiPd5DcqpgEaTAwJU4cYcc12TBL/vBMBx
 R7goFNwtZ3cX69jm3LGXlujTcN7YBXY63VjEanK3UYZh49X2ef0k4sYpoHYGAzL9J7fw
 fTKTBBP1tKlY5SBOBaf0buWK6T2vwyuEQ3cOVC7UvXFhZIdoKaIyKJ+9VaKDAC+naOkB
 v3JlMDcNxef9+VITS9UHAnTXGpvLjGR4G1sm8uq4TIGL71evdYLXGnijIiUvhTRzV+ja
 QH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=YW1pGc97VG7+w25sCvimR02dEMnUe2KZ+odKI2ArMeU=;
 b=p7czt0HemkZ4z/dHKLU090LlmIDhAkPCFuQ5bj+iKw/tgEUJGWuo14GfdFqGg7bUx0
 +dVY2N9Bo7JYKT4MQ5oJsudsgSgBax3higl4lJOJza4wD1z30TckoNBGQcsoviKi24rb
 jWa5OO0eFyQ7lrvh1OL4Hki66DScR1JuCuYF8CjZNPPBtQSHH2uCdsQ1jAPQ3kLbFRP9
 1rYBkAR+RJVWsmG5bIwbjLwAhNIGMzfQHRA0/dYhcb5Ib3KiN3rHv4XLdi6Hn2GPs7m/
 /uzjOYhYi4E4XDtG4Nt5yKE6uFCVVhoNnTQst9Wd5UpUm1QOKHetWY1l1aougKyznlB5
 2hQg==
X-Gm-Message-State: AOAM530Ftp9nW2duUUOf1fRAgpbvGEdtVyLy4vbzgw6HiqEpE4gy8Dyc
 qpW2+usd4kJBcJNT823CxG7eHaeTKcDuKoPvIiJYKw4AiRPY96f4N5pJZ6mh0+BNw3L0PMc0Kcu
 jMt3wFupO930L50253xFZuCqCUgFhxZIFifUFIy6WuiZ9x18zeOb1kQ06xRNsZrhvhOA=
X-Google-Smtp-Source: ABdhPJzKAAF6fMy6pXPyySPxGmJhKM8F1rEGVwnvmJoNzqi2QbLfO7t4POKVPmJL/duVvF/fdfPVfZku/A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:2f0f:b0:393:fbd1:cc94
 with SMTP id
 r15-20020a05600c2f0f00b00393fbd1cc94mr15465248wmn.162.1652090102410; Mon, 09
 May 2022 02:55:02 -0700 (PDT)
Date: Mon,  9 May 2022 09:54:56 +0000
Message-Id: <20220509095500.2408785-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v2 0/4] KVM: arm64: Do not communicate host pmu event changes
 by accessing hyp data
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

This series changes the way KVM communicates host pmu event changes to the
hypervisor in nvhe and protected mode. Instead of accessing hyp data directly
from the host, the data is passed to hyp via the loaded vcpu. This provides
more isolation between the host and the hypervisor, and allows us to use pmu in
protected mode.

This series is based on kvmarm/next (8c22fd2d4cfa).

Changes since V1 [*]:
- Repack struct kvm_pmu to remove all (two) holes
- Updating the guest's view of the pmu events before every vcpu run rather than
vcpu load to avoid missing updates

Thanks,
/fuad

* https://lore.kernel.org/linux-arm-kernel/20220408084052.3310931-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Wrapper for getting pmu_events
  KVM: arm64: Repack struct kvm_pmu to reduce size
  KVM: arm64: Pass pmu events to hyp via vcpu
  KVM: arm64: Reenable pmu in Protected Mode

 arch/arm64/include/asm/kvm_host.h |  8 ++-----
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 +++++-----------
 arch/arm64/kvm/pmu-emul.c         |  6 +++--
 arch/arm64/kvm/pmu.c              | 40 ++++++++++++++++++-------------
 include/kvm/arm_pmu.h             | 10 ++++++--
 5 files changed, 43 insertions(+), 41 deletions(-)


base-commit: 8c22fd2d4cfaab2ae3c5859496c894df58ab014b
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
