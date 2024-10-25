Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38764AD21
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 01:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729820223; cv=none; b=pb3rh6oeMBPYEAzpGzVQumvaiAo/UcO/m1o9NAjY6F00frI/hzxjnFkGyfbQU+Hlbi35vLLWj4hx0H1f/baOd1wUEkS2p0bFlDsAGeEtHcr+zQ1K6O1Y4fNIr6w0O5byzMsRmfrKxpl1q/Hv2rYBYnsTBJ9urR2Ea5YvQu0a76g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729820223; c=relaxed/simple;
	bh=kPBCVEBzaiEagZHQCnv7YrvCpYXUQgTapEl12I5nHgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XjeioGYi0AgIWChvfkMlZkDE2nAR6/buhDkqlIAIYdfebo8HERPUpwBfY++xqCgo8HK2RMJzVWusPf8D91y57quPjsyea3tMC9UjsYRmQ9420UEhNgzor1pzQxON6jtg5/CsP4AlCyCr2l5YcN9ZG85lCl+29Au7mAYWWapbeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JTrjtpcq; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JTrjtpcq"
Date: Thu, 24 Oct 2024 18:36:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729820219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hnRaFxFpFEv19fj1eX9QscgeHHUR4ARW9MlazyjczxY=;
	b=JTrjtpcqlV3yU6F1T7SlXslRHeDK7FJG3ZJW+nuJIzSPOn7s2Z5K7EszB4bplxgstaYijk
	D7jlnmFKxDNPR4woVsGSzQuoKaAdUAikyWJn++pg7XSla0wKXj0O3p0Lw86tXYCeMWZQ73
	3HNucWiNwH6swpsivGXXcpv9J+Ls/eY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, mark.rutland@arm.com, cohuck@redhat.com,
	eric.auger@redhat.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, jiangkunkun@huawei.com,
	jonathan.cameron@huawei.com, anthony.jebson@huawei.com,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 3/3] KVM: arm64: Enable errata based on migration
 target CPUs
Message-ID: <Zxr2JMNzOWT3zPWH@linux.dev>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
 <20241024094012.29452-4-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024094012.29452-4-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

nitpick: shortlog shouldn't use a KVM prefix if the patch isn't touching
KVM.

On Thu, Oct 24, 2024 at 10:40:12AM +0100, Shameer Kolothum wrote:
> If the Guest has migration target CPUs set, enable all errata
> that are based on target MIDR/REVIDR.
> 
> Also make sure we call the paravirt helper to retrieve migration
> targets if any.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

I don't know if you saw my suggestion on v1 [*], but it'd be great if we
can hide the array of implementations from users of is_midr_in_range()
and friends.

There's other junk keyed off MIDR (e.g. Spectre) that also needs to be
aware of all the implementations where the VM might run. The easiest way
to do that is to stop using a caller-provided MIDR and have
is_midr_in_range() either walk the array of implementations or read
MIDR_EL1.

[*]: https://lore.kernel.org/kvmarm/ZwlbTCwoKQyh3vmF@linux.dev/

-- 
Thanks,
Oliver
