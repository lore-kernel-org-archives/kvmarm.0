Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793809157;
	b=tJuWKDZ2zBc9GqVOiT/QtyQP7binl9hduu93d64NB7NWoYYEHHsAHbpV8GbbVpgqicQ5
	 eF6uE6W1o+I6xfsjcKF6iV970m9AXBpgvfmUEZDCyUob6RzPa3a8CMzzwzDj/RmhjWtj6
	 r3j61M/nxMCf4DIPw44lu0kz7TchirzkoP53wc6MvIZOz10nc89J29UIfUBvu55Ao47F/
	 OlPcHinQFOF+ViZjuE7xzFHMV9bHI8SJurkMpxw0aIpJcXc5b1mnWMKm0hig6TdX/aYZV
	 wXRKaI7yObYqH3aopqmyTg3dOIXdrfofwx9ua7/no7/HI+pav/wN2jKCtT53RvPVCzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793809157;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=RHPNCSqgWbNSnvrm9k86PHx9QoMkXwz9Vg4eXBKbL/M=;
	b=YtZ0fMHzxW3XvT/+vfdSYKx20L8F3lNY+0R/YpnTv/klwL816JqBXkYpLWnLPKX7Hg4f
	 z3wbJELzhGMzolSYPYqIDbJtWVbShZtd3Y/z9yyK/LqQVZ504W0rtOSITgxYXX31Dqk8G
	 QKMR0Eq+9ZOontP4Y327AiOpYmFlil862ZCwcvGdi6vISCen6lHzM8dduW2FiQxvOrjKd
	 qMuqT0XZwQqry9xGgFDKfpuK7BEt+hy0bu0gJHYA3H+0td/sKymmNoxsqAngH/FO+g1cy
	 FKJMzCQlhZeW3txTAhaWaiArQtZI0yBZ4XdwsSYLK9lwakKF+y8T2wcX1oKzujZO32g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dAuvnvHv;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CFC4606B8E2
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 16:19:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CFC4606B8E2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dAuvnvHv
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1F611BB2;
	Wed,  4 Nov 2026 08:19:12 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 644B73F632;
	Wed,  4 Nov 2026 08:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793809155; bh=73qVKmq8ZOLRhHHBiDc9f0Emiv0HzZsnkaXXSQbM2Ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAuvnvHvtlYEs8S83NugiFniTICrbeEc/4ouG3gZfTGQZ4JlJ1F8lnS6luc2JFyqO
	 Fsv5QMlz5Ea1HcrKcV7YViml+AOujSri/FLxtP6IPW7Cx3J4zZF6IxIGF/fs7UiRum
	 TaE1jM253h0xmtiFDqKEWux3KNJmG8gnlKhjWJK0=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Subject: Re: [PATCH v2 20/28] KVM: arm64: Reject non-coherent DMA when using forced writeback
Date: Wed,  4 Nov 2026 16:19:12 +0000
Message-ID: <auta_3j46h23hBKm@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-21-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-21-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 23, 2026 at 01:56:02PM -0700, Oliver Upton wrote:
> Assigning non-coherent devices to a KVM guest subject to forced
> writeback is broken. DMA through cacheable aliases and CMOs work, but
> using non-cacheable aliases for buffers on the CPU does not due to the
> implicit promotion to Normal writeback.
> 
> Non-coherent DMA is fundamentally incompatible with the direction of
> travel on KVM/arm64. Draw the line in the sand and bug the VM if FWB is
> in use. Users can use the newly-added kernel commandline to fall back to
> a non-FWB configuration that *actually works*.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/arm.c              | 14 ++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1c6632216e32..5672721416a4 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1565,6 +1565,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>  
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
>  
> +#define __KVM_HAVE_ARCH_NONCOHERENT_DMA
> +
>  #ifdef __KVM_NVHE_HYPERVISOR__
>  
>  #define kvm_vm_is_protected(kvm)			\
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d593ba928093..f08a450184d9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -133,6 +133,20 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>  }
>  
> +void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
> +{
> +	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
> +		return;
> +
> +	pr_err_once("kvm: noncoherent DMA unsupported with FWB, see kvm_arm.nofwb\n");

I know _ and - are the same for the purposes of parsing, but since this is 
a log message (visible by user), I think it makes sense for it to appear 
the same way as it appears in cmdline documentation. (kvm-arm.nofwb) 

Apart from above nit, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
