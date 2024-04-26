Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D09D146A7A
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128609; cv=none; b=VP9JzN5pG3xYuMmCyPQ2yvtrpPOf3GNAwtbFDAbmWjuc3Z/nJQuX1B9HxiTXbd16f705VSEWjfRm1tn12EzUP9QeS7JLG2RwpoumPBwIXhltfhju5JxLsF2Qniqy4UJzEE2jwoTLbrQ5YXjA8ErJLLuq3Ig9SJTKFZuwUV1llMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128609; c=relaxed/simple;
	bh=jh0NGErGqzNPQk8HfQs0ty56UQwvTZ9Efo3G7pxJW+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PsKCeYew8X1SSR7otDdZtmiQ90kVDuXhPbUxwLLUCL5zOpe92uSsww/b70HSv7H+JG/fU7QEywb0o1DWgpv3vVq5QehMnsv3R0C3YlBh3VjwME686fxuX3aGrqZlDriQZt7bUCS0rVfA/PvWCY5InhJ0m3QCJ9/NA/KLnW4jFCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcL5udLq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcL5udLq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tBEVlwbbJPUSSW/SmfUHJkSUS/tMVeS+WCfEWVSGRSA=;
	b=RcL5udLqHpbEF0Q26led8VKhKMVU3SwIVOrAYhQubqocPPNbIrj03DYsLDsIssFRbxaH9x
	ZQNW/T11EkszI2WQCXvMZdgBUWTg2t7ofRC262z1RwXhaXDpLAD4L6L995lTyekTz8zSqz
	AEMbAmeIoo0XirvsC/ZlP8Hd+VVXlfg=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-LWNa6suXOsGaQcnO9OpTIA-1; Fri, 26 Apr 2024 06:50:05 -0400
X-MC-Unique: LWNa6suXOsGaQcnO9OpTIA-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6eb821ceaa7so2372594a34.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128605; x=1714733405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBEVlwbbJPUSSW/SmfUHJkSUS/tMVeS+WCfEWVSGRSA=;
        b=bbOVZwXSEUa7qqWo1GpYyxN5f/B5GFPRMiSLdD9cVFLQqzsOOWXuwzH7Cpq9h+uNMK
         RVrbqSM7oasqAr38rWjwIV34nnmOfq7S481lJjPSsCmWLYMOl7OiZX0aWtATE2EWguT6
         HjRgSxGr9Cj37ApIBxmk//5pbDeAIlCsoMFTneuh7M20cuFggG3ONRC5TsX4H8KV7mdR
         YoY57jgQdDhf3TjdCQlhOiCRootm73w0vh+nk7AvpGDXRE9/88ozD7eVFZIJWbIDvjy1
         TbKhf9emEu7GrTxPrysqx2osJggm3zOZyQ23C9ewM+OGSgybNfRUdjxaBpvxx44jpMB7
         MyWw==
X-Forwarded-Encrypted: i=1; AJvYcCWbBb/aeT0CVKKWNPmSuwzkF9zrm+Vx2oFNtotoAFqZvwA/R3k5I55+nX9MCugjBm49kyX0okXHq7wRYtW17kAt+6YxadX8
X-Gm-Message-State: AOJu0YyWYgGGim+FCH6+Z7k/PsvDmb97KJV/+afqKQnfIfrpuTPc7evW
	+cKpHKrseBxim3PtC3J4HToSu6mOp4wFF+DquD579TTLdV6TLTwMEPV1iwTZgrxarwgZsKtFqIU
	oKzgRj8E7FECxReZM68WxsFSNVtQ9k/5tSeOha9yKsm8Uiu8LNJt5iw==
X-Received: by 2002:a05:6830:453:b0:6eb:cddf:a783 with SMTP id d19-20020a056830045300b006ebcddfa783mr2269777otc.26.1714128604962;
        Fri, 26 Apr 2024 03:50:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMwtq9AaLj7a7CoLw8WnO6n+wHmWUkrG5Ru4V9/wZCrwSv2FNYib3sVt3Sw6963MwbFEf/QQ==
X-Received: by 2002:a05:6830:453:b0:6eb:cddf:a783 with SMTP id d19-20020a056830045300b006ebcddfa783mr2269757otc.26.1714128604644;
        Fri, 26 Apr 2024 03:50:04 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:50:04 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 5/6] KVM: arm64: show writable masks for feature registers
Date: Fri, 26 Apr 2024 12:49:49 +0200
Message-ID: <20240426104950.7382-6-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426104950.7382-1-sebott@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com>
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

Instead of using ~0UL provide the actual writable mask for
non-id feature registers in the output of the
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.

Explicitely set the mask for CLIDR_EL1 to make sure we present
the same value to userspace than before.

This changes the mask for the CTR_EL0 register in the output
of the KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2fe3492ba3c4..7d5d55e5c16a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2532,7 +2532,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
-	  .set_user = set_clidr },
+	  .set_user = set_clidr, .val = ~0UL },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
@@ -4087,20 +4087,11 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
 		if (!is_feature_id_reg(encoding) || !reg->set_user)
 			continue;
 
-		/*
-		 * For ID registers, we return the writable mask. Other feature
-		 * registers return a full 64bit mask. That's not necessary
-		 * compliant with a given revision of the architecture, but the
-		 * RES0/RES1 definitions allow us to do that.
-		 */
-		if (is_id_reg(encoding)) {
-			if (!reg->val ||
-			    (is_aa32_id_reg(encoding) && !kvm_supports_32bit_el0()))
-				continue;
-			val = reg->val;
-		} else {
-			val = ~0UL;
+		if (!reg->val ||
+		    (is_aa32_id_reg(encoding) && !kvm_supports_32bit_el0())) {
+			continue;
 		}
+		val = reg->val;
 
 		if (put_user(val, (masks + KVM_ARM_FEATURE_ID_RANGE_INDEX(encoding))))
 			return -EFAULT;
-- 
2.42.0

