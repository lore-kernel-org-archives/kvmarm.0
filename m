Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE686C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E5B661181
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6E5B661181
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 248A74B0C2;
	Wed, 22 Sep 2021 08:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FZnanwnMpt3T; Wed, 22 Sep 2021 08:47:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 594E54B0F3;
	Wed, 22 Sep 2021 08:47:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FA6449E57
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u9isdGVoSV2Y for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:29 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 487F94B0B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:28 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 h25-20020a0cab19000000b0037a49d15c93so11013794qvb.22
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VDXP3setiKLnEkr+m8sXiGgb9NQ7LpnbUrrcIbXKtWo=;
 b=YhjUmlV5OpV1LXBTgzD8/h4cw2tRnnfej2OdpOQpSGJxMxFm+HDvY9vdNn7/RVXaxA
 lVbEnrUF58QW9sv1C6OK93B5CyDwhDWtQ4NMEpn/M8vw6kRj8RiFofXL2HGYyVZ46ghF
 oMxWjdWfsofPMRxWOOdMyIvmnVxOyner4uS2ykvqR73D33N3r/sub3jwu3PTk/Crd/c4
 y3V/DEQoTtMLQ7dGuaD7wLT3jw6R5oSx2QT8EDVkWoffehArauEXCYepe5rAYc01TdzY
 vbQSAEObj8/viDQul62w2oFY9l+j0cxFaDKLITiZVWrv7+OFhyHSy1SFp7xEU/TMu9yI
 5KqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VDXP3setiKLnEkr+m8sXiGgb9NQ7LpnbUrrcIbXKtWo=;
 b=26O8qmPYt/2ycB6iijAdRx6+Lo3jZY4Eqt1MPOFbfBlfjdl8feVoi48RzSj0HKD1tY
 FPYaEO2NYDFra/QUMEpki/UDCTNDQZXZltk6148k/epjv62GlZ1kLilHu3ELxoGY9zIK
 TUIuQfHFElC0rLMfEvXn9kNkAh9mGRxgsiXcZHIEek4aXmxolhdbGkWWDCS9oTKEIpCk
 DcjJpDHyf66VNbfLnpriE0u3If/yTXT0DwSoi1Q3SlSz8FmN6UC8Vk5F7bDrFKyIloYj
 uQvCAX3CKZeg0W340DjqccVUX8s66MgtTIMoVRGbFakpBbWFspmFFCaP8orgsPv9X7fE
 L7mg==
X-Gm-Message-State: AOAM531FCMhy4Fmt8WOKVaJAk93+W/02gszUyMFXsyefxSVQCbTJDyFY
 NcEmcdHNKRlQXKeW+/b2ttwkMnb+phavsNkw4JLdfMZrCzS2UL3c4qqXXwIIJCsZW2/1ffKyUNz
 1sdq3pVwn0Vlu6Aw7Y1ZyN9MME1gHgpR7xt9mQ8hUKlTXgAth4Acj6Yp7j/pWHcCiGYc=
X-Google-Smtp-Source: ABdhPJyQbCBi9wL/tzdvEaSavXwKPtQuvp/ahZuW35rtc+EuWLIOI43tUp6sSo2sedY/Dgz5GrvXBg5Ung==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:8881:: with SMTP id
 d1mr15958608ybl.289.1632314847844; 
 Wed, 22 Sep 2021 05:47:27 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:47:02 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-11-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 10/12] KVM: arm64: Move sanitized copies of CPU features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a07d63b8498..f6d96e60b323 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,12 +25,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index ef8456c54b18..13163be83756 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -19,6 +19,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 static inline void inject_undef64(struct kvm_vcpu *vcpu)
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
