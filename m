Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D081421257
	for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785170388; cv=pass; b=ihsSY6Y3rJtyggQ7xhv4YqFgI6QrCG6/z+wBt/NPcG4GGppFcrjWGFGJ/XfwN/rUlYexOytwuxlgrhleMNVFm/816tEzwk7KvdfE5np37S3styMsDK2e9s9vQipJPIU7m9ZGt1Nzw4caajQ9EkYnItSI9nfAA3t5BbY9L103y1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785170388; c=relaxed/simple;
	bh=LUBbrdfwesGlRHcWDHljUgGTGcVHOswwt3y/veuVbZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M5mVvIb+2cZyuWcNvcgT9vl7TPO7CeIH2LUNJX2KZ+Mwk7qFz7XHNRxwOrCoviPVSEsnyZDdcRdMtLQFZRydD0eb++PRUZIRJlK6H9t6OSf4X3wlXdQEnfxa1pKR/t5QFuDXoFPtlyZWxraX2T//8yPXTjDScYcFyKzVLLfmZ3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G163/HsE; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G163/HsE"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so440151cf.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Jul 2026 09:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785170386; cv=none;
        d=google.com; s=arc-20260327;
        b=fGPzi9QT+Z37Ul5TJUOI/JKy70GaKqV3x/tvLTRS63na7dgGLU+DqHAr++fKa2xyN6
         6izAEMvdUpVPu3YHmnk4blCkm2t+7j4HeNGvn+exkhGiIK5zdTZ+IcD0bcMuc8haKMu/
         4MlXZwuS5wN9BZVN2HQiESAIW7fXzr8oCeHAjOuHlqn9VvnwiOFlmb2y5J8oFAWBHVnb
         iT798MRXKg9mj+jLXoViJw/E+IeWHLFZQwQR4QPad8toi5DLphKgiGxqT0EwttJiisDs
         8gNUWvCoufdAa69Nikt1aDrXHTp7nqusgWwXkDuLfAQYKTVjZ8E8E3uHFm3+KSQ5gjgV
         otuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LUBbrdfwesGlRHcWDHljUgGTGcVHOswwt3y/veuVbZY=;
        fh=5Xlq1LyLl9EUv/r7vL6OQ2/XJGyjY2YX09peAQdTKoU=;
        b=STu6rlWMh58nSgJvYyKRk5dAW+VshhAqCZyI8Ky0BoTbNoiqyWfpXwvFIfJ/GXQjHB
         ivR+zxPFccBnPbUXu9878yJFq6qzsTZhA6N2cHW/OBwaqLYl+llqDRHGYCd93Sk7upIJ
         8xl3f9sovHZuq2cJpUY7a6zCHCvGgqgxQixJZqAjpYtg8eWLVjBlcB6FbNR4wye897Rd
         nipgu/+c2TyJJJM3RDvEbN0FHSEoh22wdM5jgCG7PIsr/9qfGbcWg54XH0qXiWp7mLby
         ycY0rHnBS+/aRJVIXzKZMMwAIkrD+r5B0qLu8Qb2tNfMuPzNjz2SH6NcmvL5BepMQT6t
         LoMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785170386; x=1785775186; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LUBbrdfwesGlRHcWDHljUgGTGcVHOswwt3y/veuVbZY=;
        b=G163/HsENEP4OvfHxYEy69ObmsYFuu84l3NHZeYsKNSJwfrNMCnIY5PWYQjlXQe9DZ
         CvSeuEryvbS3EB5kjo0b4Uflll1mHfa1dB6zpBzU0KB87NYNFm/HrYE4ikQOIztSt15P
         BCbRS7r/LUxPKK+Vc1QqWM7BUW+LYmWVQlESkKtMK786hXfYDEVlGn93X8HIitAfkSR6
         xlpqVvr1HOU1GXzOP7dJ6zjBNaHsI/AaJxKxNxz4gFHPlwq4kl0PZJQmKeCu4vMV+bxB
         feewMbDgBN5t6CFfe7aW+N080wxZ4WoJ6C96+Vx0iJSqfu1AeHXntG6V/rsmCi4VNGB7
         1G3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785170386; x=1785775186;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LUBbrdfwesGlRHcWDHljUgGTGcVHOswwt3y/veuVbZY=;
        b=eUgOxSSaBffAZmyeokn0zvfVFw1UR0B3D3TpoENsQmB2/cC9KSStv/zp4rxPMD+lUL
         l2s7sC7FCJgrh9y1+YpVgXdPBZGC/dfREwHVuRzZDFWKqlZrVPbPlmd/R9kmICpMXoUF
         MpvgLRklOUrpg0xoSs+GLpNOFyd/I/zsScMz9OK8Ndu/SpFerMhMm6HOPcuRmNbfbfnR
         evGHTbFnPDLVwNn7vPeFhQkbIQhM4D7TP/Ee5CEMpQhfAM7r1hl0eVo7KfAG9B7ivbZC
         4YRPXKM8hGde+r4Y8EYtwfpDK6vHvY4wN8l7hEUWnQcdqOmgSH3S9Fhh/2sL/6gFZMbc
         Ok3A==
