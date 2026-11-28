Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795856401;
	b=EG9ptulPcHZ1H+f0AZx3NnRe1qMgfMIED8DaZQkUGq1RTH9MgU25wnakjkxKQH7JEcVQ
	 W740bfJmmNfUJe8LpqLOa5PA01VmhetvWsn5h6lG1GA6FPt4jiHpq1FtIJsRBNQ5ajL2E
	 lW+o+RKSLNQDdBj1mbzgSJft6A9Xfd9h7uv/MNYnL44nIYfwmY3m/R/eYfotPO2qzN9mU
	 wbEisuDEAWpV0XIihr+VKSABQsuBn6eK+qVQtaeXr2vEKyxo+9Vh8FXweKtJ78abIv/XT
	 AekWZfPYhoX7EyU2wM0WyTwIt3c2ilFa5UMp7JFoAeW8RnW6Sjpg/9kF7a7rQdkCarw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795856401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=kEewjSJ+qkb+HSBfq+Qd57sW1mHjYvam4i7pnFyYkws=;
	b=2YEjRR1Y/VA1VhgoK6Q1ThSJzMTSIho6IhSlNT/1sZExMbcR5Vem0luCVlRVYXQi8rvZ
	 6qa7TrZ9hnu97kaWBv9MYZ9VgfMksU64BIvilfO7PakRMai1TQuxTs48heCaMmvTI4hIV
	 GrRy1J+eioFQC1d5/7ajsnokxLiPH+KBA9XUny3fRnSNnoG0PGhWjUKm8aBv6e8zPprWi
	 HjPVal1cNcpIa/KwH65bLQNleClnxLsYfvFsZShDbo8ljkjHPjQxESB9rHh7jENlF1vgI
	 cYzasxBPn4lYABd/1l5s1ptDa1RQ//j3HiF6tfcNwLsJamy3bEUIW3C4EzoDcNtpLFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=KVMl+Wpe;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6855606A31F
	for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 09:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6855606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=KVMl+Wpe
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4a357b1c649so5066724f8f.3
        for <kvmarm@lists.linux.dev>; Sat, 28 Nov 2026 01:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795856399; x=1796461199; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kEewjSJ+qkb+HSBfq+Qd57sW1mHjYvam4i7pnFyYkws=;
        b=KVMl+Wpe7Idp3dVNjxhJaYQAvu81HCR8U/tlhqN1S18QM2NGDlePeN6nMlPVyvbv5t
         yhhh+DrIBzOT6QGR8b9ZRrLVD6zGVjiCjjRPL4REybahrTK83F8GcFh/jgvCPSSn+1xU
         IyeIjSiFGEDr2Bi2znpI8RGrvPcQ74Cd/4paS1gA369p92M+dAMWSVgpU/x/2NHYWuHo
         t9N7ENJ7ptND5usZyRuL16LGD4at19Xnpp8yLc/hE2tUx7W0hyHXbGAyA+PmUixYE9aN
         at2cvBHopJ6oiSPak8p5C8h7uV2OdOHinvlglKcH0Y/p1Twp3dK4Ga44Mr2RCXmWnmqd
         3e+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795856399; x=1796461199;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kEewjSJ+qkb+HSBfq+Qd57sW1mHjYvam4i7pnFyYkws=;
        b=MPplHLMN5W/MXlwAJcyI8wJJmYDQSs+Oy6RW1F3oXdLrRXZu0KKc9oqAKVpDGOcew3
         P1aQjYPcWy0r2+H6yQLhcA5s0Y6ao9rc8jmwRfAl8Guj5Rmo16Iqz2shAJ/0ePt9EVTF
         JR4Q0DqIdE48hgz4/AStSe8ohw281UcKzQbF/4ijUbOD3VdXAu73VQcU/vap1hvOKdyF
         OxkBe8GF5LWhIM2XdgMh36H/1gn/KE7oJclVaeASP+Rp/XFV9olrIPS3FVfnyAf0bzv1
         2sCnG2J7xLS9x1iDUHN541/1pOzN70mZiDNYNZainicUpdXcUxRkCTAKGoXlOY486z3H
         nngQ==
X-Gm-Message-State: APuU4Z9rBmklc+sZkybDnFY9rn+Aoe8fOQGcaMotBvgQVwjpH3Q7E/Jo
	/NCZzk4zKjYIW8gmNv375q998yPGs4P9p92qlGlPb3UfKytl5YJClZyV+Pi1M/X4sDU=
