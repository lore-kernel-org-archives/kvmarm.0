Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D0E3CA4B3;
	Wed, 15 Jul 2026 08:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784103925; cv=none; b=Kvt1XzfqTsWMUDt0i/K2g3LzyY/+eVIbVi30ndcJC1IkXijON8YZI8giBhEt5wm8++PT9AYqYAIdlExxd1m1xIj9H7aNb2tr9Nd3AiCFHZXjB8PdWxTSRkO5ew9DQodRANhME7+TJspBEQvZpScjN0trroJPeKt3RqVSnlZDFAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784103925; c=relaxed/simple;
	bh=RvBp90OIHW4nGr71Q7jGNtp/GYDqRuS8DOHVzuvFy3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GA0LHD1QyaoH4NXTbOm0ibmQMx6BbOELrMF/Jjp9sDL7n2T0DERXmoxVQEbtK6P9vkixA7Rj4Sk+KOptQLZ8M96nX6G8659ucEVgm5QhrFl3YEQAPxq+4KIiSqOthePHkCpRRAxhc5vAyp7tIgO/WQiFykPu9AvWESvvYA8GxMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BX3+yfwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BX3+yfwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33EB1F00A3D;
	Wed, 15 Jul 2026 08:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784103924;
	bh=M8aSEDEK6ZPgt07ch8i5G0m8dM5j9fAVclCMjxvWcOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BX3+yfwq25Y7fZyDbwcjjnC7civgxwrMYEi7Bw48MC0GfbEpBwqA/oyZe4euVTH8D
	 xzg+fI4mpLrP6H4Yhi6h6wgxyFjAH01R3PuG6WitKKFua20A/y6IV1OaC5zyRRKEP8
	 //YaxE9fkG5EDEojKw4+WjGO8rmDmnVguSLc71SJ/h/URrc3M9RE561kKDGrI89fud
	 cTtLYZ4bgbIpJ0JMVErt3h9mSOR9xqVkihO5Dd7aGUZSOUW+bsWGfvDf9PL9HlUNqA
	 cjm3k623kMUKGFdt+n9r3k98BPtKwStDHBcln/WRyr/cd/8O2jwNdq2PhD6oVt9GFE
	 QZK0JkdolT/Sg==
Date: Wed, 15 Jul 2026 01:25:22 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 07/28] KVM: arm64: Don't evaluate HCR_EL2.NV nor
 HFGITR_EL2.ERET on ERET fast path
Message-ID: <aldD8rdS06QlI_nU@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
 <20260714091641.1970822-8-maz@kernel.org>
 <alc-JSvHDjSV5c_G@kernel.org>
 <86ech4oebm.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ech4oebm.wl-maz@kernel.org>

On Wed, Jul 15, 2026 at 09:19:09AM +0100, Marc Zyngier wrote:
> On Wed, 15 Jul 2026 09:00:37 +0100,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > Hey,
> > 
> > On Tue, Jul 14, 2026 at 10:16:20AM +0100, Marc Zyngier wrote:
> > > We currently avoid using the ERET fast path if the guest has HCR_EL2.NV
> > > set. This is an odd check, as NV doesn't mean much if HCR_EL2.TGE==1.
> > > 
> > > Similarly, evaluating HFGITR_EL2.ERET makes little sense, as
> > > this only applies to the nested context, while the ERET fast-path
> > > is purely for the benefit of L1.
> > > 
> > > Replace these bizarre checks with is_nested_ctxt() which makes a lot
> > > more sense: if we are running an L2, the ERET trap must go to L1.
> > > 
> > > Fixes: dd0717a998f77 ("KVM: arm64: nv: Fast-track 'InHost' exception returns")
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/vhe/switch.c | 9 +++------
> > >  1 file changed, 3 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > index bbe9cebd3d9d5..a83be345f8450 100644
> > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > @@ -344,13 +344,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
> > >  	 * if this is a VHE guest hypervisor returning to its own
> > >  	 * userspace, or the hypervisor performing a local exception
> > >  	 * return. No need to save/restore registers, no need to
> > > -	 * switch S2 MMU. Just do the canonical ERET.
> > > -	 *
> > > -	 * Unless the trap has to be forwarded further down the line,
> > > -	 * of course...
> > > +	 * switch S2 MMU. Just do the canonical ERET unlesss we are in
> > > +	 * nested context.
> > >  	 */
> > 
> > typo: unless
> > 
> > I feel like it wouldn't hurt to add a bit more detail to the comment
> > here, that L0 KVM doesn't use ERET traps in the nested context.
> > Otherwise it isn't clear why these always belong to the L1.
> 
> We already have a tiny bit of information in kvm_handle_eret(), but
> that's obviously a bit far down the line. Something like this?
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index a83be345f8450..684cebf23aa0e 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -344,8 +344,13 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * if this is a VHE guest hypervisor returning to its own
>  	 * userspace, or the hypervisor performing a local exception
>  	 * return. No need to save/restore registers, no need to
> -	 * switch S2 MMU. Just do the canonical ERET unlesss we are in
> +	 * switch S2 MMU. Just do the canonical ERET unless we are in
>  	 * nested context.
> +	 *
> +	 * Note that this is made possible because KVM itself never traps
> +	 * ERET when running an L2. The consequence is that any ERET trap is
> +	 * the result of HCR_EL2 or HFGITR_EL2 programming by L1 for its own
> +	 * guest, and the exception must be forwarded to L1.
>  	 */
>  	if (is_nested_ctxt(vcpu))
>  		return false;

Works for me!

Thanks,
Oliver
