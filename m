Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BF217ADB
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:49:22 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-573cacf4804so55413217b3.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724161; x=1692316161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v06h+ALMtOOYf7fX/Ew5y3Hfc7UGMHCjlt3bjyKHsv0=;
        b=YRRA1+3rdyppDplfs3XH3aJvhxtsAMd7YC9o1tjP/IyjupywaQyvKq+rps81DQn6n1
         IfT/9T8MBfb/05cpg+uFjPqU9WMKZxQ9fzOPBnRI+m2vIHPLSV2s/3KQGxo5DIXUHwOZ
         GdmSnQGPnvE14OEYqjCx4Fm+ABerxK8mDpsKlW+8NItJ+M4Kcnqzj3n4Y+k+3R/C1UBu
         wvL5E8Pm7bjCuwRxFwoKwRUML3nMWrNZ+3vwOtoXEZiYJEJR64OEqgs5nwKpwCN2Ct+r
         TXr64pWKwZcTWMIuNy53NUZP6UdwEiJkjqYQFxPcJ5UQJleLQ7qGIFzyDTx8Cn3NQNJC
         aywg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724161; x=1692316161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v06h+ALMtOOYf7fX/Ew5y3Hfc7UGMHCjlt3bjyKHsv0=;
        b=dJN1PozBfkc0GcFHLfvKDqrPU3r6HY2EdWX3zTq37ixgROtK2dGQAtq/x/x7BNSfxC
         BcEU+/BmSkTBOQ6mPVklFp3sMJL+oCjoC6sl3EKTtDJaTftYYBUS8rBjy9xn5ork0Bbo
         KVhrrC69YF395D7AWYsW8xQCifJkL7YHmgeeR1CLkrJXJ8NdPOR6Qv5E727QhtYxS5Rs
         O8VzFJqMjVttFwoRVg92sYeqNmyQWYctFHoZqqDMIm9uJryJIZ8r++6MYsv+jsCBQtkj
         DtBCkyIWZEWBcy3+K5mT30oQSy3s0O5BmpXI4QjbhZx+ujOFrCSdCmHOLKEnbgUdSCiK
         pSYA==
X-Gm-Message-State: ABy/qLaGZ66HhIC4nwrthzwbeYKhADHkb361LOedqxPC13A+vOCyUjNt
	rdX836rvUOzViuVcULY+zbv0g0RWYuM=
X-Google-Smtp-Source: APBJJlHpdLxbHGSEDlhfQMIka8AkYqbvfykkp39Gd8+LzOAP/g6chkA545wiuNlxw+N3wiN86qnMnz3hgbE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b306:0:b0:56c:fce1:7d8d with SMTP id
 r6-20020a81b306000000b0056cfce17d8dmr185110ywh.6.1689724161668; Tue, 18 Jul
 2023 16:49:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:45:09 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-27-seanjc@google.com>
Subject: [RFC PATCH v11 26/29] KVM: selftests: Add KVM_SET_USER_MEMORY_REGION2 helper
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Peng <chao.p.peng@linux.intel.com>

Provide a raw version as well as an assert-success version to reduce
the amount of boilerplate code need for basic usage.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  7 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 856440294013..334df27a6f43 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -492,6 +492,13 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 			       uint64_t gpa, uint64_t size, void *hva);
 int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				uint64_t gpa, uint64_t size, void *hva);
+void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot,
+				uint32_t flags, uint64_t gpa, uint64_t size,
+				void *hva, uint32_t gmem_fd, uint64_t gmem_offset);
+int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot,
+				 uint32_t flags, uint64_t gpa, uint64_t size,
+				 void *hva, uint32_t gmem_fd, uint64_t gmem_offset);
+
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	enum vm_mem_backing_src_type src_type,
 	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 64221c320389..f7b8b5eb3e8f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -868,6 +868,35 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 		    errno, strerror(errno));
 }
 
+int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot,
+				 uint32_t flags, uint64_t gpa, uint64_t size,
+				 void *hva, uint32_t gmem_fd, uint64_t gmem_offset)
+{
+	struct kvm_userspace_memory_region2 region = {
+		.slot = slot,
+		.flags = flags,
+		.guest_phys_addr = gpa,
+		.memory_size = size,
+		.userspace_addr = (uintptr_t)hva,
+		.gmem_fd = gmem_fd,
+		.gmem_offset = gmem_offset,
+	};
+
+	return ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION2, &region);
+}
+
+void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot,
+				uint32_t flags, uint64_t gpa, uint64_t size,
+				void *hva, uint32_t gmem_fd, uint64_t gmem_offset)
+{
+	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
+					       gmem_fd, gmem_offset);
+
+	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
+		    errno, strerror(errno));
+}
+
+
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-- 
2.41.0.255.g8b1d071c50-goog

