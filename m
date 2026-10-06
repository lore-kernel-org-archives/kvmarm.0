Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59C24519BB;
	Tue,  6 Oct 2026 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791292653; cv=none; b=Gq/mNm6P5O3WAl6JOM2KjsZQEf2orrDSilpqvgCZGCkA1NC4WF1oc5lH6geUz8sCRDPUwRU03YG8deEP4LGCxR5BL7PQdfg0BCY5ZCztH6/H3PMJR+YxJnwSp+m3Yjg4YUG5ZRlWhqRwxnsvCyLVyj99Qz9Kb5N27EWq776D3lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791292653; c=relaxed/simple;
	bh=QzAEcEVqY5gRpKDGkQWTS0Am9q6m2WzPJq+Jo6aq3N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPyFbEZEVtQrSjhqo10ct5vJuz73FwXujsICXXDsOscQhptt+Jt/8qT1qzZaeiGc/jKtVxayZGZgT2e1gER1NnOshAIhN/L/YIdAlde5X3CCVlf+tZ1wHdTOpQe8G6O31ivcF41uZsZdw63ijvuNSxPZixDXz0R4vnryokxTQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtHD/eHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtHD/eHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E04B1F000FF;
	Tue,  6 Oct 2026 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791292652;
	bh=1wl8U8qEevNauiC6J2pbvxkX7VYWlgHKM2aJW6iFkDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LtHD/eHL3+f7Xjm+LpgVK4iEZwvZMs30aWje1TC6Rw7auT+o//+/5FhXSlE/t0N6k
	 6H5rpCXKXDrvWESqmJF/yMebWW8oRaSZwLivBEE2hy5RMsf8T4oTpcv0udvRDFBz6P
	 M+oPcyIa/szygwa7tTUBTPvBrxvMiJAAaRPFNj7sWd288Yf7WPxqcnoWo35x+7kdNM
	 3xhA6lnJIDbCaq/BhmNfkDUW6a7Klw5dB9q4LrpfbdlZ5AzAU3aogIKkg8Z4NPpO05
	 2QRM36Ma/E/BSvDFk5/wUqBEAVmHB5pZRSvqQBBsRu2sot4oUKKzKxSasKD3R4SvyR
	 zOszerDR11zUg==
Date: Tue, 6 Oct 2026 06:17:26 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com
Subject: Re: [PATCH v4] KVM: arm64: selftests: Check the pending SError state
 in external_aborts
Message-ID: <asT05hZqkMvVVnze@kernel.org>
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

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
> The check that no SError is left pending after the guest took it is
> what fails without commit 3708f6342f01 ("KVM: arm64: Sync HCR_EL2.VSE
> back to the host vCPU under pKVM"), in kvmarm/next.
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
