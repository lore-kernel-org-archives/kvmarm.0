Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC9C2882BB
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767889592; cv=pass; b=Bin0a1CX+x9XBQwauIr9WEDDS3OJYWeW2RQjTVPDzUITbGP3uzwnF/2wBH8qS+adOnsleEZd/PZNLgfpabvJl3/fO4beIImERroWhmXsQJEqOx0jz0rTa3T0Vj66UEoVh/3cl+y2j0HN1QKweEOLTjPz6rji0IGPkQyonlPuvkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767889592; c=relaxed/simple;
	bh=PQslf1nBWkAECYlPx7V6ROJBsVJ/orbrweZgGpC4pu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f0Wi8k+J4fcv3CHhDXFaRgVt7pUiHyT1jU3fgA1bR2fqdUyk+s4+xEWcYX+zGsKX8hPI5xrzFKUb61MApu+SUPx9X9euJgr9VM8nc2k/ret9QEVnoy4caNXaFVVjIOzm5afmyAmBMZwnbbf5/7K5qID7TKzCM7XCESyb4PKnDjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aN+9FsOM; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aN+9FsOM"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ffbaaafac4so827351cf.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 08:26:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767889585; cv=none;
        d=google.com; s=arc-20240605;
        b=V4ya/fr5rg2XO+UVsS2PubBbBN4KpJBXuxgkuT7Vs1fSYYyNkkOiLK3A+oY63AkW8S
         0frnRtlTLAPWq+6Y4qnec71RfD6ghkQuBfRJhNSl2Wp5UTx9NO6RJAzYo1KjnsbJXuAV
         EEjP+KCxrmrbuoDRBNVV04fotfkyGwGv29/EY6WxD6aw5atpS7hI9m9LzmFPELqsbkRv
         DU1bvcDswSJnT33tL12rN3mPWGxFv3uxAmQubnb/6ZiQ9RUfGWkbIo+L/pOnkl6g7Q9+
         EZG1AXxjp4RJp3fUckfgy7yp6zkf6OP7ToShelXeRwGJl11kz4KWaC69pNf2Nx5PdC8+
         Rc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vwmKkVXSip/S40O81aRXL9QdzJwbud5lWPyLOxwiQv8=;
        fh=fFLr3lrx2mPzz/yVWCcrV4NV0WBFaQYyKzRSSd6iS2w=;
        b=SWdDRNIjWhAc+64ONTxb7Etz/DipduGYLVyd5EWqXyQ6HHY5uXjIRSovhhxKacZLcL
         d9Cxda/oIsgv39kMsmZQ2nsv6zn0UbFvoH97F0jgsSRDzyob+4J8QfRwmO2jbpuHMXMr
         88MXZ50lNgXD54B5NhghomY3XOo4LDizAsrrNR+dM7mi0sr+Ex+dotKscLLLfh6FgR0C
         F2LWVH7wYg4GZs5eisDt/iUCxA1ry/R/iZKGH0Qtrylh6AIJIHcKjKpNS1PqTUwoS/au
         h7xVtYz9dk68hzJcBsZMSkpxlt/XXj4moEM6dQVpLifpLrCJZif7bnfRaqREQvCSAoEG
         iOiQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767889585; x=1768494385; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vwmKkVXSip/S40O81aRXL9QdzJwbud5lWPyLOxwiQv8=;
        b=aN+9FsOMsUh3io2teLNruyyfyx7mYKpRkjMbOSW/lWNMkWt2NrFGN2MQz9xnW3LKdX
         5gb6MzeZV9ArMi1ms+JiURaNtTovzs4KlbMZ0na+WokJFmqpghgPw4vKz5dz22Tp3je6
         SPhGM7NpjrLsFKA5xmp5ZEqGvpg5AJtaP0BSB9IBvg+8bbp8G427Z7oqLw7W9DPBXtpt
         Wc1W4Flw6ZtL4rHrakT0jHsPPo0+zRMu32cZMgD25XQpLkwUKbggBCqrzBheJk5ddHDc
         Z/EAJF4klRyOWidI6uAsk6FDg0ydgXINuUlYIsVxwnuFGoZLn/mzDs2N33zJqw81uKFx
         O8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767889585; x=1768494385;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwmKkVXSip/S40O81aRXL9QdzJwbud5lWPyLOxwiQv8=;
        b=BPYcJIiB1HYzVkZ2d6l/Vhb8l16O09ebaArm6i9Pbc1lrNS9OZUuV0dyH6QV6ywiT1
         MFqlPN2LcmGY8WgWJbC/oFToD4C43MMBJAngGcP02dnIu3WCKxyEL/z3a9bpRixWRbcu
         N6NkDHfD0KLtBcgymTw4S0RXJuqMlvv8ImmkPbCAHcCD0jJlXNca9D8vBUfkLhOU9Oi5
         Bba6KYiPxVkpUi46zyA9snIuZq4PLqvPMkle3VumJmLGC/bgdPe2hlE0lXzcL+VyhZad
         tHXP7nqlJnGj1s7EDBJ3RWatia2Y6oli8g3UqQjmHDSa9epUn+faT4Qd08PfhWf1PEgN
         i1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuHasFqqWjzr9muVXmQeO1JFJTR2aA2SuHGEQfPuFQANeLcoWzkrKga7LtazS1Omx3FBw6JY4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiN7wxw6+ka7OhJ37SX/JysgKVwyffkeD7FBOpvEy4sYBOEJNe
	Mk6YrN3zRV+42BElMPXJkj/jJE1F0CDRBUJQHyDHITDNd28eZ/fVxeKgFDsVx8oqlKklmtLAcNk
	n4up9LzKJ1XmlB5gCW0RDgYEfz2MswL9UHZ7/Q7Lz3yCLmDT67xwGIffj
