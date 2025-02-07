Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B99B175D5D
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 18:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738951809; cv=none; b=ZEtJhXbd2TCXn6R5cH/f4qJNnMcE5v5Ta7zo9LNj/bHqtTowEV5uvtoEfq973seFws091Z8BqbKsMMHGVyG7SfsIQVYPaTn+lu/kGlmXs+anCkiZLB78e/B0tj4ieHiEuucGf+uo0xkqOyfeylV2lsvMzqdKvhqBX5LTKcUSQY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738951809; c=relaxed/simple;
	bh=+G+YBZTgA9QIbY2A+UZYK3QXLmcb1dpBWlg/zQMm6Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eh2t1Hpcnpg82DrKAB63ZmF114HdgNTb1e3SSbf+MY1YWW7NWgeU0C2DzrOUIP7SgddNsqrUO8GoAeoiwVuu6xjIhGzAWK1TVyXpd+WGUpZAxSgBBnB1H4+qiZgW5mkJoFkMiPhdM/vcE9XQG7D/iIHD/ZE9FMUlUnCKF7aqI7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DBeVwjXj; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DBeVwjXj"
Date: Fri, 7 Feb 2025 10:09:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738951803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZolRaIlCgaZRdZ2y7P6BoM5Dq+0ObR3jHsmtYgVaSNI=;
	b=DBeVwjXjnPTYpQs6Lq9Mvygma9/LdKK5EEukS36yscCrnbkZZcopW5h0QH0FR9304mEJVg
	Xlr/eeKMf+3R0mb40Kic+82+T0Sp+HGlGTQFnlHe2KBXWxMaPSOoRxAfoJk472uVfK3Kh2
	TQvD3khEOYtwiOiOb/dYlH+PWd6e21k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	kvmarm <kvmarm@lists.linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	christoffer.dall@arm.com, suzuki.poulose@arm.com, will@kernel.org,
	catalin.marinas@arm.com, coltonlewis@google.com, joey.gouly@arm.com,
	yuzenghui@huawei.com, darren@os.amperecomputing.com,
	vishnu@os.amperecomputing.com
Subject: Re: [PATCH] KVM: arm64: nv: Set ISTATUS for emulated timers, If
 timer expired
Message-ID: <Z6ZMdv8jJUvYwQzT@linux.dev>
References: <bcb4289b-507c-4ea1-afc7-6febd34d88db@redhat.com>
 <86y10osr19.wl-maz@kernel.org>
 <4d443db1-85b1-4071-acd5-3187deb9cb17@redhat.com>
 <2f6b2cb1-3d32-480a-9801-9b993ae74e2d@os.amperecomputing.com>
 <152d262e-641d-4bb1-9656-a13e049d62c4@redhat.com>
 <86h661wje4.wl-maz@kernel.org>
 <4a9fbdd9-ad23-44bc-8ba5-399f08068db4@redhat.com>
 <86cygpwfy0.wl-maz@kernel.org>
 <b22d5916-8b55-43bc-a256-2136d66ad25f@redhat.com>
 <86frkptzr6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86frkptzr6.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Fri, Feb 07, 2025 at 05:45:33PM +0000, Marc Zyngier wrote:
> I found at least one issue that could fail the migration. Before the
> VM starts running, we limit the feature set to the subset we actually
> support with NV.
> 
> By doing this, we also change the value of IDreg fields that are not
> writable, because they describe features that we don't support.
> Obviously, that fails on restore.
> 
> I need to have a think...

We spoke about this a while ago (and I forgot til now), but I was
wondering if we could use vCPU feature flags to describe NV, including
the selection between FEAT_E2H0 and FEAT_VHE.

I think this might match userspace expectations a bit more closely where
the state of the ID registers after init gives the actual feature set
supported by the VM.

-- 
Thanks,
Oliver
