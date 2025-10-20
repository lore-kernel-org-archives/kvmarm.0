Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D4B2E972D
	for <kvmarm@lists.linux.dev>; Mon, 20 Oct 2025 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760951363; cv=none; b=IeZvAC5AbtaWBgwwJMRzQw253METYdCfZMym3ZgMu04dhv7uq4GQ9T4YPogJwMtNmcBC7HyXxeBfLwkBb3ssKpKOQPeIDSuSGFQSQraOMbKdUvEpFlvdCnH8piQaGFCk6GUzfK1/1eVXCX+unUZCefTlgM4mPcDbEHVl5PRJN3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760951363; c=relaxed/simple;
	bh=vXpHqTVPTJwaiq0D8PgeV5D6uDxw+nGQu4OisIp3eyA=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=QS4YM550XyWqXRndHwbiu45r5VK9uPaRAc5p6JuDpPX7LBGeps6dq9oa8SmwP8hYyqS913rAOPEGEf8Ivf4IrwpA4ZDOKK/C0VPbD1JrFuRKeLb1OiX5yR8sdjGNcrxwUNq71ZG6ixB8EJu0PCbHvB2LhwCFYepOakX4kxAtqn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fkTATWTG; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fkTATWTG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760951359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2mwus7AZ3r4baeGzSdR+faFbT6Wt/yUQRtyiE49ozxo=;
	b=fkTATWTGE3Ad32GaRa4ZxaI6NcVURI7PgUrAk/Ev4RsCb/jaCJgzz7oUJ1xYtBXdtXRy00
	eaFI6z76wogarMm5Pol53uGgJtEqFyyHjZlv3ccvjUKkhQJ1+Opj3zfC0I+4iLf/P+cUuC
	69sE1O6a/Nhd+Ie37wnAawodIrOtMII=
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: RFC KVM: arm64: selftest: stage 2 mapping helpers 
Message-Id: <10A5745B-411F-4EB3-A168-0BC6CA99FF4D@linux.dev>
Date: Mon, 20 Oct 2025 18:08:58 +0900
To: kvmarm@lists.linux.dev
X-Migadu-Flow: FLOW_OUT

Hi,

Below is my attempt to add stage 2 mapping helpers for the KVM selftest =
test framework as almost a duplicate of _virt_pg_map(), I thought for =
FEAT_NV2 feature testing, it=E2=80=99d be nice to have helpers rather =
than writing it in selftests. Comments are appreciated. 4KB page size, =
and 4 levels of stage 2 translation is assumed.=20

