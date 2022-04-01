Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB11C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Apr 2022 01:08:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AD514B261;
	Thu, 31 Mar 2022 21:08:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U-f1prPZUDlB; Thu, 31 Mar 2022 21:08:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F27F44B259;
	Thu, 31 Mar 2022 21:08:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28A854B20F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6QIdQOam1J7D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Mar 2022 21:08:40 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E49EC40597
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 21:08:39 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 q6-20020a056e0215c600b002c2c4091914so858800ilu.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Mar 2022 18:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=kL9d/s0Mnyvvq5xceGf8t2Ku5ZfUJAPmTPk2nXEvlGU=;
 b=N2eqlZ8z3YFz3XyEkuOB+8wTp8T2vu7nAJ3SBPyPPNG2EXyKjBs2zPReQsCNcgR62/
 GgomeeOiuFgJj2EaUihw08Xev8ZvqIS3N4tYW2pm2uTP4ru4dIVNrNv8M2pcnDYbMpzi
 etIJvz6Q1i4ZUe9P85kyqhOCjztZjX0V6innFelwk/ZSnFAQ+QYvl/1KY0OjeRKSp63J
 ltTOL14JzHH+dM2+1yJFOEFF0jbRCJM8Zocyzj4RDtfpInxk6j49zUy34U0BUd1W4ONP
 7jehSV8LgeGFLwVEbex+LM9J5KNqZGeK3YkxooMZAKby5lcazJXLQsqQrRcjeKfAh2UT
 JVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=kL9d/s0Mnyvvq5xceGf8t2Ku5ZfUJAPmTPk2nXEvlGU=;
 b=qhRGEywMIcsLcaXJU/Hf9odn4DETtfKJd7JupN0v001Jx8xkMVw/LxsHEeTY9cFxBa
 IvowLN5yqhW0rSpJSFVS9bxQAPaSAqhxSylhsREWt7uCtLh0ofENUrGUBCavOPJd1iPD
 SyTQx7uZ6UPUclMAzO3wDPdiAi6TJZBX5gigivdtNbmeOFDtEqdQUrccoK+gVdZdhmC7
 N7PiR4bWgGGzJsx+Zd0wNMlp2hJpWpM/9Gxm5RHo5V+M60Zoqfxwus4g8XOHBemAIsxd
 d7JJoJhVBqqKgaiGqJA6c5uhGOQEtesbVNSv4CoEyMN0WFsPqMu7B3Hfmz3/FM9SHsRM
 VfQQ==
X-Gm-Message-State: AOAM533uvayKnvkhf17qP7hqdjhptDLvHVWMtmf72fA/152JEvaI/zGc
 gRtrQirZd/yoMn52Wq0vGVPhWURQBypU/Jg6jn0DUUtKl8JrJ2jm7mtvjP+zP18l13XNT0e7MP0
 1Ka/Wxzyjg+OiRNzSiqwSIEBwpySafJXJuU0XYFJhUSkHtxVuWKF+jFSko/iOw9UF61kujw==
X-Google-Smtp-Source: ABdhPJxQnq7pKml6XanwOMnHzHv9EDXFtxgBk58x0mq9HUGV2OjLa88lb/ZOZv8EHc19z+AoKhav5b9MVFE=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:1e06:b0:2c8:2707:71d
 with SMTP id
 g6-20020a056e021e0600b002c82707071dmr14141413ila.39.1648775319144; Thu, 31
 Mar 2022 18:08:39 -0700 (PDT)
Date: Fri,  1 Apr 2022 01:08:29 +0000
Message-Id: <20220401010832.3425787-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 0/3] KVM: arm64: Limit feature register reads from AArch32
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

Patch 1 reroutes the CP15 registers into the AArch64 table, taking care
to immediately RAZ undefined ranges of registers. This is done to avoid
possibly conflicting with encodings for future AArch64 registers.

Patch 2 installs an exit handler for the CP10 ID registers and also
relies on the general AArch64 register handler to implement reads.

Finally, patch 3 actually sets TID3 for AArch32 guests, providing
known-safe values for feature register accesses.

Series applies cleanly to kvmarm/fixes at commit:

  8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

There is an argument that the series is in fact a bug fix for running
AArch32 VMs on heterogeneous systems. To that end, it could be
blamed/backported to when we first knew better:

  93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features from guests")

But I left that tag off as in the aforementioned change skipping
AArch32 was intentional.

Tested with AArch32 kvm-unit-tests and booting an AArch32 debian guest
on a Raspberry Pi 4.

v1: https://lore.kernel.org/kvmarm/20220329011301.1166265-1-oupton@google.com/

v1 -> v2:
 - Actually set TID3! Oops.
 - Refactor kvm_emulate_cp15_id_reg() to check preconditions before
   proceeding to emulation (Reiji)
 - Tighten up comment on kvm_is_cp15_id_reg() to indicate that the only
   other trapped ID register (CTR) is already handled in the cp15
   register table (Reiji)

Oliver Upton (3):
  KVM: arm64: Wire up CP15 feature registers to their AArch64
    equivalents
  KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
  KVM: arm64: Start trapping ID registers for 32 bit guests

 arch/arm64/include/asm/kvm_arm.h     |   3 +-
 arch/arm64/include/asm/kvm_emulate.h |   8 --
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/handle_exit.c         |   1 +
 arch/arm64/kvm/sys_regs.c            | 129 +++++++++++++++++++++++++++
 5 files changed, 133 insertions(+), 9 deletions(-)

-- 
2.35.1.1094.g7c7d902a7c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
