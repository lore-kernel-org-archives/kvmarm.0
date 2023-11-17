Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D647ED
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 00:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c3m1wWtG"
Date: Thu, 16 Nov 2023 16:46:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700182026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5jMsQ9EkAribJYX382KZh4nD9dGODzZN07cKFgZWVAE=;
	b=c3m1wWtG7pkzaGC5A4/aZ80IMtRYKTytn1CdCS54tZn4+JQs1+uPGiNjqOTHA1SmgrjMdO
	3mau6n1Uch8HLGBJWgbkR0fONbp/DlPC4kyDIeFzEYtipi0BtskqOcj9lkKR7MyFUvy8bH
	VwSNpSbgy/lIQnvoFBhBS+Tl8ZQfN6E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 02/12] arm64: cpufeature: Correctly display signed
 override values
Message-ID: <ZVa3+zcy0og0AP9h@thinky-boi>
References: <20231113174244.3026520-1-maz@kernel.org>
 <20231113174244.3026520-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174244.3026520-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 05:42:34PM +0000, Marc Zyngier wrote:
> When a field gets overriden, the kernel indicates the result of
> the override in dmesg. This works well with unsigned fields, but
> results in a pretty ugly output when the field is signed.
> 
> Truncate the field to its width before displaying it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
