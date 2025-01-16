Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687CE22BAB7
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737039010; cv=none; b=qy1Nc6pKwhrZgeKTz1GlGJKSEQA39e9XXRb8GADiUI82x5grCGouhbZX3aleo4KW1Az3ufu/+NlLebP3ro+NfViAf6ark411E04rN2asD0IsptrDMSA+frrrwWwmtw3LqdYmSeoC9yxjmbn8MBdktF0umqBVIE+IO+Voe5JGmQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737039010; c=relaxed/simple;
	bh=4hbCTX37OlL7FWZdGlRYXpiEDdg5Z2+huHxFb8o3nLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ee9X81AhFw58GUhAPqkloSaUcPsC82HkgnL5F2Iq6bV+N4LxWLFSPskKJ4smDIIhtEGbglw3kcq9Qvf4544ShqDavaNAJiE9UR4QgMb/XabnTWgNsbJyfIFgklZKApeok78x7EVUC4vwaWl/AZGDf47nAmJ21j9uYGjz9DYnN/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pjpazH+X; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pjpazH+X"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso45685e9.1
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 06:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737039007; x=1737643807; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=th+KCDURk+54uiOu7vrQtTKV4wr7vJCxQzUoT2E5qpU=;
        b=pjpazH+X68jQNoIyqascnXXmdcoYD4Wy3+xh9i5UJQNVS7qzkCLQPDpFqkywGArHAx
         0shTvPc/Kr0p7dkZsJXztGZWo1opjGvpTlwArHZFmiyooym4eH4H9r3VbfXOrUCJGs0L
         5Kq485zP5Zer2drCm0+D+1HVLu7g12FdP4+Od4qWEGkukYzvtPuSn3jLzEi4ESxNsxYg
         3o+Pb1IQHxQm4Xfgv7m8kXcAyy20S18gI62RFQ4A3QfuPya5ADZ4RNRfzfeH5QEvubE3
         bHTowtoB8vjrMtCWA3PrrrivYD2VK/DqFR0avJ7CKNx6MXEISEzHVofmemLIxJzF+bBe
         oFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737039007; x=1737643807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=th+KCDURk+54uiOu7vrQtTKV4wr7vJCxQzUoT2E5qpU=;
        b=tdNC3UFYHGVCZr74dXYEp+/9ZpV5bwzqKcRWd2YXD9ys+NHESqUaaey8utr43mn8OK
         4f+HIfrxd8Es5plgSbsGV5EJ8QAy/fheIQgRT8iF7GOnJ4sxKFxh/nbPcqZV04jxsk++
         Eqk7GtNYYDz6xPHkZqB6tjeuy+4OuS0vl5qtpGJ0lTnR3r6FfPQKKML/jaSLbJ6PGREI
         YmXSoxK9VNXy/hIXcRt/koQgB0E2oGrBYD/nVg/EZeAKxmg6J12HazVzlUCKfzk74TTb
         cd0EDh5bU/UPpee+mYw+HPQuTEw5B0slo/f+z879wVLamzmeuqzGwU/rsEhX6U1/Vf7O
         w7EQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6A4MhOTVXr7OQ66uuyDbV3eGQTthV4vBYQ5Bo5zIqs+FWwB5iKYM2XFyNybgJwCfFgsQmrsc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKrIJWkQsZLHDa0kSKzjIe8IodtnD714T+D70+wLQOWdUuqZNq
	K/4ypc06boFOCBfB70VsCk/0KM9TNThzXE/6DAsM1IMwlwMu0Sz0h4oO3JZHIQ==
X-Gm-Gg: ASbGnctQttNCq1ygngjYXxcRmGxr5RZhsrHlsIErrAfHc3iy2vWyMzEKNjxrZP2HqJN
	UxNVEk8/HTc1eT3dW/A/hx4dBpNAmw7X8sQM6ZWUeFKo26zRYDpCHO/6NNlwzKqNM8mEXRI8L51
	BOfDCljQm/tf/NMKWt5cMVuqSy55VA71zFGJ8Ma718EMGxsjXHjmLyhEM51SBiwMmg2jAsqUh1+
	YL7CaqSEzoZtHor5LN6wN8HEsdp0o4jXzooBbqMyYt1Pz0u8DqBoF8ns65vU1R+JwUyl+5Nh+8i
	sfBByibMM9xh2sTgLy6yLnWc
X-Google-Smtp-Source: AGHT+IHbW5e6FcdINOIJSuAL5IxGPUZUYCUoVAOoYMejLluSZuDbScxH72g/lWhucPA8oug2f237Bw==
X-Received: by 2002:a05:600c:693:b0:436:1811:a79c with SMTP id 5b1f17b1804b1-4388b98b77amr1013155e9.5.1737039006638;
        Thu, 16 Jan 2025 06:50:06 -0800 (PST)
Received: from google.com (47.246.140.34.bc.googleusercontent.com. [34.140.246.47])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438904625e5sm1453475e9.32.2025.01.16.06.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:50:05 -0800 (PST)
Date: Thu, 16 Jan 2025 14:50:03 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	oliver.upton@linux.dev, will@kernel.org, Aishwarya.TCV@arm.com
Subject: Re: [PATCH] KVM: arm64: Fix the upper limit of the walker range
Message-ID: <Z4kcmwzoRINgTtrO@google.com>
References: <20250114145050.563658-2-sebastianene@google.com>
 <14cce00c-29bd-4feb-b7d0-7aae6e948d1e@sirena.org.uk>
 <8634hjvxi2.wl-maz@kernel.org>
 <e79c78a7-24a3-42e6-a217-ec64f8320e91@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e79c78a7-24a3-42e6-a217-ec64f8320e91@arm.com>

On Thu, Jan 16, 2025 at 01:49:54PM +0000, Suzuki K Poulose wrote:

Hi,

> On 16/01/2025 10:55, Marc Zyngier wrote:
> > On Thu, 16 Jan 2025 01:16:40 +0000,
> > Mark Brown <broonie@kernel.org> wrote:
> > > 
> > > On Tue, Jan 14, 2025 at 02:50:51PM +0000, Sebastian Ene wrote:
> > > 
> > > > Prevent the walker from running into weeds when walking an
> > > > entire address range.
> > > 
> > > The KVM page_fault_test selftest started failing in next-20250115 on
> > > at least n1sdp and TX2 in VHE mode and a bisect seems to point to this
> > > change.  The bisect only just finished, I've done no further
> > > investigation.
> > > 
> > > When the test fails it generates backtraces like that below:
> > 
> > [...]
> > 
> > Thanks for the heads up.
> > 
> > Given how close we are to the merge window opening, I've dropped this
> > patch from -next.
> > 
> > Seb: it looks this breaks a bunch of existing assumptions. Let's
> > revisit this before -rc1, if possible.
> In kvm_pgtable_walk() we set the walk_data.end to PAGE_ALIGNED(start +
> size), where size is BIT(ia_size) and start = 0, for
> kvm_pgtable_stage2_destroy().
> 
> And subtracting the limit in _kvm_pgtable_walk makes things go bad,
>  returning -ERANGE.
> Given the kvm_pgtable_walk() passes the "end" as the top address (not
> including it), and is always PAGE_ALIGNED, we should probably leave things
> as it is in the code.
>

Thanks for looking into this.
I have a fix but it is too much of a surgery so we decided not to send
it and instead go with the removal of my change. 

> 
> Cheers
> Suzuki
> 
> 
> > 
> > Thanks,
> > 
> > 	M.
> > 
>

Thanks,
Sebastian
