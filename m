Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA6A12E75
	for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 07:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715671390; cv=none; b=QK4FzpoG8vDup2h9hqx3dRPvHjU92lyNZhUhWa5JyDMbSODS3BvomgGq7gmeGl9AWEw+4yd9XuNH5K3V9u/wkGD7RMm6FnOq6TRZRXWwBfIbF4cZaB/wfoMGXJyOoZ3qy6nZrPKrckdMVL6Z9c9RhwRZM0jFYMoek9gekQdxz8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715671390; c=relaxed/simple;
	bh=t7E4Xq+CwDIyBlgpDlmVyy3gj5a/gnFSGaWMtzUgsUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bz/i2lcChlQWX0OIpBCEkZ1QtEw1V3ECCW+4V2o3YvkVYgKfYSCMhC9kl50MYrGLQVt81l1heT+LW6zsZPcNDGm1YVHdqA/P903sU5/JhdczR3s4QndeUgkw80ehOIe88vWT1jIPYDxzUimT5kQBb4pEEvJzkeV+4YTEB7Y8Djw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UN41xCu5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UN41xCu5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715671388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=edf79jeIcR6SIIHgF1L+nP6ohGfiMC191SZcpJswp0Q=;
	b=UN41xCu5DzZRi68GYhxSYBN6wPIPCajr++ApaRfQOBJMxsjk5aFbpfRPD93lV+7Pl6DEws
	aLMTDeJIkOI+FF1I/gGqv2Zz0+qITvUsrSCvixIPYp2btI3XJDoUH64TdS35kz++bv/Wx/
	yORsTO/I+h0/+tus2ASPylYvpg+3wuQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-wdbUTF3JMk6h4sAe5PdFug-1; Tue, 14 May 2024 03:23:06 -0400
X-MC-Unique: wdbUTF3JMk6h4sAe5PdFug-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6a14d0e6b6bso57413666d6.1
        for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 00:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715671386; x=1716276186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edf79jeIcR6SIIHgF1L+nP6ohGfiMC191SZcpJswp0Q=;
        b=mYUrZM0v/8Q+akgV3rgYGTCNym76AWgslSL2kGtguWHTHHWW1dC/aBh5Rvhos/sSPP
         Pw22UyU9vfgIy0DmVgPw9lsxB4FtbvgI8HDytufJbIctDamjAfhwtVAOpG2sxz0uxrlP
         b2NDon2ZU3y4tPGsMub/dKEr8Ob+NK5YASML1aawce7YFqp6ntUG1V7u26s5hzPM6faC
         Iskv0JzsiW3s9rnoAr3y+fww5MoTr9IKLvkD/81f0H5CP5l05bhOXaHmTKpVINiHlUHL
         ipKQAekYdWdHQsNIWxx3mTqHCz5WC6LV3eMBtnb634xZlYsGoe9n5eQEuTptYm+L/4SA
         j4MQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6oHAfS9D26MF5vBFAZuLTvT29heGvx5FBSuZTTEM9gDXfycpIvzuZMJbdtTeNrLcXj2nNFFsluBAqVaXKnBMoNd16Ikej
X-Gm-Message-State: AOJu0YxoOKZUSg8uMslmtyNRa7LmVD/sv+KQrphe9j1rEQ044PXgOPjo
	wwfxb/mOSjvNHlhicSAHJ2dq+FD7opUO2y7cOE5hKuvYjLSAYNZ8/BLepb9S3sGWD3Daln3sD35
	IF9C6+gWG9L/4wykYj6pxkic6Wxi/de98IkD9F8NjENUXC4pJJ548Dg==
X-Received: by 2002:a0c:fe8b:0:b0:6a3:27b4:9b72 with SMTP id 6a1803df08f44-6a327b49baemr101393676d6.5.1715671386025;
        Tue, 14 May 2024 00:23:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHH89ioZLBSNiqjRiyo8fWL2ZJPx4atue/rPXREABDqOjqAEr1TFGlquEEfDdLQbtkO/SiRlw==
X-Received: by 2002:a0c:fe8b:0:b0:6a3:27b4:9b72 with SMTP id 6a1803df08f44-6a327b49baemr101393586d6.5.1715671385677;
        Tue, 14 May 2024 00:23:05 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1ccd4esm50917516d6.97.2024.05.14.00.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 00:23:05 -0700 (PDT)
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
Subject: [PATCH v3 4/6] KVM: arm64: show writable masks for feature registers
Date: Tue, 14 May 2024 09:22:50 +0200
Message-ID: <20240514072252.5657-5-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514072252.5657-1-sebott@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com>
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
---
 arch/arm64/kvm/sys_regs.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8e8acf3dd9bd..1b6ab483e21e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2562,7 +2562,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_CCSIDR_EL1), access_ccsidr },
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
-	  .set_user = set_clidr },
+	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
@@ -4121,20 +4121,11 @@ int kvm_vm_ioctl_get_reg_writable_masks(struct kvm *kvm, struct reg_mask_range *
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

