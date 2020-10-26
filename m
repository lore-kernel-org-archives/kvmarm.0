Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,RCVD_DOTEDU_SUSP,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE87C4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6477222409
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 15:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="buCuU0wA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6477222409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E73004B4F8;
	Mon, 26 Oct 2020 11:58:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2QEETjQ0HhB2; Mon, 26 Oct 2020 11:58:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B3984B50A;
	Mon, 26 Oct 2020 11:58:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F0E4B4DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id giHhVhTVuNr5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 11:58:43 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A2B94B4D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 11:58:43 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6D2D2217A0;
 Mon, 26 Oct 2020 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1603727922;
 bh=rUxavYmnHDlR1WI5Thkd+VTFBF7Ii2Jx0DDSg1Dvyig=;
 h=From:To:Cc:Subject:Date:From;
 b=buCuU0wAUWtSRIEAN/R3brLSu69YvktmLKZq13pfny07wcgPPR0kXnyGEqtMiQjbl
 t195ireEAq6ogpXSLX/ulXBTOrw+n2aHd95mW0hq9yqIzTl7oqTYuGSECjcbFN+3Ps
 NNkrWOzTPMUbQyWJnabOgGgyrne01gfLVFjc7Lus=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/9] Rework hyp vector handling
Date: Mon, 26 Oct 2020 15:58:24 +0000
Message-Id: <20201026155833.24847-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, kernel-team@android.com
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

Hi all,

This small series reworks the hyp vector handling for the vectors
installed when running a guest so that they are more amenable to the
ongoing "Protected KVM" efforts. Most of the patches here are cosmetic,
with the bulk of the changes living in patch seven.

The idea is to allocate the vector slots statically, and then refer to
them using an enumerated type which can later be used as a hypercall
parameter to identify the vectors that are required.

The series also results in cleaner, simpler code with a slightly negative
diffstat.

Cheers,

Will

--->8

Will Deacon (9):
  KVM: arm64: Remove redundant Spectre-v2 code from kvm_map_vector()
  KVM: arm64: Tidy up kvm_map_vector()
  KVM: arm64: Move kvm_get_hyp_vector() out of header file
  KVM: arm64: Make BP hardening globals static instead
  KVM: arm64: Move BP hardening helpers into spectre.h
  KVM: arm64: Re-jig logic when patching hardened hyp vectors
  KVM: arm64: Allocate hyp vectors statically
  arm64: spectre: Rename ARM64_HARDEN_EL2_VECTORS to ARM64_SPECTRE_V3A
  arm64: spectre: Consolidate spectre-v3a detection

 Documentation/arm64/memory.rst   |  2 +-
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/include/asm/kvm_asm.h |  5 --
 arch/arm64/include/asm/kvm_mmu.h | 46 -----------------
 arch/arm64/include/asm/mmu.h     | 29 -----------
 arch/arm64/include/asm/spectre.h | 63 +++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c   | 19 +++----
 arch/arm64/kernel/proton-pack.c  | 84 ++++++++++++------------------
 arch/arm64/kvm/arm.c             | 87 ++++++++++++++++++++------------
 arch/arm64/kvm/hyp/Makefile      |  2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   | 72 ++++++++++++++------------
 arch/arm64/kvm/hyp/smccc_wa.S    | 32 ------------
 arch/arm64/kvm/va_layout.c       | 23 +--------
 13 files changed, 204 insertions(+), 262 deletions(-)
 delete mode 100644 arch/arm64/kvm/hyp/smccc_wa.S

-- 
2.29.0.rc2.309.g374f81d7ae-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
