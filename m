Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51282146D45;
	Fri,  3 Oct 2025 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759517005; cv=none; b=LLxnBQupZlWomXn6AehV30BjaNlZ+OEOFY9RM2d3Q2i8ErXhhPZe3ieI6d23EVyOcEe70JiwJoqMrrNIp8uNDWU6zpVos/PgNuNW1ov+CU4xgQdfm+EXXxsrGDGJNZLwiXbIcZX6aijSHfurW/WwB3zjw6VpDKUR+S3t2XJfVyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759517005; c=relaxed/simple;
	bh=Qz+UBaRtpZxocqoXLqAhwwxs/LwCEkK7O5cjtMKYXPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frVaYtkZxCIl5y9QJ+0NssAR9QtWaqTBeV4/KV3yFePAi4UY4m+lPgMXLC87BXxLKQYJlKyshuFnud8SqI/ZssixhnFgqBhS07wCB2+cVf2tqQKzCuiGDOvQ7MN8RRNSH3ddygdRTPR1QNhK0/wh5uxjkz2rxVeU/WQl9ecBEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doE2HMi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doE2HMi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB34C4CEF5;
	Fri,  3 Oct 2025 18:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759517004;
	bh=Qz+UBaRtpZxocqoXLqAhwwxs/LwCEkK7O5cjtMKYXPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=doE2HMi0Mlo2gaWrBBUUGTtcKzOxx+WmlFif1p4vvY9+VGdglc4raeDQ/IDsRMFUP
	 ZX/zqeDGhl80c74pSShqVLG4TLZEneG4j81cgh0obiuYwqfKeIsm0Hh/INJBmLidrU
	 E1fb2whzWsYotfw1/8SkUxN5MYJkJjuK9pReymQ6u1MqJ3Dr4oBHsgJwqZ7zkyrt6U
	 Pq+0XtUeGvKZLqlC54iz+bvRBj/cG/y+agUrFhJN1dJUme9atyCZTZrEsK47IHbBbM
	 ff1Y6CSEjIiA1D33A1HJW2uFTVkK969K1Ke9G8Zg1FiLHzeoy1WQEicsPUxQOYYRM4
	 +yCJWdyxNQ7PQ==
Date: Fri, 3 Oct 2025 19:43:19 +0100
From: Will Deacon <will@kernel.org>
To: stable@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>, Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Kenneth Van Alstyne <kvanals@kvanals.org>,
	gregkh@linuxfoundation.org
Subject: Re: [STABLE 5.15.y] [PATCH] KVM: arm64: Fix softirq masking in
 FPSIMD register saving sequence
Message-ID: <aOAZR0-4ZCq78DZ8@willie-the-truck>
References: <20251003183917.4209-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251003183917.4209-1-will@kernel.org>

On Fri, Oct 03, 2025 at 07:39:17PM +0100, Will Deacon wrote:
> Stable commit 23249dade24e ("KVM: arm64: Fix kernel BUG() due to bad
> backport of FPSIMD/SVE/SME fix") fixed a kernel BUG() caused by a bad
> backport of upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally
> save+flush host FPSIMD/SVE/SME state") by ensuring that softirqs are
> disabled/enabled across the fpsimd register save operation.
> 
> Unfortunately, although this fixes the original issue, it can now lead
> to deadlock when re-enabling softirqs causes pending softirqs to be
> handled with locks already held:
> 
>  | BUG: spinlock recursion on CPU#7, CPU 3/KVM/57616
>  |  lock: 0xffff3045ef850240, .magic: dead4ead, .owner: CPU 3/KVM/57616, .owner_cpu: 7
>  | CPU: 7 PID: 57616 Comm: CPU 3/KVM Tainted: G           O       6.1.152 #1
>  | Hardware name: SoftIron SoftIron Platform Mainboard/SoftIron Platform Mainboard, BIOS 1.31 May 11 2023
>  | Call trace:
>  |  dump_backtrace+0xe4/0x110
>  |  show_stack+0x20/0x30
>  |  dump_stack_lvl+0x6c/0x88
>  |  dump_stack+0x18/0x34
>  |  spin_dump+0x98/0xac
>  |  do_raw_spin_lock+0x70/0x128
>  |  _raw_spin_lock+0x18/0x28
>  |  raw_spin_rq_lock_nested+0x18/0x28
>  |  update_blocked_averages+0x70/0x550
>  |  run_rebalance_domains+0x50/0x70
>  |  handle_softirqs+0x198/0x328
>  |  __do_softirq+0x1c/0x28
>  |  ____do_softirq+0x18/0x28
>  |  call_on_irq_stack+0x30/0x48
>  |  do_softirq_own_stack+0x24/0x30
>  |  do_softirq+0x74/0x90
>  |  __local_bh_enable_ip+0x64/0x80
>  |  fpsimd_save_and_flush_cpu_state+0x5c/0x68
>  |  kvm_arch_vcpu_put_fp+0x4c/0x88
>  |  kvm_arch_vcpu_put+0x28/0x88
>  |  kvm_sched_out+0x38/0x58
>  |  __schedule+0x55c/0x6c8
>  |  schedule+0x60/0xa8
> 
> Take a tiny step towards the upstream fix in 9b19700e623f ("arm64:
> fpsimd: Drop unneeded 'busy' flag") by additionally disabling hardirqs
> while saving the fpsimd registers.
> 
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org

Sorry, Greg, I lost a stray '>' here ^^^  and so you didn't end up on CC
for this one.

Will
