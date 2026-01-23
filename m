Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69A01A08BC;
	Fri, 23 Jan 2026 12:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769172949; cv=none; b=dbrmPn60NpTIl3ub7iE2hhnPYslSYzwSJz7Q1R/z65X7M91WC6jRwUW79ZS0DfE3OD8fTS17CKKY51fn+y932H706MbbqAnkseJRnjzAl9nPFJ3Ezj45RVmKgX6Tufklm27oJNfrbmOB3e41qFWNJcv08BTQ6VFgcc9o0fmeLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769172949; c=relaxed/simple;
	bh=GcaMgzzRJVMZIDYWEMwJdb54aJDPROHZoomAa2LyUcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jrSNawj2aVD3a1l2bWBTN9tZ5dCmoBSmtrox9qV6O6F4AWywcsH9HS9tGV91PLpWNdumSTyBq4pc4dcUdb2+g7KAJkJWZ17hPhBCtBoc5nBUJa8I16rZ0Mk5NuRvnjJTdeBZKF7mSYzp9WqWudj+Gsbl7u43RDKuRhvMEwHIZoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pHcFHW/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pHcFHW/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A79C4CEF1;
	Fri, 23 Jan 2026 12:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769172949;
	bh=GcaMgzzRJVMZIDYWEMwJdb54aJDPROHZoomAa2LyUcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pHcFHW/XhoB4yR0c7RrUSgqzjTmQdT1JTb99sdK1mTjrZmaQIQ+gUXZbsp7k9r28E
	 4p5EX8n2PnELlfa7oVBobJOmjRGf8wAllbJGLU0V7jrNXvvwWrrpMrIY9P9oEwWqIJ
	 fLD5aEHRJGBACNclN6lUXppO/IjA/xnQ78XsUe3BilaBfZmTcbRB7UN0vZqYFiW3SW
	 u/lWYw64BNivYn82XTc4GsytJo3C+euWJJ6eyz8xApcXSSqulp2B/e1pVysA3j+L+k
	 0W9kWRYfZLxhWsLJQnxDAT4WXNPqHZI45GdP0B4pxHA3UGwKfnZwG1nI8wBUNINagx
	 yVq7lABae2stQ==
Date: Fri, 23 Jan 2026 12:55:43 +0000
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in
 host handler
Message-ID: <aXNvzxoBXr-oRB8r@willie-the-truck>
References: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
 <20260121-host-direct-messages-v5-1-2c1614c94e80@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-host-direct-messages-v5-1-2c1614c94e80@google.com>

Per,

On Wed, Jan 21, 2026 at 08:27:12AM +0000, Per Larsen via B4 Relay wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
> Allow direct messages to be forwarded from the host. The host should
> not be sending framework messages so they are filtered out.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index f731cc4c3f280a32acccca0de92b9ac6c8e05602..9967916278a7ca051500946ef2fcfe7bb40e0e8d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -862,6 +862,28 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg(struct arm_smccc_1_2_regs *res,
> +			      struct kvm_cpu_context *ctxt,
> +			      u64 vm_handle)
> +{
> +	DECLARE_REG(u32, flags, ctxt, 2);
> +
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	if (vm_handle != HOST_FFA_ID) {
> +		ffa_to_smccc_error(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}

Sorry, but this isn't what I had in mind. 'vm_handle' is just a local
variable and the only caller passes HOST_FFA_ID, so this isn't really
achieving anything.

What you had in v4 dropped the 'vm_handle' argument entirely, which I
think is the right thing to do. However, the FF-A spec encodes the sender
ID in bits 31:16 of register W1 and so _that_ is what I think we should
be checking because _that_ is what the receiver will see.

Honestly, we could avoid quite a lot of these review cycles if you
actually replied to my emails on the list instead of just responding
with a new patch series each time. It's supposed to be a technical
discussion...

Will
