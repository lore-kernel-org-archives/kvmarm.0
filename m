Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F028DC4;
	Fri, 12 Sep 2025 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694339; cv=none; b=jLH/+B2qts6fqpwmJyOCEq3oVSUYeossmwkbDhyHVZI9KAdbHOHclqk+JCge32VzD3GQVVRAUo4daAmtsDieU13jsxOJYK/wHaXnkcZ64pyFAY4h6T7gR6oFszkD+UNejaznf3+odb0933BX38SUfoG0b35gwDNOXm3XmfX2ao4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694339; c=relaxed/simple;
	bh=5jFyWKTb+HBOzg7Ao64TOZljfH+qFk4BcZoOJV2HFpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lkcu+GR3ZRJlvYzFYDoMfnxtjoODyj0oM+TILUVkyTZKSIRsu+uBOqhOVA2YgjkduP7iS77VhtuPLSEul6Pmp2btnZkMuDNfdiYGfxRuGPMCfnaVawczXJdqaBeyPOS9I6CRHUvmHtddkoP0c+KThQXC0Z7Yg+SBwGYaSxKL8YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F054C4CEF1;
	Fri, 12 Sep 2025 16:25:36 +0000 (UTC)
Date: Fri, 12 Sep 2025 17:25:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 2/6] KVM: arm64: expose FEAT_LSUI to guest
Message-ID: <aMRJfYKj8l5UKBxm@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-3-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816151929.197589-3-yeoreum.yun@arm.com>

On Sat, Aug 16, 2025 at 04:19:25PM +0100, Yeoreum Yun wrote:
> expose FEAT_LSUI to guest.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Acked-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
