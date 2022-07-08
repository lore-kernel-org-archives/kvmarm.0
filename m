Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC75CCA480
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jul 2022 09:43:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 024864BB4A;
	Mon, 11 Jul 2022 05:43:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SV7+G9Sjtz8d; Mon, 11 Jul 2022 05:43:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 26C454BB64;
	Mon, 11 Jul 2022 05:42:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D9834B596
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 17:21:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oczSC5YdA4fG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jul 2022 17:21:15 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1AF784B58D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jul 2022 17:21:15 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 k18-20020a25fe12000000b0066e21b72767so13819685ybe.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jul 2022 14:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=ZsW33TkaPVzGGAiF9Xw3rp8pMfW3pJDcP2sjUehOYU4=;
 b=Khnt/FKK2tmsglb39aHaXQe/85L0TtdEJmytldtpcB7PdifoCaJXvAu2CXcRmW1fzx
 y39SxrSY7BKqQOhMItRgS/Cx13UN/kBbrwQ/Gam0nbaR+8Q7CoY1CiXg5B71WoRePh2j
 BmY3lKiwS2ycyhg1BS16LXD9Z7aJPS0FkC2pQXd9qzhTDIpI2i7CD++lRaDj6QF8edbp
 dmfRRneCPKYpTwMrDrz8fnENuy1IXO5JIE+xD92f0pgT98gAriCpCX0P3s1Ps91yxQy7
 2hW2FGKbnGGRHuFURNW1H5Kl/eN3DF8tCmpGMZd4C4s8/P7ZhEauaDouX1m50xPL/K5r
 KtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=ZsW33TkaPVzGGAiF9Xw3rp8pMfW3pJDcP2sjUehOYU4=;
 b=delaxm3yT/ZX8sSisS9/6Cp14b3kvt6wrCeUiBLPRgeMdiCBUTdXjS/SLJNzXLIcvF
 mEVEysB0JdxDlo75t3bn2VvB0Kp2McLcIMgV4CwkARQ+fmaaNUp5M1nH+AJXWNPlQuyC
 YpbObXHDT/nBXzPFJdcjaLYsZa3gK1ic616RogP37yOGCBKRLBrYiu47ZsO42Eh4P9x4
 bwk4vuXzu4+9U8LBRR4AmgO+rcyqL3J22v8gaqLIThk8FKK5RLvGMAS8NaY52AcdbjFI
 sHoCs1Nr/J2+hoDGwYchbk05HblvijBKNkv0TSSBbHcgJCpNPaSedeo2KZ7gUM1ifuBq
 elbQ==
X-Gm-Message-State: AJIora8NY7ReiYaJwrosfuV5dnxziu3QqibRX/p2E2Le2NHSKrz8h7e/
 jv7G6SYbFSA/8suPVLHOB67JYnoYQF4EWTI0h+E17d3Us8zZM5P9Ui6kFs1u4zodYZ/2VeXuVsT
 /fm0so8To0kdT5nN036npZ74VFZVp2isqXFmBKoGfdf70YLxHgWJUXwvxMRbiGw==
X-Google-Smtp-Source: AGRyM1vp5D7KtAIwbZuWBcV6WXvCFoP7Sbed2vVEKCoE284wiEj/Qi2clX5cWcAQ3mb99Pg3ce7swR0=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:ff27:d65:6bb8:b084])
 (user=pcc job=sendgmr) by 2002:a5b:18e:0:b0:66e:ca1c:bab0 with SMTP id
 r14-20020a5b018e000000b0066eca1cbab0mr6050295ybl.298.1657315274526; Fri, 08
 Jul 2022 14:21:14 -0700 (PDT)
Date: Fri,  8 Jul 2022 14:21:03 -0700
Message-Id: <20220708212106.325260-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
From: Peter Collingbourne <pcc@google.com>
To: kvmarm@lists.cs.columbia.edu
X-Mailman-Approved-At: Mon, 11 Jul 2022 05:42:55 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Will Deacon <will@kernel.org>, Evgenii Stepanov <eugenis@google.com>,
 Michael Roth <michael.roth@amd.com>, Chao Peng <chao.p.peng@linux.intel.com>,
 Peter Collingbourne <pcc@google.com>, linux-arm-kernel@lists.infradead.org
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

This patch series contains a proposed extension to pKVM that allows MTE
to be exposed to the protected guests. It is based on the base pKVM
series previously sent to the list [1] and later rebased to 5.19-rc3
and uploaded to [2].

This series takes precautions against host compromise of the guests
via direct access to their tag storage, by preventing the host from
accessing the tag storage via stage 2 page tables. The device tree
must describe the physical memory address of the tag storage, if any,
and the memory nodes must declare that the tag storage location is
described. Otherwise, the MTE feature is disabled in protected guests.

Now that we can easily do so, we also prevent the host from accessing
any unmapped reserved-memory regions without a driver, as the host
has no business accessing that memory.

A proposed extension to the devicetree specification is available at
[3], a patched version of QEMU that produces the required device tree
nodes is available at [4] and a patched version of the crosvm hypervisor
that enables MTE is available at [5].

v2:
- refcount the PTEs owned by NOBODY

[1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/
[2] https://android-kvm.googlesource.com/linux/ for-upstream/pkvm-base-v2
[3] https://github.com/pcc/devicetree-specification mte-alloc
[4] https://github.com/pcc/qemu mte-shared-alloc
[5] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324

Peter Collingbourne (3):
  KVM: arm64: add a hypercall for disowning pages
  KVM: arm64: disown unused reserved-memory regions
  KVM: arm64: allow MTE in protected VMs if the tag storage is known

 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/include/asm/kvm_host.h             |  6 ++
 arch/arm64/include/asm/kvm_pkvm.h             |  4 +-
 arch/arm64/kernel/image-vars.h                |  3 +
 arch/arm64/kvm/arm.c                          | 83 ++++++++++++++++++-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +-
 arch/arm64/kvm/mmu.c                          |  4 +-
 11 files changed, 123 insertions(+), 8 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
