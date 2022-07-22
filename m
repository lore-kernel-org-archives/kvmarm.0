Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA1AC43334
	for <kvmarm@archiver.kernel.org>; Fri, 22 Jul 2022 01:51:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B6D4C86C;
	Thu, 21 Jul 2022 21:51:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m9wGzD1Xcyj5; Thu, 21 Jul 2022 21:51:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A44144C88A;
	Thu, 21 Jul 2022 21:51:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDC7E4C864
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eDMqkgeZqz3q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2022 21:51:11 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A2E664C859
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 21:51:10 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31e62bc916aso28521357b3.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2022 18:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=cXHHG5JyJT6/zfSdYwcZ5hplI/Zwtw5pce4ngWT2RP0=;
 b=B/196tHwJZGxwdFpPDFtGgET20t1oaPOi+B7MforGvjteQqAubrBbnDQDcEDABfdFN
 3DK9BLo4bXahlAM1Zsxz6zcxuz6ugGDvcoav9uuevoCJW5/jGeVxKgcMDWkvWNt+YlYE
 YGooogCFEZU+f/gGBwXExbBhTXJG7xpnwCN4d1QjLWLCX6p/euCGwNgqngATINfEafUZ
 vmxSUdXRy8210cbejvc/kzSbNqREBTwRlsnUJ3CeOb7E82yXcf7pGch9UX8WepzcpJGw
 gVDLrfHbXsI5qYh6TeA8MbgK6BZW4I+5FNvZUO3QAWxqrGa639qAV9IpgKC4MjSspDJg
 W3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=cXHHG5JyJT6/zfSdYwcZ5hplI/Zwtw5pce4ngWT2RP0=;
 b=LQvRfJuJ1JDg3klpB3VDcFs/A9vJVHRUnqlWJN+d3AlzeOT3mLPK8mNWRQHO5XY7fg
 IRQjJbqw2U7S/n2W0gHZLg7zibjZYE3jToqL3C2THAtTZLd8iPnuZ0eqNaz5F6Mp509N
 WVB17yjAmbP6BKUrTx8vN7ZeqONll69D61qZEv2hiXKXKeACOFYomsbPJMENWTSL3zAw
 Oaytr7D/GDu9BJ3d4BtS0l89Ih8CXpiyxY+Qe/yc5Q9gxXYAT7NXjHptAFSb0BN2Y+ta
 DCehDcUVEgCZ8VEg/96u8dDUpUYt708f1DkPvP7Vg0LxRrMHzVoXTHjbxWKej+bCGfL8
 iedQ==
X-Gm-Message-State: AJIora+zqbD0Ecg3AEJ3gsfu6zxO4qsWPRUBkgiV69d5M0AkfgbX+/jI
 XPUoH1R1w1IeYxy/C44vKg0k0ug=
X-Google-Smtp-Source: AGRyM1uyeQgFMIiL2ECknr9YM3j6WFlHrejpaFbSL4QcZoqTrnLYKShMPao1gximyv/6/63IGwrd5rM=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:7ed4:5864:d5e1:ffe1])
 (user=pcc job=sendgmr) by 2002:a81:124b:0:b0:31c:fc99:d4de with SMTP id
 72-20020a81124b000000b0031cfc99d4demr1273232yws.348.1658454670287; Thu, 21
 Jul 2022 18:51:10 -0700 (PDT)
Date: Thu, 21 Jul 2022 18:50:32 -0700
In-Reply-To: <20220722015034.809663-1-pcc@google.com>
Message-Id: <20220722015034.809663-7-pcc@google.com>
Mime-Version: 1.0
References: <20220722015034.809663-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
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

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d54be80e31dd..fc65dc20655d 100644
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
2.37.1.359.gd136c6c3e2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
