Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5526D181B96
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984887; cv=none; b=tuuovrIbh3BxJa+UJWXo47FZIlv5Y42VP50MNW9080y712j25hC3+0oHtCaDHKpDRhqf7oSGQg+HRH6XDwnNjxr+E9wKJZ3ljSwgtWKlj89vStA1mHcl+m5inCxcqdzk0yp5Q2n3vGJJuv/gboC7NUd89ru/AjENzKIkQPa9Bs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984887; c=relaxed/simple;
	bh=oY+YSwPHFqVVY3fzP9ou/E6BfHn7ARC/H1gWBIAm1+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ijrFEkoGCH0D2vyCxov2lt1hnE4t4mam0zyLjWI0zLvyA1ibYiGh+vNuYdK2m1+wSj/EJVm+02B+8bYQp93g74aDOUx1To2fP0Euh1N7bflZsSt25scgkAsRSkaouL4c48sgRsGl1Bew0LCXlMj3xRV/2Z2br2hNLiqKisOc1OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1hHKdXxm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1hHKdXxm"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df76f343b75so2988112276.0
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984885; x=1717589685; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8LApYKgBNKEpQOUHCgPJ8rjKQvWvAO0g6PQmvtilIlw=;
        b=1hHKdXxmLdnIxQt8tvHBzCRug1kWFOsTG7ur77P8adjGYHwI2PuvH9BtYoKcYoEI29
         D5q11H/JZtCCvkxi+zm0l7Iv54RkOotKE6OVV0unN2TqbpSgV9+SPl7QWzKxttT5x48P
         kBrFzLbHw6xdUkBjzlShRDozN36dSGpZKPzJe+psTNdF7qz4aGWmiw1pt/WlLPlPDDEW
         /JdOvsTn2iBXlNfwQIOBMUev/dAVKGuvsYvUMNCPSBH3OPXmtB/PkGwt7OXeRSxjKA6R
         v6pznr1JWk/ji+VRhxmdRqzqS+zJNMvjI1Ml+YkzfZF7citqZ2/DzJkrfJ5D9rAVhNqR
         nJ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984885; x=1717589685;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8LApYKgBNKEpQOUHCgPJ8rjKQvWvAO0g6PQmvtilIlw=;
        b=kwkx4cEP48p2GGTgBW6tYNck1skPCiWf8/1quxnxHFJ8xbLMY5T/iHz7s1Xypy/RJa
         aU799Z9mn8cbchZ54xs5cQTvSdFuHZKIp6ZYfWSZV/gh1+vcjdTNWXB9b4mKxDbR8Yxv
         sISI7cPJRhxrzP0/HS0A7Fui6Drrp8GcTG3Vqtzk83lQyKQHQBZdeDn3ldJanlcHh9Vs
         E8H8ds/DBfmwwxztjvgGVmlPTDJJhPCAAUpGEQZWHAq62q9alK/xlxJT2yS2Rx5dWBFf
         jfndwrvKqD3NA8pefvqe6pBP5wlWqtAqyt60Y93B4wOYWsZIMD+qZrUmXDVArF2EwtwL
         djPw==
X-Gm-Message-State: AOJu0YyJF+lzoFc/PFLAzJ2Fp9o5VNquVtG/nrCl2BimmmOgFuVk+L4B
	Q6dGEoKON7sTmoIuMad52cmQrgKEkXEvFTewwFRgD1Dz0O92zOOiFY9gdP4AvBBAifnA8Y7CuEk
	TxpPTa5GEY6IZ9WW4a198zDjs7MJiokPNfANuMQ6g74mEOqVqZl1iGq9g9LxBk7NzlhYqlMPW3Q
	amPV7chPjij8ScFwEcVTC/LJTWc1Y=
X-Google-Smtp-Source: AGHT+IHSjvv323m46MNf64EsuTBJ/plesPXi5fnjH9bpFqNhZzaJSI42rMp8TuTkGGyShh9t0w2mdhFYDg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1006:b0:df7:8c1b:430a with SMTP id
 3f1490d57ef6-df78c1b6af8mr3075741276.3.1716984885370; Wed, 29 May 2024
 05:14:45 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:13 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-8-ptosi@google.com>
Subject: [PATCH v4 07/13] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index d7af5f46f22a..0550b9f6317f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -384,7 +384,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -409,7 +409,6 @@ void __noreturn hyp_panic(void)
 	u64 par =3D read_sysreg_par();
=20
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.1.288.g0e0cd299f1-goog

