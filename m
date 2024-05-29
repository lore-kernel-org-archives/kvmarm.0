Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2732C18132A
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984881; cv=none; b=gCC6N9uqKW+JBwm4HH8Ti0bndu9UNIveU+xa46h/nrJavQGWQTBCETOufspak6Dv5NYi4Waio0611ntO2HnFL9iYJ8u9akQ5CE/SHo4Li6F3kzlHE3DFwKT68MAJKLzSe9RbDTb/nd3/YRDZGpbFR3onfJ8RHRcAO1GfUQWbc7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984881; c=relaxed/simple;
	bh=UZ7wcKpZc50gJ2LcQ6z4UFnFYSLyGvDPH6gSgnrtEM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XaHc1Rsx1JJ5v07UNXabY3nYUQIrN8mr59uayWnSaMWtAGlzvlpHxzHIK4MatWE0SQu96ZLXKpI8JI7yH0k81yZUnUpaF5ACaHGWLZGCa8GG5/YsQQLkO6vUf8Hg13bWhHCCKYwyMKOU+UErtdVmGh0/XGfy1cj3pLxcgahqQOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QdJmjUnY; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QdJmjUnY"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a6266ffe72eso119402966b.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984878; x=1717589678; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLEJ3O4kV4RVdclClpDnM/s5WQUclK7m/dX1iG4Slsk=;
        b=QdJmjUnYG2u7ebBH3WQGo4pSoALJx81YujIz5W+Lc1ogcyX8uUgZrxvOU0hg/sCA+G
         55M2fSbV1iClFtsTSS8+HjOk7B093Vrwb9k4w0VKnEbh8b9WdY6tvnvDYVVR8VgdesIG
         zLrl11miqqglHzdsovdW986xByvdfqlBpbg4wVrkGQBQoxEX1V6azUsbtphAvrYDvZnm
         /6JZXjui86KlQxKWe4VFFY3/yUj5Dr5Hmfr7Y+eaOpPoo4ZegAr9t8RaWeD/bju/mK0o
         m6GgOzEW11FLbDL6ScZv3pCAz+KL5NKhG7sVt+LzSpelmK83CilZ3IuHUWlOku8BXKTu
         F/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984878; x=1717589678;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QLEJ3O4kV4RVdclClpDnM/s5WQUclK7m/dX1iG4Slsk=;
        b=X3IazGys1D0YFLqb2aFKC95eLYTUU4RoHYGGkDbu9pY7n3h6sIZcOdiIAikpXfY27X
         e0RI2Vri5kCKWe2ToGZ5CIiVY7xL6ek8J1tZDFC9UrjtmCyuh/r203mtPVzaGYt+LlES
         Y/LU96xw4j83OC6dJUVFcezBWEGEi4p9YYu/38qqJC8VNhDZncWoQJgfrH5lJudj7M73
         jkrcukN2H/595HUGuTDZVymARHw4cXUCRo6XJyADSXqapx3+cRgB9SaoIQV260B3S7f0
         VbODGQNWrM4hCL2XLD606CiLha84u/+8yWopaUMqAxAZsFBH+UEMHckWGHtOMHpxTAgp
         zVFg==
X-Gm-Message-State: AOJu0YxU2+kzIk/aYi5n02qEjd8oCG3Hcre9up4XCJsObHOdcj4m1fFQ
	HeCHihVUhMx2qkOiLicpeLEbFRaWDFHrTWdySO8+vncV9Mk3Lm96b6/FPpdeK3aavqKNQnx9Ved
	JRJDHOd5s7YscZz5YU9S4jiIDVfAX0ooA/a2P7WCg0dQMWSkkk6D/+A/BdNEh/FDdWVoRivi0/A
	mIaIPtcbovwl5+7+JK6b0rgvVgDes=
X-Google-Smtp-Source: AGHT+IHcGsvak0IaIBaJRsxrOxRAaw1LTq+hg6b9qMn9Z3a3+Nx+yXco9WUVoWIw3Nxf0/WiUp16udA02A==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:906:1991:b0:a5c:e96f:6022 with SMTP id
 a640c23a62f3a-a62642e4314mr1531066b.3.1716984878101; Wed, 29 May 2024
 05:14:38 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:10 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-5-ptosi@google.com>
Subject: [PATCH v4 04/13] KVM: arm64: nVHE: Add EL2h sync exception handler
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Introduce a handler for EL2h synchronous exceptions distinct from
handlers for other "invalid" exceptions when running with the nVHE host
vector. This will allow a future patch to handle kCFI (synchronous)
errors without affecting other classes of exceptions.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 71fb311b4c0e..bc0a73d9fcd0 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -183,7 +183,7 @@ SYM_FUNC_END(__host_hvc)
 .endif
 .endm
=20
-.macro invalid_host_el2_vect
+.macro __host_el2_vect handler:req
 	.align 7
=20
 	/*
@@ -203,7 +203,7 @@ SYM_FUNC_END(__host_hvc)
 	 * been partially clobbered by __host_enter.
 	 */
 	stp	x0, x1, [sp, #-16]!
-	b	__guest_exit_panic
+	b	\handler
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
@@ -213,6 +213,10 @@ SYM_FUNC_END(__host_hvc)
 	ASM_BUG()
 .endm
=20
+.macro host_el2_sync_vect
+	__host_el2_vect __guest_exit_panic
+.endm
+
 .macro invalid_host_el1_vect
 	.align 7
 	mov	x0, xzr		/* restore_host =3D false */
@@ -222,6 +226,10 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
=20
+.macro invalid_host_el2_vect
+	__host_el2_vect __guest_exit_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consu=
ming
  * SErrors that should only be consumed by the host. Guest entry is deferr=
ed by
@@ -239,7 +247,7 @@ SYM_CODE_START(__kvm_hyp_host_vector)
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
=20
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h
--=20
2.45.1.288.g0e0cd299f1-goog

