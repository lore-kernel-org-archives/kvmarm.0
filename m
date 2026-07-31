Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CD82BE65B;
	Fri, 31 Jul 2026 00:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459448; cv=none; b=RymxlsFI2WW3m+mzOhoD2pvxG5qoHcAAmW8nLGueojsPsBM7+UaNh4MG4/4rOb9rsbBS+l/JxA9lNaO/s0XxKitWn+++bsIrXu7dMppU8IdbmzttAc6jnSDhqjniQupOAzBjs5bRdr+Yb0tsvfS0wo1KFYj8JpwRDExkYqpOaXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459448; c=relaxed/simple;
	bh=CldFfWlOgnf4zC1U/6YI+wfPKxwfum0uI/0Ov2QKXAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jx33zKOMDqLe7ABfawYKFX/WLxTUXw4TaF2BgpHlhlC0PN+fcrTH/PnhztVDFy/RxuM13e7c7MKG9Y/oFGVwNHnRzcEMbl7PxwTVtv0sbPAm+SpbHR4CMl8B3ulYy1h/Cv39tiMVH11gE6oTNN5DsC3+qd8+7nHTlsD6v0ZWqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=i2KnV56X; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="i2KnV56X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1785459446; x=1816995446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CldFfWlOgnf4zC1U/6YI+wfPKxwfum0uI/0Ov2QKXAc=;
  b=i2KnV56XY1qJt9l6Y4iwi7fidmYNBobdKG3ureq6Q45cFfAWTWj5PEfF
   O0VWS5bIXX8OVLnTiFv09QKGdJ/A6io1RRogKrsU1OX/W4laIS9chUymC
   ccMVWRZqnlh/scRywUMa2eFFN+rVLWFrQdVqUXvOjUmVz9/q+Fpwpcxda
   gzWRPsuClrqRK28lPnvqhNKa6RaPTZZqm2G5N4ZmoKh830li/YCvTnCpW
   sCuoXuQrH73CIZPxZBUJYZzVKOxwWYszdxlz9qWmT4LMgvM+STSUr6AdB
   Un6wjA82RayC2Fc/2eN3w2/RwA/ZRok2cOgTxovLAvc9sBeN6w/HVC7jv
   Q==;
X-CSE-ConnectionGUID: c8OJpFjwSD2XIQ9PBKnJrg==
X-CSE-MsgGUID: T/oEe5hDRY+oEmejBYoxdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="252750413"
X-IronPort-AV: E=Sophos;i="6.25,195,1779116400"; 
   d="scan'208";a="252750413"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 09:57:18 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id D0B4C1C01698;
	Fri, 31 Jul 2026 00:57:18 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 882ADC2BABA;
	Fri, 31 Jul 2026 00:57:18 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.24.243])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id 21DD11800D71;
	Fri, 31 Jul 2026 00:57:08 +0000 (UTC)
Date: Fri, 31 Jul 2026 09:57:06 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v15 14/37] KVM: arm64: CCA: Handle realm enter/exit
Message-ID: <amvx9kxuc6FTkJC4@FCCLS0092175.localdomain>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-15-steven.price@arm.com>
 <amcOp7tpRCkI29vt@FCCLS0092175.localdomain>
 <08599315-2dd3-4602-a902-09b197265b44@arm.com>
 <763eb5db-e9af-4b3a-b05b-746700cf0304@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <763eb5db-e9af-4b3a-b05b-746700cf0304@arm.com>

