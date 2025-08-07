Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D9A23AB9D
	for <kvmarm@lists.linux.dev>; Thu,  7 Aug 2025 12:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754568100; cv=none; b=tSiIpwSDqKJxVMqLB76YltPakbMF9Ji88a3ZMSU1MDaUeEwaC8HRojxXM0PZsSNji18/JwgyAL9TE+fCQTyQJEZ9pig+SIgQSZgt1nanV9E+Nevdstq3zIN4xn7X4WQigoYSFLqs57G+P1g7WFzee2DJz2cbgf4sUdIC7t0BohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754568100; c=relaxed/simple;
	bh=uAUZoi5rbCwh2TbdVBhZsAaPPA5C/kKTY4u+NhCw+UQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SSOSEREcw1Qp36R5Re1NuO18zcNRypMOCaZ0TUQ84cgpHoaw9UxbgFLTpY3zYa3oa/xqy6pD8ON3+3xqx4r4RUutHtNrwRqoMfbUmxPDgQ9e3fDN8Fg5l2ZBVDxq+6kHWRCEVRgGOewGu1eBaOrv7smkHN184gvhfsbu01w4miM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBOQhIQt; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBOQhIQt"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-459e0f54c88so4720715e9.1
        for <kvmarm@lists.linux.dev>; Thu, 07 Aug 2025 05:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754568096; x=1755172896; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MmEFD0EBHHCbQjRU4Ho1kLwGkicc5ODUkU4+n5Gkins=;
        b=iBOQhIQtRhobUp3bYdzHBtrPYPSNXYwhxT2ZF90yEJVITVxFsvPsEUchfr904v6S+O
         TgLkF5/GQNlWgk2fYV/PBd5yCuBIJLKu6D9K5CjIPSoPS1h6t8jbV/hH3DrRKSw3lc6T
         lm/vua+kOJaO43PC2q5/uBFLj5N7HHMMtS349fm5YugNBeW7AfeVX3hUwXc78vXjBuFY
         vJMfWTSP17Kmza2TXCPX4Vvaf3Qh2qwSxP1Jo+8VAXKGuNhb4sl1s7Abi/KuUh0MLZfW
         YdJC0+ABkbF+UETugby22IKTXFo3MwfCC2NfPxKfFCW4hEC/ghCpXUahsiUS9XzOtSOk
         17kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754568096; x=1755172896;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MmEFD0EBHHCbQjRU4Ho1kLwGkicc5ODUkU4+n5Gkins=;
        b=mj7kmX2RbFmaSI1wlOjWbkhBlHTkTo7Twb5MArvbbxV7jYU+RAcjiQZlKoxAD9Mv1g
         NFWbGd+JzrgTEo8BDORWCiljwOFthw28hhu/4xnWM30AfDLvC1Y8G/SJToiHivoOSDe3
         wWUWbkriReRZyIHYgAdfC6vWScZMgtNs3bpcxy3gGiERWq1oRoyoJEnZixYRrtyLdB2c
         YnXBvT4XuiTlXDJV4S7Hfecsngk0sTXe+6h6arAGGQlRPuMMJ0s0ZHcIO6B7XwCXv32Z
         /2mVOmqexaHZ5KlsWSHgk6OMAqHYSU9/rWYxLJ5HblLDSacyFfdG97r54K/kDh1GLykq
         amEA==
X-Gm-Message-State: AOJu0Ywd6x+ZxQXfIoaIo8D662sGfn5TeruTKhqoRKOHXekhZVopXsu5
	LhwMDqwFS63IgolNsYN143KzGlGXxK1MpdHwuG8EzBeB4jnkMwwp3ldzaV+Kx+yd/1RTq2fePRp
	sadipzVdMaNZyQ3CZaJjzVYl4O0WjmbFCo1CMOhD50xGcWbmxDx1loeXGw0Hw4Rv2Hk9n0RWyB/
	WuwGD769BLYU8yyeb6FJwCW23fyBFTsOw=
X-Google-Smtp-Source: AGHT+IEmpiZ2nf55Jh9uJTfBQmAxp4UNraapK34c6dr71U4u9eBljMgOdK7u/bo0AUdVstmW33UDMvX8rQ==
X-Received: from wmsd10.prod.google.com ([2002:a05:600c:3aca:b0:459:da33:b20c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f46:b0:458:d289:3e26
 with SMTP id 5b1f17b1804b1-459ede86e31mr32019695e9.2.1754568096496; Thu, 07
 Aug 2025 05:01:36 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:01:32 +0100
In-Reply-To: <20250807120133.871892-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250807120133.871892-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250807120133.871892-3-tabba@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: Sync protected guest VBAR_EL1 on injecting
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

Reported-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index bbd60013cf9e..71d2fc97f004 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -253,6 +253,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+	__vcpu_assign_sys_reg(vcpu, read_sysreg_el1(SYS_VBAR), VBAR_EL1);
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 
-- 
2.50.1.565.gc32cd1483b-goog

