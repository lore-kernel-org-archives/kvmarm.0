Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2784F1C1F09
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 19:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736796697; cv=none; b=uikos3W/zg5M3i9CylMf7z6Iqr0x0C9Yqt8qItDm0CaVwiUJpxbHObkWbEw70Bwrr24bSZsnkQehK0q8dS7lJuG0lfv+7SBlQ6XeYqslZlVn1mf32EeYLt0fUR7+FTjvfpx31U/oRTox2txgFgowLZIDrrt3ZycGIxXOu5kAtjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736796697; c=relaxed/simple;
	bh=7CBYbOa08e+cYUeyzldUH8J0XYLzdIZ7bkoffuV60xE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OerDHUfv0CunMkdq1tjTIDAlpM0X4Lh+pyKHc/sUZaZkfz0c8jbaZhixOtXSUBr+XAE9qPFt6f3F+3uzypfXkL0SsfB2GmVK6LWwq3X1OhGl+k0374mVMRDGQTLSmS2Jt7WawFXDTnJq3VLky5NIQIMvxdbUmJpvTobnICnxEpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IeS3aDRR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IeS3aDRR"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee9f66cb12so8342768a91.1
        for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 11:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736796695; x=1737401495; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AjSHhLfzPpweAeruuV41TxV8cjx61KJKZIlFZE69SAQ=;
        b=IeS3aDRRRr/xBzAa82eCbC8ogxahrss0Igl4J+srfF9GfdgDQBSi+xGZU3UczE/u4U
         h5WnrAnpNFCCDbuCLatINGK71VnUWmlgRNOAkRuGh9jCH5yYTcwi3N8AHN6+f6toFQnp
         twAw8hw+gvv9nA3xYH/qwPpu6s5zpGt3ihP+LKBouTseI2fZUTiCUJObl39v/2QKP4vx
         DC7xRMCOwDrnxB7Pa/wqGZf9l0L76EtMvl6F/ja4x9F8fHd7QAMUl95sEZtbQ/s+qcUi
         CbicoVMIQDChVLKZIgIx18tzC/P7MqtUxGpKdkR1yKYaFFtVPzGyArnMTRUVcmQdIXum
         he8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736796695; x=1737401495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjSHhLfzPpweAeruuV41TxV8cjx61KJKZIlFZE69SAQ=;
        b=YyTTOiOnXaEVAcaFEwrsFhwb6S4KOaQC94Im6AXSU5RerTs5o6JMxVMCfu4dYA/LAL
         aMCZpH0vuBWsl55T8tuK/fxYsuRtW3OrOjt8mVmRpeu/6GrVubyts8k60Cx2QShiSQkW
         Nb9lOdUSwkTb0geVsg8108NsJiBhxnHwp6riahaF7ea67PmrRSVJ5bL7U+VxRG7U2TCo
         dPgNMDL7/xCKJvEn4m4WBrYcuH+UC5F/spgjTXjP3a3oiJr4cTgXrTgCmw+hs0sc2aMz
         HfIBTSVkrqusNI+NCWRG0bkYWLy/7CCImaXwbb3mAtKbwF8PSJekwzHYehlb7sWQqRJ5
         /mMQ==
X-Gm-Message-State: AOJu0YyT4Q50cXKP5/AxSTZgzH8tXsydEwSSBiV3ctfQWQ1t7kC1qgn4
	8n/GmbPwlo2tBYVBVNcGr58pvw4lkUmWL7l2oprcLWxiVyEHwbrG1iww+ncpxrqWCGXsNOaF3Vj
	ivBAEPiCZC9KgOMArbwS5VwK7f0ETSp+ASWWLLmE/WV4v7WJCPejt5dIstLLzaUSH3ubkFJpEXq
	kCCYw+oLESDkJjoB+X3yD7JwhssjGV878kaoiv2wejGv+mABLPJSg4FfgeBhM=
X-Google-Smtp-Source: AGHT+IHgy/xhjs0ZlLXfoJvzHD/baMNuiYAMQ8oeX9ah+6G+BrGfVdNx/nIjUYcPrD4FhCjo+aJMyh+mafTgb4aApA==
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2f4:3ea1:9033])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2f4e:b0:2eb:140d:f6df with SMTP id 98e67ed59e1d1-2f548e98382mr28470262a91.1.1736796695319;
 Mon, 13 Jan 2025 11:31:35 -0800 (PST)
Date: Mon, 13 Jan 2025 11:31:28 -0800
In-Reply-To: <20250113193128.1533449-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250113193128.1533449-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113193128.1533449-3-jingzhangos@google.com>
Subject: [RFC PATCH 2/2] KVM: arm64: vgic-its: Add tracepoints for VGIC ITS commands
From: Jing Zhang <jingzhangos@google.com>
To: KVMARM <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This commit adds tracepoints to the KVM VGIC ITS on ARM64 to improve
observability and debuggability. The following ITS commands now have
associated tracepoints: MAPI, DISCARD, CLEAR, INT, INV, MAPD, MAPC,
MOVI, MOVALL, and INVALL.

