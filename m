Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB47C4320A
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B9D460560
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3B9D460560
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D43A4B11C;
	Fri, 27 Aug 2021 06:16:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D-V6amwdT7gu; Fri, 27 Aug 2021 06:16:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E09E4B10F;
	Fri, 27 Aug 2021 06:16:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 634584B10B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sijgiC1DFaw4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 06:16:11 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49E4B4B10A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:11 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 jq13-20020ad45fcd000000b0036c273baa23so3443354qvb.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=jsA6xT98EeA80UGER1WEqhvGsAPxq/3pPd3JQ9gufNk=;
 b=VhFaBqIfTeTaY8WOw3nAg0JlzJztciYu4suzC598Ebz2q37OUD13vfp9lIwq5DIwyw
 t2wAB2K4+11hk+25HeExvkyRPequRrvFhjWJRyh1JdbiFa0vwD4hj3hd/PqOLHgui/P9
 YfWX7zFGKKu2ymeJI7D+6uyVNjR9Q1ctx4ZkLAHHHNITVKevtV5R9VMkYD6L5A/Z+L4C
 ZGMuUGyptLkmSaYfLQsfqiQCk7FI2cDGRWLqlN4QQEGyvdUX+LtphSsnwi/HOo9KEcel
 DYxqxTmSRwZnKtnJoQRVYbLs194cX3pj7jdEqAGWK+Rc5akusnV62oo28FJMS5/UkyRd
 r7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=jsA6xT98EeA80UGER1WEqhvGsAPxq/3pPd3JQ9gufNk=;
 b=T83c9QLW271Z9vztCveN+MI29hbRf59umDM+7eLjFHAED5BkMaSfBuLArcnSFEy93y
 4vg4tnCNxcI1iVG3GLUJZ0fXWIdhHA4gTffVkWD7hYHiXSbHycIZDcubA/nwC5AWyTyB
 0RNTmG8DV7Gr/XwZ0kDtbfY268FeUvZ26aiyh8nv4v38uTXbb0JSjI0nRv9os0PPU6Mh
 7Hrj9otmg84wCB98Nt74ydqAXJKfm2r9HTPMqSMNsohD3f9iQleiOkg964CnGIxt5+V7
 2CCfL67kOQ7oyUOLlq6yjKrgp8PlZHKlTIEMdeBnX18VRzMAZqeEEg18t0cMqLtUJY3b
 7KDQ==
X-Gm-Message-State: AOAM531bs5hHa8374yCWXYY+OFBMAbBpoo1hVzI0gAWY+bFDhW/Dy0Lk
 3W8NQUZ5Tf2NYBQkmeiYWnv8226CdG1qA23H2ZoCVJad0A1FIvJX8glrViJo0gzHe4DEHeGWcGx
 1ZW5vIq5KlCno+TlZgIK8Ig1I5ZWcvW4ukDq+HQlHwGsnB7kxcgJLM5sqE30WXa1AqWM=
X-Google-Smtp-Source: ABdhPJzvFP8+CJjGjT4Q/qSS+1OA0tDxp3n9hoCOklGx1Uk6TnaXfxtcDrpuAdqzcwZSqvV+uAeQtEL0Zg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:fbcf:: with SMTP id
 n15mr9011967qvp.49.1630059370831; 
 Fri, 27 Aug 2021 03:16:10 -0700 (PDT)
Date: Fri, 27 Aug 2021 11:16:01 +0100
Message-Id: <20210827101609.2808181-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 0/8] KVM: arm64: Fixed features for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Changes since v4 [1]:
- Calculating feature id register values takes into account features
  supported/enabled in KVM.
- Handle all AArch64 feature ID registers, with sanitized copies at EL2 if
  necessary, rather than trusting the host, even if the value is the same.
- Trap registers are set based on the exposed value of the feature id
  registers, rather than the masks to allow/restrict.
- Move code for settings trap registers for protected guests to EL2.
- Refactoring and fixes.
- Dropped Will's ack for "KVM: arm64: Trap access to pVM restricted features"
- Rebase on Marc's pkvm-fixed-features branch [2].

Changes since v3 [3]:
- Redid calculating restricted values of feature register fields, ensuring that
  the code distinguishes between unsigned and (potentially in the future)
  signed fields (Will)
- Refactoring and fixes (Drew, Will)
- More documentation and comments (Oliver, Will)
- Dropped patch "Restrict protected VM capabilities", since it should come with
  or after the user ABI series for pKVM (Will)
