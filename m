Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4643E513557;
	Tue, 29 Sep 2026 11:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790680532; cv=none; b=MeOqLYw65sWH7I3XfdUTBqDByUh9oQlGomfSZ5m+wab8KQgIsXbeNcNj2dBsqz94NGDWmwFPDaCMmy8hmhOQlus6DtGm+ZW+0FpV/zv7BNu/vPYEuPhnceKc/Xw1osEwdhEky4wOJie+V+N0HeY4RqldRFU9FfT71egG6lJzT1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790680532; c=relaxed/simple;
	bh=EtNt9F69mUNykSq1XAoSHpVt3uxqbxoxtVDWc5Yc2vI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTAGIyXT5XvJzQUjKE4EcGAoGPvB6mKKH7G6D1QoeelBNQO6aJqQkP6nOLuh+m+9CI425wJptlFetN3j+hdMVDJdoJ6Wc0cXpPYdEuwTAx3xp0pQsAS5ONBuMaPsbU1kXvjSREGmJnSnuW4W7rov2sQvhBHnF5G3XPfy4UNbpKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HKKnIXWO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HKKnIXWO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A4DA1476;
	Tue, 29 Sep 2026 04:15:27 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF92B3F85F;
	Tue, 29 Sep 2026 04:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790680530; bh=EtNt9F69mUNykSq1XAoSHpVt3uxqbxoxtVDWc5Yc2vI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HKKnIXWO9ePgXYN5lZU7WKIkJ0Y694l06KK62Inm5ufByUbczpRB9bQBMtH9v5bnQ
	 AQkn5Lmrvfbs93lO7iRfn0fUAa7py5AwI87D0K+JsmeaV7B0LWyNW19HOQLOPTjr9a
	 oZT4lHdURk5GeAsxycjGKA6wrzyHdzI0gOaRcxuA=
Date: Tue, 29 Sep 2026 12:15:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v19 5/7] firmware: arm_rmm: Activate the RMM
Message-ID: <arudWVBPXcnUvYNh@arm.com>
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-6-suzuki.poulose@arm.com>
 <arZmXFw5Jw2IbAmA@arm.com>
 <a11aba04-eaaa-43fd-988b-a2581b1b2fdb@arm.com>
 <araketG70TIKeNuf@arm.com>
 <12e83d88-de4c-4230-aac2-1796123320ad@arm.com>
 <70d47475-e26e-40e1-b409-b0c16aecb8c0@arm.com>
 <195cdfe4-a55a-453f-9c34-620738eca244@arm.com>
 <arqrZ_Auk9BYOopa@arm.com>
 <0f68dcff-1dfe-4515-9912-515ca6457674@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f68dcff-1dfe-4515-9912-515ca6457674@arm.com>

On Mon, Sep 28, 2026 at 07:28:20PM +0100, Suzuki K Poulose wrote:
> On 28/09/2026 19:01, Catalin Marinas wrote:
> > possible, to defer the RMM activation until the first user (still do the
> > RMI probing as an initcall). If we run on RME-capable hardware and
> > firmware but don't care about realms or TSM, we still get the normal OS
> > functionality.
> 
> Would you prefer this in the first drop of the RMM ? Or is this
> something we could add as a separate series ?

I think we could add the deferring as a separate patch, maybe together
with the KVM bits. An advantage of keeping it here if we merge this
first is that we still exercise the activation path without full realm
support or TSM. Otherwise a lot of this would be dead code until the
other series arrive. Either way, do it as as separate patch on top of
this series.

-- 
Catalin
