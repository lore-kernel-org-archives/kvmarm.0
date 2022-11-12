Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B38C43217
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BBC14B7FD;
	Sat, 12 Nov 2022 03:17:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OvhZA+1ni+sM; Sat, 12 Nov 2022 03:17:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B71F4B83C;
	Sat, 12 Nov 2022 03:17:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 160D74B7D8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 39BJyn6SU66d for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:32 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE2EB4B78C
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:31 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 y6-20020a25b9c6000000b006c1c6161716so6316332ybj.8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=RSyLO/J2OZ8IR7rCygIEQwqWF34HE/cmjvAFbCy9UCk=;
 b=XbNV/sOYK22JdWgiTH2gTYZIZ2JAdMLBk35z3CQYb9CTn32I5GDB7F2rCRA/X8mLqw
 hH3HU3TvXgNkR/bnpfpu2xp6vtr7lVL3bn9y1FtnzGCPsCxDYpfzSX0KpT5zMfrzBvnY
 MK9M3SBR81XIYkfchgW8VkXotC21Tf5BmVzIfh6qF9tjayEV1QQiaWYoxaHXShhM3W9a
 ZtA4yi5lV73TrxL75et+sWVbmdDdPGmHgYhLGiQqaxlNGq/N9YpYbdSQ1km43Ko86JXl
 fqYEOvtyvPKXP/TJ0YAuWW0VmMtXNAwuZ16w3/1bB30kWBhrPswOXP6F2LdSVkCzxiq7
 /k+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=RSyLO/J2OZ8IR7rCygIEQwqWF34HE/cmjvAFbCy9UCk=;
 b=oFYr6Cpky6Z1wB/IA7WY5uooSuv0xTnQWsVVxUJcz8+InVjNmUbKWnQcVDCLwOCqYG
 x6CHA+TAt3/yNsWJqyEVyW0FjIPcmhORYd1IQP3xv1fuiN4W8aIWueCDh9rlykAglNUA
 fnV8W9osa15f0si18w2yhh3Ur22cecUhrj8+hY+uBnpiljMHfVkz9r4CuWGe7qUW+IRK
 NQvJ+hGJ2XJqKNvf0FROPEQCEj/5Ebtm9org5MRrf7PAT3XxwHEfaJ2KsQ/JpaEu0w5Q
 brb6vcnkNO86q/wYYt+ArqfwIexEAdVLeuK6HIyu24/AL1AICS+fDB5Y2xu/NxDTODvm
 V+sw==
X-Gm-Message-State: ANoB5pn0aJKicJGU/3wyqg+uM90BBJNgD4CVKVB6OL39C5VzKGAXP3/4
 Tp/jvlA5BC+x6ylWbWAdCUY24PNJ3CxXxA==
X-Google-Smtp-Source: AA0mqf4ZMSd0IbLoI1AkRzAZK/OQcoH6q02SDUxTYBq2QG+Ba1y2BEB32tCAZcmlr2OLtCGGticIz09bJ4TPjw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:55d4:0:b0:6ca:363a:9a1b with SMTP id
 j203-20020a2555d4000000b006ca363a9a1bmr5130852ybb.1.1668241051339; Sat, 12
 Nov 2022 00:17:31 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:10 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-9-ricarkol@google.com>
Subject: [RFC PATCH 08/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd()
into it. A future commit will add some more things to do
inside of kvm_uninit_stage2_mmu().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 1 +
 arch/arm64/kvm/mmu.c             | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index e4a7e6369499..058f3ae5bc26 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -167,6 +167,7 @@ void free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
+void kvm_uninit_stage2_mmu(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 			  phys_addr_t pa, unsigned long size, bool writable);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6599a45eebf5..94865c5ce181 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -766,6 +766,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return err;
 }
 
+void kvm_uninit_stage2_mmu(struct kvm *kvm)
+{
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
+}
+
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -1869,7 +1874,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
