Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804C6326D4A
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 17:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788973399; cv=none; b=nuRPbGAD5j3IBhKFT3ULEb7socMQ21grzSHH2yilnhZi5k9GRV8BWOcB9TrSVdhvB8P17SgW8GxAgjdLt7MeXKNo8rH73JKutnofkoQ+TntX+EruQIUp9hKmnQdO7x/YICb/fg7e5RSfR9W1OZMRSC0d8jkKocZIQtiuIsOtGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788973399; c=relaxed/simple;
	bh=512p7lSBvw7xCoQBN0yV7GJl74kb4lk+PPjU1dHXIlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=dTMdWQXtKTLEZR6twPxeN3eQfL2pyb/0SMlVdV54pq5S1kfuTXPHxO97/Q2KFhmJmpNsfpT2HnZKBVMDJTpKSLC9RSnNI8D/7yKfZBLfbwXLd6ULBs672IHm8QjLU8e/HNNRMlfxhXyCZrIJ+dqAvsddGB5sYvbuJVso3XVR0No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NTwgjEGo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NTwgjEGo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 37F6A1576;
	Wed,  9 Sep 2026 10:03:13 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B54403F528;
	Wed,  9 Sep 2026 10:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788973396; bh=512p7lSBvw7xCoQBN0yV7GJl74kb4lk+PPjU1dHXIlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTwgjEGog+sjhQtxbp4isbtd3o4wjAB5zOfu2pnJ6izw0A6Zy4yfUfF+WLSy8gwWU
	 p0mmuqeUyga+mogdErUqUJcuVQH4Pe4yDzpEdp4KcwKvNJVezDJ9YqA/wHXrR5bG6A
	 ZxsYHAoHzYR703S1v95m/VGp7yK/HqbzAqj7OAyc=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Peter Maydell <peter.maydell@linaro.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 12/14] KVM: selftests: arm64: Only restore SPSR_EL1 and ELR_EL1 if they change
Date: Wed,  9 Sep 2026 18:03:12 +0100
Message-ID: <aqGRUD_UdInNyWik@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-12-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-12-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:10PM +0100, Mark Brown wrote:
> When EXLOCK is enabled for ELx writes to SPSR_ELx and ELR_ELx generate
> GCS exceptions. Currently the selftest helpers unconditionally reload the
> saved values for these registers regardless of if the handler didn't change
> them. This gets in the way of EXLOCK testing, making it hard to generate
> contexts which will generate an invalid ERET since we never get as far as
> doing an exception return while EXLOCK is enabled.
> 
> In order to facilitate testing of nested virtualisation emulation of EXLOCK
> change our reloads into read/modify/write cycles, suppressing the writes
> when they would not change the value in the register.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/lib/arm64/handlers.S | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/arm64/handlers.S b/tools/testing/selftests/kvm/lib/arm64/handlers.S
> index 0e443eadfac6..367c22d61cba 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/handlers.S
> +++ b/tools/testing/selftests/kvm/lib/arm64/handlers.S
> @@ -33,8 +33,18 @@
>  
>  .macro restore_registers
>  	ldp	x1, x2, [sp, #16 * 16] /* PC, PSTATE */
> +
> +	/* Suppress redundant writes to support GCS exception lock testing */
> +	mrs	x3, elr_el1
> +	cmp	x1, x3
> +	beq	.Lskip_elr_\@
>  	msr	elr_el1, x1
> +.Lskip_elr_\@:
> +	mrs	x3, spsr_el1
> +	cmp	x2, x3
> +	beq	.Lskip_spsr_\@
>  	msr	spsr_el1, x2
> +.Lskip_spsr_\@:
>  
>  	/* sp is not restored */
>  	ldp	x30, xzr, [sp, #16 * 15] /* x30, SP */
> 

Ok, looks fair.
I don't think there could be any effect that would happen only for writing 
to the register (when nothing was changed), so that should be safe (as long 
as it does _not_ run in multiple threads at the same time.


If that's the case:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
