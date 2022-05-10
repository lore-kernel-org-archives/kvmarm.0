Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEFFC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 10 May 2022 00:16:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CD334B105;
	Mon,  9 May 2022 20:16:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l-5w60DgfqaX; Mon,  9 May 2022 20:16:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1045149F24;
	Mon,  9 May 2022 20:16:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA544B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g76bEHhT8iby for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 20:16:37 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71F854B08B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 20:16:37 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 r16-20020a17090b051000b001db302efed7so6866914pjz.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 17:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=6oKSjCnrnaDJ0MjaoXbtw04iHzdq0yCq1lYPhCeQzvw=;
 b=BMg0uyyPoG1R2H7dLqoVSs50fr5+oYtt/E+68BORI5NJcBRDJVFWvQ3XVgro9rnlrn
 Kt97Wd64Hi/KrqXr/jXiBO9X2wkOW7QlNHSdz0CRoCs1STab9+grOz4Jh3vkrviWxe+Z
 3m1FqSTcIiEXs2I/kbzFnnY/g188Bf3oGlhunltmQ95crEA+A2LuzG+8ue7SKBcWHdKh
 3fpqwlNuh8y9SZvznMLH9iQkv4NQhFo551q8cHvUfEBewsnCp63qJzvN0OCM0XeX89uy
 rVWrMy8S16izRtzCzZWNtpXX7L0fgq2iIDUSYMVqqQzVVih5qc9yCLIVl3mo2UnHS9pA
 +cJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=6oKSjCnrnaDJ0MjaoXbtw04iHzdq0yCq1lYPhCeQzvw=;
 b=HGuCUsXtrKdIqiE+S8EBe3NBGPhgSGK2IjZMfKcwiawA35lSvDuAop8k9OBDrDX9er
 4cdy3R9NVOIjXWHvZZ7PhRoF0TJea2MBm6mkLBso8iXEWleu93uC4TjnxKEalNfOg1Ca
 ItX5EY2Bf5vM2abyy3952BAVvzX5+KCGcMC1YnV7woviBF3xLWlFCRA+ihEUg/YWStwm
 xwA5yJI9dxtG6Edx8TAmfUnwIBQF92Ai6BIsRFvvJmmAN5w58/dF7bHPrOM5Cs9Re7Gl
 7lxZwtiPoXV9Ov5Jrhi7KEN+70ftNHv88ba/WETf0W6kp3oZ7Kl3syV/w3sdSmDCNA2n
 1c8w==
X-Gm-Message-State: AOAM530ajNlD5nBlHr8NGybXsmFSd2W+I1OduNG3zYpnJvKNg4sWNgUO
 GDBwpIggvfTPZdYUCan7EQ2KLbFAa7JbNg==
X-Google-Smtp-Source: ABdhPJwC/rHmJWgon7TLj+TannUN3z+nd6cTOgZdagu7p9mijBEZ7uf+GPz7Ci2qlDQpatMnYPdV1Cdn4wo9Mw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:ea0f:b0:15e:afcf:d1a4 with SMTP
 id s15-20020a170902ea0f00b0015eafcfd1a4mr18401436plg.96.1652141796314; Mon,
 09 May 2022 17:16:36 -0700 (PDT)
Date: Mon,  9 May 2022 17:16:29 -0700
Message-Id: <20220510001633.552496-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v3 0/4] KVM: arm64: vgic: Misc ITS fixes
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

v2: https://lore.kernel.org/kvmarm/20220427184814.2204513-1-ricarkol@google.com/
v2 -> v3:
- collect RBs from Eric (Thanks!)
- reorder check in vgic_its_cmd_handle_mapi (commit 1) [Eric]
- removed some checks in vgic_its_restore_ite and vgic_its_restore_dte. [Eric]
- not skipping dummy end elements when restoring collection tables. [Eric]

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

 arch/arm64/kvm/vgic/vgic-its.c | 96 +++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 18 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
