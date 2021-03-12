Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D422FC433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 16:00:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 41BC364FFE
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 16:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41BC364FFE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC8F24B4D9;
	Fri, 12 Mar 2021 11:00:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aPjm9bQBO6zW; Fri, 12 Mar 2021 11:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A74F04B4DA;
	Fri, 12 Mar 2021 11:00:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2039B4B4D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 11:00:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bhf3LF7Chc82 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 11:00:36 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFDC24B4CE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 11:00:35 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0F1F564FFE;
 Fri, 12 Mar 2021 16:00:34 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lKkDH-001GDF-Qt; Fri, 12 Mar 2021 16:00:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 5.12, take #2
Date: Fri, 12 Mar 2021 16:00:03 +0000
Message-Id: <20210312160003.3920996-1-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, ardb@kernel.org,
 catalin.marinas@arm.com, eric.auger@redhat.com, keescook@chromium.org,
 nathan@kernel.org, samitolvanen@google.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Kees Cook <keescook@chromium.org>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
 Will Deacon <will@kernel.org>
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

Hi Paolo,

Here's the second batch of KVM/arm64 fixes for 5.12. The most notable
item is the tidying up of the way we deal with the guest physical
space, which had a couple of warts. The other patches address i-cache
isolation between vcpus (they are supposed to be vcpu-private, but can
not being so...), and a fix for a link-time issue that can occur with
LTO.

Note that this time around, this pull request is on top of kvm/next,
right after the patches you applied last week.

Please pull,

	M.

The following changes since commit 357ad203d45c0f9d76a8feadbd5a1c5d460c638b:

  KVM: arm64: Fix range alignment when walking page tables (2021-03-06 04:18:41 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-2

for you to fetch changes up to 262b003d059c6671601a19057e9fe1a5e7f23722:

  KVM: arm64: Fix exclusive limit for IPA size (2021-03-12 15:43:22 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 5.12, take #2

- Fix a couple of branches that could be impossible to resolve at
  link time when objects are far apart, such as with LTO
- Mandate i-cache invalidation when two vcpus are sharing a physical CPU
- Fail VM creation if the implicit IPA size isn't supported
- Don't reject memslots that reach the IPA limit without breaching it

----------------------------------------------------------------
Marc Zyngier (3):
      KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
      KVM: arm64: Reject VM creation when the default IPA size is unsupported
      KVM: arm64: Fix exclusive limit for IPA size

Sami Tolvanen (1):
      KVM: arm64: Don't use cbz/adr with external symbols

 Documentation/virt/kvm/api.rst     |  3 +++
 arch/arm64/include/asm/kvm_asm.h   |  4 ++--
 arch/arm64/kvm/arm.c               |  7 ++++++-
 arch/arm64/kvm/hyp/entry.S         |  6 ++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 +++---
 arch/arm64/kvm/hyp/nvhe/tlb.c      |  3 ++-
 arch/arm64/kvm/hyp/vhe/tlb.c       |  3 ++-
 arch/arm64/kvm/mmu.c               |  3 +--
 arch/arm64/kvm/reset.c             | 12 ++++++++----
 9 files changed, 31 insertions(+), 16 deletions(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
