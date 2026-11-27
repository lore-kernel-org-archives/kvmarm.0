Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795796632;
	b=GbLlgBWst2Lx60k4BXDLpNxgU9m36txRjvdsR6bC+Q+onl2iY7Vn4pVpbdP6RUIEzcFw
	 LYymbsA2ljRJQDfvRdRYJ/PQSrWbX8Eu6VT/P9y0bMpspvXkgYTnxZOM9OTRiUI2fCNdI
	 NTCnLpzNdI5WVHVkI19vIQyyNAR9Etx6jJ5srfgZILEXnixla0e6MTOZNmLiDm8huzjZe
	 sCeskObLCTk/s58z7DDI515Lx89vt6Qs1O/Ed8E2F5UKPDjkHL28mkuMi2JP+DjQmMYL5
	 QDVBkos6STrnygPzzTy6wzwoYPx+kIjUNa/hOXH739pfRgA7VhLBe/PnBLuL5YeCBrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795796632;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=iUOkhTViorBjXwVMNoDQvsI3GOnGrmqio/YBI7cO2Uk=;
	b=bHNPuuhtYCmu972lY9kbNVar5nlhWN42JXnKB6TVu5KAJ8MxsET5/ebQMZoqcx9ClX4O
	 oSFxrnyZ41PvYmCPDEpY0SxQZiLLD8eDtnODbvMeJr61SMjtvhWuSSjg9Ma49C2BWZAoy
	 vbSRcQuu7NXp1g03Ts0/vKdQpC8+PReH/dHVVMbu/Pdt32z67BEri1aSv+ttlR+vn4F8z
	 JbmBFFfUBhZG7Sw1jsPClllHt5g0BvBdySu9vjZE28p0bJ1yhdZ4VlbD/0m+mDMQmqwrk
	 JJEnG2t0DVdGwV+FZuCyg2YhEuim2TPPEaTe5Dqk/Z1sFCENpN3kdQPgtwdDyzPPvTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=EIHqfEh3;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE670606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 16:23:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE670606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=EIHqfEh3
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4a5024b3c28so5329532f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 08:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795796630; x=1796401430; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iUOkhTViorBjXwVMNoDQvsI3GOnGrmqio/YBI7cO2Uk=;
        b=EIHqfEh3zAieaIyHMBK55KaExyZuVnegDiiLJAn4JpelaYrxD4ST0jv/LDiihagM/s
         O28nrGxpN1AEINPL58iBmo2mOLe2Ygit+Qe9KelKXBkMdjPp7rXTXV0TyikLK/nNWCnk
         E+yhV5bqd8dhufl2gM+5JPHzeQjH3Ct0YJqh5L57fck8+iHRNyTXY/BaiWdvy7hD01Lw
         U2/n3RpL8ID1HTF/il9JC1BXu9LAd06Ze0a2EbTTdc7S7LQwS2Qh7iT6ps1+l6YFw6gn
         2irhqzCy77a9rf577oEBxzteNDeXOskUxM1jzzOYVDXEs/RQjEit/s5fqc0YZYKFJIKH
         X/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795796630; x=1796401430;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iUOkhTViorBjXwVMNoDQvsI3GOnGrmqio/YBI7cO2Uk=;
        b=AAMHh75dD/fUB2/Nluw/9S61QVdZRxAqmdiNs+V7NzdqV7ej7hj9ZYID9Bqs+cwFGF
         SoQNgxF9t5sml5B1pNzFy6Y/3Ovd16GOqNWrLRThqd+/Buqd2GdzuxIzhT6vBuw6AzOe
         GnXxHBzxMVCNhRgs1elLOejQoY0eUTLMCj73ksIX5i71vyoxsZDIXxW0iIP1et5NWgfF
         nB+2BHaaSX78AbnZQlxXDjt0aCnTjjIJMaT50b26olmRGMFrYVfYbXNTeiM4egSxgFyu
         +mJP/ZY4ozWqgmpbZfHgOKzKweoVCAxPRyLDaRcg4f/L0bt/5BDiv8kMDACh90OcXk+Z
         2jrw==
