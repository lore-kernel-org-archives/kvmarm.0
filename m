Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2768221F24
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 02:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791340107; cv=none; b=ujaTR8geO0KFGumVhkZkyp32sInPwaFRkNRFopO1sVwaHHoC3IXr3JaSB3W792Bt5P3aUvndWjgWQgVlYIo+oLz38IIGliYhl1jo1sSUfJP0MfeHQc3xnIQC/eW3xDBi20ykq4HGRqbTuJKer7W5K/R2EySyShkK0exuclAL1Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791340107; c=relaxed/simple;
	bh=oeddAg8h/XfSj3W7DeYIWZ+00v/T5CKvwZTOXBtFeTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rr9F8k83RGSmvKEE+oPNQjxd4XFlmdZtFNt2GdiWLmT2hUKFmh0p/EX+Lua4FobDtjSBOU/QrYajMHdPmq4GE1zqkvcyyo4Gunaim9yK+UWRYqmp3FOg8hzZ8puDnrLamkVKwxWbv4jOQWrhlKk8ImSPD86Egpl4Z8d4EGnC7HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=CYDXevsD; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="CYDXevsD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1791340106; x=1822876106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oeddAg8h/XfSj3W7DeYIWZ+00v/T5CKvwZTOXBtFeTg=;
  b=CYDXevsDE4H+lCgrUyw5+mTMv5BuFgcieWfo+K4M0JQFjqk/zXsk//1Y
   hiYz7uHoWu/OfaA1jX7V1P5RyZO8ibM+u4wBdA8wRcni7COeECQEZmIDC
   WLj8I9r514l5u+jxXlFYXXa4FBg8l+EtCGQE0T3tLqI7RvAP5UjliyT1r
   BAGCZzpvJVoEIEqgI/MGZoS49pfeUoX4ZqnpmpNSnu6Kb1qzODrMipb/u
   f0g7eVkxJzTBJzfJUuhSqO1cok2cDrcaQkTUpL4ylFZzcTGRUOV/qZz1b
   s44OJJIQIGVKT5GFHkxwII3cqcFMwH5iplDh4/8sQe7fgSuuU+yaFm2ai
   w==;
X-CSE-ConnectionGUID: lkztpRZmSfeAMWP2haHjwg==
X-CSE-MsgGUID: o7uFefuiQPi6P28BflvETw==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="255609410"
X-IronPort-AV: E=Sophos;i="6.27,144,1786978800"; 
   d="scan'208";a="255609410"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 11:28:17 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 9DB1A82070D
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 02:28:17 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 5343C18000F3
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 02:28:17 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 27BE2405EC0;
	Wed,  7 Oct 2026 02:28:11 +0000 (UTC)
Date: Wed, 7 Oct 2026 11:28:09 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com
Subject: Re: [PATCH v4] KVM: arm64: selftests: Check the pending SError state
 in external_aborts
Message-ID: <asWuORRZlOQR1N6B@sm-arm-grace07>
References: <20261006092841.2202109-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006092841.2202109-1-fuad.tabba@linux.dev>

On Tue, Oct 06, 2026 at 10:28:41AM +0100, Fuad Tabba wrote:
> None of the external abort tests look at the vCPU events once the guest
> is done, so an SError left pending after the guest took it, or dropped
> while the guest had it masked, goes unnoticed.
> 
> Read the vCPU events back at the end of every test that runs the guest.
> The SError must still be pending in the masked case, with the injected
> ESR when the vCPU has RAS, and no SError, injected or spurious, may be
> pending in any of the others.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
> The check that no SError is left pending after the guest took it is
> what fails without commit 3708f6342f01 ("KVM: arm64: Sync HCR_EL2.VSE
> back to the host vCPU under pKVM"), in kvmarm/next.

Applied this fix cleanly on today's kvmarm/next and did run
extranl_aborts on a NVIDIA Grace system booted with the proper ACPI tables,
the program finished quietly.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> Changes since v3 [1]:
> - Check the SError pending state at the end of every test that runs the
>   guest, and assert it is still pending, with the injected ESR, in the
>   masked case (Oliver [2]).
> 
> [1] https://lore.kernel.org/all/20261005050349.836795-1-fuad.tabba@linux.dev/
> [2] https://lore.kernel.org/all/asNdAXGkxagm88Su@kernel.org/
> 
>  .../selftests/kvm/arm64/external_aborts.c     | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
> index 7836756a38a6c..1a858d0d82968 100644
> --- a/tools/testing/selftests/kvm/arm64/external_aborts.c
> +++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
> @@ -75,6 +75,17 @@ static void vcpu_inject_serror(struct kvm_vcpu *vcpu)
>  	vcpu_events_set(vcpu, &events);
>  }
>  
> +static void vcpu_assert_serror_pending(struct kvm_vcpu *vcpu, bool pending)
> +{
> +	struct kvm_vcpu_events events;
> +
> +	vcpu_events_get(vcpu, &events);
> +	TEST_ASSERT_EQ(events.exception.serror_pending, pending);
> +
> +	if (pending && vcpu_has_ras(vcpu))
> +		TEST_ASSERT_EQ(events.exception.serror_esr, EXPECTED_SERROR_ISS);
> +}
> +
>  static void __vcpu_run_expect(struct kvm_vcpu *vcpu, unsigned int cmd)
>  {
>  	struct ucall uc;
> @@ -134,6 +145,7 @@ static void test_mmio_abort(void)
>  
>  	vcpu_inject_sea(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  	kvm_vm_free(vm);
>  }
>  
> @@ -162,6 +174,7 @@ static void test_mmio_nisv(void)
>  
>  	TEST_ASSERT(_vcpu_run(vcpu), "Expected nonzero return code from KVM_RUN");
>  	TEST_ASSERT_EQ(errno, ENOSYS);
> +	vcpu_assert_serror_pending(vcpu, false);
>  
>  	kvm_vm_free(vm);
>  }
> @@ -185,6 +198,7 @@ static void test_mmio_nisv_abort(void)
>  
>  	vcpu_inject_sea(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  	kvm_vm_free(vm);
>  }
>  
> @@ -212,6 +226,7 @@ static void test_serror_masked(void)
>  
>  	vcpu_inject_serror(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, true);
>  	kvm_vm_free(vm);
>  }
>  
> @@ -247,6 +262,7 @@ static void test_serror(void)
>  
>  	vcpu_inject_serror(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  	kvm_vm_free(vm);
>  }
>  
> @@ -288,6 +304,7 @@ static void test_s1ptw_abort(void)
>  	*ptep |= bad_pa;
>  
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  	kvm_vm_free(vm);
>  }
>  
> @@ -313,6 +330,7 @@ static void test_serror_emulated(void)
>  	vcpu_run_expect_sync(vcpu);
>  	vcpu_inject_serror(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  	kvm_vm_free(vm);
>  }
>  
> @@ -356,6 +374,7 @@ static void test_mmio_ease(void)
>  
>  	vcpu_inject_sea(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  done:
>  	kvm_vm_free(vm);
>  }
> @@ -395,6 +414,7 @@ static void test_serror_amo(void)
>  	vcpu_run_expect_sync(vcpu);
>  	vcpu_inject_serror(vcpu);
>  	vcpu_run_expect_done(vcpu);
> +	vcpu_assert_serror_pending(vcpu, false);
>  	kvm_vm_free(vm);
>  }
>  
> 
> base-commit: fa22cd9947fc245d71bc40482f7f78eb0d5a4af0
> -- 
> 2.39.5
> 
