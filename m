Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3B34F887
	for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715951901; cv=none; b=O2e0y7qOfMx2Iykfu3nBzcB0Tz7JDsYVFrM8Fj/tjIIzlP1suk+mNt26/kHOHPRShl1EUUITXQGyPqgTI0ozXkUHKy/pQ9sbfchaf3Wzli+V+N0o6FmpD2mHqf+9GTcsicjP4C7nMFFDaeq01wXTEmQzOrncECAEE0LnAP7fbHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715951901; c=relaxed/simple;
	bh=USDqnt0C042mDQ85oIzrggWipt4qCVOD7T+Q18fyYKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IMaIQwOxj7iJ0KWnpCUxT/M2gjQeCbWyhg+cIPllisc82Ws8SzdlOH9VKgPjxPTHLHMYyJDRMr1VLnqeNDdpnYif4lVbFeusQDfT5Yaxsdid2X+hNBVJdkSfT03v1ugEEWlN/sRaFxiFSsXACu8nZtconCtNy3HDWC/Tgjh03zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODpJOqlj; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODpJOqlj"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be5d44307so149888247b3.0
        for <kvmarm@lists.linux.dev>; Fri, 17 May 2024 06:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715951899; x=1716556699; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qVdEbOXx9MOG+bTq6aQWXhaGPeEByVvBsRBOQaUyERE=;
        b=ODpJOqljOM4plkG+sUbfS0MNsP8TPkms1EyKEn9AJy4PWyDRmq8hMw/XARnQEkTOH3
         EnwDhKfxleuFPnDp+gGcr+KPDXhfCwqCUygMJEcbfO8PiOE3odVKB4jAV6uLvo8bFHps
         cTZGtpd0Ienwn4fU+yzhpG4JC+HImG+VD3dD/P2qE4j8SX9wgu272YVd3cKTUCmK2ADg
         sQsjwJQqQWP0M9/sAM0g/cPAVjWOcJGhJRWVx/ghNb5ll57DxpWxxFU5Zu50rOXW3roM
         CGR5shL2qTS9G5lqm7E62yyGXbBKUM5RalTqvF3h3XqumdEUHDjr/wIVENXB/Rj1AaGS
         A8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715951899; x=1716556699;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qVdEbOXx9MOG+bTq6aQWXhaGPeEByVvBsRBOQaUyERE=;
        b=e+qhk/dwX28xSxDqCTu54JUysxNWUoDfYIelUva7Yz4Wf5MwYJLFtSAmXjZCRac3Bd
         SK3IaMcnHXuayPddT3M5pdW+en8eCR2XwCbXT+wuSXVyflJjHRgQWZt5018qPKuuyLPC
         ZnqPfXqs1+ngBC81g7jk1lYq5X18mMQWasBGxbNPhcOP9gwXlhIn1b2EswS2611iqt1o
         cbw8A7jlTv5u7vQ70VAk1XVyIhA+Lvm6FxNmzZdGDErUGV2NQgSBXmQrI+xJwItVE1Sg
         MNvLaRYvPzI0rFCFDyjhSuNJQETJfLx0nz6D9RqguR6pwreCEOsDu+B8LaSdvA1I1XEw
         HwuQ==
X-Gm-Message-State: AOJu0Yy8hFM5+klhqxoz+cOLMx8VxdExDz0rvPZPb8ZF8rcas22mNU7Z
	fukzq90wEZpXRoQntitPY3vAvu2ictDrrJQDIibqrlNtKdwGhDDwHCHcgXSu4AQeq0b4b9YwfXr
	wmHAjlymt1CDn//EgrX66MeW2QYMXOGuX5XhlAlvZrZ5gg1D4WXxBh7mUubpy4jxCtoAziiEKC3
	AoEwBW3uN5brLQP4aD9vSoCYLYb28=
X-Google-Smtp-Source: AGHT+IFu4xWqso28SdQtQi+Z/57nxXVkCa8pGDFm0D3eMy9K8b368o6GYN0EaIVqFVZzIZX6I7aPYxNX3Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:4d88:b0:61b:ec80:3137 with SMTP id
 00721157ae682-622b01491d7mr49443427b3.9.1715951899059; Fri, 17 May 2024
 06:18:19 -0700 (PDT)
Date: Fri, 17 May 2024 14:18:08 +0100
In-Reply-To: <20240517131814.719933-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240517131814.719933-2-tabba@google.com>
Subject: [PATCH v1 1/7] KVM: arm64: Reintroduce __sve_save_state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Now that the hypervisor is handling the host sve state in
protected mode, it needs to be able to save it.

This reverts commit e66425fc9ba3 ("KVM: arm64: Remove unused
__sve_save_state").

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/fpsimd.S      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e80464f8953..2ab23589339a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -111,6 +111,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+void __sve_save_state(void *sve_pffr, u32 *fpsr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 61e6f3ba7b7d..e950875e31ce 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -25,3 +25,9 @@ SYM_FUNC_START(__sve_restore_state)
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
+
+SYM_FUNC_START(__sve_save_state)
+	mov	x2, #1
+	sve_save 0, x1, x2, 3
+	ret
+SYM_FUNC_END(__sve_save_state)
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

