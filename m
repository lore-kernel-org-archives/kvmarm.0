Received: from out-21.mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6124D17FE0
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 20:02:53 +0000 (UTC)
Date: Tue, 11 Jul 2023 20:02:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689105771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7wpPKSWBw5SPfNkCzcIKlvtgTa7z9041l05WeQlyP8=;
	b=p2knxbGe3yEElrh6ORsVsqD09+UwWkdlHYdv7AwamdXCHy7HAb9LoSpOMkPv6hVmc+gct3
	7ye/cwJk4MZUKJ2suXw/hq0Rv0vmOlvqLc2I3OKwkXsGyuGuTspq1eNqEUHG4kNOMMKI/q
	yGVOr4mOfyPNt0fsCTPvRWpGWfLFf58=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Eric Auger <eauger@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: timers: Use CNTHCTL_EL2 when setting
 non-CNTKCTL_EL1 bits
Message-ID: <ZK21Z5WB6+bTjWA0@linux.dev>
References: <20230627140557.544885-1-maz@kernel.org>
 <d49225cb-3240-ea8e-11e6-b8ed30ce2fc8@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d49225cb-3240-ea8e-11e6-b8ed30ce2fc8@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 11, 2023 at 12:35:00PM +0200, Eric Auger wrote:
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks for reviewing this Eric. I addressed your comments and picked up
your R-b when applying Marc's patch.

-- 
Thanks,
Oliver