Each tracepoint captures essential information such as device ID, event
ID, and other relevant parameters, allowing for detailed monitoring of
ITS operations.

These tracepoints are useful for:

*   Debugging interrupt routing issues.
*   Performance analysis and optimization.
*   Understanding ITS behavior.
*   Root-causing interrupt handling errors.

This enhancement provides crucial insights into interrupt handling in
ARM64 virtualized environments, aiding in development, debugging, and
maintenance.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/trace.h    | 135 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c |  19 +++++
 2 files changed, 154 insertions(+)

diff --git a/arch/arm64/kvm/vgic/trace.h b/arch/arm64/kvm/vgic/trace.h
index 83c64401a7fc..22953c0ef159 100644
--- a/arch/arm64/kvm/vgic/trace.h
+++ b/arch/arm64/kvm/vgic/trace.h
@@ -27,6 +27,141 @@ TRACE_EVENT(vgic_update_irq_pending,
 		  __entry->vcpu_id, __entry->irq, __entry->level)
 );
 
+DECLARE_EVENT_CLASS(vgic_its_cmd_class,
+	TP_PROTO(__u32 device_id, __u32 event_id),
+	TP_ARGS(device_id, event_id),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		device_id		)
+		__field(	__u32,		event_id		)
+	),
+
+	TP_fast_assign(
+		__entry->device_id		= device_id;
+		__entry->event_id		= event_id;
+	),
+
+	TP_printk("Device ID: %u, Event ID: %u",
+		  __entry->device_id, __entry->event_id)
+);
+
+DEFINE_EVENT(vgic_its_cmd_class, vgic_its_cmd_mapi,
+	TP_PROTO(__u32 device_id, __u32 event_id),
+	TP_ARGS(device_id, event_id));
+
+DEFINE_EVENT(vgic_its_cmd_class, vgic_its_cmd_discard,
+	TP_PROTO(__u32 device_id, __u32 event_id),
+	TP_ARGS(device_id, event_id));
+
+DEFINE_EVENT(vgic_its_cmd_class, vgic_its_cmd_clear,
+	TP_PROTO(__u32 device_id, __u32 event_id),
+	TP_ARGS(device_id, event_id));
+
+DEFINE_EVENT(vgic_its_cmd_class, vgic_its_cmd_int,
+	TP_PROTO(__u32 device_id, __u32 event_id),
+	TP_ARGS(device_id, event_id));
+
+DEFINE_EVENT(vgic_its_cmd_class, vgic_its_cmd_inv,
+	TP_PROTO(__u32 device_id, __u32 event_id),
+	TP_ARGS(device_id, event_id));
+
+TRACE_EVENT(vgic_its_cmd_mapd,
+	TP_PROTO(__u32 device_id, bool valid, __u8 num_eventid_bits, __u64 itt_addr),
+	TP_ARGS(device_id, valid, num_eventid_bits, itt_addr),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		device_id		)
+		__field(	bool,		valid			)
+		__field(	__u8,		num_eventid_bits	)
+		__field(	__u64,		itt_addr		)
+	),
+
+	TP_fast_assign(
+		__entry->device_id		= device_id;
+		__entry->valid			= valid;
+		__entry->num_eventid_bits	= num_eventid_bits;
+		__entry->itt_addr		= itt_addr;
+	),
+
+	TP_printk("Device ID: %u, valid: %d, num_eventid_bits: %u, itt_addr: %llx",
+		  __entry->device_id, __entry->valid,
+		  __entry->num_eventid_bits, __entry->itt_addr)
+);
+
+TRACE_EVENT(vgic_its_cmd_mapc,
+	TP_PROTO(__u32 collection_id, bool valid),
+	TP_ARGS(collection_id, valid),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		collection_id		)
+		__field(	bool,		valid			)
+	),
+
+	TP_fast_assign(
+		__entry->collection_id		= collection_id;
+		__entry->valid			= valid;
+	),
+
+	TP_printk("Collection ID: %u, valid: %d",
+		  __entry->collection_id, __entry->valid)
+);
+
+TRACE_EVENT(vgic_its_cmd_movi,
+	TP_PROTO(__u32 device_id, __u32 event_id, __u32 collection_id),
+	TP_ARGS(device_id, event_id, collection_id),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		device_id		)
+		__field(	__u32,		event_id		)
+		__field(	__u32,		collection_id		)
+	),
+
+	TP_fast_assign(
+		__entry->device_id		= device_id;
+		__entry->event_id		= event_id;
+		__entry->collection_id		= collection_id;
+	),
+
+	TP_printk("Device ID: %u, Event ID: %u, Collection ID: %u",
+		  __entry->device_id, __entry->event_id, __entry->collection_id)
+);
+
+TRACE_EVENT(vgic_its_cmd_movall,
+	TP_PROTO(int vcpu_source, int vcpu_target),
+	TP_ARGS(vcpu_source, vcpu_target),
+
+	TP_STRUCT__entry(
+		__field(	int,		vcpu_source		)
+		__field(	int,		vcpu_target		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_source		= vcpu_source;
+		__entry->vcpu_target		= vcpu_target;
+	),
+
+	TP_printk("Source VCPU: %d, Target VCPU: %d",
+		  __entry->vcpu_source, __entry->vcpu_target)
+);
+
+TRACE_EVENT(vgic_its_cmd_invall,
+	TP_PROTO(__u32 collection_id, int vcpu_id),
+	TP_ARGS(collection_id, vcpu_id),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		collection_id		)
+		__field(	int,		vcpu_id			)
+	),
+
+	TP_fast_assign(
+		__entry->collection_id		= collection_id;
+		__entry->vcpu_id		= vcpu_id;
+	),
+
+	TP_printk("Collection ID: %u, VCPU ID: %d",
+		  __entry->collection_id, __entry->vcpu_id)
+);
+
 #endif /* _TRACE_VGIC_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 569f9da9049f..d7524e3abad6 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -22,6 +22,7 @@
 
 #include "vgic.h"
 #include "vgic-mmio.h"
