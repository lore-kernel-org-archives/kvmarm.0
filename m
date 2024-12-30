Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1A31AAA2C
	for <kvmarm@lists.linux.dev>; Mon, 30 Dec 2024 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735577590; cv=none; b=R3CWGp7kR4Kr4zkRSm1an/g1eqo0mK/ywmclk3lH4p4ASSuUxB+FHaKAsEgCDkSqf+7WI+0EfNwKiN/frkB8vYvSLAz6PaD1a1jWBgSUDJ4bBdVdCzjYwcre6iNMo7L/DROnjzmAMhjEcSFEsd4AXPtWhYi1WWKe+mvoZ05yEPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735577590; c=relaxed/simple;
	bh=4DsuUvtZSbNE0JOtTEMvH9e2uISx6eK0eBTQhYCJr98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JF7OVpKaQhWkKnQmOYg6UG9JU43kJ+Lckrv8N61IM+Jx8lgYwkMiNgOGYx0FbNTudfcSZJj2qlGoj0A/iXwpvJGQdROAANsKXsxNdtbT+xLGY3OoASKE/YZKqM/WYDtU/vXzyWWgaqRpLGlfwW3b2V+OxuLPqq96JWIpAkPt+0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SKttJG/K; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SKttJG/K"
Date: Mon, 30 Dec 2024 17:52:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735577584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u6RAXwVrfF2VY7f5Ytg9m6NqyXZWFZBWlWIBVYnzxbk=;
	b=SKttJG/K5VBA10uqB1WtZbfn7Pov2i2vRwRilGvhrVNzmWfyPcbK9LU8WNXh7N9xR4OfoX
	5DHd9eduMnY98ZingRMvGQreE7s3+loFrsbVy03lc7AZ8P0eHbhjUVqWr2SSegb6dCRaSO
	djUIzKMB1zjS8TqewFZ62vgLGuYExzE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <20241230-bccb6213d3a71a09a7d32834@orel>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor>
 <20241230-3c7d660ca38c9b390ec74b01@orel>
 <Z3LKLvkLjId1SeTI@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3LKLvkLjId1SeTI@raptor>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 30, 2024 at 04:28:30PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Mon, Dec 30, 2024 at 04:45:01PM +0100, Andrew Jones wrote:
> > On Mon, Dec 30, 2024 at 03:19:48PM +0000, Alexandru Elisei wrote:
> > ...
> > > Interestingly though, when I try to run a test (either with ./run_tests.sh
> > > mte-sync, or by trying out your example), I get this error:
> > > 
> > > qemu-system-aarch64: MTE requested, but not supported by the guest CPU
> > > 
> > > My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
> > > model CPU. Changing the cpu to 'max' makes the test run. How are you getting
> > > around this on your end?
> > >
> > 
> > We can (and I think should) change to 'max' for the default model.
> 
> I think so too, something like this maybe?
> 
> diff --git a/configure b/configure
> index 86cf1da36467..4babbd5f5e74 100755
> --- a/configure
> +++ b/configure
> @@ -286,7 +286,7 @@ fi
>  [ -z "$processor" ] && processor="$arch"
> 
>  if [ "$processor" = "arm64" ]; then
> -    processor="cortex-a57"
> +    processor="max"
>  elif [ "$processor" = "arm" ]; then
>      processor="cortex-a15"
>  fi
> 
> Can't do the same for arm, because Makefile.arm passes the processor to
> -mcpu and that causes a build error.

I wonder if we can improve the mcpu thing by just selecting some generic
cpu type at this point? Or just dropping it and counting on the compiler
to use generic cpu type? It'd be nice to use max for both arm and arm64,
but if nobody has time to do the arm work / testing to be sure we can,
then I'm fine with just a patch changing arm64.

Thanks,
drew
