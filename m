Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A917266F19
	for <kvmarm@lists.linux.dev>; Mon,  5 May 2025 16:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746461661; cv=none; b=YBJjY7n4nzA9BfEIEEHAO2Aqgue2F7u9vcm1B9mLgdlQ//EA/5PoAYML6NOyrAybUsvyjSYw2bb7m0T1w/2+3wlGI5F9h9/+Hm1MV37l4/hQBB8UpeBUdAb5HqAEkTjLI95xZ1UyREGFHgvF/Jxe4Lmwlzd1yAEk7P+BaBoNLRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746461661; c=relaxed/simple;
	bh=tP/Dy38GceNJDf3Zr30G5oxFd5DNpiB2roiPdOIJcEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NqJjj+XYUEd87n4zx/EOVsVuihAIJjIzPLiNT2aCZoLT30/p30YDvS7Tw0Mqj7V0k9s7eWTVfD57/En/WKlGINogFPJiVW5UtzySFLT9S+quk6zM1bKF9ZcGAQpmdARZ6wpnOK1cSQTXTShy9dSYaW4pbj6AZFEFrLD7BpuvR5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RAPJaeOA; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RAPJaeOA"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1b2fa98c39so4731349a12.2
        for <kvmarm@lists.linux.dev>; Mon, 05 May 2025 09:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746461658; x=1747066458; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OJagTHHNdVxyDzkTZrB+wizm+z9g6erBUIGhulC+0c0=;
        b=RAPJaeOAKeUpfYhb33g4D7ZWRS3iThgL+hGTKdxvR/97cLEoHmP6SKKPQ7fqCNUv9U
         4axM+kWv5u+S4ScznBP986YarVNm38VRsHUqU7ZyuWiETupX7q3afrqY9VyQWEYCHM7O
         ulUyK4CYG+cSBjrc5Vdku+P8ujKGMZTTdMPAz6i+GVWb5hmocfsHH1VLvRth733uEpAp
         djfd7gQyIzzxB2HkZ0SADlottNerD98saaL1d0LpzWkg8IaPP1DZsx+aSrJSQ1jZBquX
         RGCremmDpVoT8KL3TrrLgJZe9imqMr9WzlY0/GsVEz/458IUE7bJeOI5zdcZussSsAyn
         NWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746461658; x=1747066458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OJagTHHNdVxyDzkTZrB+wizm+z9g6erBUIGhulC+0c0=;
        b=GrCekz3j2PdkQFZYmiqHvIYanB9dhG40gzXvPfbqoai7TfaAVziR7Y82O2Q1ExoL1V
         GaCwfjyAyXGfhXCutcpd6Sr8bxiokJ7fNK7HhzBfVYO5DovpvC/hgFvN/FR+laQPZSTh
         uq+L0hedVd5dXqEfW6WOIvY1Gn/TFNNs8RXByF1ZfjghfLyxMZiRJs706pCQD5/gwvmH
         m73S54t9msniMflHg28SgDmzbHH/i0n2DxRMHNWexkicIYh4/FKCFvZeNLBrgiLY+Iwv
         UkJfC+diPm1sdjysp07KtVGSAozSVaHjgrppyDPaPHjK03lItKNzaUIDpeBDRlPlBtbr
         7eNg==
X-Forwarded-Encrypted: i=1; AJvYcCWp4vmRKGLkdysxPUaI31HtzlJ0/NQZa8OryJPi7DXRi98bKXZmnsZ0c6pZWD2FNhmGsdDvHIU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlJzzGPsaMsK0JVnVORTlwDW0f5ug5u1xzk37osqF5sbaq0U4m
	sGb3O9svs5O5DLmCWa5rCbCQPzsTA0vt2avZKkyPZKuJddqrHT63DY1L9MCBwBB14BA/VlJFO8l
	zmFZFKrMiHg==
X-Google-Smtp-Source: AGHT+IHmeuVYVihs7sQ36TEo2hNXWZbWh14KISXEiA150JU3zbOiiYwpdjNYy9bWt46liO2U4UYaoHnwxcbrZQ==
X-Received: from pjbpw4.prod.google.com ([2002:a17:90b:2784:b0:2f8:49ad:406c])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d883:b0:309:eb54:9ea2 with SMTP id 98e67ed59e1d1-30a5ae3f34cmr13505195a91.20.1746461658457;
 Mon, 05 May 2025 09:14:18 -0700 (PDT)
Date: Mon,  5 May 2025 16:14:08 +0000
In-Reply-To: <20250505161412.1926643-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250505161412.1926643-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250505161412.1926643-3-jiaqiyan@google.com>
Subject: [PATCH v1 2/6] KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Certain microarchitectures (e.g. Neoverse V2) do not keep track of
the faulting address for a memory load that consumes poisoned data
and results in a synchronous external abort (SEA). This means the
faulting guest physical address is unavailable when KVM handles such
SEA in EL2, and FAR_EL2 just holds a garbage value.

In case VMM later asks KVM to synchronously inject a SEA into the
guest, KVM should set FnV bit
- in VCPU's ESR_EL1 to let guest kernel know that FAR_EL1 is invalid
  and holds garbage value
- in VCPU's ESR_EL2 to let nested virtualization know that FAR_EL2
  is invalid and holds garbage value

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/kvm/inject_fault.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e6..b4f9a09952ead 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -81,6 +81,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
+	if (!kvm_vcpu_sea_far_valid(vcpu))
+		esr |= ESR_ELx_FnV;
+
 	esr |= ESR_ELx_FSC_EXTABT;
 
 	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
-- 
2.49.0.967.g6a0df3ecc3-goog

