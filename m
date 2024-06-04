Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8876A1311A1
	for <kvmarm@lists.linux.dev>; Tue,  4 Jun 2024 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717516326; cv=none; b=fNablLuHjsnYECdQISIMzYHKv8Har1RGy0swq4SvrpVlgTlOWi+0hHSXrdZveJ7gMp7s+e7gcTkckyS9CXQ9hr/0iUKzjukBVOS08J3W7oGwtp+T9ZXcXJTkl5ZuhzWjAenGrNeL3FL7ezN/bb7kJnvEaghhhqnmBw0zhfxwxIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717516326; c=relaxed/simple;
	bh=qHT2E9JXlk7ttnLty3NOuDY9aR5M7vuQyAQ1ZVNDrjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdA5hILPGYJ/GjLeUm7QI7JJhW3C0jBfZegZnh9d8zhVga/g5iVBREuxc9/Zo4J+eQq3/D0YLWrjZ/Ng3xz5xmCUZp9lY35PckXL5VrcYvAcHezwIxmBwHkrwrMNtupNC1mEdywkgmlGT8rKTM4SmNb5OwhqoBX6iSkH4Lv2kIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AiOnK8Zs; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AiOnK8Zs"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57a4ea8058bso3869505a12.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Jun 2024 08:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717516323; x=1718121123; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2gcc4iBvvKpaM1N8hUMKIuorK0dH13+qzLOax+XEG0o=;
        b=AiOnK8ZsADJ6xMBZz7MF5MZeBy0le2taJyr33cz/96xo4iA8mCkqLE5CJfk6KFzgX+
         Wil8ZtsLbqpYb3yLfIe67hoSBzNknH1QI+Ekx2SsfQmkI9iAyGAkaG4vG+TPF85UtBUQ
         yHy47Jg3+NI+CxR7dETbEqX1pv304TLV+5aAtLskXXlybTsJ7k9eukYUgeUyIKEtHDcf
         65zh7diTQvdC46lgvqK0sE338+wAqVgUAo21dnt+9hHa5fxJCTFUH1DD7OlZMlxZeC+t
         bojnbHFwcGE5h4BtiIGNQ4VtTCcHHhKeUBEdLivtJcGQJnVohfQDZ/u5hHdi7jsp4UxQ
         NKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717516323; x=1718121123;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gcc4iBvvKpaM1N8hUMKIuorK0dH13+qzLOax+XEG0o=;
        b=OK0WdHhNFV0CRY5pfoMJW7efQjLqkmxJlvGOisxJw5W0Rg9FW3bcDcBMolWE6oHGf7
         lZLosHj7WuwLtMAxQYACBeN8PQPjvC/a6JqzJSL3JAQpQhEsgqOTL6zlYX7EtxX4nKx6
         S+1KSx1hZg18frRz16y90aTN+MlSBfPj/QKYSMBqJoHYZu5qH5fBFLSQ+cMjaroVfUIc
         HtTKsRgmlaW9uHicKutzIF4KFsc3wmCGO5+aGxKM0vGgaPkgvuNzdQkfmMa1xn1EhpmS
         P3k5nifWBykXE9T7xLWn5KwiGgLnrDaA/YQVYfVZZq3BBfjgDfa3PtExOJd4RD1NEK+E
         8xyA==
X-Gm-Message-State: AOJu0YzW80jP/ZpwciuPFPRMIOQtYgtf79zjWTEwNghuMFzEfpuyYSVQ
	hlhNyCeWZDtXBcT9/8YQRCfX9D0BH6y1URVCgMITuPtWuAfKAkyG8vK3rmMvyC0p671gx8gIrWE
	ZG+YN
X-Google-Smtp-Source: AGHT+IGfAzZJvUYrriUlHKJNvDU27Rn35hs0ZzZeAmqXl6qtysMyyKnUKZDq6C0qJc0XLrKnJiGBjQ==
X-Received: by 2002:a17:906:c0ce:b0:a68:b3e9:b364 with SMTP id a640c23a62f3a-a68b3e9b466mr587701166b.75.1717516322613;
        Tue, 04 Jun 2024 08:52:02 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68f39b9294sm391487466b.180.2024.06.04.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 08:52:01 -0700 (PDT)
Date: Tue, 4 Jun 2024 16:51:58 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 05/13] KVM: arm64: Rename __guest_exit_panic
 __hyp_panic
Message-ID: <42h74rlklrenekak6dzl6mpi2b37peir6o55tnawvvf3kt6idn@53svu2uxcxk5>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-6-ptosi@google.com>
 <20240603143424.GF19151@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240603143424.GF19151@willie-the-truck>

On Mon, Jun 03, 2024 at 03:34:24PM +0100, Will Deacon wrote:
> On Wed, May 29, 2024 at 01:12:11PM +0100, Pierre-Clément Tosi wrote:
> > Use a name that expresses the fact that the routine might not exit
> > through the guest but will always (directly or indirectly) end up
> > executing hyp_panic().
> > 
> > Use CPU_LR_OFFSET to clarify that the routine returns to hyp_panic().
> > 
> > Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> > ---
> >  arch/arm64/kvm/hyp/entry.S              | 6 +++---
> >  arch/arm64/kvm/hyp/hyp-entry.S          | 2 +-
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
> >  arch/arm64/kvm/hyp/nvhe/host.S          | 4 ++--
> >  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> Hmm, I'm not sure about this. When is __guest_exit_panic() called outside
> of guest context?

AFAICT, it is also called from

- the early __kvm_hyp_host_vector, installed by cpu_hyp_init_context()
- the flavors of __kvm_hyp_vector, installed by cpu_hyp_init_features()

which start handling exceptions long before the first guest can even be spawned.
Hence __guest_exit_panic() needing to validate the context on entry.

I don't get why those handlers didn't branch directly to hyp_panic() (perhaps to
have a more robust flow?) but, as mentioned in [1], it is convenient for kCFI to
be able to intercept all panic paths for sync exception from a single place.

[1]: https://lore.kernel.org/kvm/qob5gnca2nte4ggkrnn4uil5mfbkz3p55lmk3egpxstnumixfr@lq7xomrhf6za/
