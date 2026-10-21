Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792623741;
	b=BXRNPPxXKMlnbGPt/1d42E5dfTO10jgQDatV491emZnGtqp++Vvhqo0LbfZ3Jz9kuq3y
	 RfaBOk7tSQjN7xOFbtCxVeaa9r5zyd1Evd/fylgE+cDBlME0j2GZOfBLZB5n5qttOIuY+
	 Iar1LdZf8jrjgrpnsC7eJvS2i7tpX7wt+Ceutju9mX66oU1Ct/91SFs1nXJ8KWaykbvgD
	 mDFz0qVacus4Axo2XC4BZEielccG9t+eNak+al3laUG94l9ynqZeGZsS1wP3UCP+R+v1h
	 P48N4GNFmMlv6sL7M8Ps09ESL+1DFqL8+LRpq5VVIgVjgV006xrVlSnnqBaWP+nBjJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792623741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=Rh1ct0ynFCJmpIeBgUsQvZu9SOoIsv6E2A9BdvVwioc=;
	b=l6s7vgc+bbFh7jw9hcf+cO2xynpXi0bXbGtK7HzjS8Az0OrP05Vl0L2ujMAsDnzsD3jK
	 VIAOwfBESmpPdbnjRXHqFZvFP4rCPVH10sSyU2iDmuo8nb+Wt+j6b5FlIdajx6zTFOTLY
	 zxO/DBaKRb1GwN4qCRoHYowTiA9Uv1olhWCMOMqu3uXwhSvC6KzwjU75y3O0a5vCDcOyz
	 J1vDImfNQ/i1jEZ0WDeoG3YzQuwDy6UTbDVDBm0/ezSetqtYrT5g5CfzM7EmDlyWnF5r5
	 k51sKOkdB8FUNdEAQ+IRhMT5uC+/EGdgmx+u2vBOkgEP2U5mzMYK8h9o7V2qNYuGC0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="LooLg07/";
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C470606A320
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 23:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C470606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=LooLg07/
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so766464a91.2
        for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 16:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792623741; x=1793228541; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rh1ct0ynFCJmpIeBgUsQvZu9SOoIsv6E2A9BdvVwioc=;
        b=LooLg07/jIq4fTj8/WSkVhmX7O5R4KqvIleS+BBMd3cr9breEy84WXW9DxX4PIJS3j
         u0JPuvRGopkj6yy1iX5RUv2dAm4BMvOW/wDq3CP17WPMAl7SxxuVQ5B86mIGjg6Yrqlh
         lzzI+NMXOAiXTiBjSAv184EsT+Eb3jgF4iqLPkfNXqxEabYILyVI7+LesTK0R9KNNHSN
         Fjj0Ld1c1Ihq2sDvaF4MzAOKj93GDXG05IpP458s35Al+IwVqqdjf4IYEmYY4bOsMUlO
         QMPcjQeQbeDXqxN9MS/YCcvzGWMdVYOK7F6zMCXjSzlsONa1Oh0Y0yfhB/pQE0/LFSFs
         jmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623741; x=1793228541;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Rh1ct0ynFCJmpIeBgUsQvZu9SOoIsv6E2A9BdvVwioc=;
        b=yEuNqX+KiWeXPRfp/Rj15tnmfsgMFKbSP2q23Egod/dec+CNqGYt5V2zjAoapa3qv8
         /8CEQye+y+hWacXFUXnpD75EjgQHow8CfaT/0DNTOp2+1uEctw/3xxIO8ILqpYshIodm
         P8TIn/ox8/7toSYMi5Ra5kLT82m2UZK7e/F+CnKQ43y0WOBpph1C1AFwUDf8tw1o04iI
         i5r366tK5r32/9nYY0so30PQPWiCCM0KnJukpE8qVfSPM1r+EBo7MYlMLNxlMZUrhPmF
         b5h2TS4Cd82xbY5ftgY/OQEERfB5AsO6TMFWjtHhjR2arlQqjWxwcXpAcrnvXrZn8F6v
         cz3g==
X-Forwarded-Encrypted: i=1; AKwUvBzEE1O2N2a7XSzyeYwRpQn2WrYXcLZ19jZjvbIJXu1AXCoc3lP1PSpzkIJM/fVtHjRCJwWngjU=@lists.linux.dev
X-Gm-Message-State: AFq9FYITIDko9rmL1Yigx+J9BaLiz5TdEjGtZOet6Qem3Z3bScQuq909
	YCrDlBGo/tlMANCjUujjwrBjqAU48nSDlJh4sKjcgnxf/611ahFxneJ9PacifzK9jQ==