X-Forwarded-Encrypted: i=1; AL+hErFO83hjBcCOwuCd+Zc+vz9HEGybqqYlw7HcvDW5gcf/CvjbZycEIKN/KXT1yedfB93LC1vN0/A=@lists.linux.dev
X-Gm-Message-State: APuU4Z9QPrxSMhqU8uN3ufwBPqkN0jV6TiMwppQG64BJLbGxIe7qFWyS
	l1rPUBmLAXpbt0FHg0JeNvbRZsJ/OlgVKzJw5ZHxad9ylFxgNDbevfozZWiUirBH+oo=
X-Gm-Gg: AZFdTZe4Qwm89GKccFk0WrMbhDPfhx+XkPw27QEiDxEKHbby2f3z8FKjz24qnKFg5jI
	55a0cEf2hwFTqOTDXPTvheok9Byr4YOuVgcwzT+dkeMthCZtyPyrmj4f0LiIg+MkoICAu12hi4l
	QMFD2r/8LvMtRGdY2GlKwi0vvDupBD1v1MRucSqt3h4WGZ6lPvaGFUxo2F10p4EMJKyyXt/loq3
	NSrx/6zaB1qf1m30MDTvIX96tgzGLnpXVGH+VrsAfAq/FV1UwSyVBkiRWH+LbdIEYuqNmS+3Int
	Nk3cxigQmTD979PPXLIYa3TKtkS59/PhqfWPkuuOqIcJCdX55M9OtE+i7KTbDP0bo0W6BW0PIci
	DdvnxGccJOzvPHUTtjmzGId3ENbLk/nrg30Rc8n2bogwx2wMrihlrMlsM3rWm/opQ0VGR1IJgd0
	e0g6fHFLydAqFk+tKl7vtI4rIN06Lcupw/bPfbdxC+y5loog7hbtgYCJvdHEknxWZKveEHkdetU
	99VO3spP+ibJs7iEzZiqJxCO0FNXRSXA5AwzO9W9XRz6dYXQSf9Ou7TRUd70QFEUFvZ9T6ezmB+
	upoEWXQqhFWTIB7yCAw=
X-Received: by 2002:a05:6000:2992:10b0:492:b1c5:6db6 with SMTP id ffacd0b85a97d-4abafd034aamr36481249f8f.6.1795796629954;
        Fri, 27 Nov 2026 08:23:49 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b9add26sm48569879f8f.44.2026.11.27.08.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 08:23:49 -0800 (PST)
Date: Fri, 27 Nov 2026 19:23:46 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting an
 unmasked SError
Message-ID: <awmukv2SwxTt6l9s@stanley.mountain>
References: <20261125-serror-drop-mmio-v1-1-48076f59608c@pereq.eu>
 <CA+EHjTwi=nFyBKKT_beb60DHU8N98yGQsNHcFRSdc3Vcu7D24w@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwi=nFyBKKT_beb60DHU8N98yGQsNHcFRSdc3Vcu7D24w@mail.gmail.com>

On Wed, Nov 25, 2026 at 01:52:53PM +0000, Fuad Tabba wrote:
> Hi Dan,
> 
> On Wed, 25 Nov 2026 12:26:47 +0000, Dan Carpenter <dan@pereq.eu> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> > index 1d5dfd4b9e00..91b835bc939b 100644
> [...]
> > @@ -396,6 +396,14 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr)
> >                  return 1;
> >          }
> >
> > +        /*
> > +         * Like the emulated entry above, an unmasked SError cancels the MMIO
> > +         * access the vcpu exited on.  The host's copy of a protected vcpu's
> > +         * PSTATE is stale so checking serror_is_masked() doesn't make sense.
> > +         */
> > +        if (!vcpu_is_protected(vcpu) && !serror_is_masked(vcpu))
> > +                vcpu->mmio_needed = false;
> 
> Could you check PSTATE.A directly instead of calling
> serror_is_masked()? That helper treats SCTLR2_EL1.NMEA=1 as unmasked,
> but NMEA doesn't affect a virtual SError. With NMEA and PSTATE.A both
> set, the patch would drop the access while the SError stays pending.
> 
> Checking PSTATE.A also covers protected vCPUs, since EL2 always sets A
> in the host's copy of a protected vCPU's PSTATE (pvm_host_pstate()).
> You can then drop the vcpu_is_protected() check. Something like:
> 
>         if (!(*vcpu_cpsr(vcpu) & PSR_A_BIT))
>                 vcpu->mmio_needed = false;
> 

That obviously works.  I'll send it.  I wonder if it would be prettier
inside a wrapper like if (!vserror_is_masked(vcpu)) instead?

regards,
dan carpenter


