From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] arm64: Kill ESR_LNX_EXEC
Date: Tue, 31 May 2016 12:33:00 +0100
Message-ID: <1464694383-31700-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04B24410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2016 07:29:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Os8w26QZi-ol for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 May 2016 07:29:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F7B407A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 May 2016 07:29:31 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, shijie.huang@arm.com, dave.martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Currently we (ab)use a reserved bit in ESR_ELx for our own purposes as
ESR_LNX_EXEC, which isn't ideal, especially as we're inconsistent with our
mnemonic usage. This series removes ESR_LNX_EXEC entirely, avoiding (ab)use of
reserved ESR_ELx bits, and makes things a little more consistent.

I've extracted this from my entry-deasm branch [1], and rebased to v4.7-rc1.
I've split the KVM changes as the KVM code is undergoing rapid change these
days, and it should be possible to take those as a subsequent cleanup rather
than forcing a painful merging process.

Thanks,
Mark.

[1] https://git.kernel.org/cgit/linux/kernel/git/mark/linux.git/log/?h=arm64/entry-deasm


Mark Rutland (3):
  arm64: add macro to extract ESR_ELx.EC
  arm64/kvm: use ESR_ELx_EC to extract EC
  arm64: kill ESR_LNX_EXEC

 arch/arm64/include/asm/esr.h         |  1 +
 arch/arm64/include/asm/kvm_emulate.h |  2 +-
 arch/arm64/kernel/entry.S            |  2 +-
 arch/arm64/kernel/traps.c            |  2 +-
 arch/arm64/kvm/handle_exit.c         |  4 ++--
 arch/arm64/kvm/hyp/switch.c          |  2 +-
 arch/arm64/mm/fault.c                | 15 +++++++++------
 7 files changed, 16 insertions(+), 12 deletions(-)

-- 
1.9.1
