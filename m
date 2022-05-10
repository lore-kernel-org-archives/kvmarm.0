Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4010C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 09:57:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4974B089;
	Tue, 10 May 2022 05:57:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KoefZN-cSIyG; Tue, 10 May 2022 05:57:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 170FD4B150;
	Tue, 10 May 2022 05:57:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 497F24B0F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yw2STxP3cBfx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2022 05:57:13 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1546B4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 05:57:13 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 u26-20020adfb21a000000b0020ac48a9aa4so6839340wra.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2022 02:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=MtmAwqs8YXD/WNqsl0616lAaftWmFHAYLnEsrB1KhE4=;
 b=ew+YDsEUoNHbNrWsYNdJdcGpH3TgT2wsvr5GWyUVKu+wt0F2/R//RpQyZ3ggJg+wLN
 RilebVlNbX13rClyxSmkdJ08XLrdKnhl+cTKvCau1hrFEJzlOyXhp4dr3x97CVQW51d3
 wOZFDIZ3No6yG3bxFXJpsLGA+i+JnAnJ5zMcIyQ/IT3cdKDIhdvzDqBPka01K7tQixWS
 uBZgI25qSAPQ7chWT0yId+JULBKaBUN3i9HRdeGEpyLTw9nrtsjJDAWHNC4odg7a+gVO
 bmfHTw65EWxeHvM1J/qgSZ2B8FQob4a0AHZe5D02U7twBIGz0owwEpdBI4JebNquI6Lj
 +7Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=MtmAwqs8YXD/WNqsl0616lAaftWmFHAYLnEsrB1KhE4=;
 b=ccumUehfOvPcDCxVmm+nEVghiqOmykrIzNlOrL/et6obdU0XxVOX6RgNqHFuRP9c/v
 +jf2mPEfS9uALjZ3TkqXNu0mL+UmfXoLR5Vb8YpjV997k+gihl9il8yerCKfvWHc2M9M
 lq0zDMuTPZA9+tMis4WArRwfSqtHTktFfhEIcp7bqjU+INRZEDhUvyEfRyZW2BrINIxV
 VP6F6GiGTnFUQprtN7m8pKImPJa8x5/vGTAwt63vTS7gY8za6p69ZxEkMeh9REgKgQP0
 c9rnxUUnfPF+RgBBd5c18Ws5K4y2tN07SlrPokH/Ulfqyd5vnIg0GawihHBaxgWX1CyD
 mbfA==
X-Gm-Message-State: AOAM532lu+Kmr1ifslYonkz2l5XjIBCr3Ol8BJTDpkjTZNyeaqZhuvbp
 sPYBWcx7tSess+iQyyqsKn1pac4e5DV/Croy52Bt9c7VRAsGBJl7uX0YV2f3e4OKYQJIv3Z8dR5
 SWJInJcy6ExqWqqWASrS2rZC2rCCD/mGeUZFmyd3bnVkT91RS9Aa6W18IhbyVYyY6wi8=
X-Google-Smtp-Source: ABdhPJw4V8FP3VXISHMvP+eBFRlmx3MmQxzndgE1sucyKQRc17P8zqP22OPaMbH4UkiBA4NsOppvDdCkbA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a7b:c414:0:b0:394:21dd:e24f with
 SMTP id
 k20-20020a7bc414000000b0039421dde24fmr20840132wmi.133.1652176631812; Tue, 10
 May 2022 02:57:11 -0700 (PDT)
Date: Tue, 10 May 2022 09:57:06 +0000
Message-Id: <20220510095710.148178-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v4 0/4] KVM: arm64: Do not communicate host pmu event changes
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

Changes since V3 [1]:
- Fix/clarify commit messages (Oliver)
- Reduce scope of kvm_pmu_events (Oliver/Marc)

Changes since V2 [2]:
- Update the guest view of the pmu events after interrupts have been disabled
  (Marc)

Changes since V1 [3]:
- Repack struct kvm_pmu to remove all (two) holes (Marc)
- Updating the guest's view of the pmu events before every vcpu run rather than
  vcpu load to avoid missing updates (Marc)

Thanks,
/fuad

[1] https://lore.kernel.org/all/20220509120330.3043773-1-tabba@google.com/
[2] https://lore.kernel.org/all/20220509095500.2408785-1-tabba@google.com/
[3] https://lore.kernel.org/linux-arm-kernel/20220408084052.3310931-1-tabba@google.com/

Fuad Tabba (4):
  KVM: arm64: Wrapper for getting pmu_events
  KVM: arm64: Repack struct kvm_pmu to reduce size
  KVM: arm64: Pass pmu events to hyp via vcpu
  KVM: arm64: Reenable pmu in Protected Mode

 arch/arm64/include/asm/kvm_host.h |  7 +-----
 arch/arm64/kvm/arm.c              | 15 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c  | 20 +++++-----------
 arch/arm64/kvm/pmu-emul.c         |  3 +--
 arch/arm64/kvm/pmu.c              | 40 ++++++++++++++++++-------------
 include/kvm/arm_pmu.h             | 10 ++++++--
 6 files changed, 54 insertions(+), 41 deletions(-)


base-commit: 8c22fd2d4cfaab2ae3c5859496c894df58ab014b
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
