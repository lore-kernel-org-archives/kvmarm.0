Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1621FC433FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 Apr 2022 18:48:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1C1049F46;
	Wed, 27 Apr 2022 14:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LGu9HdFGbANW; Wed, 27 Apr 2022 14:48:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 817384B1BF;
	Wed, 27 Apr 2022 14:48:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52AA249F46
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QbapU4rIVd7s for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Apr 2022 14:48:18 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E76814089E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 14:48:17 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 mm2-20020a17090b358200b001bf529127dfso1460999pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Apr 2022 11:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=W31J+NXrVsC6+MO2Lwj0kB41xQsk0gH6sl8VC4G0Hhw=;
 b=FESEaVxAwhhRxp009/PbfkU87OUhtLSXa32rvs7Sy1rWU0fM9GFCw5A3ulYIQlSwgF
 hsymoNj32M8/ZLy0y54HR9w9x8Z8oYHlYOc0TmBwHpeLJMLwgeHs3TrV4FNvGbDFuvvt
 XyvHEn41GBYC5Du+JHk4EFcMGoFQiDHuJOMoVzdMKfOgGPEzRvEsue/01R49rkbM/9b2
 RsqFZzJB4cMmtGJr2G0U7BwT80PFoVDwDn1/xsPOmbDYYxzUItfAlrxrmCwTvp2kWy6w
 HdDHBWxWkNAJHhmxBAAC/mV4UanmAA5bkIU9Bz5iiqMiMDyFkUFAYoE7dxNKPPvZSk48
 S0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=W31J+NXrVsC6+MO2Lwj0kB41xQsk0gH6sl8VC4G0Hhw=;
 b=3ysMrJxy3AUIt6sxNqxRAZrxU6VOyABMAmc3Mck8/OIk2I0AAi5RtYHVQSOuE086Y+
 vYbIDSrE85+diJq+XCikNMUItb8JcX0DcWaoqSxphG6q8ecm1p1TOTZsZw2SFubnCyVF
 2Q6js2phKhsVjGq2cF9FSrSUuFv5pUwMoUR5yi5sit3Qdf90vHXPPcn3TnSzVnltqpzH
 +5oHBFTrjQKJ3JQ6e+2zq0DyV4Hibn+ZuxqDpMcCmij4olsrFfXJYFis+/0YQvW9i/vp
 C8RiIQaRxsMPi1Jm271uix2r4gixVJa7q5IpUbRsGzd79MT0yyyYifkQdgC9n5wmyzTg
 UbGA==
X-Gm-Message-State: AOAM533cdSY6yQP3bMFl2W/L3H7YCoTY+rs+H4Pp1yknEJrm4XtfnOzs
 e6SYA/pYazXGZu0k0+K5vUoyytWUkpkzJg==
X-Google-Smtp-Source: ABdhPJwPe8FNq1K7NbxdZ9TP/wTRtiQjsYQUJ4+BrlzwseokJPagTVD2W3Cq84m7PQ7pNxDPRSa8a14AiQHXxg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:2742:0:b0:505:89a5:2023 with SMTP id
 n63-20020a622742000000b0050589a52023mr31612943pfn.18.1651085296858; Wed, 27
 Apr 2022 11:48:16 -0700 (PDT)
Date: Wed, 27 Apr 2022 11:48:10 -0700
Message-Id: <20220427184814.2204513-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v2 0/4] KVM: arm64: vgic: Misc ITS fixes
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
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

The purpose of this series is to help debugging failed ITS saves and
restores.  Failures can be due to misconfiguration on the guest side:
tables with bogus base addresses, or the guest overwriting L1 indirect
tables. KVM can't do much in these cases, but one thing it can do to help
is raising errors as soon as possible. Here are a couple of cases where
KVM could do more:

- A command that adds an entry into an ITS table that is not in guest
  memory should fail, as any command should be treated as if it was
  actually saving entries in guest memory (KVM doesn't until saving).  KVM
  does this check for collections and devices (using vgic_its_check_id),
  but it doesn't for the ITT (Interrupt Translation Table). Commit #1 adds
  the missing check.

- Restoring the ITS tables does some checks for corrupted tables, but not
  as many as in a save.  For example, a device ID overflowing the table
  will be detected on save but not on restore.  The consequence is that
  restoring a corrupted table won't be detected until the next save;
  including the ITS not working as expected after the restore. As an
  example, if the guest sets tables overlapping each other, this would most
  likely result in some corrupted table; and this is what we would see from
  the host point of view:

	guest sets bogus baser addresses
	save ioctl
	restore ioctl
	save ioctl (fails)

  This failed save could happen many days after the first operation, so it
  would be hard to track down. Commit #2 adds some checks into restore:
  like checking that the ITE entries are not repeated.

- Restoring a corrupted collection entry is being ignored. Commit #3 fixes
  this while trying to organize the code so to make the bug more obvious
  next time.

Finally, failed restores should clean up all intermediate state. Commit #4
takes care of cleaning up everything created until the restore was deemed a
failure.

v1: https://lore.kernel.org/kvmarm/20220425185534.57011-1-ricarkol@google.com/
v1 -> v2:
- moved alloc_collection comment to its respective commit. [marc]
- refactored check_ite to reuse some code from check_id. [marc]
- rewrote all commit messages. [marc]

Tested with kvm-unit-tests ITS tests.

Ricardo Koller (4):
  KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
  KVM: arm64: vgic: Add more checks when restoring ITS tables
  KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
  KVM: arm64: vgic: Undo work in failed ITS restores

 arch/arm64/kvm/vgic/vgic-its.c | 112 +++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 25 deletions(-)

-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
