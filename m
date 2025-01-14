Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F83E1FC7C9
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 18:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736880676; cv=none; b=AIrLlM7TXdTl/D/HScq4rn8W/QzkdkPW3t18PCh2z6pa7rCcR88R0fpzr9oBNg9d4Qva3gdeRQUgpvfeRFZYCJivbO9/cgwA20fqCF8VvcW43ZOHgWbnRSxTpDuwJpbLu2RsclqtP2hEAFfd09Qnl3P5I+HroU/w+H2lCAEIxNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736880676; c=relaxed/simple;
	bh=R4OdNl8vclZ5OqJ7MQuD3rDX0xFvlBDx/OTMtePGWIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmxSOmDnIr78XoctVXF8P++0KCcwPaJcOZlpVVC55TFaWnp4X//YKmwWs0dXL25183gPyGtfPRleCkp9FyNAykFHh36OPo8OZishTGFqMKhlXrpeYN730Rq4bSET3PHZMiiiKeYLy8j9IDLD/j06IfNbupsJQX0SWCtVhDJaQo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bDwVpiqw; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bDwVpiqw"
Date: Tue, 14 Jan 2025 19:51:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736880667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2eozFwwdtkEYzJ2hyZvHDykhTKQHMj/tbtFgxiV9nmk=;
	b=bDwVpiqwthykPiL4DaZF3p8XdHuWrRCxyc+t3QoVxlq9WllkrRjz253Cd2sapgSU4PpTuG
	DBtaCXDW1u7il2zRd6EYwHlzoZ1xsuWES603N8XxALx+eGQSDb769jEfu92II30o+alkaZ
	mznHVpGOOinL8YdOWHkCwYRK3h0Supg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com, 
	pbonzini@redhat.com, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, vladimir.murzin@arm.com
Subject: Re: [kvm-unit-tests PATCH v1 2/5] configure: Display the default
 processor for arm and arm64
Message-ID: <20250114-a36510d222fc3410b9b7654e@orel>
References: <20250110135848.35465-1-alexandru.elisei@arm.com>
 <20250110135848.35465-3-alexandru.elisei@arm.com>
 <20250113-45b57478be2241a35ffa1b67@orel>
 <Z4acKHEn/dE0yLM2@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4acKHEn/dE0yLM2@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 14, 2025 at 05:17:28PM +0000, Alexandru Elisei wrote:
...
> > > +# $arch will have changed when cross-compiling.
> > > +[ -z "$processor" ] && processor=$(get_default_processor $arch)
> > 
> > The fact that $arch and $processor are wrong until they've had a chance to
> 
> $processor is never wrong. $processor is unset until either the user sets it
> with --processor, or until this line. This patch introduces $default_processor
> only for the purpose of having an accurate help text, it doesn't change when and
> how $processor is assigned.

I should have said "The fact that $arch and $default_processor are wrong..."

> 
> > be converted might be another reason for the $do_help idea. But it'll
> > always be fragile since another change that does some sort of conversion
> > could end up getting added after the '[ $do_help ] && usage' someday.
> 
> configure needs to distinguish between:
> 
> 1. The user not having specified --processor when doing ./configure.
> 2. The user having set --processor.
> 
> If 1, then kvm-unit-tests can use the default $processor value for $arch,
> which could have also been specified by the user.
> 
> If 2, then kvm-unit-tests should not touch $processor because that's what the
> user wants.
> 
> Do you see something wrong with that reasoning?

If we output $default_processor in usage() before it's had a chance to be
set correctly based on a given cross arch, then it won't display the
correct name.

> 
> Also, I don't understand why you say it's fragile, since configure doesn't

I wrote "it'll always be fragile" where 'it' refers to the most recent
object of my paragraph ("the $do_help idea"). But, TBH, I'm not sure
how important it is to get the help text accurate, so we can just not
care if we call usage() with the wrong strings sometimes.

Thanks,
drew

> touch $processor until this point (and unless the user sets it, of course).
> 
> Thanks,
> Alex
> 
> -- 
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
