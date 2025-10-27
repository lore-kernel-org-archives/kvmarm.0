Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BCE23BF8F
	for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 11:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761565192; cv=none; b=orwsQ2zM+0DjOVBqmMd355G6FBVFZHq2KEAGl7ZxCRq9Q9x/WytPVXVPvvFDybK0tBtJVL7LCaJ5S8S3Jq488iPmtBYmTUZT3LAztv51fmaSN3pqDwBjsvKbTsmX8iuEdKXHYAjTwE7XWSsxq/UI9SJcnN0y0vG3W74WQI7lPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761565192; c=relaxed/simple;
	bh=f18anSMvBSuenSnLb/Xbd8UFXKt6gIPnehc+WlYNjJw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BPOeY2mDeF8QoUV4XPGhD2SOuglD74xJG2za7H85qe/7dTynhGa7YGvOHIGTlO5AQTYS8BNHqtgmDvrWuhdnFE11/piOIcVPB+BuBzRYiJTkHO6AxBK+6ofU3in1MvBCSpYxpd9m/RgZyVwalN2eRkqNt92LYkjDaKEbFdUhg2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QgkgxZDg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QgkgxZDg"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-475ddf7e925so1629215e9.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Oct 2025 04:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761565189; x=1762169989; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddUaiwuC2mzRcZAvCLVUB0QFXxr0juQKTwC4zCGP1k4=;
        b=QgkgxZDgah4WY619ZQpqLASGTSv9XhZTGbaoPKwA8YUjuedcEyF67SSWc41HNUYRFF
         nh56he5Aah/JocWlM6Lei2okmWl3OV71icBxb1hSIVkwZ8Eyk7l1P/epqOoTAszo62RR
         orLjM4nCOKyc0S7M2gqMMusedQvGRXAzXwm3Cyhi8WMqXOug99cq3MubqnRPeUFZsUH4
         H077o59OQ+nM4fu5fozLFK94D5orCBGNIM1tbV4vv9Kh53sZbRx+jb7SFJ6VI9ole85W
         lu/KJwIhd8+hqeFtJggje4V/EmDdFPZ1hCMnRAasuZfrcMe4dUZfCvWJZiWpvW1UnHJe
         UCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761565189; x=1762169989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddUaiwuC2mzRcZAvCLVUB0QFXxr0juQKTwC4zCGP1k4=;
        b=II88bsGVIZ/WNSkMDbFcNx+CcARUowJaxagkFt9qhd7a5jKPEkc6uFm70bLsi9LJ/B
         mDUfzjFfbgCtXuqrk3gE6mtwZL3lE5Oy/I2wMEWGlnGpuq6dlU0T0qsh6Lwstymo+5k5
         8kJrW7J7JZ/VOq0hxUVmiITYcjg6Tl3lTsaj7ncNS8w8qNaBxhXwp53PzNEM5kL0Cvfo
         nasiia1K9C9R9tGb+o6LWISRtEvu+ZvdcoTI7Rz+mLV2cLLfl6C4wK+kXPiCHS04IWjL
         1Cj3Ru3xk76kvCZS66fqSkXN4b6PQ3jI3sGjy/CeeKqQUb/BK33Y1sXOPr/V/XvEX+Nr
         rCIA==
X-Gm-Message-State: AOJu0YwzlrvBSoON4aS0HaP9VW2NEGqtXbIVFMRa0ZH+zStDeSoZzZXH
	5xrkaVhJUtc5X4Rrui3k5XNgsx93UB8RwGLIRF4BsKfzzNqsukdZlOpmUG9fEoKwA5Duyw2a94P
	xlwhNa0hYy811WTUnF2uOgk+LUNUAJiLnb+uyEPq71Vymipwmdx0PW5be7IbqkQpClKPA679E6z
	yDH7PtaT8zga0Bjj8E7QmH6Yp30leARk0=
X-Google-Smtp-Source: AGHT+IHxB/wvK7ZW88eLq2mPzfdrKraGlY3vUxwTIx9YmWHVo3e6D2tmb9cmbK2uH9d6WMiSxuo442zJjg==
X-Received: from wmcv7.prod.google.com ([2002:a05:600c:4287:b0:475:d94e:4d5d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5403:b0:475:e007:baf1
 with SMTP id 5b1f17b1804b1-475e007f163mr66110575e9.34.1761565188837; Mon, 27
 Oct 2025 04:39:48 -0700 (PDT)
Date: Mon, 27 Oct 2025 11:39:43 +0000
In-Reply-To: <20251027113943.1282568-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251027113943.1282568-1-tabba@google.com>
X-Mailer: git-send-email 2.51.1.838.g19442a804e-goog
Message-ID: <20251027113943.1282568-5-tabba@google.com>
Subject: [PATCH v1 4/4] KVM: arm64: Add compile-time type check for register
 in __vcpu_rmw_sys_reg()
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Although it is less likely that the 'r' (register) and 'val' (value)
parameters in __vcpu_rmw_sys_reg() would be swapped, it is still
possible. The register ID is an int/enum, whereas the value is a u64, as
in other similar functions and macros. The cost of adding a compile-time
check to prevent this is minimal.

To prevent this class of bugs, add a compile-time type compatibility
check to prevent the 'r' parameter from having a 'u64' type.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2b7c8ba8802d..9758ba502ed5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1147,15 +1147,16 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 		ctxt_sys_reg(ctxt, (r)) = __v;					\
 	} while (0)
 
-#define __vcpu_rmw_sys_reg(v, r, op, val)				\
-	do {								\
-		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
-		u64 __v = ctxt_sys_reg(ctxt, (r));			\
-		__v op (val);						\
-		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
-			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);	\
-									\
-		ctxt_sys_reg(ctxt, (r)) = __v;				\
+#define __vcpu_rmw_sys_reg(v, r, op, val)					\
+	do {									\
+		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;		\
+		u64 __v = ctxt_sys_reg(ctxt, (r));				\
+		BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(r), u64));\
+		__v op (val);							\
+		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)		\
+			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);		\
+										\
+		ctxt_sys_reg(ctxt, (r)) = __v;					\
 	} while (0)
 
 #define __vcpu_sys_reg(v,r)						\
-- 
2.51.1.838.g19442a804e-goog

