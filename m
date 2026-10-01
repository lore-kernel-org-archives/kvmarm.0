Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78DF4F68DD;
	Thu,  1 Oct 2026 11:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790854108; cv=none; b=CEkL6hyGfGrBFIGC7tYmB2XtXtIvUR10RJwIBQiwYPjX4J71rdvBXaVuPbc8DF+M6XecEJA7CCL/VIpNzn5AdTt11BKqMNRPlRPmrlYILBGwqeOeIu7E5nN8ZphYE/97mBdwBx05HfHB85euYVpUouioIjnuS93PkxYt3dKWcT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790854108; c=relaxed/simple;
	bh=+aPFoqTRZI9aQaQwPIfthfWsP7uMV9Fzj9lzvBTtCJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiskNmczANa8/gH190V3UEI2U83seJwjU12joxtCPnGWqlZ6jSOZxmDREG7toAnZSMJdxMYEJm0Bn7zz2BAG1q2HL97MEmpqZNsCpgqzSfdhKn9oAJT8rmCfppmf4yfsMOwn1hSPkNCNDTfNBhzD9rv9OaSijb2tNV11dwfioRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tv79kSWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tv79kSWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344A51F000FF;
	Thu,  1 Oct 2026 11:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790854099;
	bh=ds5ik7E8aFeLG9+eGz+NlTxnIFC20DsaI0MfbH9KF6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tv79kSWilx5o3Mgjnv6DJsulMK1FxPD1gS7DssuJbuIB6XLXKDDufYKPtTkUgG+1c
	 /GZZ/EqB3dXenONMYETxi+vZA1vJPnF3avtbUEqXo3PoU8+p7tqVAs1uPLVG334ry2
	 4UuZk7zTvGoXN1nEDe7nL0MUkhudPFMxNllKQOiey7dMnF1/OlUTxL9ZzQHcLIe3Wd
	 Ntct4FD7P/KhiRrAUxYYnfzjt/5SKCzPQF66AAe+NgkWQJsOl4YmWjrATckyU92tLU
	 gKj3M8oIOr4ZJV52WDQEu+jEDngRReB2YxkeviHwajemKI/fVnOSCha7vmP9rckloa
	 zZqZzJXDWUIOg==
Date: Thu, 1 Oct 2026 12:28:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 03/15] KVM: arm64: Manage GCS access and registers
 for guests
Message-ID: <ar5DIENoWVSOTQsY@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-3-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-3-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:13PM +0100, Mark Brown wrote:

> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

With the preceding patch and the additional change below to extend the
invariant to GCS as well, the issue with incorrect save/restore is resolved
and this LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3ae293798b27..823460106de8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c

> @@ -5875,6 +5917,9 @@ static bool kvm_validate_id_regs(struct kvm *kvm)
>  	if (kvm_has_s1poe(kvm) && !kvm_has_tcr2(kvm))
>  		return false;
>
> +	if (kvm_has_gcs(kvm) && !kvm_has_s1pie(kvm))
> +		return false;

OK nice this extends the invariant to cover GCS as well!

--
Cheers, Lorenzo
