Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2F41D514B
	for <kvmarm@lists.linux.dev>; Wed,  6 Nov 2024 08:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730881845; cv=none; b=d7ezn2J6BoaxqYYIOvWa+OjhCxzf672Bx9aO55rf8PEbuAjskQG1rZhU5/lMZX4oS9BtsSHT4S8TvCXmw8K0PC1SLa0A8oahMrP8TPP3ZRYhxifdDXlfvpAi30LSBg/sEfG0V+xy8QGVRwSPQvJ9IlQCmF4lRfnogqS5lMx0FVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730881845; c=relaxed/simple;
	bh=tavsWSyECWwwbRMUfMpNbqjrocxYQjPLaI64Xy8DqdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T5UNYNL1APC2ws/pWG5MKNELs2TR4gGRxkFJTEGofRg9uQgEesXo2a6HXuwuUjvmnihw7prxdrREvlXmtDMJeJj/qB3dPZUV/rtLl/wV7vFNRPumvnrUgTFHoML/2nPTFNAmFs6EK6jxzTiJZAYwqt0BZWMPgAcdz4WWn4N+Fk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mG3dBMs6; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mG3dBMs6"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea8a5e862eso8724637b3.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Nov 2024 00:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730881843; x=1731486643; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=diXjwQHhYDrLApdizCzZAM2Cz7No88ZBnmospkxRJcg=;
        b=mG3dBMs6FmjsEijuv3o0BCJ4GZm7ICBTpDja9sBnJVLhaw8GFQlztzVqj85hZ72FSI
         NXxOytwWu80U5PCid0zVfwgRe7eM9C/pO39zGUL31ibTyu25OACJFFe4xyYCTY2bHIE6
         nOQkp5EKTOSyPhBqT6hoGKn0HbazX4DyvRYtNWp5MgPv2lXBrl8lqEQaT0G2k3DDQ42z
         l/P42DHwhI7Ht2aoQxzdsUJCf7RwfqMfZpSnbYV8TYxcoFvdvX7KpXC41Ad5TAu/nNF0
         PKAq17NwzgQmROLx3jL24dzVXr7KpjliBmnChS6NVGcSWpsnL1fliMKy4F6rnKT2INBU
         QPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730881843; x=1731486643;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=diXjwQHhYDrLApdizCzZAM2Cz7No88ZBnmospkxRJcg=;
        b=LP9t4D6c+c6ddggUuO1K9BmaHjtcx0VJC39M1i2T6soIYHjzYr1c/JclupYkUemGIP
         Ymjs2U6bzyBR1FZjFceouhkPHsMbCgeh2+2yLwDTEjyK8tYY+7Zv8J8M9d6B0MgG29bg
         a7yZrWDDPKZHuXi/7fIz/oObLot8S4705+sAIiM7XjUJNceDzpLtEwn8auUV2MNyCMD1
         1cCroboN5hXqqLzs+FleTnYI0uw5lFKXfaOeqH0uM2OC0AY9SeTNmitHKOkJRGLXn2pX
         4HLqMC+YexGP9zjvv1fF5F4z3VX3VDOJ/enEwY1tj6gS0mFv/jrV+5IDpWCbWBBWJv6k
         cdcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL9UOlxBw6hRO1KqcWN4t3nK4xH6JTqk0UzWM5NfpE+jeaU/TgZkSuuZtdNMsvKLjk8A3eRAA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjPMROUBBml8GmogtYFnDyc2P5fjIJNQ2rfkuRe1ygB8tjnl4c
	5Aarn3/vuv3uCDoBc7IlbZoRp6lCHHdYVgGE9toAfM3ADMbZeRPINXQiNfCjXTA9dCSf3vrl8gv
	DxqBOjBUfm3VVT6mcbJAkVw==
X-Google-Smtp-Source: AGHT+IHBjq15b6Y9u9NLiJuGhJ0HwVi1u2HdYmZIETeo0dLVKCCo/ZW6prnAhvaB3StzEMzIb/ffCzTWRHXU7A2VXw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:690c:4a04:b0:6ea:881b:b545 with
 SMTP id 00721157ae682-6eabf0290c6mr591907b3.4.1730881843278; Wed, 06 Nov 2024
 00:30:43 -0800 (PST)
Date: Wed,  6 Nov 2024 00:30:33 -0800
In-Reply-To: <20241106083035.2813799-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241106083035.2813799-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241106083035.2813799-3-jingzhangos@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
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

vgic_its_save_device_tables will traverse its->device_list to
save DTE for each device. vgic_its_restore_device_tables will
traverse each entry of device table and check if it is valid.
Restore if valid.

But when MAPD unmaps a device, it does not invalidate the
corresponding DTE. In the scenario of continuous saves
and restores, there may be a situation where a device's DTE
is not saved but is restored. This is unreasonable and may
cause restore to fail. This patch clears the corresponding
DTE when MAPD unmaps a device.

Co-developed-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Shusen Li <lishusen2@huawei.com>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 2381bc5ce544..7c57c7c6fbff 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -1140,8 +1140,9 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	u8 num_eventid_bits = its_cmd_get_size(its_cmd);
 	gpa_t itt_addr = its_cmd_get_ittaddr(its_cmd);
 	struct its_device *device;
+	gpa_t gpa;
 
-	if (!vgic_its_check_id(its, its->baser_device_table, device_id, NULL))
+	if (!vgic_its_check_id(its, its->baser_device_table, device_id, &gpa))
 		return E_ITS_MAPD_DEVICE_OOR;
 
 	if (valid && num_eventid_bits > VITS_TYPER_IDBITS)
@@ -1161,8 +1162,17 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
 	 * The spec does not say whether unmapping a not-mapped device
 	 * is an error, so we are done in any case.
 	 */
-	if (!valid)
+	if (!valid) {
+		struct kvm *kvm = its->dev->kvm;
+		int dte_esz = vgic_its_get_abi(its)->dte_esz;
+		u64 val = 0;
+
+		if (KVM_BUG_ON(dte_esz != sizeof(val), kvm))
+			return -EINVAL;
+
+		vgic_write_guest_lock(kvm, gpa, &val, dte_esz);
 		return 0;
+	}
 
 	device = vgic_its_alloc_device(its, device_id, itt_addr,
 				       num_eventid_bits);
-- 
2.47.0.277.g8800431eea-goog

