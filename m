Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E374DC19F2A
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 17:02:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FE0B4E85C;
	Thu, 11 Aug 2022 13:02:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BQXSL7VMhCAw; Thu, 11 Aug 2022 13:02:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B76F4E85B;
	Thu, 11 Aug 2022 13:02:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8C8A4E858
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 13:02:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T3maspaJcKJa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 13:02:34 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B708D4E856
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 13:02:34 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660237353;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=aRu2Qz6xb8tRmhzinXW+uqzNL8wj7Il9t5HyZbqL6Tg=;
 b=SNu3vi3owseg596wltVqJROBlTin96X5tvt0yK/GkSaYWcOt6/lp6NMQ45Ni63ZoaGOi4x
 CMavQI/m2OuZPnzo5X14fxUNJG9AnbeV4LHHRWBrrfQcaoVsdQ0t2C8TbE+1pTFW4mqtgF
 3cT0+yIXdS5WBRGSAxdpM1Tu7rmW2MI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/2] KVM: arm64: Uphold 64bit-only behavior on asymmetric
 systems
Date: Thu, 11 Aug 2022 17:02:19 +0000
Message-Id: <20220811170221.3771048-1-oliver.upton@linux.dev>
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

Oliver Upton (2):
  KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
  KVM: arm64: Reject 32bit user PSTATE on asymmetric systems

 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/guest.c            | 2 +-
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 4 files changed, 8 insertions(+), 5 deletions(-)


base-commit: 21f9c8a13bb2a0c24d9c6b86bc0896542a28c197
-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
