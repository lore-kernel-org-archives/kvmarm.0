Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29FDFC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 18:52:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DA440EB6;
	Fri,  2 Dec 2022 13:52:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZtxVRWLTa86P; Fri,  2 Dec 2022 13:52:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 764BE4B125;
	Fri,  2 Dec 2022 13:52:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42D344A0D8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:52:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bnutGF2qV1Qu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Dec 2022 13:52:12 -0500 (EST)
Received: from out-153.mta0.migadu.com (out-153.mta0.migadu.com
 [91.218.175.153])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C87C040EB6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Dec 2022 13:52:12 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670007131;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=MpKufAjAF/g+30wBdMSCH1h9pcp+y/qwWl4scHSVwd4=;
 b=wcSk4Oflw5w66Zb3y27I3DVuLOMQIEX76IgGexKJezpSQlE5vmVXPET/3ip7LhrWnDFOd+
 FJ0GAe3PLG97aPbXwdKnt6bIMgiiNw5tjqCGKWTKKg09t/29Ba6u4EEr5oajOsQPc0BxHS
 7T/8dWxxJcOIM1fPgY3A8AXwuBTWajI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 0/6] KVM: arm64: Parallel access faults
Date: Fri,  2 Dec 2022 18:51:50 +0000
Message-Id: <20221202185156.696189-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

When I implemented the parallel faults series I was mostly focused on
improving the performance of 8.1+ implementations which bring us
FEAT_HAFDBS. In so doing, I failed to put access faults on the read side
of the MMU lock.

Anyhow, this small series adds support for handling access faults in
parallel, piling on top of the infrastructure from the first parallel
faults series.

Patch 1 is a nit I had when working on this series.

Patches 2-4 improve the retry logic to avoid unnecessarily serializing
and/or invalidating when an attr walker has no effect on the page
tables due to a race.

I added a flag to indicate whether or not a table walk takes place
within a fault handler to decide whether or not an early return is
necessary for EAGAIN. We could probably pile even more onto this in the
future with lock contention and need_resched() detection.

Patch 5 rolls over access faults to the read lock.

Finally, patch 6 guards KVM's use of VTCR_EL2.HA with the corresponding
kernel config option for FEAT_HAFDBS. FWIW, it is rather useful for
testing access faults on systems that implement FEAT_HAFDBS.

Applies to kvmarm/next. Tested on Ampere Altra w/ VTCR_EL2.HA=0 and
lockdep enabled.

v1 -> v2:
 - Don't serialize if attr walker fails due to an invalid PTE (Ricardo)
 - Rejig the error handling path in the table walker to suppress EAGAIN
   in non-fault handling paths

v1: https://lore.kernel.org/kvmarm/20221129191946.1735662-1-oliver.upton@linux.dev

Oliver Upton (6):
  KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
  KVM: arm64: Ignore EAGAIN for walks outside of a fault
  KVM: arm64: Return EAGAIN for invalid PTE in attr walker
  KVM: arm64: Don't serialize if the access flag isn't set
  KVM: arm64: Handle access faults behind the read lock
  KVM: arm64: Condition HW AF updates on config option

 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         | 43 ++++++++++++++++++++++++----
 arch/arm64/kvm/mmu.c                 | 18 ++++++------
 3 files changed, 54 insertions(+), 15 deletions(-)


base-commit: edf3e6d30db78cc37bb57944b2255225aa73bbe8
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
