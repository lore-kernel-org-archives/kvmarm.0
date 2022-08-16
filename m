Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CD6C32772
	for <kvmarm@archiver.kernel.org>; Tue, 16 Aug 2022 19:26:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBC004D40D;
	Tue, 16 Aug 2022 15:26:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NGVh-Fb2uaGl; Tue, 16 Aug 2022 15:26:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F9DC4D401;
	Tue, 16 Aug 2022 15:26:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2118B4D3F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2022 15:26:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OzJGQK7m8bL0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2022 15:26:08 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CA2BB4D3F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2022 15:26:08 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660677967;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=Qyb4P3aeu3kcSplqFQPf6DeNYTbLexPY2NVEpp1YSig=;
 b=LCbCsDpds/zG+Va7xHgoChxHXHa8DjiiGRazo1QLBulYW9xQfLToPoGcarurdlrzvJgTpt
 46OVyxAzuFiZBknosWlujn1sSL+OHdDKo3a1+m4GN5y54cxK5BSYjhHdakflruS7SQHXU+
 +VPuithtmqBASaYDnrJkRq+e6+PwX28=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on asymmetric
 systems
Date: Tue, 16 Aug 2022 19:25:52 +0000
Message-Id: <20220816192554.1455559-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, maz@kernel.org, will@kernel.org,
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

Small series to fix a couple issues around when 64bit-only behavior is
applied. As KVM is more restrictive than the kernel in terms of 32bit
support (no asymmetry), we really needed our own predicate when the
meaning of system_supports_32bit_el0() changed in commit 2122a833316f
("arm64: Allow mismatched 32-bit EL0 support").

Lightly tested as I do not have any asymmetric systems on hand at the
moment. Attention on patch 2 would be appreciated as it affects ABI.

Applies to 6.0-rc1.

v1 -> v2:
 - Fix a silly logic inversion in vcpu_mode_is_bad_32bit()
 - Rebase to 6.0-rc1

Oliver Upton (2):
  KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
  KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 4 files changed, 8 insertions(+), 5 deletions(-)


base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
