Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A73293B5F
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504068; cv=none; b=jzYEiB03ekOajWQtSFuviKY3ZM9vN4ufeKZxf05JiAiTkdE0nxu0r2baAWWx4y6mEyLq2p3DskVTtTUrhBl0ngsLwMPP5NIIXTMQNSggFRNiu5Vx5D87jGuV2yLbrBWuojBZDKS9ccfQNWvvSWPdWuxxryFzUR4/NJ4xOAeNkns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504068; c=relaxed/simple;
	bh=4ABx24IRjfvVXtvRhqG0T6gWoZOLeg1qYCJYADA24es=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=shJBScNBVVVy+tE3GjC7P54mciai8j+Hz6ZPB/BIVK3eNFXdJEt+bC7b4cQmVI+EO8OK28pFQgLpd9JCH2zKzYZ3z8Ze9SdJ35Y2mPNyvfXTxvlMGisJmazobZCVOGvDozr6G+ucWT6eFRn7cQIuzQVZLNULihEc3ccFfm9ty3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bGvJWkGA; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bGvJWkGA"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39bf44be22fso820755f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504064; x=1746108864; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC4sArz2tKH+wjPmCs+Bj3DeYtgEPbRq63zRADPtWtk=;
        b=bGvJWkGA5tlyAz3pyPPxjYJXa4VplhnuDyOuhDiYFuJag3oJr6CrfO3cBQny5LvfHX
         giTkugAY+tsMQJ+DRONZSSRG/n0aLPT+M4rczaUuowHwoJYDqw/XTcuqZpCJXoMpYYbR
         zKepHFPbQVaOIjbqW1qh0KAJTBl11lqN9nJJLPn/eWPvBl6Bg2oNSFhm827v8GMWAlON
         E4bz9NTHuR1hTOZmYnHQlP5buFoYo4gjzENWUPvwkKBzlQdI99xu/gFFH3uzSnXKkoIo
         Jd6e0VymRi7M+uI3cXgtol5M2kCYK7q6YbVdrvEoOhRK6gEUoL4sb7hFcGgrVtV5PGeo
         6AxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504064; x=1746108864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WC4sArz2tKH+wjPmCs+Bj3DeYtgEPbRq63zRADPtWtk=;
        b=n8V+8mz+vsmu4kTkZxq05Ahbi0N6nAEXvraDU/6Aa00s2csY7bBJoFqoPb6h5bZvW4
         IjBtv9O7Uwm/dcrwrBDlC0MIymYgvhrjmJyDED14tsB8y2g1HGYF1qDgmm+clKw987Sd
         NBiZbZtdsJr0Kd7gZadgfcJVu+nZ5vE1uN3DFGcMkeWkHayO7tro4vejH64iA7CFHm+Y
         f5KqeRP5l1AVQ466liRoMoN+CliXeLJMQzY8bkCz7vKQampI4Sot1utATd7fkZBkeTf4
         kGYQ2Evx3xkSVj1PcJ69Mw1ebOEX/4IBBxLCwhpn83ygAsdUb8gDUYl+NaypRwHw8CQ3
         vugw==
X-Forwarded-Encrypted: i=1; AJvYcCXM9YPh/7YSOlBWkpEWTZeeE0r9y1M28uUp/bgGsIgtfuUShKwj9C6x1QU+S6+o5kT8yfme95Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxR53VPCddY8llA22XBo6bxfmkeNmTHjvrEyxmWy4KHojAFQ7pA
	zaXruW0jTAECBVJ+zSiqMQrvLF5dE/sJt3P0/bhQyjyWwTKJWm2pvY6kvZcHNVs=
X-Gm-Gg: ASbGncum2mXevQo39l+0W8nHxlqEJx9lstEJotATrlXJ7hEZ2brtcabtkbgO0rGGEyT
	Zz5CjR0JXrHJ5xAKmNzph/9YdfDRyL/mWCMrMRlccPr5WzeKWSSLKKpLurK8Btl9OFTgbe16I0e
	6ZDIco7fkHblho2wxJ5r9fffNm1/k/hsW6mhgN4V4uppofCPLa0nfWY+VLgCfA7MS0VGFSxUQcV
	7/ozNrCqgGrNaSbqQtboz7/GWmVQi2cRbLPnhazMr7DqzP4dIUCwOPpKhFvZg8aQmCBDpFYaA/y
	SgK1xYcQPR0Nl0bedGr2DACR7Y6JkUn2Y6fw7ywwPxLgF7d+M1PuuOMjEGeP5554DehD7DiLpMc
	mjsiGw93zOuODNSh/