X-Forwarded-Encrypted: i=1; AHgh+Ro4RZamLAU8Qn7kpe3f9VUXv2h2E1vp+jBtCSLE6IlXmwT5Jdu0RN4vc+5CDsPcj8eOtly49rw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCHRft9HT++Vome27T6ElUcSNfKiWOepOtTnGALdaeWPWAubty
	cZMfJc1yrURT0t1IP8D3hF16LOOzfieKInTOpJJezHk0vZ915LofJQX/WCbPcL1cm5XReAAIqAL
	sgDTx7MIVuGF989xVu3TPsOexygxYzL4rRx0qRGl+TyJsdGB+rUfjzvHIUfc=
X-Gm-Gg: AR+sD12R4fbzBQPg3y1E/QsYsEQfAxC0ApsfMLvaECXP05z5KEAQMVo+Qu27IlyyrpF
	T687yoA/6ITRklSNiiJWW4SKtOv9Z5CQGfHC/zFRtRHeIvihFkaO06QJ+nYCZXWIDcSFxeuOwRm
	lVoH0xwixDjnx7dbMId5KfdPRKqMykUB+XdTY8jCYrPs08q0zH7RtYGoTcqgCz9xMQ2IOHzdem4
	tZWhbCmM9l4g+KhnztpMgE4BoTX64whcrwng1rhpVF+xQ0uYGQ9ABtQ+ZLNm2xpoyi7nJ2i
X-Received: by 2002:a05:622a:901c:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-529a76e10b3mr34531831cf.11.1785170385186; Mon, 27 Jul 2026
 09:39:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-11-sascha.bischoff@arm.com> <20260724112240.4FD981F000E9@smtp.kernel.org>
In-Reply-To: <20260724112240.4FD981F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 27 Jul 2026 17:39:08 +0100
X-Gm-Features: AUfX_mzw5Yr2AUqO8uAEYXPzPNlrBJYH8jNQa3p7XPPYeAO9kSA3O-KglVf42h8
Message-ID: <CA+EHjTz0byw1LJDnqJGsPgOYz-pwyyY_u5S_44CbKGAfKnQkgQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/48] KVM: arm64: gic-v5: Introduce guest IST alloc
 and management
To: sashiko-reviews@lists.linux.dev
Cc: Sascha Bischoff <Sascha.Bischoff@arm.com>, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jul 2026 at 12:29, <sashiko-bot@kernel.org> wrote:
...
> - [High] Missing `GICV5_VMTEL2E_IST_VALID` bit leaves IST configurations invalid.

Replying to this one because I was reading about this today, and
thought it was tricky. This is a false positive (will teach
Sashiko/review-prompts about the GICv5 once this series goes in).

I do not think this one holds, and I would not apply it.

The IRS writes that bit itself. `vgic_v5_vmte_assign_ist()` populates
the IST section and then issues `SPI_VIST_MAKE_VALID` /
`LPI_VIST_MAKE_VALID`, which is the `IRS_VMAP_VISTR` write, and the
IRS sets the section's valid bit in response to it (from the spec).
Software setting that bit itself in an L2 entry belonging to a valid
VM is UNPREDICTABLE.

KVM makes the VM valid before it ever assigns an IST, in
`vgic_v5_init()`, so it is always on that path. There is a separate
case where software does write the bit, when the L2 entry is populated
before the VM becomes valid, but that is not the sequence here.

Same reasoning applies to the level 1 VM table entry, where the IRS
sets `L1_VMTE.VALID` in response to `IRS_VMAP_L2_VMTR`.

Cheers,
/fuad
