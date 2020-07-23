Return-Path: <SRS0=bqG1=BC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C27C433E5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 11:02:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D5391208E4
	for <kvmarm@archiver.kernel.org>; Thu, 23 Jul 2020 11:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1XgwXX1k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5391208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FB9A4B331;
	Thu, 23 Jul 2020 07:02:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ozATWdKjUBo1; Thu, 23 Jul 2020 07:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 374AA4B2F8;
	Thu, 23 Jul 2020 07:02:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C99BF4B2E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 07:02:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vdwkn83rCpPg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Jul 2020 07:02:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9D974B2E6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Jul 2020 07:02:45 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 910B42080D;
 Thu, 23 Jul 2020 11:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595502165;
 bh=7BS3tGlUSdMKnll9WlvmP5t8lhtC1LVjE2eQrR2WVKk=;
 h=From:To:Cc:Subject:Date:From;
 b=1XgwXX1ksp94++hKQkvh1//ockWr1w0JQf31mqbNyL/M86H2yvLh5VP6631zafeMy
 ybtKuXJxj12Lr+9wVRVuC1ySJhYGD+n4T71DGqonR7M8BUTK+1XGes0K8XkFI92orh
 EfAcsV+ccqA+eWvCvAIi74rkckjH81Vqb9b80R5U=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/3] KVM: arm64: Clean up memcache usage for page-table pages
Date: Thu, 23 Jul 2020 12:02:24 +0100
Message-Id: <20200723110227.16001-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, maz@kernel.org, kernel-team@android.com,
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

Hi all,

Here are some small cleanups I made to the memcache logic while hacking on the
page-table code. The ioremap() behaviour looks like a bug to me, although it's
just a performance thing so nothing urgent.

Cheers,

Will

--->8

Will Deacon (3):
  KVM: arm64: Don't free memcache pages in kvm_phys_addr_ioremap()
  KVM: arm64: Simplify mmu_topup_memory_cache()
  KVM: arm64: Remove mmu_free_memory_cache()

 arch/arm64/kvm/mmu.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

-- 
2.28.0.rc0.105.gf9edc3c819-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