Thanks,
Itaru.=20

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h =
b/tools/testing/selftests/kvm/include/kvm_util.h
index 11b6c5aa3f12..6fe9210eeeb6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -106,6 +106,7 @@ struct kvm_vm {
 	bool pgd_created;
 	vm_paddr_t ucall_mmio_addr;
 	vm_paddr_t pgd;
+	vm_paddr_t s2_pgd;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
@@ -1202,6 +1203,12 @@ static inline void virt_pg_map(struct kvm_vm *vm, =
uint64_t vaddr, uint64_t paddr
 	virt_arch_pg_map(vm, vaddr, paddr);
 }
=20
+void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr);
+
+static inline void virt_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
+{
+	virt_arch_s2_map(vm, ipa, paddr);
+}
=20
 /*
  * Address Guest Virtual to Guest Physical
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c =
b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 369a4c87dd8f..a49cd8a7e9a8 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -124,6 +124,96 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
 				     vm->memslots[MEM_REGION_PT]);
 	vm->pgd_created =3D true;
+
+	vm->s2_pgd =3D vm_phy_pages_alloc(vm, nr_pages,
+                                     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+                                     vm->memslots[MEM_REGION_PT]);
+}
+
+static void _virt_s2_map(struct kvm_vm *vm, uint64_t ipa, uint64_t =
paddr, uint64_t flags)
+{
+	uint8_t attr_idx =3D flags & (PTE_ATTRINDX_MASK >> =
PTE_ATTRINDX_SHIFT);
+	uint64_t pg_attr;
+	uint64_t *ptep;
+	uint64_t *pgdp;
+
+	ptep =3D addr_gpa2hva(vm, vm->s2_pgd) + pgd_index(vm, ipa) * 8;
+	if (!*ptep) {
+                *ptep =3D addr_pte(vm, vm_alloc_page_table(vm),
+                                 PGD_TYPE_TABLE | PTE_VALID);
+	}
+
+	switch (4) {
+        case 4:
+                ptep =3D addr_gpa2hva(vm, pte_addr(vm, *ptep)) + =
pud_index(vm, ipa) * 8;
+                if (!*ptep)
+                        *ptep =3D addr_pte(vm, vm_alloc_page_table(vm), =
PUD_TYPE_TABLE | PTE_VALID);
+                /* fall through */
+        case 3:
+                ptep =3D addr_gpa2hva(vm, pte_addr(vm, *ptep)) + =
pmd_index(vm, ipa) * 8;
+                if (!*ptep)
+                        *ptep =3D addr_pte(vm, vm_alloc_page_table(vm), =
PMD_TYPE_TABLE | PTE_VALID);
+                /* fall through */
+        case 2:
+                ptep =3D addr_gpa2hva(vm, pte_addr(vm, *ptep)) + =
pte_index(vm, ipa) * 8;
+                break;
+        default:
+                TEST_FAIL("Page table levels must be 2, 3, or 4");
+        }
+
+#define KVM_PTE_VALID                   BIT(0)
+
+#define KVM_PTE_ADDR_MASK               GENMASK(47, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_48              GENMASK(15, 12)
+#define KVM_PTE_ADDR_MASK_LPA2          GENMASK(49, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_50_LPA2         GENMASK(9, 8)
+
+#define KVM_PHYS_INVALID                (-1ULL)
+
+#define KVM_PTE_TYPE                    BIT(1)
+#define KVM_PTE_TYPE_BLOCK              0
+#define KVM_PTE_TYPE_PAGE               1
+#define KVM_PTE_TYPE_TABLE              1
+
+#define KVM_PTE_LEAF_ATTR_LO            GENMASK(11, 2)
+
+#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX GENMASK(4, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP      GENMASK(7, 6)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO           \
+        ({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 2 : 3; })
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW           \
+        ({ cpus_have_final_cap(ARM64_KVM_HVHE) ? 0 : 1; })
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH      GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS   3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AF      BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR GENMASK(5, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R  BIT(6)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W  BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH      GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS   3
+#define KVM_PTE_LEAF_ATTR_LO_S2_AF      BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_HI            GENMASK(63, 50)
+
+#define KVM_PTE_LEAF_ATTR_HI_SW         GENMASK(58, 55)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN      BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN      BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_GP      BIT(50)
+
+#define KVM_PTE_CLEAR_RSBZ_BIT10 (~(1ULL << 10))
+
+#define S2_PTE_LO_FLAGS_MASK 0x3FFF
+
+	pg_attr =3D KVM_PTE_VALID | FIELD_PREP(KVM_PTE_TYPE, =
KVM_PTE_TYPE_PAGE) | KVM_PTE_LEAF_ATTR_LO_S2_AF | =
KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | =
FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, KVM_PTE_LEAF_ATTR_LO_S2_SH_IS) & =
KVM_PTE_CLEAR_RSBZ_BIT10;
+
+        if (!use_lpa2_pte_format(vm))
+                pg_attr |=3D PTE_SHARED;
+        *ptep =3D addr_pte(vm, paddr, pg_attr);
+
 }
=20
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t =
paddr,
@@ -186,6 +276,13 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t =
vaddr, uint64_t paddr)
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
=20
+void virt_arch_s2_map(struct kvm_vm *vm, u64 ipa, u64 paddr)
+{
+	u64 attr_idx =3D MT_NORMAL;
+
+	_virt_s2_map(vm, ipa, paddr, attr_idx);
+}
+
 uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, =
int level)
 {
 	uint64_t *ptep;

