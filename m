Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A32AC43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 16:00:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BF0F12074D
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 16:00:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF0F12074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31DCC4B2A2;
	Fri,  4 Sep 2020 12:00:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jk9Bh50qMZnk; Fri,  4 Sep 2020 12:00:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD694B37B;
	Fri,  4 Sep 2020 12:00:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 161D34B345
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 12:00:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GmfnOcYlZxZE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 12:00:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A16664B2A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 12:00:27 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2935E11B3;
 Fri,  4 Sep 2020 09:00:27 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD76B3F66F;
 Fri,  4 Sep 2020 09:00:24 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2 0/2] MTE support for KVM guest
Date: Fri,  4 Sep 2020 17:00:16 +0100
Message-Id: <20200904160018.29481-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Peter Maydell <Peter.Maydell@arm.com>, qemu-devel@nongnu.org,
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

Arm's Memory Tagging Extension (MTE) adds 4 bits of tag data to every 16
bytes of memory in the system. This along with stashing a tag within the
high bit of virtual addresses allows runtime checking of memory
accesses.

These patches add support to KVM to enable MTE within a guest. They are
based on Catalin's v9 MTE user-space support series[1].

I'd welcome feedback on the proposed user-kernel ABI. Specifically this
series currently:

 1. Requires the VMM to enable MTE per-VCPU.
 2. Automatically promotes (normal host) memory given to the guest to be
    tag enabled (sets PG_mte_tagged), if any VCPU has MTE enabled. The
    tags are cleared if the memory wasn't previously MTE enabled.
 3. Doesn't provide any new methods for the VMM to access the tags on
    memory.

(2) and (3) are particularly interesting from the aspect of VM migration.
The guest is able to store/retrieve data in the tags (presumably for the
purpose of tag checking, but architecturally it could be used as just
storage). This means that when migrating a guest the data needs to be
transferred (or saved/restored).

MTE tags are controlled by the same permission model as normal pages
(i.e. a read-only page has read-only tags), so the normal methods of
detecting guest changes to pages can be used. But this would also
require the tags within a page to be migrated at the same time as the
data (since the access control for tags is the same as the normal data
within a page).

(3) may be problematic and I'd welcome input from those familiar with
VMMs. User space cannot access tags unless the memory is mapped with the
PROT_MTE flag. However enabling PROT_MTE will also enable tag checking
for the user space process (assuming the VMM enables tag checking for
the process) and since the tags in memory are controlled by the guest
it's unlikely the VMM would have an appropriately tagged pointer for its
access. This means the VMM would either need to maintain two mappings of
memory (one to access tags, the other to access data) or disable tag
checking during the accesses to data.

If it's not practical to either disable tag checking in the VMM or
maintain multiple mappings then the alternatives I'm aware of are:

 * Provide a KVM-specific method to extract the tags from guest memory.
   This might also have benefits in terms of providing an easy way to
   read bulk tag data from guest memory (since the LDGM instruction
   isn't available at EL0).
 * Provide support for user space setting the TCMA0 or TCMA1 bits in
   TCR_EL1. These would allow the VMM to generate pointers which are not
   tag checked.

Feedback is welcome, and feel free to ask questions if anything in the
above doesn't make sense.

Changes since the previous v1 posting[2]:

 * Rebasing clean-ups
 * sysreg visibility is now controlled based on whether the VCPU has MTE
   enabled or not

[1] https://lore.kernel.org/r/20200904103029.32083-1-catalin.marinas@arm.com
[2] https://lore.kernel.org/r/20200713100102.53664-1-steven.price%40arm.com

Steven Price (2):
  arm64: kvm: Save/restore MTE registers
  arm64: kvm: Introduce MTE VCPU feature

 arch/arm64/include/asm/kvm_emulate.h       |  3 +++
 arch/arm64/include/asm/kvm_host.h          |  9 ++++++++-
 arch/arm64/include/asm/sysreg.h            |  3 ++-
 arch/arm64/include/uapi/asm/kvm.h          |  1 +
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
 arch/arm64/kvm/mmu.c                       | 15 +++++++++++++++
 arch/arm64/kvm/reset.c                     |  8 ++++++++
 arch/arm64/kvm/sys_regs.c                  | 20 +++++++++++++++-----
 8 files changed, 66 insertions(+), 7 deletions(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
