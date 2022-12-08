Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D417EC10F1E
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:39:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E7E4BA1C;
	Thu,  8 Dec 2022 14:39:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r0Bjh3lqiKKP; Thu,  8 Dec 2022 14:39:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B40124BA2C;
	Thu,  8 Dec 2022 14:39:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DAAE4BA21
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bf-gTur7G4PF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:15 -0500 (EST)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61DDC4BA12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:13 -0500 (EST)
Received: by mail-pg1-f201.google.com with SMTP id
 e37-20020a635025000000b00476bfca5d31so1608110pgb.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=zPqhilQnjSVH+DKsiF3UuxsA3mWYraWvqkpSQiCn4mk=;
 b=iEvz84VootOQzL2fuUOye77ff0RBTUJwBPc/nCp9n7wqfMIJewYjnWs+e+UV8BdMIw
 elYqajuLHReDubNQsxzeD4LQOafn7i58BjesdxlcK+vzw+x1HQo9F7VP57LAnqtKoesr
 UywCJYsjvD0BlUoCSDFWtr6dHwgWaW3JtPzOAkFIkkT8WGiWMzZ2oAHhyStfBm7eJSsS
 38EqRrqfu/Bb+ppVcaHkYCPUXH92lKxDVFDbgcDFRtoe1sRIy80NzBB22C9JYr71mn8T
 A1Ozw0Mgmaj7KonevqN/mmVI3ivsgF7FtLFAmhFybNP5PHPBvBWnlJEVJf0pakv7c2rW
 r4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=zPqhilQnjSVH+DKsiF3UuxsA3mWYraWvqkpSQiCn4mk=;
 b=F/DAXCswTjuXFlHClsor4eWAA7b8Q1QQMgNqLAk9Dne+zWHPm8FWyujhF869ux0A0m
 GZIF4ge27SErRb5m+HSiXvxlNI+9P2oDvLrvihJjMRS7vnGfm7cqOoH96LrgyLL8Z/5U
 PImX47Fyjr98gpuvEAMeqTnZW5X7jFR16vOQcUC9PzJ6UL41prpz2jdtEiL6MsQCxEtw
 MWXPUvj23jglfEToAij/ysMNeDxGihWVGyqOXusKe3st6mIuqAH4CkGDnCXFZPIWaUEQ
 R9Sh7hwyCJd08ggrAsGNbG/8a5JDlOVxAVVaGvUO0TMsbLeoR1pt9EQvKK9v1icNX+PA
 jHJg==
X-Gm-Message-State: ANoB5pmewaYpe6QGZdbbfSw9SeuPgk3kQQGoOKTp+rh8+MGJdejKbMvE
 M3EjlAqvWxUuEvGxG+0V7s7cIVL04UwtCg==
X-Google-Smtp-Source: AA0mqf7eM5A3bS0eYMJF7BGmyZN+evZ/sdXM528vLtaTteWzbjmMBYJhb583jjAiLFnL4yHJF6g542RYvvvpWw==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1623:b0:577:4baf:f412 with SMTP
 id e3-20020a056a00162300b005774baff412mr10161002pfc.77.1670528352538; Thu, 08
 Dec 2022 11:39:12 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:23 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-4-dmatlack@google.com>
Subject: [RFC PATCH 03/37] KVM: MMU: Move tdp_ptep_t into common code
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 kvmarm@lists.linux.dev, Nadav Amit <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 David Matlack <dmatlack@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Andrew Morton <akpm@linux-foundation.org>
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

Move the definition of tdp_ptep_t into kvm/mmu_types.h so it can be used
from common code in future commits.

No functional changed intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 include/kvm/mmu_types.h         | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c19a80fdeb8d..e32379c5b1ad 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -44,8 +44,6 @@ extern bool dbg;
 #define INVALID_PAE_ROOT	0
 #define IS_VALID_PAE_ROOT(x)	(!!(x))
 
-typedef u64 __rcu *tdp_ptep_t;
-
 struct kvm_mmu_page {
 	/*
 	 * Note, "link" through "spt" fit in a single 64 byte cache line on
diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
index 3f35a924e031..14099956fdac 100644
--- a/include/kvm/mmu_types.h
+++ b/include/kvm/mmu_types.h
@@ -34,4 +34,6 @@ union kvm_mmu_page_role {
 
 static_assert(sizeof(union kvm_mmu_page_role) == sizeof_field(union kvm_mmu_page_role, word));
 
+typedef u64 __rcu *tdp_ptep_t;
+
 #endif /* !__KVM_MMU_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