X-Gm-Gg: AZFdTZftYwBeUR1g45TOkWITSKZWQLXsVEgbDaPq4P6G7haLpk7HzD8C1rG7HryPw7L
	ERRgYICJPP0C/f8CJKej+1DSTMKv90lvnp5IMxsdbH0hjhnFHhadubxa4KHu5lq9B8aEHyXFJCM
	nEev4fpl2xw4lPhYrNlucuL3Ey1ybmx8EOqYmuO1rKgjUhTsZZ0hfgpLi4/yDsPC02Z3UfFxidf
	gWazr8xk5D4TkEuf3sfZ3Y6LJT+4uxIv6ybnZ8PKZxysnIfV9DiBmeOsaabOdXdruPTeUoH5HLJ
	3C8iFXDJo3L8cEDsPS1hITq0eP1F2EQEQBaduXkYyaaPEiCmoM8tRoh3dbbVYvTN0BNyPCh3P8N
	kBeOvSN47aSHJPpzkuMIGvrHGxKlNs882pq3Zy8bN9R3fItPbp0lNJ3lpF4rCFjmyfZlO+SyfnR
	KDgBlXTTMmtXGNYJ76Kn/Vs9jEhYCKI06c8gQBmzKMlcmoKGP8r/dBeDkf9uEP4SEDMzINFOUev
	OozYe23GLOLzQJsZGSdr8YiKnlGqBDqbJS6zGsJyBcYVQnMLlp6IWnVQy0O5rKaUVNnrh0Y9sr1
	PEqLC6p/2yYJgX0P0jo=
X-Received: by 2002:a05:6000:2dc5:b0:4b3:71c7:42bb with SMTP id ffacd0b85a97d-4b371c74483mr36515415f8f.19.1795856398886;
        Sat, 28 Nov 2026 00:59:58 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110c50sm51225405f8f.37.2026.11.28.00.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 00:59:58 -0800 (PST)
Date: Sat, 28 Nov 2026 11:59:54 +0300
From: Dan Carpenter <dan@pereq.eu>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH] KVM: arm64: Drop a pending MMIO access when injecting an
 unmasked SError
Message-ID: <awqYCojgJpQGnWiQ@stanley.mountain>
References: <20261127-serror-drop-mmio-v2-v1-1-96bd01bef6d8@pereq.eu>
 <sashiko-outbox-238059@kernel.org>
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
In-Reply-To: <sashiko-outbox-238059@kernel.org>

On Fri, Nov 27, 2026 at 06:14:08PM +0000, sashiko-bot@kernel.org wrote:
> > +	/*
> > +	 * Like the emulated entry above, an unmasked SError cancels the MMIO
> > +	 * access the vcpu exited on.
> > +	 */
> > +	if (!(*vcpu_cpsr(vcpu) & PSR_A_BIT))
> > +		vcpu->mmio_needed = false;
> 
> [Severity: Low]
> Does hardware deliver a virtual SError pended via HCR_EL2.VSE when
> PSTATE.A is 1 and the effective SCTLR2_ELx.NMEA bit is 1?
> 
> This rests on an architecture detail that could not be confirmed from the
> kernel source.  Earlier in this file, serror_is_masked() treats SErrors as
> unmasked when effective_sctlr2_nmea(vcpu) is set, and the NV path right
> above emulates the exception entry and clears vcpu->mmio_needed in that
> state:
> 
> arch/arm64/kvm/inject_fault.c:serror_is_masked() {
> 	return (*vcpu_cpsr(vcpu) & PSR_A_BIT) && !effective_sctlr2_nmea(vcpu);
> }
> 
> If HCR_EL2.VSE also delivers the virtual SError when PSTATE.A is 1 and
> effective SCTLR2_EL1.NMEA is 1, testing only PSR_A_BIT here leaves
> vcpu->mmio_needed set on a non-NV vCPU, so the next KVM_RUN completes the
> MMIO access and advances PC before the guest takes the SError.

Sashiko is basically saying we go back to v1.  I don't think that's true
because Fuad is the expert here and because what Fuad is saying matches
what the Specs say.

The original bug was found in testing, but truth is that I'm using Qemu
so I can't actually test the difference between v1 and v2.  I had already
added the new case to my test matrix before I sent the patch, but on my
test setup it's a skip.  I am planning to push the test after everything
is working so we will eventually see if the specs match real CPUs.

regards,
dan carpenter

