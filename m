Return-Path: <SRS0=McOM=P3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1F6C4332F
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 15:46:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 268006128B
	for <kvmarm@archiver.kernel.org>; Mon,  8 Nov 2021 15:46:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 268006128B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69BBE4B22B;
	Mon,  8 Nov 2021 10:46:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0HCnYdS2QUuS; Mon,  8 Nov 2021 10:46:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87C7A4B227;
	Mon,  8 Nov 2021 10:46:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A71484B209
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 10:46:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1fxeq-EHiFy1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 10:46:40 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61C684B1AF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 10:46:40 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 z5-20020a5d6405000000b00182083d7d2aso4168443wru.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 07:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=AKApMG+OBphO2mXMNWEAzsKBITa8c+pAso67pj90vC8=;
 b=tG6WMOy8dE74seq/qZL5tl10JmW8g5oPqehlE/OLFpxU36Ysf7ZW95dwBXeXgmcMF8
 YEWHUhQQOWRykLtNUx2WTgIx8tOmvq9soy+zWO4U29ZLZD7+5I4VvJqbdW+/vmnwr2Yk
 EItavDge61Azr5p7RdHNoJnde9HhafcPYYeub9RMPClQthw6TRcpLY1/asXTnzDBLc2S
 gjUAanJK6ajTf+rC+yFSGDXgHiK0pGx10EvBgimhWb8xAuX55XDt4mQpFt/ixoE4aqS5
 nMqKwSAKLLTPKuKelYGlJmiQ9rtga1sjS0ipfi403/FpDqPaupXIs/M8wJpSQnJwwxRU
 YtIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=AKApMG+OBphO2mXMNWEAzsKBITa8c+pAso67pj90vC8=;
 b=W8E3PLorZkw9XMtZdolKumQ11gaqRESp4Nc2rf6M3ldDfGyX9oiqlQguPY5ogOTf+Z
 aFyp2GbCalfcyFaiWhJeFY+KeST8Gmh77MHs7VFMEUkV3ZJZtX73kWYsyhLF8BQWmYMG
 68vKFmpDHeoo+2Wv/Z8qj8UhZvtqJUBRxZKgTjzrfzTOAt85vOJHcl0v6NNvxu13Ak/G
 vi19S0CCVtrvsPF9Vce2mNvT2K/6ohkd3gWRw2Iw6t/l5Nf/mPeGKDlW69ubTsWFI3jo
 cEdyug1SQQfXKyFl+bL2ZZEoS5QcW9vlsgPZtKwm9UzUckyuQeXKFXAS4uJnHmq7fPuo
 6+TQ==
X-Gm-Message-State: AOAM532nTKOqwM/wPNj9wL92+nMnhffwXyciSyj4XF0Cm+BqDxv991x0
 9c9RMjgkdkx78d1BYRXgs/nlEVgu2CZ0
X-Google-Smtp-Source: ABdhPJwzJyzbAG53O2weMHNNmNKKDpLhMyRm0Wi+7RXoQ9dLo6WBHGjX8UZ98cpkXILxFN6jSDpOUH0xoW/G
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:909f:3aba:7f9a:3a93])
 (user=qperret job=sendgmr) by 2002:a05:600c:3ba5:: with SMTP id
 n37mr36644382wms.168.1636386399156; Mon, 08 Nov 2021 07:46:39 -0800 (PST)
Date: Mon,  8 Nov 2021 15:46:32 +0000
Message-Id: <20211108154636.393384-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH] KVM: arm64: Fix host stage-2 finalization
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

We currently walk the hypervisor stage-1 page-table towards the end of
hyp init in nVHE protected mode and adjust the host page ownership
attributes in its stage-2 in order to get a consistent state from both
point of views. The walk is done on the entire hyp VA space, and expects
to only ever find page-level mappings. While this expectation is
reasonable in the half of hyp VA space that maps memory with a fixed
offset (see the loop in pkvm_create_mappings_locked()), it can be
incorrect in the other half where nothing prevents the usage of block
mappings. For instance, on systems where memory is physically aligned at
an address that happens to maps to a PMD aligned VA in the hyp_vmemmap,
kvm_pgtable_hyp_map() will install block mappings when backing the
hyp_vmemmap, which will later cause finalize_host_mappings() to fail.
Furthermore, it should be noted that all pages backing the hyp_vmemmap
are also mapped in the 'fixed offset range' of the hypervisor, which
implies that finalize_host_mappings() will walk both aliases and update
the host stage-2 attributes twice. The order in which this happens is
unpredictable, though, since the hyp VA layout is highly dependent on
the position of the idmap page, hence resulting in a fragile mess at
best.

In order to fix all of this, let's restrict the finalization walk to
only cover memory regions in the 'fixed-offset range' of the hyp VA
space and nothing else. This not only fixes a correctness issue, but
will also result in a slighlty faster hyp initialization overall.

Fixes: 2c50166c62ba ("KVM: arm64: Mark host bss and rodata section as shared")
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 862c7b514e20..578f71798c2e 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -178,7 +178,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 
 	phys = kvm_pte_to_phys(pte);
 	if (!addr_is_memory(phys))
-		return 0;
+		return -EINVAL;
 
 	/*
 	 * Adjust the host stage-2 mappings to match the ownership attributes
@@ -207,8 +207,18 @@ static int finalize_host_mappings(void)
 		.cb	= finalize_host_mappings_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
 	};
+	int i, ret;
+
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		struct memblock_region *reg = &hyp_memory[i];
+		u64 start = (u64)hyp_phys_to_virt(reg->base);
+
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
+		if (ret)
+			return ret;
+	}
 
-	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits), &walker);
+	return 0;
 }
 
 void __noreturn __pkvm_init_finalise(void)
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