X-Gm-Gg: AY/fxX4WgyEKEMGDgIR9A9OFU0Lq/2i8EhkUFQ0oK+XnJC/OUl2qBjBFturxMzzXV8h
	lelAmY6BYRWCJj6QRjyzLRVWnwbFRRoaTmNhGzp44y2y097E9zf9RKpZvtYeCowAUt/wqD1+QVd
	fj2TKIyRviRFWsZoM5QiEfHzRtz1k6mYR9v0a40iH45jUDFa+iFeSfUMOSPoPVLF3oiXZcEFR1Q
	LvcbX1pwp9evodAYisDIaZO9ms78pjB0dymow+BCiiOcJ54meh+N/ZSqfabABSwT2Lc2Mbq
X-Received: by 2002:ac8:6a1a:0:b0:4ff:c103:49f1 with SMTP id
 d75a77b69052e-4ffc1034cd3mr7852131cf.6.1767889212251; Thu, 08 Jan 2026
 08:20:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org>
 <20251223-kvm-arm64-sme-v9-2-8be3867cb883@kernel.org> <CA+EHjTxdSnpFHkm6o85EtjQjAWemBfcv9Oq6omWyrrMdkOuuVA@mail.gmail.com>
 <3c8b4a5e-89f4-47e0-9a5d-24399407db0c@sirena.org.uk> <CA+EHjTxLkLjPj=1vwDqROXOUXi2LhOQb90WP6dFaTiYG1nWovA@mail.gmail.com>
 <e50b4923-ee45-43de-9d4e-344546c635bb@sirena.org.uk>
In-Reply-To: <e50b4923-ee45-43de-9d4e-344546c635bb@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 16:19:34 +0000
X-Gm-Features: AQt7F2qnUAAJolhK9_-R6BxIXN3MEwPRzr3Wsfe1tbgWe2D8WrIhfrxwTrYHhW4
Message-ID: <CA+EHjTybF+aq2b2vhcEqi6U_sJjtt7ngzMZ9UcJ15G-Kqj=A9A@mail.gmail.com>
Subject: Re: [PATCH v9 02/30] arm64/fpsimd: Update FA64 and ZT0 enables when
 loading SME state
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 Jan 2026 at 15:57, Mark Brown <broonie@kernel.org> wrote:
>
> On Thu, Jan 08, 2026 at 02:09:34PM +0000, Fuad Tabba wrote:
> > On Thu, 8 Jan 2026 at 11:54, Mark Brown <broonie@kernel.org> wrote:
> > > On Wed, Jan 07, 2026 at 07:25:04PM +0000, Fuad Tabba wrote:
> > > > On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> > > > Should we also preserve the remaining old bits from SMCR_EL1, i.e.,
> > > > copy over the bits that aren't
> > > > SMCR_ELx_LEN_MASK|SMCR_ELx_FA64|SMCR_ELx_EZT0? For now they are RES0,
> > > > but that could change.
>
> > > My thinking here is that any new bits are almost certainly going to need
> > > explicit support (like with the addition of ZT0) and that copying them
> > > forward without understanding is more likely to lead to a bug like
> > > exposing state we didn't mean to than clearing them will.
>
> > I understand the 'secure by default' intent for enable bits, but I'm
> > concerned that this implementation changes the current behavior of the
> > host kernel, which isn't mentioned in the commit message. Previously,
> > both the feature enablement code (cpu_enable_fa64) and the vector
> > length setting code (sme_set_vq/write_vl) performed a RMW, preserving
> > existing bits in SMCR_EL1. This new macro zeroes out any bits not
> > explicitly tracked here.
>
> The behaviour is unchanged since we're always choosing the same value in
> the end, it's just a question of rearranging when do it which is the
> explicit goal of the change.  There won't be a change in behaviour until
> later on in the series when we start potentially choosing other settings
> for KVM guests.
>
> > In terms of copying them over, if they were set from the beginning,
> > doesn't that mean that that explicit support was already added?
>
> That's a bit circular, with the new interface if someone updates the
> kernel to set some new bits they're going to have to update this code as
> part of that.  A part of the goal here is to make it harder to make a
> mistake with remembering what needs to be updatd when.

Fair point. If the intent is to enforce a strict known state and force
updates here when new features are added, that makes sense.

Would it be worth adding a comment above the macro noting this
difference from sve_cond_update_zcr_vq()? Something along the lines of
'Intentionally overwrites to ensure strict control of enable bits', to
save future readers from getting confused...

Thanks,
/fuad
