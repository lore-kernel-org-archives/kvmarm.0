Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972FD1885A5;
	Tue, 10 Sep 2024 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962726; cv=none; b=ZdoJV9LcEyfKGuAqkLE2PClUMntkSW2gJYuCQk5EAZaVMhSth/cVfGYJy0kiezoU/9O/FpcWeY6o2wueZUN/sSrHOzJOhxXivudMfUtMGG8sbV15crtEHT4RIBnxlhPKKWhF+N0JlXqlmGThveYfshHRVJnUaJt2mH61r9NUYLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962726; c=relaxed/simple;
	bh=DLrMOWYFV1dYuWjvZRcOpD1VWr/pzu3RG8p181wCNqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNnw//S5jMt7egSjxaEThDiYIAtcVcbjLfGU+gble0thC/rtOFcz8KewEjfXKbU9SuJmmYwwH52H8dgXN/+v6ctke6Nr3Nipmky6X0Qz+m6k5fK90wlZfjdxuOjRk0vzkz17GwEDehjkVn6rF7D//RDJnbmiHjyMy3BUJpBECQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyDw6Z2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyDw6Z2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0674C4CECE;
	Tue, 10 Sep 2024 10:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725962726;
	bh=DLrMOWYFV1dYuWjvZRcOpD1VWr/pzu3RG8p181wCNqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QyDw6Z2VSdVrcTO1xBJiH/TK9lMkjBG2boW4cmgvG3+kmQlhVMUUrqr4N7Y71FZzG
	 r1DEB3QDEUQyCxDJiXE0BdBq4Nbd5oW2kuePdWNdasaUyYcF/G/yFpWTKgM9OSgvP8
	 vnnIMmhYSsUioJOkqfv+/No7fu4Yjk1x91yQfeG8NeLekay1QHFRH8uMcNSER3vzDA
	 8WRzhKKoX9O17xpZffwXdbceRmaR123cobfp+7GfY7rgw/8fqEGNayniVQ4GZ6veWi
	 vmCHgbiF8Et5Gw6AjZcweveyJDsF3uZ6iHxtnqs5jDRZRxXn/XtfI6ZNsbvzvjn06R
	 53xDZG6vihgxQ==
Date: Tue, 10 Sep 2024 11:05:19 +0100
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
Subject: Re: [PATCH v10 4/5] arm64: ptdump: Don't override the level when
 operating on the stage-2 tables
Message-ID: <20240910100518.GD20813@willie-the-truck>
References: <20240909124721.1672199-1-sebastianene@google.com>
 <20240909124721.1672199-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909124721.1672199-5-sebastianene@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Sep 09, 2024 at 12:47:20PM +0000, Sebastian Ene wrote:
> Ptdump uses the init_mm structure directly to dump the kernel
> pagetables. When ptdump is called on the stage-2 pagetables, this mm
> argument is not used. Prevent the level from being overwritten by
> checking the argument against NULL.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/mm/ptdump.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
