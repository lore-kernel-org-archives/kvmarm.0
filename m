Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1FB4E36E2;
	Mon, 28 Sep 2026 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790614071; cv=none; b=u9BrDRFnvIT5WIX3NhW43Gs9GdSO0SuV0m8umz/BmXG3b6DGnCwSbq8YNYeeBXg8yfKde4KEZa26nXM8tschvCoth6am4968C3kDUa23tQ7R52hObWi/xV1TARpumSsaWSdJqMGA7uLQPZRalOnVEZrhdWwfDdUU3hI7ks9dKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790614071; c=relaxed/simple;
	bh=gDcfPVtVHcW+Cf5+ngnOwHcglgx37KLaTQTgKxKa3cE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQJccASmnMEPVgmVYPuCLy9cEZnzhMWUgaw9VifpWWnBOUQmf9ANhurUzmv1bEj0ycJHZj/cwVV8hkj12Kyvzx5/k3tXxM1jiLARN6PiSHtxzqz2hzlFbiUrktujwICXDGQVhpB70aaywUgTCIbc1pyeKNcDxA+R2bgv/Rkz4Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCZ+hg67; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCZ+hg67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B901F000FF;
	Mon, 28 Sep 2026 16:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790614070;
	bh=bBHDYTHQuD+7hDiMCy60LWuK31N8uebgNh3zqIFzM+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cCZ+hg67XzC2jBoGZl4v2d3k4A9DhpNvXtX3hMhlpjuq6qKiUPqSjlMgVgO1XwH6o
	 PSIszuGRmTWG2fuVfM/iqrvhzO93YywJ0VzwvxZXYrR40h0YyrSJhUPBwVIPqktQZG
	 +f9OWW2Zo8jahPDqDzpGtNkp8sg3jinGCF6rxX/fRN1E9CzaKJI4w6asKjgQ9C6jYp
	 rU5gdTMA0wo7ojyLC2wWubmtGOzmA+S7NtTbtkDLWG+ldnKUFhblUOv1UXNq+lN0Ug
	 gcLKGqbLWIJZdeR8Tgnr7n+3EdP5l8h0hBcnwhky1SpHbcf1YAH67E5GkZ47Uv/RHV
	 2ck0j1F6+yENA==
Date: Mon, 28 Sep 2026 09:47:48 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 04/10] KVM: arm64: nv: Return a failed stage-2
 descriptor read as a fault
Message-ID: <arqaNHGzVfMpVha5@kernel.org>
References: <20260928152507.2116110-1-fuad.tabba@linux.dev>
 <20260928152507.2116110-5-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928152507.2116110-5-fuad.tabba@linux.dev>

On Mon, Sep 28, 2026 at 04:25:01PM +0100, Fuad Tabba wrote:
> When KVM walks an L1 guest's stage-2 tables and can't read a
> descriptor, for example because the guest points a table at an IPA with
> no memslot, it sets a synchronous external abort on the walk but
> returns the -EFAULT from kvm_read_guest(). As with an invalid
> VTCR_EL2, KVM then leaves AT S12E{0,1}{R,W} unretired, so the guest
> retries it forever. On an L2 abort, KVM injects the abort and
> returns -EFAULT from KVM_RUN.
> 
> Return 1, as the walk already does when it can't update a descriptor,
> leaving -EAGAIN from a descriptor race as its only negative return.
> The AT then retires with the external abort in PAR_EL1, which is what a
> stage-1 walk records for a descriptor it can't read.
> 
> Fixes: fd276e71d1e7b ("KVM: arm64: nv: Handle shadow stage 2 page faults")
> Fixes: 92c6443222ca4 ("KVM: arm64: Propagate PTW errors up to AT emulation")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a67be19e73250..f9a2e50c0b567 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -304,7 +304,7 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, phys_addr_t ipa,
>  		ret = read_guest_s2_desc(vcpu, paddr, &desc, wi);
>  		if (ret < 0) {
>  			out->esr = ESR_ELx_FSC_SEA_TTW(level);
> -			return ret;
> +			return 1;

Hmm. Rather than fixing these things individually, I'd prefer aligning return
codes between the S1 and S2 walks. I agree with the approach; negative
return codes should be reserved for host-visible failure reasons whereas
everything guest visible gets communicated through s1_walk_result /
kvm_s2_trans.

Thanks,
Oliver
