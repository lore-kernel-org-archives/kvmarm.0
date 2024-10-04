Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41161C82E0
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 15:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728057491; cv=none; b=OSQZal+cWLwsXbqyKyUbg+a1DZTkAag0WLlEwEeQSsc5aMFsTlUXfM06CvglX5LiJISJ5YRRQp5r9qkYblan7WP0if6PaKoH31XIkiZnAF4DMoZfuk9Ndg0DGqD+llJk1okn5ffv8v6foUKryXB58O/sJM1eIPyDwOnWCY4Y88M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728057491; c=relaxed/simple;
	bh=HWGViDOQRtvE03XV98m1bwgXILGc5l07x+W+qORtMAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JNA045RDDwknpSHClCCkOGHj52uPPnNMwKjMMlbjAdXowakzvOZGMJk3WBrFPByXrA1odcDtCgeQ3bnYhCCN7oRP0C/ab+/5EsTmoc9oeAd4bX+1Kk/huFLdVgHvJyivw3kQpiV4wRWfd+dsU1sXBYIGQD+67lxN85d0/ixTxws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d1z6+7Dv; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d1z6+7Dv"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fac60ab585so25898491fa.0
        for <kvmarm@lists.linux.dev>; Fri, 04 Oct 2024 08:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728057488; x=1728662288; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HWGViDOQRtvE03XV98m1bwgXILGc5l07x+W+qORtMAQ=;
        b=d1z6+7DvV0YwpLpIQZo1JWPvXi7cZUM1e9VMt23SruHJZ/0tUt1rd+6oFpJtIRJIFh
         xDIhu3lcUPJj/4XzAZsLqxspEuinF/8HyVOxGjVt8KNT1HWZc/0eiFA4YhIgbRMe3Z1C
         zYJk0rqnccvjZPGebMxj64GbWzadQ7WTk9537dzYZBm6f8ZQnb3PQCdbFc0AwlMM5Nh0
         JN+imrWZ3zNQp3D9lJAW/CHzNTdeQRbGcv2nqdDbOec2ZxgvaQbF6F7T6n8aFnYF8Jfd
         2I3iEikw45q4YF2Df/gIv2dXpXuO8d7s1GktSCvmxVzvOQ/iNmAvxMI8XUMmlde6aRQV
         bB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728057488; x=1728662288;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HWGViDOQRtvE03XV98m1bwgXILGc5l07x+W+qORtMAQ=;
        b=p6NRrJO2nZg/066UvaOyi7/idCE7UYSXMVP/YuuKLZqLeIG5RsxoSjpLZoRTxKE8ae
         QTPIGdUGpRRJHTjv1OrSIdZCFZ+5JATdLCY3JId6B5N6fF03h9uQHzQaZiLlHB/OqkOo
         kcqOHbNpX7E62stxeqthHMNipiLZQVdEV78ZXf17o+ymG7tv96XFhA8z/SzofgE5ATTy
         iZrgytgo19YUYFlHP/NGBYbVx+Ot9/3zmtsmuvwatHXpMMfl0VuvoVmny0XmRB3hTZG6
         tNBR27QlIgZYM3AzKKRGxyziabEzohNQm0/SLE+OyvvY6qOuTefFjhZkNGfvUx7hs0Y4
         I+rQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYwYN2Hc7k8wLecnZIkOk75xYhObUbLSzeqSUH3CUuAtl/6orh6WebZ6iFhjeNybTn4jTW5do=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHYoDHP+MGPSv/uh8HqGiXHDGoNVfQDuEzK/eCGByDOuMAva1M
	Vp0YuzCy/dSRXRSDyHDFkIG+mfHHKIUN6+eTlLAWU2CiRISbe4Twu+lNZb3OmAQ55jNmuT0fSv5
	0VfPyVlMyCpgN7SLQK3eR9pPSaVGUNkkb6CzGwQ==
X-Google-Smtp-Source: AGHT+IE6D/ytJI1XEuL5RjuLmHf7kTMpHr2stdM6cvQcL3VbC95ix/TXwe9hvfiPDKge6XKhF4GO1QqzUMMpBNOmpEg=
X-Received: by 2002:a2e:e1a:0:b0:2fa:c57a:3b1c with SMTP id
 38308e7fff4ca-2faf3c63ed4mr17625661fa.17.1728057487436; Fri, 04 Oct 2024
 08:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de> <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
 <ZwAPWc-v9GhMbERF@linux.dev>
In-Reply-To: <ZwAPWc-v9GhMbERF@linux.dev>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 4 Oct 2024 16:57:56 +0100
Message-ID: <CAFEAcA9bnJR__3v2ixjjEyQD+Kwz4oR9+HO=w8u6JsVjgnXE2w@mail.gmail.com>
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO address
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ahmad Fatoum <a.fatoum@pengutronix.de>, qemu-arm@nongnu.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, Pengutronix Kernel Team <kernel@pengutronix.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Oct 2024 at 16:53, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Fri, Oct 04, 2024 at 01:10:48PM +0100, Peter Maydell wrote:
> > On Fri, 4 Oct 2024 at 12:51, Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> > > > Strictly speaking this is a missing feature in KVM (in an
> > > > ideal world it would let you do MMIO with any instruction
> > > > that you could use on real hardware).
> > >
> > > I assume that's because KVM doesn't want to handle interruptions
> > > in the middle of such "composite" instructions?
> >
> > It's because with the ISV=1 information in the ESR_EL2,
> > KVM has everything it needs to emulate the load/store:
> > it has the affected register number, the data width, etc. When
> > ISV is 0, simulating the load/store would require KVM
> > to load the actual instruction word, decode it to figure
> > out what kind of load/store it was, and then emulate
> > its behaviour. The instruction decode would be complicated
> > and if done in the kernel would increase the attack surface
> > exposed to the guest.
>
> On top of that, the only way to 'safely' fetch the instruction would be
> to pause all vCPUs in the VM to prevent the guest from remapping the
> address space behind either KVM or the VMM's back.

Do we actually care about that, though? If the guest does
that isn't it equivalent to a hardware CPU happening to
fetch the insn just-after a remapping rather than just-before?
If you decode the insn and it's not a store you could just
restart the guest...

thanks
-- PMM
