Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8750127877F
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402185; cv=none; b=gEvKca+HRgdU92j4amJuZOBS/6akn2C+Kw+E5V1NV9sjwMFqRyDOe40eTwIwN/s0umG3azjaWTiLWLXHaGEHCmILL+1TZP4OIYLfPEDrUR6KOuiEeDutJ/SO4h4+B4xZubY5BlP+9M8i/hsf3ZT+LGSXouYmjEbehOpx8dBMzVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402185; c=relaxed/simple;
	bh=O9b+2I7xmpCbm3zTXiRuGHOenPphRrzOgACr2YXvmNg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SWv8gu1EP7Qv/LuMWtagnWel/sXXIMj3ToNOrRQLVNQdAi18Pwt9Em1cOej+GS97A87apVU9qgjfjxVXXzmkY8p8aBddKXWAb2qSZmgnOGvU15ODTw48ssUsatqFMBpnYjwmZ9mm8+ZJC21iXpwuXbR0aV1FhBWwnbKZ7pD+SKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rtlVbq+K; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rtlVbq+K"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b78329f180so4070938f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 06:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754402182; x=1755006982; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0g5s/vMNa6k0VF8k/74mjwV2z8bECBFX7KuPQJtOVcc=;
        b=rtlVbq+KEoctvmz7SA6hSBCAYokSSekPkKtmmbEntVCHHiXGLpAG68c21ODW+XNOwe
         N6K4w5O2Y/viJTjUhTS0GV2eETEo+nvGXMQcVJyeGNcpxZHWoR1BiU2DBNIsSvEUlHV7
         or+Sqb7LHc+fX12Zu3Uvr/bcIuts5izFAHSsklascKXY0cqpl1GUgmSYQ3lCo58Xcuye
         QmViZvBdUFt3IyQsM8Q16Sh8rCDLcPfE/l3Jik4qEngiFp9BiP5SnOs4qYSTCmL7VymM
         lKM9NpyDEPNnK2xQ0K7Va6XNCuZ5+H8omkCCNbzsHvx668bf6+jNK1+mgfbuFMviczWK
         jzSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402182; x=1755006982;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0g5s/vMNa6k0VF8k/74mjwV2z8bECBFX7KuPQJtOVcc=;
        b=Phdbvi+yA1euh+xj2RTGYjLRqoqgAghUlipDQMRw1P5vhvYtmLF+ef0N+Na8lFcVRQ
         pDsSfYhcwpzNr1+YU+J3Yopz/+ZM/wI6Bg80JmW+TMEhugNmsTO0FV2hrwiBjaxCBNUu
         FSjdeny+739dOG6ThFDOVzUaIpaKgl3CMLdQnnUX3JkER9IfXEGcRdjEkjWegPiJmpBt
         9YCuvIEfCQ20tFtEEb1+Nw6ODyzdoYNzm3J6VWReRHBMY9Bn2qqdDGrRFsSZSSS5OXHI
         LVQ6Ki4olY4Tq8EkcB9C4uHQZbgarSOW0lI8xD73iMM6IdKMC4cBGaRGczLrzFBwG3YT
         OXBw==
X-Gm-Message-State: AOJu0Yx750dPbFB2gZrP8UzdioE8aGq7xy7QZMSqMwFnLcMU4JBrw7Sl
	1e7fyyhrn6udfDJPVvIi+JBB4zD5+r+xNv8NFM+XZ3G9HEfdSZ2/juQntCE1oegLinDyqZ2Ni3+
	q+uPAKwD32bSmAUMDuXgD5CAzU/AF7uKYVyhcO0AgHwq0cdFa/8hWpBGaQRgE6bYhLO9izyaPUH
	P69LrgW2x5goeexs9AI+/OWvSsoaT6xHU=
X-Google-Smtp-Source: AGHT+IF/UGyI4L7YpCXJDabe/uv6iQuXjlneJOcefO9AkqQGkDCIdBxHYEZPw+BgfwWT0U2pqZzo0vel9w==
X-Received: from wrbft8.prod.google.com ([2002:a05:6000:2b08:b0:3b7:9af7:9cb])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:24c1:b0:3b7:879c:c15c
 with SMTP id ffacd0b85a97d-3b8d94c3a7cmr10132358f8f.47.1754402181707; Tue, 05
 Aug 2025 06:56:21 -0700 (PDT)
Date: Tue,  5 Aug 2025 14:56:16 +0100
In-Reply-To: <20250805135617.831971-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805135617.831971-4-tabba@google.com>
Subject: [PATCH v1 3/4] KVM: arm64: Sync protected guest VBAR_EL1 on injecting
 an undef exception
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

In pKVM, a race condition can occur if a guest updates its VBAR_EL1
register and, before a vCPU exit synchronizes this change, the
hypervisor needs to inject an undefined exception into a protected
guest.

In this scenario, the vCPU still holds the stale VBAR_EL1 value from
before the guest's update. When pKVM injects the exception, it ends up
using the stale value.

Explicitly read the live value of VBAR_EL1 from the guest and update the
vCPU value immediately before pending the exception. This ensures the
vCPU's value is the same as the guest's and that the exception will be
handled at the correct address upon resuming the guest.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index bbd60013cf9e..b34b10be1ad7 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -253,6 +253,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+	vcpu_write_sys_reg(vcpu, read_sysreg_el1(SYS_VBAR), VBAR_EL1);
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 
-- 
2.50.1.565.gc32cd1483b-goog

