Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074563D6
	for <kvmarm@lists.linux.dev>; Mon, 21 Nov 2022 18:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11659C433C1;
	Mon, 21 Nov 2022 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669054147;
	bh=/7KHXu25uYdxptbYApPiI4X6tmxB+JZaBclz27zxScA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s/GpyKDjXOFYp5ugSCAdXo1NhlB2IPARJM3jRaplMsXTLpV8lxciaQnUUyxQquulK
	 KzEe49FCFaD8LuZy5w40TIz8akrFGG53YphhnwI5jTjvzL+/8C9YHEIelrPhT2xilp
	 CFcT+oCqfydITYFEx1ZK3OI+iuL03YCEyIygLd19LEeKPQQ8m2HuC9LebUr+2cA4i0
	 /MoOm0DInv0d9t1r/8qvWSt0x+gJwsPr+mi9mVlqj1ORRgENAhZmHOZfClgfcbHTBE
	 XmnydxyEqRfCurqpHdYQZDorzFQqvAhcZmuPCp/ecd0IWnHVtsC41IQui39XQPk8/f
	 yyvZa3qp0B0/g==
Date: Mon, 21 Nov 2022 18:09:02 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 0/3] KVM: arm64: Fixes for parallel faults series
Message-ID: <20221121180901.GC7645@willie-the-truck>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID: <20221121180902.wohTZDOiXHKbop7h1ZDS1km8n7z0vukON56vnjemlU8@z>

On Fri, Nov 18, 2022 at 06:22:19PM +0000, Oliver Upton wrote:
> Small set of fixes for the parallel faults series. Most importantly,
> stop taking the RCU read lock for walking hyp stage-1. For the sake of
> consistency, take a pointer to kvm_pgtable_walker in
> kvm_dereference_pteref() as well.
> 
> Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected} and
> lockdep. Applies on top of the parallel faults series picked up last
> week.
> 
> v3: https://lore.kernel.org/kvmarm/20221116165655.2649475-1-oliver.upton@linux.dev/
> 
> v3 -> v4:
>  - Return an error instead of WARN() in hyp for shared walks (Will)

For the series:

Acked-by: Will Deacon <will@kernel.org>

Thanks!

Will
