Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794853872;
	b=L/+PIrGEsHWaKmKsloiufUekMte+JOaqfDByDswILJdT4PRewVBD5BmS425O6xJcYAl2
	 r4/9gSp0TVso+tp+BeuJtB5RA3gx26J4uNs8o2+sNocNiyOMvvjjgz75+Rvm1ubW0qKgU
	 ohaSnJJdC5nF33gf+4t/VXM073ZbgnnE0CC7WgO3FSqpD6KTeM8hYXkBu3sOzh3hf7mWj
	 b/cvKw+9KzjpGoBmnzgGiDmiFHgMq38KlW99ipUBd23QoQler5W7HezgQ+R6YjTbvzsl6
	 SfkklqwtjfZR0xmeaL26Co6jBPhpc3T0JPo+qtl9EAt9X4HcFSTF8bFNbXgi1giGYDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794853872;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=S7e5/3qhMzwHmcdOrhg3u7+owObXooEMey9O5v8c82I=;
	b=bkVLWOKDr592Ni/Zuxfj4ABHxovXn34f3U1wX2WkWpBYXQVGsUNEKNfOkUZBOyUsoD29
	 UtWmwWnd8kJu6dIDMAp8QhJYM65B2P8O29MOeIMOY2tIfJ3Z483Jy0OeI1XxqE4dgqMxW
	 ms4bn9ggSE79yVw2X195nuV3CLhCIsBvJ3PgDRsVGttLIZuPj4W9dAc0rfsG0LT5xensl
	 4cwOzGDuSP1IcgnD1UtTzq5BkmwBx2yyV8fMg5hUaV7sT6ISSW8W9Ax7XNaR12PWT2QIC
	 diMXmsUY74cB/2QccUNqPD2ilaBGidLwqotlbsdEJ9MslEqfevW/NJHibhSDXtMKlLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crR46lRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70880606A323;
	Mon, 16 Nov 2026 18:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=crR46lRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB1E1F000C4;
	Mon, 16 Nov 2026 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853872;
	bh=S7e5/3qhMzwHmcdOrhg3u7+owObXooEMey9O5v8c82I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=crR46lRanQeAEbsu7dj9ejzkWarMyTE/KgmXszbgPd4x/5fhj4QZ4a3G7UCHVFjus
	 kQmCiu8Nru5pGrzH1NhMFCtcRvGNtOnWEWjYR3t3o2lkrDsmgLl90kFUwh4lDh2l6y
	 YghpD/Bl7eUI8eHkteuehVpoBjx7+8wAFB64aowvkRXhOjJkQ4iSGuQzQVqvNcxfS9
	 0wYf7KlRrWQrqsPs34Vdu2LSr/b04K2bPUeDiuiQQ52iNttgoOAbPsu7SxmL2yvSCn
	 BagwxznYuUMIFk+Wpfu1xumVYR3Te5REvfFbPSntQhf2Se/WwptBq7NtYFTNN5Kret
	 PhGnqfB9wDFvg==
Date: Mon, 16 Nov 2026 18:31:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 06/28] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Message-ID: <avtL0nlA1plEURmz@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-7-alexandru.elisei@arm.com>
 <atDtheEuNRs7v3Gx@gremlin>
 <avXcdwY89YPFGIlk@raptor>
 <avXloVVaBeEwEplU@raptor>
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
In-Reply-To: <avXloVVaBeEwEplU@raptor>

On Thu, Nov 12, 2026 at 04:13:21PM +0000, Alexandru Elisei wrote:
> Hi Lorenzo,
>
> On Thu, Nov 12, 2026 at 03:34:15PM +0000, Alexandru Elisei wrote:
> > Hi Lorenzo,
> >
> > On Thu, Oct 15, 2026 at 05:51:03PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Sep 03, 2026 at 05:06:01PM +0100, Alexandru Elisei wrote:
> > > > [..]
> > > > +	if (!entry)
> > > > +		return;
> > >
> > > Hmm, shouldn't failing to allocate here be an error, or at least a warning?
> >
> > I don't think it's something that should cause the probe to fail. I could
> > add a warning, I guess, to let the user know why KVM_CAP_ARM_SPE is missing
> > even though the SPE module was loaded successfully.
>
> On second thought, there's really no need to taint the kernel if the
> allocation fails, KVM and the SPE driver can still function correctly.
> Since the likelyhood of it happening is very low (it's a small allocation,
> only three pointers), and userspace can detect it happening because
> KVM_CAP_ARM_SPE is not available, I am inclined to keep it as it is and not
> print a warning.

OK, fair enough, this isn't a big deal, thanks! :)

>
> Thanks,
> Alex

--
Cheers, Lorenzo
