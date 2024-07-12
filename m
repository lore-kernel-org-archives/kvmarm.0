Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571A715FA78
	for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 11:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720782231; cv=none; b=lmKjBsWqZYNdfpSDLBhyBT29Jv8sRikCpyzvUwPTUZCxa04V2n3d/BdQxRwOF+ZihIPqRi5oKhji9XEkdiUvqquAobfm+Wtclg4Ltbis+bUi9+A1DP4CmGUAJFRmrrNI6q+CQCJHcF5vwtqId4+99cHwogIkST5Gadq/ZSDxGt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720782231; c=relaxed/simple;
	bh=dLBBaMqHPPQsYGXel7Tg/y3cknFXfDOZMFogS4bCL30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igrVroFA0jBZDM13QHaomOeOxa8CtsWatbkjivdelYIxP6Ft1MLv1TCKdwDmvMLlWihqzgHPoM4D7Gld3oVnrYs/0e5WV0OhYFaoMbzgGCC79z97Jp5qIv4IvkOJvohA6gYOunvx8QsWjz/yQ9ok/2jMz6mg2mEPFhqsfou7f2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iFBTPSMZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iFBTPSMZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720782227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6xAST+V6lWXBsnEaGTLUMH67LdmttdDtWSOQgal7aQQ=;
	b=iFBTPSMZuGdnRyalDv6epfo51Kn2vjOfy9xj/EYQMPPgk0PluOLjQ4Raz1yXrBHXYZ1//k
	33bUJeiRDyHzU1Gg/VBPAUow4/yIV/OPGZKYe2J3knjrvUnpx1WxFNXFsmJOsHlF1A80w4
	ckEssxrjV5Ov/jodr8bXD/uTZuZDlKQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-LmVp3AaTOn2SPqc60ZvR8A-1; Fri, 12 Jul 2024 07:03:46 -0400
X-MC-Unique: LmVp3AaTOn2SPqc60ZvR8A-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-79f0da8e7c7so166818185a.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 04:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720782225; x=1721387025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6xAST+V6lWXBsnEaGTLUMH67LdmttdDtWSOQgal7aQQ=;
        b=CLrNnqcbF8BOM4kfEzv8eGD2vy9PSFTwdop+l3iXZeaTpIJZ69z3vt9ifCddsjv9rE
         P6Y+Wfe51x8Qq3u2x58ShXa4do0jBtxpVT9gnj6giK0ctaVdunCLQ6k8H8EUdV0mX9v+
         S8f8iWFdMIV4Y2vDjeA7MkRyYA04sv8kr00fRaSlVobf9mnWnoIoBBlevCqWGOvYfy7K
         AB0rDfVwLmz8I+49jJDwILUNoG85PMqu7Tgw4ONh4eQ/PqyvUQzlnkyfwLNkrFHgoE+z
         2DJ8O2dTxcBJrQH8iZD9iSFTHxCb8+SVJ5srxo5+Uxi0HFlkWFIxnvucqVOZkWpPAjcF
         1YDA==
X-Forwarded-Encrypted: i=1; AJvYcCWEV5oLaMJAHaNPhhCb8c2I50aswuMFD7sjT+8S5RQ/PWMy8441FT2Sd6F02cDt0zt+Mb0G69R1TnUEORk7O34dNBcvvaLm
X-Gm-Message-State: AOJu0Yzzm7YXY2pQXcwXSgEXX6ElGfoM/3NaHaPPzr38TzLAiCGilFJy
	5bVJDtU1wM5gsBH9FwmNGmqjdMJDPgrdz1WjiOUVmdJwQhklvJHHiLe5mdaPg9hgPBlqq5sH8zd
	x+20rDlWr132xywb9igfFHEQQy+h8w7eryrV45F2MKQQtzrNyXnBsCg==
X-Received: by 2002:a05:620a:909:b0:79e:f850:e4de with SMTP id af79cd13be357-79f1991b083mr1092096585a.0.1720782225622;
        Fri, 12 Jul 2024 04:03:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRtK3var3gfeKJIjD1DbrBau/cSSmMTHNiKReqsoRwrLr/R+k8zDdqm587bqmZ6Jq9LLcrog==
X-Received: by 2002:a05:620a:909:b0:79e:f850:e4de with SMTP id af79cd13be357-79f1991b083mr1092094585a.0.1720782225283;
        Fri, 12 Jul 2024 04:03:45 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f18ff834csm390498685a.5.2024.07.12.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 04:03:44 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/3] KVM: arm64: fix kdoc warnings in W=1 builds
