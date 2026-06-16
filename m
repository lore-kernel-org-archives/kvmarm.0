Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46447423A77
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 09:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781603955; cv=none; b=WRruLrb+71lCQHnx2QEQSd61SM+vYSZtxwItMe69B1G0ic4PWNQWV78whxkswOA3x2q7L8KVUbghtiu4XIRu1Yma6ocjQKqniYWt7lk/slg8LHmHVq0wscddjwZM6MisoeSD6NqIKrHc1T7ZmcO8hk5XZZcTWez3cTyIzUOKo/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781603955; c=relaxed/simple;
	bh=YsUH8GRjWzF+2z5nMFgIqfB/qMMasJwyFVQwKxNs2vc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOY8ISCBDbio+jc2Tle97Mi/R/WC4+xljyd8IzAZu4Gjo1EeryRweAAQLuUBhE1fKpY/C3/mEUmNtCuprsxCSI8EcR2tIbVs+McYyGskbfCi/Ai0DiMfPM4ruAxxGSoDN0ukPK1iPWZLF08BK4oT+rr3uLvD/w1Lt21mz1ZlAB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mUT6qz9N; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mUT6qz9N"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490bb5ad3bdso36735e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 02:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781603953; x=1782208753; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7wYkUZPhq8nvtETyvZf9QFyTN8ToFuQUMboYREVvOs=;
        b=mUT6qz9NKW5F+9lv3PaHiEDMP7cQpEoJTjuPVRBL99s7q6M+plc63dRAGc3bhMUkx3
         SOwX1WkrKTrV+8Tgz/mGlfXRkJildz7F2kM6ezQ6BxLNlgQ/u2dMJYT0rleBuddo9yeO
         ymYHI1Fg10ITBgokxXszcAMe4PIAoJYQsms5mXPzt6vqxD0joWaL3m2bYd1KFJX2Kvxz
         ThmSLRN+4XwvpuLFn/dkOlWh4dBrCa+6yyKeHqyXvfRgswJLrgrVxiEORC1vaoKQ90aZ
         /w26Fq0xWK3I2RJGp1zGR921+BhFPvJXZI8TkaHykIlx62CmDn/xw/wC0opzA8iDhZzy
         ce1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781603953; x=1782208753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7wYkUZPhq8nvtETyvZf9QFyTN8ToFuQUMboYREVvOs=;
        b=WeMz8ga6upfkh8vMV1IXkaFTh+/3Pehl/Lg9qU80b81UZRXFmxO9n6lfQbwkSeOCsH
         xTbefhm0RZikeZH/snhUCYtX3zCe1azBHTxuL+92NsVXR8i702ZsQw1iIBsxdS1b+P0a
         F56iTuLZ30vTFI6fPthyLsitwCyZ6BdK860Adi3xoC67cRMlK2kLrIGYiPqyLNKBw6mh
         BIjqDPLJ6lbfWoFHix2d6Ne13e+C4U+2y+BGRXLcYPLmAlSG8mCvBqXmoqtCuMKE+3x5
         lOM7P3f44PXs4eQyFbjhjj1VJMmz+lkWOzi7VgU0XkXazSuIRSKBidtftUNbFcgncvmZ
         VmhQ==
X-Forwarded-Encrypted: i=1; AFNElJ/tcBO4FT7YisdsoZ7R7O2KEMrsyy7ErKdP+KLYYSlvjuX+vpoSVqLPfLOsPdFNMsISft27k4c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCZIFV/tSQP1t42BteJS/wGuuSOS0Y5EyJdtww+QOERYzm0lGS
	4pflQyL38jnx7CIDA5jDDtqnf84HlfJcFw7sAT9Uzb5zRtecEF71qOl19ChLeTUX/Q==
X-Gm-Gg: Acq92OGw4MNho+MI1WjrUaAFtFhqliJ5411pUDenPvf/mk4OQ9k0Qtd/piDpSMzyQ0m
	FiaS2MLvx7SOOc1bgvg1XVVfimMLRtzHaQ7vLym3xpJWCrt+x5sQT0AQDd297PfjpRymjqWkyZ4
	XoG2HPLV1PKzo4ax//urrSoC8XZlHfJkyYrC32spCZLEUdTkxdakuavK3bI/KuT1HgUmezeJaTY
	nQFH4qpdc5rdOwVdJmQnh4uV9XtI/7D1pPODEKBiYD+0IiG5iuNCSr/qhO94fr7iJl9QKEQF3Mx
	MFzGY42Lwclh10y1/kU55rAunnB1puem2/EtoJgSssYGkPI4GD7e+JxKPmyAtuoFPiHwT2nEnSe
	ztCe4G6sNZAujvjJJSXz+zjnsP4TQTChHodQaTJkiGupZUEaS/jyfkiAa8wY9u1F82zHgvSaYbN
	yEp4fn3iaHroHq9MT1xJxU7otrXks1Gdfrbob0P/R9GhU3FoFDYX0/OotGKToWfxh4j7xiiQ==
