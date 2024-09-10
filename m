Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686DC18787E;
	Tue, 10 Sep 2024 10:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962610; cv=none; b=CQiVO6aid8cKLHV8R8VVV5bHWTs1HXeYHTY+lwphGsiuPuFONu+g7MWvHUMH2ZUc5iGhRWmbn3Iqpf+f04JO0FxJhFH0waciLkeiki78OL85VoWnHIm2UIFXKlo6bmC1GbIv3fDUtOODkuQJZe/istAZ2P+QG0zJhq57yZKjxrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962610; c=relaxed/simple;
	bh=tKXQMD/Wks1mLpOCYW7Od/reIk2UokRTYt3rmY1Jm7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XRiCx3kf+aWP/uD9ds8GybK9aMVIyEhcLS0onD09UPr22mMIWxlQoTzqJOk/MaxPGkRkC2ncPCOrZbtQCnvhjouTSndZQhQ4lEtPAK013DuWfQj57boOWobcRBhAh6NyJ5OO83dZJfGVJOp15ckC/l/RujGj21sQ35hVyH6IhIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L/d6Ku0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L/d6Ku0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640B6C4CEC6;
	Tue, 10 Sep 2024 10:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725962610;
	bh=tKXQMD/Wks1mLpOCYW7Od/reIk2UokRTYt3rmY1Jm7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L/d6Ku0DjR09G4hviwphz2Dhz+DPnZlpqUcU4GKxTSAtXVNzgTvvMJpgLrUqtv2l0
	 qUJJ58ZpMe9+1l4OklZ8iWV5pP3RsfbeMwexhjopvVQNZ1hPTI/HfvqxwWweUZassU
	 EJeZ/yucq+bCrqQG3dQ+OEx+WKT4h11AfEdQxtxl+fkZXlxnZws5MW8YYkbHnkSxaU
	 6t2fiLY4ZcOuv9RLAPLBAxTkNk1e38mvZiSdD6F9jcWyz01z4xghMVKZxtCKxNudxe
	 DBaE9QsD1931yVDoNDJmTEaky6lIgSPkFfDAltH7xvSLfnSqEkrThoZ4v+3HwCDXT8
	 JMlHS4/EG1mFw==
Date: Tue, 10 Sep 2024 11:03:13 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, rananta@google.com, ryan.roberts@arm.com,
	shahuang@redhat.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v10 3/5] arm64: ptdump: Use the ptdump description from a
 local context
Message-ID: <20240910100313.GC20813@willie-the-truck>
References: <20240909124721.1672199-1-sebastianene@google.com>
 <20240909124721.1672199-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909124721.1672199-4-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Sep 09, 2024 at 12:47:19PM +0000, Sebastian Ene wrote:
> Rename the attributes description array to allow the parsing method
> to use the description from a local context. To be able to do this,
> store a pointer to the description array in the state structure. This
> will allow for the later introduced callers (stage_2 ptdump) to specify
> their own page table description format to the ptdump parser.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/include/asm/ptdump.h |  1 +
>  arch/arm64/mm/ptdump.c          | 13 ++++++++-----
>  2 files changed, 9 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
