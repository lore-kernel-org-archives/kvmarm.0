Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A5C4C93
	for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 18:40:49 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-4c8e781bc0aso29760687b3.22
        for <kvmarm@lists.linux.dev>; Thu, 26 Jan 2023 10:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFZa9l3vyucfCG4Eq3J8ahjsI/hEp3XR7lOR7mP5Tis=;
        b=VN8PcPha7Z2Hg2wUqIDXSVB9mIu3m5t7TqCWhS7ECVnfl8R6VT46nDUUpIdPd8qYIu
         sPbmuYUrqofSVjFpAQL/fHfGTywYaxsZmAQ4hg3IUfTCV8TgsrkwIG8rB6V8so/pVILl
         FbZnf6P1zimoFc9xDC9Nk70G/4VeIh3saPIAZ7GaELcRYjZXPiiuTvAxlL2J7MK+GgBB
         R79bSmOGc2ymgpjljLv3Gs+t2Fpik0oiOCH+4+ATd2NpUHX4NQuK4+vww/XPqJ3KVOzW
         Dzdepdf9i5pi4SZVLHZGzkaG3RO4gSy6JIe5EWncXIGCyemgDUkXQuACg068oRZAaLUa
         bEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFZa9l3vyucfCG4Eq3J8ahjsI/hEp3XR7lOR7mP5Tis=;
        b=E2nJjcaF6BLQ2mKpLi1T2uF8Vxo2g+2EmgLQ0kPD4MWUkga5T/oFc/ZWPvNnfvq7A9
         vn7BrJVBbBU+pBJ6hLoMb/mmh2g6Nfq08E/vijrqxPEMay/Svv5JDz2ja1soFnrlhwo3
         5mgsP7R/HMAhRQRWd7ErW5QlDVB9NKh7m0nnhP0gAUohs83CZ3bWslqV1gvj9iklYTRg
         IodVborOmNlRCWme/TjQROQnPkcWOXVh5CMD+m9ltAlXW5wtnoww73g+HuUB8c/YdYQr
         wyMDJ84ww0esHVAd33F8EZzmTakSMB0CJlLwudYK4yI6dlRo/ws7NzD0Kc7s4X3Mi5Eg
         eiIw==
X-Gm-Message-State: AO0yUKXSIn+guhLactTLq+1xlsLGkN32asK+1yc49p+xdDEgKlspQxgI
	bsiA4PjY2O/ofLt9qkEyuPvA+OhcVC2bUg==
X-Google-Smtp-Source: AK7set+zuBoUhMsYx0pNBabOkZre6s4lpq4SlxleAkv4G0uh1Va2tnBH9KvK2TQFyhdS6n4IjKUpzb9Uws//rg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:5204:0:b0:507:86ae:c733 with SMTP id
 g4-20020a815204000000b0050786aec733mr835986ywb.358.1674758448911; Thu, 26 Jan
 2023 10:40:48 -0800 (PST)
Date: Thu, 26 Jan 2023 10:40:23 -0800
In-Reply-To: <20230126184025.2294823-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230126184025.2294823-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126184025.2294823-6-dmatlack@google.com>
Subject: [PATCH v2 5/7] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Use gfn_t instead of u64 for the start_gfn parameter to
kvm_flush_remote_tlbs_range(), since that is the standard type for GFNs
throughout KVM.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 2 +-
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 215a8b7f5e03..34b670e719af 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -247,7 +247,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 3bb21d29d84c..0dba4d8304a6 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -170,7 +170,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 
 /* Flush the given page (huge or not) of guest memory. */
 static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
-- 
2.39.1.456.gfc5497dd1b-goog