X-Received: by 2002:a05:600c:642:b0:489:1ace:d0d3 with SMTP id 5b1f17b1804b1-4923088f166mr659075e9.3.1781603952202;
        Tue, 16 Jun 2026 02:59:12 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b1056sm42862289f8f.18.2026.06.16.02.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 02:59:11 -0700 (PDT)
Date: Tue, 16 Jun 2026 09:59:07 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Will Deacon <will@kernel.org>, catalin.marinas@arm.com, maz@kernel.org,
	oupton@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v2 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <ajEea2SdZxPQISzD@google.com>
References: <20260608165549.1479409-1-sebastianene@google.com>
 <aikt44sVnpL3_dYi@google.com>
 <aik5MtvOlnQDmzjr@willie-the-truck>
 <ailVcN-bxY30-XBF@google.com>
 <ailXKA1VG8vyKNfV@willie-the-truck>
 <ailtCAcEaJIgZ5Ap@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ailtCAcEaJIgZ5Ap@google.com>

On Wed, Jun 10, 2026 at 02:56:24PM +0100, Vincent Donnefort wrote:
> On Wed, Jun 10, 2026 at 01:23:04PM +0100, Will Deacon wrote:
> > On Wed, Jun 10, 2026 at 01:15:44PM +0100, Vincent Donnefort wrote:
> > > On Wed, Jun 10, 2026 at 11:15:14AM +0100, Will Deacon wrote:
> > > > On Wed, Jun 10, 2026 at 10:26:59AM +0100, Vincent Donnefort wrote:
> > > > > On Mon, Jun 08, 2026 at 04:55:42PM +0000, Sebastian Ene wrote:
> > > > > > Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> > > > > > FF-A proxy. This restriction was preventing the use of asynchronous
> > > > > > signaling mechanisms defined by the Arm FF-A specification to
> > > > > > communicate with the secure services.
> > > > > > While these calls are markes as optional, there is no reason why the
> > > > > > hypervisor proxy would block them because:
> > > > > > 
> > > > > > 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
> > > > > >    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
> > > > > >    Because all forwarded notifications are inherently attributed to
> > > > > >    the Host by the SPMC, there is no risk of VM ID spoofing
> > > > > >    originating from the Normal World.
> > > > > > 
> > > > > > 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
> > > > > >    operate strictly via register-based parameters, passing only
> > > > > >    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
> > > > > >    not contain memory addresses, offsets, or pointers, forwarding
> > > > > >    them doesn't pose a risk of memory-based confused deputy attack
> > > > > >    (e.g., tricking the SPMC into overwriting protected memory).
> > > > > > 
> > > > > > While the pKVM proxy behaves as a relayer, it doesn't currently have its
> > > > > > own FF-A ID(only the host has the ID 0). The behavior of the setup
> > > > > > flow is covered by the spec in the: '10.9 Notification support without
> > > > > > a Hypervisor'.
> > > > > 
> > > > > As it is only a relayer. Is it really important to check SBZ arguments and
> > > > > fields on behalf of Trustzone? It doesn't feel it brings any security. If the
> > > > > host passes broken arguments, I don't believe this puts pKVM at risk. Does it? 
> > > > 
> > > > I think the problem would be if an update to FF-A allocated some of the
> > > > currently SBZ bits to implement some functionality that we would want
> > > > to filter at EL2.
> > > 
> > > I suppose that would bump the FF-A version and the proxy would reject it?
> > 
> > Maybe? I don't think they'd _have_ to bump the version number.
> > 
> > > If we really want to check for those arguments to be 0:
> > > 
> > >  * Shouldn't we extend this check to other FF-A invocations?
> > 
> > yes, that's what the diff was doing in the reply here:
> > 
> > https://lore.kernel.org/all/af3fW468-f1KXCrC@google.com/
> > 
> > but, as I said here:
> > 
> > https://lore.kernel.org/all/ahmxiFXXTupafbXw@willie-the-truck/
> > 
> > I don't particularly like the table-driven indirection (the checks
> > should just be inlined).
> 
> Ha, sorry I'm late to the party. 
> 
> Perhaps this series should start with adding ffa_check_unused_args_sbz() to the
> existing allowed FF-A invocations?

Right, after talking to Will a bit more on this I will add
ffa_check_unused_args_sbz() to the existing calls in the first part of
the series.

> 
> > 
> > >  * Do we really want to also look into the !SBZ arguments to verify what we can?
> > >    (I'm thinking about the checks on flags)
> > 
> > For known arguments, we only need to verify things that can affect EL2.
> > I suspect we don't care about a bunch of it.
> > 
> > Will

Thanks,
Sebastian
