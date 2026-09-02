Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8A74AE131
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788366648; cv=none; b=aiJZTOU+cwTJi6o7kfBzjB0TJWcAZAhbjwFBbcx4VIoEEvoyF12gHuWzHcqro2K2vL2wTuCUcWNBcOHFUhGD8dvLCcnA8Mj3GhYySoXUvDewX4JnrwGaIm4KpDPiXF05eyRbs65MVWVWViY+bItk5vHihCAdNTGAFdjRAfOKgXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788366648; c=relaxed/simple;
	bh=RMlvZ3YXuMVOhDDXeCBDqAOcnoat3xP4LQ6OtgGDeVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=GamYW9rxvs21d1rdmIMkWevTg+ansh7Wj5ToakWt3d6tTFczUWzT7qNfywAKOJ2hdVoUopUPQX6b+U88gAKfFKF03Ne30MJhgpkhO6wvjvpS+EUvzeMq2a+o1XqFqp7xGVx7Y7EJ1oLkMq5Xf6qJ9I5F1eLGytl8q6XPhU5lqnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=B3dcRLnP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="B3dcRLnP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF5AA165C;
	Wed,  2 Sep 2026 09:30:41 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6869C3F882;
	Wed,  2 Sep 2026 09:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788366645; bh=RMlvZ3YXuMVOhDDXeCBDqAOcnoat3xP4LQ6OtgGDeVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3dcRLnP9L3Xl5v7fW2zVaoKGzwYrvoHWWhLFlBC/dhW0ySfGu5cfAV2cbd5CTvqT
	 ul/ErXJPrAOvS2Io7nT7Bzc44tjNjRjpyKaaJtL5I0svvKQD8irUx9UC6wTIboyRKT
	 T67/R/0ZABmzV/q+RjI7heGlyWPForXik3k3Cil4=
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
Subject: Re: [PATCH v20 04/14] KVM: arm64: Ensure GCS memory effects are visible
Date: Wed,  2 Sep 2026 17:30:20 +0100
Message-ID: <aphPHJsdV4HWFjpg@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901-arm64-gcs-v20-4-f31750bdfadb@kernel.org>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org> <20260901-arm64-gcs-v20-4-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 10:47:02PM +0100, Mark Brown wrote:
> In order to allow efficient implementation of GCS implementations are
> permitted to do GCS specific caching, with barriers implicit in stack
> switch operations and GCSB DSYNC as an explicit barrier.  Since we do
> not use GCS in the hypervisor or host kernel the hypervisor cannot rely
> on any barriers being present in vCPU context switches other than those
> it explicitly inserts.  Add explicit barriers when loading and saving
> vCPU state.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
> ---
>  arch/arm64/kvm/arm.c               | 7 +++++++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90..52f53f682e6a 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -755,6 +755,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>  	}
>  
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere.
> +	 */
> +	if (kvm_has_gcs(vcpu->kvm))
> +		gcsb_dsync();
> +

Makes sense as previously discussed:
Only gcsb when leaving the guest, if it's possible the vcpu will be 
migrated somewhere else.

>  	kvm_vcpu_put_debug(vcpu);
>  	kvm_arch_vcpu_put_fp(vcpu);
>  	if (has_vhe())
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 9a3b92e626ad..534db037c5f6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -261,6 +261,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	fpsimd_sve_sync(&hyp_vcpu->vcpu);
>  	sync_debug_state(hyp_vcpu);
>  
> +	/*
> +	 * Ensure any GCS memory effects from the outgoing vCPU are
> +	 * visible elsewhere even if the host skips syncing.
> +	 */
> +	if (kvm_has_gcs(hyp_vcpu->vcpu.kvm))
> +		gcsb_dsync();
> +
>  	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
>  		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
>  	} else {
> 

sync_hyp_vcpu() gets called only in handle___kvm_vcpu_run(), just after 
__kvm_vcpu_run(), and outside of the main loop. So it makes sense to gcsb 
here.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
