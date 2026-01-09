Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E9619E819
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 15:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767970909; cv=none; b=qP6bZT0Lpwkcajsrey0CX3tWXckimKTo4RXvrJwo4uerEOaESbmv6SYlnUBawZF0DKF3ftFcCIt7WX8UX1bay5ZXcks4rhY1gDY0tbryyw7e1tPBAOpzsqaihJ4ty1nnMpFIiEdcaeqs2wipKIpAyW05oE77NZSh5OGEw6Iqfls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767970909; c=relaxed/simple;
	bh=EfyZeMcdGYG1Wkkz7uSj7yy5+WlI+vUfvjVYy8QffGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=al7hhyxN3g6R9WYoYkIpovWC3LfXdlTQYG2jo+xXfKxb93xDC6lY3zHAVuhIbKlgh//FNm3WM+3yt3QAG1bT2mtkUwRqll/Xdw3Aw87jfQkAttsYbwdEJoUv+Qa7tdyes1QtxJMDZUOxujs5tEczN4H8vBI8yTksgNBWTfpy8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZBW6RbGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBW6RbGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C72C4CEF1;
	Fri,  9 Jan 2026 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767970909;
	bh=EfyZeMcdGYG1Wkkz7uSj7yy5+WlI+vUfvjVYy8QffGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZBW6RbGZKKBFHftx6uokbHQpCynVoLmZs2NICmpUa1v7bXPBGAjwFKxfhn8t90NJI
	 zEqfWNsJ/whwreBSBoTh6zBwAxXnOLahBravaIY/qNtxT9LZVXpl36avlzcN61vav5
	 yixpkpJNrRNQTvf53dE1ViP2FzWK9NQrgHze4huLEqNPq7TLNMfA1D8/0mZjW/ylRf
	 LZrczl6JSkv7lNxbC4buxZCUtxPevDHOJRlxW/Me2VdWR4IFE9PHCUckqCWrDf/O0e
	 WJygYDeM6k9GZ3RiZhqKJcZ+iD3v+yYBAr4IgxFDxmNvW8E4qjwwlzBoLGzQqKtA8T
	 4RpZrGWFI11nQ==
Date: Fri, 9 Jan 2026 15:01:43 +0000
From: Will Deacon <will@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 24/30] KVM: arm64: Implement the MEM_SHARE hypercall for
 protected VMs
Message-ID: <aWEYV-Pg5tPCtvaQ@willie-the-truck>
References: <20260105154939.11041-1-will@kernel.org>
 <20260105154939.11041-25-will@kernel.org>
 <aV0uJDtZwbu2iKhs@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV0uJDtZwbu2iKhs@google.com>

On Tue, Jan 06, 2026 at 03:45:40PM +0000, Vincent Donnefort wrote:
> [...]
> 
> > @@ -952,6 +1004,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_HYP_MEMINFO);
> > +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MEM_SHARE);
> >  		break;
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID:
> >  		if (smccc_get_arg1(vcpu) ||
> > @@ -962,6 +1015,14 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
> >  
> >  		val[0] = PAGE_SIZE;
> >  		break;
> > +	case ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID:
> > +		if (smccc_get_arg2(vcpu) ||
> > +		    smccc_get_arg3(vcpu)) {
> > +			break;
> > +		}
> 
> I wonder if that shouldn't go into pkvm_memshare_call(): that function has the
> knowledge of the argument content since we pass vcpu.

I decided to keep all the zero-arg checking in the top-level switch so
that people adding new hypercalls are encouraged to add those checks as
well :p

> Otherwise:
> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Thanks,

Will
