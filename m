Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418D8F6F
	for <kvmarm@lists.linux.dev>; Thu,  8 Dec 2022 19:39:13 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id 67-20020a621946000000b00575f8210320so1758732pfz.10
        for <kvmarm@lists.linux.dev>; Thu, 08 Dec 2022 11:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=eCbbmotEpVzqq9IazBTgNzRfKO01nCvKRh7RF3F3+PqcH0Cb6xiS6uLxa7dj7X6Fro
         +xXoXtasnrSBAEbxGZjxhhToSby8phBmSkOxVfBwbxkgYT3DdI5vr9I8yNeCV0hMlwpF
         x2gS8MniGvQlGJ7+7kt4jVyj7cCLBvRgJiHdMJ96qjrF+X3QcQVYM3Qzhv0T80PBmnVp
         2GlCL6yDIWujrrZSraSsjGBvqwVt2m/knRrqKE+A9qMQBcEkXT0tiKlZVq28J4BSQ4Ds
         0EOd+mbfAtJoibfMdBU4gT0VMIN86hbQngeNpi1PRO66PcILqBraarDk6X5dssUDT4gJ
         HYtg==
X-Gm-Message-State: ANoB5pmhVcJqPzbEWx92wmEtDajokVg5ad9Ui3yBNKbKdFnjm4QIFIny
	Rtym9NwSRhSsdZNEjMGKsJqvqvLMWPg8ug==
X-Google-Smtp-Source: AA0mqf7eM5A3bS0eYMJF7BGmyZN+evZ/sdXM528vLtaTteWzbjmMBYJhb583jjAiLFnL4yHJF6g542RYvvvpWw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:1623:b0:577:4baf:f412 with SMTP
 id e3-20020a056a00162300b005774baff412mr10161002pfc.77.1670528352538; Thu, 08
 Dec 2022 11:39:12 -0800 (PST)
Date: Thu,  8 Dec 2022 11:38:23 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-4-dmatlack@google.com>
Subject: [RFC PATCH 03/37] KVM: MMU: Move tdp_ptep_t into common code
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
Message-ID: <20221208193823.LqXCy36sFN7Tf6swI3UEMmxeiLIghsgujVXtK50NUUc@z>

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

