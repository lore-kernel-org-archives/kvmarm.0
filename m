Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DB134CDD
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783695418; cv=none; b=cgpmyQKWsTOQO3/2C/h7DlGO/6x8sM2JA2CNCxv5+JJr14qd2oLHBHNO7QUzVnX92thYwTw1kEkvIVxlfSPtmmtrCWlSEsIf1Sx1xwHNx826k0qOOW6TGdEQJi3B9GnQvUIoaA/puRo1w6YznP70L6HsAAnuN5NTtAhuDeZ7Sek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783695418; c=relaxed/simple;
	bh=kWZ/q/+p3VrAnnSCKo1mZVef53IyupoK4tnQ+cyjDQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elMijD3dMnj3CCOFrEDuDor+Yz2KBWZcSoBtwrx6wAD1BvMMg9ZhJpcitjxIcUi4mEnjPOulJiis2lM79nlnHE3B886om2C2bCSBh8Ri6kg1Glq5H4YAbTaAPrpVExpDBwwn5uojeijACdIKJ0w7nmLUPJVpcwICtGvvhR31hrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PmuI9JkU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PmuI9JkU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21D5E1E7D;
	Fri, 10 Jul 2026 07:56:52 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AE473F7B4;
	Fri, 10 Jul 2026 07:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783695416; bh=kWZ/q/+p3VrAnnSCKo1mZVef53IyupoK4tnQ+cyjDQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PmuI9JkU97IwkYAtcl75Uz7ASKcEhVqmMSImuRNbC900dXx8548yfKX3v5WovGGgC
	 E/w6F2D3quuCi+/J+zttBFKVERBkdkznkOf6G0NfkJ9XYZZ5G7enWc3ZHaM0iucmYK
	 2nQXCAVw04K4fphEB9M2WQSNTw1DDDHrHp3ejydA=
Date: Fri, 10 Jul 2026 15:56:52 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 14/28] arm64: sysreg: Add HCRX_EL2 bits related to
 FEAT_NV3
Message-ID: <20260710145652.GD12293@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-15-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-15-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:34PM +0100, Marc Zyngier wrote:
> FEAT_NV3 introduces 4 new HCRX_EL2 control bits. Describe them
> in the sysreg file.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Checked against the spec.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/tools/sysreg | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 31e4ea455a9ce..afe9337851a2e 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -4548,7 +4548,12 @@ Fields	ZCR_ELx
>  EndSysreg
>  
>  Sysreg	HCRX_EL2	3	4	1	2	2
> -Res0	63:27
> +Res0	63:35
> +Field	34	NVnTTLBOS
> +Field	33	NVnTTLBIS
> +Field	32	NVnTTLB
> +Res0	31:28
> +Field	27	NVTGE
>  Field	26	SRMASKEn
>  Res0	25
>  Field	24	PACMEn
> -- 
> 2.47.3
> 
