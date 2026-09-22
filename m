Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD2B2FE060
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096828; cv=none; b=Q967sxHFBZBPyzGoMefrpp7+SAp1YJ7LOhb6MuUV6SyePPlLg3OUGiFUzZ9v62MwJkjRoNtae/G3Bu3WKFcbSoO97UQHsg1p8Aa7ehKxQSLlJY2CFsv8uMjNsT/c//Si3lMs0AL1OsN2Tc9QUu90UIEI1WEKsVSNo6norQG5AOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096828; c=relaxed/simple;
	bh=THqLxf2Nh8WONvTsUugDhC8C3Fhu1GnsjuOyv2a4vcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hm3JFUjEXkaks064MwXewAzriq3hMM8WLRQ6yCnH2FaHZSADJP5KX8ujIv8h8glnzdYIwlJ6qYT+SrKiBtZHvjZsSi2YTgx8fMyDUKMOqPLCWKSSLn8TEJU86LDjcOYhcRPj3aj3x1oKrBAJAXUY7/PZaj2vyRVvM9ULqd539KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nJ+VCNPv; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nJ+VCNPv"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912e64ccso188695e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790096825; x=1790701625; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8JODXIaSFJC9qN9KmTlMz7Gcx5C6dm9DycX2u8LOJSM=;
        b=nJ+VCNPvGOehTcaDC2OJu+If/M49Zx0Z8kKnuvy3JwjmERT/7LBPxFEMYIOPy4Jo/B
         RwxtlkWc1/H+VH/LOVqQt/ZQDXHT23yVETmD7hsFRTAeLOnUOBtBipUy4ZHxZ+UBOmyw
         lveZ0J6laqgS120H8UkpsDDDytNF3jMs56+zVsylQp7g3CBakFzHaX6LhPFcVC3gLa58
         1P0sSSMMuxEhmqSNgAMWCXID47VqP0rN/vvOEqBzZJ2/K8lyV830ZXi16Ytafz4+O60K
         f0YFDUD4jPWUVZ0MF0slB1QNB8BdXttkQ/4H5umdjuFec54IMllHonHJac65gDWDOnYi
         9VLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790096825; x=1790701625;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8JODXIaSFJC9qN9KmTlMz7Gcx5C6dm9DycX2u8LOJSM=;
        b=Y+sO1CN7feGcSLdgHV116nB2c3SIFSfR1onQToyHYTRwwm2a4Oip28fPjWDGRExPR/
         JiPpG4l1KYh0VR52w5Y5kIKwmoBr0FmXK8p6HNHlVCHtvk7zZpovfTn6r3hWIC1HrgCk
         NTuo6lkTWyGzsBJo5arjEuWSBB1m5h8lZPBuFxA+NKd8dgDmSyEfUCK0BajdDXLzeyLS
         b5iNF7WsB/n/i6+o5zlG/zKy7uszo0TZwndf6UpW8sWebQDHr+t60jvpjU4NpUkW2ywT
         PmK3i2QXgspLV4Pd8XufK6VIzuo8yel0vX6OUPhv191d96HIGACaTWLOYjfvjigIVic4
         Wp5Q==
X-Forwarded-Encrypted: i=1; AKwUvBz58LC2IpiZ8X0UL58RfTMZ4Vb5drRV5lgTSQp6o0fgDl9TW50aenmfc/wmrx9ijyXb8pZNxHM=@lists.linux.dev
X-Gm-Message-State: AFuF++kEUyPpAayg9RzpH8dyhwScOA1noEVkl68l4fr45rws7IMyrucU
	+iW9Yjyp1jDQgZJ7gQecZcwq4cNsuBZssx2CTEQcNqpReQuV8bscagY+apvdBl9VDA==
