Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBBD311C2A;
	Wed, 18 Mar 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855020; cv=none; b=C3yDrwDM4PKWMNWhp+TVDsu3M48CHUr4E+7a/v9116QJ6UmEWz9bA/qAGCn9/4AKf9PWc+aGZjeNZsCO/U1TsFfVHfbcJXMj1uKRtpP7NOU5JBj+aaL8AxEA6FEPGbGGDC00A4JDQisvXU5Ph8GK6+bivhGPiuKhtkPb4Qv4CGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855020; c=relaxed/simple;
	bh=tH6Xpo5vJv6+B5LeABImygawpoxYpTo3oFFwWdJdbG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEl0TZmAHkK4cgw5cE3AXKLIGVjb1UDWbSGq6gqaItVYhDIeTxT58ptbS04UUHjUJDL8G0Mcz/IAN4vvgMz6tt/FCQj78c528rh5WhoSmuwMwuWOTqf0CjAL00Yi0W91CSITAsfhzHNmMz3dxq7GPsEN+M96/LDzc/27g7WtiFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewp/L6vZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewp/L6vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E44C19421;
	Wed, 18 Mar 2026 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773855020;
	bh=tH6Xpo5vJv6+B5LeABImygawpoxYpTo3oFFwWdJdbG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewp/L6vZJk/jgds3H9pQSa7aOWcU+7xVH93TfvwnIFEY9FqTu9yCCOGTJ8am12C5P
	 yytH4QCbccaGd1AzliYx0ddiODu5VSsMf1W+TiyEYltv2I0SRHm80Chz4ldkDMFTWQ
	 IzNCNzuxE/an2aJ2VBSZMF/845rErytnCrG5tvuSOOjO1fUmZQV8VYvbWvsUYFj6EW
	 OuTNfphk54u92dVzA+saqfmqmXlaBW/GDOMIH5clmeEayLhqQqWSTMPe0X/nJn/Msz
	 9UXjHhJPBwkiU1EmU1mELq/Jq9AoFUfA7NJoHcHQ2l/sTZiNipld8wlK5XOeOQM95i
	 /om8t+uW9bxaQ==
Date: Wed, 18 Mar 2026 17:30:32 +0000
From: Jean-Philippe Brucker <jpb@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
	Fuad Tabba <tabba@google.com>, Mark Rutland <mark.rutland@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v10 05/30] KVM: arm64: Pay attention to FFR parameter in
 SVE save and load
Message-ID: <20260318173032.GC2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-5-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-5-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:00:57PM +0000, Mark Brown wrote:
> The hypervisor copies of the SVE save and load functions are prototyped
> with third arguments specifying FFR should be accessed but the assembly
> functions overwrite whatever is supplied to unconditionally access FFR.
> Remove this and use the supplied parameter.
> 
> This has no effect currently since FFR is always present for SVE but will
> be important for SME.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Jean-Philippe Brucker <jpb@kernel.org>

> ---
>  arch/arm64/kvm/hyp/fpsimd.S | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index e950875e31ce..6e16cbfc5df2 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -21,13 +21,11 @@ SYM_FUNC_START(__fpsimd_restore_state)
>  SYM_FUNC_END(__fpsimd_restore_state)
>  
>  SYM_FUNC_START(__sve_restore_state)
> -	mov	x2, #1
>  	sve_load 0, x1, x2, 3
>  	ret
>  SYM_FUNC_END(__sve_restore_state)
>  
>  SYM_FUNC_START(__sve_save_state)
> -	mov	x2, #1
>  	sve_save 0, x1, x2, 3
>  	ret
>  SYM_FUNC_END(__sve_save_state)
> 
> -- 
> 2.47.3
> 
> 
