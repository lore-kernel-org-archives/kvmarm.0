Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA95C43334
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 15:35:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D17C4C5C4;
	Thu, 14 Jul 2022 11:35:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AFlaynMrHI0r; Thu, 14 Jul 2022 11:35:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EE974C5F7;
	Thu, 14 Jul 2022 11:35:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C89374C592
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bjve3anTKkTd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 11:35:24 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 178924C59B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 11:35:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 35A89B8267F;
 Thu, 14 Jul 2022 15:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9EEC34114;
 Thu, 14 Jul 2022 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1657812921;
 bh=uKTZ7q/gsQNMYQ24/tzAJ7rKkKRt7Y+oaSKj6tJVeR4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RrPs/FEmrW+sYs9pCj4v3DxZdgeh0I8Tsvr048Y43pDwIVadWBGn7fZxVv2WjLaNu
 T5uI8onoV0BhrfHGkS2Ue6999gcxx7u932j6Wwe4S29XjjyZW8SvK8NZPEIdnna9pz
 lsjXfcPPlRM4mfAYkV90V/XzjtN7ZPcbd+anUMXKIxdJu/HuVPawbAXHGiYZXLeA3B
 m6/rwDltjUyWE6T8yk2CMBqDUwPblc/iiY/2+ckdID/3ktzJ3AqwufDuR/WPNBNCJq
 XjEBrGFnmQrcM0dpEGK2bWEEtvauB2aFC4uKX/xP35Wsw4+P37+pAulfS8Vk5HFmQP
 Wr6JfflRY5odA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oC0dk-007UVL-TY;
 Thu, 14 Jul 2022 16:20:32 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 18/20] KVM: arm64: Get rid of find_reg_by_id()
Date: Thu, 14 Jul 2022 16:20:22 +0100
Message-Id: <20220714152024.1673368-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714152024.1673368-1-maz@kernel.org>
References: <20220714152024.1673368-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 reijiw@google.com, schspa@gmail.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
 Oliver Upton <oliver.upton@linux.dev>
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

This helper doesn't have a user anymore, let's get rid of it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 11 -----------
 arch/arm64/kvm/sys_regs.h |  5 -----
 2 files changed, 16 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 379478eecfaa..7ab67a7fc0d8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2577,17 +2577,6 @@ static bool index_to_params(u64 id, struct sys_reg_params *params)
 	}
 }
 
-const struct sys_reg_desc *find_reg_by_id(u64 id,
-					  struct sys_reg_params *params,
-					  const struct sys_reg_desc table[],
-					  unsigned int num)
-{
-	if (!index_to_params(id, params))
-		return NULL;
-
-	return find_reg(params, table, num);
-}
-
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num)
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index b8b576a2af2b..49517f58deb5 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -190,11 +190,6 @@ find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
 	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
 }
 
-const struct sys_reg_desc *find_reg_by_id(u64 id,
-					  struct sys_reg_params *params,
-					  const struct sys_reg_desc table[],
-					  unsigned int num);
-
 const struct sys_reg_desc *get_reg_by_id(u64 id,
 					 const struct sys_reg_desc table[],
 					 unsigned int num);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
