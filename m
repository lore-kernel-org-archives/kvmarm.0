Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD92171A3
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 14:59:56 +0000 (UTC)
Date: Fri, 9 Jun 2023 14:59:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686322794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tjX8DzT+VkdDDHfdUii6WZAg+8YtJ/Le8qPqCL2aFIg=;
	b=W1j3MzafFpna6foeRceMZoNVh+mGTUjdhwuAw8nMLJT3L1F1f2IJN6Mf9KJOvSOuRuiO6Q
	1jLF5iAJd183k0VguYGNXFIS9TJy6XND+BMHrqBRkf04HI+VKUCz6lKW9nd+kjPKJMf2f1
	PgNbT9fvR4pH0UChxo/8rFuqqN6KiH4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] KVM: arm64: Skip break phase when we have FEAT_BBM
 level 2
Message-ID: <ZIM+ZgFji/H3Y/9U@linux.dev>
References: <20230602170147.1541355-1-coltonlewis@google.com>
 <20230602170147.1541355-4-coltonlewis@google.com>
 <87sfb7octw.wl-maz@kernel.org>
 <ZH5VQMEoiHEITmF4@linux.dev>
 <20230608172112.GA1606@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608172112.GA1606@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

Hey Will,

On Thu, Jun 08, 2023 at 06:21:13PM +0100, Will Deacon wrote:
> > IIRC, Colton was testing largely with permission relaxation, and had
> > forward progress issues b.c. the stale TLB entry was never invalidated
> > in response to a permission fault.
> 
> Would the series at:
> 
> https://lore.kernel.org/r/5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com
> 
> help with that?

Heh, that's a rather interesting patch :)

I don't think it is directly related to the problem Colton encounters,
though the symptoms are similar. This crops up when KVM uses a stricter
permission set than the primary MMU, like lazy X for deferred I$
maintenance and write-protection for dirty logging. KVM policy led to
the stale TLB entry, so KVM is the one that needs to initiate the
invalidation.

-- 
Thanks,
Oliver
