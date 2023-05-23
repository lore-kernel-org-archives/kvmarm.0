Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8407200B3
	for <kvmarm@lists.linux.dev>; Tue, 23 May 2023 16:13:21 +0000 (UTC)
Date: Tue, 23 May 2023 16:13:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684858399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LhWcgX32vYTWdJdDtogaGEXVC2EELZrbClWPu0X5VOU=;
	b=j90Fdtqh4/lNPe6BpQZlyZo6Xt8nkV7lGmhof0FlhlQMWvYm3lAGH9zNr6/Xbv1DkXu/Bz
	vRYEjx23p4wCv7GFW8o8eJ7hh+Epinjv+frcETZK9wU+QArbvOV7eyjo8kKtwxfzDmhR9g
	tVMjsFXMQMwCA8YEqXGVN9UlbMXy2ic=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: Handle MTE Set/Way CMOs
Message-ID: <ZGzmGxkL7x7+rokE@linux.dev>
References: <20230515204601.1270428-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, May 15, 2023 at 09:45:59PM +0100, Marc Zyngier wrote:
> When the MTE support was added, it seens the handling of MTE Set/Way
> was ommited, meaning that the guest will get an UNDEF if it tries to
> do something that is quite stupid, but still allowed by the
> architecture...
> 
> Found by inspection while writting the trap support for NV.
> 
> Marc Zyngier (2):
>   arm64: Add missing Set/Way CMO encodings
>   KVM: arm64: Handle trap of tagged Set/Way CMOs

For the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
