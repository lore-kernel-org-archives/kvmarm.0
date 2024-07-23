Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3249B14F114
	for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 10:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721729541; cv=none; b=RTjmUhG0UgO8wEBNuZdFiqnHm6USnCJ0pPCmO5hTXVWFvtsHHlZNR52TwOjFf6qatAG3cQYeWn8FchW3vsd55pHyZTUIxhtBdqLgr8pqYkIeWIHZANEIotmbbZrCkZ1pTabUjX0FaqwxNWok4IKpoRt5Ah7xZ+fmjeQQNZQaCT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721729541; c=relaxed/simple;
	bh=AYfOsTim18mKk3f/6TIR5xq65kd3Yt1GDi3RAW/TNkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2TpbtHZ+vR143wBIuO90qLoEv0AIJMiCzTRcoQwc235n2KO+jCdCL9QVe8ndQl66vB6H7ti8/k5XHtDKwe1keMNgSozHtXlpny8pphNT2KnbUdjTccHA7Sjnx//WD4dgEFb62cNUuSGb0so4i2J6C5tYYysX8Yne16tdwzShlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RFTZnM47; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RFTZnM47"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721729538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eYU79afplONI6yVx+AGbEJT6iE6q/eJtdNUT3lyaw3g=;
	b=RFTZnM47HS+5suk9wrSHLAoUGti69M76bB2AMpOIpr1ba6GJgEhnchki4Rcvv7oPnen2tN
	ISh4lQ5JSyQWpHHXqo2xCZxl9kLmAq5C5glqKf9DdAVPfcIyPpOimYmGzqpKtxYsxe5eQo
	wcJC8aJadu7YAHTSWnWLdK6m5GNrVjE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-MfZjfQ6UMMmq27KGDfFKYQ-1; Tue, 23 Jul 2024 06:12:17 -0400
X-MC-Unique: MfZjfQ6UMMmq27KGDfFKYQ-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a1985748dcso626788885a.3
        for <kvmarm@lists.linux.dev>; Tue, 23 Jul 2024 03:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721729536; x=1722334336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eYU79afplONI6yVx+AGbEJT6iE6q/eJtdNUT3lyaw3g=;
        b=QFfTJCADYjwA+DK/M79pOaz28VzGePG1tBWxVVVqYPxrJSgLMP69CniWlX2z0GOef3
         5IX7ExSQ+9F8w3c3X3JxJnwFvZeh8flPlGb+WtSh1hOgsYmkHVhhEMHPw419mvXmuxnR
         TbLrbZTpeMQeDrQKSX3wyDYNdgazBcqBYihsnv/3iNp23id7oQBcxvEUeqm+/hu1kKSN
         v/4EQSKA9lsNNxGSZNuHUAP1x67MTDaaCsCsBpF0b3dmLgudSsvv1itsLOgUrZ++UgYE
         rCGuT34Ks9C4bIlVHRxRWHxroQH28bAjEAvKuYfN6SmdwwtlJJ+0rlQx17m2BvQ6lfyM
         2Liw==
X-Forwarded-Encrypted: i=1; AJvYcCW1GXuD6UGbSJql/2A5WUlv2Bbm9NLydBrACECZHUXhoFDFC86x0+FcCWvAqCQh10Hzbulb7w6T58OERfYTVcdQY7aXA/V7
X-Gm-Message-State: AOJu0YwZcyj1dA4tdEI4YvCy/uJvo3Cv+LltEsbIf/qvErdqnmLjzJsY
	T4axBVkiR+s6yyTWDWaLaFZHS/BoK2phcRjAj0bXzOj4/WlmUxNSpvNhdM/9Dhl/iErsblH8Xpq
	/gRsgpxz3dniiNhc4qxX9y+f91OFdcw+y4wTW50oja4TzM0Llv6SY3w==
X-Received: by 2002:a05:620a:2889:b0:79f:186e:40ae with SMTP id af79cd13be357-7a1a66656edmr1162831985a.53.1721729536482;
        Tue, 23 Jul 2024 03:12:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLHZv1++yvDs2k3NZSaNv8PP8WkhYN1uecWcb93Utq4aaTWS6WbOltpz2JXXEdPG07aFrkHg==
X-Received: by 2002:a05:620a:2889:b0:79f:186e:40ae with SMTP id af79cd13be357-7a1a66656edmr1162829385a.53.1721729536084;
        Tue, 23 Jul 2024 03:12:16 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1990063f2sm463780085a.64.2024.07.23.03.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 03:12:15 -0700 (PDT)
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
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 2/3] KVM: arm64: fix kdoc warnings in W=1 builds
Date: Tue, 23 Jul 2024 12:12:03 +0200
Message-ID: <20240723101204.7356-3-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723101204.7356-1-sebott@redhat.com>
References: <20240723101204.7356-1-sebott@redhat.com>
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
index a7ca776b51ec..23e1fa56c02d 100644
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

