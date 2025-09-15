Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C522F998B;
	Mon, 15 Sep 2025 10:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757933690; cv=none; b=mrVvgipOJFHDDZF/A6kOQx377fCdaYSBwgwrzBvHo2zhrMjn37yeoll98uK2jYhhmKMk6R3oTEly5v/1WIADnfHT8AYfkOCR31mql+JruUEq16g3vm5mtJq4On7XqYsoikyMFv2x73t4shU41Z/0LGFQCkDVZxwnWxIQX7HGyME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757933690; c=relaxed/simple;
	bh=M8SkjZeU6dCQfX1o6+UMsowRF/3INQ8dsl4CaGbWqqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8X7BdX4GAn0mSfX1sD7iNFH8hjoL/PB8cyVy/+1kENXKxbYRdRbLDk9Tx1jWALQsyncMstyZsPuQm61E5GGYJYH5xcBbVN8VYS+9Kk9LpAa05lz2CCi4wOihOyLRiNtYsXiSugvjZVyQHKPPo3Pt2+PYBYdVTSMbI165IYbgCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1U5sYUY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1U5sYUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0975C4CEF1;
	Mon, 15 Sep 2025 10:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757933690;
	bh=M8SkjZeU6dCQfX1o6+UMsowRF/3INQ8dsl4CaGbWqqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o1U5sYUY5kz82KPEBxqntZ4xF+CeO4mdugufCCwjY2xPgnOpKd6lomFQG/BcIMJ30
	 px3qnfcuRYLH5IK6fPCMM1++uXk/u0qYlHpZ5jimcN2Ww+7H5GCSrAYZPlmqwW/0jm
	 ZZmvRjJs31fK8XefSmzks29tryaDMSzzCQsydp+v3O8DGKVUDr2tKSQpPfa07E6Qgw
	 bDNiw9u8ZgvL7dVnEYFOHciOo24iC4Or285ehQlAGewxgTbuTwOWvuYXKw2N2QqJ/W
	 rUzDVenaolwbBNgU3d68tswnHBnvjuVok/mtQanoOgo+rowaoAWFGgO9AuXB7xbTPy
	 xI19zRGDJCSYQ==
Date: Mon, 15 Sep 2025 11:54:44 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, perret@google.com, keirf@google.com,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Dump instruction on hyp panic
Message-ID: <aMfwdInqPCiqc8rn@willie-the-truck>
References: <20250909133631.3844423-1-smostafa@google.com>
 <20250909133631.3844423-2-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250909133631.3844423-2-smostafa@google.com>

On Tue, Sep 09, 2025 at 01:36:30PM +0000, Mostafa Saleh wrote:
> Similar to the kernel panic, where the instruction code is printed,
> we can do the same for hypervisor panics.
> 
> This patch does that only in case of “CONFIG_NVHE_EL2_DEBUG” or nvhe.
> 
> The next patch adds support for pKVM.
> 
> Also, remove the hardcoded argument dump_kernel_instr().
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Kunwu Chan <chentao@kylinos.cn>
> Reviewed-by: Kunwu Chan <chentao@kylinos.cn>
> ---
>  arch/arm64/include/asm/traps.h |  1 +
>  arch/arm64/kernel/traps.c      | 15 +++++++++------
>  arch/arm64/kvm/handle_exit.c   |  5 +++++
>  3 files changed, 15 insertions(+), 6 deletions(-)

Thanks for the respin:

Acked-by: Will Deacon <will@kernel.org>

Will
