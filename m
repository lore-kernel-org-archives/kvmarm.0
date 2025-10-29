Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15FE2D9ED8
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 20:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761770917; cv=none; b=sQudsm7IK3wTItlwsxBI8CGCtaQ+c/3WNPuLBrG05bpWG4q7GnzJPbmI5Kv5VngTxA7IVbTauCSvudqTlpYGJ/0jLLIxN+0fbYNpzhtcsxwdHkH68II5T0y68luD/7m1ugFprFiEJkz92sNyQ5oFepvl78wYyP5OxUB5Ozqn+b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761770917; c=relaxed/simple;
	bh=CpqxIQaOXMxDs/03sklra3KXKiZ5+GcRhtAMgLboz7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cg8OpyQypFZRTL2mt6kgoAmoMpxNrlq4CEg18aXg0ALcSErdhWlYjULqIIw4ODsD3Mbmee/yaU5c7Gv1jpNGIuKb6dHeoM0H/AykrOKGUmPsDDNYR2LCtI2wNSPz+5NjbV7VK56nQ4IdXY/a62JzYGMfqSGe8SZ6/qg0lcfTWKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mMtMSGoz; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mMtMSGoz"
Date: Wed, 29 Oct 2025 13:48:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761770909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JYMU26G80HSBFv2mfmxmI1ldCw66DlxUZPOrNSRANLA=;
	b=mMtMSGoznU8oiC3CKM6I+dZhCTlWmvw1ubRpmyM4nMyhNicLPb4oETsm6a/gY/kM3R7A2l
	uMgoibMrNKqc42fs6rPaWAvbqqk6ib+dkdFcS2rDB6TbbvE9MZFY1tZHKxSlsaF1oejGB3
	2up1KEUWUmjPt8uzMnMoLhUpcai+VD4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ben Horgan <ben.horgan@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	shuah@kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: selftests: Count test_guest_reg_read()
 as a test
Message-ID: <aQJ9mC5_j6HQ_jbg@linux.dev>
References: <20251014102108.2442391-1-ben.horgan@arm.com>
 <20251014102108.2442391-2-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014102108.2442391-2-ben.horgan@arm.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 14, 2025 at 11:21:06AM +0100, Ben Horgan wrote:
> The test test_guest_reg_read() is run without announcing its presence or
> contributing to the test count. Rectify this.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index 5e24f77868b5..6878ee23310e 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -655,6 +655,8 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
>  			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
>  		}
>  	}
> +
> +	ksft_test_result_pass("%s\n", __func__);
>  }
>  
>  /* Politely lifted from arch/arm64/include/asm/cache.h */
> @@ -786,7 +788,7 @@ int main(void)
>  
>  	ksft_print_header();
>  
> -	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
> +	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;

TBH, I'd actually be in favor of a patch that removes usage of the
ksft_* harness from this test altogether. I don't think it adds much and
we use the KVM-specific test assertions anyway.

Thanks,
Oliver
