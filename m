Return-Path: <SRS0=jse9=PZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE5FC433F5
	for <kvmarm@archiver.kernel.org>; Sat,  6 Nov 2021 11:25:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 537D2611C4
	for <kvmarm@archiver.kernel.org>; Sat,  6 Nov 2021 11:25:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 537D2611C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C600C4B1C1;
	Sat,  6 Nov 2021 07:25:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XgPkmGWLdUPF; Sat,  6 Nov 2021 07:24:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B3764B1B6;
	Sat,  6 Nov 2021 07:24:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA36C4086F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 23:25:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QVfzWPWhfSDD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Nov 2021 23:25:36 -0400 (EDT)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93EDD4B0F5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Nov 2021 23:25:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
 MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
 Content-ID:Content-Description:In-Reply-To:References;
 bh=6/kWhbqRgRV86GqBXhUN/qe26HQfH+5fQJSNVsfmrLk=; b=saVTPC+PbCuS1zrwV+ABsc/N3N
 zAYDjp01Md4FsPC7tOIrByN4tbwpXTwSxYnFgen9t5L3Pz3/iiTV2sMzOBrhdI5PGDbrgasLqBIpJ
 /4ACwlxgm4jgjQuyrpIxYWL4Ft4w5h3v/TYTACGXmzUOflGnJgY7nxCbLFF9xPuI3ZHOlirTc7BAk
 9wCEATMv2uKFdakr/BfZTUyPC4Wc+rDCRlPlyPrEQzZGgT5T2uasyALTjxdL/pSCRfn00/LwZtgAn
 P6vx8Zt6GSst7PXv/K3r0ZgKv5L03uWqyeJo/6x9FGf4rDmGc1PeoESLTd7CPYZ4dT0WsV+uUpWFK
 620q9Hhw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mjCKg-00CcF3-KT; Sat, 06 Nov 2021 03:25:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: kvm/hyp/nvhe: fix a non-kernel-doc comment
Date: Fri,  5 Nov 2021 20:25:29 -0700
Message-Id: <20211106032529.15057-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
X-Mailman-Approved-At: Sat, 06 Nov 2021 07:24:57 -0400
Cc: kernel test robot <lkp@intel.com>, Marc Zyngier <maz@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, kvmarm@lists.cs.columbia.edu,
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

Do not use kernel-doc "/**" notation when the comment is not in
kernel-doc format.

Fixes this docs build warning:

arch/arm64/kvm/hyp/nvhe/sys_regs.c:478: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * Handler for protected VM restricted exceptions.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211106.orig/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ linux-next-20211106/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -474,7 +474,7 @@ bool kvm_handle_pvm_sysreg(struct kvm_vc
 	return true;
 }
 
-/**
+/*
  * Handler for protected VM restricted exceptions.
  *
  * Inject an undefined exception into the guest and return true to indicate that
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
