Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A651C39EF2B
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634516; cv=none; b=QN3PXetVZQa4l64GwfZ7o40bX1XE0RFSkSdRU7iLRpgsQfuU/BXTeQSWR0HLdRFk+1dUgiP7FmaxCdTi+sup+9XiEJlO47xBh1XIj1DYGvOmPIo3AbjUIUsKjw7M0JdYARA6ucVg+Em6Thd0rXC2GWZnFQQ+30lus92q9lUixiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634516; c=relaxed/simple;
	bh=BzOwJo7tMtTnOiFbCf1do1lKh7xZTwBmNLgdzfBWFIc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B1yEzHvI5n9iTgWiyD0XFVCFZlH3sD7qhMv8Cil2RJLDhk1CNNjDkTog4R5dl/LaM6jTW8/yZlAB7h2El1lDgbVp2phEwKzUQJ5/dloncNlmBNtCcQD1qvXyZkamtEdlIlXdvL9FezgZnt9SSZ6JaW8rC/0lCoRaZ3LXgtKdWz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GYngFalL; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GYngFalL"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso11798995e9.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634513; x=1778239313; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=llK0KM02OjlQ3dfGmbUJ3xamz2nXDZo+cJOrJzYBrAM=;
        b=GYngFalLDZgnjbWo73gr+mQzPsugIZ5+79A1S6a3w4Mxkh51Fxwqb9+txtlBuk0hUA
         wsb1Lt1kHKXxps0oRXSbJpuI1361jmvPsQqlorkRk3fi8UQo5MxsTFIzDw8lASa/i8OW
         TyW8J475bURiHfM6ZhcHHUmRjgx/meRBAq4SFY0DDe8MpBMQxZjpVZuD6BhVfJpU8ho1
         EZSFEU6zgqb+T66IODCVtOEEGdIa/RHZ15e0Dbgwnc5mtL0N52lQAu6UQqyJM/5gVxzQ
         gsl3p4mi6k+2Vsw3UN82z6E7mBBDY9hPY/BWNxqtA+Mo5NY2S7T/UDPZqW3yBmH/3krT
         SHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634513; x=1778239313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=llK0KM02OjlQ3dfGmbUJ3xamz2nXDZo+cJOrJzYBrAM=;
        b=bviUuijAKUEKDJrb7J9XqxgWyUpwX8Jkdxc2tfPD+A3E5jyq5oAYBZHpag/0IGOI1Y
         J1RTsVaxhKMyp11maV4cFQBewHplzfE6oonOHk0bj3tPreuBD3M0MOvC/Q+7hRrlVWH/
         Zr8PgdneQZYpULdquGF/uJ7kD2VCH0yN/DWOGrVN+6OVlltiUvQ9kJEKtg6WdM2Nlr64
         TtG2rt6Qsh/V1HxFCtARbh9kDiXgRyGaIhjPK3A9Dy4B17pi2v/sf1FWs3oY+0dnLPkG
         6HmQbJcvjPsvrU/Z3FTXbXE/jlGD3R+jTzCQGIgxtrQ79zDIKorsEp23vEzSMbp4ix6U
         3pZQ==
X-Forwarded-Encrypted: i=1; AFNElJ95NDwTfD3Zvf9YbwjsPA6zLQvTX/v1Xgt2SuNQnX26JG2cISaNH3lsZSE3ppLb3SFO+bxwYBI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxs7VQA8ZYlWDXVmM+gSHS6riYtfo/UcS+IkH9ePzdvppAoVQcA
	ND2nF69TLQSI/PqTc/St0bSCX7xU9feD4SdCxRQKV3C00ErIQl/DeKiQFJoNautUi1RjiOnq4uj
	Z6Q==
X-Received: from wmee3.prod.google.com ([2002:a05:600c:2183:b0:48a:5547:c79e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19ce:b0:489:1c32:210d
 with SMTP id 5b1f17b1804b1-48a8eb8834fmr41657655e9.15.1777634513137; Fri, 01
 May 2026 04:21:53 -0700 (PDT)
Date: Fri,  1 May 2026 12:21:45 +0100
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501112149.2824881-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501112149.2824881-3-tabba@google.com>
Subject: [PATCH v2 2/6] KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
From: Fuad Tabba <tabba@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com, 
	catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On VHE, __hyp_call_panic() unconditionally calls __deactivate_traps(vcpu)
on the vcpu pointer read from host_ctxt->__hyp_running_vcpu. That pointer
is cleared after every guest exit (and is never set when no guest is
running), so an unexpected EL2 exception landing in _guest_exit_panic,
e.g. via the el2t*_invalid / el2h_irq_invalid vectors - reaches this
function with vcpu == NULL. __deactivate_traps() then dereferences vcpu
via ___deactivate_traps() -> vserror_state_is_nested() -> vcpu_has_nv()
-> vcpu->arch.features, faulting inside the panic handler and obscuring
the original failure.

The nVHE counterpart (hyp_panic() in arch/arm64/kvm/hyp/nvhe/switch.c)
already guards its vcpu-using cleanup with "if (vcpu)"; mirror that
here. sysreg_restore_host_state_vhe() does not depend on vcpu and
continues to run unconditionally, preserving panic forensics. The
trailing panic("...VCPU:%p", vcpu) prints "(null)" safely via printk's
%p handling.

Fixes: 6a0259ed29bb ("KVM: arm64: Remove hyp_panic arguments")
Assisted-by: Gemini:gemini-3.1-pro review-prompts
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db3f11a4754..1e8995add14f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -663,7 +663,8 @@ static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 	host_ctxt = host_data_ptr(host_ctxt);
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
-	__deactivate_traps(vcpu);
+	if (vcpu)
+		__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
-- 
2.54.0.545.g6539524ca2-goog

