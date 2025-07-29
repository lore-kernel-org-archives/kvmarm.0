Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A0F287266;
	Tue, 29 Jul 2025 15:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804479; cv=none; b=WfjUxyp0o4f8nDLNIvo/02FXfDwMdRUkIWpgBcUjmN2IntvowtEKz1LhqZ64ttraqd554Lug3ut6OSkI3cvy17B8v1tzIknHqhJK8wbTeDglrNjdE30a8cBJDORSmrN/DGXdPw6bWe+R/cRXIqtJJp0KlSi4bb9RkDzrdT+oUtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804479; c=relaxed/simple;
	bh=n3Jk+CPILaJYaCx7aTV41IfzLXf10369ycUvb31MdKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mFVFHhuwYUiiAFEanROPQYS7pSlxScALvP9fTSHAqNjsRcAY2UNocAp7iS+wh2jlXPPboEQnmBxyLxwmsiiALtnBcSPqahEt2QcG665Z/P6hQQHf1px8nSb2N4mMYwS55WHmWJvGtt7IFdqR3+gWKuK82NqbVe6Xrna/MVw8D/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYavHetW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYavHetW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7B0C4CEEF;
	Tue, 29 Jul 2025 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753804479;
	bh=n3Jk+CPILaJYaCx7aTV41IfzLXf10369ycUvb31MdKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SYavHetWDdRQrwYVwiIDQu/+5/kxpO6SdrYzb559IzsmNAvSyIhnYpjdQdEORxUT+
	 JelpcInB+0Tstp+5et8taFYA9aj2ng6IwTqOAzuDl/W/2+E368U9x+PuMVvzinefWE
	 KP+0J9bv/rtIoyV+GlZdej6VomTyj9k3DpF+DchtUYOoTfK0f6jFls4XjKOrIY+GwF
	 YW0KXfdCSMyZyzm511WjZDHjph8iFbYapkgcTPuKMxYjAKJcx5GM/C7d6ncBJAcm69
	 KIZqUly7CdiGPjfP9Ve9PUZLbwVJWvp5IsjOt/XPAz1LGXmEq5JdLAybekNIO47nVN
	 +puzQQug3keTg==
Date: Tue, 29 Jul 2025 16:54:33 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v8 7/7] KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in
 host handler
Message-ID: <aIjuuTf2az25A7jW@willie-the-truck>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
 <20250719-virtio-msg-ffa-v8-7-03e8e8dbe856@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250719-virtio-msg-ffa-v8-7-03e8e8dbe856@google.com>

On Sat, Jul 19, 2025 at 02:11:29AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> FF-A 1.2 adds the DIRECT_REQ2 messaging interface which is similar to
> the existing FFA_MSG_SEND_DIRECT_{REQ,RESP} functions except that it
> uses the SMC calling convention v1.2 which allows calls to use x4-x17 as
> argument and return registers. Add support for FFA_MSG_SEND_DIRECT_REQ2
> in the host ffa handler.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index f6d964df53c3e21ba85984f35cc7b6859012d1b0..363374408b354a5d65861b9cf140974d8914ff40 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -851,6 +851,15 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
>  
> +static void do_ffa_direct_msg2(struct arm_smccc_1_2_regs *regs,
> +			       struct kvm_cpu_context *ctxt,
> +			       u64 vm_handle)
> +{
> +	struct arm_smccc_1_2_regs *args = (void *)&ctxt->regs.regs[0];
> +
> +	arm_smccc_1_2_smc(args, regs);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
>  	struct arm_smccc_1_2_regs res;
> @@ -909,11 +918,18 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  	case FFA_PARTITION_INFO_GET:
>  		do_ffa_part_get(&res, host_ctxt);
>  		goto out_handled;
> +	case FFA_MSG_SEND_DIRECT_REQ2:
> +		if (hyp_ffa_version >= FFA_VERSION_1_2) {
> +			do_ffa_direct_msg2(&res, host_ctxt, HOST_FFA_ID);
> +			goto out_handled;

I think it would be cleaner if ffa_call_supported() returned false for
this when the FFA version is < 1.2

Will
