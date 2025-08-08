Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE24F1CAB3;
	Fri,  8 Aug 2025 12:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754656881; cv=none; b=h4dsQpu0ss1bXDhWxlyMj3bQmObU17DsSwfa8BfUBIqVuYzQMg6RZ83tMgux/8cTOZ91egH2/d5hDTkyE0tCocMTCdNtvGxIctCiK7bSmFT3O0dbZkUvmFYdzY7RcUlzfpzx2YOlmvnshB2t80xhNf17RjfQ6li17zUS4V5Yvt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754656881; c=relaxed/simple;
	bh=zlgu9JSVlseeLyVrq6HQ3TQhoDjjj/5JeROwbBJkVLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5/xdB/yreciagC6SZTSg6DB3y+MOevVzMiX6N1dIAchMlYOF1lkrQtX05CsJXwB6u1OvXCi3FIO1Yo1etUCTlbDaIPwGXnCjXFNT7OmWbPlRZ4G5Jf71B0Qtph/dY/0Fg/kRTTej83CbilfdU/szH4xx1WemycRIeqKq3ydKio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxSs+j5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxSs+j5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2220EC4CEF4;
	Fri,  8 Aug 2025 12:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754656881;
	bh=zlgu9JSVlseeLyVrq6HQ3TQhoDjjj/5JeROwbBJkVLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GxSs+j5ft/UKaggtneb1Y+z4+vN3e+LSz3cz+zbyVrW5boZXsOxE+cbnxfX3HQwT8
	 7PH6nay715b1YnyU66BVfb4FXTAf39zoaj/CmtElLTUmgzMdqRxmtUx7hXZI+nMdTp
	 iu4eMTQDTGR6ZMHSfMx7RFwGKeH84QQPfEXKnNnLPTvUWnhijvSsLDTXX/yf2lFy2y
	 agqiFdLEJWZC21Q84CdXd7ebBcWrNJpH5NazkrF7ca0DJeEYZX0m+CsIqUOTJkM6AI
	 jVsWYUw7BMmc7giBmlVy7AWxXBDM9ssqvVzAPbzsDUyzIzZ3a1LlSFxz0l0xwjg9+e
	 0V5esqtG6Balg==
Date: Fri, 8 Aug 2025 13:41:14 +0100
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
Subject: Re: [PATCH v9 4/6] KVM: arm64: Mark optional FF-A 1.2 interfaces as
 unsupported
Message-ID: <aJXwan8iMtRBkiPX@willie-the-truck>
References: <20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com>
 <20250730-virtio-msg-ffa-v9-4-7f1b55c8d149@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730-virtio-msg-ffa-v9-4-7f1b55c8d149@google.com>

On Wed, Jul 30, 2025 at 09:15:07PM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> Mark FF-A 1.2 interfaces as unsupported lest they get proxied. Also mark
> FFA_EL3_INTR_HANDLE as unsupported as it is only valid for physical
> instances.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 48183fa78014e420372c4fb5e489519bc652bf53..7fe96fe626d630a9009551e8dec1683617acafbd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -674,6 +674,13 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_NOTIFICATION_SET:
>  	case FFA_NOTIFICATION_GET:
>  	case FFA_NOTIFICATION_INFO_GET:
> +	/* Optional interfaces added in FF-A 1.2 */
> +	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> +	case FFA_MSG_SEND_DIRECT_RESP2:		/* Optional per 7.5.1 */
> +	case FFA_CONSOLE_LOG:			/* Optional per 13.1: not in Table 13.1 */
> +	case FFA_PARTITION_INFO_GET_REGS:	/* Optional for virtual instances per 13.1 */
> +	/* Unsupported interfaces added in FF-A 1.2 */
> +	case FFA_EL3_INTR_HANDLE:		/* Only valid for secure physical instances */

Shouldn't the secure side be rejecting that one for us, then?

>  		return false;
>  	}

Regardless,

Acked-by: Will Deacon <will@kernel.org>

Will
