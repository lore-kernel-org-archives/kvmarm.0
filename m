Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35898C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 15:28:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A6AC3238A0
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 15:28:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6AC3238A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D2E4B1BF;
	Fri, 15 Jan 2021 10:28:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mCMfYST5ymOa; Fri, 15 Jan 2021 10:28:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 962124B1B2;
	Fri, 15 Jan 2021 10:28:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBBD44B1B2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 10:28:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zz614UEHZ7k9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 10:28:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 920AA4B1AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 10:28:21 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3CA9D6E;
 Fri, 15 Jan 2021 07:28:20 -0800 (PST)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD3513F70D;
 Fri, 15 Jan 2021 07:28:17 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v7 0/3] MTE support for KVM guest
Date: Fri, 15 Jan 2021 15:28:08 +0000
Message-Id: <20210115152811.8398-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Steven Price <steven.price@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

After chasing down a bug[1] with MTE assisted KASAN and KVM, I've now
been able to rebase on v5.11-rc1 and test the combination of
KVM-with-MTE and KASAN.

For anyone new to this series, or simply pretending 2020 didn't happen,
this series adds support for Arm's Memory Tagging Extension (MTE) to KVM,
allowing KVM guests to make use of it. The first patch adds definitions
for the new registers and saves/restores them as necessary. The second
adds a new VM feature which allows the guest access to MTE.

The third patch is new and RFC for now. It adds a new ioctl allowing a
VMM to easily read/write the tags in the guest's memory even if the
memory isn't mapped with PROT_MTE in userspace. I'd particularly welcome
feedback on this new ABI.

Changes since v6[2]:
 * Moved the save/restore of RGSR_EL1, GCR_EL1 and TFSRE0_EL into asm
 * Correctly set TCO when injecting an exception to an MTE-enabled guest
 * Rebased on v5.11-rc1
 * RFC patch for new MTE tag copy ioctl

[1] https://lore.kernel.org/r/20210108161254.53674-1-steven.price@arm.com
[2] https://lore.kernel.org/r/20201127152113.13099-1-steven.price@arm.com

Steven Price (3):
  arm64: kvm: Save/restore MTE registers
  arm64: kvm: Introduce MTE VCPU feature
  KVM: arm64: ioctl to fetch/store tags in a guest

 arch/arm64/include/asm/kvm_emulate.h       |  3 +
 arch/arm64/include/asm/kvm_host.h          |  7 ++
 arch/arm64/include/asm/kvm_mte.h           | 74 ++++++++++++++++++++++
 arch/arm64/include/asm/pgtable.h           |  2 +-
 arch/arm64/include/asm/sysreg.h            |  3 +-
 arch/arm64/include/uapi/asm/kvm.h          | 13 ++++
 arch/arm64/kernel/asm-offsets.c            |  3 +
 arch/arm64/kernel/mte.c                    | 36 +++++++----
 arch/arm64/kvm/arm.c                       | 68 ++++++++++++++++++++
 arch/arm64/kvm/hyp/entry.S                 |  7 ++
 arch/arm64/kvm/hyp/exception.c             |  3 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 ++
 arch/arm64/kvm/mmu.c                       | 16 +++++
 arch/arm64/kvm/sys_regs.c                  | 20 ++++--
 include/uapi/linux/kvm.h                   |  2 +
 15 files changed, 239 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_mte.h

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
