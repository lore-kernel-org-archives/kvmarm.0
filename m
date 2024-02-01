Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE08C20E4
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 01:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706750357; cv=none; b=SzQHn/1fS48c7yWO8UedboQ9wXoDju7Crvr/72XrjPBNto6nqUlEHz4a/DeruTYHW1WZ1L2i5CHW+41jnonf967LPYeurol/cNI/VscAuuzc7ItprBJpUTJ7LAZhKO9ZX1tnhmyjz9uisCB7Eb6QdOUT9oSXDodRqXCcNW3+Wyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706750357; c=relaxed/simple;
	bh=7fRlzmXPRGNcP7/rdkvvjw/GywXiezprH3glel5e1Y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qi7bQBzDQ6HHI6VC3y3r/41tKGVTJSSQ4mpaWQQ1XFyuBhkKgLXRBTjWnJS0ExAgXzSJygyEr8nHiW88/XQZhkz8DRDWM/O59ne66zMKE7tGmyaQ2OWE2NntG7vL34yy946IS64qzXAOA3ArmGGqhxMTiE4MhKt0t3v4LKEhCO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T58wrdoS; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T58wrdoS"
Date: Thu, 1 Feb 2024 01:19:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706750351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdGWg9mLdgVQVzubThwyPSrz1+OTwVAbV3Hd5xxiYb4=;
	b=T58wrdoSVWwBPyvZipAUQ5zN0guv+zb27w40axBq0O8RkShsNA6VT11q6sHwmGVS2UPohE
	bUEIGzfmhOW4zzwLFga3AwvpM92q7Dovee16HHMTzJxUsdYTP+a0um4Pm5/h6hVRj8z7Lh
	oNcIl9SG/A2IrGsuHFnDzfmec0woV8Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Houghton <jthoughton@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, seanjc@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	maz@kernel.org, robert.hoo.linux@gmail.com, dmatlack@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
Message-ID: <ZbrxiSNV7e1C6LO-@linux.dev>
References: <20231109210325.3806151-1-amoorthy@google.com>
 <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 31, 2024 at 04:26:08PM -0800, James Houghton wrote:
> On Wed, Jan 31, 2024 at 2:00 PM Anish Moorthy <amoorthy@google.com> wrote:

[...]

> On that note, I think we need to drop the patch that causes
> read-faults in RO memslots to go through fast GUP. KVM didn't do that
> for a good reason[1].
> 
> That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
> the right way to implement KVM_EXIT_ON_MISSING is to have
> hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
> We still get the win we're looking for: don't grab the userfaultfd
> locks.

Is there even a legitimate use case that warrants optimizing faults on
RO memslots? My expectation is that the VMM uses these to back things
like guest ROM, or at least that's what QEMU does. In that case I'd
expect faults to be exceedingly rare, and if the VMM actually cared it
could just pre-populate the primary mapping.

I understand why we would want to support KVM_EXIT_ON_MISSING for the
sake of completeness of the UAPI, but it'd be surprising if this
mattered in the context of post-copy.

-- 
Thanks,
Oliver