X-Gm-Gg: AYBFou19RbJXsaxZiBHg0UGhJlmmBwDPgqVAM+46+rfl9MOa/5VJzAK4cftREh5Pkh7
	uxHdsJ/yYVaVYslNjv0whlUrE46F5c7eZCGMc+4A0iKV8e0db/C6/9ajIznKO9yHc2Se1Pk7KB4
	SVSbCjdw7BjKQvJRY/cVPVUlO5xTuzMr1BXtL8AaXltgukUfhKptV0s0yz4rYPzjbJXrdo+FfsU
	WmHthG4ngjY9TFJQo4mTk6ntytF60nII1Doqq9ZIma7odRgnStd5u04aCKhGeA+I+Icg3VEbc6O
	MUcT4tzvtV+k5wKxg2vrcfWgPC45nFNJ+V2sCUrBPPez+yyAREj86T1QZXgcM0XmGexP0VhprT6
	IrPylzAXMypYPFMUrvaxSW84mrAIsZ1sS7KMyoiDVaDJXuUrovEqE8K9px2468uVrruL/aV6D/i
	LdklcgwzYywM9wOqE2C/HRkY+ayrborrrSXeGlHLiOX5pNv92uwX8vLUeTYHuQirxU82dHT0nys
	4SjJd0s6cDLCdtSo7imAoHC5Vpj+1fp3wS4v5Xzge0=
X-Received: by 2002:a05:600c:5487:b0:49f:bd3c:bc1e with SMTP id 5b1f17b1804b1-49fc573a0damr223240355e9.25.1790096824351;
        Tue, 22 Sep 2026 10:07:04 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde1ccb90sm4537125e9.6.2026.09.22.10.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:07:03 -0700 (PDT)
Date: Tue, 22 Sep 2026 18:07:00 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com,
	tabba@google.com
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
Message-ID: <arK1tHUEJsCQEKzn@google.com>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914113338.159227-11-fuad.tabba@linux.dev>

On Mon, Sep 14, 2026 at 12:33:30PM +0100, Fuad Tabba wrote:
> EL2 implements PSCI 1.1 for protected VMs: CPU_ON, CPU_OFF,
> PSCI_VERSION and PSCI_FEATURES are decided at EL2 (CPU_ON and CPU_OFF
> still exit to the host, which only schedules or parks the target),
> AFFINITY_INFO, CPU_SUSPEND and the platform power operations are
> forwarded to the host, and anything else returns NOT_SUPPORTED,
> including the TRNG calls and the functions above 1.1, SYSTEM_OFF2
> among them, that the host handled for a protected guest until now.
> TRNG for protected guests is a follow-up. AFFINITY_INFO stays
> with the host, which returns OFF only once it has parked the target:
> the host is what a guest polls to see a CPU_OFF complete before it
> issues the next CPU_ON, as Linux does on hotplug.
> 
> Three consequences follow:
> 
>   - A protected VM has one primary vCPU, the first whose hyp vCPU is
>     created with mp_state RUNNABLE. A second one, or an mp_state other
>     than RUNNABLE or STOPPED, fails that vCPU's first KVM_RUN with
>     -EINVAL.
> 
>   - CPU_ON finds its target among the hyp vCPUs, which exist from the
>     target's first KVM_RUN; before that the guest gets
>     INVALID_PARAMETERS.
> 
>   - A vCPU EL2 holds powered off doesn't run: handle___kvm_vcpu_run()
>     returns ARM_EXCEPTION_IL, reported as KVM_EXIT_FAIL_ENTRY. Its
>     existing bail-outs return the same code instead of an -EINVAL that
>     handle_exit() didn't recognise, for every hyp vCPU.
> 
> Non-protected VMs keep power_state ON and accept any mp_state.
> 
> Each protected vCPU is OFF, ON_PENDING or ON. CPU_ON moves the target
> to ON_PENDING, and the target's next run resets it and moves it to ON.
> The racing transitions are cmpxchg, and the reset state is published
> with a release/acquire pair, documented at each site. CPU_OFF publishes
> OFF with a release, so the target's clear of reset_state.reset is
> ordered before it and a CPU_ON that then wins on OFF republishes after
> the clear. Rolling a CPU_ON the host failed back to OFF needs the
> host's return value, which the per-EC marshalling patch delivers along
> with the rollback. Until then such a target stays ON_PENDING, and the
> reset has no observable effect: flush_hyp_vcpu() copies the host's
> context in on every entry until that patch removes the copy, so the
> target enters on the host's values rather than the ones EL2 reset.
> 
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  25 ++-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 283 ++++++++++++++++++++++++-
>  3 files changed, 311 insertions(+), 11 deletions(-)
> 

