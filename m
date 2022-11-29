Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C904FC4167B
	for <kvmarm@archiver.kernel.org>; Tue, 29 Nov 2022 19:19:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A69A43479;
	Tue, 29 Nov 2022 14:19:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oylIUbJvlEFB; Tue, 29 Nov 2022 14:19:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BF7B40DAE;
	Tue, 29 Nov 2022 14:19:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A749740DAE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 14:19:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xQRqjHhl1tww for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2022 14:19:55 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 766EF40399
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2022 14:19:55 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1669749594;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=m0zZd4zUCb269/4WV/qmecpcPiXCIRgs1aacjO8LrGw=;
 b=pTlOrQHeV71gskFasm8wtT0s3vuYrWAs+URI7fzmgoko+UIiq4S4zJWYjZfDakZdKkZElj
 yyw5IKaB9OxuLLZktZ7xNwOu3DrtQdoo8xaftF8FXMCt9KrdFvc1Rj0BGTzMsSUDQRLUvn
 A/6zW4QHCMlhCcGwKnVVDL/0DAM5k6U=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 0/4] KVM: arm64: Parallel access faults
Date: Tue, 29 Nov 2022 19:19:42 +0000
Message-Id: <20221129191946.1735662-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
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

When I implemented the parallel faults series I was mostly focused on
improving the performance of 8.1+ implementations which bring us
FEAT_HAFDBS. In so doing, I failed to put access faults on the read side
of the MMU lock.

Anyhow, this small series adds support for handling access faults in
parallel, piling on top of the infrastructure from the first parallel
faults series. As most large systems I'm aware of are 8.1+ anyway, I
don't expect this series to provide significant uplift beyond some
oddball machines Marc has lying around. Don't get me wrong, I'd love to
have a D05 to play with too...

Patches 1-3 are the significant portion of the series, and patch 4 was
used to test on an Ampere Altra system by guarding VTCR_EL2.HA with the
kernel's Kconfig option for FEAT_HAFDBS. I've included it as I find it
helpful for testing on newer hardware. Having said that, I won't throw a
fit if it gets dropped either.

Applies to kvmarm/next due to the dependency on the larger parallel
faults series. Tested on Ampere Altra w/ VTCR_EL2.HA=0 as well as a
Raspberry Pi 4.

Oliver Upton (4):
  KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
  KVM: arm64: Don't serialize if the access flag isn't set
  KVM: arm64: Handle access faults behind the read lock
  KVM: arm64: Condition HW AF updates on config option

 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 12 +++++++++---
 arch/arm64/kvm/mmu.c                 | 14 ++++++--------
 3 files changed, 20 insertions(+), 11 deletions(-)


base-commit: 456ce3545dd06700df7fe82173a06b369288bcef
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
