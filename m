Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC1FA42
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:32 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id h4-20020a5b02c4000000b006bc192d672bso6407158ybp.22
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=zMMa29IOKRuBRKGef+8aWzOunBJP15UEFePko7UD55HJ+FNIHBfpCxBiYLwA4KrPMI
         TXcxXb9y/adMoBvbQuUDakImCwwN7Z4WEP2SZZpo9edmYTz15OkBTw6/P+LQhZtW+99u
         pzGGV25kB4qysY7wAtKFo8vPAijY9xFoyV/3Si9e2W69zzO5Msco6CN5mAKQrlqf1Xp6
         K0EzM6EwQhCMqsJw6/BH3VpXeodJIWx00sS526Lq1e7iIPc8bBEGR7mONHb/q0nNAC+k
         UdsBP9VUPJm2xY0dmxsNjNEXqSUzu8PUkfIscBfsbDOUP2dmFsDk7FwVXJA2dBam/Ya9
         Z8gA==
X-Gm-Message-State: ANoB5pkv3hAyU+oCHNxbnS/T1MFCQ9Qs8sPQDOHAU1IwSG5cUmSOwrWo
	W/UKCesstHZUotsxvChd5VF/7BGLi983kw==
X-Google-Smtp-Source: AA0mqf4ZMSd0IbLoI1AkRzAZK/OQcoH6q02SDUxTYBq2QG+Ba1y2BEB32tCAZcmlr2OLtCGGticIz09bJ4TPjw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:55d4:0:b0:6ca:363a:9a1b with SMTP id
 j203-20020a2555d4000000b006ca363a9a1bmr5130852ybb.1.1668241051339; Sat, 12
 Nov 2022 00:17:31 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:10 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081710.JjHFq00yP__mlYv63TTRybezHyM8zf1u1Fclp52POAo@z>

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

