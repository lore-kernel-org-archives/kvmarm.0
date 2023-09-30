Received: from out-205.mta1.migadu.com (out-205.mta1.migadu.com [95.215.58.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70238B678
	for <kvmarm@lists.linux.dev>; Sat, 30 Sep 2023 17:57:48 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696096666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YP8pzHoOJhEVL/4e1lPSUV1DVqINT91qtiUeFMbVwVM=;
	b=RVGhZwpAnOY3ylOU1HW+QfCDrCjIslGJdDvhZ6BBHv0C9cI/wgz42KCbBovNQFylhSI7Ox
	t932vZozhjfgQOx83MHD0UP91RbF9vpJeFt5FXZbG01OrqekguT/Lko18ZgJT44z1cd26N
	6osboL1N/cgWA7vuOBIFZLGJjrua6mM=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	kernel-team@android.com,
	willy@infradead.org,
	linux-arm-kernel@lists.infradead.org,
	will@kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Use folio for THP support
Date: Sat, 30 Sep 2023 17:57:31 +0000
Message-ID: <169609490682.1603054.2653332700305524612.b4-ty@linux.dev>
In-Reply-To: <20230928173205.2826598-1-vdonnefort@google.com>
References: <20230928173205.2826598-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 28 Sep 2023 18:32:02 +0100, Vincent Donnefort wrote:
> With the introduction of folios for transparent huge pages [1], we
> can rely on this support to identify if a page is backed by a huge one,
> saving a page table walk.
> 
> v1 -> v2:
>   * Add git reference to [1] in the commit message
>   * GUP always acted on the Head page under the hood. Update the commit
>     message.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: Do not transfer page refcount for THP adjustment
      https://git.kernel.org/kvmarm/kvmarm/c/c04bf723ccd6
[2/2] KVM: arm64: Use folio for THP adjustment
      https://git.kernel.org/kvmarm/kvmarm/c/bf92834e6f6e

--
Best,
Oliver
