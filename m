Return-Path: <SRS0=gNwE=PR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E5CC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BA3261107
	for <kvmarm@archiver.kernel.org>; Fri, 29 Oct 2021 00:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3BA3261107
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD7074B15B;
	Thu, 28 Oct 2021 20:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tOfYUe-4Orlp; Thu, 28 Oct 2021 20:32:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A48174B162;
	Thu, 28 Oct 2021 20:32:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46A324B160
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wl-qvV3i+J1U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 20:32:42 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4099407E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 20:32:41 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 m78-20020a252651000000b005c1f44d3c7bso4056579ybm.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 17:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=vw5IElLY3kB8cY1L2Z+7D5wanBys4JUHwDM1VncqKoI=;
 b=PCh1M803lS/Kd65Q8t89i5Nu8M1/0FfLF3gOxRVpd9H5ySYjaVIlKhrcBmAAZHAvHL
 v1TsKipc2dhUgHXNlPnV6jTdmV8k9F46xup3BxToefljw/OFIXB7jePY2Cm5XrOxHzi1
 s8M6HeWExB082mLRIgrKgNPhssfGoXV53P/km8PJih9ZFR6rbrcbCAS6w32AIVYPYJgJ
 jkreVHIwHpBpbmFJP36xIPd7JbRl7aE/2xUzNuumQ+Q8H5dY5ooxCypcZIgwXw/K8JHp
 PkbLJ/g8MvaXOZdsUClyOyvB5EZXIMWrkgMJezJ2FuSquxP6Vg4Umm2GNRVIu2mPTA1R
 K2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=vw5IElLY3kB8cY1L2Z+7D5wanBys4JUHwDM1VncqKoI=;
 b=P5Zh/JkC5eMRLRglgt48QDP2lrjHkZSS/mY66XaX/7mNVdJLPIAaID5IEz6xu9ItgB
 8ly58h4pOiIgqr7qVnYTp+E+d9KZF3iKdT1JTRZkgLRtjisOPdT34DrZGsmkxYWnF5W0
 duJa7IGZZjm+4rgDaN1A36QkDvOnSwe6hR3Pu6AXpJzALpZqc91K90SgOccsYrMfb4AR
 jf0mc6qf7TWTtFP7jXAAImmVb1ZO7ZE18VwyZZiG0OuYr+JBWxbHN3V0no/FOTlnn4Xi
 Ui6+JGw2T5f5OLfrgWgsBMUyDyPBd5OFA847m4Rhxp8/dKWY2rXvEZP68/3kwqoCIcsa
 zDdw==
X-Gm-Message-State: AOAM530ghXVHWP9v5FKicQx5nGdtcZQv7GmqM47ZQr88nm5ryKPmoens
 DzZs6Q3yZrN70fSVSmQMRwSXxgJiFf0kyjJqv86OVXhRzXmZz+gwzOg3BRrAy8TYpvKeHTgu2Wk
 eB7hz3J5oxqVJ/b6T0GWRREJyGw08XL+A33I6ViD6wzC+eM2BXlDWEd+rrYCKybN9PthYww==
X-Google-Smtp-Source: ABdhPJxAz30X4IhyMRe9T1OY/gwd77ukFMDfy0+meau5n4bTd35B4sOyPkxXfMVZntXji4d0V4ISRBJUilI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:aac8:: with SMTP id
 t66mr8949989ybi.238.1635467561151; 
 Thu, 28 Oct 2021 17:32:41 -0700 (PDT)
Date: Fri, 29 Oct 2021 00:31:59 +0000
Message-Id: <20211029003202.158161-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 0/3] KVM: arm64: Fixes for the exposed debug architecture
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

I had a conversation with Marc about some of the quirks around the debug
architecture on KVM and incorporated some of his suggestions into a
series here. Of course, any glaring mistakes/choices made in this series
is on me :-)

Anyhow:

KVM's implementation of the debug architecture is a bit deviant as it
stands. For one, KVM handles the OS Lock as RAZ/WI, even though the
architecture mandates it. Additionally, KVM advertises more than it can
actually support: FEAT_DoubleLock is exposed as implemented to the
guest, though OSDLR_EL1 is handled as RAZ/WI too.

Only v8.2+ revisions of the debug architecture permit implementations to
omit DoubleLock. Fortunately, the delta between v8.0 and v8.2 is
entirely focused on external debug, a feature that KVM does not support
and likely never will. So, there isn't much of a hurdle to bump KVM's
reported DebugVer to v8.2, thereby allowing KVM to omit DoubleLock from
ID_AA64DFR0_EL1. Of the remaining bits of external debug visible to the
guest, the only additional thing to address is the OSLAR_EL1 issue by
simply context switching the host/guest values.

Patch 1 changes the way KVM backs OSLSR_EL1 in the sys reg table.
Instead of returning a static value from its handler, stash a copy of it
in kvm_cpu_context and return that when read.

Patch 2 makes the material change of allowing a guest to actually toggle
the OSLK bit by redirecting writes to OSLAR_EL1.OSLK to OSLSR_EL1.OSLK.
When saving context, simply stash the value of OSLSR_EL1. On resume,
apply OSLSR_EL1.OSLK to OSLAR_EL1.OSLK.

Finally, Patch 3 raises the KVM debug architecture to v8.2 and exposes
FEAT_DoubleLock as NI to the guest. With the changes to OSLAR_EL1 in
this series, KVM now does what it says on the tin.

This series applies cleanly to 5.15-rc4, and was (lightly) tested by
booting 5.15-rc4 as a kvmtool guest on this kernel.

Oliver Upton (3):
  KVM: arm64: Stash OSLSR_EL1 in the cpu context
  KVM: arm64: Allow the guest to change the OS Lock status
  KVM: arm64: Raise KVM's reported debug architecture to v8.2

 arch/arm64/include/asm/kvm_host.h          |  1 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  5 +++
 arch/arm64/kvm/sys_regs.c                  | 42 ++++++++++++++++------
 3 files changed, 37 insertions(+), 11 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