+#include "trace.h"
 
 static struct kvm_device_ops kvm_arm_vgic_its_ops;
 
@@ -795,6 +796,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 	u32 event_id = its_cmd_get_id(its_cmd);
 	struct its_ite *ite;
 
+	trace_vgic_its_cmd_discard(device_id, event_id);
+
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
 		struct its_device *device = find_its_device(its, device_id);
@@ -829,6 +832,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	struct its_ite *ite;
 	struct its_collection *collection;
 
+	trace_vgic_its_cmd_movi(device_id, event_id, coll_id);
+
 	ite = find_ite(its, device_id, event_id);
 	if (!ite)
 		return E_ITS_MOVI_UNMAPPED_INTERRUPT;
@@ -1035,6 +1040,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	struct vgic_irq *irq;
 	int lpi_nr;
 
+	trace_vgic_its_cmd_mapi(device_id, event_id);
+
 	device = find_its_device(its, device_id);
 	if (!device)
 		return E_ITS_MAPTI_UNMAPPED_DEVICE;
@@ -1161,6 +1168,8 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	struct its_device *device;
 	gpa_t gpa;
 
+	trace_vgic_its_cmd_mapd(device_id, valid, num_eventid_bits, itt_addr);
+
 	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
@@ -1204,6 +1213,8 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 	valid = its_cmd_get_validbit(its_cmd);
 	coll_id = its_cmd_get_collection(its_cmd);
 
+	trace_vgic_its_cmd_mapc(coll_id, valid);
+
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
 		vgic_its_invalidate_cache(its);
@@ -1248,6 +1259,7 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 	u32 event_id = its_cmd_get_id(its_cmd);
 	struct its_ite *ite;
 
+	trace_vgic_its_cmd_clear(device_id, event_id);
 
 	ite = find_ite(its, device_id, event_id);
 	if (!ite)
@@ -1278,6 +1290,7 @@ static int vgic_its_cmd_handle_inv(struct kvm *kvm, struct vgic_its *its,
 	u32 event_id = its_cmd_get_id(its_cmd);
 	struct its_ite *ite;
 
+	trace_vgic_its_cmd_inv(device_id, event_id);
 
 	ite = find_ite(its, device_id, event_id);
 	if (!ite)
@@ -1338,6 +1351,8 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 	vcpu = collection_to_vcpu(kvm, collection);
 	vgic_its_invall(vcpu);
 
+	trace_vgic_its_cmd_invall(coll_id, vcpu->vcpu_id);
+
 	return 0;
 }
 
@@ -1364,6 +1379,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	if (!vcpu1 || !vcpu2)
 		return E_ITS_MOVALL_PROCNUM_OOR;
 
+	trace_vgic_its_cmd_movall(vcpu1->vcpu_id, vcpu2->vcpu_id);
+
 	if (vcpu1 == vcpu2)
 		return 0;
 
@@ -1392,6 +1409,8 @@ static int vgic_its_cmd_handle_int(struct kvm *kvm, struct vgic_its *its,
 	u32 msi_data = its_cmd_get_id(its_cmd);
 	u64 msi_devid = its_cmd_get_deviceid(its_cmd);
 
+	trace_vgic_its_cmd_int(msi_devid, msi_data);
+
 	return vgic_its_trigger_msi(kvm, its, msi_devid, msi_data);
 }
 
-- 
2.47.1.613.gc27f4b7a9f-goog

