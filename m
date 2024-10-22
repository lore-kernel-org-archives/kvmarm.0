Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB9512B93
	for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 20:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629955; cv=none; b=Wk3dZ/BJDGYFhhhjSjWQ7KvacQj6lRY/p/pT3N7dg1QIBNDgMmtxcT06PuWmxaqBFMGGup/dLsdixcHnkya9vh49eN5mALYeGCncEWBLEYyGT3XlLAETHnkoeClVSVQ+H6JzXCk6Tu2+Ow+tgGHE0Ivn2HImnTh2CrFJAAkYn4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629955; c=relaxed/simple;
	bh=ePP0KKG3AmqoivlK1Old/Drm0oSgiiqOXmhfPrCwRTM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MNSY/S7Un6lP/weAhtSkg7q4pU5PK23xRXFr9q2uOo994CTHGE/L9RLpr2EHbcYWWW0K3tZC4Tf0E9LBscB9kfovmfE5q4oIRV0yySpCatDnGulsXsU0IKNvAY9DyBJbxYgv1ceasdP5F21E8zvHXSpiSJcVDeXVZRxnPhRfX3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hj92inD5; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hj92inD5"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4608dddaa35so93361cf.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Oct 2024 13:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729629952; x=1730234752; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7pdxsF3XjrG3sQC3UYjrYUD/z5vetyx8pXZ2oumqo0=;
        b=hj92inD5QdaKEg8gUGyMK2x6iGqojCZMyMYl0O8BHddgQKMD1C60i2JZJgyRLTajcO
         EMDNRBZJUc8S9fgF/UInxIZRdVUFvQv/xNVJnrRRb3+vF+eOsv7Zl8Fqm8cZnPU/R8YK
         5v70MjYcyV0GGBXRj1kdhsIKNTAe6NSd0zhv7V1CeX24xmsLtvUAqaunxWCOmBU44/aI
         iNtJyrZUuG24GxATaniOIfEQdMCUuV1ukyDtoZN6Jn1uUAgyDsL8tsYnBQBhi09+tjfi
         H3XH6ZYY6jwOqe6lrdhj3yJtfpmpkXJHhWrlVn8axUuBDJ1+SYL4iUpm0r06J5+JBeZf
         b2lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629952; x=1730234752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7pdxsF3XjrG3sQC3UYjrYUD/z5vetyx8pXZ2oumqo0=;
        b=mwWUrxyNnbeXufWBBoNAbBEBAOT+aENnD0TxaZHJzjwlATriEeb2yve6oMV7s5deow
         JTjMoI+9YlytIaG/QxnKsM4TjoQkCEkAWy9cHWOg05G21mGzNoxnnVDXGV6p+CjdH6VI
         wlJKBEoeMbOUa7s1SFv7JyIn81ckLneCSIIXDcqCDxHWGKuI+2plgsXXvJ6OUA1w2S4N
         vynevmfGLUi9U5yFB3e80mR7Me9PdkNG2pu2jdhUXrjpv9f/OIvtH9CDhb85gdPLkipM
         Sy+i7/DwlEXRCLffFYS8o5hcLRTccZUOJSth9ATpOizhAo3W6XMQ9Nwt4F80KTrkuNeK
         O/rQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9B/7/LskKI5Ev9NgBkEoOT+C5Pstdq/aZqM8bRizb+pMyU06Zga44AbFAuoJBZqfyEuzRuOQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxfn4IU0CM54XY3Beg2zLqmiOAZkx8pRWXO4Mt2CsAr9rusSOcF
	XyAeVS1bDB++pst4P9BS/7Pi5tTojIUPzBxYLF38z3R4Kje8A788s20YjtOGOZcYXT/SDkc+6uk
	m5VmiwFKr9UUvfVbB85CKZ07e5kG4EfdR2aoM
X-Google-Smtp-Source: AGHT+IG2tJpAMbmo2KfN4SiR/K0WDNMUziYfvYUHs03hKb+23lCo5klxeLBVIZb8UJTAAHrJVJYY1WsxyjaM8DrvBec=
X-Received: by 2002:ac8:60d0:0:b0:460:48c3:c352 with SMTP id
 d75a77b69052e-46113cc66c6mr816011cf.1.1729629952138; Tue, 22 Oct 2024
 13:45:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241022004710.1888067-1-rananta@google.com> <20241022-2c60a0bcbb908435aa91d1ff@orel>
In-Reply-To: <20241022-2c60a0bcbb908435aa91d1ff@orel>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 22 Oct 2024 13:45:40 -0700
Message-ID: <CAJHc60wRgy2Hp6ZKAAmfH0sNFOFgvRXr_8-YuNf9+HV9-xwWDQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] Fix arm64 clang errors on fpu tests
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, Oct 22, 2024 at 6:10=E2=80=AFAM Andrew Jones <andrew.jones@linux.de=
v> wrote:
>
> With clang 18.1.8 (Fedora 18.1.8-1.fc40) I get a bunch of errors like
> these
>
>     arm/fpu.c:281:3: error: instruction requires: fp-armv8
>
> I used my cross-clang series[1] and configured with
>
>     ./configure --arch=3Darm64 --cc=3Dclang --cflags=3D'--target=3Daarch6=
4' --cross-prefix=3Daarch64-linux-gnu-
>
> [1] https://lore.kernel.org/all/20240911091406.134240-7-andrew.jones@linu=
x.dev/
>
> Thanks,
> drew

I was able to reproduce the errors by pointing to a newer clang (20)
and applying your series.
I think we see the errors because llvm decided to disable loads and
stores on FP registers with "-mgeneral-regs-only" [1]. Explicitly
adding ".arch_extension fp" for the fp_reg_{read,write}() helped with
the build:

diff --git a/arm/fpu.c b/arm/fpu.c
index 6b0411d3..f44ed82a 100644
--- a/arm/fpu.c
+++ b/arm/fpu.c
@@ -38,7 +38,8 @@ static inline bool arch_collect_entropy(uint64_t *random)
 #define fpu_reg_read(val)                              \
 ({                                                     \
        uint64_t *__val =3D (val);                        \
-       asm volatile("stp q0, q1, [%0], #32\n\t"        \
+       asm volatile(".arch_extension fp\n"             \
+                    "stp q0, q1, [%0], #32\n\t"        \
                     "stp q2, q3, [%0], #32\n\t"        \
                     "stp q4, q5, [%0], #32\n\t"        \
                     "stp q6, q7, [%0], #32\n\t"        \
@@ -71,7 +72,8 @@ static inline bool arch_collect_entropy(uint64_t *random)
 #define fpu_reg_write(val)                             \
 do {                                                   \
        uint64_t *__val =3D (val);                        \
-       asm volatile("ldp q0, q1, [%0], #32\n\t"        \
+       asm volatile(".arch_extension fp\n"             \
+                    "ldp q0, q1, [%0], #32\n\t"        \
                     "ldp q2, q3, [%0], #32\n\t"        \
                     "ldp q4, q5, [%0], #32\n\t"        \
                     "ldp q6, q7, [%0], #32\n\t"        \

If you are fine with this, I can push it as a separate patch in v2.

Thank you.
Raghavendra

[1]: https://github.com/llvm/llvm-project/pull/77817
