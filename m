Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF89283A1D
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261484; cv=none; b=dfZxS2T+djCDkMLH5YiQvdP0EdI4Au9EqHyJxuSniTix3yR6mfSEN6TYAgEg01K7dzXWDl/AabCeateeEKWFfJCPx0D+rPWyJzvuONnXm2yhn+RWqr38wFDiWxc5jtB7EjNMcts1fTloOeBoq05kgy78nBM9bzNkN509P9kxOgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261484; c=relaxed/simple;
	bh=0nMZ71u5Hf+3lDi0fcYEyc+OV45bTuYfrFOESBduPjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CsqkE2agZoDxUSpBzvLYUhg9Wk8y92Okb84MOBJBqX39kdGC7T/fTfy1mWe+pVaNMkXwSLB30ANjFOJoLl09g3L2bH33UU2W4QyKFmJ9txWAuSLIxI9lFJ/ACv4eWn1obushNMJL50Im6X0C6sfmmch9tXiY0TD/9E3qi+1AplE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d8cFl6gO; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d8cFl6gO"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343d3e1ff1eso3175288f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261481; x=1713866281; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VaoOH3kimp7qpXc0CFTK4VS8ab98aeHhOHJ8OcfrCDE=;
        b=d8cFl6gO1INGVuPEsW1EzKga2aDjrlpp6iG0a9ArCbnS7SrRn3jh9sa36UfJo9ogT7
         L4OZkZkNNA01kEZBFZihr4KKMorx+GM0tUW31Y7PoR62uM0ZAWIcrSgBMej3PYwzOIJ7
         Zx/c3kvjRp3Ju6lrlKNIeOJIIFJV8I49islMXQe+91SxNRJTzdIxepmdpr22OOuYc3Jj
         0SUp69PIvpjGdK3oNYKJeVOdvvxpxtPC5YN57WZeDKhuvnwymbSI3RwdwyXHoEq5jJGE
         9Efzjx4CUDVZhH5KZzc3EyqONn0AnGutgIezn03Tev+kolq5QyEY8tjlRDJe+dQSlOzC
         wSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261481; x=1713866281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VaoOH3kimp7qpXc0CFTK4VS8ab98aeHhOHJ8OcfrCDE=;
        b=FlLTDuIe4x2P4YZWxEePpJsxql68XNjMHAPqqVv7l151rmF+v+Rn/I/w2En0zGN/kl
         JkMm+BdPeXTzuGNS52YW/HTrTmp7uy8Tf4T4IgZ5+7rIkq5MkJZ2LZpvKSA31+uIwB3r
         LIMS5li9XVOvZ9+LIqEUZ09dF4OnsF6PjYdsMqHKvlzZuwvE2AcW5Ex0ylug5Sjb0nUR
         b/5aHGHxj26rN3aiAqo4BCqLfsg2W7hWYfYA9BzMapCyLPQum1l/i2dF1nIBhFckOVsN
         2WzcXxxV/233tXep554Kb5aviHBHi6MaRW5ULmCt3/dg2qDf1+wUClcifhrBZDbpq9lv
         PQWQ==
X-Gm-Message-State: AOJu0YzUU2HZZY1RL8v19F/hHasXj1aH8AvFCwzN75S4wngvIdzvuRP3
	uCXNnps+6Fx7CDtqcxVtDaULyEstt1iGGMhG/l1NiPDm/Dhdkerc9scYAeh+4z4+ff1ddG4b+JU
	nDLZZP/BvdysWNS7fbuX1ayxzvnPwsx/eXgNiSaGdfaWfTGbI/nIsHpX9WCqk9wDMHClVlGZHpr
	Pyy6rxg7UCJUqRkf6oP7O0617HooA=
X-Google-Smtp-Source: AGHT+IEQ8Z2VpMG/BWMUq1mdVvRn+oUBx1EP7fkX23dXbUnvnnnwSY/tjyOX2RMaWyEqwj2yz2+85+A3vA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e80b:0:b0:346:c606:bfc4 with SMTP id
 o11-20020adfe80b000000b00346c606bfc4mr24266wrm.2.1713261480834; Tue, 16 Apr
 2024 02:58:00 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:26 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-36-tabba@google.com>
Subject: [PATCH v2 35/47] KVM: arm64: Do not set the virtual timer offset for
 protected vCPUs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The host shouldn't be able to access the virtual timer state for
protected vCPUs. Moreover, protected vCPUs always run with a
virtual counter offset of 0.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/arch_timer.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 879982b1cc73..ab49c22694ca 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -162,8 +162,9 @@ static void timer_set_cval(struct arch_timer_context *ctxt, u64 cval)
 
 static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
-	if (!ctxt->offset.vm_offset) {
-		WARN(offset, "timer %ld\n", arch_timer_ctx_index(ctxt));
+	if (unlikely(!ctxt->offset.vm_offset)) {
+		WARN(offset && !kvm_vm_is_protected(ctxt->vcpu->kvm),
+			"timer %ld\n", arch_timer_ctx_index(ctxt));
 		return;
 	}
 
@@ -988,10 +989,14 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
 
 	ctxt->vcpu = vcpu;
 
-	if (timerid == TIMER_VTIMER)
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
-	else
-		ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	if (!kvm_vm_is_protected(vcpu->kvm)) {
+		if (timerid == TIMER_VTIMER)
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
+		else
+			ctxt->offset.vm_offset = &kvm->arch.timer_data.poffset;
+	} else {
+		ctxt->offset.vm_offset = NULL;
+	}
 
 	hrtimer_init(&ctxt->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS_HARD);
 	ctxt->hrtimer.function = kvm_hrtimer_expire;
@@ -1656,6 +1661,9 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
 	if (offset->reserved)
 		return -EINVAL;
 
+	if (kvm_vm_is_protected(kvm))
+		return -EBUSY;
+
 	mutex_lock(&kvm->lock);
 
 	if (lock_all_vcpus(kvm)) {
-- 
2.44.0.683.g7961c838ac-goog

