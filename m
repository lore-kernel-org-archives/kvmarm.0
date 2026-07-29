Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD774C900A
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336752; cv=none; b=APX0mnOmIuw1CMFnjG+tvajY5zfld9ZXuLYy5VZGglZROvHo6KfeEzwueixcVz1FYwi7KVDAJf8l7iuJMaB6JHYL3cv9SoqCe1w8l8AX+I/FQJ2h1ZlMEJ3lFXZk+g4P3cqny3iqhk0BDbzkXFhzgO8+Bj6jbGIE38PV/uIL0jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336752; c=relaxed/simple;
	bh=eixUchvLdNRQOC/B4OdufYEzjQkBP0NIamoZkXez1KQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IS4wZlYcFObI5JVBrnK7Okpxk9GFV3N8Ia2re4t0de2jBfLG0649e7JPvfD3wv+o26RP+kNMemRU3GS4kA9o2gRYIZI3v+W9aSJYfSgjMMzRu4Nz7xD3zcKI7f3xflmAvC/rXz0EwoFAVFSlFK/NoMYNvhYcR7Nl9nFaX22pb7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=deVeQ+Kx; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="deVeQ+Kx"
X-Forwarded-Encrypted: i=1; AHgh+RpWNWdaUgsZIbyigGmGsB80e4PrmZtfd8wgSHpy+HOVKybj9713AbUI8rouj/lKwtUTXbmVBfw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785336748;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XDalj4wabDKvXxxdpuvhrZ8sM+mh/PoM2BIg7cLyOyM=;
	b=deVeQ+KxP4BMhQ8auGoK5EascjeaFaXpcjxxPKz0pjkokBKPMHta+0W0k33yZT3DmGTV7x
	O2iGVr8YoB5zNAB+b2do2FvVAZg9Z/2T3x8CG/yH9N77e38oa9cW8nkg8yblWw2g15c6+L
	kTtsLBHGZsFjklxrxVNd0E+TyNFJGd8=
X-Gm-Message-State: AOJu0YyyXK9OTHsUUjvN/rtQzJPrEHUD5WN74NhGfIyJ7OX+9tTCCZg5
	P/lTpVbgIfUGIJaS0bC6P4SNxWkw4CAa9RGoepXZaNU/P//UGIUPUvrHrhGbZdfXsQxhdpJ4E9U
	YVnWnHjJD/ZlXx0LVTKPE1pbpprWSwxTK3XvOENuF
X-Received: by 2002:a05:622a:1312:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-52b2cc8596amr9690121cf.11.1785336736189; Wed, 29 Jul 2026
 07:52:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-3-fuad.tabba@linux.dev> <amoFnupIKfDEzN0F@e143914.arm.com>
In-Reply-To: <amoFnupIKfDEzN0F@e143914.arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 15:51:39 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzjb+LX-+C=DkXXkVLiradjHqQN8H_df1hUVk6aoT8+vg@mail.gmail.com>
X-Gm-Features: AUfX_mwhvTt4R2cSbWIXoLFDxC4tUlnWCCLFknIFzYSOsoQTGMFyW5qhd6pEU7I
Message-ID: <CA+EHjTzjb+LX-+C=DkXXkVLiradjHqQN8H_df1hUVk6aoT8+vg@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Joey,

On Wed, 29 Jul 2026 at 14:52, Joey Gouly <joey.gouly@arm.com> wrote:

...

> > +/* In nVHE hyp code, registers are always in memory: use the raw accessors. */
> > +#if defined(__KVM_NVHE_HYPERVISOR__)
> > +#define vcpu_read_sys_reg(v, r)              __vcpu_sys_reg(v, r)
> > +#define vcpu_write_sys_reg(v, x, r)  __vcpu_assign_sys_reg(v, r, x)
> > +#endif
> > +
>
> Does this make sense in arch/arm64/include/asm/kvm_host.h instead? Next
> to the definitions of __vcpu_sys_reg() etc.

It could go in kvm_host.h, but not next to __vcpu_sys_reg() as
suggested: the redirect has to come after the
vcpu_{read,write}_sys_reg() prototypes it overrides, or the nVHE
preprocessor expands the prototypes themselves. A placement that
builds has to sit below those prototypes, not next to the raw
accessors, so it wouldn't group with them the way you're suggesting
anyway.

It's currently in kvm_emulate.h, after those prototypes, which is
where Marc suggested putting it when he moved the patch off the
earlier rename [1]. I'd prefer to keep it there.

Cheers,
/fuad

[1] https://lore.kernel.org/all/86h5m1o79h.wl-maz@kernel.org/
