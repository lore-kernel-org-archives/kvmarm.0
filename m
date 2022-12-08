Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3448F71
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:56 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id f11-20020a5b01cb000000b0070374b66537so2542160ybp.14
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=3ivvUOdXcF1lKBfZXlwOBQlc9Hvptnrt6kliV/FFkU6t1CkKz6ku/Ns6li/ZX9pV8L
         35jrwVI3YoqKioK/tZ2sSJCc3pO2n/Fy6zcVnI8IIym2z2W6YXHgdbHuk8RcsQOlYJLU
         T/mtlYaUfCGwtlu4TffkP+aKpAUEgKmJF7gLbA99gcRZWZY4qS+At2It+KyUXELCsE33
         AZ48aNr2Dhn0lC/J9PxWHRmGq3e/sqm07VSmbp7r2dR0YDWqF71POgujZljMnTy8JBtG
         IGRJHSbC4RXuP6njUfInfsmS+sYF4K8MzoRr2jZNB1Gx0vhkhgeHDIOkPG3oc4Cy8isT
         wPkQ==
X-Gm-Message-State: ANoB5plc2TinXyzSdCqFHRE4qc5PDxRK5/J9FVR4TMXmhA9id6aikJ1K
	MofZMRwv3enaIHtdZ5eU3lZTnSo7aj17ZQ==
X-Google-Smtp-Source: AA0mqf7NcSr4AIKU//qVuXa9coH1f9XMOTx1jz8qMU/k8ctWA7f2fWXafNUay3Wq3KgA3j2vNzHhSJ2naqJ0zg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6309:0:b0:3b0:773b:2b8f with SMTP id
 x9-20020a816309000000b003b0773b2b8fmr1555613ywb.350.1670528395580; Thu, 08
 Dec 2022 11:39:55 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:49 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-30-dmatlack@google.com>
Subject: [RFC PATCH 29/37] KVM: x86/mmu: Collapse kvm_flush_remote_tlbs_with_{range,address}()
 together
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Matlack <dmatlack@google.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Nadav Amit <namit@vmware.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Yu Zhao <yuzhao@google.com>, Colin Cross <ccross@google.com>, Hugh Dickins <hughd@google.com>, 
	Ben Gardon <bgardon@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Krish Sadhukhan <krish.sadhukhan@oracle.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221208193849.T5Pb-ZdlKtNGCwjAEuJzI2FxnqqtA_wZ9AC3i2jiD6Q@z>

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

