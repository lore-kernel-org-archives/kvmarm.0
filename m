Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ABC37DEAB
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 10:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773916281; cv=none; b=rM8VBRFnN7iv+6blyVRCTTS0F66u+2MW+WYCC2CxXmuu7O+6udrLFBWP4sEMhsj7VAT5jrGjSDZqqHH4ba7u2T27MUlDNhpkEOOZ8yF5W34pwpAkk7B3svvgZVE4v9Krvs0yQ3pFs/F6L9Up1pvezRVLn9HHGb6ngWZI+gd7eKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773916281; c=relaxed/simple;
	bh=zzJ/+/Zt8I4VMdJ+OaYyb5chrAl8wtc7VvHKdwdZJt4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QS9CfzTAkYfyyuSrHuqUeiPdsFY8kBA7dDRmVQUL72pp58o39GhKO+gySB7mE0cpbIPvhd624Cu4pRJjBn3GDejbIOzbkbdhOVFypxYzR44AqSXes7H0sklM33Ujk2UXZVFabmH176L8EJzRI6guWVgtQd29R0FvfIPU3HsUwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=kaQtoDyQ; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="kaQtoDyQ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zL/2+nC1pt2yK9os/cDSownjGgGlQCInSM2J/Abjd1A=;
	b=kaQtoDyQgL8zwwRTe7UtyLV1VIEdHhi8GRYlnFMy4Qf4sab0lDmc8pgAFRuUJ6LsyfYurp/Dk
	vLcbEZcR87lAhU91bHA+wlysubWF2L8Gll0MjrA4ox3FPfDsXwTImonW9elnWLqV7vhBFIwJMtc
	OHKdPAuIRnpAquKhTc2/spI=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fc1cj2R84z1P6gQ;
	Thu, 19 Mar 2026 18:08:53 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc1hS2qwyzHnH7b;
	Thu, 19 Mar 2026 18:12:08 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id A99B440589;
	Thu, 19 Mar 2026 18:12:31 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 10:12:30 +0000
Date: Thu, 19 Mar 2026 10:12:29 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v6 03/39] KVM: arm64: Return early from
 kvm_finalize_sys_regs() if guest has run
Message-ID: <20260319101229.000040f2@huawei.com>
In-Reply-To: <20260317113949.2548118-4-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	<20260317113949.2548118-4-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 17 Mar 2026 11:40:44 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> If the guest has already run, we have no business finalizing the
> system register state - it is too late. Therefore, check early and
> bail if the VM has already run.
Given it isn't in the scope below, might be worth calling out that
this is skipping kvm_init_nv_sysregs()  So on non NV setups isn't
changing anything but on those it's indeed skipping setup of system
registers.

Seems correct to me, but is this a fix?  So should it have a fixes tag?


> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0acd10e50aaba..42c84b7900ff5 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -5659,11 +5659,14 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
>  
>  	guard(mutex)(&kvm->arch.config_lock);
>  
> +	if (kvm_vm_has_ran_once(kvm))
> +		return 0;
> +
>  	/*
>  	 * This hacks into the ID registers, so only perform it when the
>  	 * first vcpu runs, or the kvm_set_vm_id_reg() helper will scream.
>  	 */
> -	if (!irqchip_in_kernel(kvm) && !kvm_vm_has_ran_once(kvm)) {
> +	if (!irqchip_in_kernel(kvm)) {
>  		u64 val;
>  
>  		val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;

