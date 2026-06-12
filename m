Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75961339844
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259831; cv=none; b=pElifJyY2JKcuR5VQ2krv/v6LFgi+2B4guqqLEIL/eaILubJfmiBlbv7jDBjRYw7SYNEIOSYt8YeHvzG17JrcXUwqZXIq0nzdhs+rATtuSWoIZS7IDPAV/Njtxv75pcXhylrnKNwsFtGUHIFcufF5R3sjQ+sr15+8BhXjPX+G0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259831; c=relaxed/simple;
	bh=2bp6i2caV1IPgQ36ib4fF6m+6xLxOZWEJFaOoMYDZnQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=L51hOqOHTYFTTnQqUTzpE4+G8flSUlWovHZZhR5BeXJf3ISKsumG61KaMmCv7lYNCQLHQIY4YPZO1r2XChQwAombPLy/WIhzJX3TpsnNlBQ76nVLh/yS+Fp32t5Izgq82WfSvTg8vutatT6tyfyn7MOVBBYVCbkI8OwEaB1YXHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bx/XfK8u; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bx/XfK8u"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so6970985e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 03:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781259829; x=1781864629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0YFcRPBWc1sBVr+dWmTbZ0TsBZp12xAJxg+DiPsswnA=;
        b=Bx/XfK8uxEKVAR6q6Pyz9+5YBv/6f3GQXPuGMlWFqEyFNpQE/6r/MLQPRj0vxzHzOx
         r/WpI6zrAXu4po0Ak4VVRClCKspH5Eilg50StS540lnEWBaesEowh7Hh43EhZyrNl8Kj
         YsOV/29LINCY7to34QTy0wYzLN8JM31sbeZI6ukQRYbBUZZHpEDkqAF7wHkF23KFsIxU
         NfLv6QEKQJbZttPrw2cljeWtXclS/8KWsjLREyJzU2ZtBO/BFfcgllWb4NuJVS0fhNff
         nQcPCAd/4YyI+9Uf4UvGZUgcYz9xmGEP0weO9JzvBmu7IaiOJeTBybO6Fyj5Bbum01Rz
         ht8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781259829; x=1781864629;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0YFcRPBWc1sBVr+dWmTbZ0TsBZp12xAJxg+DiPsswnA=;
        b=Olyqro4gkSSyIlAu15vV25om8CbqCAo4SUN1gdhFmGdmDd0yKnhXtcYPpnWSLHNVQf
         MM6gwmkS0j2jefFLpkScYzhBV29ZJl87aBwwq6IYUV9lV95ZttpGHRG6g/Nmzd3vahMy
         NytaZFzZUO2QWrKVLE1HPYnVOzDQpoMBm2n132QKINUAW6QsMm9MqFdXVrt831oYUSMZ
         srAVBTtKOQ0r/+mvDR3flmh8iizxoOXvkwbNxlSNuVpET0nwm5s8M0lRc2Njt4duS5N1
         r2l8EXUfhBgwucvYDGsjSSwBTEfG+35lxF4MFl9pTLkLx/MKTH4PqKkSnr1WoaNzFdnP
         GvjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+2wTR9nDGSQ12fV2Io6sTVsjAVJIrMh0qNyQ/AzONrOjmmZyyxKri4RfzQARbBjhsz1OY1iA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2bJPYXsbK1eY6BvkePYeNwowpnxk/0hKRzGihlNHqWD6rww0q
	N47Qj1O9E15q6o83R7dXgYrghcZPPRGVaQJcdxgROdTEX/hxZqeTTvLz+Tl2JFvBpFeGmeMEa9I
	cZA==
X-Received: from wmlu18.prod.google.com ([2002:a05:600c:2112:b0:490:b58a:2c9b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:21da:b0:490:b99c:9337
 with SMTP id 5b1f17b1804b1-490ec4c1712mr18163655e9.10.1781259828771; Fri, 12
 Jun 2026 03:23:48 -0700 (PDT)
Date: Fri, 12 Jun 2026 11:23:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612102347.914994-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When pKVM injects a synchronous exception into a protected guest,
enter_exception64() reads SCTLR_EL1 to set the new PSTATE's PAN and
SSBS bits. pKVM refreshes VBAR_EL1 from the live value before injecting
but not SCTLR_EL1, which is untrapped for protected guests, so a guest
that updates it and then traps takes the exception with stale PAN/SSBS.

Sync SCTLR_EL1 alongside VBAR_EL1.

Fixes: 798eb5978700 ("KVM: arm64: Sync protected guest VBAR_EL1 on injecting an undef exception")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8c3fbb413a06..7608cc4030b8 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -257,10 +257,11 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
 
 	/*
-	 * Make sure we have the latest update to VBAR_EL1, as pKVM
-	 * handles traps very early, before sysregs are resync'ed
+	 * Sync VBAR_EL1 and SCTLR_EL1, both read by enter_exception64(),
+	 * as pKVM handles traps before sysregs are resync'ed.
 	 */
 	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
+	__vcpu_assign_sys_reg(vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR));
 
 	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
 
-- 
2.54.0.1136.gdb2ca164c4-goog