X-Gm-Gg: AYBFou3vSAmWq2bePp1C5GUdH1E6/KpHfzQghQXubVxce3HO8eUceanZNxRbBeElFU+
	zAuWnC2KWAX2NB7B026NahMVIUjrYCYJTPOZAzO5j82/h9SuPzJ755rOp35OcMPdvcHVx1I/xO2
	jBQELX3tqnYUwfjz0g0u4lQfzrsXHiCge8UD6fcbybPNcOWapEm0mGCD0B8H5DbZhzd/s9fLndg
	GZzx8qzRVWMuNMklc1ymWS+vvzCMmzeesG/wpMBvso3pyC4MGHFgD53ox3aaC9KDj8KeWU23QuB
	oAY4tLxyayAao6O33xilnbcc8IPguBmWjLhvYE/umpO5YbbKGKI31QLL/m+SEqdCtZsGLPULyz5
	sUiAe2PX1rxnGyBbM+o4jPxBOpvE2r/9wuT6bLuIJUfzwXFIZ+Q7PnYVrSIJMgDZzHzv4OT3pQd
	e/MtfXC40tayty1vRWbnJW0cKv9+0rD91d7ZhHaj5mDpwL74GmklchTCtlnAFDigWihCXOO9zMQ
	qWZo7NlyPGuupG1bA+hiAjOITfWmu6Cy25xzqQLv+noJjJ4fYeSR2GBk32T1RQZAjDGAsRXC3nE
	CirheWr8h+NBCEOSwrLzx74hZGy25xqbyNgD7w==
X-Received: by 2002:a17:90b:2f85:b0:3ac:7c4d:8be6 with SMTP id 98e67ed59e1d1-3ad86d9e088mr2829501a91.40.1792623739843;
        Wed, 21 Oct 2026 16:02:19 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ada4896c4dsm1314919a91.7.2026.10.21.16.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:02:18 -0700 (PDT)
Date: Wed, 21 Oct 2026 23:02:14 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Tarun Sahu <tarunsahu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] liveupdate: Select file handler by name in
 the preserve ioctl
Message-ID: <atlEdhPjlyTPDWmG@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-3-tarunsahu@google.com>
 <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCnS8wcVDbOymBGeJB6pDUkknOpF22EynbwSV=D5=J4ow@mail.gmail.com>

On 2026-10-21 01:17 PM, Pasha Tatashin wrote:
> On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> >
> > Currently luo_preserve_file() iterates over luo_file_handler_list and
> > picks the first registered handler whose .can_preserve() callback
> > returns true. When a subsystem introduces a new, backwards-incompatible
> > file handler alongside an existing one for the same file type, userspace
> > has no way to choose which handler preserves a file descriptor, nor can
> > the kernel keep the existing rollback-safe handler as the default while
> > allowing callers to opt into the new handler.
> 
> That is not how it will work. If we are in the .can_preserve() call,
> it means the user has already decided which file handlers to use. We
> need to do that before any preservation happens; otherwise, we could
> run into conflicts on FLBs i.e. FH of different version require
> different FLBs.
> 
> Therefore, there should be a luoctl call (i.e via a new ioctl to set
> compatability) that provides the kernel with the specs file of the
> target kernel we are updating to, allowing the kernel to select the
> compatible file handlers. Since .can_preserve() is called when the
> user is already preserving files, the specification must have already
> been supplied, or the kernel should fall back to using the default
> (i.e., latest) file handlers.

I don't think that is the right direction. IMO the kernel should not be
choosing which file handler to use, userspace should be. If userspace
gets it wrong and chooses a file handler the next kernel does not
support, that's on them.

The problem with the kernel making a decision about file handlers is
then userspace does not know what arguments to pass in. We are adding
custom per-file handler arguments to PRESERVE_FD and RETRIEVE_FD. If the
kernel is picking which file handler to use, say for a memfd, then
userspace doesn't know which arguments to pass in.

Sure you could add some method where userspace could query which file
handlers are active and decide arguments based on that. But it feels
backwards.

I think a much cleaner solution is that userspace chooses file handler
during PRESERVE_FD. I would even require it for RETRIEVE_FD so that we
are guaranteed that the args the user is passing in are being sent to
the right file handler. Passing to RETRIEVE_FD also opens the door to
transforming across Live Update (similar to how AWS did LU from Xen to
KVM as discussed at LPC).

Regarding FLB conflicts, today we don't support multiple FLBs for the
same global state, so there is nothing to conflict. Selecting a file
handler during PRESERVE_FD doesn't change that.

If we ever need to support multiple FLBs for the same global state
(e.g. an incompatible change to the PCI FLB), we can add an ioctl that
lets userspace select which FLB to use before preserving any files.
After that, only file handlers registered with the selected FLB can be
used to preserve files. PRESERVE_FD with any other file handler fails.

That keeps the FLB decision up front and global, like you want, while
still letting userspace pick the file handler for each fd. I'd also
expect this to be rare, since FLB serialized state can use the same
feature flags as everything else in this series.
