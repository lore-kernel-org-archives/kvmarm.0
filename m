Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807929;
	b=34Ld5zTxLy+nXpSFuQB1h+XGsTuJXwcFLlRkwdc8VWLcwW0VODrYdK/0pPYD/7PXJD4z
	 T93lV7w+IttO5KwjsaFG+hVwL065Bs1banX/iPsSLkPpb1ycTjMXHU+3ApEEG56G3PAar
	 bWpaeba1d4yD5m6VWi7wFyz9exdLHTOz4hjCVxnMHFDaRnG4JAc/BxTQhQinUL/MMVA6p
	 SQhReWzj1OcmuGpki6ZcY5rNxCQU0/4OegF5hj4zF0rBxcI2KM7dU7QTfMKgG5Li5nxLD
	 7x2bxBJrm1dK7o1wmbg8ue/9CDC+E9HIN/JFphJBTthv80ibmQ7XHxruS0oGAwHMDCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807929;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=OHeodE7/fCWNJUug0INsrW2yy35XOqCUzVQG497egmY=;
	b=eTYkfuXKpCIOwDLR89nonj0A7bJpjpVWJjcCw5rFC35VnI7+VzOT6DTcuHQA9ZQhIaSY
	 9gAvRXiIn5cyWyE4XN3reB6saJsRAtYV/cw4QC5KmTCKdSaSosLq92WSB4i0T8LatdUCj
	 1VOsmle5ugZmYWN52IvXXUMZ/tHhgryI/5lKqJrP3RAN8AwKlWCXlcIx6l9HmmVgBbgFE
	 YPIGgV4XJsJcp2/q2e5QtVWEWYsdMyW5jwkk0FmwayApQ4HMFsV5OYCG5L0K4GWLpAGq2
	 hGB1XSBKLHnpTf8qtwRt+6Jj0rrMkAJvmLKVorv0jYlsSFzweFJtuetQzQC2bd1UdMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gFHcTNXJ;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4E6606A328
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 15:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B4E6606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=gFHcTNXJ
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 354661BB2;
	Wed,  4 Nov 2026 07:58:45 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E66953F632;
	Wed,  4 Nov 2026 07:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793807928; bh=qYW952awTBG6mVyQt7zz/HHIA9hqUvkzy5HXMHIkMmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFHcTNXJDZWbfpLFKYTMecfhG+Ve7P/91rkwGCycqKlL2993w4ZXNB0+XOnByetNe
	 Flm8j3BdLgPVavNYFlcK4QH4P4nnwHqhArQPaNCZxs+tf4HVZMgeqHhoax4o+0bDlj
	 d6pVRT8hw8dP1VAKpAx1JQHOk0PyhqxJ92Cb1I1M=
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
Subject: Re: [PATCH v2 19/28] arm64: Add command line switch to disable FEAT_S2FWB
Date: Wed,  4 Nov 2026 15:58:44 +0000
Message-ID: <autWNOUfxakAmVnK@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023205610.1044532-20-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org> <20261023205610.1044532-20-oupton@kernel.org>
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

On Fri, Oct 23, 2026 at 01:56:01PM -0700, Oliver Upton wrote:
> Assigning noncoherent devices to KVM guests does not work when guest
> memory is forced writeback. There's absolutely no reason to support
> this configuration, especially when disabling FWB is a valid fallback.
> 
> Add a command line switch to disable FWB in anticipation of KVM
> mandating it for noncoherent DMA. Use a kvm_arm alias that can be
> remapped in the distant future to select passthough S2 attributes
> when FEAT_S2FWB becomes mandatory in the architecture.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
>  arch/arm64/kernel/pi/idreg-override.c           | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 33cd30996e47..1c0e3b9e726d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3265,6 +3265,10 @@ Kernel parameters
>  			"nested" and "protected" are experimental and should be
>  			used with extreme caution.
>  
> +	kvm-arm.nofwb
> +			[KVM,ARM,EARLY] Disable the use of stage-2 forced
> +			writeback in KVM.
> +
>  	kvm-arm.vgic_v3_group0_trap=
>  			[KVM,ARM,EARLY] Trap guest accesses to GICv3 group-0
>  			system registers
> diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
> index 274bc72ba98d..188e1fb2eb2c 100644
> --- a/arch/arm64/kernel/pi/idreg-override.c
> +++ b/arch/arm64/kernel/pi/idreg-override.c
> @@ -103,6 +103,7 @@ static const struct ftr_set_desc mmfr2 __prel64_initconst = {
>  	.override	= &id_aa64mmfr2_override,
>  	.fields		= {
>  		FIELD("varange", ID_AA64MMFR2_EL1_VARange_SHIFT, mmfr2_varange_filter),
> +		FIELD("fwb", ID_AA64MMFR2_EL1_FWB_SHIFT, NULL),
>  		{}
>  	},
>  };
> @@ -245,6 +246,7 @@ static const struct {
>  } aliases[] __initconst = {
>  	{ "kvm_arm.mode=nvhe",		"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" },
>  	{ "kvm_arm.mode=protected",	"arm64_sw.hvhe=1" },
> +	{ "kvm_arm.nofwb",		"id_aa64mmfr2.fwb=0" },
>  	{ "arm64.nosve",		"id_aa64pfr0.sve=0" },
>  	{ "arm64.nosme",		"id_aa64pfr1.sme=0" },
>  	{ "arm64.nobti",		"id_aa64pfr1.bt=0" },
> -- 
> 2.47.3
> 

Oh, did not know about this idreg_override feature, really cool.
Patch looks straightforward.

FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

Thanks!
Leo
