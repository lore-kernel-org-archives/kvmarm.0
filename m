Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0D82FDC44;
	Mon,  8 Sep 2025 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333480; cv=none; b=PI+vDQkWPfH7FkFhi72MAnSB3CWJoAgjgkIPCha9OxBy5dCQkYdfJbRRZ3jarwJ1RCmUwm9jgpVX/47IzcFrFbBizcibFo2gF9Zo0eOEEkI3c4WA8UnPZyf9yJL0hzgu982W1MJaYF+iUahVFrCZ4kkzpPqyFrZbCdiQLGaDaQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333480; c=relaxed/simple;
	bh=3JeRbTeLSST3KXnw3bSHqeKYTRfpq2hpWQfFDYDztc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btwxooJeBJ5koaaynlmdJ2+VxUMntmuJ1lW0+tbb7lJAPO7f/v6NKBPb+gYPe3x/Z80n1mYoMfeGlOrcemo6YzcqktjG0IG15v/2MtWDpEG1ZFzLkYc3sBc5EuU9ZCMUZikxvZRbErqRNE+rpudlVvscyZ52b2CDML6WcYYrRRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLhCW6KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLhCW6KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187A4C4CEF1;
	Mon,  8 Sep 2025 12:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757333480;
	bh=3JeRbTeLSST3KXnw3bSHqeKYTRfpq2hpWQfFDYDztc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLhCW6KP9on2cOLpJwU0kgl3Iq52UXHk39R8ATmUrJPoBhHOHXHvPSjOgo+7K734R
	 S/k5MrK8scJLaMqtglJf3R4DBEPoqCHBULmuYTpj+VKQw/ufllOJXKcjNTbQUe7nlh
	 VsTTg1ZEsUzF5EpREt/Vd/Nc2YLEMd4k2wiSt2J+l3ybfqSzPLX1tPNTZaJUwSOqjK
	 wVPh/Yqwo3lxV+8DCAiK7moMDMIvEMBosB/6jOHbrGnHxe3rZ3pI0Ls6eyK5JfjoM8
	 iANdBT6lot/t2J8n4tm+uFnlsRk+5nqdHz4NRmE9ZIqvlj7PEur0+XD5RF/qNXE3nj
	 KS6h3H1KcmUtA==
Date: Mon, 8 Sep 2025 13:11:15 +0100
From: Will Deacon <will@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, catalin.marinas@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, qperret@google.com, keirf@google.com
Subject: Re: [PATCH 2/2] KVM: arm64: Map hyp text as RO and dump instr on
 panic
Message-ID: <aL7H4-KdLba3VVlX@willie-the-truck>
References: <20250717234744.2254371-1-smostafa@google.com>
 <20250717234744.2254371-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717234744.2254371-3-smostafa@google.com>

On Thu, Jul 17, 2025 at 11:47:44PM +0000, Mostafa Saleh wrote:
> Map the hyp text section as RO, there are no secrets there
> and that allows the kernel extract info for debugging.
> 
> As in case of panic we can now dump the faulting instructions
> similar to the kernel.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/handle_exit.c    |  4 +---
>  arch/arm64/kvm/hyp/nvhe/setup.c | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 5 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
