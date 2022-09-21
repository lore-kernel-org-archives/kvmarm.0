Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57F01C6FA82
	for <kvmarm@archiver.kernel.org>; Wed, 21 Sep 2022 03:53:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 124624B824;
	Tue, 20 Sep 2022 23:53:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cNFJJKwKBcKu; Tue, 20 Sep 2022 23:53:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E75FA4B7F8;
	Tue, 20 Sep 2022 23:53:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B8C74B7C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bi0SdZRfaeIF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 23:53:09 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD4444B81F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 23:53:08 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-348c4a1e12dso41442407b3.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 20:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc:subject:date;
 bh=l32Gj8DFEI8fLqucJeW2Rbzgq3dj8DyhNV3q0+UkQLg=;
 b=XuosAkkktXXWMgAJHuCQa6UGl0+k/yysrZg8b+tKU72U2p9L/09e0hmFFdbpFORH8V
 vTILz5cc/H+dABEvWXOa0Q96/hCZZqtcjG6GDq9EnJkg1HRbHUdnGMBvgxgXxkD9eVhg
 3mESCk3cMrCrJNyO444O2KjWFvhL+u7B8U8iyrT2z2rQsl/Atk7HTwqj22cvRTddvz5V
 /9XStQt610oFcuHnUCacx/6zTnRV/jgFzTs0rOpnX2VLj6/BcvNplLLaWguL+DWjExP6
 E/0WLMczgDZY2C1h/uArgrik8gj1VT8Z5HqD+l0KltnMuzSx9/uO4IE53pibPPLBUHoA
 GLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=l32Gj8DFEI8fLqucJeW2Rbzgq3dj8DyhNV3q0+UkQLg=;
 b=at6QkEwulmR4EViehvGiIZIcPemxaxbnYSKMTeNYsaVeeq7hdzumBNlImLpo5nIfMM
 8RFPRF0vcJwbSEVrfZAb6KP20A6YuskTQWsEoge/z1WFmW95PJIU5DVTzhOoOEHQAOIr
 gUPjrXyOjCULmqBqv5BdhNhenkF0NaD9IVybLQxEzAjJp1Wp1IIu2IrBOrU9pFP5r/so
 HChQHRAyZeO+zPXQ7CEWq/yC5xaQJ88k/aJ58pQi4Xq1cyJ3PcNctoJ1kF8a+qIpud2u
 CWyQbPPWpzJ9bEz2KfwM5JNmR7c0Al3UwXhur/SjnoRvuXiWbmU65NQjQxMF9huMH2NF
 hqjQ==
X-Gm-Message-State: ACrzQf2FigPtrRP/VEUd8u+mtYsVqwfF+q6GFG+DLd7SuN5gXdFqgwu/
 a0v/FG4Dcr4jMq2w8h970y4UbfI=
X-Google-Smtp-Source: AMsMyM4k2SLq+xH0pc9iLcqj7V+ZPh7OXwHnlc3w1WiBAqn/qKtC40c1YU8Rcz5OMXlTDVVr0U6HpDc=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:1b89:96f1:d30:e3c])
 (user=pcc job=sendgmr) by 2002:a25:d70b:0:b0:6b4:1ed6:24b2 with SMTP id
 o11-20020a25d70b000000b006b41ed624b2mr9467270ybg.268.1663732388240; Tue, 20
 Sep 2022 20:53:08 -0700 (PDT)
Date: Tue, 20 Sep 2022 20:51:39 -0700
In-Reply-To: <20220921035140.57513-1-pcc@google.com>
Message-Id: <20220921035140.57513-8-pcc@google.com>
Mime-Version: 1.0
References: <20220921035140.57513-1-pcc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Subject: [PATCH v4 7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
 MTE enabled
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
on being able to map guest memory as MAP_SHARED. The current restriction
on sharing MAP_SHARED pages with the guest is preventing the use of
those features with MTE. Now that the races between tasks concurrently
clearing tags on the same page have been fixed, remove this restriction.

Note that this is a relaxation of the ABI.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index e34fbabd8b93..996ea11fb0e5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 
 static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 {
-	/*
-	 * VM_SHARED mappings are not allowed with MTE to avoid races
-	 * when updating the PG_mte_tagged page flag, see
-	 * sanitise_mte_tags for more details.
-	 */
-	if (vma->vm_flags & VM_SHARED)
-		return false;
-
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