X-Google-Smtp-Source: AGHT+IGeGIUXl8vOV0aXlznupMFAAmbzGK8/bha/61z42fQMkuhHsWrpW3uTjHsZlOeGVmwfVkNdPQ==
X-Received: by 2002:a05:6000:18ad:b0:39a:c9ac:cd58 with SMTP id ffacd0b85a97d-3a06cf63742mr2096999f8f.29.1745504063860;
        Thu, 24 Apr 2025 07:14:23 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:23 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 29/34] gunyah: Enable demand paging
Date: Thu, 24 Apr 2025 15:13:36 +0100
Message-Id: <20250424141341.841734-30-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tell resource manager to enable demand paging and wire vCPU faults to
provide the backing folio.

When a folio is donated to the guest, PG_private is set on the folio so
that we can recognize it later when taking it back (e.g. to reclaim the
folio when the VM exists).

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 182 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 179 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 687f2beea4e7..e8037d636e8f 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/cpumask.h>
+#include <linux/pagemap.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/perf_event.h>
@@ -476,7 +477,7 @@ static inline u32 reclaim_flags(bool share)
 					GUNYAH_MEMEXTENT_DONATE_FROM_PROTECTED);
 }
 
-static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
+static int __gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
 		struct folio *folio, gfn_t gfn, bool share, bool write)
 {
 	struct gunyah_resource *guest_extent, *host_extent, *addrspace;
@@ -573,7 +574,7 @@ static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm,
 	return ret;
 }
 
