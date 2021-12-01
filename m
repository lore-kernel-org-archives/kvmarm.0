Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E37C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 808704B1F7;
	Wed,  1 Dec 2021 12:04:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Opp5RnFCRqEo; Wed,  1 Dec 2021 12:04:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D5F24B269;
	Wed,  1 Dec 2021 12:04:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C278D4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q74QWQrz5T-u for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:51 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D07B44B25D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:50 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 i131-20020a1c3b89000000b00337f92384e0so136311wma.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=gP7Fa7oF1mk2VL/C80BdOcZ11ucSfvyvrK5tI2TJOao=;
 b=YIFEpSMiiphVp00kT4SqQiVFlCZjWeW7pHUFlPbzlz6LipVw2aWy7Rd6tb3JUzJM+3
 QKIISnMlREKuRhzWfT+DUQt86OHAlAejeH8a+q5aOiFs7nF9U2+bewCuES5TKaRshu2s
 qH0lsFmh+oO1cw1jDqXHNIc8iZWQ2FkeeVNPRVURvz8RBrMKrSNdu28aFetakrGmqP//
 ult2AtCbkCkC9p4XjEbc6jcacWZURDLmr7Iv9xCzICqAYxduRH8LXhXBrpLmELev6Puf
 5SG+5mVlcaSiNM5tx0UO0lC2C2y3/Zrd77xHXrAIHeEj5kfiRwqdzDjzXaSZxaueQr4u
 SamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=gP7Fa7oF1mk2VL/C80BdOcZ11ucSfvyvrK5tI2TJOao=;
 b=5zjmhwSizQhoU1mNDLmbGP1+yr2E0zbgCmkcOb7XHnZmbQzRnYG25i5ZPRF0tfxf9F
 c32ZcuhSU29Ed1mQXH1GpfpW79/JVsCwekSTPf7RP5EMul7f5dj5P+2pj2y7SP9dRIKG
 Un3AicSZ0bl4V6fVCRWoQNPlaWr8TgjMHUx9eN4aCgAHIJn97KrTRtTAkG8hyL86WdNk
 t56PBenlYgTeYBSRuxbp1I2GQcxeUNTSaFFuUF1XuL85shpeb2aY4CHNpPB8Ra9//nip
 zdiW8xM1Ly06Ahug7i4qNgrbp6orzk2l9AOZBwS0JtQ2mM7HwFlqfaLSFJ5APoWnYfJE
 w1PQ==
X-Gm-Message-State: AOAM530UdQunZgqLa9J5jHmxpfXntEn1NpW0a8jy90Xkefv1VGUNRqaa
 lSX7cO9j0YCPkEGUR1aBZutuTbBkHhtH
X-Google-Smtp-Source: ABdhPJxYTjRVBjX0Rb9ACwgvUv8SYqRjTELJGdvUGk2ZT9j9VAZxKEYlzDVuho8VN54x8a7VK7k6aXTc82QW
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:600c:354f:: with SMTP id
 i15mr8597282wmq.59.1638378289941; Wed, 01 Dec 2021 09:04:49 -0800 (PST)
Date: Wed,  1 Dec 2021 17:04:03 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-10-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 09/15] KVM: arm64: Extend pkvm_page_state enumeration to
 handle absent pages
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

From: Will Deacon <will@kernel.org>

Explicitly name the combination of SW0 | SW1 as reserved in the pte and
introduce a new PKVM_NOPAGE meta-state which, although not directly
stored in the software bits of the pte, can be used to represent an
entry for which there is no underlying page. This is distinct from an
invalid pte, as stage-2 identity mappings for the host are created
lazily and so an invalid pte there is the same as a valid mapping for
the purposes of ownership information.

This state will be used for permission checking during page transitions
in later patches.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index b58c910babaf..56445586c755 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -24,6 +24,11 @@ enum pkvm_page_state {
 	PKVM_PAGE_OWNED			= 0ULL,
 	PKVM_PAGE_SHARED_OWNED		= KVM_PGTABLE_PROT_SW0,
 	PKVM_PAGE_SHARED_BORROWED	= KVM_PGTABLE_PROT_SW1,
+	__PKVM_PAGE_RESERVED		= KVM_PGTABLE_PROT_SW0 |
+					  KVM_PGTABLE_PROT_SW1,
+
+	/* Meta-states which aren't encoded directly in the PTE's SW bits */
+	PKVM_NOPAGE,
 };
 
 #define PKVM_PAGE_STATE_PROT_MASK	(KVM_PGTABLE_PROT_SW0 | KVM_PGTABLE_PROT_SW1)
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
