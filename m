Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5161223DFB
	for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758902323; cv=none; b=nX4gc9SIjEY6rPS19NtsbSOjlEukSpRT/WBIyuaFidorr2OgyIIORZWwhoGoT/c38N8oYvIA4VSPFEQ3vojcBIxZqVVAz5cIKz01vdHd+7xcHYnTKjWXV77RowG5cwqibihc9t9phVvYPqbwP9WiVfDFcmEerIwixSRLNBQqQeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758902323; c=relaxed/simple;
	bh=ioYNFXSk4x7Lrdjvrdmcd3nR6XgAOSJkZ5hhpjugXk8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R29JzPcprFg6B8yPYByrtV8i1Zy4Rtgaz/U7AmJlYdfEq4mfEstTvKDwt2zGPRGp5HGKEuf/vDBPv8pJyktDAUEunJvw24d57ny25Jh5c/hdVxvrmr43dUZcxs7Y65cc1ciDK7k2Nuw6b0PuJa9RJGJoTdOjylVP6VbmWvcw+4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VeKID8dT; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VeKID8dT"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befbbaso2658082a91.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Sep 2025 08:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758902321; x=1759507121; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L5K8UK2MsZZPVLL6gVUiO47uURDGeEw8rDgtDDz0bOs=;
        b=VeKID8dTvFcqdQ4wsG4M9zCEX6V0gTXc/kro7UyP22jFEDrRKdXcYcTqKMXZAf9Jnu
         QM+tSKu80UilTNb160Etf24CVUy67vtWZimO25rdCY07IasJdwijoxmlWtX78T/mNK/g
         baKyLJeOHARXdMKRJzhn6LprnXCVIZl8pCl5lzQmmc+iGnZobChtiWbDChZ+D6xK8hQy
         HEPgQ9VS+GCLy1HU4Qcu1pMkKcd9JteMSVtN3IsCwSVBZInkIplcI2R7ay0XWg/ed4UJ
         XULkGebmvFeMaTpJ82ygM5fRvf0hP2DV7+hURRdl2c3X+zcWkRjsgg9CoQbQKCK8R0KW
         bwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758902321; x=1759507121;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L5K8UK2MsZZPVLL6gVUiO47uURDGeEw8rDgtDDz0bOs=;
        b=KCqPCVOXJAoQVsxmp5T6EQaRxHwbHHFqSLPh7UC6OIUtJfF8e6JoikyhJN9VoB005y
         srBxto/+pEE+9ZswJdzu6e84u6BGOWvIP2J8wz64qnFYIO04Qyl4/RTzbbGousLmG7b2
         4nilR9MArF6QEMVipI1htE3hyfLzvYPyz1v74HWMtIruzMLAf5UpHqzvhAKfwQkIoUs7
         bQJ/Td8cIBe6j9uREumcE3sjW5XGgbkgdmPgnsI3Ddn4XHbs473l1343VZY5ya7/TvHg
         /+MGMUHQ16r0Qo9OqKa8myq1MVcrmtn8NrGcnrY2I1RGEIuFpShRad1VGw2Xjj1lDw9H
         c1KA==
X-Forwarded-Encrypted: i=1; AJvYcCW5PIW8+TvtycHdIx0f8nvTdGO7yu0FzPlmw1L85E1ICpyfAq7fIPqBj/kTyFQ00a0CqjrBsIs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNCBynQfC7dTlRuqgDOhsPKIXMTVvtVzZzOhW4sOAzxB31JD5N
	skHphDuOHtHjUqacpZ64fqiSEDrPBMB8N6aYFIIirjh76xweRc8RcK5R9k8pM5zVWm2JnTPlabT
	/ipFTXg==
X-Google-Smtp-Source: AGHT+IFjpgSzA5Rlw7JbImpaC56pYTXgSa295k3g3PBWsimpHinIifwdOO6eH2ZwQpZ8/ysgQKAAB2w8fRA=
X-Received: from pjber8.prod.google.com ([2002:a17:90a:f6c8:b0:32b:6136:95b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f8f:b0:32b:8582:34be
 with SMTP id 98e67ed59e1d1-3342a261050mr7471559a91.13.1758902321029; Fri, 26
 Sep 2025 08:58:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 08:58:38 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250926155838.2612205-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Track width of arm64's timer counter as
 "int", not "uint64_t"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sebastian Ott <sebott@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Store the width of arm64's timer counter as an "int", not a "uint64_t".
ilog2() returns an "int", and more importantly using what is an "unsigned
long" under the hood makes clang unhappy due to a type mismatch when
clamping the width to a sane value.

  arm64/arch_timer_edge_cases.c:1032:10: error: comparison of distinct pointer types
     ('typeof (width) *' (aka 'unsigned long *') and 'typeof (56) *' (aka 'int *'))
     [-Werror,-Wcompare-distinct-pointer-types]
   1032 |         width = clamp(width, 56, 64);
        |                 ^~~~~~~~~~~~~~~~~~~~
  tools/include/linux/kernel.h:47:45: note: expanded from macro 'clamp'
     47 | #define clamp(val, lo, hi)      min((typeof(val))max(val, lo), hi)
        |                                                  ^~~~~~~~~~~~
  tools/include/linux/kernel.h:33:17: note: expanded from macro 'max'
     33 |         (void) (&_max1 == &_max2);              \
        |                 ~~~~~~ ^  ~~~~~~
  tools/include/linux/kernel.h:39:9: note: expanded from macro 'min'
     39 |         typeof(x) _min1 = (x);                  \
        |                ^

Fixes: fad4cf944839 ("KVM: arm64: selftests: Determine effective counter width in arch_timer_edge_cases")
Cc: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index ce74d069cb7b..38493c9cde83 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -1027,7 +1027,7 @@ static void set_counter_defaults(void)
 {
 	const uint64_t MIN_ROLLOVER_SECS = 40ULL * 365 * 24 * 3600;
 	uint64_t freq = read_sysreg(CNTFRQ_EL0);
-	uint64_t width = ilog2(MIN_ROLLOVER_SECS * freq);
+	int width = ilog2(MIN_ROLLOVER_SECS * freq);
 
 	width = clamp(width, 56, 64);
 	CVAL_MAX = GENMASK_ULL(width - 1, 0);

base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.51.0.536.g15c5d4f767-goog

