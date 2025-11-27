Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF53632AAC4
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764256025; cv=none; b=n7LmDBBAGnvmwBPl/nQ8CsF75nbfExqYbJ5yS3gaFfFt6o51J8NDoTSTbmhvc9USgLowLcE9javLbgXeCS8YyWkIQ++s/dFG9n9NW+RwPtWzxRg9g2yaPpcnVqKmBdFUUiLzP9c2nPb3kvjcZQkG/82J9fLAgWX7j7g3JExPq70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764256025; c=relaxed/simple;
	bh=O3Jl0TedBRVRfVhZgOJdrLKqQHfxK+5HmiN/P10lDXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aFkJpw3HGDo1UJAygotll0ELG1syRrWC4endvA5l4l33W+sQc6idwaU0L91avvdv1hHi1vHPBkuF94UKLeOH0KnRNLdHEO4pXh3IRlHrxTcVzq0yO1VWBTRvqVM3Mjcs+oBSfscDI6ATsv/R2hP3A0c/d2OoMntDwsKIZAjYhyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WAd70L0o; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WAd70L0o"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6430834244aso725824d50.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 07:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764256023; x=1764860823; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o9j9JckZewB0T/evvAwAYflbY/oMjYUWYlwvg8R/JAM=;
        b=WAd70L0oPj9dbUOPKJ2EoY4rYCNTSBmilcWc4c4fWP4F7rtUfkAi+doPHoQ/JxXtwW
         toofWb2CaP9NB+GHYK2aiq0MB7CPvz9aMermWRykbuvCHdsL4WZRQxVawWm9wAy6pOqL
         37oKGxbqWC4skmypI69m4b5dtcMBcrS8lyiskPdmUbXIFn/KDikspGjfeQTR1sQGHQwg
         MCOF5r2H9mfvoP3zRbKd52YI1MM+ol21emDh3ppVUyQj6B5E6pBw/L5jkCYE0BDKS088
         PrDMV3/95x1YceC5tn6X8X5i7pzz6O5wN0oc/nk/jjo8nlUoBtBjS8DBePx7r7BdJFhI
         /6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764256023; x=1764860823;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9j9JckZewB0T/evvAwAYflbY/oMjYUWYlwvg8R/JAM=;
        b=nExzI7mabLlj4ehzgNUzo85Uq41PH56dAUADn3ssZB47bfqwJ0W9pRyVI9KaSHoDQG
         D2oZcFWyuaHYzVcwnYvA35DBGHeQNA5dQ4Qp4AZ5816w2+MEeIp+Cw18wCFyjEJg3XlF
         ZhO8Vw9wDo3XGJTKzd/YnijcfcG3mkAyo1QC89AqmiQxrirgXmer2XVTonJj0glJSz9U
         wN7sDCfv7vto7deMUWtTYyR6gr9/0+O0d6hBDX8RAGMlUlGIWYuQsxUVmVmST/7XzNtV
         3Th6xngoEY6cUwehM8Va1XzdFcS4DwU/ILDwO91VHel1aObwbsKBXG2LKLIE6L6BaWDd
         8I6g==
X-Forwarded-Encrypted: i=1; AJvYcCVx+pUo20GJwZ1C6HDJpuHRux0uGl347Vt40+xDXhTapXK6LYQ27/g67eHh3VfYS30aJmlM2bo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUC4Q6nxie2bQcOSyjWqxVBmSSKgW3ce9AaZ85qGWOseK1yNwQ
	gJcUHDwUNIFcWiv6bi0umgnLEywR9w9OhHgRGsEu0fxgc8sCDXA8xjRBwexIsMEZaY9zldHqfaP
	I0jwnkFYQXZIbKvGl66kmsQiM/I4Qs1YS5/fxjZSzfg==
