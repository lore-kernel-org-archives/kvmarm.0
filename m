Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C12CCA47A
	for <kvmarm@archiver.kernel.org>; Tue, 14 Jun 2022 08:16:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 56C884B22A;
	Tue, 14 Jun 2022 04:16:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nifty.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mnTd8SDFjD-a; Tue, 14 Jun 2022 04:16:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67BD54B20F;
	Tue, 14 Jun 2022 04:16:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E41EB4B30A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 05:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NwX+24UkFePu for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jun 2022 05:21:11 -0400 (EDT)
Received: from conuserg-11.nifty.com (conuserg-11.nifty.com [210.131.2.78])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AFFC4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jun 2022 05:21:11 -0400 (EDT)
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp
 [133.32.177.133]) (authenticated)
 by conuserg-11.nifty.com with ESMTP id 25D9Kgx8000823;
 Mon, 13 Jun 2022 18:20:44 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com 25D9Kgx8000823
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
 s=dec2015msa; t=1655112044;
 bh=geZktAm+s7Yy19cRfK3Fa5IfT7B/Uq8q4gOcEHOo8Ys=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=RNrbi+i2RZvCHfXkLID7CANqJ0V+E5DyR04ZodAvDTdqBbf0l/dHDVkK/8QnbzdAL
 iv0+AcaU93RhU/Ud/jYNKdy/5H7tTTAArZk7ib7f0VuahuthxsfH/DEUtAQp8UtRMG
 t+obGikq+j/sSQLDU1ce9chr415/9mvGGGwizVfIAH0cav2l6pI1H6ZSRxDcyIHoc/
 SGnyXci+kGWtHOYU9X/1paPVQnE99/8JGJ/cmXuLBJOsjG2mrHlMRvPI1RMqXGYThs
 eTS84bqPucHC+DviBfzXirCw6hsRffa7c5gkkWSoL2AMbfk/89LKCC1QYb8uBAKeZL
 b4z5JcK6c4Hpw==
X-Nifty-SrcIP: [133.32.177.133]
From: Masahiro Yamada <masahiroy@kernel.org>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/2] KVM: arm64: nvhe: add intermediates to 'targets' instead
 of extra-y
Date: Mon, 13 Jun 2022 18:20:26 +0900
Message-Id: <20220613092026.1705630-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220613092026.1705630-1-masahiroy@kernel.org>
References: <20220613092026.1705630-1-masahiroy@kernel.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 14 Jun 2022 04:16:17 -0400
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-kernel@vger.kernel.org,
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

These are generated on demand. Adding them to 'targets' is enough.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 3c6d3a18171c..a2b0d043dddf 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -28,7 +28,7 @@ hyp-obj-y += $(lib-objs)
 
 hyp-obj := $(patsubst %.o,%.nvhe.o,$(hyp-obj-y))
 obj-y := kvm_nvhe.o
-extra-y := $(hyp-obj) kvm_nvhe.tmp.o kvm_nvhe.rel.o hyp.lds hyp-reloc.S hyp-reloc.o
+targets += $(hyp-obj) kvm_nvhe.tmp.o kvm_nvhe.rel.o hyp.lds hyp-reloc.S hyp-reloc.o
 
 # 1) Compile all source files to `.nvhe.o` object files. The file extension
 #    avoids file name clashes for files shared with VHE.
-- 
2.32.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
