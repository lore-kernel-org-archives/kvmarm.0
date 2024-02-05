Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A8A210E0
	for <kvmarm@lists.linux.dev>; Mon,  5 Feb 2024 13:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707139294; cv=none; b=I7MPccfv8wMkb/pcpIouHYPcwXFSHG/nc6vDPalhHwvEhLdbekCXDocXsjuvjWbI9HZ1pgZjtA0IPIPV44VQvBuBfZ8UHUNteiXQAzadWYW1CbLcbaaNoHIVsJDavvFKdfbGnk1lAq4r0oad3l5ARgP1B2s7+DFpadN58IntIgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707139294; c=relaxed/simple;
	bh=mDdBJfptNTRev8vYPas+YaJMyNsKhfsljBz9EaTVLlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A67t+aM3luuCbgqVhhtzcNrbpreJodGSuFtbAX5svn31JPRXZrDBQ4ncx9f1kLY+SUfn3t3rCwYoqrXLOi6rhplHI4U99PrU+5FM7P8eqGTiKz7uquQfQvnMF0pz7+8fqWHffdOk7OQPKE+ZoK5AsVhTBN4kQ+/Z5irBsMs0CIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YbgN3AeY; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YbgN3AeY"
Date: Mon, 5 Feb 2024 13:21:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707139289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r8wLnWWA4PkBzsgde5n7CqFtTqXJKCoOlinRqF4VWvs=;
	b=YbgN3AeYOgNDxaxv3aL5Fi28ARY/eOEICeZpSZRF0YfQU1YAdGSQfeldDujThmMNVzkW2y
	30AMFFza0kmkbbJaalH9ea8uNYwRzjjABMlX74rwrM1rqkPl9nnwfsR+UVZlgwsd2NQw6B
	kIbtuNJxoUI8q6fyV5ZW3UenW76RkIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Clark <james.clark@arm.com>, coresight@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	broonie@kernel.org, suzuki.poulose@arm.com, acme@kernel.org,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@linaro.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Rob Herring <robh@kernel.org>, Miguel Luis <miguel.luis@oracle.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
	Vincent Donnefort <vdonnefort@google.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jing Zhang <jingzhangos@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/7] arm64: KVM: Use shared area to pass PMU event
 state to hypervisor
Message-ID: <ZcDg1sP3EYZG-i_3@linux.dev>
References: <20240104162714.1062610-1-james.clark@arm.com>
 <20240104162714.1062610-3-james.clark@arm.com>
 <Zb1mCCi13AJ_YjFZ@linux.dev>
 <8a908ee8-620a-d9c2-734b-5a6402950072@arm.com>
 <ZcDc8-FQo8wKavA4@linux.dev>
 <867cjj6ohz.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cjj6ohz.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 05, 2024 at 01:15:36PM +0000, Marc Zyngier wrote:
> On Mon, 05 Feb 2024 13:04:51 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Unless someone has strong opinions about making this work in protected
> > mode, I am happy to see tracing support limited to the 'normal' nVHE
> > configuration. The protected feature as a whole is just baggage until
> > upstream support is completed.
> 
> Limiting tracing to non-protected mode is a must IMO. Allowing tracing
> when pKVM is enabled is a sure way to expose secrets that should
> stay... secret. The only exception I can think of is when
> CONFIG_NVHE_EL2_DEBUG is enabled, at which point all bets are off.

Zero argument there :) I left off the "and PMU" part of what I was
saying, because that was a feature that semi-worked in protected mode
before VM/VCPU shadowing support landed.

-- 
Thanks,
Oliver