X-Gm-Gg: ASbGncuHp+cxe3NohPOF78PhC7jeZbvvNhx3ODubUv89Su0+PpHqW1oDO5KDMbl18zq
	+LVWxizyW9S+43D5MXLzF8Jpv41RjCetxtrvQ4RBV1Q3z5EVBfhE+CHsh+5L5CsbBewZpGH58Im
	xIC/Bc5MlpIZtmbmmWjTym1QQZAo74z4tvamlK/q2u8Qsj0roSAq7FP1QHa9VQCwCNVajyedLjb
	4zq7ijPM1CEyayK5pKS0Oh8GtG2AQ3ymL3OnLjuPA4tcjDqbXA/xWe9RCB40RziCAVfMMFr
X-Google-Smtp-Source: AGHT+IHOZv1XVUaCpJ1GafgJ+Q4ufaODDINZzVe7OUjEEvUjTH0ObsXn/Gn7AJqtRSZdFMpWXb50BEdfVotDE3qezIw=
X-Received: by 2002:a05:690e:1581:10b0:641:f5bc:68d3 with SMTP id
 956f58d0204a3-6432940d24amr6552660d50.80.1764256022644; Thu, 27 Nov 2025
 07:07:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902-kvm-arm64-sme-v8-0-2cb2199c656c@kernel.org>
 <20250902-kvm-arm64-sme-v8-11-2cb2199c656c@kernel.org> <CAFEAcA_GJ7gzn7aMCZYxHnJWvx4tHSHBKsOxtQ7NTb4gPjkMJQ@mail.gmail.com>
 <df712591-397e-422b-b9c9-fbf080cad9aa@sirena.org.uk>
In-Reply-To: <df712591-397e-422b-b9c9-fbf080cad9aa@sirena.org.uk>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 27 Nov 2025 15:06:50 +0000
X-Gm-Features: AWmQ_blQNCtlqrFl6oR-29ayIeVzxjSMrcpdxqL32ABrh38kpa7m6Xz9ardxRBI
Message-ID: <CAFEAcA8LGwm-6JEhtKTq1E_da-T=H-aBX9-8LMJOAQpK5J+NfQ@mail.gmail.com>
Subject: Re: [PATCH v8 11/29] KVM: arm64: Document the KVM ABI for SME
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 24 Nov 2025 at 20:13, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Nov 24, 2025 at 03:48:06PM +0000, Peter Maydell wrote:
> > On Tue, 2 Sept 2025 at 12:45, Mark Brown <broonie@kernel.org> wrote:
>
> > > SME, the Scalable Matrix Extension, is an arm64 extension which adds
> > > support for matrix operations, with core concepts patterned after SVE.
>
> > I haven't actually tried writing any code that uses this proposed
> > ABI, but mostly it looks OK to me. I have a few nits below, but
> > my main concern is the bits of text that say (or seem to say --
> > maybe I'm misinterpreting them) that various parts of how userspace
> > accesses the guest state (e.g. the fp regs) depend on the current
> > state of the vcpu, rather than being only a function of how the
> > vcpu was configured. That seems to me like it's unnecessarily awkward.
> > (More detail below.)
>
> That was deliberate and I agree it is awkward, it was introduced as a
> result of earlier review comments.  I had originally implemented an ABI
> where the VL for the vector registers was the maximum of the SVE and SME
> VLs but the feedback was that the ABI should instead follow what the
> architecture does with the vector length and potentially presence of the
> vector registers depending on the current streaming mode configuration.
> It sounds like you would prefer something more like what was there
> originally?

Yes, that's what I would prefer. The "varies by current CPU state"
approach seems to me to be not the way we do things right now,
and to be awkward for the VMM side, so it ought to have a really
strong justification for why we need it.

Generally the VMM doesn't care about the actual current state of the
CPU, it just wants all the data (e.g. to send for migration). We don't
make the current SVE accessors change based on what the current SVE
vq length is or whether the guest has set the SVE enable bits -- we
have "if the vcpu supports SVE at all, data is always accessed via
the SVE accessors, and it's always the max_vq length, regardless of
how the vcpu has set its current vq length".

What's the benefit of making the way KVM exposes the data
bounce around based on the current CPU state? Does that
make things easier for the kernel internally?

-- PMM
