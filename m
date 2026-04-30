Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3483AE712
	for <kvmarm@lists.linux.dev>; Thu, 30 Apr 2026 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777585227; cv=none; b=BkWm3eAjFc/vyGtD2OPziZDM/JnaSBwJ9gv+nGmwpNvLVCgrtx6DeDFYYFG3B3o1d/IKNFjeh95pO6kJd78s0OtfG6XK6lq+h7khw5kKV+nv9K+S9dLr6pHkvGyrLRYx2/ubWdjU4e+pNv8s3PDINl2wT0xxDc6WsjMbeBfnMKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777585227; c=relaxed/simple;
	bh=8lyAwzWVTmFDUmliFb03cvHhr/tGqRi0gI3snoi4/Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBVpBpwfyWqGbqd4dxlM77KIkvokJS6USbHTu90yu95MP+mYN4vYv6b+n7YzY6MKi2pT7qcemGMEGRB/OyY9NTde5InPIH7x6frcls+26AHA0J+iIrW/nMdZhF6Mwe2+243IcElQDsFCfzMeL+mMUZHgKaPay1kzv6wul82f/zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jEVDxx9N; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jEVDxx9N"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE69E169E;
	Thu, 30 Apr 2026 14:40:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50E453F763;
	Thu, 30 Apr 2026 14:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777585224; bh=8lyAwzWVTmFDUmliFb03cvHhr/tGqRi0gI3snoi4/Zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jEVDxx9Nr8dqUAI3cJEY920Hm3c+qicOYErtC8OS4rmzF3gQaVhR/BvUf/gEd+Qh6
	 iOl2CVAia5mkOb7KlDqGDY3/odBKfUwxZsCbLdO1ZlubiMLcFMG/i/xi+diYebfftd
	 g3MJFOLRZFlb3Af1MCknmn/nS91k5pw5wISRKS1g=
Date: Thu, 30 Apr 2026 22:40:19 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Armelle Laine <armellel@google.com>,
	Sebastien Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/2] KVM: arm64: Support FF-A direct messaging
 interfaces
Message-ID: <afPMQ29x5fjHwtDo@e129823.arm.com>
References: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-host-direct-messages-v5-0-2c1614c94e80@google.com>

Hi Per,

May I ask how this patch is progressing?

Thanks!

> Support FFA_MSG_SEND_DIRECT_REQ unconditionally.
> Support FFA_MSG_SEND_DIRECT_REQ2 if hypervisor negotiated version 1.2+.
> 
> Framework messages (FF-A control plane) are filtered out. For
> FFA_MSG_SEND_DIRECT_REQ, we look at flags in w2. Messages using the REQ2
> interface are always partition messages.
> 
> The second patch was part of a previous patch set [0] but was dropped
> since the use case was unclear. A clear use case has now appeared: use
> TPM device with CRB over FF-A when kernel boots with pkvm [1].
> 
> Tested by booting Android under QEMU.
> 
> Best Regards,
> Per
> 
> [0]: https://lore.kernel.org/all/20250730-virtio-msg-ffa-v9-0-7f1b55c8d149@google.com/
> [1]: https://lore.kernel.org/all/20251027191729.1704744-1-yeoreum.yun@arm.com/
>  
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
> Changes in v5:
> - 1/2: do_ffa_direct_msg: validate that sender is HOST_FFA_ID.
> - Link to v4: https://lore.kernel.org/r/20260109-host-direct-messages-v4-0-95da4221d186@google.com
> 
> Changes in v4:
> - 1/2: do_ffa_direct_msg: check that flag in w2 is zero; drop unused vm_handle parameter.
> - 2/2: ffa_call_supported: simplify logic by reordering cases.
> -      do_ffa_direct_msg: switch polarity of check and update comment.
> - Link to v3: https://lore.kernel.org/r/20251119-host-direct-messages-v3-0-c74d04944b26@google.com
> 
> Changes in v3:
> - Filter out framework messages as suggested by Will Deacon. Update cover letter accordingly.
> - Update trailers: Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> - Link to v2: https://lore.kernel.org/r/20251030-host-direct-messages-v2-0-9f27cef36730@google.com
> 
> Changes in v2:
> - 1/2: Drop support for FFA_ID_GET interface in host handler.
> - Link to v1: https://lore.kernel.org/r/20251030-host-direct-messages-v1-0-463e57871c8f@google.com
> 
> ---
> Per Larsen (1):
>       KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ2 in host handler
> 
> Sebastian Ene (1):
>       KVM: arm64: Support FFA_MSG_SEND_DIRECT_REQ in host handler
> 
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
> ---
> base-commit: 6c790212c588fddeb0d852f2790840753bb604b1
> change-id: 20251029-host-direct-messages-5201d7f55abd
> 
> Best regards,
> -- 
> Per Larsen <perlarsen@google.com>
> 
> 

-- 
Sincerely,
Yeoreum Yun
