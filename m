Return-Path: <SRS0=IB6K=76=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CA6C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 12:39:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4AB1421532
	for <kvmarm@archiver.kernel.org>; Wed, 17 Jun 2020 12:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AB1421532
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 899894B201;
	Wed, 17 Jun 2020 08:39:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WNWUce-7smF9; Wed, 17 Jun 2020 08:39:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8954B226;
	Wed, 17 Jun 2020 08:39:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBAA4B1F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 08:39:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id W1U4d1BL+HDv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Jun 2020 08:39:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4585F4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Jun 2020 08:39:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA0781045;
 Wed, 17 Jun 2020 05:39:20 -0700 (PDT)
Received: from e112269-lin.arm.com (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 078483F71F;
 Wed, 17 Jun 2020 05:39:18 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
Subject: [RFC PATCH 0/2] MTE support for KVM guest
Date: Wed, 17 Jun 2020 13:38:42 +0100
Message-Id: <20200617123844.29960-1-steven.price@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org,
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

These patches add support to KVM to enable MTE within a guest. It is
based on Catalin's v4 MTE user space series[1].

[1] http://lkml.kernel.org/r/20200515171612.1020-1-catalin.marinas%40arm.com

Posting as an RFC as I'd like feedback on the approach taken. First a
little background on how MTE fits within the architecture:

The stage 2 page tables have limited scope for controlling the
availability of MTE. If a page is mapped as Normal and cached in stage 2
then it's the stage 1 tables that get to choose whether the memory is
tagged or not. So the only way of forbidding tags on a page from the
hypervisor is to change the cacheability (or make it device memory)
which would cause other problems.  Note this restriction fits the
intention that a system should have all (general purpose) memory
supporting tags if it support MTE, so it's not too surprising.

However, the upshot of this is that to enable MTE within a guest all
pages of memory mapped into the guest as normal cached pages in stage 2
*must* support MTE (i.e. we must ensure the tags are appropriately
sanitised and save/restore the tags during swap etc).

My current approach is that KVM transparently upgrades any pages
provided by the VMM to be tag-enabled when they are faulted in (i.e.
sets the PG_mte_tagged flag on the page) which has the benefit of
requiring fewer changes in the VMM. However, save/restore of the VM
state still requires the VMM to have a PROT_MTE enabled mapping so that
it can access the tag values. A VMM which 'forgets' to enable PROT_MTE
would lose the tag values when saving/restoring (tags are RAZ/WI when
PROT_MTE isn't set).

An alternative approach would be to enforce the VMM provides PROT_MTE
memory in the first place. This seems appealing to prevent the above
potentially unexpected gotchas with save/restore, however this would
also extend to memory that you might not expect to have PROT_MTE (e.g. a
shared frame buffer for an emulated graphics card). 

Comments on the approach (or ideas for alternative approaches) are very
welcome.

Steven Price (2):
  arm64: kvm: Save/restore MTE registers
  arm64: kvm: Introduce MTE VCPU feature

 arch/arm64/include/asm/kvm_emulate.h |  3 +++
 arch/arm64/include/asm/kvm_host.h    |  9 ++++++++-
 arch/arm64/include/uapi/asm/kvm.h    |  1 +
 arch/arm64/kvm/hyp/sysreg-sr.c       | 12 ++++++++++++
 arch/arm64/kvm/reset.c               |  8 ++++++++
 arch/arm64/kvm/sys_regs.c            |  8 ++++++++
 virt/kvm/arm/mmu.c                   | 11 +++++++++++
 7 files changed, 51 insertions(+), 1 deletion(-)

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
