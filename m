Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E91C4167B
	for <kvmarm@archiver.kernel.org>; Thu,  8 Dec 2022 19:40:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EFA24BA8A;
	Thu,  8 Dec 2022 14:40:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 91ZbxZt1O2xJ; Thu,  8 Dec 2022 14:40:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D970A4BA96;
	Thu,  8 Dec 2022 14:40:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3016C4B994
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4VrmiyMAv5o for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 14:39:57 -0500 (EST)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F21434BA32
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 14:39:55 -0500 (EST)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-368994f4bc0so24899467b3.14
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Dec 2022 11:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=IGXwNDL4QYyEmLxSnzAicnadmof6UqucM+DSeXyfLbg=;
 b=e2wlSIbIUNSSfaa5cE8nlhbofFQRnDINdERr5/zptolHxRg/aPkZUAkV/kMjTwqvnL
 VAny0I7JM9mmYwlM19HgFZ4z/Bt+AByLMvJNwn4T4fl0KwFC3zH/PllsEXxvlbxKUkc0
 NdMHxpCwQrIPT0+bestZB+Anm+CNeXCBzxYs+7pB5OowuPNVic/k7alXblYXNWUiyNRn
 3s7YLdEKTaInLDTRes3bQcWtyjH3N9OVLHAzY6Bg1V5A6pocb3CfBR9ECK9NIDh6py2b
 FQXi6i4x7GPqtsNYbTReUTLXYmSwdtvZ+/Ai3ANOoadydeN1zSK+lfHKCn5oiJ5BQfNn
 SJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=IGXwNDL4QYyEmLxSnzAicnadmof6UqucM+DSeXyfLbg=;
 b=g4c6GiTh99d0xJ3i99929OJ8lgCqhs+U0iU7ot00DyY0antOsej8YkWn9/7jpLB/OO
 YgZb/I/d/IYiMIGiUoNBFcn/mS/MknfUjj0Ql7B8jO/TJeTzGFUOEhaqoOdTfntEJNY5
 4OKwvrNSrlHNdWrqf1TJamKhA9LwEpwnBbglsOclcHNXBf4iGuQ2ZZEZAQJXF3E6c/fG
 bF995PObLGy0PHvOnJ3mndd3YmHbvgjxwJFvmna3pHgn8yX2cBczc39o5jiREuGC8Yap
 NEx2/iFtetwQyU/DQoVX9XQitIy26zNPvsaisNRbEn+wh5JLe010uVQHAhfZ3zmo7gkZ
 +xoQ==
X-Gm-Message-State: ANoB5pkieqkCfak+YWpYbssAjQiOkvAuC97UcL0h+9I1NJyS9pbVq5/y
 I76wxEiXGhiwAJV2eEoi1SZ3PwBKAAtfiw==
X-Google-Smtp-Source: AA0mqf7NcSr4AIKU//qVuXa9coH1f9XMOTx1jz8qMU/k8ctWA7f2fWXafNUay3Wq3KgA3j2vNzHhSJ2naqJ0zg==
X-Received: from dmatlack-n2d-128.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6309:0:b0:3b0:773b:2b8f with SMTP id
 x9-20020a816309000000b003b0773b2b8fmr1555613ywb.350.1670528395580; Thu, 08
 Dec 2022 11:39:55 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:49 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-30-dmatlack@google.com>
Subject: [RFC PATCH 29/37] KVM: x86/mmu: Collapse
 kvm_flush_remote_tlbs_with_{range, address}() together
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

Collapse kvm_flush_remote_tlbs_with_range() and
kvm_flush_remote_tlbs_with_address() into a single function. This
eliminates some lines of code and a useless NULL check on the range
struct.

Opportunistically switch from ENOTSUPP to EOPNOTSUPP to make checkpatch
happy.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f01ee01f3509..b7bbabac9127 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,27 +244,20 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
-{
-	int ret = -ENOTSUPP;
-
-	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
-		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
-
-	if (ret)
-		kvm_flush_remote_tlbs(kvm);
-}
-
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 		u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
+	int ret = -EOPNOTSUPP;
 
 	range.start_gfn = start_gfn;
 	range.pages = pages;
 
-	kvm_flush_remote_tlbs_with_range(kvm, &range);
+	if (kvm_x86_ops.tlb_remote_flush_with_range)
+		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range);
+
+	if (ret)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
