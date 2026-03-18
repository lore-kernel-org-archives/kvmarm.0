Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F4E356A08;
	Wed, 18 Mar 2026 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856126; cv=none; b=Vo0llAQTmfbXgNJSIswES2wqoqJoKSY+Kh/tel0Gp7D0GS3akvVbtu8y1Vwsaqg1VLkGP/C5yweUfyRFwuknvaa9vx5DLB5ZyE7t1m4598n3PRCqxCiGbZVqLWK2qrTG/CmASyL/q8XsPc4+/tG79K2shTznzWlJM1q6AOrBTSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856126; c=relaxed/simple;
	bh=n0MnqJl2TOeHEpAg4OVfr0lxtUkQnytUwf9VSMN6vPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gf9FKAwuslq5rydqOpETjBmeXHLqbcFjV9EKdUFV5XfofysopRZNJ9F6MXBmjPWEGuIlm73/aDfJWQV3Q6JZ+k+kmDvMJJppk+bHnLEcMyikUdxLAY2vYifda/JBLnq9E0FZN+AWa6E3riS9IBtTH9h3C22RhZgET+JDApVV5Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOgv1+2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOgv1+2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAB6C19421;
	Wed, 18 Mar 2026 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773856125;
	bh=n0MnqJl2TOeHEpAg4OVfr0lxtUkQnytUwf9VSMN6vPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LOgv1+2mwpavGPO2QlnbCxclonKXFB+AxWUsJ01xE2+V1JtCkdsmGshS45GkRQh9u
	 2onntOOl8y4ZGEgr8OWwunDZjjHOQCYviLUb8rxV+ku/0xxTlsZKwIlxeyJ7px12Mu
	 86Xx/KDpcj4jMK0Ad+eAad6UyNB+GGaJyzn2FDDJxMd6jVUgIlYZTtM270S7PSSGYi
	 kWXd4e5jqIWXmza/mPZOj5lKKU7KimXD2JFJVD/NXdWvgbpko28vf/s+QdyuTnkIiR
	 G+gN0Zi9dVfhR/megVQkY4HRAtwPvz4Zw3IGRBL1tEeiAb0yOC/YQZj021qQ4eYBbF
	 N4HApQJcXAZ2g==
Date: Wed, 18 Mar 2026 17:48:57 +0000
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
Subject: Re: [PATCH v10 11/30] KVM: arm64: Store vector lengths in an array
Message-ID: <20260318174857.GI2390801@myrica>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
 <20260306-kvm-arm64-sme-v10-11-43f7683a0fb7@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kvm-arm64-sme-v10-11-43f7683a0fb7@kernel.org>

On Fri, Mar 06, 2026 at 05:01:03PM +0000, Mark Brown wrote:
> SME adds a second vector length configured in a very similar way to the
> SVE vector length, in order to facilitate future code sharing for SME
> refactor our storage of vector lengths to use an array like the host does.
> We do not yet take much advantage of this so the intermediate code is not
> as clean as might be.
> 
> No functional change.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h       | 17 +++++++++++------
>  arch/arm64/include/asm/kvm_hyp.h        |  2 +-
>  arch/arm64/include/asm/kvm_pkvm.h       |  2 +-
>  arch/arm64/kvm/fpsimd.c                 |  2 +-
>  arch/arm64/kvm/guest.c                  |  6 +++---
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 +++---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          |  7 ++++---
>  arch/arm64/kvm/reset.c                  | 22 +++++++++++-----------
>  9 files changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 906dbefc5b33..3c30c1a70429 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -77,8 +77,10 @@ enum kvm_mode kvm_get_mode(void);
>  static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
>  #endif
>  
> -extern unsigned int __ro_after_init kvm_sve_max_vl;
> -extern unsigned int __ro_after_init kvm_host_sve_max_vl;
> +extern unsigned int __ro_after_init kvm_max_vl[ARM64_VEC_MAX];
> +extern unsigned int __ro_after_init kvm_host_max_vl[ARM64_VEC_MAX];
> +DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);

A rebase issue here, rest looks good

Thanks,
Jean

