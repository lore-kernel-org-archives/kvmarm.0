Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26414C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:51:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0F056152B
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 13:51:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A0F056152B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 437504B30B;
	Tue,  5 Oct 2021 09:51:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kdRtMrPUb555; Tue,  5 Oct 2021 09:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DD54B2E9;
	Tue,  5 Oct 2021 09:51:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 264D34B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:51:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G7TwIY8lMkR1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 09:50:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 024C14B2B6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 09:50:57 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D82617E3;
 Tue,  5 Oct 2021 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633441856;
 bh=+Zz8nIxHkcfBTCM4F23ZXRh80YwkMvyTTEPJ/v4wdQg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=l0WiQV/JEjVkh19uSlGKjmsuuRfkR2JKMOoXPmF1y50Y9AvGqU7A1dy9nUBUv0Yws
 j3TMwm9myuX9LxigKZs8Pj3nVUrrRq23GrbCVW9n68qWuGRUflfjsvlC4/rrEQNPZD
 EaezPF0JnUOgD7ykVWpbmEdb3FVew9H3olwGWzxbHXuEt10ksfXLgg4ncI+E+FVMns
 /WOMEQpIKQoItIAoFfVCDrF/OpweOBoTxYkk9awSTw//C//dSohqcZzl8q/5rH+9V/
 bpTEz9iZnlAbriSsxffos9QwoxwsVqPeZYUnP7m1fmg3tt+bZlfIULf1YYIjKxKaZe
 NyR8WMbS/jU6w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 16/40] KVM: arm64: nvhe: Fix missing FORCE for
 hyp-reloc.S build rule
Date: Tue,  5 Oct 2021 09:49:55 -0400
Message-Id: <20211005135020.214291-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, keescook@chromium.org,
 Marc Zyngier <maz@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>,
 samitolvanen@google.com, catalin.marinas@arm.com, will@kernel.org,
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

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit a49b50a3c1c3226d26e1dd11e8b763f27e477623 ]

Add FORCE so that if_changed can detect the command line change.

We'll otherwise see a compilation warning since commit e1f86d7b4b2a
("kbuild: warn if FORCE is missing for if_changed(_dep,_rule) and
filechk").

arch/arm64/kvm/hyp/nvhe/Makefile:58: FORCE prerequisite is missing

Cc: David Brazdil <dbrazdil@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210907052137.1059-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 5df6193fc430..8d741f71377f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -54,7 +54,7 @@ $(obj)/kvm_nvhe.tmp.o: $(obj)/hyp.lds $(addprefix $(obj)/,$(hyp-obj)) FORCE
 #    runtime. Because the hypervisor is part of the kernel binary, relocations
 #    produce a kernel VA. We enumerate relocations targeting hyp at build time
 #    and convert the kernel VAs at those positions to hyp VAs.
-$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel
+$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel FORCE
 	$(call if_changed,hyprel)
 
 # 5) Compile hyp-reloc.S and link it into the existing partially linked object.
-- 
2.33.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
