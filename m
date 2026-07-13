Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E63B38F230;
	Mon, 13 Jul 2026 07:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783928020; cv=none; b=sPOn0giYQFScnBz9V6Z0xE1OWe9vv7yZmxnEM0xTsxhzUxpKGQkXeQrFSz9k4QL61WMoE56GpG9ZGrn6A/hay4wgRbSafkmabl87YCZF0wcki6Y3IqU2+irbY0Wg+OVrFZqUt5M0PgJ378K+gnCsEOyCDBfSb83AHsWGK30Rcxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783928020; c=relaxed/simple;
	bh=vxR1n8x++y1etfYJI5z3sl9ofTRJlNXz1r/eUXMPNK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQLjQ8udJFDIOSp+rPfhjTq/LbNdhwwQO1FzvWCyD3D/HlE7SkEhmehBoWYtW9vn43t8JJON8pCqYV1M70yexLftp3rXbu0t/AZv/Aikje83XWtCx3CchNiZk8pebC/GMPfJ4djMCJDyKlEl9ArvQHWsVnFFlJdoYg5SoMAwx+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTljm3XC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTljm3XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956141F000E9;
	Mon, 13 Jul 2026 07:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783928018;
	bh=YK6JJLrtYdjUeALj48c7CkynRd/F55S7Z4V7ax9rj+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FTljm3XC7PYrixU2x5qXuvq0zgoVZ/vdaSFjUkS3qnIRtIgW3LqKRDBMWCqA4vyz2
	 wver2ibuCFeaz8yAIFmelV46IC4YVJX21usDAIWS47K6A/oomcVhgEdhetuwS8mCLY
	 RHwT6v5JsDqBAa1JF0DqJIGj7u+4unUeNxU2Cfm+Yqoo7frtgFFO7XZ4uMbG8VgmPH
	 mrcbEPSyNNdygnw9yncJ2EaQIvDOAI2teBZBeicbjHACBaAkjb34ZNROiD2A0AqLwg
	 pP8bSd0W5LCm3XL2nOlWhwBY8Pg+P2Va2R7FlPuc5NomIhulJRV41Wq1cONcXcm1dk
	 XgyFFaYKQS0HQ==
Date: Mon, 13 Jul 2026 00:33:37 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 01/11] KVM: arm64: Serialize userspace MDCR_EL2 access
Message-ID: <alSU0ZoIQ3sMLo0p@kernel.org>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
 <20260710-hybrid-v8-1-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-hybrid-v8-1-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>

Hi,

On Fri, Jul 10, 2026 at 08:14:55PM +0900, Akihiko Odaki wrote:
> kvm_arm_set_nr_counters() updates MDCR_EL2.HPMN for every vCPU while
> holding kvm->arch.config_lock. However, KVM_SET_ONE_REG currently writes
> MDCR_EL2 through the generic sysreg path without taking the same lock.
> Concurrent PMU configuration and register restore can therefore race and
> lose updates to unrelated MDCR_EL2 bits.

Ugh, we should just stop updating MDCR_EL2.HPMN altogether. Since this
overwrites the previous value (rather than clamping it) we could discard
a legal value set by userspace.

From the UAPI POV all we need to do is ensure the reset value is sane.
The documentation says that system registers are reset to their warm
reset values when KVM_ARM_VCPU_INIT is called. Which in this would mean
HPMN is reset to the number of implemented counters at the time of the
ioctl.

If userspace changes the number of counters afterwards, that's their
problem.

> Add explicit userspace accessors for MDCR_EL2. Serialize them with
> config_lock so whole-register userspace writes cannot race with HPMN
> rewrites, reject HPMN values above the configured PMU counter count, and
> request a PMU reload when HPME changes to match guest trap behavior.
> 
> Fixes: c8823e51b534 ("KVM: arm64: Fix MDCR_EL2.HPMN reset value")
> Closes: https://sashiko.dev/#/patchset/20260706-hybrid-v8-0-de459617b59d%40rsg.ci.i.u-tokyo.ac.jp?part=6
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> ---
>  arch/arm64/kvm/sys_regs.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index d217530359ba..2b2ea33159e9 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2949,6 +2949,42 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static int get_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		    u64 *val)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	guard(mutex)(&kvm->arch.config_lock);

Hrm... I would strongly prefer that we *not* take the config_lock for
this register since there's no way for userspace to avoid lock
contention. ID registers are special and documented as VM-scoped, so an
aware VMM could potentially set these once (avoiding the lock).

> +	*val = __vcpu_sys_reg(vcpu, MDCR_EL2);
> +
> +	return 0;
> +}
> +
> +static int set_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +		    u64 val)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 old, hpmn = FIELD_GET(MDCR_EL2_HPMN, val);
> +
> +	guard(mutex)(&kvm->arch.config_lock);
> +
> +	if (hpmn > vcpu->kvm->arch.nr_pmu_counters)
> +		return -EINVAL;

KVM allows userspace to write whatever it wants right now, we can't
start rejecting values that were previously valid. The architecture also
allows anything to be written to the field, just that unimplemented
values have UNKNOWN behavior.

Thanks,
Oliver
