Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC73C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 16:57:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B35A94B2F1;
	Wed, 25 May 2022 12:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7bwVbLNIDxS3; Wed, 25 May 2022 12:57:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B82814B2F6;
	Wed, 25 May 2022 12:57:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66D5C4B2EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:57:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jiftud2FJGpA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 12:57:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2E84B26A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:57:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5146E1424;
 Wed, 25 May 2022 09:57:02 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ECD43F66F;
 Wed, 25 May 2022 09:57:01 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 andre.przywara@arm.com
Subject: [PATCH kvmtool 0/2] Fixes for arm64 and MIPS
Date: Wed, 25 May 2022 17:57:02 +0100
Message-Id: <20220525165704.186754-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
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

The first fix is for arm64, where the VCPUs weren't pinned correctly with
--vcpu-affinity when creating an aarch32 guest. Hopefully the patch is
straightforward.

The last patch is a fix for MIPS not compiling for a year now, ever since
hw/serial.c was changed to use a different address for arm/arm64 in commit
45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher addresses"). Did
some digging and it turns out that the serial never worked on MIPS since
RAM starts at 0 for the architecture. So I just removed hw/serial.o from the
list of compilation objects, which revelead that kvm-ipc assumes that all
architectures use the 16550/8250 UART. Added a stub for
serial8250__inject_sysreg() to MIPS to fix that.

Note that as far as I can tell powerpc is in the same situation as MIPS:
RAM starts at 0 and ends at 64TB (that's terabytes), so the UART was never
working. It looks like powerpc uses hypercalls to emulate a console with
the name "hvterm" (devicetree node created in kvm.c and emulation
implemented in spapr_hvcons.{c,h}). I don't know enough about the powerpc
architecture and I don't have a machine to test it on, and since powerpc
still compiles, I opted not to do any changes to the architecture.

Tested by cross-compiling both patches for all architectures (arm, arm64, mips,
powerpc, riscv, x86), running a kernel on x86, and running kvm-unit-tests for
both arm and arm64 on a rockpro64 (has two PMUs).

Alexandru Elisei (2):
  arm64: Honor --vcpu-affinity for aarch32 guests
  mips: Do not emulate a serial device

 Makefile              |  7 +++++--
 arm/aarch64/kvm-cpu.c | 22 ++++++++++++----------
 mips/kvm.c            |  5 +++++
 3 files changed, 22 insertions(+), 12 deletions(-)

-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
