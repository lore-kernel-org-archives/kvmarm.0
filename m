Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0A513C67C
	for <kvmarm@lists.linux.dev>; Fri,  1 Nov 2024 16:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730477807; cv=none; b=DLBLQ4xlGBhCFbcFciCAbbUJ7IoKjTyEJXPR/WFd7SnzqpBynGm9OJGVNwvU/K3UU9UkBiPEpDSUylECDdR0vADdNCziWtB8etVj43ZHYGylk3VVMfLDU+SXD9bAIfdZxQJL7FT8RVCVjOZf3+j7Vs60q+q5YdvEXVaKhvbIqF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730477807; c=relaxed/simple;
	bh=xaLPiV2P+iFOGORP3GmSsCXQJJWWFEtG1+56r8fgQQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fCJN48khljcmXwMZTjwmKsp0kx7JSqtWDefDRdznF1L8yJuwEL8k/pQ7Svfovci6cx+MdRDU1Jf5XNwOpVGaqPIW2QwEvSn7JsHk7IHYgwsQdlV70+fHT8bBRfrIB1HvFZZD9QbfJbCb4C/S6VvP3bZl4iDoRkBcP9rgAPExu2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkUZiinz; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkUZiinz"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30ceaa5feeso3871041276.2
        for <kvmarm@lists.linux.dev>; Fri, 01 Nov 2024 09:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730477804; x=1731082604; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hX5tyyhHqv16hXch1rLN0W0q9yFTn7ruBymiSqraZAY=;
        b=DkUZiinzkvi7P4QSdqSZS/aSul7Lts2vDmxarLYj7dsxvQ4m74ciuM/lrKIFLy21vB
         6eYXT9SViRJajAW883C0UQatfKY+FEMx4oF8YxF1EKLB7mW1vlJfQNqrgyi2yN6f4aP9
         s5v3hUmzPcMDuShZr43gpDHBXvyWpMZmZipHvfqvEIfN73Mns5BlSwiWbSquGN88duYw
         ZbJf8ij+Wgyw0Fnbl/guzoIH3IdI+YZYV1jQB1PVAJAf08JY2sPtpSe1IjlXbr50Tr+T
         dA0KdX1NbW/k3xk1JMz08FGeDyMwz2IvZDBrfdNGfi6ytgf/K6am3noTRS6FdGR+kqZk
         r0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730477804; x=1731082604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hX5tyyhHqv16hXch1rLN0W0q9yFTn7ruBymiSqraZAY=;
        b=O8JaHMQPBgLkNupmXGes5D5UD/teGygcFf3xDqN22thRrHhCAp+Non9pbp9fdTOjWV
         V53lt8VJKWSckxIxiFi6yp9PJkT2HiYWE7Qx+vA9Wz6D1Q8MznBcizdwZ3RUT/fCatkF
         /mIniAq9JM/drbdGn60PavLzdQdeqPEPFVveNVQJvFeBsggaACfG6ncEY/OyQLiNvvRd
         Gl0wCqdtfUFNQNPM20MtXJKGCF2Tb0WHQr60Sbk7IAjPVP2OnWEEh/haPiQofPfl8F+X
         x/UaeGrdHYSHSnLp8iM7rcJbtTVBGZCaFs4OSgND7ZO8QhSM+Tou2KvMUNC4ww2p8gnO
         jQRA==
X-Forwarded-Encrypted: i=1; AJvYcCUvObx3kMbwfPSjGBKOP/fIqRil4KE+7HzSwd0I254ci6oJYxTWLfA45Ra0JIg3XxxTCaPvB0I=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGgC4KsVxtOY3CDzMeUCHGY38c5Q8McnUjJnDZHc3IjpV8fAtO
	ThPnxfMdaf5DsIVU0b2rhjZjkmiH2laB2L88qWmSyt1mr1sAdP8pKQT+2gXnvxlJ9bsI9k5VzkN
	n/w==
X-Google-Smtp-Source: AGHT+IFqadUfHcDo1fnNxpX1VCp4eu6teKzEJN9syL1uwq8yv7xcjwbZMF7JDB8DnbLfXveA32Uk5MCvzSo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b2a5:0:b0:e30:dccd:9aaa with SMTP id
 3f1490d57ef6-e3302686a1fmr4471276.6.1730477804134; Fri, 01 Nov 2024 09:16:44
 -0700 (PDT)
Date: Fri, 1 Nov 2024 09:16:42 -0700
In-Reply-To: <ZyT9rSnLcDWkWoL_@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk> <ZyTpwwm0s89iU9Pk@google.com>
 <ZyT2CB6zodtbWEI9@linux.dev> <ZyT61FF0-g8gKZfc@google.com> <ZyT9rSnLcDWkWoL_@linux.dev>
Message-ID: <ZyT-6iCNlA1VSAV3@google.com>
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Mark Brown <broonie@kernel.org>, Marc Zyngier <maz@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 01, 2024, Oliver Upton wrote:
> On Fri, Nov 01, 2024 at 08:59:16AM -0700, Sean Christopherson wrote:
> > > Can you instead just push out a topic branch and let the affected
> > > maintainers deal with it? This is the usual way we handle conflicts
> > > between trees...
> > 
> > That'd work too, but as you note below, doing that now throws a wrench in things
> > because essentially all arch maintainers would need merge that topic branch,
> > otherwise linux-next would end up in the same state.
> 
> TBH, I'm quite happy with that. Recent history has not been particularly
> convinincing to me that folks are actually testing arm64, let alone
> compiling for it when applying selftests patches.

FWIW, I did compile all patches on all KVM architectures, including selftests.
But my base obviously didn't include the kvm-arm64 branch :-/

One thing I'll add to my workflow would be to do a local merge (and smoke test)
of linux-next into kvm-x86 next before pushing it out.  This isn't the only snafu
this cycle where such a sanity check would have saved me and others a bit of pain.

https://lore.kernel.org/all/20241101153857.GAZyT2EdLXKs7ZmDFx@fat_crate.local
