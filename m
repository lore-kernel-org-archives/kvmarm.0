Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5530EF9F
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757349362; cv=none; b=gm/NbxJNJbvzDP6r2/YieRQcg3XVecYeFaRXP7Q9d+5nwENV84X5vwdYOHu6DPu0N2zaamwBBFqG5WfbCRpuubUEEGq+gAtiETQURcmMBGccSj/1T0+fsbHGOFEgikxeM8mkU7Ys7cnyhFexgDSHGwOm027EflJI13yWAbKOaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757349362; c=relaxed/simple;
	bh=6LostVtP/daJPYmbFFLvihLxnyTt/y/P/gXony6Gh7c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DFJC4OkMuaMUG6el9pYlu+7TyctBzEWqvl73N+0bZqQhedqC7SZa6orxCY1t6BMDUiYR2KP0fGAqbLwRst4neGjOh76OQbbr0Vbu9u4HKAE6oxbAno3HJFk51fmcQ9wseBpgYuEXFLdsNs19VDxcqx7o3zRmi3K+HbZVEOll3Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JsKzVkM9; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JsKzVkM9"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45de13167aaso16379965e9.1
        for <kvmarm@lists.linux.dev>; Mon, 08 Sep 2025 09:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757349359; x=1757954159; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WmM4LftI21357OgeVjH332v8ir12kSjHUiMiWxV6Jy4=;
        b=JsKzVkM9zVyJrlf5RKSRrGf36u0Dr0ZQzFiTFxG6/JxYEbulSo83xMSEvTkwlw4bni
         tPtqnVhajb0gHlq+rThE4Oson+6Sr+p5QqXGg+Ei03QpQ95ydnQx9FarML8IVM+WTbvY
         MYkENkFMZbsx3WjA6bUbhT8jvbSDNXlKFfIcbGX48fbx75ZhkDTOtbpGOAVlTNPAHLTu
         1x+rIcsWkJehGZdPiIvOUxmdEzREWP2h/hAcRO+4o3yz+IYy4HXGSBqU+zG39LN1D5HK
         NmrUYaMw9QnsatvdWd4qsn0gtir6OHwQ2T9WhxofyupdPphw2bWT2qlx+6rAX+JR5RL0
         p4jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757349359; x=1757954159;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WmM4LftI21357OgeVjH332v8ir12kSjHUiMiWxV6Jy4=;
        b=r5LnGfvo+7F94uzPmi3gvjcEYysH2YCbwkc5TnQM2Wd3+jthGED+HSV2lCeXSEGQ2q
         U947fdC2ty3MjsuFhgjurctsfxu3eX5p6BMPxjlXId2n24Xr8gZ+Oi8MZ2utQPV+r4zB
         TO15nzqL9+hAEmlHnNQ1XE8pUN/yG/cVNwR8g5EpfybkCn1xxEf88ttxLWMslngSvV0u
         51w6KTIqFcIkVE1zgXktjJnpukul6Y6y/CS65fG+SylYaxOWXewjuX9BhIdNkIUf9582
         1Ch5g1TFgYsi8+D9Y9WY6VLpgCUhuLEYFGFTXH0xb9wEtBXgxq0aPL7kJ2Fkm0LKo3Dy
         2zdg==
X-Gm-Message-State: AOJu0YxzuMAXIRQH9+J9jt3mFiHkUKFpjWk09pgW4MgSkoVEhPqWOyAY
	YXP8QThlk/bkP4LmkL+HtvihbC5IZ1SvxMPdPThJnW9DcsLlIZLhY703IIwizA8diDY90O2HC3E
	kzrVTFc+OXUACo3e6NJSY+XZZ5sCOcpISgpoXTAJxBNLviumZvm5mtLREtlqHfQNwMzlWalCEwP
	zfG5vjXQUOr8ZVCku3K72arzi8MQ5wni4=
X-Google-Smtp-Source: AGHT+IEPtQhZHhaSSiFrRywARpqA9kmZE1Y6TE2e26K2tyWQbsjjS1YtpIf0he6IaQ2gQJGqetaDUms3uQ==
X-Received: from wrbet15.prod.google.com ([2002:a05:6000:230f:b0:3c3:cdfb:e634])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:184d:b0:3e7:4265:66de
 with SMTP id ffacd0b85a97d-3e742656b0emr4522585f8f.8.1757349358812; Mon, 08
 Sep 2025 09:35:58 -0700 (PDT)
Date: Mon,  8 Sep 2025 17:35:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250908163557.2419780-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Fix parameter ordering for VBAR_EL1 assignment
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The __vcpu_assign_sys_reg() helper expects the register ID as the second
argument and the value to be assigned as the third. However, the
existing code was passing these parameters in the incorrect order.

Fix the function call to properly read the live value of VBAR_EL1 from
the guest and update the vCPU value immediately before pending the
exception. This ensures the vCPU's value is the same as the guest's and
that the exception will be handled at the correct address upon resuming
the guest.

Fixes: 798eb5978700 ("KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exception")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 71d2fc97f004..82da9b03692d 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -253,7 +253,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
-	__vcpu_assign_sys_reg(vcpu, read_sysreg_el1(SYS_VBAR), VBAR_EL1);
+	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 

base-commit: 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c
-- 
2.51.0.355.g5224444f11-goog

