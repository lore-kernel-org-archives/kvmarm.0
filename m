Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592D4C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D79E964F38
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D79E964F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C174B645;
	Tue,  2 Mar 2021 10:00:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R51LOS2gUVNe; Tue,  2 Mar 2021 10:00:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C9614B687;
	Tue,  2 Mar 2021 10:00:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC7004B658
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TjTDxp5Vw0+6 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:55 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 617B04B0D7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:54 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id j8so694204wmq.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=4oxp+YpplIoIB69u+tbsX2FMX4bca6h5fwiDtQ6/a1E=;
 b=DVwV4PEk1sNj/JtjY53/uNRLb44IFXbqnfCgK0gXSCwMPvjRNvm9Fcb1TcjqwrCfku
 euCCdmLYqJP39qBt+5Bew9C6jJ+Q/bGJwemVcfgXRh3nQXn8NkcDAuaezl/nhpgkNrDK
 f94J8Xjfqwl7DDHczcWMPaseBthcz2iTf0vYl5mo3WKmn0nIsdDOVisnf0UEOT7gqpCd
 Bx4inz0gG/xCu+KGf1nv2v5uR5Hk3FOUX9Hn8r4v/5ujdvnBCU7lrahHnPK/nXuRosk1
 W9lQkbXQttUHawOFtS1GUul9l6p1xAhGprMNslTZTrXUK43WU14pnWI770t3Dfmxfred
 +t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=4oxp+YpplIoIB69u+tbsX2FMX4bca6h5fwiDtQ6/a1E=;
 b=LBegHP+OtnOLS796HFiK1D4uZFp7ZU49wZ2YMbx5AAqt3/POi+pC2mXvKgLWxEf5yk
 xnwZI0h3Qi9XDi8sJ4sTkC4Uk6a/AzPT9+x3y3RYaBYhadE8JexT0M4ab0+U0AqpygQd
 CHdxdTzxe8C6ZZDRdhmcKoph172vLxRMaxJBCj8gGogMbGSwR5ZD2HGYDfC68l6IoptW
 OkzF/SLfwbRyjiqxDMU6lp9vrSIgNVIyxPcnmZpX8FBxSLTcyBnbMlyFQso3g6v8PDWx
 tLHn2bXA4LkYT87oxvTV6CgjCPx7NBcFXz7ar9AqsIDIW2mPjpEPpHcLwzB/AeJ1B6g5
 4Fgg==
X-Gm-Message-State: AOAM532JHP+Ps+FspcKc+BAQw9gL0oPudDXn9wgkwlcZWCLdX5QM5FSd
 +OoqrWKogaZqaeHNoF6I6pwGQuQzjR8m
X-Google-Smtp-Source: ABdhPJwfPjt5pFKOfHuPj31XXVqR4/+bIz9+vX0UnJf2kL9ZXviOPHu8S3WCnbrQ6ZUfzWMvmubTRIE+eq90
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:b6d7:: with SMTP id
 g206mr4471661wmf.123.1614697253532; Tue, 02 Mar 2021 07:00:53 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:51 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-22-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 21/32] KVM: arm64: Refactor __load_guest_stage2()
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Refactor __load_guest_stage2() to introduce __load_stage2() which will
be re-used when loading the host stage 2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6f743e20cb06..9d64fa73ee67 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -270,9 +270,9 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
  * Must be called from hyp code running at EL2 with an updated VTTBR
  * and interrupts disabled.
  */
-static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
+static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu, unsigned long vtcr)
 {
-	write_sysreg(kern_hyp_va(mmu->arch)->vtcr, vtcr_el2);
+	write_sysreg(vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
 
 	/*
@@ -283,6 +283,11 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
+static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
+{
+	__load_stage2(mmu, kern_hyp_va(mmu->arch)->vtcr);
+}
+
 static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
