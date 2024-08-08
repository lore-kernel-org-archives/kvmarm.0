Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D661474A5
	for <kvmarm@lists.linux.dev>; Thu,  8 Aug 2024 23:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723159206; cv=none; b=hOozVDKSjKbwxOH9Yh8Xh7YYfhZoMb7HUs+1BdcusAe0UasgHFsKknueFR3MQfgQLuaw6GXpWInwGulOHK/SVr5MTGTWbYc8OZA9eS7+8CpgRssC5QRB+FwfkmB/63nIA+S/qAf+xFNFxlMTWOLvgn8FQO3eXu7FaP0lrC9x06E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723159206; c=relaxed/simple;
	bh=i/AtlWsPJJjUXMcBgUzpCiDbqISNbD37D+nqHmYNV8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCGp+YhVsDcFJHTy1JCHVunJ16AFb3xNfdVgHHvyr0UfAnZmli+6HHD54nwTOq4RtskkWaVaHjnneGkJZboCCDfPgmKbXQr8cmodjbqSLj3z+Eit9nRme+gvxAbfou6cxFkKS9JDaAdtQGglF/0nb4drbWL8hQPYKNGbgKDd7EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wBP/JqjJ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wBP/JqjJ"
Date: Thu, 8 Aug 2024 16:19:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723159200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YUVqsyvuuqd3EGANDtFg25g5rz458MXufVkUSQ2tFo8=;
	b=wBP/JqjJS/jqJGckbKURoEzLSU/ifQ0Bx/Dh+5ffIhrjAc7P9UBxnLQ+KLlHhXhcvHKRUj
	RW9EbngFYGzJS1PauH/ZXf1CZfcH9noD4Bn6hg/bXU30I38KnhiejSCbNj7CMpUOuZFaDe
	R4pvPlRmAvsc3HYAR+Vh3ewii2y+jFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Disable OS double lock visibility by default
 and ignore VMM writes
Message-ID: <ZrVSlbVwnaMDShah@linux.dev>
References: <20240808125711.14368-1-shameerali.kolothum.thodi@huawei.com>
 <ZrUC5O8XUuvlLJcc@linux.dev>
 <f81365c28d1b4ae1a5e9c2345d24b2c7@huawei.com>
 <ZrUO_RG6a9We7neT@linux.dev>
 <f41074b4b460431e9830bc717b8a58b6@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f41074b4b460431e9830bc717b8a58b6@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 08, 2024 at 06:38:41PM +0000, Shameerali Kolothum Thodi wrote:

[...]

> > 
> > Would you be willing to cook up a patch that just opens up the
> > DoubleLock field to downgrades?
> 
> Sure. Will do.(And we might need more as well. Let me see.)

That'd be great, we've been playing a game of whack-a-mole with the ID
registers for some time. If you could handle all of the other fields
associated with the register(s) you need to tweak (e.g. DFR0 in this case)
that would be *extremely* helpful.

-- 
Thanks,
Oliver
