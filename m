Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42DC3DFEE
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 18:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQYDwaxV"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1cc252cbde2so6362835ad.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698430993; x=1699035793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+S4AiipPfUUKpJ2ruaZ4ElxK7cYS7w8+XYANZ6GAwNM=;
        b=WQYDwaxV/57eiGsw8mz0Um1Y0eAUNSMgTz5wxBMPD+EukESKXgveyOKjeqyPvyRTvN
         Ai60Qw61RBED88bycZQe+V4ayUHS+G9I7vTGN9Hqei5JmdsPNjlFcmhRGZBzazb9qgJe
         QuzL/7/5DoQUWXMt8iPXWSQkXrqH0N0cmjxeAXQlHK3DM/+1QgMPnoJ5x31yd3pUKNfb
         mqCcJ1c4WPvASvQYFSwad1RMxcb/KHRhlCBNJP8jehEwvJWPL4+Hag2LoJx3uQkaFa2q
         mFQz0f+JLnowaHb4qsGZ5fAFXseFOkf794YYkYvsUuONdddxr5xKhwhqyKdUrQMF1+TZ
         YFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698430993; x=1699035793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+S4AiipPfUUKpJ2ruaZ4ElxK7cYS7w8+XYANZ6GAwNM=;
        b=CAnRrQRatLaIW3VLe/ubYkfMod+s4kZhxDIwzB6x6Ga+Emo8O1Dj9qTpZZ6ZAViCWy
         zIttf4F1wiIOiXVqHN1NRL6ahkZAPaJ4qQVBmYpDmQ+309mKWVZzPBNRTHYuqb+un3Fn
         w3aa9xNXar6Y1SNSoR9NCt4I/8A3M0wG76N31AZHMqqPK8vJ0uW5IIOyxugoxsXIeeC1
         t1KMRfwQZA27jj65KtyyXVSm2YVnhYgn+NTXh53BUb+o79faAeif3lIn7LIb9RydykQV
         d5D8GaUUSNe3Mz/+mUxHh/oZwFaPu7rLJ3RoSAbIlohZ2Ly02cLUK0IoJpqhnNK2z4nL
         oTGg==
X-Gm-Message-State: AOJu0Yzp7WWgCvTkWiPAJLXB4mjp6aDvn2TulzUviLbsjr2JnQZrCiNc
	kO54vPQrhacZe9HCV2FDJJsHjpRIvoo=
X-Google-Smtp-Source: AGHT+IEqIkKuv5DX25uHuP2fYVc0fUSbsifhQGdV1yLQ889bX1DKci/qdjsCIFlDcD5dVWlFtax8M8nrsME=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:4296:b0:1c9:e3ea:750d with SMTP id
 ju22-20020a170903429600b001c9e3ea750dmr58852plb.11.1698430993223; Fri, 27 Oct
 2023 11:23:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Oct 2023 11:22:06 -0700
In-Reply-To: <20231027182217.3615211-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.820.g83a721a137-goog
Message-ID: <20231027182217.3615211-25-seanjc@google.com>
Subject: [PATCH v13 24/35] KVM: selftests: Drop unused kvm_userspace_memory_region_find()
 helper
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop kvm_userspace_memory_region_find(), it's unused and a terrible API
(probably why it's unused).  If anything outside of kvm_util.c needs to
get at the memslot, userspace_mem_region_find() can be exposed to give
others full access to all memory region/slot information.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 -------------------
 2 files changed, 33 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a18db6a7b3cf..967eaaeacd75 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -776,10 +776,6 @@ vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
 	return n;
 }
 
-struct kvm_userspace_memory_region *
-kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
-				 uint64_t end);
-
 #define sync_global_to_guest(vm, g) ({				\
 	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
 	memcpy(_p, &(g), sizeof(g));				\
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7a8af1821f5d..f09295d56c23 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -590,35 +590,6 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 	return NULL;
 }
 
-/*
- * KVM Userspace Memory Region Find
- *
- * Input Args:
- *   vm - Virtual Machine
- *   start - Starting VM physical address
- *   end - Ending VM physical address, inclusive.
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to overlapping region, NULL if no such region.
- *
- * Public interface to userspace_mem_region_find. Allows tests to look up
- * the memslot datastructure for a given range of guest physical memory.
- */
-struct kvm_userspace_memory_region *
-kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
-				 uint64_t end)
-{
-	struct userspace_mem_region *region;
-
-	region = userspace_mem_region_find(vm, start, end);
-	if (!region)
-		return NULL;
-
-	return &region->region;
-}
-
 __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
 {
 
-- 
2.42.0.820.g83a721a137-goog

