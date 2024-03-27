Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82EC14831F
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561050; cv=none; b=aLxvr6kLEW8VG9Rk/D33vd2HmJ9sDAW9xWI3pST5yjYo2n8AXSETVYuvbLEy1/GzkrsOzIYNV0TEWIrBoqJrdSmlbrL8sTL55uCmMmosNCma0eZ1F/iTKpCaN9ovbeKTKReDuKefrJJOJBwADm1RuNzPYYO217FHuvxG3GWyWKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561050; c=relaxed/simple;
	bh=5w/n7DL7Y9AlXl6702t3X5suiD0PfIMFgSP34TgYdZc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bvYbo1dFl7QnO2/7ZZvaf2h9OEckl45vUXjRUWjCH/XrssoubZHn/MxlSgD1PtQYBN3flDPka5Zn5Ad50y/65BCddrnENfQ9rEV1nCeTHglg7s5Vmvt+zkBxsO0ctNke07ke8VDMkUt/u83Vs2eR8pgVsj+7q6UsemYpbTOmCBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FD7TKaJW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FD7TKaJW"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33ed22facfeso7281f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561047; x=1712165847; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hHLUVoz4koDF700d29dUPb5cj6slFDGs6KTtOQVD8zo=;
        b=FD7TKaJWNjLALcylTKEVFVPtotC5HojJkfoTh9CGK/ys2z2Qi3fyeo0qFc8XlMwrCt
         KD7tRoYMcIgT0bRsHyy+JWk9BPyP4CgyJXShwakrDK2uMPgB3vnqsb80WLbTLM93x3K8
         nVRnAY1pbzUMBci/61nUNgx7iowVDSXQHRK0MR32G9YtI2Nrt38cdtBbGl8kGxhQJlOE
         NPhp7eEW5BQt2ql10FjUeML9SsRI1gXv1VFO0szaS7WcP6pRkqdZiQ0+aN9yqaMLEIs8
         I28kCNSa8cEaRpS8BVxocI7VR3OMhEHz9/+ytXo6e1L5bek0rkgtlaWwbEKDhIUTvFx6
         ENvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561047; x=1712165847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHLUVoz4koDF700d29dUPb5cj6slFDGs6KTtOQVD8zo=;
        b=u17xKbH4pB1pNVNIRNlQ7rKJA+quihwpxSfnCuEG2wt17pxwIMmgLRBvwi16++LF5v
         Oz7j3ugqjRETWpBOYRdoo0MJqQqq2TNyoOWhtnITdPfBsT/KbUZAxrdH8uYZwqHC9lyE
         Zws0EKSsB9xGv2yWy3pbI3OeAXTjIy0sXAuuXGkBavYfMpNIhUkbnlLMoB+Jf/YH6pK+
         /kUd1o3gmHIzN0IEAVOw5BC2BJ9ifybmhzO0OH+OJ+8u8c4KAIM+bftHNtOY6YJmWy+c
         UB7dqF6tjAsF0MQGeHwBgkWxV5Hqzd3QcLmMNS4UQ5Q0as674xnufcokOEPNsheHIz3W
         yoiw==
X-Gm-Message-State: AOJu0Yw21DcGBqmefmy463ClUf/8iH4U3ZfVKHdv6Kckh9m534HiMzqa
	w5cFY3tmXg2zqJBiBrge1YtixU4OJkayPL5lX+bY82JcUr+2B//dtgGlHUqoB6Zddvpvwy7Rsf6
	JRQrBN6IlAjs2G9d4RcT/Mfvo2Tq1YTKTbCYCnt/KrBfehleAkmPxtrJMNcEZOMo6nEdvTpW+uw
	qIX2FDwedErPYZ9l5zQuh8Aw2vD3c=
X-Google-Smtp-Source: AGHT+IG+DU1+DU/o80G9rBB8unjUs0xznSbKBLQWted0c0YMHacELCvaMWeDbsR60npwX4e68UL6pGUs1w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:448b:0:b0:33e:cab3:4c27 with SMTP id
 j11-20020a5d448b000000b0033ecab34c27mr61wrq.5.1711561047304; Wed, 27 Mar 2024
 10:37:27 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:30 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-44-tabba@google.com>
Subject: [PATCH v1 43/44] KVM: arm64: Advertise GICv3 sysreg interface to
 protected guests
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Advertise the system register GICv3 CPU interface to protected guests
as that is the only supported configuration under pKVM.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 970b0cf72f7d..40bebcffc9d0 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -45,11 +45,13 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
 /*
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
+ * - GICv3(+) system register interface
  * - Data Independent Timing
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) \
 	)
 
-- 
2.44.0.478.gd926399ef9-goog

