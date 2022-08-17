Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C572C25B08
	for <kvmarm@archiver.kernel.org>; Wed, 17 Aug 2022 21:48:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 002F34D235;
	Wed, 17 Aug 2022 17:48:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2iNzExoj0srm; Wed, 17 Aug 2022 17:48:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDD3B4D237;
	Wed, 17 Aug 2022 17:48:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D6CE4D232
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 17:48:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fUqUIux-xqVx for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Aug 2022 17:48:39 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3512C4D231
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Aug 2022 17:48:39 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660772917;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=cDVlBOelWFV15LvLWa+pCIh5Az2QchuTMm2O7H0MfZk=;
 b=puD8I3PkQRNayksEy0wOfU5b0YzxoKZaMjrXlFl+3KOT9ZugR1UJ41zWBQ4rIUp7WgJmYP
 zer8g0/Qivf8EkqpyOrgj/kSI9u4kcW+RqBS5h0Sw26FxOJKXuml5SvL9BIxtorjjBp7Ck
 3/FsLgpUpC7mZFkmblRFxfhBznj563c=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/6] KVM: arm64: Treat 32bit ID registers as RAZ/WI on
 64bit-only system
Date: Wed, 17 Aug 2022 21:48:12 +0000
Message-Id: <20220817214818.3243383-1-oliver.upton@linux.dev>
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

For reasons unknown, the Arm architecture defines the 64-bit views of
the 32-bit ID registers as UNKNOWN [1]. This combines poorly with the
fact that KVM unconditionally exposes these registers to userspace,
which could throw a wrench in migration between 64-bit only systems.

This series reworks KVM's definition of these registers to RAZ/WI with
the goal of providing consistent register values across 64-bit machines.

Patches 1-2 clean up some of the ID register accessors, taking advantage
of the fact that the generic ones already know how to handle RAZ
registers.

Patches 3-4 wire in a new visibility bit to indicate a register ignores
writes from userspace.

Patch 5 moves all exposed 32-bit ID registers to have RAZ/WI behavior on
64-bit only systems. Note that hidden 32-bit registers continue to have
RAZ behavior and carry the additional requirement of invariance.

Lastly, patch 6 tests that userspace and guest indeed see the registers
as RAZ/WI.

Applies to 6.0-rc1 + the mismatched system fixes [2] picked up earlier
today. Tested on the fast model, both with mismatched AArch32 support
and no AArch32 support whatoever.

[1]: DDI0487H.a Table D12-2 'Instruction encodings for non-Debug System Register accesses'
[2]: https://lore.kernel.org/kvmarm/20220816192554.1455559-1-oliver.upton@linux.dev/

Oliver Upton (6):
  KVM: arm64: Use visibility hook to treat ID regs as RAZ
  KVM: arm64: Remove internal accessor helpers for id regs
  KVM: arm64: Spin off helper for calling visibility hook
  KVM: arm64: Add a visibility bit to ignore user writes
  KVM: arm64: Treat 32bit ID registers as RAZ/WI on 64bit-only system
  KVM: selftests: Add test for RAZ/WI AArch32 ID registers

 arch/arm64/kvm/sys_regs.c                     | 137 +++++++++---------
 arch/arm64/kvm/sys_regs.h                     |  24 ++-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/aarch64_only_id_regs.c        | 135 +++++++++++++++++
 5 files changed, 222 insertions(+), 76 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/aarch64_only_id_regs.c

-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
