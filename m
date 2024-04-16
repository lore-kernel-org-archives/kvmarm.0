Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999ED85929
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261443; cv=none; b=lOdBW6Wmm//ofcZ3tekWtx7nlmL8hBQ7wwxWl6vf0JGw/2wuNr/WQ+fsTKj7w608nZg3je1bdU6uGjwFYO2vRFUWhpB4plEf/q6DvsgfaLM8EbuUtV7GlcCjGtY0Ck9pgxYetBCiOHlakRjCUV1SL9xtOOcw30MtY1P1JMpQ3Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261443; c=relaxed/simple;
	bh=JKkEG2AlHclttX3lTkDrneutyQs94t9l+qGtlTDyWDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iDWomNiAE1A9e0s9qPRafp7jaP1zY6TMPbn1f/PvbHXvy+7KXw60On8j7/UAJoExMZlhFmnBBaXiIQQCIFtTAOnqboyDpQ+8Wpoba0z5y/zSBAZDW5Tlg76yltwRRG8fe+tY0jB0NgfEK1eywo/R6JPLMerJw2UnKmSoQfWoPoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dCUOep4Z; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dCUOep4Z"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-416ac21981dso21910515e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261440; x=1713866240; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0jKJqTwWifoAIBL40mnASpfCVEuJxEZevWWy3VXKhCE=;
        b=dCUOep4Z/DiRn04asjp3zwJoq8KrxKg7o9UsMDJPRY02InIF15M2xpSyrktSfVPU9Q
         ri9z6tNshW9s4S8GNeI48dy/jl0khGHxEkF6GbRXMUksgrN38ZHFC0DSBDdPK84MY6hH
         YSIBSwcVGf9R2FME4Aa+b7O3v4WsaV7cxkhF9yUXYMKb466J0YrJfegkvPC5WvxL2CZ3
         H5RaA7pAZFLpOkd8SWbZ33dGyMPmbFukRkW0m+TLvXypM1bI0552Nrg86c5NVB2c26AF
         Kar54afaOv/HvtYczK/9vRMjcOEfLka3Yhli8fDKD1kaKlidXapS+wZ/zUlX31q8ntb4
         S23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261440; x=1713866240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0jKJqTwWifoAIBL40mnASpfCVEuJxEZevWWy3VXKhCE=;
        b=PDWxs1GFo+7dWA/wdekqUBSKzkg9OrJetN2/lQmWJaGnLRokAw6qLMhNuggprtr5yb
         jiCi2GkoTEv0fCHfUIGxZ6EPXIsXwzMUKk0ppZNE7fr5OOmCILX9AP1JF70MYbRs5TIU
         fcJXd47RPJEdgajIEzr+7/xmnUkX5dd1FmL7RmMyuAdZXG6mIgtwgpOEZB/aSJM4/om5
         F/t5jS94+nco5eEiGY62UtBA9qD8gcJBgN7bun1Yf1m8wMyijUfDj3dwVSb+17RcZNNw
         MSO5CtJlT6D0oDK6B/CNmVXftI59WChEUimTJLOy21RdOow3Semm3lml/MV+tgtc7FHi
         CjwQ==
X-Gm-Message-State: AOJu0Yx6bT1cgzU+aL+x19l+GpHO7YUu07i90FC6aRuFBQWgOIC/mTCd
	hAkU7C/KYomTaUY6rC2dyOFvN0oDA3gUSujDaqOdgzKe3GvH/XU2lMQ6DTIjWPU3NEql3YxrVJZ
	LLC0W9DdfDjVQVghh2wjR49AWdxGDxwy8ciP+LqGnTaJ1LxoigNnSxrQiEgvYSqNIxyzJ7bvHpj
	5x7DC/v5mRs8P0chCHx4dXbLq3K10=
X-Google-Smtp-Source: AGHT+IFLroet/ohSMzJsmm6sepHK62mo8C8Vqfg4NJeF5FqvJRAGEIiaNQ5WFK81EcFlOK7/Z7kzUh41Sg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d3:b0:418:9fd3:6e71 with SMTP id
 r19-20020a05600c35d300b004189fd36e71mr25770wmq.2.1713261439764; Tue, 16 Apr
 2024 02:57:19 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:08 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-18-tabba@google.com>
Subject: [PATCH v2 17/47] KVM: arm64: Refactor calculating SVE state size to
 use helpers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The main factor for determining the SVE state size is the vector
length, and future patches will need to calculate it without
necessarily having a vcpu as a reference.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e4b044d4cea..39025b8af6de 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -856,22 +856,24 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
 
-#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
-
-#define vcpu_sve_state_size(vcpu) ({					\
+#define sve_state_size(sve_max_vl) ({					\
 	size_t __size_ret;						\
-	unsigned int __vcpu_vq;						\
+	unsigned int __vq;						\
 									\
-	if (WARN_ON(!sve_vl_valid((vcpu)->arch.sve_max_vl))) {		\
+	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
 		__size_ret = 0;						\
 	} else {							\
-		__vcpu_vq = vcpu_sve_max_vq(vcpu);			\
-		__size_ret = SVE_SIG_REGS_SIZE(__vcpu_vq);		\
+		__vq = sve_vq_from_vl(sve_max_vl);			\
+		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
 	}								\
 									\
 	__size_ret;							\
 })
 
+#define vcpu_sve_max_vq(vcpu) sve_vq_from_vl((vcpu)->arch.sve_max_vl)
+
+#define vcpu_sve_state_size(vcpu) sve_state_size((vcpu)->arch.sve_max_vl)
+
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
-- 
2.44.0.683.g7961c838ac-goog