[...]

> +
> +/*
> + * Returns true when handled at EL2, false when the host must wake the target
> + * vCPU.
> + */
> +static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
> +	struct vcpu_reset_state *reset_state;
> +	struct pkvm_hyp_vcpu *target;
> +	unsigned long cpu_id, ret;
> +	int power_state;
> +
> +	cpu_id = smccc_get_arg1(&hyp_vcpu->vcpu);
> +	if (!kvm_psci_valid_affinity(&hyp_vcpu->vcpu, cpu_id)) {
> +		ret = PSCI_RET_INVALID_PARAMS;
> +		goto error;
> +	}
> +
> +	target = pkvm_mpidr_to_hyp_vcpu(hyp_vm, cpu_id);
> +	if (!target) {
> +		ret = PSCI_RET_INVALID_PARAMS;
> +		goto error;
> +	}
> +
> +	/*
> +	 * vCPUs race to power on the same target. Relaxed: reset_state
> +	 * is published by the release on reset_state.reset below.
> +	 */
> +	power_state = cmpxchg_relaxed(&target->power_state,
> +				      PSCI_0_2_AFFINITY_LEVEL_OFF,
> +				      PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);
> +	switch (power_state) {
> +	case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
> +		ret = PSCI_RET_ON_PENDING;
> +		goto error;
> +	case PSCI_0_2_AFFINITY_LEVEL_ON:
> +		ret = PSCI_RET_ALREADY_ON;
> +		goto error;
> +	case PSCI_0_2_AFFINITY_LEVEL_OFF:
> +		break;
> +	default:
> +		ret = PSCI_RET_INTERNAL_FAILURE;
> +		goto error;
> +	}
> +
> +	reset_state = &target->vcpu.arch.reset_state;
> +	reset_state->pc = smccc_get_arg2(&hyp_vcpu->vcpu);
> +	reset_state->r0 = smccc_get_arg3(&hyp_vcpu->vcpu);
> +	reset_state->be = kvm_vcpu_is_be(&hyp_vcpu->vcpu);
> +	/*
> +	 * Publish reset_state.{pc, r0, be} to the target vCPU. Pairs with
> +	 * smp_load_acquire(&reset_state->reset) in pkvm_reset_vcpu().
> +	 */
> +	smp_store_release(&reset_state->reset, true);
> +
> +	/* The host requests KVM_REQ_VCPU_RESET and wakes the target. */
> +	return false;
> +
> +error:
> +	smccc_set_retval(&hyp_vcpu->vcpu, ret, 0, 0, 0);
> +	return true;
> +}
> +
> +/*
> + * Returns true when handled at EL2, false when the host must stop scheduling
> + * the vCPU.
> + */
> +static bool pvm_psci_vcpu_off(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +	/* No other writer runs while this vCPU is ON and executing. */
> +	WARN_ON(READ_ONCE(hyp_vcpu->power_state) != PSCI_0_2_AFFINITY_LEVEL_ON);
> +
> +	/*
> +	 * Orders pkvm_reset_vcpu()'s clear of reset_state.reset before OFF, so
> +	 * a CPU_ON that wins on OFF republishes after it. Pairs with the
> +	 * cmpxchg in pvm_psci_vcpu_on().
> +	 */
> +	smp_store_release(&hyp_vcpu->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);

Is there an issue either with the comment or with pvm_psci_vcpu_on()? the
cmpxchg is relaxed. I would have expected cmpxchg_acquire().

> +
> +	/* Return to the host so that it can finish powering off the vcpu. */
> +	return false;
> +}
> +

[...]

-- 
Vincent
