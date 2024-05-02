Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40B4153BEA
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714666111; cv=none; b=PTjhj8NGXVgKmi4K4TQ9a+ZtDgaTSQu0nN8a4hV2yYebrt1bUFc65xaKfcHn6OB4RCOAshwkJTnOwp6DB31RYSCsCGfwpW0xFCY3cb1hHCoje/Rg8BCbCSLl61SpnGR2nNU+fEuOmIQfSERnBYNIncnzuGDu3hf1hHoUUIq4Ik8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714666111; c=relaxed/simple;
	bh=1kWTvQMvQETsTHZMZgivrnlVA51356943+Xz6s7KCbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CeZFHtjX7CJ3YO/Q0VzycczuPOTyHe3LXzsPJ2cRCL28WbRjF3IfJNreJr++GROxxSegP32dIM9JUCQwCElNcjsOjtL0KZXvwZRG842OmlTcPNwD6l9Gxnq5XVSsonXI41qqGWeSHcjsWp7EriX4wZJJzVH9NgsvWxh4LOwLXAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m2pJfyg5; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m2pJfyg5"
Date: Thu, 2 May 2024 09:08:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714666107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ISofqfjw6smbKowxD1twVu5Cy9j5hX2DmE6w7IVTpEQ=;
	b=m2pJfyg5vudbKMRZ2kVAL4g5U+Ue0VJ+Q0GxdjWEBh5h6gXJXSciy9h32uxIGMH8SyG5fh
	ZlIg0nljzPqPQewSHcvyTrUr0iB1CaSFgl+Sz3yAk76nQM+YQ3e2IZEysQBs0rR+AH/K6Y
	vQTwpbVZhM8XLg+jIAljkXJIm/n0IyY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
Message-ID: <ZjO6dvK-_BUjqf61@linux.dev>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
 <20240502-d67a14b9ac3dd606a52af562@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502-d67a14b9ac3dd606a52af562@orel>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 11:05:51AM +0200, Andrew Jones wrote:
> On Thu, May 02, 2024 at 07:41:56AM GMT, Oliver Upton wrote:
> > Some arm64 implementations in the wild, like the Apple parts, do not
> > support the 64K translation granule. This can be a bit annoying when
> > running with the defaults on such hardware, as every test fails
> > before getting the MMU turned on.
> > 
> > Switch the default page size to 4K with the intention of having the
> > default setting be the most widely applicable one.
> 
> I had been drinking the "64k pages will rule the world" Kool-Aid for
> too long.

Hey, your words not mine! :-)

> Kool-Aid have already long worn off though, so I'll get this merged.

Thanks drew.

-- 
Best,
Oliver
