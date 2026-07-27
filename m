Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FAC3DEFFC;
	Mon, 27 Jul 2026 08:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785140099; cv=none; b=EKPiaig4gfnTKWpB6KQX0+SyFcG5nHwnVWODIipM91eu/pMeHfPrYdoEu4SiVdegKjxh6ETwM5eY4quCAwBRYSvemja+qeetuQEFGLnxSbYHPKVKUclb8lNnEgETOnVc9aDSG5Usxu3drv4aOtGiLkLPNy3SLyNw4NrZKsZqy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785140099; c=relaxed/simple;
	bh=P7OnimFYQWkAalEgzraoPxXsrblUmypJNwaTPMgMFwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jm2xjn2RdW4lfBidBdQWa/W7XHBVAqTQn9NrIoUfq/K2ldXkS/YFZX5r/MWV11iqLTCd4dkUk1br3btSCrFa3jOn5RQAl5lXPXFd8HiEHFZzGvBuLMoTvfDUNLN2CjB66N6HUvgpeORlNDI/guEeXTW0YbyShalhvGdcX+r7s68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=IwE/blos; arc=none smtp.client-ip=207.54.90.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="IwE/blos"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1785140098; x=1816676098;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P7OnimFYQWkAalEgzraoPxXsrblUmypJNwaTPMgMFwo=;
  b=IwE/blosIQ2yZ/csrDIFleLlWQQSCqhwUaNEIilnHNKQRJXC6yZH7553
   PlDfYmwG0Nm2+iXULqFF/ELxNNxKAg4jt3dw1Iryz9d1KsVAFTy5Uv/P4
   qhfjUd3JxpCc8kyw1U4ArM2wTDSZr4i3Bag4Trp/fnt3AaezBfse3ENdf
   GkupbraPMZjjoMizu+Tu4gB08hvneyyVbWSmoXsZFsH/5Q5HeNh7l/OEP
   lbchemliPvHfUY069NcrOGr3kbY6Aow3a7Dl4OS0UpneezdWRydMkUdNW
   nZlMKj2ktk2hyvDqG99GNNGnqvBcjuXU8yghbeBSp/NqgebtV5XGa5OuJ
   Q==;
X-CSE-ConnectionGUID: Ftif6aueQ86+dEcoK7vj9g==
X-CSE-MsgGUID: r22+dMvxSk+d9c/1S91pFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11857"; a="248712693"
X-IronPort-AV: E=Sophos;i="6.25,188,1779116400"; 
   d="scan'208";a="248712693"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 17:14:50 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 3117AC00224;
	Mon, 27 Jul 2026 08:14:50 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (unknown [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id DD17818002F3;
	Mon, 27 Jul 2026 08:14:49 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.156.208])
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with SMTP id 9D98B829EFA;
	Mon, 27 Jul 2026 08:14:41 +0000 (UTC)
Date: Mon, 27 Jul 2026 17:14:33 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v15 14/37] KVM: arm64: CCA: Handle realm enter/exit
Message-ID: <amcOp7tpRCkI29vt@FCCLS0092175.localdomain>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-15-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260715142841.80544-15-steven.price@arm.com>

Hi Steven, I have a comment about rec_exit_sys_reg() below.

On 07/15 15:28, Steven Price wrote:
> Entering a realm is done using a SMC call to the RMM. On exit the
> exit-codes need to be handled slightly differently to the normal KVM
> path so define our own functions for realm enter/exit and hook them
> in if the guest is a realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> ---
> Changes since v13:
>  * The RMM is now required to provide an ESR value with the correct
>    information to emulate MMIO, so we no longer need to hardcode 0s in
>    rec_exit_sys_reg().
>  * The PSCI changes mean that there is a potential race when turning on
>    a VCPU which can cause a RMI_ERROR_REC return. Exit to user space
>    with -EAGAIN in this case.
> Changes since v12:
>  * Call guest_state_{enter,exit}_irqoff() around rmi_rec_enter().
>  * Add handling of the IRQ exception case where IRQs need to be briefly
>    enabled before exiting guest timing.
> Changes since v8:
>  * Introduce kvm_rec_pre_enter() called before entering an atomic
>    section to handle operations that might require memory allocation
>    (specifically completing a RIPAS change introduced in a later patch).
>  * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
>    HPFAR_EL2_NS as a valid flag.
>  * Fix exit reason when racing with PSCI shutdown to return
>    KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
> Changes since v7:
>  * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
>    been read (although that can never happen in the current code). Tidy
>    up the condition to handle any future refactoring.
> Changes since v6:
>  * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
>    vcpu to the error.
>  * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
>    this exit type.
>  * Split code handling a RIPAS change triggered by the guest to the
>    following patch.
> Changes since v5:
>  * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
>    change on next entry rather than immediately on the exit. This allows
>    the VMM to 'reject' a RIPAS change by refusing to continue
>    scheduling.
> Changes since v4:
>  * Rename handle_rme_exit() to handle_rec_exit()
>  * Move the loop to copy registers into the REC enter structure from the
>    to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
>    where the handler exits to user space and user space wants to modify
>    the GPRS.
>  * Some code rearrangement in rec_exit_ripas_change().
> Changes since v2:
>  * realm_set_ipa_state() now provides an output parameter for the
>    top_iap that was changed. Use this to signal the VMM with the correct
>    range that has been transitioned.
>  * Adapt to previous patch changes.
> ---
>
> [...]
>
> +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
> +{
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> +	int rt = kvm_vcpu_sys_get_rt(vcpu);
> +	bool is_write = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_WRITE;
> +	int ret;
> +
> +	if (is_write)
> +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);

When rt is 31 (XZR), does exit.gprs[rt] trigger an out-of-bounds read
since REC_RUN_GPRS is 31? Although the padding after the gprs means this
OOB may not cause any practical issue, would it make sense to skip the
access when rt is 31?

if (is_write && rt != 31)
    vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);

> +
> +	ret = kvm_handle_sys_reg(vcpu);
> +	if (!is_write)
> +		rec->run->enter.gprs[rt] = vcpu_get_reg(vcpu, rt);

The same applies here:

if (!is_write && rt != 31)
    rec->run->enter.gprs[rt] = vcpu_get_reg(vcpu, rt);

> +
> +	return ret;
> +}
