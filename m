Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE2A8625F
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261455; cv=none; b=U99W0h7ok/DUonoME2UQ+utwPfOOTT/9SuNEvyWNiHTfRbr3TT8RtRwe4SMgKoL+NWhehBBpRZCYb2N7kw397aYSnRlrLkk6/oFf1tGqj9TiJ48ZXJIvOuLpiDwLMJbxmc8wUMqvgbRUKF5nGVk7IY80FZcIukmOXvaQ6HhNuvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261455; c=relaxed/simple;
	bh=/ZY0WElV1qyVskRlbxlPKdsc1RW4niLjg+VCX5k4aJs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QTaws1Rwaugzxm62twjrY/12CuV3AIcKN1k8FI/JO60eiIfWtpaPy/4aqR15RN4ly/GEF72gsRhu0L6iGu62KE7yWdb/yOoiM17vijuk+/J3Xue1HjFhe/YLMm5EoZZP7DHMbq7OowDf5wWNzv+9P04QjEd6EUzoW+dwtrnRbpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ot9kdcb3; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ot9kdcb3"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-615073c8dfbso87384847b3.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261453; x=1713866253; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EL3Bsp/oYXLXaU3J4TMClfwUNJ8SjgfNhlXj94JTkMY=;
        b=ot9kdcb3Gz4b1xvU/2hmCndCEzvPqn2LSU4zq9Ur5SK7yIoVh7dDHpaeyUGEXuJ2PN
         g68msMJ9/SEJaS8iWlfWdLQa8hFcEUMihtVjJiYTUR3i5pxSAWsYswEtG8OCiP2zqZI2
         wawKaTU7l16aYSLRqqNhduEw79MwZCj5pfyjUMUJTYgqEIAZt0Ripov9KvVHXCpwVIxh
         Q1CNWuZPZbq/Zff4dEoH9fboDBsDbxrAKVk77fcWXzz0+r50VRtGZPWpGfPLcHA//06S
         oo7IaYYM1IoD+Xve0x4mQvmju4/SGEWdXjJUmiEW1U2+3kjpXBXozRomI8CMuUG+byv6
         CaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261453; x=1713866253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EL3Bsp/oYXLXaU3J4TMClfwUNJ8SjgfNhlXj94JTkMY=;
        b=xAwth5QrKvYEmv6iqLwW4d6jkTwZ7c2n02f10D50/JFviQeMHheY8nGPqAGswcTfCQ
         lO2Sc+AjZ8lLfCpf+gSsEXNYXBahYv2rbZa4ASXWurqcp6tx5QU1/k5EU58/yzE4kYbL
         1FxwOPQiQ8eecQWKp0DRRicrYm1v5WHJ2rb5woT5Ik5AlbIyiUW5OfR9/k/B3wKiALN+
         CDti/5LsGEttpHtMeOMFwhlHI0U5b2RhwziroKNi2+LmAsEEQ0WS9qSAy1Y+ALDuOCf6
         zTOvKJhnZ8RYK/ih1zOmbEOt2u/CTJO4sO4jF6ZGvih9xfRg7JD6PMpImZNC7CRuyeYr
         V0zw==
X-Gm-Message-State: AOJu0Yz+HUCqdZ7zg8/jSFypMRV6GLbZRtdVTczYRYQ3Uz4Hsuvdhaxx
	DoInFTNxTALv/3jxnjhxNgmfepxpabTCoI8LQu2/r2EZDOHad18NNIIlthV66Xhylyev2LbP5XU
	1qm1bJ4B6z5c0oa7gmG8mBBe5SOaTRQQZoiDGynf3zJIvQAHoY5HFgsLdGAKvWVQbU7OC0zh78X
	Ild/8z3ANYZf8nPsALMOrtYvXpSys=
X-Google-Smtp-Source: AGHT+IFqGQEwZphq9d05MJhShS4mtIS4qTyrSqr/boxwYFHDAtYDaqbGAcVK49Y3ZqyoUg4nMqEKEcQPDw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:d554:0:b0:61a:e12b:fb07 with SMTP id
 x81-20020a0dd554000000b0061ae12bfb07mr768109ywd.5.1713261453589; Tue, 16 Apr
 2024 02:57:33 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:14 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-24-tabba@google.com>
Subject: [PATCH v2 23/47] KVM: arm64: Add PC_UPDATE_REQ flags covering all PC updates
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

In order to deal with PC updates (such as INCREMENT_PC and the
collection of flags that come with PENDING_EXCEPTION), add a single
mask that covers them all.

This will be used to manipulate these flags as a single entity.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9c4bed737d35..e123bfbfeceb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -799,6 +799,8 @@ struct kvm_vcpu_arch {
 #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
 /* Target EL/MODE (not a single flag, but let's abuse the macro) */
 #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
+/* Cover both PENDING_EXCEPTION and EXCEPT_MASK for global operations */
+#define PC_UPDATE_REQ		__vcpu_single_flag(iflags, GENMASK(3, 0))
 
 /* Helpers to encode exceptions with minimum fuss */
 #define __EXCEPT_MASK_VAL	unpack_vcpu_flag(EXCEPT_MASK)
-- 
2.44.0.683.g7961c838ac-goog

