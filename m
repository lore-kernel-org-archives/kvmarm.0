Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190C1D5AB5
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 08:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881847; cv=none; b=UEew/Dkno7eRgUzX1JSUUK9uWa+1erxu9oune7Rc7DiC+lWfnIt2yOSahCvQ04N5VjwZrq/KT7NgZtutDVp6Lg8lMofp4EwK4QH8hRJU8kxO0l54Or2EIGzQSjqcbouexgkJ5iE+UhfnHyMF/0Peqfu/ki/dTSaNtTlAAEKAO/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881847; c=relaxed/simple;
	bh=tCG2vupC8Z4zzofbZHgX6YODMp9jrvmH6QRuS6LWQ1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M+wcLO2TrEbsmJ7DCt0ByTYMMOoHaWaGtQv7ocFfur3P09FklamssIjURUewCg6OrhI21eCCFJznrR1vEa8mpa0kYCVQbd6r3WuvMEKhJH8XEEP4TyFUfjdo24Yv6fpE73mwyK5jEza90qo/MiZBN+j11+cOV/e06f5pGAME6QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I4ABwimT; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I4ABwimT"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20cb3d9f5eeso6557615ad.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 00:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881845; x=1731486645; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9OqfUOMAqbpcWXjOPS3HeNW6CbTb26wA4+Tx2JMJgo=;
        b=I4ABwimT7oGiulreSq90Nb916O8Kh5HSgkrVF/jCPm/BHzdslk+oXR+kvtTYF/27ap
         YrpzFu+O8bMFjakcDHm0a2e2ZNcRYDlrI71cWRUFEVoXNmmzxm6Ec6jsBleR5e0uqMPU
         QLtqBYOV9gcIL+xttrbSHy221qE1RGvIoKtuPnAvuYTgqW4g1foQPOiOc2fFL39c6//U
         r79c4fVHnw9+PdmwAdoT/QX1hS9J4ubpCmvsY69gkF3nkWK/cEBgu8lDQGchgU6wn2t7
         qY0C2kXcrg7MEn9ycbWb0NZ+B+T8EipECi+rPtiZit/+m1P4JWw2fQYSj4ZzX4hBkbrF
         FxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881845; x=1731486645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9OqfUOMAqbpcWXjOPS3HeNW6CbTb26wA4+Tx2JMJgo=;
        b=VTfzy1fdi4uPivaS6/PQwQLIanjYC6xyz5pU+wRmDq7cZGTWO4AuOhazMAfGN9gDWC
         RbxawlsK0feQ/jkcEqC6kGCryeeAX/p8Jla2xLuPEZmAg2r9A+/OU8YTPsdA/w5pG2fU
         wYzdjW/IgmUDUn4HJ2pfdCSvJEGC5Gk9yrBG0G3mUG5WluAG6orxjYNZhQa+cvUFdbA0
         z9MV6TMzxkgyH69Z77u6b5yteKLKRXc2BxU1lom2Lve68K4VV+8GD6qDdTkOnXFZUOjn
         tOzAj/sMJVHeBFi27MKf45udoO7ZLnOhRoioYdJyeYLxymzNvTviRjdJ2iT2GX7mraDF
         s4Fw==
X-Forwarded-Encrypted: i=1; AJvYcCX2kioC2u+FRkEpHOpEXW0YWA8nD8Np0PsQRcgyAcvy2qO1hi6SlRG5Cy2mewhQs3NBqjxFLII=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjqk+UeP2dtWieyyoXymvSA3FPkR+5m0GfVauERPhelt7HQ+yG
	JQTEzMws0Jq3zyKRKYUC+2uc/+xf9lW45AXrgaDOYWiy+MBFaLhkIp8DUsl/tMfMwRD0YtZ7EgS
	yOy9yy6WZtxmGNSrxsUK10g==
X-Google-Smtp-Source: AGHT+IEIX/6hVDGOmxY1iHcCV7jeryOMcpYeUgvJ4PGHYdhp40R/dK9bTBilzwLgwCsXlLEKi3MnqQQmu9vQlZaSIw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:b686:b0:20b:8d7d:fe08 with
 SMTP id d9443c01a7336-2116c9c51demr90245ad.6.1730881844849; Wed, 06 Nov 2024
 00:30:44 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:34 -0800
In-Reply-To: <20241106083035.2813799-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-4-jingzhangos@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kunkun Jiang <jiangkunkun@huawei.com>

When DISCARD frees an ITE, it does not invalidate the
corresponding ITE. In the scenario of continuous saves and
restores, there may be a situation where an ITE is not saved
but is restored. This is unreasonable and may cause restore
to fail. This patch clears the corresponding ITE when DISCARD
frees an ITE.

Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7c57c7c6fbff..df8408ceae30 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -782,6 +782,10 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 
 	ite = find_ite(its, device_id, event_id);
 	if (ite && its_is_collection_mapped(ite->collection)) {
+		struct its_device *device = find_its_device(its, device_id);
+		int ite_esz = vgic_its_get_abi(its)->ite_esz;
+		gpa_t gpa = device->itt_addr + ite->event_id * ite_esz;
+		u64 val = 0;
 		/*
 		 * Though the spec talks about removing the pending state, we
 		 * don't bother here since we clear the ITTE anyway and the
@@ -790,6 +794,11 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		vgic_its_invalidate_cache(its);
 
 		its_free_ite(kvm, ite);
+
+		if (KVM_BUG_ON(ite_esz != sizeof(val), kvm))
+			return -EINVAL;
+
+		vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 		return 0;
 	}
 
-- 
2.47.0.277.g8800431eea-goog