-static int gunyah_memory_reclaim_folio(struct gunyah_vm *ghvm,
+static int gunyah_memory_reclaim_folio_locked(struct gunyah_vm *ghvm,
 		struct folio *folio, gfn_t gfn, bool share)
 {
 	u32 map_flags = BIT(GUNYAH_ADDRSPACE_MAP_FLAG_PARTIAL);
@@ -713,6 +714,144 @@ static int gunyah_reclaim_memory_parcel(struct gunyah_vm *ghvm,
 	return 0;
 }
 
+static int gunyah_memory_provide_folio(struct gunyah_vm *ghvm, gfn_t gfn, bool write)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *memslot;
+	struct page *page;
+	struct folio *folio;
+	int ret;
+
+	/* Gunyah always starts guest address space at 1G */
+	if (gfn < gpa_to_gfn(SZ_1G))
+		return -EINVAL;
+
+	memslot = gfn_to_memslot(kvm, gfn);
+	if (!memslot)
+		return -ENOENT;
+
+	page = memslot->arch.pages[gfn - memslot->base_gfn];
+	folio = page_folio(page);
+
+	folio_lock(folio);
+	/* Did we race with another vCPU? */
+	if (folio_test_private(folio)) {
+		folio_unlock(folio);
+		return 0;
+	}
+
+	ret = __gunyah_memory_provide_folio(ghvm, folio, gfn, false, true);
+	if (ret) {
+		folio_unlock(folio);
+		return ret;
+	}
+	folio_set_private(folio);
+	folio_unlock(folio);
+
+	return 0;
+}
+
+static int gunyah_reclaim_memory_range(struct gunyah_vm *ghvm, gfn_t start, gfn_t nr)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	gfn_t end = start + nr;
+	int i, ret;
+
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		slots = __kvm_memslots(kvm, i);
+
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
+			struct page **pages, *page;
+			struct folio *folio;
+			unsigned long offset;
+			unsigned long reclaimed = 0;
+
+			slot = iter.slot;
+			pages = slot->arch.pages;
+			for (offset = 0; offset < slot->npages;) {
+				page = pages[offset];
+				folio = page_folio(page);
+				folio_lock(folio);
+				if (folio_test_private(folio)) {
+					ret = gunyah_memory_reclaim_folio_locked(ghvm, folio,
+							slot->base_gfn + offset, false);
+					if (ret) {
+						WARN_ON_ONCE(1);
+						return ret;
+					}
+					folio_clear_private(folio);
+					reclaimed++;
+				}
+				folio_unlock(folio);
+				offset += folio_nr_pages(folio);
+			}
+		}
+	}
+	return 0;
+}
+
+static int gunyah_memory_parcel_to_paged(struct gunyah_vm *ghvm, gfn_t start, gfn_t nr)
+{
+	struct kvm *kvm = &ghvm->kvm;
+	struct kvm_memory_slot *memslot;
+	struct page **pages, *page;
+	struct folio *folio;
+	int i;
+
+	memslot = gfn_to_memslot(kvm, start);
+	if (!memslot)
+		return -ENOENT;
+
+	if (start - memslot->base_gfn < nr)
+		return -EINVAL;
+
+	pages = &memslot->arch.pages[start - memslot->base_gfn];
+
+	for (i = 0; i < nr;) {
+		page = pages[i];
+		folio = page_folio(page);
+		VM_BUG_ON(folio_test_private(folio));
+		folio_set_private(folio);
+		i += folio_nr_pages(folio);
+	}
+
+	return 0;
+}
+
+static int gunyah_start_paging(struct gunyah_vm *ghvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	struct gunyah_rm_mem_entry *entries, *entry;
+	int count = 0;
+	int bkt, ret;
+
+	slots = kvm_memslots(&ghvm->kvm);
+	kvm_for_each_memslot(slot, bkt, slots) {
+		if (slot->base_gfn >= PFN_DOWN(SZ_1G))
+			count++;
+	}
+
+	entries = entry = kcalloc(count, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	kvm_for_each_memslot(slot, bkt, slots) {
+		if (slot->base_gfn < PFN_DOWN(SZ_1G))
+			continue;
+		entry->phys_addr = cpu_to_le64(gfn_to_gpa(slot->base_gfn));
+		entry->size = cpu_to_le64(gfn_to_gpa(slot->npages));
+		entry++;
+	}
+
+	ret = gunyah_rm_vm_set_demand_paging(ghvm->rm, ghvm->vmid, count, entries);
+	kfree(entries);
+	return ret;
+}
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -772,7 +911,14 @@ static int gunyah_handle_page_fault(
 	struct gunyah_vcpu *vcpu,
 	const struct gunyah_hypercall_vcpu_run_resp *vcpu_run_resp)
 {
-	return -EINVAL;
+	u64 addr = vcpu_run_resp->state_data[0];
+	bool write = !!vcpu_run_resp->state_data[1];
+	int ret = 0;
+
+	ret = gunyah_memory_provide_folio(vcpu->ghvm, gpa_to_gfn(addr), write);
+	if (!ret || ret == -EAGAIN)
+		return 0;
+	return ret;
 }
 
 static bool gunyah_kvm_handle_mmio(struct gunyah_vcpu *vcpu,
@@ -1614,6 +1760,28 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 		goto err;
 	}
 
+	ret = gunyah_start_paging(ghvm);
+	if (ret) {
+		pr_warn("Failed to set up demand paging: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_memory_parcel_to_paged(ghvm, ghvm->dtb.parcel_start,
+			ghvm->dtb.parcel_pages);
+	if (ret) {
+		pr_warn("Failed to set up paging for memparcel: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_rm_vm_set_address_layout(
+		ghvm->rm, ghvm->vmid, GUNYAH_RM_RANGE_ID_IMAGE,
+		ghvm->dtb.parcel_start << PAGE_SHIFT,
+		ghvm->dtb.parcel_pages << PAGE_SHIFT);
+	if (ret) {
+		pr_warn("Failed to set location of DTB mem parcel: %d\n", ret);
+		goto err;
+	}
+
 	ret = gunyah_rm_vm_init(ghvm->rm, ghvm->vmid);
 	if (ret) {
 		ghvm->vm_status = GUNYAH_RM_VM_STATUS_INIT_FAILED;
@@ -1719,6 +1887,14 @@ static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
 			pr_err("Failed to reclaim DTB parcel: %d\n", ret);
 	}
 
+	/**
+	 * If this fails, we're going to lose the memory for good and is
+	 * BUG_ON-worthy, but not unrecoverable (we just lose memory).
+	 * This call should always succeed though because the VM is in not
+	 * running and RM will let us reclaim all the memory.
+	 */
+	WARN_ON(gunyah_reclaim_memory_range(ghvm, gpa_to_gfn(SZ_1G), gpa_to_gfn(U64_MAX)));
+
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->addrspace_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_shared_extent_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_private_extent_ticket);
-- 
2.39.5

