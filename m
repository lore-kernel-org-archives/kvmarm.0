Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C304A7E101
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884812; cv=none; b=r3TofH5kQbrLXLCXl5riaVc5Bkiwu0q3QTFOGYLjPl5lW2oVBeSvGUcy5z4O0VRkq+AKSJ3PIP1QG/SpkyA3SppDmdn+n9Z6r2tctcSg0cTU41ZxrFu1LvWALvC3oK+sc2Zd8AxF8GYJB2gZ/SPu+8EnOC1W8svhcyZFKBe0tQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884812; c=relaxed/simple;
	bh=2GsIRqPZagWKhuj9EZGoOldsGx6hXMcIg/EWdwB1fmk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BewPyUrooPq0Or+Oz7Lwmg1LDNxhAa0ySJQOb4b8e2D/IIsBibhNRdPHSMr+Tblx8MSq957JLZF1lHwb8yXdDA9Diu6dB2409OMAxK0cNJw8lRVohkBdrNuwgv4lARd+wHNG5sMFWuxEvgL0qOwtlhzPF5IAbiYVCYLZDLJ7PE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t23B6bpQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t23B6bpQ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b32e7f94bso92052447b3.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884810; x=1714489610; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HCT+MKeivP6eUNB+e7xF0kRsoFU+ciDO6eU9PbH4fgM=;
        b=t23B6bpQyXQCDHY8WstnI8bVI1Pkjbdv5JsVK1ZR/N33X/heSayML3bCvGbdgD8NZr
         85Ax4cvfuHagb33/UQ6gau9rolRMyv1lZmF4D1IE6Q87tRWdzYxnr51l01T0yjYmIHVs
         dk3o4s34Q0LZtniZJcUMkl2yLLsjZ3WiXPuhyWe38oJilaaU9O52jRguxi5z+3pgiy2V
         cqHwa8OwC+mnlbiHSNHLWcw6lMuiVCSioGsmzaw3MaKgVv53a6H6+PCALag7lKTeSKZ9
         4rbTTrzxz9TOiLNwFB1GFDdx/7451Q+Wx0pqYgvqmXC4oEq+hjisRzmNNEpLSIK6t+eP
         fq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884810; x=1714489610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HCT+MKeivP6eUNB+e7xF0kRsoFU+ciDO6eU9PbH4fgM=;
        b=tmifWCTgh99rSY4pnVSd0AOnKf4iRM3MQ2nBna9CRT/C5a2TwdWMVkeb7jVRxHhrXn
         81ItSyifbcRNzlDK+CaQd/zwcW5F58IVlujQnswr1L4HHvZZbw+0hSt5+zQBZjNwCfAY
         gy51UTLCpxLwg2/rOOgwvuxmbrsj2wjq1aP0FY+08bzRSTnHnqA5SHVJPZSpilLpRdk1
         jmlnC0to90rIyo7SihOtZEnoyzHpkCGywZxxfSpghzNudnT8zUathRFadZSXPYmqQC/Y
         9eyujavJIzQMDz65gnIM9v+GU5mqhNc228YOQhsJzzQiKf8I9fBV13vQ2u6oF1HqOL9F
         6OdQ==
X-Gm-Message-State: AOJu0YyZO7gJHxPiJKkLLeBi7ILhOCdJec4vUi5XrqM628P+gHsjXeHZ
	2LxPn/myQbSZcOJSXWKq3FGxxJSXpqdbyLwSb9GDWdfCrUwE6l3oeN34j6jCUf5uqZnDjmThK54
	9Y/0tYBbYvSSfWys3b6HyKtCxuMaqswfOGwM9lDBRyAZ6Pw2UO0QcePVUPyVVcIrpFpYr3AP050
	60WzaAhE3j+r4AmqSwMSUZ5Qsjixo=
X-Google-Smtp-Source: AGHT+IGZaIaQPMMMUXjrHQ1JrQQwk6m7fi/oXinDexWndwFbIgk9RfwGolRrnrLOFGR3ZT1Mx6341Pkvjw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:d8d5:0:b0:dcc:50ca:e153 with SMTP id
 p204-20020a25d8d5000000b00dcc50cae153mr4066836ybg.7.1713884809763; Tue, 23
 Apr 2024 08:06:49 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:38 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-31-tabba@google.com>
Subject: [PATCH v4 30/30] KVM: arm64: Force injection of a data abort on NISV
 MMIO exit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

If a vcpu exits for a data abort with an invalid syndrome, the
expectations are that userspace has a chance to save the day if
it has requested to see such exits.

However, this is completely futile in the case of a protected VM,
as none of the state is available. In this particular case, inject
a data abort directly into the vcpu, consistent with what userspace
could do.

This also helps with pKVM, which discards all syndrome information when
forwarding data aborts that are not known to be MMIO.

Finally, document this tweak to the API.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 Documentation/virt/kvm/api.rst | 7 +++++++
 arch/arm64/kvm/mmio.c          | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..b11b70ae137e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6894,6 +6894,13 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+This feature isn't available to protected VMs, as userspace does not
+have access to the state that is required to perform the emulation.
+Instead, a data abort exception is directly injected in the guest.
+Note that although KVM_CAP_ARM_NISV_TO_USER will be reported if
+queried outside of a protected VM context, the feature will not be
+exposed if queried on a protected VM file descriptor.
+
 ::
 
 		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 5e1ffb0d5363..cd6b7b83e2c3 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -133,11 +133,19 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	/*
 	 * No valid syndrome? Ask userspace for help if it has
 	 * volunteered to do so, and bail out otherwise.
+	 *
+	 * In the protected VM case, there isn't much userspace can do
+	 * though, so directly deliver an exception to the guest.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
 		trace_kvm_mmio_nisv(*vcpu_pc(vcpu), kvm_vcpu_get_esr(vcpu),
 				    kvm_vcpu_get_hfar(vcpu), fault_ipa);
 
+		if (vcpu_is_protected(vcpu)) {
+			kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+			return 1;
+		}
+
 		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
 			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-- 
2.44.0.769.g3c40516874-goog

