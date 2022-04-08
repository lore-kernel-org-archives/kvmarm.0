Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4880C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 08:40:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D12D4B14C;
	Fri,  8 Apr 2022 04:40:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cnLBbhb7kXEH; Fri,  8 Apr 2022 04:40:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F02574B15E;
	Fri,  8 Apr 2022 04:40:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B929D4B14C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:40:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oviJAumjnT-F for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 04:40:55 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84BA549F20
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 04:40:55 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 l19-20020a05600c1d1300b0038e736f98faso2082058wms.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 01:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Nppf0IVUcbryIy16xL7a0EyLuMDdlfoY1IOmXXJ7T9g=;
 b=ClKRdYAX/jJ01QPRYEvw+j1C+Ngfdnh/FySEhtUJUth0UsYl4MAz4K4Xr0OMTyGc3k
 0iINv1KnmLz3FlqBSyYCY4Q4lfB6PVeKE4BF+EW1DanrPeJaxsBAC4ImQSgcyxILxnv8
 +b/JxzXFDjEIscdb0oDwXCbFzZq7UAojGHNJ2iT9BFqbJ6r58xcuKA79jPf6VK8yJPZb
 ijC1jrI++c09toxd1XRMToPOC+LW1fhYzR506ItrhJzHr3F03fewK5xZueOUcH5s24UG
 NrtvXAeJsAIYcEUnCgKY1NDrSEMz2JeL93WRecclM5UwF47qKurB+egvyL9ImA3fsUAd
 J2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Nppf0IVUcbryIy16xL7a0EyLuMDdlfoY1IOmXXJ7T9g=;
 b=eE/uxHSj+04O1/ocqJGyXlmG2kaXRwEop4pETvkhp0vJKILQ1GJ3mi/5Z80pi5aeTV
 ef80HlS6dTKcazE47sULpbP73lVJ81zLDegZX+IWydO8EKFIQEQHuRf2GQvSwId6cNoH
 YWJvUTc6CRawihPpzysZZVrXBEvI6NStnoKk5BnZOYwBLHRg7nKup04zgx5wDkahBoSm
 744F8X2MhCIkCWj4eR5Jb+YLq4p8dzXRLC1YwHLtHVm/6CSE98pZYiil/JvjrxTERs52
 c40QCsjXoATLqIXfJeVpdP7zAsLAdapOO7f7i5GKZVhxyPzwqBFtXnQNe8pBIrmv7B3q
 hQlQ==
X-Gm-Message-State: AOAM533Nz5TEZhCdtP4slSNYIDPPR6vrT5sHQRGmKqXxi8BRkm8JtqpU
 Q6Tb7LwSja9nZWzbLd/+hnU1YTIuJs784pZywM7fuAqJi3PEcELZG7Sr0VFqDGqSmYFXwR00eTm
 eJhDMKs0aE5fTlCktPm0SEm/w8Zfyj0o/PlXCqrZpY1pqlEmoefUWlHC1tw2AIkCpEWA=
X-Google-Smtp-Source: ABdhPJyNZCaPHSyKllqyzN/x+DlMqMHNaN1fxF7n9qRxANWZjGjBn5VEnUWtfciVShfJyNqeBJbN5DEbag==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:3d14:b0:38c:9d85:781d
 with SMTP id
 bh20-20020a05600c3d1400b0038c9d85781dmr15820986wmb.191.1649407254542; Fri, 08
 Apr 2022 01:40:54 -0700 (PDT)
Date: Fri,  8 Apr 2022 09:40:49 +0100
Message-Id: <20220408084052.3310931-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v1 0/3] KVM: arm64: Do not communicate host pmu event changes
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
from the host, the data is passed to hyp via the loaded vcpu. This gives more
isolation between the host and the hypervisor, and would allow us to use pmu in
protected mode.

This series is based on kvmarm/next.

Thanks,
/fuad

Fuad Tabba (3):
  KVM: arm64: Wrapper for getting pmu_events
  KVM: arm64: Pass pmu events to hyp via vcpu
  KVM: arm64: Reenable pmu in Protected Mode

 arch/arm64/include/asm/kvm_host.h |  8 ++----
 arch/arm64/kvm/arm.c              |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 ++++---------
 arch/arm64/kvm/pmu-emul.c         |  3 +-
 arch/arm64/kvm/pmu.c              | 48 ++++++++++++++++++++-----------
 include/kvm/arm_pmu.h             |  6 ++++
 6 files changed, 47 insertions(+), 40 deletions(-)


base-commit: 21ea457842759a236eefed2cfaa8cc7e5dc967a0
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
