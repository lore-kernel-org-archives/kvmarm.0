Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091228643F
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 22:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321392; cv=none; b=gJAkfFEO2t6oE3rvh9Ptq5osNRICztb/2x7lJzdu5CjNsTx1Z7jVofb0e6dkUfiG+jtK5rZB5/Cc9AjVXVaGOoO/4LQYBbkDZtGG+VvY9IUEeTS+kAEQEA/6wHKYb0hyWWAgTx3479rJcwOHl76bEjc8qzykqk20wC2+WHlfgAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321392; c=relaxed/simple;
	bh=7eDpY1eMh5dYeqhmTzFwn1dyzrTn2HojODaQiNIzJsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhGLv5cwe7p5s3WsOgwB8E1daZ7M9Rkp8x7SPvKsn/+0K/8ruhXcP+FrFbQa3yErVStCw03S0vvMeV9Gxz1tw+uEimKDQm/BDNT6lBHiKnu0F0WhSPmXXJKTrJY1R3kcEZFGsUVLfTb8gPXGV9TMESZyI2awzrigIi8GlhWdot4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OZh7Dlt3; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OZh7Dlt3"
Date: Fri, 19 Sep 2025 15:36:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758321385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JXFpc6ThiFcP26DmQ5iR/Po6IMjawdunmjqXPNzL7xU=;
	b=OZh7Dlt3NZ7BUlUFPjvmF1/oi5L3bmy8XMqUVWs0HN+KkAnj+j/kC6NdQnj2tvgXzaiH+N
	dbPBx4++rzSOmiimw92MHBmrzm1L4aqh4cVZMIVm2MfW59HqqESsCNZvhkHvd/FCo7+5Th
	9/5Akdc0/TlrWdygZOdq/Vdx8H4Bnz0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 16/16] KVM: arm64: selftest: Expand external_aborts
 test to look for TTW levels
Message-ID: <aM3a30SHqFRNgGcm@linux.dev>
References: <20250915114451.660351-1-maz@kernel.org>
 <20250915114451.660351-17-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915114451.660351-17-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 15, 2025 at 12:44:51PM +0100, Marc Zyngier wrote:
> Add a basic test corrupting a level-2 table entry to check that
> the resulting abort is a SEA on a PTW at level-3.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  .../selftests/kvm/arm64/external_aborts.c     | 43 +++++++++++++++++++
>  .../selftests/kvm/include/arm64/processor.h   |  1 +
>  .../selftests/kvm/lib/arm64/processor.c       | 13 +++++-
>  3 files changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
> index 062bf84cced13..acb32d0f27bbe 100644
> --- a/tools/testing/selftests/kvm/arm64/external_aborts.c
> +++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
> @@ -250,6 +250,48 @@ static void test_serror(void)
>  	kvm_vm_free(vm);
>  }
>  
> +static void expect_sea_s1ptw_handler(struct ex_regs *regs)
> +{
> +	u64 esr = read_sysreg(esr_el1);
> +
> +

Extra whitespace

> +	GUEST_ASSERT_EQ(regs->pc, expected_abort_pc);
> +	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
> +	GUEST_ASSERT_EQ((esr & ESR_ELx_FSC), ESR_ELx_FSC_SEA_TTW(3));
> +
> +	GUEST_DONE();
> +}
> +

Thanks,
Oliver
