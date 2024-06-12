Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754FC58203
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 05:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718171924; cv=none; b=lp3K+X/A1L3wp7fxYVYvMoYkpJYFhAlSShcsPiXGkufLcpzQh6wIKdjT56J0hHkh5HqtG07+OL3CsYkhahaPiR7gvgr+yZrdKYwx6RdbzN2Hy8VQzM7+G1u2kvTqSIorU1ITfDSCpBmKBd7tdyTnWKXCoSgtURbc+EK1ncMdh8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718171924; c=relaxed/simple;
	bh=d++qrIBCc+v23jCIkE3wM8GRAf2ykGEp/AZ6F2A5P88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fs8GulkT2i806OdutK6EdBeP5NPvqYsuAM/l+16RPXZGi/FGn0zAUf4pVK5HjKhvh8XLuwtzE40vAMks/VcFB9x9G5Py/iNLAIgSSFpNK18gq5XSlHwS0japiyY7aOGxRU3UnjiD7tkKoSWA4z8cgpakxuM6mUERSnqJsdNX0q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gWLeN/I3; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gWLeN/I3"
X-Envelope-To: shahuang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718171919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vr7nODWIwz/w7nv174lBINiHccBj0qhYAvXZmJBwsYk=;
	b=gWLeN/I39iPxX1I5XAr2UFfDEzZo2t7i7+tcRhaZP7LnQHVgj0uEnvXd063+cQTUINfKl0
	MheewWr+mqicvBVvE3iuVrUIr3cYrWSt/N+4HFdBT4c3ZIzK1D84HRtXRu9F/hqUmLtI96
	yK/kwMHNIWKZT/diTVvpl9rgPdY4sXU=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: eauger@redhat.com
X-Envelope-To: sebott@redhat.com
X-Envelope-To: cohuck@redhat.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Tue, 11 Jun 2024 22:58:30 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/2] KVM: arm64: Allow BT field in ID_AA64PFR1_EL1
 writable
Message-ID: <Zmk5Bj4w_CFxrabg@linux.dev>
References: <20240612023553.127813-1-shahuang@redhat.com>
 <20240612023553.127813-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612023553.127813-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 11, 2024 at 10:35:51PM -0400, Shaoqin Huang wrote:
> When migrating from MtCollins to AmpereOne, the BT field value in
> ID_AA64PFR1_EL1 register is different and not writable. This causes
> the migration to fail.
> 
> The BT field means Branch Target Identification mechanism support in
> AArch64 state. The value 0 means BT is not implemented, the value 1
> means BT is implemented.
> 
> On MtCollins(Migration Src), the BT value is 0.
> On AmpereOne(Migration Dst), the BT value is 1.
> 
> As it defined in the ftr_id_aa64dfr0, the samller value is safe. So if

typo: smaller

> we make the BT field writable, on the AmpereOne(Migration Dst) the BT
> field will be overrided with value 0.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> But there is a question, the ARM DDI mentions from Armv8.5, the only
> permitted value is 0b01. Do you guys know if there are any consequence
> if the userspace write value 0b0 into this field? Or we should restrict
> that at some level, like in VMM or kernel level?

There's no directly visible attribute in the CPU registers to determine
what level of the architecture the implementation supports, and I
don't really want KVM to go about policing this.

The general guidance for ID register fields is that we allow userspace
to select a subset of CPU features supported by KVM / the
implementation, which in this case would include the _NI encoding for
the field. This has been slightly opinionated so far, leaving features
that userspace selects via a separate mechanism (e.g. KVM_ARM_VCPU_INIT)
read only.

Userspace can (and should) come up with its own heuristics for
determining the feature set for the vCPU.

> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c9f4f387155f..8e0ea62e14e1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2292,7 +2292,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  		   ID_AA64PFR0_EL1_GIC |
>  		   ID_AA64PFR0_EL1_AdvSIMD |
>  		   ID_AA64PFR0_EL1_FP), },
> -	ID_SANITISED(ID_AA64PFR1_EL1),
> +	ID_WRITABLE(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_EL1_BT),

This doesn't compile. The macro prefixes "SYS_" to the register name.

-- 
Thanks,
Oliver
