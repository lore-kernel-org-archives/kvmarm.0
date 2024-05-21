Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B66314431C
	for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309448; cv=none; b=hO98jAb6xsESRpeFkcVaL68i+d49gmK2wYHleLoQkHIq1AqkOlbFTv9KzomspMQ9GmdUlT1nBMX4TNKeaHLi0u8yrkgBuLz0vMhLf5XvKjAAfwKK1xd/gzcJuSm5IQIYPSsqEg0Y0hUK18piNVUpCKg6HCuhhR1IuczQiigC6OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309448; c=relaxed/simple;
	bh=QGDrulH7QkQztLI6olUTp7xW6bPoEpp4UbSQOVxpLCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EBItesCPqFXtfcSwZMk3PatIqEgFcvE9uxhhYUdtJ+2wrM+ZPVeG9fcWjd6QZEMim6AmTuZjv9TBlHFpgiNLQhDt12UapoNoWdoj4ChsEnci+7wYkJYd1CLK/ac8K4cEqvPw8bKAAu/eZOxb/1cef8e9F+aK1XtapbATQUemfzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pnHKIl56; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pnHKIl56"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41ff6049fdbso62224305e9.0
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 09:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716309446; x=1716914246; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m7ZeeaxMNlmMYn0HEuEMpJymN2C87G6/IDzgH+gHD1Y=;
        b=pnHKIl56ZpUldNSWNAplT4HXpbgNkwseqDaW1K7zBjUVQDgdyKyJAKE53IazKQfTIM
         km3yz3Aofasv4GYcZPrjccQ7pnr0l5+wluWaemk8aqZ3wTvqoO/Wq5ibW/1A0PlRwReu
         kDeOjhDoS1mRdkbXtPOGsj3BVVFmIJx7F1NYktwbVCJATBRzROnuq6ae4htLvfRbOCCr
         r/pZ5v+bYvZpP3q9mqCfz3dcJsKNqpg55D6Cs4q5ixIaHuLHmG3rZ5zi9y5LJ1vn4xZB
         wT/TI6HGpRTGfS3yp2YmaNaosFL/HTt0L2gx8oLCYtXo79jj8jPHdeQA/IGU+NyLaZOv
         QsDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716309446; x=1716914246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m7ZeeaxMNlmMYn0HEuEMpJymN2C87G6/IDzgH+gHD1Y=;
        b=bwqMiZuy9OXVTgSV9RoO68LXqXF4xQrAW5cRB23n9dRKhPws2ID5HSYe3H17A2XzI9
         S3oGk/YfDkah4F+mZTkOdqNPPrDPUsNQOJWUYX3K5WJsgucMxDPGTRZMXNSo87LBHQkX
         Sh/TEn9Y13kqwuZl9FDdI/srFMOiEtj7EysSu0xEhE/+I+qBDkOX/3IOrcuBF4Khjg56
         +OGjZA9SJaeefN3RUkKkJ3y6n3ZfCSSF1oH3WJ2BXt21lv5IhMtfSPgaaLp8o80wjifA
         JVUJsb5eqbG3vJKCZ6xTRV9pHVv2GuHMy5ZuOV32oJEFfEkdCpDP7vL4Bm9Z6ZS+aI3P
         9yvQ==
X-Gm-Message-State: AOJu0YzCChW2LPJyYb+upIcJ5GRqKmt0XkW4zT67sEunCyIobxzbVSgt
	OOchSAgaNyad9QNKqL4wGSQqJE5qJrcb+jx6IVtWAoAC1LY2LV29czJmMgzV0nIpetK0ZHK2B/H
	oHi9AuKddUySFOtQgVva8D4WMMM/bwZ3u1W2yG9Mn+OKxXKoOGZryHvHIC1/LDyOmEM2ldHEdj/
	JCQ3QIBvpVl4wulyzcqk8UFQAQki0=
X-Google-Smtp-Source: AGHT+IH8+KZZbevX4Xq7NAjw8ZrWD7yBzTW4v4+FZmdAHGSDvTyJFv08DrSsJ07Ifi9e/W7vS9cJCBYEdA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:210:b0:41f:c7bf:dc33 with SMTP id
 5b1f17b1804b1-41fead59f80mr1899985e9.8.1716309445372; Tue, 21 May 2024
 09:37:25 -0700 (PDT)
Date: Tue, 21 May 2024 17:37:14 +0100
In-Reply-To: <20240521163720.3812851-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240521163720.3812851-2-tabba@google.com>
Subject: [PATCH v2 1/7] KVM: arm64: Reintroduce __sve_save_state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Now that the hypervisor is handling the host sve state in
protected mode, it needs to be able to save it.

This reverts commit e66425fc9ba3 ("KVM: arm64: Remove unused
__sve_save_state").

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 1 +
 arch/arm64/kvm/hyp/fpsimd.S      | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3e80464f8953..2ab23589339a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -111,6 +111,7 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+void __sve_save_state(void *sve_pffr, u32 *fpsr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 61e6f3ba7b7d..e950875e31ce 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -25,3 +25,9 @@ SYM_FUNC_START(__sve_restore_state)
 	sve_load 0, x1, x2, 3
 	ret
 SYM_FUNC_END(__sve_restore_state)
+
+SYM_FUNC_START(__sve_save_state)
+	mov	x2, #1
+	sve_save 0, x1, x2, 3
+	ret
+SYM_FUNC_END(__sve_save_state)
-- 
2.45.0.215.g3402c0e53f-goog

