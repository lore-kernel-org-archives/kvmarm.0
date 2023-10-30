Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657751A73D
	for <kvmarm@lists.linux.dev>; Mon, 30 Oct 2023 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U7ucrjq/"
Date: Mon, 30 Oct 2023 20:16:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698696992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lw60s2vqsT+xLsSFkvhDcj7UgplRhBNRMHITqEbjoAg=;
	b=U7ucrjq//HTpf2PGatqTVMLRd2zPcYww3dIYtWyFWdl598C+OTgCK4oHmy1RqiG0dVktbd
	MxYRDVFo03sH/Jz834Jy+G/FalpSoPK4mFnseL7UQ8f175vCEMYNRUTXweJQt7rdOb92D5
	apWkI7uLedGGMRo6L+wNfJypACs5n3Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org, Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, kernel-team@android.com, willy@infradead.org,
	linux-arm-kernel@lists.infradead.org, will@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v2 0/2] KVM: arm64: Use folio for THP support
Message-ID: <ZUAPG-WU-RRDtaHl@linux.dev>
References: <20230928173205.2826598-1-vdonnefort@google.com>
 <169609490682.1603054.2653332700305524612.b4-ty@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169609490682.1603054.2653332700305524612.b4-ty@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Sep 30, 2023 at 05:57:31PM +0000, Oliver Upton wrote:
> On Thu, 28 Sep 2023 18:32:02 +0100, Vincent Donnefort wrote:
> > With the introduction of folios for transparent huge pages [1], we
> > can rely on this support to identify if a page is backed by a huge one,
> > saving a page table walk.
> > 
> > v1 -> v2:
> >   * Add git reference to [1] in the commit message
> >   * GUP always acted on the Head page under the hood. Update the commit
> >     message.
> > 
> > [...]
> 
> Applied to kvmarm/next, thanks!
> 
> [1/2] KVM: arm64: Do not transfer page refcount for THP adjustment
>       https://git.kernel.org/kvmarm/kvmarm/c/c04bf723ccd6
> [2/2] KVM: arm64: Use folio for THP adjustment
>       https://git.kernel.org/kvmarm/kvmarm/c/bf92834e6f6e

Based on the discussion I've gone ahead and dropped the second patch.
I'm keeping the first since it is a nice cleanup.

Thanks Ryan for catching what would've otherwise been a rather nasty
bug.

-- 
Thanks,
Oliver
