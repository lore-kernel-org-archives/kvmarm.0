Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D286AC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 01:13:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32B784B1C3;
	Mon, 28 Mar 2022 21:13:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KLpMJAnaBCCZ; Mon, 28 Mar 2022 21:13:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DB424B178;
	Mon, 28 Mar 2022 21:13:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D6E849EFE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PvxPhDvGYTRl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 21:13:10 -0400 (EDT)
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com
 [209.85.210.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 318E34B119
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 21:13:10 -0400 (EDT)
Received: by mail-ot1-f74.google.com with SMTP id
 c1-20020a9d67c1000000b005b2353e2c03so9058170otn.8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 18:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=nYlE+C/axixPppHHbcO/XGK1yVRHkszjXFRKMgmo2rQ=;
 b=tUZNXLhTPTopRQyZVbL8Vxdk++9/mwdVfpzx2zNYKV1d3E/6Kg6zw6o0PSKaWu26Y1
 pG1gfCQFJzSZdys9ABwQ1NIBkX62MZJ6XdDGpjd9VvNaS4Pm/4M6RTUzEVwDm4VUEY3c
 AvbGNQLFPOEUxr2O9hbCT0Y6CXJ9zQykHhFNsZtgolLyid4BWiF7gsm9Mq6N7Oo3XtjT
 3m7EebjNmgk1vWU5ojSN1cvxV/nuAyN7B/NiGZ7H6PDfg6IEVoA1zXw3Ru+QOaR+RX7l
 j280fbEy7glIONhzteHunuyH7rmj9wuQ3Swek9km8eOogW1f+hVDtsHIyG8/Lrc/9uoM
 ub3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=nYlE+C/axixPppHHbcO/XGK1yVRHkszjXFRKMgmo2rQ=;
 b=RnmDYogfDkmmVnrReV/fU0MKjQ+sbG+CReoB1F1Hf08MKbVaY9CTvPDgZ7Rq2KS0An
 vY5morQqxi6Mah1R8ZnN5e0FtP4ICsTHOqJzQuHVLHe8fsxogdNun4KiZEEYahCz4Xyj
 4trAp7wDA5Iz2tIGI8o118sQLU/cOFImEZPQNr8qh2LuG1Zayh4k8TZsRH1nbgeQ/nWW
 hTocYYKz8m0HetXQyPy79I5xZzxqJml07EjmveNs1egutdFvcu0ji39y3/t0MGAijVk0
 Vm8P3LzMtDHl+Rs0+sk/fHOM3uK8H4jhA70VcgUIxOU+WUzVJHEaUh7urSUJlG/0cYkB
 2mNQ==
X-Gm-Message-State: AOAM531w1XkEfJ58mFN2IlGX9WFEFYudqIlqZJdCA6GJMyYZ1GDaDCFP
 zgnsLHrREadidVNPH7+7g5NTKD0/oxCG5H6OArqb6mKHG9AMculVCUo+YWro35akZKZZ7oiXGic
 zktV4AbjM2zq4WmwmIYWSkpEOe+U0wzoujydpAFYYSZEDa6AYd55/CMvRAhigD5+eFTnQHQ==
X-Google-Smtp-Source: ABdhPJwwujhcPW9Bu1rOL7Be1SGcb234TZlpdxtAkIVxfUSk/Vnz+sZ0hNqbYylYDqlhN4vDVQTbAJrgTQ8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:6f07:0:b0:5b2:38e8:41f7 with
 SMTP id
 n7-20020a9d6f07000000b005b238e841f7mr113246otq.308.1648516389241; Mon, 28 Mar
 2022 18:13:09 -0700 (PDT)
Date: Tue, 29 Mar 2022 01:12:58 +0000
Message-Id: <20220329011301.1166265-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH 0/3] KVM: arm64: Limit feature register reads from AArch32
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

I'll leave it as an exercise for the reader to decide whether or not I'm
being _too_ lazy here ;-)

Series applies cleanly to kvmarm/fixes at commit:

  8872d9b3e35a ("KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler")

Tested with AArch32 kvm-unit-tests and booting an AArch32 debian image
on a Raspberry Pi 4. Nothing seems to have gone up in smoke yet...

Oliver Upton (3):
  KVM: arm64: Wire up CP15 feature registers to their AArch64
    equivalents
  KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
  KVM: arm64: Start trapping ID registers for 32 bit guests

 arch/arm64/include/asm/kvm_emulate.h |   8 --
 arch/arm64/include/asm/kvm_host.h    |   1 +
 arch/arm64/kvm/handle_exit.c         |   1 +
 arch/arm64/kvm/sys_regs.c            | 128 +++++++++++++++++++++++++++
 4 files changed, 130 insertions(+), 8 deletions(-)

-- 
2.35.1.1021.g381101b075-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
