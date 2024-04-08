Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CFE7D09F
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 13:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583369; cv=none; b=CGspCVOMncUYHtz6t5z+3kjNNWa0B2w5giiYw2GfqL7TV92GQubrkQUANpgemhRblb4kFqoZMi5M+6NP3HqtGURCUrsO1Hw9c1Cg7+bH41Lr39YLQcnHJMfQFTRnnuefGIdABykjZdbbBJN5BUv9imBNX2ZhG5DQoo/N2nJsQJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583369; c=relaxed/simple;
	bh=oNLEINFv5HD/mA8NGtY9nNyoXVxYTLzRgQ+xmGwugRY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iWd2Kbdghf+5EFNp3M7CQVWSKxMH6efFZMGldlz3iJmlshWZQcOoHGAuTLzxhgCYR1pmAHUrU4Q6Cr5OF3pKCcQUbt0Otk6CgVLjjpuTDx3j67C7/zUPSFDZ7s4cJXHirVy9o3I3IEFREqZhw9MCeJ/TAGNh1rGaLH9S81W7EJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bxFHEncx; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bxFHEncx"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-479e51438c0so483951137.1
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 06:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712583366; x=1713188166; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryaDE6D9eZm7R8LnwbUwx5Z750NMv4aU2biPgVu5YD4=;
        b=bxFHEncxIRg0QNFig2915zpUCXqXz1NNA5QE3B4jaRZrhf2a/GA8YbvajPMzOvG0vG
         CPMPXOYggw2FfmkMwyWoNoC4MvSPfJfJECWI5MmKSJq5luDghyRyz+JaDtvF9NVvvtTd
         Wx+9SU+6mZkXVUDlaC6ehtqLMZbXTNLAuL/rilGwqF+vjN4N0g0vdq+6nwiH5MwFAyht
         AhkhPDlUGiiMUnU/noOq2ofH83slFmEgllW6nwgDw3Mg/ZqUxHCpQ/OpWW2XfyFSMoND
         jzlMGgAdZRLfzN3+sCFuti+/Klwj61DwRsw66HUYOzlc0duf2737Y8nMK5jglMs0qvpM
         pF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712583366; x=1713188166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryaDE6D9eZm7R8LnwbUwx5Z750NMv4aU2biPgVu5YD4=;
        b=vgkwE1qcObMjtNhDNXxB347hdI4qpS+l6xRr0D31/D+nJcPMwy33ZBo17RLHTp5s/Y
         MUs5SU2va23L3COKhkNMsTDvO5O15HkISk35ZnuMBo0fvLzfwzFmzxnzW4YqdnB/EInF
         omDaRNp4p0n0RYJuGNEjBALTkIqnOaTkNfJs33Xto4ibNm/KVDisNBihT52SNXUu8PNn
         S4GUsP/f9op3wyCGJd5yWGi9U2NdX9p0YWob821KZtUap4+0mZq8pE1dvUwrp+4RvIM9
         IeTa0fwMECCbCzHLDhH5Eecbf5yx0Okn6Ur1pMBsDrOancbBJby/I2OvfwO7599gUupf
         7fMw==
X-Gm-Message-State: AOJu0Yzh5p1YAP7DnVkA4ZltS7OKKhJYbK2CImUuyP2ehPZSRpCtPBOW
	dACjWDYMezpLF7EeUqLYAV3p+Bkyz1ckyhSDTdVavo1U+BCbylmQ6EDJpQBhW4EA5VOWYdnHbD9
	sN/5Y660MXTD2v7bffsPWMz3xHlEMTzseTUM+
X-Google-Smtp-Source: AGHT+IGGi4jfSF8R3R+heYACyamJq1fr5adQjXRUqAeiIwDRMiMPtQL6MefAyC18haaNamAHBF77ybu1SsbI22jmWoo=
X-Received: by 2002:a05:6102:3f50:b0:479:dc11:a422 with SMTP id
 l16-20020a0561023f5000b00479dc11a422mr5542644vsv.31.1712583366366; Mon, 08
 Apr 2024 06:36:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-15-tabba@google.com>
 <cd642d56-7445-4716-a2ab-1624df9137e4@sirena.org.uk>
In-Reply-To: <cd642d56-7445-4716-a2ab-1624df9137e4@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Apr 2024 14:35:28 +0100
Message-ID: <CA+EHjTzwJk9JgLikJXPxi348hQMcchgE5wYv17AP3quXppQbKw@mail.gmail.com>
Subject: Re: [PATCH v1 14/44] KVM: arm64: Refactor calculating SVE state size
 to use helpers
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, 
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, Mar 28, 2024 at 6:57=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Mar 27, 2024 at 05:35:01PM +0000, Fuad Tabba wrote:
> > The main factor for determining the SVE state size is the vector
> > length, and future patches will need to calculate it without
> > necessarily having a vcpu as a reference.
>
> > -#define vcpu_sve_max_vq(vcpu)        sve_vq_from_vl((vcpu)->arch.sve_m=
ax_vl)
> > -
> > -#define vcpu_sve_state_size(vcpu) ({                                 \
> > +#define _vcpu_sve_state_size(sve_max_vl) ({                          \
>
> If we're trying to make this a vCPU independent thing (which is fair
> enough) shouldn't we also remove the vcpu from the name?
> _sve_state_size() for example?  It feels like this might want sharing
> with the host too but that could be done incrementally.

Will do.

Cheers,
/fuad
