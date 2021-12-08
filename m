Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1395C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D6F84B190;
	Wed,  8 Dec 2021 10:23:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 77F7sevQM8fo; Wed,  8 Dec 2021 10:23:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA4B74B17B;
	Wed,  8 Dec 2021 10:23:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F604B16E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DztIhlZiZfZ2 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:19 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8DEC4B1B2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:18 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 201-20020a1c04d2000000b003335bf8075fso1483286wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cuQE0YW8UdMGW3rLCo6CNfwjy36MSIxkvZOeV47gVAQ=;
 b=KUpsl8OdrXa2TfNhJOIs3W3KwuQrGlRyqmoXmUyaJ/yuu4HpfU1Kh6qBx0/DO5VGCW
 30J/V6mtYiRAmcRHM+mRVJum30AGeDLlvKOpqxYp+Jet7qFJJ1RdoNIVvktcVDiLDpqZ
 ehHF9n08W/1YSh/QKI1PIfTOx8lNeNdWFZqFuHY4IbZYhDWrHvWxvuQ+m8SLOOOKopWV
 Uch7He8l5dVKPrpUzYaPboYyMT/+vk2ZeR+zmJn7QZvuOWKOuoJdoYS5ptXP4LyB1l/u
 sS5qgHeFSbCTheo3xIpypUgjz9uCkJAgxoYl5uOx5eSw/hZ/dtcTXVGboSUwYK26WUuE
 AqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cuQE0YW8UdMGW3rLCo6CNfwjy36MSIxkvZOeV47gVAQ=;
 b=c1gh5Og2a9wKR31g5HvT0Nuw2uRgCGmv+LINC3CahCUHYWsxp50XdDsLEsYII1NBbR
 d+VcYKmyXEz5l6tEMB/LkaYf8YIqT/0Ae3FyFFgCGxd79hpqwn5V2E5DCGFi0dXxzw/w
 zUHCvMaWr7BKEIvFwMThzOc8SJJ8xX+nn2Rn41ZM97S4u+Pq3h+jWN7ibj+bxaVxqvM5
 ziHnbneAvZoeVU6g5dRrYambvFzjGsjQdhyfbyBYbfA4BcpROMYgHLP8U8JSTvxcrR6v
 LRMO2Y+xl9kMsSiQIyCGb1Ee7TBHu6RkuwDn2zQ6+VX1V7q+xPPOyeOa1yX+9Kcbnh5O
 Tb2g==
X-Gm-Message-State: AOAM530Zn74BmxkvTOj9v+ZCZLDl8VJzI9iCxq30W996DaAdRrjwqSE1
 UuJJ/WSz3+YSP9oWmU7cHiFjKtEbG9lE
X-Google-Smtp-Source: ABdhPJxGsSBocOeLXiSRK4wTT3nM6evq9+M4+nial4TaliEuNBrySS5ScIR8zMauErKeWzLKuaryRYic2Qfw
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a05:600c:3506:: with SMTP id
 h6mr16840889wmq.122.1638976997976; Wed, 08 Dec 2021 07:23:17 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:58 +0000
In-Reply-To: <20211208152300.2478542-1-qperret@google.com>
Message-Id: <20211208152300.2478542-6-qperret@google.com>
Mime-Version: 1.0
References: <20211208152300.2478542-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 5/6] KVM: arm64: pkvm: Stub io map functions
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Now that GICv2 is disabled in nVHE protected mode there should be no
other reason for the host to use create_hyp_io_mappings() or
kvm_phys_addr_ioremap(). Add sanity checks to make sure that assumption
remains true looking forward.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/mmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 326cdfec74a1..605c104eb030 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -407,6 +407,9 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 	unsigned long addr;
 	int ret;
 
+	if (is_protected_kvm_enabled())
+		return -EPERM;
+
 	*kaddr = ioremap(phys_addr, size);
 	if (!*kaddr)
 		return -ENOMEM;
@@ -650,6 +653,9 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 				     KVM_PGTABLE_PROT_R |
 				     (writable ? KVM_PGTABLE_PROT_W : 0);
 
+	if (is_protected_kvm_enabled())
+		return -EPERM;
+
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
 
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
