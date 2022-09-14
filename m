Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D052ECAAD3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:36:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DED934BC6E;
	Wed, 14 Sep 2022 04:36:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x3HETg2ja5FZ; Wed, 14 Sep 2022 04:36:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A00714BC7E;
	Wed, 14 Sep 2022 04:36:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 351714BC56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D-KqbfRyGMDt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:36:42 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BDB74BB31
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 44E93CE1413;
 Wed, 14 Sep 2022 08:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AE4C433B5;
 Wed, 14 Sep 2022 08:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144594;
 bh=XjVIvPU3zWa+9OaMaawmlciTVUPSR/pweEDm06D5NfA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=XYIr2IcYtoMGNjm2gY3rGb9TcmYPaINJIGzYn3I/vJbyoFgwyV5/t549bxDRmrRYC
 poCmhac3+zOGXRPItBMVUsp4ffd4He9oQ8J4lYy6EGrPyYnN6aZxan3TBb10mpG1Y6
 AV/+BP/6BZOupGnmutAKXqQWTMS/T8JNYu+nsWBQsL/XL8xb0Ukz1AUV5Xy16QwSIi
 +08VrXlYcnsdfJMM3YFeR/RpC1b0RFCvdiODBX2+PH5y0jqBfwTkN/CIsRMeVY/kFu
 EN9gg8pr/eR5XDjc8vsKklInPrtpa3dLUcv6W9Vxy7tK7pwL2ypptdK49h5tAF0Aty
 Hbly6X2HEkncA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 24/25] KVM: arm64: Don't unnecessarily map host kernel
 sections at EL2
Date: Wed, 14 Sep 2022 09:34:59 +0100
Message-Id: <20220914083500.5118-25-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

From: Quentin Perret <qperret@google.com>

We no longer need to map the host's '.rodata' and '.bss' sections in the
stage-1 page-table of the pKVM hypervisor at EL2, so remove those
mappings and avoid creating any future dependencies at EL2 on
host-controlled data structures.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/image-vars.h  |  6 ------
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 +++-----------
 2 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index d20dc9d555af..b585bbd36d81 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -118,12 +118,6 @@ KVM_NVHE_ALIAS_HYP(__memcpy, __pi_memcpy);
 KVM_NVHE_ALIAS_HYP(__memset, __pi_memset);
 #endif
 
-/* Kernel memory sections */
-KVM_NVHE_ALIAS(__start_rodata);
-KVM_NVHE_ALIAS(__end_rodata);
-KVM_NVHE_ALIAS(__bss_start);
-KVM_NVHE_ALIAS(__bss_stop);
-
 /* Hyp memory sections */
 KVM_NVHE_ALIAS(__hyp_idmap_text_start);
 KVM_NVHE_ALIAS(__hyp_idmap_text_end);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 5a371ab236db..5cdf3fb09bb4 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -144,23 +144,15 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	}
 
 	/*
-	 * Map the host's .bss and .rodata sections RO in the hypervisor, but
-	 * transfer the ownership from the host to the hypervisor itself to
-	 * make sure it can't be donated or shared with another entity.
+	 * Map the host sections RO in the hypervisor, but transfer the
+	 * ownership from the host to the hypervisor itself to make sure they
+	 * can't be donated or shared with another entity.
 	 *
 	 * The ownership transition requires matching changes in the host
 	 * stage-2. This will be done later (see finalize_host_mappings()) once
 	 * the hyp_vmemmap is addressable.
 	 */
 	prot = pkvm_mkstate(PAGE_HYP_RO, PKVM_PAGE_SHARED_OWNED);
-	ret = pkvm_create_mappings(__start_rodata, __end_rodata, prot);
-	if (ret)
-		return ret;
-
-	ret = pkvm_create_mappings(__hyp_bss_end, __bss_stop, prot);
-	if (ret)
-		return ret;
-
 	ret = pkvm_create_mappings(&kvm_vgic_global_state,
 				   &kvm_vgic_global_state + 1, prot);
 	if (ret)
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
