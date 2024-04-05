Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDCB16C6A5
	for <kvmarm@lists.linux.dev>; Fri,  5 Apr 2024 12:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712318491; cv=none; b=Kjrofcujuaj56sBryIgHX61XS+hT5Gx6CVNW0+Z71S3jjs0YBSlmBNkvCTeoMhuBK4+qOM8U7DEqJbrZZiZOlOPVCuTtfLHK2CSr/+ZE/7es6yMZV3vWuLRZuUG25eg4sEiYqkEK4LmqHck2GtGqFWJPzJt1siqVCM8Zth0eB4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712318491; c=relaxed/simple;
	bh=4UJ5Fg3bfU8lfARbEPZ8K38xQekfzxdrdG5SQuwKNMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g69boMtCgVuxUXjeaFeeuTMmV8PL0LTaJpSYbGNepZo5Fj5q4syfqZeTewD7NokQszL89DWqE4Egj8GEcHeTTI17WiuYl7HJIFs6Nr0sdfqv7Rea+aGPe6VoLrY+LDimvtzEzzxRJ2/R5pmRb3yfFy16LA/dZbLlCTF+KOJA25o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzhNU8Ix; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzhNU8Ix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712318488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rn4BMv+SOP2Xe0y3A99nPyLC4GfuU+9ShaoCAlDA424=;
	b=fzhNU8IxZ+RmgtIZbj2sXJmCOSlOojy2kWNnUwAz0vPvsF2BFgn8EyQv2qiAkjsQ/dHOUC
	ElmO4ST9VacpAM1DwEez2f+aihz+OI5KLiSTfTIDRsVSjxb5H30xa8OzPYGu5/HpSfOoV1
	Bb0mtp6PM9rQLqp3TeH52BHsHbMyrzw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-m9ZLvD9wM9SAXQjs7ShNeA-1; Fri, 05 Apr 2024 08:01:27 -0400
X-MC-Unique: m9ZLvD9wM9SAXQjs7ShNeA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-789dade2871so240463585a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 05:01:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712318486; x=1712923286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rn4BMv+SOP2Xe0y3A99nPyLC4GfuU+9ShaoCAlDA424=;
        b=XDypu+K5TKusFH+JV7MLLWA0d2oZ6EVBK2lLj43Q/Qi2i+tvrZkZzjL8Vg0H5gwk9u
         Rw+54mOFX1pZi7om8phS0jTIpl3VLqC0dBamCNmLaVPW/NQ1qzLLGeAfsjZMQdoFkcQN
         Nf7dUAS+F4Ppyf2TpC/WIr9S589CfcKHHaP+Wm0IYbJTLouxgoHV2eRQtjMRmMHkYKyl
         7NNXyXvGXh4aCTFwgKwYg1oY74EUeuuaYM6a3GeuBA34ODZSPxNNATGj9aOMtuQKFqVt
         DWEpV3kKPzW+2iTV3fx4H+FeLGVvzE5WnypO2tr23sl1AIee2wlDQL8cwyM0FSnaAjA+
         1v5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxxX7foOEb6Mukm9y7i5bHOO/api0Z6YsByA45QTYO+NWTqga04uSXjRdHCmdi2eJ1Ex5sD9PCqa0TPt8LrN5PaKbt8FJt
X-Gm-Message-State: AOJu0YwEhD/RDWs3/hjnt1v/7lPNy4qRR4sbnO6snITvG4BdCn4Fre0Y
	e2z/fQmLkwzlxD3S9jfcWlk/ukpD7ktCu8+d2Ts6qnETWRvT+aOAK3z7H3FrPyIaI8JRHDuXAPK
	LEpaePXDT7qDwTXdm/d1Fl+XpF0av/m5unxPiwUHUUUva960t/AMbevmpmc02Pw==
X-Received: by 2002:ac8:7d0a:0:b0:431:5fad:ddbd with SMTP id g10-20020ac87d0a000000b004315fadddbdmr1508851qtb.29.1712318486531;
        Fri, 05 Apr 2024 05:01:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJoGGlIt1CxA4rAZezuA7q+tZShCN/ywwM2H1k89TmnzVpNOpAzo4NVsKSoiRJE7N6sIm0dg==
X-Received: by 2002:ac8:7d0a:0:b0:431:5fad:ddbd with SMTP id g10-20020ac87d0a000000b004315fadddbdmr1508823qtb.29.1712318486257;
        Fri, 05 Apr 2024 05:01:26 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4c24001316a1e598258370.dip0.t-ipconnect.de. [2003:c9:3f4c:2400:1316:a1e5:9825:8370])
        by smtp.gmail.com with ESMTPSA id fb17-20020a05622a481100b00434383f2518sm679808qtb.87.2024.04.05.05.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Apr 2024 05:01:25 -0700 (PDT)
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
Subject: [PATCH 4/4] KVM: arm64: show writable masks for feature registers
Date: Fri,  5 Apr 2024 14:01:08 +0200
Message-ID: <20240405120108.11844-5-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405120108.11844-1-sebott@redhat.com>
References: <20240405120108.11844-1-sebott@redhat.com>
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
index b0ba292259f9..947aa9c0784f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2505,7 +2505,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
-	  .set_user = set_clidr },
+	  .set_user = set_clidr, .val = ~0UL },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
@@ -4059,20 +4059,11 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
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

