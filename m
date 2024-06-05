Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F82FFBFD
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 19:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717616472; cv=none; b=LwP0flECoUNnKcsM35cOhH4aT138L/KG6RgGtGIJnjJt+zwR3pTWsVj677Ho/7bmHrM7Wdp5p5SXgf0qo4ojwXqV9gGOtydBT/OwVqwm9AivMcMERIj1CuM+jB2Fvh9Z6VgCkrcLKYw/rdz5HwA/MVus7Z5ngx6TLwI4oAsuYn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717616472; c=relaxed/simple;
	bh=5ibj/fnmpZiIwzxbzLrcku79RVFzUFCq7Xnrp7YZuP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiiGSdDCJl/IQD22i8Ed95NKbQ8R2O5tAjWpi/LdENu6qkmanWgsEUxWpPA3AXTdGTfmVw7kfnsgbq3F62GZyPwiuu5nWbdRU6vYyllHilGMLr1hrIG0SmXZ0njzczme5thWj+c7fxha/b7GeOjdiE0liQSYfRZmogQjHy7U0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lC1v9PCv; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lC1v9PCv"
X-Envelope-To: maz@kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717616466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lxpi+HI6W0ywsNLdUWfFgg8K2OiK948hs+eRJnTEKKE=;
	b=lC1v9PCv2LbPYZLoFgjoWuwM5frZgzicuBp3WDk5/HHIkgm5WN3G4Ac9+Wmshgh1hdN1I/
	Lp/8SGlnm7KOyTAbSbbP5TPMxMenlAGt0ZeMX2xzrU6tpPkYke/d4W5GIFICBmr9+anKkM
	j0beBK4vrbQWlwGysf9vVDmG8k64Z/w=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: glider@google.com
X-Envelope-To: stable@vger.kernel.org
Date: Wed, 5 Jun 2024 19:40:59 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, glider@google.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Disassociate vcpus from redistributor region
 on teardown
Message-ID: <ZmC_S5FZM2pXecSr@linux.dev>
References: <20240605175637.1635653-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605175637.1635653-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 05, 2024 at 06:56:37PM +0100, Marc Zyngier wrote:
> When tearing down a redistributor region, make sure we don't have
> any dangling pointer to that region stored in a vcpu.
> 
> Fixes: e5a35635464b ("kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Reported-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
