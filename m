Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D50181308
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984878; cv=none; b=DEEJiO6MkMV1Z2NexqO10DOVVDQa78Jgz+YP/rRsvgMsGbI3xjcSsp19tPsHI21qnT5t3jI9a2jIhkyZ8NtBB8lvxbmW4PZYQ+oqg46po8WEWhkQegw05XCIri20tFuzEhR5NJSZ18bw3l/qvKgeDSq0dt2sIDvZKoIw9x6dwXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984878; c=relaxed/simple;
	bh=n/Rt+Z7/h3tKGyTZQjuwoohj1Dyd6vhk6ULQqnGfhKE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VFgu0Wt077YEG3pIEqHb+zWiIdPPyy+nDVDfWW8Ajx2PzHCDY3uLJx5D8ziB00EzvZyYxM+c5xuxErf+gxFCV0ouh7NtQYRZ7Kkvoo8OLhJyjKx8gadjpVDw8Pbh38diAcIB/aeHFY7IA6jaW6PFjjmSDb5lhALjg0otjB+byWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t4aEe8l+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t4aEe8l+"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e7f0ca54so36726957b3.3
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984876; x=1717589676; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j4Rf2lfhPQdW0ulVQ+ZkbOO+HrzrcUNTk97aD9mbPlw=;
        b=t4aEe8l+h1NaizLNVnYmMZKC1o8L7cpu0TTmmTRQ5i04L+gEDmYLFt3MiVzJJkIyV0
         RiXfC7xwQ0QW3+alXCMmppR/6F03nifGKY4rnecT72QiVSLiz4pZ1ehjZ5maGRD1PjTX
         w//LdGtWUy48smtU4qKHhKn8AbWPrCPclbxh7LyxiO/6tqHsybrLX0rNNguvlNc/343z
         tFD6CSHw/KrQeMsn0RfXUHHN0Yvtilth9ru0bkhqqnE+XyvxoJ+vgCVdv6ydLYdt5YI8
         8DuyGFQ7VRbsynCp8WyNxxTkNKrf19KqXEtLA/r1chTUhU/uWSPFSrsQc+QwtgGirUWH
         d9KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984876; x=1717589676;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=j4Rf2lfhPQdW0ulVQ+ZkbOO+HrzrcUNTk97aD9mbPlw=;
        b=nkR7COC30Hvi7wxgjPaWo1loHoU1WxZA3NREjjfIUOwC7GMHl3QCYz1quUhWcudLPi
         Xd4Yhmj0I66+JrzPffsEh4jkldSrYsPxg8aW+x/dm0FkTy2Df9WA6UGSaleXje3s0q9P
         oj6NvwW/JLxl/e+3AgNqLF6vWhF0HdqdmseODQsFaLP5xf8aTGa6fQXBucoozEIiiR0j
         k/lEbq4ghhYXM8wnpR7EGHsh6eLuj8Twgrl06FGW1X0szygJlWPrfEhDXav3jGSsgbwZ
         sAOF5Sj/qVYfctO3xV2GQ5JpX++9bqywhi9YKzLndk6vyvfiyWCwdDTY1gvX4o9ZSp+b
         mXtg==
X-Gm-Message-State: AOJu0YwdxE/TRvu07NDkK3hQO7NG9HD3jDZZa5RvQfcKX3dzgxGBwbj6
	HU5j5Kp1EW0uL6/SvMZGkeJQnI9r99VMul3JFBjl2c2AnKXOETGk2IVnDDmkjEvDFwmpbfBsOgX
	3k6xbRUy6a3/4eT7adTv7lD7JFMXj7p+c8q/KoOR9EvaGSZzgCl1kaV7NdOoXhvS2zO+zWWE6Tw
	NB5lZCmJfdh5Aaz+HmYq9bPOn36fQ=
X-Google-Smtp-Source: AGHT+IEkdZ2CPDm5cYVOhM4+XL1fH8AlLKI24Mx4NO3l+ssr5tA1I25II+Qs22X8PnruQU2dGz49CMMUxw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:f0f:b0:de5:4ed6:d3f3 with SMTP id
 3f1490d57ef6-df7721df7cbmr3593228276.6.1716984875835; Wed, 29 May 2024
 05:14:35 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:09 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-4-ptosi@google.com>
Subject: [PATCH v4 03/13] KVM: arm64: nVHE: Simplify __guest_exit_panic path
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In invalid_host_el2_vect (i.e. EL2{t,h} handlers in nVHE guest context),
remove the duplicate vCPU context check that __guest_exit_panic also
performs, allowing an unconditional branch to it.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 135cfb294ee5..71fb311b4c0e 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -197,18 +197,13 @@ SYM_FUNC_END(__host_hvc)
 	sub	x0, sp, x0			// x0'' =3D sp' - x0' =3D (sp + x0) - sp =3D x0
 	sub	sp, sp, x0			// sp'' =3D sp' - x0 =3D (sp + x0) - x0 =3D sp
=20
-	/* If a guest is loaded, panic out of it. */
-	stp	x0, x1, [sp, #-16]!
-	get_loaded_vcpu x0, x1
-	cbnz	x0, __guest_exit_panic
-	add	sp, sp, #16
-
 	/*
 	 * The panic may not be clean if the exception is taken before the host
 	 * context has been saved by __host_exit or after the hyp context has
 	 * been partially clobbered by __host_enter.
 	 */
-	b	hyp_panic
+	stp	x0, x1, [sp, #-16]!
+	b	__guest_exit_panic
=20
 .L__hyp_sp_overflow\@:
 	/* Switch to the overflow stack */
--=20
2.45.1.288.g0e0cd299f1-goog