On 07/30 15:57, Suzuki K Poulose wrote:
> On 30/07/2026 14:58, Steven Price wrote:
> > On 27/07/2026 09:14, Kohei Enju wrote:
> > > Hi Steven, I have a comment about rec_exit_sys_reg() below.
> > > 
> > > On 07/15 15:28, Steven Price wrote:
> > > > Entering a realm is done using a SMC call to the RMM. On exit the
> > > > exit-codes need to be handled slightly differently to the normal KVM
> > > > path so define our own functions for realm enter/exit and hook them
> > > > in if the guest is a realm guest.
> > > > 
> > > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > > ---
> > > > Changes since v13:
> > > >   * The RMM is now required to provide an ESR value with the correct
> > > >     information to emulate MMIO, so we no longer need to hardcode 0s in
> > > >     rec_exit_sys_reg().
> > > >   * The PSCI changes mean that there is a potential race when turning on
> > > >     a VCPU which can cause a RMI_ERROR_REC return. Exit to user space
> > > >     with -EAGAIN in this case.
> > > > Changes since v12:
> > > >   * Call guest_state_{enter,exit}_irqoff() around rmi_rec_enter().
> > > >   * Add handling of the IRQ exception case where IRQs need to be briefly
> > > >     enabled before exiting guest timing.
> > > > Changes since v8:
> > > >   * Introduce kvm_rec_pre_enter() called before entering an atomic
> > > >     section to handle operations that might require memory allocation
> > > >     (specifically completing a RIPAS change introduced in a later patch).
> > > >   * Updates to align with upstream changes to hpfar_el2 which now (ab)uses
> > > >     HPFAR_EL2_NS as a valid flag.
> > > >   * Fix exit reason when racing with PSCI shutdown to return
> > > >     KVM_EXIT_SHUTDOWN rather than KVM_EXIT_UNKNOWN.
> > > > Changes since v7:
> > > >   * A return of 0 from kvm_handle_sys_reg() doesn't mean the register has
> > > >     been read (although that can never happen in the current code). Tidy
> > > >     up the condition to handle any future refactoring.
> > > > Changes since v6:
> > > >   * Use vcpu_err() rather than pr_err/kvm_err when there is an associated
> > > >     vcpu to the error.
> > > >   * Return -EFAULT for KVM_EXIT_MEMORY_FAULT as per the documentation for
> > > >     this exit type.
> > > >   * Split code handling a RIPAS change triggered by the guest to the
> > > >     following patch.
> > > > Changes since v5:
> > > >   * For a RIPAS_CHANGE request from the guest perform the actual RIPAS
> > > >     change on next entry rather than immediately on the exit. This allows
> > > >     the VMM to 'reject' a RIPAS change by refusing to continue
> > > >     scheduling.
> > > > Changes since v4:
> > > >   * Rename handle_rme_exit() to handle_rec_exit()
> > > >   * Move the loop to copy registers into the REC enter structure from the
> > > >     to rec_exit_handlers callbacks to kvm_rec_enter(). This fixes a bug
> > > >     where the handler exits to user space and user space wants to modify
> > > >     the GPRS.
> > > >   * Some code rearrangement in rec_exit_ripas_change().
> > > > Changes since v2:
> > > >   * realm_set_ipa_state() now provides an output parameter for the
> > > >     top_iap that was changed. Use this to signal the VMM with the correct
> > > >     range that has been transitioned.
> > > >   * Adapt to previous patch changes.
> > > > ---
> > > > 
> > > > [...]
> > > > 
> > > > +static int rec_exit_sys_reg(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	struct realm_rec *rec = &vcpu->arch.rec;
> > > > +	unsigned long esr = kvm_vcpu_get_esr(vcpu);
> > > > +	int rt = kvm_vcpu_sys_get_rt(vcpu);
> > > > +	bool is_write = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_WRITE;
> > > > +	int ret;
> > > > +
> > > > +	if (is_write)
> > > > +		vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);
> > > 
> > > When rt is 31 (XZR), does exit.gprs[rt] trigger an out-of-bounds read
> > > since REC_RUN_GPRS is 31? Although the padding after the gprs means this
> > > OOB may not cause any practical issue, would it make sense to skip the
> > > access when rt is 31?
> > > 
> 
> RMM mandates that the ESR_ELx.ISS.RT == 0 on an exit due to System register
> access. See "A4.3.4.4 REC exit due to System register access"
> 
> So this shouldn't be a problem, but doesn't hurt to defend the host
> against a malicious RMM ?

Ah, I missed that requirement. The changelog and the old RMM
implementation led me to mistakenly assume tat Rt could be non-zero.

Then special-casing Rt == 31 doesn't really make sense. So keeping the
code as it is seems fine to me:)

Thanks,
Kohei

> 
> Suzuki
> 
> 
> 
> > > if (is_write && rt != 31)
> > >      vcpu_set_reg(vcpu, rt, rec->run->exit.gprs[rt]);
> > 
> > Very true - as you say in practise this isn't a big issue because
> > vcpu_set_reg() is a no-op, so it's just a read of padding. But
> > definitely worth fixing.
> > 
> > > > +
> > > > +	ret = kvm_handle_sys_reg(vcpu);
> > > > +	if (!is_write)
> > > > +		rec->run->enter.gprs[rt] = vcpu_get_reg(vcpu, rt);
> > > 
> > > The same applies here:
> > > 
> > > if (!is_write && rt != 31)
> > >      rec->run->enter.gprs[rt] = vcpu_get_reg(vcpu, rt);
> > 
> > And the same here - a zero written into the padding.
> > 
> > Thanks for the review!
> > 
> > Steve
> > 
> > > > +
> > > > +	return ret;
> > > > +}
> > 
> 
