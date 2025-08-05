Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9A427877F
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402183; cv=none; b=EiKjcl/DvtQQagcciKtUu1YuQIFVJo+uYl4363V60PESuMHpXT78njQqLcBm3LCE93aT7vji8Tdg2zjFKEBf34ptQDLjqApMuxzvo35EyKu3saauXHxLManLZrUc9u6hLYHgPTTSRFcew1my6090HmVop7Dx5I1JV2WjtI+isp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402183; c=relaxed/simple;
	bh=Da0cMVKZqskJI0tgx2E4M4VSV5tpQ+XoWDLw2WFIfLk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cFZRPOSSLLOAZuuPg8vptfOFDdB8dUm4uB9nVyjOCaoUY6iago9kOzI11g0V1MK70VbZYVcDC/bldixBRcIsSXpYAFd2F/ONWlHoaiJ/V8bEBxkAZDaZpqHrjL5VEDb2KmyiyYyPj4/6AHlFcnKKhDZljTe4NyzRRJgJ2W5fsvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlCZBlEd; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlCZBlEd"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-60c9d8a169cso5471275a12.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 06:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754402180; x=1755006980; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w9PKkBftLtMMa3V1BGcq/seOYF3kVU6vuT2AmyZI/7o=;
        b=QlCZBlEdCNAguikECqQdETqnRgUk5psiiuiNsg85z5erCMB05As14iv90/0QueyLXU
         0lKLumK9hyGW9lPzfYdIjEEPutUWCFuS+UceGqvYvCrGP6WIvuceQKWdlnUZyzGTuGjT
         YS9/nEqacK1xx/836TEvfX93n73jTmD2cR/vs+ClRG5kXGFJvai+Q+LYd/n/rH3ffm2j
         6hjJMjy8ZxqJWptMsQJ9C2LBG7fOWQLq6A1kJoECMmop7mVRwmrMnhlb/moPwnxBGEi0
         LIMOmeskWYLKdwuLdcqOLBKCESdAvNtPNYg7aerhZNx1ipRBgG+FbUUWYmzqEHIvqzvj
         j2vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402180; x=1755006980;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w9PKkBftLtMMa3V1BGcq/seOYF3kVU6vuT2AmyZI/7o=;
        b=myJiN5UfMG55JHnmTZm7mIjRG5VObzAKfroKnsCGESsR9T0hMFqfZ08okDP4WD6U4u
         x4kOewBgqSpwq9OhY4VYembbdyVD1cFODddiWeq8a7Lt4Yx6BYXOCpb2IqSJjjj3YS5F
         PvwPOFirpwsWNwDaql5I3NKwThn2q/jyn4y1vWzMr/1FghWo4vz1NOzo9RcifOp0VpBK
         lKlSoCte9kHnn2Rl+Wn8uWVwtdCwIXHQq+XPpQh3VZF6VaMGsIfkr9XX+k2QEWpVtLwx
         goOK1HhpgIKYexRx8lpzPOeQGz0WJDUpjbFAe4iLU70r1XckcxzZCsnzgtjItEMYAQA0
         63qQ==
X-Gm-Message-State: AOJu0Yw6aeMx3iuCy0vQ4QtbFmpjB8ka2qhwPdeVNJiCBe6oegY9H29a
	g//rfqmrJaQNZieKxx/JcvxNLetLgYXlA252GxnP7pOOcrfuMsH0KjPaj0dIyMabO7K+b51vRTp
	BbuIUwBWxwOOYP05MjMxi2Ljzmr1dxIGptBfeAB7oUhdk0NXfiT643eBdlBcuM8WAmrOaVNq4rf
	YZPYjzG0dhIbIxbYfD3lDFjyhdUlu1fi4=
X-Google-Smtp-Source: AGHT+IF5wgTcJEco9zIL9WHK/o1q8g0iW6nGJBQokB85ZIBv7D4+qnKQNfxOZe0YoUBGLdib7WasFyNGmA==
X-Received: from edbeg13.prod.google.com ([2002:a05:6402:288d:b0:615:789a:b89d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:50cf:b0:615:a3c2:2e5d
 with SMTP id 4fb4d7f45d1cf-615e6f52cefmr12085596a12.19.1754402179558; Tue, 05
 Aug 2025 06:56:19 -0700 (PDT)
Date: Tue,  5 Aug 2025 14:56:14 +0100
In-Reply-To: <20250805135617.831971-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250805135617.831971-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805135617.831971-2-tabba@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Handle AIDR_EL1 and REVIDR_EL1 in host for
 protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vdonnefort@google.com, qperret@google.com, 
	sebastianene@google.com, keirf@google.com, smostafa@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Since commit 17efc1acee62 ("arm64: Expose AIDR_EL1 via sysfs"), AIDR_EL1
is read early during boot. Therefore, a guest running as a protected VM
will fail to boot because when it attempts to access AIDR_EL1, since
access to that register is restricted in pKVM for protected guests.

Similar to how MIDR_EL1 is handled by the host for protected VMs, let
the host handle accesses to AIDR_EL1 as well as REVIDR_EL1. However note
that, unlike MIDR_EL1, AIDR_EL1 and REVIDR_EL1 are trapped by
HCR_EL2.TID1. Therefore, explicitly mark them as handled by the host for
protected VMs. TID1 is always set in pKVM, because it needs to restrict
access to SMIDR_EL1, which is also trapped by that bit.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 1ddd9ed3cbb3..bbd60013cf9e 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -372,6 +372,9 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Debug and Trace Registers are restricted. */
 
+	/* Group 1 ID registers */
+	HOST_HANDLED(SYS_REVIDR_EL1),
+
 	/* AArch64 mappings of the AArch32 ID registers */
 	/* CRm=1 */
 	AARCH32(SYS_ID_PFR0_EL1),
@@ -460,6 +463,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	HOST_HANDLED(SYS_CCSIDR_EL1),
 	HOST_HANDLED(SYS_CLIDR_EL1),
+	HOST_HANDLED(SYS_AIDR_EL1),
 	HOST_HANDLED(SYS_CSSELR_EL1),
 	HOST_HANDLED(SYS_CTR_EL0),
 
-- 
2.50.1.565.gc32cd1483b-goog