- Carried Will's acks

Changes since v2 [4]:
- Both trapping and setting of feature id registers are toggled by an allowed
  features bitmap of the feature id registers (Will)
- Documentation explaining the rationale behind allowed/blocked features (Drew)
- Restrict protected VM features by checking and restricting VM capabilities
- Misc small fixes and tidying up (mostly Will)
- Remove dependency on Will's protected VM user ABI series [5]
- Rebase on 5.14-rc2
- Carried Will's acks

Changes since v1 [6]:
- Restrict protected VM features based on an allowed features rather than
  rejected ones (Drew)
- Add more background describing protected KVM to the cover letter (Alex)

This patch series adds support for restricting CPU features for protected VMs
in KVM (pKVM) [7].

Various VM feature configurations are allowed in KVM/arm64, each requiring
specific handling logic to deal with traps, context-switching and potentially
emulation. Achieving feature parity in pKVM therefore requires either elevating
this logic to EL2 (and substantially increasing the TCB) or continuing to trust
the host handlers at EL1. Since neither of these options are especially
appealing, pKVM instead limits the CPU features exposed to a guest to a fixed
configuration based on the underlying hardware and which can mostly be provided
straightforwardly by EL2.

This series approaches that by restricting CPU features exposed to protected
guests. Features advertised through feature registers are limited, which pKVM
enforces by trapping register accesses and instructions associated with these
features.

This series is based on 5.14-rc2. You can find the applied series here [8].

Cheers,
/fuad

[1] https://lore.kernel.org/kvmarm/20210817081134.2918285-1-tabba@google.com/

[2] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pkvm-fixed-features

[3] https://lore.kernel.org/kvmarm/20210719160346.609914-1-tabba@google.com/

[4] https://lore.kernel.org/kvmarm/20210615133950.693489-1-tabba@google.com/

[5] https://lore.kernel.org/kvmarm/20210603183347.1695-1-will@kernel.org/

[6] https://lore.kernel.org/kvmarm/20210608141141.997398-1-tabba@google.com/

[7] Once complete, protected KVM adds the ability to create protected VMs.
These protected VMs are protected from the host Linux kernel (and from other
VMs), where the host does not have access to guest memory,even if compromised.
Normal (nVHE) guests can still be created and run in parallel with protected
VMs. Their functionality should not be affected.

For protected VMs, the host should not even have access to a protected guest's
state or anything that would enable it to manipulate it (e.g., vcpu register
context and el2 system registers); only hyp would have that access. If the host
could access that state, then it might be able to get around the protection
provided.  Therefore, anything that is sensitive and that would require such
access needs to happen at hyp, hence the code in nvhe running only at hyp.

For more details about pKVM, please refer to Will's talk at KVM Forum 2020:
https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/slides/kvmforum-2020-edited.pdf
https://www.youtube.com/watch?v=edqJSzsDRxk

[8] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/el2_fixed_feature_v5

Fuad Tabba (8):
  KVM: arm64: Pass struct kvm to per-EC handlers
  KVM: arm64: Add missing field descriptor for MDCR_EL2
  KVM: arm64: Simplify masking out MTE in feature id reg
  KVM: arm64: Add trap handlers for protected VMs
  KVM: arm64: Initialize trap registers for protected VMs
  KVM: arm64: Move sanitized copies of CPU features
  KVM: arm64: Trap access to pVM restricted features
  KVM: arm64: Handle protected guests at 32 bits

 arch/arm64/include/asm/kvm_arm.h           |   1 +
 arch/arm64/include/asm/kvm_asm.h           |   1 +
 arch/arm64/include/asm/kvm_fixed_config.h  | 164 +++++++
 arch/arm64/include/asm/kvm_host.h          |   2 +
 arch/arm64/include/asm/kvm_hyp.h           |   5 +
 arch/arm64/kvm/arm.c                       |  13 +
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  16 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h     |  14 +
 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h |  29 ++
 arch/arm64/kvm/hyp/nvhe/Makefile           |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         |  10 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c      |   6 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c             | 186 ++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c           |  59 ++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c         | 525 +++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c            |   2 +-
 arch/arm64/kvm/sys_regs.c                  |  10 +-
 17 files changed, 1020 insertions(+), 25 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_fixed_config.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/pkvm.h
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/sys_regs.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/pkvm.c
 create mode 100644 arch/arm64/kvm/hyp/nvhe/sys_regs.c


base-commit: cc3ef75c796e58acec8f64a9acf47fc18645f194
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
