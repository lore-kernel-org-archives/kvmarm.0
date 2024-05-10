Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D0E17557E
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340453; cv=none; b=Ke/qyx+zYe9Wf+zojRVAi7m7vvfuknmlxphtQZr8ymDCigXR40OODmSJ6HTkHF7N+uzJQLxERTJ9O1EKff9kb1h1RtdbPKsKiqidMLcKmv4kk9SmB2AXWvXZpfRn3qmTvUlFJWfVYQlDNpLSzj3Jc5jpikRLCCnb9lDnYbrVjhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340453; c=relaxed/simple;
	bh=RuQZrcKwOHj3TG5Qgns1mzsOfW6oRw1bJHQR20VMa7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mPzqjgS58by34BrAjrjOaL080fRSB/gxQbHLGDIxlAJRHIFmfE1p5fN73iwJdtvvKq4X8RjTcP4/Rb97ZyKD8YAi47FBau6pJL8YXmR3+FINBkETKDNAP9/bfwOpOFAj7owOmsoml0tGFkPx2HKxEiIgjuS2ake+KD4R5jjYBn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k6DDBJdd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k6DDBJdd"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61be530d024so30385517b3.2
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340450; x=1715945250; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qcEzQNh9dWuFIVjzg9t8TylWGTumh3MZGtqI9gQXfso=;
        b=k6DDBJddaQqLvi477ygWRaJc8ETRFx+Su2jY04eQLnrAErQ18bqGKCZS0OUWQ7li7N
         73GuE1jMi1EvP7za4SZWFSDp9Q+3wiUDsvKLKBI6s9oq1CtFKxZx3bn+Aih3lG7uUrbP
         z3EmdMQknRH3kYiw8rgWIKQ0Fr0nMPk6ROjqF8S0cKygOYSZyg6wffYrd3kQdx6Os6Bm
         BleaDbV+A7/uW7GpAbcFJG6YvP+Q5P5hbvTjPrWhhs6+9IByMbEMipkuB8/LUta5jOzr
         Whd8+jSk2inE9e9y9mGTlPwx8D3iLuBSNext+ut+YUD8+yVtGrYTZ4/HsKdqW6GL/O/s
         wEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340450; x=1715945250;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qcEzQNh9dWuFIVjzg9t8TylWGTumh3MZGtqI9gQXfso=;
        b=jpIPCuC3HcLKmeemTP/hLx+l77LsFrjzGnVtwg0greHLBhWbpT2Jn8/7OtlMWLHWiC
         rIa3x732IlE7EweUR3NFkDBN26EjLvAh+ZYi5zyqkXu1ch1Tq2NedcQPOTCM2cdtpB+d
         DNVH67267ENqqXoOaDEbMTXU9VimgNEZ+IOob9+vevvFY5txlDsipB2pm6FnZ+a856zC
         lKg2SxzLJEdnKbZhTdwoXLDAV/eeHEUn4p+3lJUp2xE2P2rLewQz1s1NxruhZOos8xJM
         X/jGvVDd8NBgwMbhM624wCjIjcORy10zAE1znq6gMVYT5dLWkcTY36LA8R8lxLHTj636
         d98A==
X-Gm-Message-State: AOJu0YxqNMNq2zPAzdPL+0BQCF+SbgPPJ7e/LFpLGQU2bLYtOSY59yjd
	lRcwg6DFt57Qdkn658i6XkyPFRdJD1QkyTJLolpL7IzCmRsw14m1AfbVL9d7+FpbEVyYbL/+n/v
	EWwg6xptQKgTi5bxNqPDmUL4G/hOidFGM1r+ZXkPEpTNuDldb+dODD6x5A5VkzWehqXmLMp7wTJ
	7H1lwDlryHTZKGbGnixaF0NcSUcmQ=
X-Google-Smtp-Source: AGHT+IF00DsgRNr4wMWPoZLxFG4BzAtNHmn3WH+94RNNB3FGneRo+0N3ZZ2Yl4THjXTnNjJION1G71wXVw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:690c:4507:b0:61b:3b02:6901 with SMTP id
 00721157ae682-622b001dd60mr5562717b3.9.1715340450084; Fri, 10 May 2024
 04:27:30 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:34 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-6-ptosi@google.com>
Subject: [PATCH v3 05/12] KVM: arm64: nVHE: Add EL2h sync exception handler
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
index 7397b4f1838a..0613b6e35137 100644
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
@@ -202,7 +202,7 @@ SYM_FUNC_END(__host_hvc)
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	__hyp_panic
+	b	\handler
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
@@ -212,6 +212,10 @@ SYM_FUNC_END(__host_hvc)
 	ASM_BUG()
 .endm
=20
+.macro host_el2_sync_vect
+	__host_el2_vect __hyp_panic
+.endm
+
 .macro invalid_host_el1_vect
 	.align 7
 	mov	x0, xzr		/* restore_host =3D false */
@@ -221,6 +225,10 @@ SYM_FUNC_END(__host_hvc)
 	b	__hyp_do_panic
 .endm
=20
+.macro invalid_host_el2_vect
+	__host_el2_vect __hyp_panic
+.endm
+
 /*
  * The host vector does not use an ESB instruction in order to avoid consu=
ming
  * SErrors that should only be consumed by the host. Guest entry is deferr=
ed by
@@ -238,7 +246,7 @@ SYM_CODE_START(__kvm_hyp_host_vector)
 	invalid_host_el2_vect			// FIQ EL2t
 	invalid_host_el2_vect			// Error EL2t
=20
-	invalid_host_el2_vect			// Synchronous EL2h
+	host_el2_sync_vect			// Synchronous EL2h
 	invalid_host_el2_vect			// IRQ EL2h
 	invalid_host_el2_vect			// FIQ EL2h
 	invalid_host_el2_vect			// Error EL2h
--=20
2.45.0.118.g7fe29c98d7-goog

