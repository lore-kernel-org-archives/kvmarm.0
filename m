Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1E853B5
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:59:05 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id e11-20020a17090a77cb00b0022925dd66d3so8955919pjs.4
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ned5ZH8F69GPFdj4cuN6WK5vFKhDB+aqB56zYhL8gAM=;
        b=V5/nDwgUHHF6CWVuMNYTpzf9GNUV0/IEDAjTALBiNrylNWFmIPY5WFXEJ3yqe4n1q4
         PZP25IJMjYJRup8+5Tdgp6vitrhxT2tTiNjHi3YMp5/Q2T8ezkBUgYh5ixbzSyofSJOf
         h4mkHAOplb1MwZE/F5dNAxniXBuX/xolqd4SBRIPRx5x7Uu2rMw/VrZA/XH+8btGS0Aa
         aXvMadlh/D+Wyx+khVqbAVPVYU6aWRaMDVCZtQ9wdmazIb/jJV3rDc+eDsv59MlERKwm
         9s+gPXnoA8Wt2yUBhHToh/6iflaIrX13sJaHyVLyVBLxoc6xNwVWTfS/dQ/Du74cDZO1
         Ddrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ned5ZH8F69GPFdj4cuN6WK5vFKhDB+aqB56zYhL8gAM=;
        b=KltbUJNiVdddT6aaqQpEaWtoljyClJarwYfwKZKmkNWlztzDiu2+3WYf+QrG0GWs4J
         SEQyEPaCdIpnFe7rZ4feDh568Ew1Po4taeb2WWaL7YmIhYfIE8QrhLWVKKs5xeSMiGwj
         T4E0og5vgjwNrVCiIY9ZzazwVeSQ9jFUoWTYHlCdKLsxPwxLXgfevxDA22syxsBCLyB0
         9LPS2E9chjkDTysH/QryWF9IBVWt0f7q3JLpQrusRbrIUnGolMqXI0tu1FZGAZfEfifD
         TdMhffzIaT7IT7LXMD6HN6/KjCoTXhVZ5zZvyHX7bP9Lu/OiiOqoQL+QJRoA01M7VMQm
         9/YQ==
X-Gm-Message-State: AO0yUKVxFhwGD1OkE2akroFl+PrjwoQyU5uvfEBDffJOeW7TI4pzRH+h
	A+uaT6zrXxN5SSoPHcKqDMFKrVjgKD+TrQ==
X-Google-Smtp-Source: AK7set9fNVVKWi71d4Mx5UI1FkBgjOML5W4imqZGeHvkXnc95/ruYP//2mmjpRMKpD7hf/wYCKXhTBjf6u6VnQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1a:b0:592:4daf:20d6 with SMTP id
 h26-20020a056a00001a00b005924daf20d6mr7056pfk.43.1675702744554; Mon, 06 Feb
 2023 08:59:04 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:45 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-7-ricarkol@google.com>
Subject: [PATCH v2 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
future commit will add some more things to do inside of
kvm_uninit_stage2_mmu().

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
index d2c5e6992459..812633a75e74 100644
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
@@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_uninit_stage2_mmu(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.39.1.519.gcb327c4b5f-goog

