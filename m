Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E903A1CD0C
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 20:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713818786; cv=none; b=Cr1CN4ZaKx9YAZlPVvQnmjZPcawoC/B3wjCL8sTL/o98naxCutEF7w7Av4/mbTj3yKVu5pS9zuQX4LNtmkqSHu6BVbuRZhAP35vSuz/UL/C/v/BMPPMlJMOUTnflP91zSurQ4dtJamLJuKBLdOs5hVCV1RGSFKq4Ug2quthYecw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713818786; c=relaxed/simple;
	bh=7sZHnKwTNZUf1H5kHCndWOXGhTBlZ+wAV/Lak4FW3Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OA2cvk/HPPytYsRbjYhZFy6C6wb21MS31ohpfaerigHYk6d1n+pFH0RPXj9SBKrN0PIlSD+wPZqhWql43lRVEPTIA8MFpepRga7mploMbedw+L05g6gtNkBRpGoKcfw+XnooNKlkEsuLu3eEEuRD1RF6umi+rbJ8k8tIcLC+Ib4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qv+bH1e6; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qv+bH1e6"
Date: Mon, 22 Apr 2024 13:46:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713818782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GY9VKB90xKG2Hm1BXu8I0uer62f2h9TAXMCpu3QdQS8=;
	b=Qv+bH1e6DwjsSn/NcLYpwj8cJht3S1bm/rkvOL3K1kIvaayxDOOcSHhREi4VLH4Z4+GxSd
	5/gf61TjeHFM8OwTVrq8abfgSQNx5LfCIRYPIiY0yG2zuIm+mfsbmc26GNxpeKqToEXC0w
	C52evuQnyES3l7OqdrtLoi7SSaWAJZo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org,
	qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Subject: Re: [PATCH v3 27/31] KVM: arm64: Use atomic refcount helpers for
 'struct hyp_page::refcount'
Message-ID: <ZibMlkG-1MnCiXXF@linux.dev>
References: <20240419075941.4085061-1-tabba@google.com>
 <20240419075941.4085061-28-tabba@google.com>
 <ZiLZehsi1_arusae@linux.dev>
 <CA+EHjTx67TOQKzsLJ_9PP_rYRiYb7j0RuJLzDK8B6jK_SdQMHA@mail.gmail.com>
 <CA+EHjTzc6h719kvP9FJA3xqLnOxr5gPWDq7iYOx7JfQz4Wn61w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTzc6h719kvP9FJA3xqLnOxr5gPWDq7iYOx7JfQz4Wn61w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 22, 2024 at 02:08:17PM +0100, Fuad Tabba wrote:

[...]

> > > Adding a BUG_ON() for taking a reference on a non-refcounted page (i.e.
> > > p->refcount was 0) would be nice, especially since we're past the point of
> > > serializing everything and you can theoretically have a zero count page
> > > outside of the free list.
> > >
> > > Seems like otherwise we'd get actually hit the BUG_ON() in an unrelated
> > > allocation path.
> 
> Actually, the refcount can be 0 without it being an error. For
> example, when hyp pins memory shared with it by the host
> (mem_protect.c:hyp_pin_shared_mem()).

Are those not by their very definition non-refcounted pages? I can't
imagine we'd want pages in a shared state with the host to ever get
returned to the hyp allocator. Seems an erroneous hyp_put_page() would
get you there, though.

-- 
Thanks,
Oliver
