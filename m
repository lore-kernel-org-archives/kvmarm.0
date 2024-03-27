Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F651487E9
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561020; cv=none; b=SV4Z8T4+KZ8h2oEF3ClDDK8kbd2BkQX4/wBxJ1DlLczez5Xu0KP5hnZrOWnJc/LRfe+iNNihw9ERwv4Hu/Ow8+J2DlkZi+bh/1JbHIoCV/0GHRJiq+NhiKybU89t+HTY8g9C6QtBzU4N8qe/gaQmtvMoBj6hJIlgj8vOjbbCBjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561020; c=relaxed/simple;
	bh=n0SebahHGKgeiUug/X//L2J0aGk8nSu0IOcJGb6Lcx4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sp0jLoWOiCh/F4bGFo4pNrY0MzNKa+oJxNaSMrufUo94ZLbFpFWJ/bxOv9353x+pRbuR/5GCgCh4cxyeJy9tfPr5qwCnqd5WIJlGRmjRTnVl8Rd8WquDKhKI6SVOAXgjnklGe31n1M0WpqXnIfJ4Z48EbjiTWEzIKzSGZdqzyyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sdi7/sRN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sdi7/sRN"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso58397276.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561018; x=1712165818; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AXKxzlrl1nvqPlnrZOPuGbaACakjoLLkAJCzjz53SvE=;
        b=Sdi7/sRNRnXJ7Lps/O/W7RhqoCOxAVmPSnvIWOzBnBFcr+2G4NUvgCOoItJQOzzDZz
         i9wy7cfZ43la1mcUs0ScVUnXHr6210Io0kJm5hD83m6XlcwMJJqvlfVlJF0aA9CyGBUg
         s7f5IwsPq55NzprdvtNiyvbdyVhB67Qt/9adMnK/JZaPOvxDhKOwU9Wh8dIHLel5MliN
         2Q2haYR7uy35h0bkpVMvjhnxGoeQGXUqVdYaPSv3Q474JMLDrAQWHOBPfLHUAEjaOo9M
         s0/sbqvFUqaUmYbUqPCObXIBxDDu6/ldLj1Os56TqYAMRwLnfcXQ2TQWiMsAeQjYeMGu
         ujsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561018; x=1712165818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AXKxzlrl1nvqPlnrZOPuGbaACakjoLLkAJCzjz53SvE=;
        b=ElSyC5eDmDwMKklJOXheLmFtyacqXOTA3B+v+lJDwyd8nLkvJ8zMVmM570TxPc7khN
         xf0a88NhMB8iiLh1HmwDhptKQktczp1Ryb8ZPbHj5eM0fykEI7lvf8cnRqUEhMDAxT/i
         OrFMYhe9QXAtUnXITd6XLi/WaV9vb4RR2AoU+y+0mlGpHlr1E+BxOrlYlHKH0aNchBn3
         8Iwsvoq0I/67OK8xXue4ILPSqfJOoGlJDAyg+ST0JZypfxKrnyNtmTMijinNkYQOrw8j
         AiwbAGYvaHwREJLD9kgJVQ5Op75EHBBdBqAUkg7Leb2gkDe4KwUrQk/0otuQWeOiqF8J
         71Rg==
X-Gm-Message-State: AOJu0Yz2b/Ta3oRxsJsMOkHI3UeC69WKhUK4V9nWvtmDXNBZP0UerJHd
	bB86ghI64hNSMyzl2l9D3IVomPPTtEXl1QJyQUhfgwdsWSdLVxODhY27eI5I/YzBq42EBJaLIGM
	QU8AFzZFFrjMp5uDt2KKWrBMeyJckRaxHuT8JTIqMDG/K4XwaHRiluwAbaSAx22eAFmOJ2hHLAw
	tcwjYRRrdTt4/Ii9Y0rxhO1cs2qdA=
X-Google-Smtp-Source: AGHT+IGn5zkQurlHLxXBD4Kpy1iOi5I7VDLZ2QMnUyKFmshaYabvpaiF2fMLVpUii6MKT3z5DhXO/Krm1A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:230b:b0:dc6:f877:ea7b with SMTP id
 do11-20020a056902230b00b00dc6f877ea7bmr141989ybb.9.1711561018073; Wed, 27 Mar
 2024 10:36:58 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:21 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-35-tabba@google.com>
Subject: [PATCH v1 34/44] KVM: arm64: Do not set the virtual timer offset for
 protected vCPUs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
2.44.0.478.gd926399ef9-goog

