Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C72112EBC6
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419931; cv=none; b=HP7GaVj45YKOA6EaHXvJtlVkOBcPUC1xNg5zF/PDSeZj9lhDj1Q9X+oMF4rksrz9K02ibnJ4ELf3SsmAC0xiwFLbARlT0M/egBUo7APb4giiJ2gPNeLBXAqMEu9SGzVnCQQd4Vg7BMNToptuM5jTUCdzilesHReWImWDydwDCt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419931; c=relaxed/simple;
	bh=YhcdwzH90218JoOWdcc1NwAP0Li4AXv2Tb893sr7v9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q42WVp8QjMiimnhpCF7+cfuIrtXK2gqBA2A3msMGwEdSNzaOpimMaMu34XYXfhBItYZ9H+U991kSqvRgvmTTfAYjJAB9HalhcsFzyiP5WH9M9/BEtObDJaoSM5q/kKpbBBeFB9EJwO6rdReiwLvyyNFsgtnon8l8m9lrJQQaBBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M94BUB8V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M94BUB8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXAmMQrgrXIFLyB/yIKENXCHvnmz0ML8IZSHNgowrl8=;
	b=M94BUB8Vb8dCT00CY5v3rPnSWLjHuEnl2jXvkLdN6zN6gDwaukJcFAIYzBQcEQd3bgPSKA
	+vLWtsonSrhsCbv+m2ijZ0htb/AoGzT2dVynGt2154Q1ABlus7TQEjEhde9i0VLBXUjZya
	0z1i5uHouDzvagno7PG7ekPLg4WgKZI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-mZuwLf-aPQ-CP4oEk4SVww-1; Mon, 03 Jun 2024 09:05:26 -0400
X-MC-Unique: mZuwLf-aPQ-CP4oEk4SVww-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6ae099984c6so36075756d6.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419926; x=1718024726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXAmMQrgrXIFLyB/yIKENXCHvnmz0ML8IZSHNgowrl8=;
        b=n7GZb+R93uTI3Zaz/75MFwBqjSUvGYjS6hwGazI9NhL0w4DDKCREc4Ay0fTS4wjrrr
         KDsUE1Pd7sCDSIiXiEi0rS+92kuBMiGEGl5zmsFyutwpmpmUYRQi5XxNY5sh9o5e97wX
         9pfjjEPmfz0PN2BKDAJJJwXP1dN5H5snIGDyXLydqGAcU4yw/9xh06B/s7GImcwMoQ+K
         3WBPXpK1ffX/iAPcAPH7aSXlUz3hdcGRvfsxwSXM7zRK/ycjsdTcIUO1nLrg4h1+Z4Dd
         7hIk+AnaIuaeWWNyJ/xGbKrVqGfWryvtX81Ldusg/n3fuZWVof4tsEiy3XgT6TG4n6x2
         DZhw==
X-Forwarded-Encrypted: i=1; AJvYcCXwdJj1fSmOnztORUX8nZzJuWmbuVxJxLChUuQBacGgoxpAb/KlQUA2bvyy21HXqFuh1fzyumo80spz+3qOSe6Ed5yAJPyi
X-Gm-Message-State: AOJu0YyAa+XeZwrf/jAgb0gHWZlNU9bJoGak87dAOzX0eLsVHT9qUMcF
	SlSPnyTFWrwSBiQZ81sQxrYJJwW2XOL886nru/K/NWIdHPz4nAqCn32e/Wc6uJBIbErBgYyd0rC
	z9F6VSri0KwCMyefk0hh/WYWNq4HLhBP55BmcrJyVwyfuBQZjxLdTaA==
X-Received: by 2002:a05:6214:3b87:b0:6af:b70d:55e9 with SMTP id 6a1803df08f44-6afb70d56b0mr37258096d6.42.1717419926011;
        Mon, 03 Jun 2024 06:05:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLGteIxc3SVsMMA5OIbdqpk/I/qYvB4QX9ht7y8iaF54/X1TCt3zDCTxhbKhkVly5RHbTheQ==
X-Received: by 2002:a05:6214:3b87:b0:6af:b70d:55e9 with SMTP id 6a1803df08f44-6afb70d56b0mr37257636d6.42.1717419925390;
        Mon, 03 Jun 2024 06:05:25 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:25 -0700 (PDT)
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
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 4/6] KVM: arm64: show writable masks for feature registers
Date: Mon,  3 Jun 2024 15:05:05 +0200
Message-ID: <20240603130507.17597-5-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
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

This changes the mask for the CTR_EL0 and CLIDR_EL1 registers.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 39057718fbcd..8008120d021b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2566,7 +2566,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
-	  .set_user = set_clidr },
+	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
@@ -4125,20 +4125,11 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
 		if (!is_feature_id_reg(encoding) || !reg->set_user)
 			continue;
 
-		/*
-		 * For ID registers, we return the writable mask. Other feature
-		 * registers return a full 64bit mask. That's not necessary
-		 * compliant with a given revision of the architecture, but the
-		 * RES0/RES1 definitions allow us to do that.
-		 */
-		if (is_vm_ftr_id_reg(encoding)) {
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

