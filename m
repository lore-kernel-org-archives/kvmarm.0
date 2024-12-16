Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4234203D53
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346276; cv=none; b=KezZqfYkRu9hKCaB7amMYErAw9M4uAZXbl8rNiRlH16YLNMJeGwRKjq05YyycwzSGgXC4etFP97EM3ED3GvXN5zDHg+mbvaHdngCg/L69oEjRnH1OU+GJVCRqG21jUPmXJ0+DmVz5Kg5GYYOYGdFEZ3zgSL9TDgVnVc7GrnOFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346276; c=relaxed/simple;
	bh=1qke95D/idqilRmDHzMvcITXZC+tonFqQRQRTd5tuBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f5X0DP0xFVvhYtLmVS7j4Ze9Ho2O+IYYGe7RtImd+OPc8yRFZF7NkxaK7r1rOv9HHM3eNRYvRiFZUMRj7WC69CU/OMgmlP6STsTrkqO6n8+Mw43tkTfAHxsJrYq86xUCdLgfNHrKBlbpe6MbwlqmyyqEi5nYtz7DIkjk5+Iui5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RM5GNpkG; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RM5GNpkG"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4361eb83f46so33352035e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346273; x=1734951073; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDSaYlu5BNMFCP2Ps/7sY6DRsZy+2NDNRO3YTy1dJqE=;
        b=RM5GNpkGSUzRxCgbupHaE1+XvflUKBHsEp0eUGj6VrqDTXf8MUJrNJ7JH1BjeqUQZv
         gJVEfsCmqvutbNjbeL0zUIDrZ6XZ9bBAgtrdo7vPnXM9rSuyXpP9L0zzoU1dHi4tR7Qr
         T8tv2RsM8KJV+6hkYsVtCf8lXeCC2eQlvbeAZjmnllr//ixUgeUGag1g6NRC6nG61d0F
         Ak3MtTmWIASmxH4xZkLKFh1N5YUQiC6f5Z3JxhUu3KZ7HCIPS7HaiYPGy2CKdOsoqNbk
         lTOa32ktSoBtOnvzgbLft1QJq3JFoZTAm1Oy4sCjIwfBRftSN0kC4stvuDynZnnfntaW
         1pfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346273; x=1734951073;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDSaYlu5BNMFCP2Ps/7sY6DRsZy+2NDNRO3YTy1dJqE=;
        b=MEefqLS6TpHmovyOhCIBfS0jTFX9Kx7yrNu2wgcZV1V9c47oHFyiWlEO/4XEUPMoTe
         8irWFd/KBGMPaGPekgs3+znM9IbPUaodgU3PC+Nh7whYYjslZaPDowkkFFQ0mB89wSP/
         hW7vU3jimDiyKvlgLvyltHyQvj+nQmOX9lxbR2GYoZXcVu7wYiHde7nS/9c/w1WsDLZK
         6ISehVxmnxs7RTqJYrItDyulRIyTEoDcXmBbPdB4NpX7WkVWbPtj0wVU+UjW9FjvUwx5
         3Z9CBOh/ixdWhbGb9lNOe2ReoyHZSIOdlntDNx3e1RyFAhVx+adsyLZWxm90+Q8Izoki
         wdZQ==
X-Gm-Message-State: AOJu0YxEs94M/in6dHj2TCceBhLu09kBrDQ8ONll8u1lT5dlmboCC1Kv
	RwhTCY1OIt5cY4vVFxo4BBPAZYJHvSq9vJm6mXfDlGlCseoAt1bGKPC+DuRgzlB3rsD0fkYbFM/
	NjkfOKqYP5oTDOOFftuguL7SyzEVODMAcIClLccCQYN0Yv7vyscqMVx+B5mHcn9J0xP53rz0HQR
	UrFrcMFFvxCgkz00D1x/m6XbXFGx4=
X-Google-Smtp-Source: AGHT+IGTCUWt0z19T0g5/8JOxHn663C/7YVEmI38PMNTQ3Odt4zIxqDGQFfmtIF8bmQlzq9AaQluAPJkGw==
X-Received: from wmik26.prod.google.com ([2002:a7b:c41a:0:b0:434:f801:bf67])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c0d:b0:431:52b7:a499
 with SMTP id 5b1f17b1804b1-4362aa97465mr91799405e9.20.1734346273238; Mon, 16
 Dec 2024 02:51:13 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:47 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-8-tabba@google.com>
Subject: [PATCH v5 07/17] KVM: arm64: Fix RAS trapping in pKVM for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Trap RAS in pKVM if not supported at all for protected VMs. The
RAS version doesn't matter in this case.

Fixes: 2a0c343386ae ("KVM: arm64: Initialize trap registers for protected VMs")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3014f3295d81..25bbd4c99d30 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -70,9 +70,8 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	 */
 	val |= HCR_TACR | HCR_TIDCP | HCR_TID3 | HCR_TID1;
 
-	/* Trap RAS unless all current versions are supported */
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0) <
-	    ID_AA64PFR0_EL1_RAS_V1P1) {
+	/* Trap RAS */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0)) {
 		val |= HCR_TERR | HCR_TEA;
 		val &= ~(HCR_FIEN);
 	}
-- 
2.47.1.613.gc27f4b7a9f-goog

