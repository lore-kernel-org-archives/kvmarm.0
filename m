Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DBE322C73;
	Fri, 22 Aug 2025 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755872718; cv=none; b=rynf0Vh9yiaLxI3TBcQlx54eTgtIlp7ddeHKx+GKUlayI1Nou+epUd3XC+tcL30G/7zKGbiKd8bisHp8ShAltcCrc5vaazRsJpjhQ/beI3Y4uQ7xKe8BUMfJV+7M+yjWUBtAjPUwBHKgehw57kUk3liSEd3i27yy+gw6DNUqNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755872718; c=relaxed/simple;
	bh=hd4mU3eVfUpI8O+XIWVhc+/UeFGUawqGS9Ci7m0C8Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OK31eXVRVnZhBAQZAsMzXuqLncPbOuF1q7g4PhvnngPUE0B/nwS901PGjzRhoqbdRtWgL0mLthEAterw94vhaXEqUhPaBDlSFdCZbGzqgCcs05aMhTcDKA3x855dDbRvQHDZcALDQJQpW0SAY7lvrrIUoW2Jgf8vsadBh81tGGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kc+8Fmg2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kc+8Fmg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95107C4CEED;
	Fri, 22 Aug 2025 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755872718;
	bh=hd4mU3eVfUpI8O+XIWVhc+/UeFGUawqGS9Ci7m0C8Qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kc+8Fmg2j5u6iZ8MOCY+V2p8A7pE4SoLN+xUG7lq79Vhcawfgh37AUZgbc55y8um3
	 gP4ChwRQS/Mgy15Pp8TvfXuMqNzWOc6vT7v1weB04IxsnN2JV++6ej0Z97ndBwGTwU
	 MsbMOxjiYo7VpU9YpkVSuVhnmrKoG/Hk+0tZtTfM=
Date: Fri, 22 Aug 2025 16:25:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
	Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [STABLE] [PATCH] KVM: arm64: Fix kernel BUG() due to bad
 backport of FPSIMD/SVE/SME fix
Message-ID: <2025082203-stream-carless-e5d9@gregkh>
References: <20250822140402.2688-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822140402.2688-1-will@kernel.org>

On Fri, Aug 22, 2025 at 03:04:02PM +0100, Will Deacon wrote:
> Upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally save+flush
> host FPSIMD/SVE/SME state") relies on interrupts being disabled during
> fpsimd_save_and_flush_cpu_state() so that a softirq cannot be taken
> while the host floating point context is being saved and potentially try
> to use kernel-mode NEON.
> 
> Unfortunately, stable kernels without 9b19700e623f ("arm64: fpsimd: Drop
> unneeded 'busy' flag") leave interrupts enabled in
> fpsimd_save_and_flush_cpu_state() and so the BUG_ON(!may_use_simd()) in
> kernel_neon_begin() has been observed to trigger in real-world usage:
> 
>  |  kernel BUG at arch/arm64/kernel/fpsimd.c:1904!
>  |  Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
>  |
>  |  Call trace:
>  |   kernel_neon_begin+0xdc/0x12c
>  |   ...
>  |   crypto_aead_decrypt+0x5c/0x6c
>  |   seqiv_aead_decrypt+0x88/0x9c
>  |   crypto_aead_decrypt+0x5c/0x6c
>  |   esp_input+0x280/0x364
>  |   xfrm_input+0x6ac/0x16f8
>  |   ...
>  |   net_rx_action+0x13c/0x31c
>  |   handle_softirqs+0x124/0x3d0
>  |   __do_softirq+0x14/0x20
>  |   ____do_softirq+0x10/0x20
>  |   call_on_irq_stack+0x3c/0x74
>  |   do_softirq_own_stack+0x1c/0x2c
>  |   __irq_exit_rcu+0x54/0xb4
>  |   irq_exit_rcu+0x10/0x1c
>  |   el1_interrupt+0x38/0x58
>  |   el1h_64_irq_handler+0x18/0x24
>  |   el1h_64_irq+0x68/0x6c
>  |   fpsimd_save+0xe4/0x130
>  |   kvm_arch_vcpu_load_fp+0x2c/0x58
>  |   kvm_arch_vcpu_load+0x88/0x26c
>  |   kvm_sched_in+0x2c/0x3c
> 
> Given that 9b19700e623f ("arm64: fpsimd: Drop unneeded 'busy' flag") is
> not a fix in its own right, has non-trivial dependencies and is a
> reasonably invasive change to the in-kernel use of fpsimd, opt instead
> for a simple fix to use the softirq-safe {get,put}_cpu_fpsimd_context()
> helpers in fpsimd_save_and_flush_cpu_state().
> 
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: <stable@vger.kernel.org> # 5.15.y, 6.1.y and 6.6.y

Now queued up to these trees, thanks!

greg k-h
