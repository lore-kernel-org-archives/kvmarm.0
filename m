Return-Path: <SRS0=VMV7=EY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BD8C5519F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 19:44:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2574246BC
	for <kvmarm@archiver.kernel.org>; Wed, 18 Nov 2020 19:44:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiAU3lqT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2574246BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0316C4B9C6;
	Wed, 18 Nov 2020 14:44:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4YhmzB0H7vPn; Wed, 18 Nov 2020 14:44:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0014B4B99E;
	Wed, 18 Nov 2020 14:44:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B9DC4B935
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 14:44:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FUY0eIjQu9lw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Nov 2020 14:44:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 356824B934
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Nov 2020 14:44:08 -0500 (EST)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E1BAE246A7;
 Wed, 18 Nov 2020 19:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1605728647;
 bh=clUE66Hge1Oaex3TBcgXMZk3+2Gxr2qET9z/1RCFWRY=;
 h=From:To:Cc:Subject:Date:From;
 b=EiAU3lqTO21GFTPjItaxl98TiucfxKfP47WMZ47Eb2z6/rhpt6VxW7XMjVwbOO51g
 nuB8Ei2D6usclOmBgX71bp4QOEo1TnOjYL2Jbw+5ILAO6QwhbNjM8Ig/X/iw4aCnv6
 HRU36n/naz4NCW7Crdlm6G+6vy/F+RD2zpj0yV1A=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu,
	maz@kernel.org
Subject: [PATCH 0/3] KVM: arm64: Boring cosmetic patches
Date: Wed, 18 Nov 2020 19:43:59 +0000
Message-Id: <20201118194402.2892-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
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

Hi all,

Here are some desperately dull patches I cooked while working on pkvm
enablement. The latter isn't ready yet, but figured there wasn't much
point me sitting on these. Although they're boring, the first patch does
touch uapi/ so it's not completely trivial.

Cheers,

Will

--->8

Will Deacon (3):
  KVM: arm64: Move 'struct kvm_arch_memory_slot' out of uapi/
  KVM: arm64: Remove kvm_arch_vm_ioctl_check_extension()
  KVM: arm64: Remove unused __extended_idmap_trampoline() prototype

 arch/arm64/include/asm/cpufeature.h |  5 +++
 arch/arm64/include/asm/kvm_host.h   |  5 +--
 arch/arm64/include/uapi/asm/kvm.h   |  3 --
 arch/arm64/kvm/arm.c                | 31 +++++++++++++++--
 arch/arm64/kvm/reset.c              | 52 -----------------------------
 5 files changed, 37 insertions(+), 59 deletions(-)

-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
