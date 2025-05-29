Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E622256F;
	Thu, 29 May 2025 12:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748520332; cv=none; b=Z/4WHmRJfiiUYnwG9Tc3YEtWgghwX4vuK4LJ38zwndFemYiA/u98PQ/TqVUb7e/M95C0mBsulBi1Dmhnmwbznf2Puh2ekslocEcXcw/M3wPkce20phyWaBJeMHlgerBf6rUtsea2E66lYF8BoPt8kt6KeETn6oIPYO5FHw0uXVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748520332; c=relaxed/simple;
	bh=8I/UWuszTYHqaey/kP67a900h+P9udkFPXSQpcAGIl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELbBpObFEO5505pqULUuS6zt9J+mp1F5w1RQwVENxAfU3cvFvj/wHeDZa9i1t1CJN3PnOiDNJiCElb5zqorbAwMjDdl9W+MgFGG6FWt11e5hGzLkmyrZCyYbX7se5kuOrsIQaokDdlAo5dpttuv7r0+pkfGvWTXHMz8z/zY3OuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4dxqYAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4dxqYAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCB5C4CEE7;
	Thu, 29 May 2025 12:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748520331;
	bh=8I/UWuszTYHqaey/kP67a900h+P9udkFPXSQpcAGIl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T4dxqYAvZ54FKoVTj+yydgfIVvF/MnkLhnLXZnTR4ayNz5QvjWEoq4myi5AvbFfAm
	 DUik26A7WJfdEZn2Oavw5VB35a7oD37DLB6bACy/AcZYQJ1FsQhdQ6z874mM+rKNyK
	 NE9lT1NtdwjTyJULJvVgf3R175yapp8HcDemurLEuVAOniMKakZp7ko/pODiWSIRLw
	 mfQMlaQP9ooRzSAvU+QH//MLMNUffj17tLGYdBF5hLOb66qByfsDMtQ5zRdSqDfZMx
	 AaBAGFzMQFa8zQ6ZBpjrTm+58HiFVK+uyN40qv4cgPpby02raRrBdrtmWjJjBDzkZv
	 MwR/NA+c4+urA==
Date: Thu, 29 May 2025 13:05:24 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, sebastianene@google.com,
	qperret@google.com, qwandor@google.com, arve@android.com,
	perl@immunant.com, lpieralisi@kernel.org, kernel-team@android.com,
	tabba@google.com, james.morse@arm.com, armellel@google.com,
	jean-philippe@linaro.org, ahomescu@google.com
Subject: Re: [PATCH v4 3/5] KVM: arm64: Mark FFA_NOTIFICATION_* calls as
 unsupported
Message-ID: <20250529120523.GA29242@willie-the-truck>
References: <20250516-virtio-msg-ffa-v4-0-580ee70e5081@google.com>
 <20250516-virtio-msg-ffa-v4-3-580ee70e5081@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516-virtio-msg-ffa-v4-3-580ee70e5081@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 16, 2025 at 12:14:02PM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> Prevent FFA_NOTIFICATION_* interfaces from being passed through to TZ.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index b3d016bee404ce3f8c72cc57befb4ef4e6c1657f..a545d25002c85b79a8d281739479dab7838a7cd3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -632,6 +632,14 @@ static bool ffa_call_supported(u64 func_id)
>  	case FFA_RXTX_MAP:
>  	case FFA_MEM_DONATE:
>  	case FFA_MEM_RETRIEVE_REQ:
> +       /* Optional notification interfaces added in FF-A 1.1 */
> +	case FFA_NOTIFICATION_BITMAP_CREATE:
> +	case FFA_NOTIFICATION_BITMAP_DESTROY:
> +	case FFA_NOTIFICATION_BIND:
> +	case FFA_NOTIFICATION_UNBIND:
> +	case FFA_NOTIFICATION_SET:
> +	case FFA_NOTIFICATION_GET:
> +	case FFA_NOTIFICATION_INFO_GET:
>  		return false;

Acked-by: Will Deacon <will@kernel.org>

That said, I wonder if we should revisit this denylist along the lines
of the discussion with Oliver on the initial FF-A proxy series:

https://lore.kernel.org/kvmarm/ZGx0QBZzFCmm636r@linux.dev/

We check for is_ffa_call() already, so we could invert the above to be
an allow-list for calls within the FF-A range rather than a deny-list.

What do you think?

Will
