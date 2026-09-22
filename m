Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B2841A918;
	Tue, 22 Sep 2026 12:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790079354; cv=none; b=poXj7JM2QJL+daPyhLpL/nnx8CiDXChT7tW+6UroXQtXIEdJUUIb+Y8ROfGiw4ZzMhlNmss9Fn7pLZ1V971JlImBuEKerl19IpBrvfUZ34if0AuXcjrT80d7XHy16pQkj0HSIKBNmF6Ar1VrC84m0wOqEZ9TVbddctI1hUE4xzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790079354; c=relaxed/simple;
	bh=VPNUyX3TZtl3siFsSmkMbcAFhvr7f98/I/jvNA3v3bI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pARENrB0yPho4qu3a0ZpRLqw7zycB62rvoomACmNUJ/ZD6jnagFH9XK16+6rlzIbyCS8dhtkp4z4ZVD0oSihhpYbi0wXZpD8uk1ysIfT9Lxdez/HXsRb2YqiLBd0qY1qd+s9FL8m5zKt4P6nnI49LrL1RIUpZwsYuW9whqVFju8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fj4Nz8fB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fj4Nz8fB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9C51F00893;
	Tue, 22 Sep 2026 12:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790079352;
	bh=JIYSRvzS+lTZK1y1XxDKW9rrYSsqjNnfXKv1cTCBldM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fj4Nz8fBrlIMtPAwuvyzWYgk2LXF8Lpt0kYzJikISSS2f0gxq5cu91MkPgMyWhjmi
	 TYz4m2gkgQqLrmbKjfBYcSmLKtH9wodN2/Y73RJQFK/57b5LQAdtG2hb2KfS+yWqCf
	 uNGH+Od6166rVnHDSiH0YgzkLIKrgic57G4b6NwkebXfJEq90QcRbBTIoiN+jCNjab
	 YExQKEHAAB7yOuSq+JSzzcGGcPv8ESaG5JOBvLB4k0H0oXfFsb46GRQRjewGO8R2SG
	 3PR5daWjK6PZ94j72UK/IRJGiA/l4632P8gg4blm110z9uU7grk6wVndtuhCAc7xSE
	 9eHOmJN2e4u4g==
Date: Tue, 22 Sep 2026 13:15:48 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Snehal Koukuntla <snehalreddy@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] firmware: arm_ffa: Add FFA_FN64_MEM_RECLAIM2
 function ID
Message-ID: <20260922-chubby-cicada-of-exercise-bbb429@sudeepholla>
References: <20260921164748.2958578-1-snehalreddy@google.com>
 <20260921164748.2958578-2-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921164748.2958578-2-snehalreddy@google.com>

On Mon, Sep 21, 2026 at 04:47:47PM +0000, Snehal Koukuntla wrote:
> FF-A v1.3 ALP5 (DEN0140 rev J) introduces the optional FFA_MEM_RECLAIM2
> (0xC4000091) ABI, which enables an Owner to reclaim exclusive access to
> a subset of pages of a memory region without requiring the Relayer to
> maintain intermediate transaction state.
> 
> Add the FFA_FN64_MEM_RECLAIM2 function ID definition to arm_ffa.h.
> 

Since the spec is still at ALPHA, I suggest to add RFC in the subject
if you post newer version so that it is *NOT* considered for merging
until spec reaches *BETA*.

-- 
Regards,
Sudeep
