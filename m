Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902378;
	b=16XiTMO17noeeQSucE6PdqPK55jf0QB2s9wNKv/pWayfS++IPduYwIlP+yvU3wbNbgNH
	 TgNx/XKMzGDgMMA4Mt0Ofb9eoY79wAl0KIOGmmeVLavFzqeUtZnrsJ4kbgRQBJMe5CieT
	 0IC/9U4nUg4YTETfDGTWrCv8RbzWYi4HM/i07KE3pj6FRydBxzIwT8SCGgt0jvtLwFeZQ
	 hn8Ls05xA8q4G0HXQo25VdGAH8xHX21Q2/tNamqDvXe35AK+Mau9s1KHm5IOcRHn6ogBa
	 78HySQOfrUziJw/FX4dkI3X5UMEl3L5C2BzBDH0tPwQ6JJn5qvVCACV+TBymHO1NSVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902378;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=xYvryrD2mKKwwayO8ml+blPYD19r69B7suqW1qnF/T0=;
	b=Sia+Rb8SHSDvydMMlEFmFHHGrp21CzroeqeXFXDhlmZitNBNIDxRffnxgVMykozTWdaZ
	 oziJXeWeCV6NdaMkyQCEY7qLhqAsQSh9MaPRLeVGmY7U6yTJWFoTEZQdJefJH56xURgtt
	 xN8/LcDCPHs4klTNN2PISdy1ZpSyBtdnVTgroijGnnE/zxTob8F8HS3JWCtfsJkn9sYOu
	 QbW+HprUfOe23Yfhz9R4eJlfgJlJjtElf/BWDSCFBjqMqAZL2WfM/lCpwgm7sUafIF5Y+
	 Gfj3tpoz3lc7ByuXjY0QnSmu3OfVOzKJRprmiXAPTNGoBRqGGZpsy0GPe7YEEyvmSlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=krwqKpch;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196E2606A326
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 18:12:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 196E2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=krwqKpch
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32598168F;
	Thu,  5 Nov 2026 10:12:53 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABD643F632;
	Thu,  5 Nov 2026 10:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793902376; bh=0Hk4TBMX4UiOnMMhg3C7jxmoLcTDZUL//P6HcTK2T1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krwqKpchavArwqo5jKe736oqtHdl/61uhT158yLd9rfDy4qAZXyyq41qI48NfJldL
	 BJDZZr9+w+wz9qc0niU6X+ONw625YMXziBBaoyyiAK65x7jxH2DMuvkhTZ5myDF06d
	 +Xg6BThD0COVk11K57i1c+6Mieia1mNBi6A3z94Q=
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
Subject: Re: [PATCH 2/8] KVM: arm64: nv: Add CGT description for FEAT_PoPS instructions
Date: Thu,  5 Nov 2026 18:12:48 +0000
Message-ID: <auzHIGC9iGg7xfKr@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104192124.3932743-3-oupton@kernel.org>
References: <20261104192124.3932743-1-oupton@kernel.org> <20261104192124.3932743-3-oupton@kernel.org>
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

On Wed, Nov 04, 2026 at 11:21:18AM -0800, Oliver Upton wrote:
> The DC CIVAPS and DC CIGDVAPS instructions are both affected by
> HCR_EL2.TPCP. Add the missing CGT descriptors.
> 
> Fixes: a7484c80e5ca ("KVM: arm64: Allow userspace to request KVM_ARM_VCPU_EL2*")
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 2bec81668361..d04ac5203454 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -747,6 +747,8 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
>  	SR_TRAP(SYS_DC_CGDVAP,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_CGVADP,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_CGDVADP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CIVAPS,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CIGDVAPS,	CGT_HCR_TPC),
>  	SR_TRAP(SYS_IC_IVAU,		CGT_HCR_TPU_TOCU),
>  	SR_TRAP(SYS_IC_IALLU,		CGT_HCR_TPU_TOCU),
>  	SR_TRAP(SYS_IC_IALLUIS,		CGT_HCR_TPU_TICAB),
> -- 
> 2.47.3
> 

LGTM. FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
