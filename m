Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD1E86629
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261509; cv=none; b=iOWQW9aKlCkeceNXEAdXpTcZbClEInhED0U1mqpqFX+6GqRwYPlJVdl3tveafaegRH9ZEpWuxfQFXFUwqyncHNTUulV7uB2CUVd/NVgG8OaiS7nl9DkhpELQ4+q20FXmsxF32bF0rYjqhINXw8dPn2iJlwsZdg0sKhAGGYU21X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261509; c=relaxed/simple;
	bh=AIGrGhL0sI/XTy+fut7PhTDvSDUEYPYtncktpKcxyVg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hdDFia4yKMgT/a8smKYQXztBzay8cYrida605DhOD7UmkY2hOfYXacPIizaKCuSQIZKA37Dg6uXHj3KDc6UY5HQKIsIVNI+0BnHRNiUo3rbHzX+mftAZF+0Z6pUfAKQZ7Levnq7IPHfFjbOqH4YXJsEkaq+dnmMX4HyQSmRFauE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zZ9Ib/Ra; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zZ9Ib/Ra"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343c86edeb7so2750955f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261506; x=1713866306; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=70/urdIV0TtAXV5fulVO9QAa/d8pdGgdHhVJPu9sXAE=;
        b=zZ9Ib/RaqH4uhaQXdl0yhICL+gKMpMl8FRdOfJTGMoH/+NNqsCpgTvkoU8tot/qke8
         cV4rnenOXG18NeVLldF0DKKXK6Eh9mdFeNNBzfKNZfiR58lGqwhdP+2ciYM9zQGvrn+v
         XcaCjfYqMrZkKWZ43HUQ/Jk/vqx1KttZV7craU5AF/75Eb9HazN0UfD/AwZaMMpFtWiy
         jFVA5dXSrWG/ffLdM0+pmm5WetQn/kG9BQUMS4YPCfB3zOCiZa3YzU8C88VFYQoDwzIV
         vhMrNRmPZuP3P42a6gocj6TtKsMaugvxQqrCNebDGjSnA5W1B1djf0GDXiFeBBmBg7jF
         UqSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261506; x=1713866306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70/urdIV0TtAXV5fulVO9QAa/d8pdGgdHhVJPu9sXAE=;
        b=Mq4iPWbtprm6B5kS+JFRdkPFSbR4U4diDuAFhJGzK/1T8xTqRl2EI/zHBl+R/Vjn0a
         9dNHif32sJ3vqaclDfj7lie4aMLSG3IttuD4oYcHt5rC98OXlmWorkmdWAvzLqlzBGbe
         Rh9NKbkbcPc7ucrh1+PU5pnk+RuSXPPBH+PP5xUndCDpkK3IB6YwsKCQ1WRUkO57+ccq
         ZN7ExZzGFmnovj/bQoUfvBBm8EgAFIZ1k01cwsZpss1lU9aMb0C+N0BawJ+iCpaVo/GN
         1cP3Xldo7GqSxKnEvZmHsIcMWCkKHGzgsFJxQHAy6wKYiRcKKAdGn0fi1MiVDsKu1rq2
         N/CQ==
X-Gm-Message-State: AOJu0YxF+nlIH+K8wtmbpeSBnHCquU46PVWBrqU64qY+4VqgrNkMegTi
	jwKt4p5jQHzaL9GK2lckkAk3V8AlzbzJOfG0p2QCsIECizczkrw4Jhf8zH661gUuh2z2NL0huLn
	g9XnxyDFWasdEQh+PtDpIORoVHtb5ctgUJdskvXlfuOxuIlrotm8FNmJowlAeRc6p1Fgve6AJr4
	5kF2wfjSjdtOryEC2HVTqQTpiZs+A=
X-Google-Smtp-Source: AGHT+IErTTjr+fAoBB2HDKDGSacn5MwdtVlEILrtpDO+8EK+IsSsmnl6RYfOwwieDSDXv0TGDlJKhMxUnQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:5644:0:b0:348:b456:e1c7 with SMTP id
 j4-20020a5d5644000000b00348b456e1c7mr3198wrw.4.1713261505594; Tue, 16 Apr
 2024 02:58:25 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:37 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-47-tabba@google.com>
Subject: [PATCH v2 46/47] KVM: arm64: Add host_owns_fp_regs()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid direct comparison against the FP_STATE_HOST_OWNED, add
a new function that performs the check, host_owns_fp_regs(), to
complement the existing guest_owns_fp_regs().

The following patch will refactor the code to use these two
helper functions.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 5651e971b341..36e0a7281bc0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -78,6 +78,12 @@ static inline bool guest_owns_fp_regs(void)
 	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
 }
 
+/* Check whether the FP regs are owned by the host */
+static inline bool host_owns_fp_regs(void)
+{
+	return *host_data_ptr(fp_owner) == FP_STATE_HOST_OWNED;
+}
+
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
-- 
2.44.0.683.g7961c838ac-goog