Date: Fri, 12 Jul 2024 13:03:31 +0200
Message-ID: <20240712110332.10970-3-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712110332.10970-1-sebott@redhat.com>
References: <20240712110332.10970-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Fix kdoc warnings by adding missing function parameter
descriptions or by conversion to a normal comment.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/arm.c             |  1 +
 arch/arm64/kvm/vgic/vgic-irqfd.c |  7 ++++---
 arch/arm64/kvm/vgic/vgic-its.c   | 18 +++++++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c    |  2 +-
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c818818398a5..2cbc23dd554d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -164,6 +164,7 @@ static int kvm_arm_default_max_vcpus(void)
 /**
  * kvm_arch_init_vm - initializes a VM data structure
  * @kvm:	pointer to the KVM struct
+ * @type:	kvm device type
  */
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 8c711deb25aa..c314c016659a 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -9,7 +9,7 @@
 #include <kvm/arm_vgic.h>
 #include "vgic.h"
 
-/**
+/*
  * vgic_irqfd_set_irq: inject the IRQ corresponding to the
  * irqchip routing entry
  *
@@ -75,7 +75,8 @@ static void kvm_populate_msi(struct kvm_kernel_irq_routing_entry *e,
 	msi->flags = e->msi.flags;
 	msi->devid = e->msi.devid;
 }
-/**
+
+/*
  * kvm_set_msi: inject the MSI corresponding to the
  * MSI routing entry
  *
@@ -98,7 +99,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
-/**
+/*
  * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
  */
 int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 40bb43f20bf3..ba945ba78cc7 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2040,6 +2040,7 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *entry,
  * @start_id: the ID of the first entry in the table
  * (non zero for 2d level tables)
  * @fn: function to apply on each entry
+ * @opaque: pointer to opaque data
  *
  * Return: < 0 on error, 0 if last element was identified, 1 otherwise
  * (the last element may not be found on second level tables)
@@ -2079,7 +2080,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 	return 1;
 }
 
-/**
+/*
  * vgic_its_save_ite - Save an interrupt translation entry at @gpa
  */
 static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
@@ -2099,6 +2100,8 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 
 /**
  * vgic_its_restore_ite - restore an interrupt translation entry
+ *
+ * @its: its handle
  * @event_id: id used for indexing
  * @ptr: pointer to the ITE entry
  * @opaque: pointer to the its_device
@@ -2231,6 +2234,7 @@ static int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
  * @its: ITS handle
  * @dev: ITS device
  * @ptr: GPA
+ * @dte_esz: device table entry size
  */
 static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 			     gpa_t ptr, int dte_esz)
@@ -2313,7 +2317,7 @@ static int vgic_its_device_cmp(void *priv, const struct list_head *a,
 		return 1;
 }
 
-/**
+/*
  * vgic_its_save_device_tables - Save the device table and all ITT
  * into guest RAM
  *
@@ -2386,7 +2390,7 @@ static int handle_l1_dte(struct vgic_its *its, u32 id, void *addr,
 	return ret;
 }
 
-/**
+/*
  * vgic_its_restore_device_tables - Restore the device table and all ITT
  * from guest RAM to internal data structs
  */
@@ -2478,7 +2482,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	return 1;
 }
 
-/**
+/*
  * vgic_its_save_collection_table - Save the collection table into
  * guest RAM
  */
@@ -2518,7 +2522,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	return ret;
 }
 
-/**
+/*
  * vgic_its_restore_collection_table - reads the collection table
  * in guest memory and restores the ITS internal state. Requires the
  * BASER registers to be restored before.
@@ -2556,7 +2560,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
 	return ret;
 }
 
-/**
+/*
  * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
  * according to v0 ABI
  */
@@ -2571,7 +2575,7 @@ static int vgic_its_save_tables_v0(struct vgic_its *its)
 	return vgic_its_save_collection_table(its);
 }
 
-/**
+/*
  * vgic_its_restore_tables_v0 - Restore the ITS tables from guest RAM
  * to internal data structs according to V0 ABI
  *
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index ed6e412cd74b..3eecdd2f4b8f 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -370,7 +370,7 @@ static void map_all_vpes(struct kvm *kvm)
 						dist->its_vm.vpes[i]->irq));
 }
 
-/**
+/*
  * vgic_v3_save_pending_tables - Save the pending tables into guest RAM
  * kvm lock and all vcpu lock must be held
  */
-- 
2.42.0

