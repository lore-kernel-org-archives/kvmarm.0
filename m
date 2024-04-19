Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527BF131E5D
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713549609; cv=none; b=TVZym/mVF1whh+OxFjwaIkR7pgk8cUmTJgd9DjqX5bO3PFGG8I7vEjBE4MQJJnNLaLZgLTaJI6GOVNKtNzWyF62oPTS3AW2d5Y6HTbAqI8YBFSzndg7sXtTabK/3s4y1HEA54BAKOZkNbUj7HimAfKi4yNsVZ/NqqPeh2RcUzrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713549609; c=relaxed/simple;
	bh=FYbdPO6nvS8DL8aYkCKuZMeZOTMvF4UldIjjt0A7QgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZTybdbbFns3lR8R7nnLWoODGjJzH8re6DDLjJ21ImCbwKuEV3vgY4KBXOuvwIlakjpqxQXArRLAodUp65wlZNkdHBUdO8VrsVuRGQJZBvO7jg0g3B6Gb8/zyyRN9x5kvNDT8Wwbk5/E0vyNmEq7W396KuqL5Vk0gofIwgFL6orM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oIl4i+W0; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oIl4i+W0"
Date: Fri, 19 Apr 2024 17:59:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713549605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KOSmujKg3qWQnKj2ty5CaYpgKVLjxCFMsEg1pbjGs8o=;
	b=oIl4i+W06hKJLo+dQTSLUy6UUyvNZmtaXjJWsqvx9uRO5AAA+plqHivoTh0QDgaUDK25LR
	KqYss8St0lMxjfKUsFtAPb3FSfUuxSOlOY3lq6FNk/KhJi0bQo6JgX1xmZxPEFg6QoJ5FB
	l5huJHOPwqzRnOltTO4UNJy8GWYfW1c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>, Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/15] KVM/arm64: Add NV support for ERET and PAuth
Message-ID: <ZiKxHyvAAMyJQM1Q@linux.dev>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 11:29:20AM +0100, Marc Zyngier wrote:
> This is the fourth version of this series introducing ERET and PAuth
> support for NV guests, and now the base prefix for the NV support
> series.
> 
> Unless someone shouts, I intend to take this in for 6.10.

Meant to do this for the last spin, sorry:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
