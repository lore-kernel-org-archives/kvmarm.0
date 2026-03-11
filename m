Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719E53DE458
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773242614; cv=none; b=chD0tYSQmgSKEjIz8RblL5Kda9Ntetx0amFoQvKNAS1p0LqWJn2v+8Td77btkF93lQCEXK61L8ULtHkmvz9wLUOoqJvxKNM3wqV03epGaQ449bIADVZjjvzcxLBSuyfjjy+YOosAumN7UbcHaNbCI5zYOPs8FQsfeALELhHIrNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773242614; c=relaxed/simple;
	bh=Z+GkvsxIGO1i8VGlHtLFZtvWWVWC8f8GiQAoIj6Szb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pl91xKgIsZoqcqeSVY+pQTy6QDFwtMCIVfKDANUdj6akq2OFklorJbqJSzLZmenVE5PK9J81uLoJYkm6JskpqPwIBQszOiYsekY3r7hZ7/j+uPT/Y/qOQQqhaQ4fqeWypnj/B3t56FmOIX/HKEjc9DzqLWrwrGQm5/79F4Jjaps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4DVTh8jA; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4DVTh8jA"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439b2965d4bso8585192f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 08:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773242610; x=1773847410; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M1n477ll3uIr3ftc1SUKSWN3qMH5BQQpUlgTcrO/W9I=;
        b=4DVTh8jA8gI9zAx03BXnnQDWisvQAUvRsJI9YhYhsyFiUF8+lpzsGBVGO+sCS4lZ2N
         8EF9l6Mhltm7Tvmw7nzsFVQ+/AFGYjqwRSb3MdeFFSqYJNhgI2cziYpZ9dzz06gzSFbz
         VGDvIzVuA/ME2+DKOfGXZBoFSEjz7oZJBDd1r/aLZfYNHUllMXMRO34+MYL42LK50GtB
         DnYA/yMEx0+QmeYgtwrSv33ze90twonayEflAcz3+txRzIGJcKaCok10vEzHf6wM7q1G
         kr31hvq6X9Eq4BABc310XSTZKAmMIhKg5kF7miK7F/uahHwHmy7dLvbpZGmMonJn8Ayx
         o4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773242610; x=1773847410;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M1n477ll3uIr3ftc1SUKSWN3qMH5BQQpUlgTcrO/W9I=;
        b=LgbJLI7tJxz8zbGdOyWQYTjTthGBEGC3zXscl9i1G6tNp9BNznfsG7iIRPZbdB7wlE
         2IUGp0TJSB1uiclkFU1RjuLHhafBffiTrgUZXPlQ6EtFdHSnQUMeWg3Tq4JQeEM+i5mE
         guFvl57fY/0A3J/+Z6927t4YWMxdAu7oSEmEIgA8XOTmqDXUwH/161OIklIBAPMNwMC1
         o3xoXXy/pzs6Gy7c18uhRDWj7RVV0EU4hv08Euxfy7GFAuNLESVMEn/M67u5oW7tg8Zi
         POPLJfIZj+n7EoN+c7zBQaX7vMeXpITr7qW4PLEr5KfSHAqzvLaAyJ/hQ/DJ94FK6u0t
         PjGg==
X-Forwarded-Encrypted: i=1; AJvYcCXrtWwsZihPG8XbUfGP045oILRI4Zc/58Yh41xEscIWGObZG19QAb/WAz7UxtiY+WnonKwePnI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSHlWJVfgQS9qKJKBRjLQ943uo6lVUO5jMD89FEb2+DimZSGBd
	GsuCuK8Kh0rqGusYlwK4kWV6MDoQ7eA2+wqOkpTMgAyyPdq8yjWOigfqD8KE313D5g==
X-Gm-Gg: ATEYQzzwyOpjfA0lMvlonjhhMyN+S7v1jxNF8LxrNR79kU11TXlN5hWqlIt93iwbvBz
	a0WfmLmJRlAkm/adZxaRx4sWNJKvoP1NTo0/u2teCLTfBSAYDAa40vUtyGS5jSb+aatBn7mEnaI
	WDJ5PKPdAA0Z3R3IFz+G5V5oH7zuXF0fczsLWLwnzFd8HX6o6Cl8uh29p3c3/9KS7hUAsKiTFq3
	fjoRnZkbraGbUUwO4oPsV9Ydkc0Z+6N4AUN2DDuv0oE1Iu5w4Syg9IlKKCrdl93jVWoMJ3YftRK
	GLO6343C+nliUFm/qQUlnv2ihbyfMJ8rVzwaS/FBdPQz4RqLOVDFL1OLEEFG38g5bgNmkUHEIuH
	Qphw2/U/78jDppICunUkptJmLX7FARM0OuZAx6MbsEMb0n+ZmXrpH63IUpQJia+xIOuafvWvnJV
	epEKOeIzuNK26iYnTJHE9/cJE2CziQ7OA64X1l6VVvRtGPGfGkgodx+7GNgjv4mpK3mUs=
X-Received: by 2002:a5d:5d85:0:b0:439:b715:6f49 with SMTP id ffacd0b85a97d-439f8415ffdmr5618431f8f.59.1773242610090;
        Wed, 11 Mar 2026 08:23:30 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f82078a1sm9543853f8f.29.2026.03.11.08.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 08:23:29 -0700 (PDT)
Date: Wed, 11 Mar 2026 15:23:26 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-trace-kernel@vger.kernel.org, kernel-team@android.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suzuki Poulouse <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	John Stultz <jstultz@google.com>,
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v13 03/32] ring-buffer: Introduce ring-buffer remotes
Message-ID: <abGI7kzhTHl-MyHv@google.com>
References: <20260306143536.339777-4-vdonnefort@google.com>
 <677c7ad6-6e67-4011-b2d0-03d0d58547ce@web.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <677c7ad6-6e67-4011-b2d0-03d0d58547ce@web.de>

On Fri, Mar 06, 2026 at 05:37:35PM +0100, Markus Elfring wrote:
> …
> > It is expected from the remote to keep the meta-page updated.
> 
> See also once more:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v7.0-rc2#n94
> 
> 
> …
> > +++ b/kernel/trace/ring_buffer.c
> …
> > +int ring_buffer_poll_remote(struct trace_buffer *buffer, int cpu)
> > +{
> …
> > +	cpus_read_lock();
> > +
> > +	/*
> > +	 * Make sure all the ring buffers are up to date before we start reading
> > +	 * them.
> > +	 */
> > +	for_each_buffer_cpu(buffer, cpu) {
> …
> > +	}
> > +
> > +	cpus_read_unlock();
> > +
> > +	return 0;
> > +}
> …
> 
> How do you think about to use another lock guard here?
> https://elixir.bootlin.com/linux/v7.0-rc1/source/include/linux/cpuhplock.h#L48

Sorry, I forgot to reply to you. I had to respin a new version so I have made
the changes you've suggested.

Thanks,
Vincent

> 
> Regards,
> Markus
