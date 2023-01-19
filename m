Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592EAA94D
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 17:36:20 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id 69-20020a630148000000b00478118684c4so1315560pgb.20
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 09:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c0SS1XLwsBFZ40upMmt6qRjU4c0qpX4m+4RA3lz+crc=;
        b=bRTUL9THslA1WY3C6zfQ1MAdQYPay9Jt3idYcFlPDFpT0P4o1+XdpDhUeIk2USmwqG
         D3KWQ2FFy3WJkFP9lARnX3e2e5+KhWdYytuOptPQtHynN/RZhg3lvRYJ1+tDBSadgtps
         wX3mEXowuzhodMcGekL2PsM6hfEXUHRivXQGF0Q29dG33K4Rv5+lelnHW3mcP/8E3OxY
         qNPsUHH4GMaFwBF+QLlhLNR1zHxYzEPnBpWfOlG2W1lShRazOpwLppupOCoEm3ciHxk3
         OsbBJeAM+1GFVBPMGCcS7Q866gvCz+lnaIzAW6Qyf3Bq9YevZj2TcF9nD2jvuYi68kxn
         b2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0SS1XLwsBFZ40upMmt6qRjU4c0qpX4m+4RA3lz+crc=;
        b=vcPMgbeI8zY5BW1cZqJP2vMgge4RlqX35mGWGp/KJvvYu3L8UvO9DdJ/SIzaUiQt2K
         /gr6RoiVMsMNaBzBxLl5OcLtZco1EqM+KEAa3K6CatMFZEljdg9Vx5fX9RBoWgyOYqCp
         kTakP2lvBYWPQI+gnewv4mFwZGfqAPrtZb3sPQNM9w6LKkkEi4sA5hCane18P8c2cdS4
         HcSMJqJEnFiyqXfyhSgbyj/B3PrPcyOG2lq1YGIUBM5dc6AGdCceBSOxoA9strnwmDNu
         LIGZ7UCPf6uRANmzWhmSefsmAxOve5D1VGpBNJcpTO3NKNj+swqtGSEXhiXEosFNqvT/
         DKgA==
X-Gm-Message-State: AFqh2kpP+kawBD8CP2LYavn2JE6nFqVmO4ZIHUTNyQfLTa3ws2go8NXO
	blaP7aCv6ujy7XgmqIBY8X/dbvwt3tFl8w==
X-Google-Smtp-Source: AMrXdXvbTmwzuJAuBPKJsyHR0snVOekSSTxs16QNlqhF8cG4iLKN5DvuKgwpJj8AOixc6btzxFQ4Hm+pmC9GRQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a62:ae10:0:b0:580:9b0b:4fde with SMTP id
 q16-20020a62ae10000000b005809b0b4fdemr1243710pff.49.1674149779734; Thu, 19
 Jan 2023 09:36:19 -0800 (PST)
Date: Thu, 19 Jan 2023 09:35:57 -0800
In-Reply-To: <20230119173559.2517103-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119173559.2517103-6-dmatlack@google.com>
Subject: [PATCH 5/7] KVM: x86/MMU: Use gfn_t in kvm_flush_remote_tlbs_range()
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
index 36ce3110b7da..1e2c2d711dbb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -246,7 +246,7 @@ static inline bool kvm_available_flush_tlb_with_range(void)
 	return kvm_x86_ops.tlb_remote_flush_with_range;
 }
 
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages)
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
 	int ret = -EOPNOTSUPP;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e606a6d5e040..851982a25502 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -164,7 +164,7 @@ void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn,
 				    int min_level);
-void kvm_flush_remote_tlbs_range(struct kvm *kvm, u64 start_gfn, u64 pages);
+void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
 extern int nx_huge_pages;
-- 
2.39.0.246.g2a6d74b583-goog

