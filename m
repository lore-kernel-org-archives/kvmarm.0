Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450FA2032D
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001190; cv=none; b=hAri6c/mjyxBhWTUDtwhT8VcF/06GRUrjpi7yHBLK/BMRnix753T74gHHAMZ862RTJEIepieVFvq8MjqsUlPT+x0LSbRBLmDIA8mWg0B3UGMKkaVxnibIe9DkGvmPjtI7PFelHem29r71Q88mVVLYsT4YqSmOUwMpcHhJ/XKek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001190; c=relaxed/simple;
	bh=4sBy4q9o+2XAwUMDPYKyMJ3gbWzk4GYah5sqC1TOQ/c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k7lRfBd2R4sGzc+eexyJHJROtmkMnbVu2rU3UmU2ugDI0qLU7d7yH85fZ7vvv1REKPP3iQr/K4anTn/6uS4+gRoir9cJ4L+EipjDS538iKc+vNLjnslri2j6bMc7YHUSmd55anPZOrzqGvSBPzdscSy16XRvZamzq1GzzFmXod8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q2YA4rZ6; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q2YA4rZ6"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dfb0acdf0c6so3815499276.3
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001188; x=1718605988; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FAg4zwCV0ETMYk7uJAuzLLD4Wj6HS+UWIuwSFsyOCeM=;
        b=q2YA4rZ6StsawTofGUdoveaAIfei/msFlcqaa6ZTW3keI8IfSotvvbvJy5kNNHBZBy
         IsRaeZkfktbUpXiGvpoe7X4sOc8dsVD9er3h0Ds64M4el20c7PEldoUF9nfwT3K96Xtc
         WJyWJZUqfzYflvVx2F9SEGh7p4Hx4lR4Du6xqT0wjc6obUwwsaX3UQdRs+L+sY5OR3ae
         A7cKXp1BVz3MxRqqyh00ZoNMklArHKpVRfmEUC4/B/CsEBwdoVg/o88OuqDUHXmfJ+o1
         np2pUdcmvvNB/oV5FYLyfLRRAxb8YdPSMo0CMVobW2+M7E912pQ0pG111KWo5FgW8iOu
         bhCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001188; x=1718605988;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FAg4zwCV0ETMYk7uJAuzLLD4Wj6HS+UWIuwSFsyOCeM=;
        b=hTf2UGbAiZ80HKHy0ROFbMMBS/gPiSir4JXSpCAck2RgJqwZYSrJp+d/E7kKsczHR6
         PD4V1uhBDKUiCygaad9srX8PCx5uavv++cWQExBPEHKg0SK3ofj1XXuL2c8C7pHOARUN
         AL+lBuIRdE5Ax1j/ioDhXzAfhBJT+/j+/V20Vta7BsmFoUJtqSicxqXoa0vgQ2dogGVd
         tGOULCKVeGoYfqOCtFb7fnrXy8rpvoOmG/5H1cV7Mo2r/zUo+peIz2wbBACCKSVsgC70
         uRjPSAscptfr3eaGRHTlJKKrQFuQQD1qsNBh2e4yJ3JHArYbTFkCKCfRqMQ5W0GtEA+B
         R41w==
X-Gm-Message-State: AOJu0Yzuu2Z8NWrg+4EzEbrOMTW8LxhXV5CKfC2ue2xtpVM7fSQo1x0u
	apiVFgYWjHPC+/xW4wet8iHiTAyrY37sw/BDFUzhRq83EmGUZfJEq2lmQQWCDpk94+LLMjtbHOr
	arNebHckiDNPVCukdZHS/bHZMQktgNdZoN2j2wEDnd2fddKaYpnwhfHF1X7AICja40qgl0FHHBK
	15Hdeo+jdOO7nOJw6N2bhkLGfUO+0=
X-Google-Smtp-Source: AGHT+IFreq9wyxrRYtilc13+BKJ6v9CVdYWcuPyBidJggSdMr5wZPl1j8+ICTd1AZf0bVymxH29Mv4wpGg==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:20c5:b0:df7:b717:10c2 with SMTP id
 3f1490d57ef6-dfaf6524ed6mr2518522276.2.1718001188121; Sun, 09 Jun 2024
 23:33:08 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:32 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-4-ptosi@google.com>
Subject: [PATCH v5 3/8] KVM: arm64: nVHE: Simplify invalid_host_el2_vect
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The invalid_host_el2_vect macro is used by EL2{t,h} handlers in nVHE
*host* context, which should never run with a guest context loaded.
Therefore, remove the superfluous vCPU context check and branch
unconditionally to hyp_panic.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/nvhe/host.S | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.=
S
index 135cfb294ee5..3d610fc51f4d 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -197,12 +197,6 @@ SYM_FUNC_END(__host_hvc)
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
--=20
2.45.2.505.gda0bf45e8d-goog

