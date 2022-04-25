Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D713DC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 25 Apr 2022 23:53:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 247F549EC3;
	Mon, 25 Apr 2022 19:53:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H5cbLAzHTE8o; Mon, 25 Apr 2022 19:53:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D51274B0B3;
	Mon, 25 Apr 2022 19:53:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C2EA49EC3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hhmRzwgs6y3u for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Apr 2022 19:53:45 -0400 (EDT)
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com
 [209.85.161.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AACAA49EC0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 19:53:45 -0400 (EDT)
Received: by mail-oo1-f73.google.com with SMTP id
 j15-20020a4a888f000000b00321764d8f14so9334022ooa.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Apr 2022 16:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=DcihtRyhxZSASrAxWYvG+vbHikEXUCwgp718CSC9bMo=;
 b=bxDlTykMwr9Eii5P0vs5td20RwMYWDrdaNaR3kKZ6vFMPHfRLG5jmjORyoP4POGF60
 nA8phR2ww4MgrzN+LMPxGJbnSEDso7tQL9wckviWO+/d1JIoTst1Xwa/dk58wvUeVjls
 PfcbUhZVCEdviaAFb8SOKwHJ7v6guuTIGUAVf3AEF149Tx//Fq0j1mkofEIskSRN7/Ih
 z7aYDioOgYuIA6euhcoVCkZ5TjsZwpOFdAhJSWXOr/3YvLiOJrWoc/qrnP/fJIQIBCcE
 bL7ORzw1GtMnmr0yYEPa5SD1uwfXD7rURiQfC4d/AHIsn70korOgZqUm5PLbqXq0rZwk
 7n5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=DcihtRyhxZSASrAxWYvG+vbHikEXUCwgp718CSC9bMo=;
 b=MXMjyc8H38fXMLt+86leeQVjcIhP/gNAeuSdpnONRAcajeuE6XSJEyrU4ZqNtzgKe4
 MenxoFjlgKwAFcXsF0x+Ebc5o3t29mJu4l4CoxcJFxUyR2OPtZlwNZLwKsFJFilhjA3H
 J9xaUb7v0KnqQxLNo1ngm21gtgsqwJCVjCnAZWBSLJUx0r9FwGwm+LqP3O8b7qheM2vl
 OwwZChbPUKaPflQFiHXe7ayZeOKB+mgOKVbeaiHtMwPFfhUhXtWbCtmtVEJAYNKf0IZJ
 wn+Yw1k8CLl+xXAT8AcRIOR5nLNMfF1pID9+jAmZErvv7ycNAXFmEFgxFGkXVClzXfJI
 bPzA==
X-Gm-Message-State: AOAM533dOCuaBNj/4ns3SHcAvCy01G7qXDUl9hL074hdhiVDfFV4X/dA
 68KLkW9Imb05iuxPAm8OkzsSm6R+/MEFFvdZfQkNU791B5a4SNovRB+plV1jeREEV51EK+B9XKa
 tNBeHdyF/eAG2aW+XD26dKDlnbS5gFz2Qo4hny3v/rOVDepPaFCuATm2NHPRAi/GtmbgrnA==
X-Google-Smtp-Source: ABdhPJxKsgOjwnsQHHwzUCN10OQb3jAAYyq3y/pis69T7DTdEuFTR2EpQXnDB6jMJ7K6ExgV6uUQsRgVmh0=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a05:6870:1481:b0:d7:30a3:1f39 with SMTP id
 k1-20020a056870148100b000d730a31f39mr12496597oab.14.1650930824850; Mon, 25
 Apr 2022 16:53:44 -0700 (PDT)
Date: Mon, 25 Apr 2022 23:53:37 +0000
Message-Id: <20220425235342.3210912-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v3 0/5] KVM: arm64: Limit feature register reads from AArch32
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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

KVM/arm64 does not restrict the guest's view of the AArch32 feature
registers when read from AArch32. HCR_EL2.TID3 is cleared for AArch32
guests, meaning that register reads come straight from hardware. This is
problematic as KVM relies on read_sanitised_ftr_reg() to expose a set of
features consistent for a particular system.

Appropriate handlers must first be put in place for CP10 and CP15 ID
register accesses before setting TID3. Rather than exhaustively
enumerating each of the encodings for CP10 and CP15 registers, take the
lazy route and aim the register accesses at the AArch64 system register
table.

Patches 1-2 are small cleanups to how we handle register emulation
failure. No functional change for current KVM, but required to do
register emulation correctly in this series.

Patch 3 reroutes the CP15 registers into the AArch64 table, taking care
to immediately RAZ undefined ranges of registers. This is done to avoid
possibly conflicting with encodings for future AArch64 registers.

Patch 4 installs an exit handler for the CP10 ID registers and also
relies on the general AArch64 register handler to implement reads.

Finally, patch 5 actually sets TID3 for AArch32 guests, providing
known-safe values for feature register accesses.

There is an argument that the series is in fact a bug fix for running
AArch32 VMs on heterogeneous systems. To that end, it could be
blamed/backported to when we first knew better:

  93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")

But I left that tag off as in the aforementioned change skipping
AArch32 was intentional. Up to you, Marc, if you want to call it a
bugfix ;-)

Applies cleanly to 5.18-rc4.

Tested with AArch32 kvm-unit-tests and booting an AArch32 debian guest
on a Raspberry Pi 4. Additionally, I tested AArch32 kvm-unit-tests w/
pmu={on,off} and saw no splat, as Alex had discovered [1]. The test
correctly skips with the PMU feature bit disabled now.

[1]: https://lore.kernel.org/r/20220425145530.723858-1-alexandru.elisei@arm.com

v1: https://lore.kernel.org/kvmarm/20220329011301.1166265-1-oupton@google.com/
v2: https://lore.kernel.org/r/20220401010832.3425787-1-oupton@google.com

v2 -> v3:
 - Collect R-b from Reiji (thanks!)
 - Adopt Marc's suggestion for CP15 register handling
 - Avoid writing to Rt when emulation fails (Marc)
 - Print some debug info on an unexpected CP10 register access (Reiji)

v1 -> v2:
 - Actually set TID3! Oops.
 - Refactor kvm_emulate_cp15_id_reg() to check preconditions before
   proceeding to emulation (Reiji)
 - Tighten up comment on kvm_is_cp15_id_reg() to indicate that the only
   other trapped ID register (CTR) is already handled in the cp15

Oliver Upton (5):
  KVM: arm64: Return a bool from emulate_cp()
  KVM: arm64: Don't write to Rt unless sys_reg emulation succeeds
  KVM: arm64: Wire up CP15 feature registers to their AArch64
    equivalents
  KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
  KVM: arm64: Start trapping ID registers for 32 bit guests

 arch/arm64/include/asm/kvm_arm.h     |   3 +-
 arch/arm64/include/asm/kvm_emulate.h |   7 -
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/handle_exit.c         |   1 +
 arch/arm64/kvm/sys_regs.c            | 197 +++++++++++++++++++++++----
 arch/arm64/kvm/sys_regs.h            |   7 +
 6 files changed, 178 insertions(+), 38 deletions(-)

-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
