Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C5513D612
	for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737762; cv=none; b=tc4zUcqoes4KS5yleEPzp94cqlrnSm8pTdfe+rpoRO4HjzgEyH2oQiaDCkZTlihH/etEYlLG8Pxk2GOvwJ6AiV2CqtJF4SqBlqxTojzaVenWzWNbKOJfjsRvKZhZ/gA99xxdNsxAkAKOrx96BVoX+AXwhWo8fyAWbOyxcCyrD+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737762; c=relaxed/simple;
	bh=1xy8JEBzmCvsE0c+vyvVtF1ncyFT2iUpIVYsycSUaUc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CnVDlmf9SbRV0o5n3F7yU1Q6h6OxOptTrOCQMcnX9mdwfy9flQbajKgFVy/k9i9hRmeUHnYT3REseHa/aMRXUMkXCB4p/HTtMLe+9QEkpQjqygsVwcR/x5rxYI2xF4GEVygEfnFa8Wpd6eI9+4jeaHy6vUlEr5o0Zn8lFYT1uvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CTGHlME+; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CTGHlME+"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-56e6f4ee104so2596842a12.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Apr 2024 01:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737759; x=1713342559; darn=lists.linux.dev;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jh/NV6yW6K+2G6i6rK3aentqLTJHJAzofXzqiefolM=;
        b=CTGHlME+gqjSlqkqjP/UANIbhAXJ7PCagOPOdfQAHHn8AFEJlisn8FwtP38eUj7G0f
         UZjCZyhUmmkYQLzGsBsms0zTWFkMIKSGAqN5pSK983pxEt3yQGSb1yEwdN/1t/bdPn7q
         0tTH2Vc49uwuqbcUnbseEt0ngI0Bn9tIJ8fEZfNXtEkrYrAcAPW4rEAtY2khBmDo083J
         LsukevXEmxmKJpCjoSxXXpZyZFq9BM/rlyLT/w9rh/AHxcXRLyhOubam90Nuu61e9X2j
         QTuSZkJm2Qwmz3F8j080XEts2GoacvtjWOgeqEmPy4D8v1jy73KIsxmJNUuDyuFNG7gS
         uH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737759; x=1713342559;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jh/NV6yW6K+2G6i6rK3aentqLTJHJAzofXzqiefolM=;
        b=PLsAFYIVTv2bomz6kbqWVHRakExsweLDF+Cvn6RPbaW/52ktfRyYYSSVeik9nJ562A
         EMjEpAY9J2QpXJgw3rQCMnvFrXcg7lzm3SKSYU7cbl7gL7niAwqBi4LnJ73yVsxIsioC
         L05/nMxmpBQ6tkGcjEbSXTuAO3jvsNIMol9BMwSrq5LenTmOS4CELVQIKpUjiI4jDIIB
         KjEqdLnpTEkeUbV4GbkTJf5vLFIuRF7Nvg3txy3rOZ3jD5W9jOGnbl8FPL0VJtktBo4A
         egOm0/7J+QJOP5Q5dtWxAGg1kgEsNxp2L/xn8C7G6LYdljORsvuH1Dg5ok4yjWHUssgS
         rP8g==
X-Gm-Message-State: AOJu0YxE41Hv6T1wKNXntNrBqtPyN77fFV15O87SgNYtOO+YUYVUXc7I
	E625m2L40AeH2JWhuSREgsw5hB/HZ4DdghDH4TYiqp9Kd3Ii9zz6MlLSDgLqyHX33Goe2lShL7T
	Hbg==
X-Google-Smtp-Source: AGHT+IHhEhDmwBmoCNwZPINWnUcQxwKkJgql9hzsRwxXum2LL0s2QGfma9Zc+wwW++uYiLm7gJA5pQ==
X-Received: by 2002:a50:871b:0:b0:56e:219a:b49c with SMTP id i27-20020a50871b000000b0056e219ab49cmr1074195edb.32.1712737758727;
        Wed, 10 Apr 2024 01:29:18 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id ef5-20020a05640228c500b0056e74af55e0sm1558489edb.83.2024.04.10.01.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:29:18 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:29:14 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 07/12] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
Message-ID: <7f4fsc647ve5c4tn5wxosdrss2iqd7fsgmdx3rha4dvruwyi75@kc5yyoyaw7iv>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 1581df6aec87..9db04a286398 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
 	u64 par = read_sysreg_par();
 
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
 
 asmlinkage void kvm_unexpected_el2_exception(void)
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre
