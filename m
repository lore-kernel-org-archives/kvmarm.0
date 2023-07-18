Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CDE17AC3
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 23:49:09 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1b9de3e7fb1so32328245ad.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 16:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689724148; x=1692316148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Op8HHmnUgwupsWBaRFuhvxYPW8xnNAPNdjQWsU6sjr4=;
        b=QGe2TDZHOQa4Dl//VYNCOYShcTza/1woeu2375n0rkVScAi+cbY/3o7kv0BRcH2AMJ
         +c/iqHZ3q4qoWQp2d3aei0T6E53l+ZqCNd2m04n3+R0wSNZlGOK1LSjxlHNXzCcomxJY
         E8j4TlQATKeS/E+fNB5tnRwv8C8AcACbuwNfJJ4GFsEgr7shqPyCnrSeiwO4qSSrmzt7
         efORpwkrylJDYPQpjxrM/NpVjNFpNVPE0Qd0lMQKpfpNX9QNZ2W1IrXiVTqmpPMaOQWI
         k1X5M4hUDGgW+QX9Vf1eWMvk3OJKrPnVnj02NJetvqw5q8wS599WGmVh+Grx/YjjjUXB
         v1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689724148; x=1692316148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Op8HHmnUgwupsWBaRFuhvxYPW8xnNAPNdjQWsU6sjr4=;
        b=iqCZRlLrpltfhI3F2LeCz4R97Xv4aMslzGlGR0jEpgXJHVAcFOPpfEqMzq3f5131Hn
         Kyb0NQKpiVcNg9Ff4ZaEV2tHepDRPVF43OKC2/ROBNF1sPjXuAOEcM/au0Mjoc4POAmv
         c9Rh+Ebfc5ShSMbSGNxQD0Okz2Zjjj7HTKSVWw8B0DWGEoqVSd6M+CYGUn6XoXcsTEnX
         mYutBU2atzswhj3C10XyHFsd1Gt9yhtNU/s6zF1OQjmglxrynLs426JsgTlcFNIqOXhp
         qhIbagtWTJmHt6m5dTfyt13o6i+YLx3zICCcHr+NyON7xTmcNNj6HAM9++GBJJmpKAZw
         76iw==
X-Gm-Message-State: ABy/qLbLIS/AY7kqsMlklDrSa/cLWup45eGMOK/WKicuE4rv+0aJnb00
	pcmrmO8ENNfB5F4buJa/IW5rGJd0bgo=
X-Google-Smtp-Source: APBJJlGOkej0m8Idb/suY4iXY9qip/Dep68m1+USICpK/8IAat1dD7w7AsEo2fC/HRINs5tpOYMC/rDWeUE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec88:b0:1b9:df8f:888c with SMTP id
 x8-20020a170902ec8800b001b9df8f888cmr16357plg.8.1689724148112; Tue, 18 Jul
 2023 16:49:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Jul 2023 16:45:02 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230718234512.1690985-20-seanjc@google.com>
Subject: [RFC PATCH v11 19/29] KVM: selftests: Convert lib's mem regions to KVM_SET_USER_MEMORY_REGION2
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h      |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c     | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6aeb008dd668..d4a9925d6815 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -43,7 +43,7 @@ typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
 struct userspace_mem_region {
-	struct kvm_userspace_memory_region region;
+	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
 	int fd;
 	off_t offset;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 45d21e052db0..c1e4de53d082 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -449,8 +449,8 @@ void kvm_vm_restart(struct kvm_vm *vmp)
 		vm_create_irqchip(vmp);
 
 	hash_for_each(vmp->regions.slot_hash, ctr, region, slot_node) {
-		int ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
-		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
+		int ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION2, &region->region);
+		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
 			    "  rc: %i errno: %i\n"
 			    "  slot: %u flags: 0x%x\n"
 			    "  guest_phys_addr: 0x%llx size: 0x%llx",
@@ -653,7 +653,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	}
 
 	region->region.memory_size = 0;
-	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
+	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
@@ -1010,8 +1010,8 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	region->region.guest_phys_addr = guest_paddr;
 	region->region.memory_size = npages * vm->page_size;
 	region->region.userspace_addr = (uintptr_t) region->host_mem;
-	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
-	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
 		"  rc: %i errno: %i\n"
 		"  slot: %u flags: 0x%x\n"
 		"  guest_phys_addr: 0x%lx size: 0x%lx",
@@ -1093,9 +1093,9 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
 
 	region->region.flags = flags;
 
-	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
 
-	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
+	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION2 IOCTL failed,\n"
 		"  rc: %i errno: %i slot: %u flags: 0x%x",
 		ret, errno, slot, flags);
 }
@@ -1123,9 +1123,9 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
 
 	region->region.guest_phys_addr = new_gpa;
 
-	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region);
+	ret = __vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
 
-	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
+	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed\n"
 		    "ret: %i errno: %i slot: %u new_gpa: 0x%lx",
 		    ret, errno, slot, new_gpa);
 }
-- 
2.41.0.255.g8b1d071c50-goog

