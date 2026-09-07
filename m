Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CFB3546D6;
	Mon,  7 Sep 2026 07:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788767132; cv=none; b=eHU+UfZAdruoAdcN4lGD+s1lG73MHPBfDrVKMGxVySkXNAQ4FRlFHGmLVe8wp6nKmK3xYT+TAJHJi4MMNG6e+wKCe9qieBCg9w5DVMrT/4QCKboxJVqt3pKaBADaUkJBwDeA/kimWF0hKApVhFrj4X0vUnkrnZP6vxpH+/HvDpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788767132; c=relaxed/simple;
	bh=qk6/X7C3XmKrnAvXBqOLd12alMHlFiDTZ1WdU3G6n6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbNNGWdMm3m+VSu7EbYWHLrrUCI/uUGe5AWqVlKmcV7xF6GL8noangKRvNxdNQPOOJ8tYgxDWjVNaVCSR3fetjnhGK9TZJ+rGpRbhOLgkRT5tM+ZZpMfiXgw3EqIJgpvht/zsEhzuS8G4pmWCbTbjHaWQWHaijovwtgGIe+9Bc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=O05hEGcd; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="O05hEGcd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1788767130; x=1820303130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qk6/X7C3XmKrnAvXBqOLd12alMHlFiDTZ1WdU3G6n6s=;
  b=O05hEGcdqf1hJtBPM0LobrbhySWi6pfzKa5xHeY6XAr1EupR4LSyifwi
   HldlgdF/U1asz+PSBWLOJlV82NQPy1cz3vp7BxXWJO4l+CtHW0RhieQ8m
   nbZ1QeDMJxGgf2CNWPrIiyWogQG+F/XALj2YbxzrESjwrUheGWCjjmHub
   AZ/OgmRY6FmmFDUd/cHdVA7PIkuqkd4Q26/OGDA/z00DW+ikan4Om5SAZ
   4vB78LhPhltpkzkuXbZOqSdrqzb9nkWaMl7L42+PxWuEkG0C/UgB7kd1m
   serlDHXcKyvLLdikVk0ZAzpMDETH01hASVEFKLVvfq3YLWrmf7btux2+j
   w==;
X-CSE-ConnectionGUID: fls8pjTkSW24oKk1RzPIhg==
X-CSE-MsgGUID: WJ9LO6wuSuaFAvORAescSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11898"; a="233073508"
X-IronPort-AV: E=Sophos;i="6.25,267,1779116400"; 
   d="scan'208";a="233073508"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 16:44:19 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id CC6901C1C70E;
	Mon,  7 Sep 2026 07:44:19 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 7C0D914003C1;
	Mon,  7 Sep 2026 07:44:19 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.144.219])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id 860FB18002EE;
	Mon,  7 Sep 2026 07:44:10 +0000 (UTC)
Date: Mon, 7 Sep 2026 16:44:02 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Gavin Shan <gshan@redhat.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Shanker Donthineni <sdonthineni@nvidia.com>, 
	Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, 
	Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 22/45] KVM: arm64: CCA: Handle RMI_EXIT_RIPAS_CHANGE
Message-ID: <ap5p4PpuunQdm0WE@FCCLS0092175.localdomain>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-23-steven.price@arm.com>
 <ap49Orng5-oehc6J@FCCLS0092175.localdomain>
 <8a437df9-a591-4645-9cd8-55fc4f0ed534@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8a437df9-a591-4645-9cd8-55fc4f0ed534@redhat.com>

On 09/07 16:58, Gavin Shan wrote:
> Hi Kohei,
> 
> On 9/7/26 3:05 PM, Kohei Enju wrote:
> > Hi Steven,
> > 
> > On 08/03 14:43, Steven Price wrote:
> > > The guest can request that a region of its protected address space is
> > > switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> > > RSI_IPA_STATE_SET. This causes a guest exit with the
> > > RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> > > protected region to unprotected (or back), exiting to the VMM to make
> > > the necessary changes to the guest_memfd and memslot mappings. On the
> > > next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> > > calls.
> > > 
> > > The VMM may wish to reject the RIPAS change requested by the guest. For
> > > now it can only do this by no longer scheduling the VCPU as we don't
> > > currently have a usecase for returning that rejection to the guest, but
> > > by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> > > open for adding a new ioctl in the future for this purpose.
> > > 
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > ---
> > > Changes since v15:
> > >   * Propagate negative error returns.
> > > Changes since v14:
> > >   * Use addition rather than bitwise OR for adding the shared_bit in
> > >     realm_unmap_shared_range(), this handles the case where the region
> > >     includes the last address (which means 'end' already has the bit
> > >     set).
> > > Changes since v13:
> > >   * Switch to the new RMI_RTT_UNPROT_UNMAP range-based API.
> > >   * Drop ugly hack for RMM bug which errored when the RIPAS was already
> > >     set to the desired value.
> > > Changes since v12:
> > >   * Switch to the new RMM v2.0 RMI_RTT_DATA_UNMAP which can unmap an
> > >     address range.
> > > Changes since v11:
> > >   * Combine the "Allow VMM to set RIPAS" patch into this one to avoid
> > >     adding functions before they are used.
> > >   * Drop the CAP for setting RIPAS and adapt to changes from previous
> > >     patches.
> > > Changes since v10:
> > >   * Add comment explaining the assignment of rec->run->exit.ripas_base in
> > >     kvm_complete_ripas_change().
> > > Changes since v8:
> > >   * Make use of ripas_change() from a previous patch to implement
> > >     realm_set_ipa_state().
> > >   * Update exit.ripas_base after a RIPAS change so that, if instead of
> > >     entering the guest we exit to user space, we don't attempt to repeat
> > >     the RIPAS change (triggering an error from the RMM).
> > > Changes since v7:
> > >   * Rework the loop in realm_set_ipa_state() to make it clear when the
> > >     'next' output value of rmi_rtt_set_ripas() is used.
> > > New patch for v7: The code was previously split awkwardly between two
> > > other patches.
> > > ---
> > >   arch/arm64/include/asm/kvm_rmi.h |   6 +
> > >   arch/arm64/kvm/mmu.c             |   8 +-
> > >   arch/arm64/kvm/rmi.c             | 473 +++++++++++++++++++++++++++++++
> > >   3 files changed, 484 insertions(+), 3 deletions(-)
> > > 
> > > [...]
> > > +
> > > +static int ripas_change(struct kvm *kvm,
> > > +			struct kvm_vcpu *vcpu,
> > > +			unsigned long ipa,
> > > +			unsigned long end,
> > > +			enum ripas_action action,
> > > +			unsigned long *top_ipa)
> > > +{
> > > +	struct realm *realm = &kvm->arch.realm;
> > > +	phys_addr_t rd_phys = virt_to_phys(realm->rd);
> > > +	phys_addr_t rec_phys;
> > > +	struct kvm_mmu_memory_cache *memcache = NULL;
> > > +	long ret = 0;
> > > +
> > > +	if (vcpu) {
> > > +		rec_phys = vcpu->arch.rec.rec_phys;
> > > +		memcache = &vcpu->arch.mmu_page_cache;
> > > +
> > > +		WARN_ON(action != RIPAS_SET);
> > > +	} else {
> > > +		WARN_ON(action != RIPAS_INIT);
> > > +	}
> > > +
> > > +	while (ipa < end) {
> > > +		unsigned long next = ~0;
> > > +
> > > +		switch (action) {
> > > +		case RIPAS_INIT:
> > > +			ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
> > > +			break;
> > > +		case RIPAS_SET:
> > > +			ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
> > > +						&next);
> > > +			break;
> > > +		}
> > > +
> > > +		if (ret < 0)
> > > +			goto out;
> > > +
> > > +		switch (RMI_RETURN_STATUS(ret)) {
> > > +		case RMI_SUCCESS:
> > > +			ipa = next;
> > > +			break;
> > > +		case RMI_ERROR_RTT: {
> > > +			int err_level = RMI_RETURN_INDEX(ret);
> > > +			int level = find_map_level(realm, ipa, end);
> > > +
> > 
> > I have been testing this series using TF-RMM from:
> >    https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_3
> > 
> > I found that Linux repeatedly issues the same SMC_RMI_RTT_SET_RIPAS call
> > [0], eventually causing a soft lockup [1].
> > 
> > The root cause appears to be an RMM bug fixed by:
> >    https://git.trustedfirmware.org/plugins/gitiles/TF-RMM/tf-rmm.git/+/38c1de0adf66
> > 
> > Without this fix, RMM returns RMI_ERROR_RTT at level 3. In this case,
> > both err_level and level are 3. Since this is RIPAS_SET, the check below
> > is skipped, realm_create_rtt_levels(realm, ipa, 3, 3, ...) is a no-op,
> > and ipa does not advance. The same RMI is therefore retried
> > indefinitely.
> > 
> 
> FYI. This is a known issue, reported previously [1]. Following the discussions
> in the thread will lead to the TF-RMM commit you mentioned.
> 
> [1] https://lore.kernel.org/linux-coco/d0ffbcb5-0cca-4d1e-9788-6b430345fa9b@redhat.com/

Hi Gavin,

Thank you for the FYI.
I wasn't aware of that discussions, so I appreciate you pointing it out.

Thanks,
Kohei

> 
> Thanks,
> Gavin
> 
> > > +			/*
> > > +			 * If the operation failed at deeper level than
> > > +			 * what is required for the address range, this
> > > +			 * implies encountering an unexpected entry,
> > > +			 * (e.g., RIPAS_DESTROYED), which the RMM prevents
> > > +			 * us from modifying. This is only applicable for
> > > +			 * RMI_RTT_INIT_RIPAS. All the other requests
> > > +			 * are generated by the Realm and thus RMM should
> > > +			 * be able to allow the transition.
> > > +			 */
> > > +			if (action == RIPAS_INIT && WARN_ON_ONCE(err_level >= level))
> > > +				return -ENXIO;
> > 
> > Although the root cause is an RMM bug, should we also guard RIPAS_SET
> > against this no-progress case?
> > 
> > Thanks,
> > Kohei
> > 
> > [0]
> >    SMC_RSI_VERSION                   10000 > RSI_SUCCESS 10000 10001
> >    SMC_RSI_REALM_CONFIG              830e5000 > RSI_SUCCESS
> >    SMC_RSI_IPA_STATE_SET             80000000 c0000000 1 0
> >    SMC_RMI_RTT_SET_RIPAS             10060182000 10056e1c000 8000c000 c0000000 > RMI_ERROR_RTT 3
> >    SMC_RMI_RTT_SET_RIPAS             10060182000 10056e1c000 8000c000 c0000000 > RMI_ERROR_RTT 3
> >    SMC_RMI_RTT_SET_RIPAS             10060182000 10056e1c000 8000c000 c0000000 > RMI_ERROR_RTT 3
> >    ... (the same SMC_RMI_RTT_SET_RIPAS call is logged repeatedly)
> > 
> > [1]
> >    [  201.945663] CPU: 113 UID: 0 PID: 8093 Comm: kvm-vcpu-0
> >    [...]
> >    [  201.946291] pstate: 61402009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> >    [  201.946416] pc : arm_smccc_1_2_smc+0x34/0x70
> >    [  201.946430] lr : rmi_smccc_invoke+0xc0/0x108
> >    [  201.946442] sp : ffff8000b59ab5e0
> >    [  201.946448] x29: ffff8000b59ab690 x28: 000000008313e000 x27: 0000000000000003
> >    [  201.946510] x26: 000008241cb3c000 x25: ffffffffffffffff x24: ffff8000b59ab830
> >    [  201.946569] x23: ffff8000b59ab7c0 x22: 0000082419daa000 x21: 000008241cb3c000
> >    [  201.946701] x20: 00000000000000fb x19: ffff8000b59ab5f8 x18: 0000000000000000
> >    [  201.946740] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> >    [  201.947097] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
> >    [  201.947127] x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> >    [  201.947550] x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
> >    [  201.947783] x5 : 0000000000000000 x4 : 00000000c0000000 x3 : 0000000000000000
> >    [  201.947802] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000304
> >    [  201.948305] Call trace:
> >    [  201.948438]  arm_smccc_1_2_smc+0x34/0x70 (P)
> >    [  201.948484]  rmi_sro_execute+0x24/0xd0
> >    [  201.948571]  rmi_rtt_set_ripas.constprop.0+0x6c/0xb0
> >    [  201.948698]  ripas_change+0xc4/0x1e8
> >    [  201.948889]  kvm_rec_handle_request+0x190/0x308
> >    [  201.948943]  check_vcpu_requests+0xcc/0x4f8
> >    [  201.948960]  kvm_arch_vcpu_ioctl_run+0x208/0x7c0
> >    [  201.948986]  kvm_vcpu_ioctl+0x174/0xac8
> >    [  201.949062]  __arm64_sys_ioctl+0xb4/0x118
> >    [  201.949089]  invoke_syscall.constprop.0+0xa8/0x100
> >    [  201.949147]  do_el0_svc+0xb8/0xc8
> >    [  201.949159]  el0_svc+0x48/0x1f8
> >    [  201.949169]  el0t_64_sync_handler+0xa0/0xe8
> >    [  201.949194]  el0t_64_sync+0x1ac/0x1b0
> > 
> > > +
> > > +			ret = realm_create_rtt_levels(realm, ipa, err_level,
> > > +						      level, memcache);
> > > +			if (ret)
> > > +				goto out;
> > > +			/* Retry with the RTT levels in place */
> > > +			break;
> > > +		}
> > > +		default:
> > > +			WARN_ON(1);
> > > +			ret = -ENXIO;
> > > +			goto out;
> > > +		}
> > > +	}
> > > +
> > > +out:
> > > +	if (top_ipa)
> > > +		*top_ipa = ipa;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
> > > +			       unsigned long start,
> > > +			       unsigned long end,
> > > +			       unsigned long ripas,
> > > +			       unsigned long *top_ipa)
> > > +{
> > > +	struct kvm *kvm = vcpu->kvm;
> > > +	int ret = ripas_change(kvm, vcpu, start, end, RIPAS_SET, top_ipa);
> > > +
> > > +	if (!ret && ripas == RMI_EMPTY && *top_ipa != start)
> > > +		realm_unmap_private_range(kvm, start, *top_ipa, false);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static int kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm *kvm = vcpu->kvm;
> > > +	struct realm_rec *rec = &vcpu->arch.rec;
> > > +	unsigned long base = rec->run->exit.ripas_base;
> > > +	unsigned long top = rec->run->exit.ripas_top;
> > > +	unsigned long ripas = rec->run->exit.ripas_value;
> > > +	unsigned long top_ipa = base;
> > > +	int ret;
> > > +
> > > +	do {
> > > +		kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
> > > +					   kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
> > > +		write_lock(&kvm->mmu_lock);
> > > +		ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
> > > +		write_unlock(&kvm->mmu_lock);
> > > +
> > > +		if (ret == -ENOMEM) {
> > > +			/* If no progress, then stop */
> > > +			if (top_ipa == base)
> > > +				break;
> > > +			base = top_ipa;
> > > +			continue;
> > > +		}
> > > +
> > > +		if (WARN_RATELIMIT(ret,
> > > +				   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx, ripas: %#lx\n",
> > > +				   base, top, ripas))
> > > +			break;
> > > +
> > > +		base = top_ipa;
> > > +	} while (base < top);
> > > +
> > > +	/*
> > > +	 * If this function is called again before the REC_ENTER call then
> > > +	 * avoid calling realm_set_ipa_state() again by changing to the value
> > > +	 * of ripas_base for the part that has already been covered. The RMM
> > > +	 * ignores the contains of the rec_exit structure so this doesn't
> > > +	 * affect the RMM.
> > > +	 */
> > > +	rec->run->exit.ripas_base = base;
> > > +
> > > +	return 1;
> > > +}
> > > +
> > >   int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
> > >   {
> > >   	struct realm_rec *rec = &vcpu->arch.rec;
> > > @@ -224,6 +695,8 @@ int kvm_rec_handle_request(struct kvm_vcpu *vcpu)
> > >   					vcpu_get_reg(vcpu, rt);
> > >   		}
> > >   		break;
> > > +	case RMI_EXIT_RIPAS_CHANGE:
> > > +		return kvm_complete_ripas_change(vcpu);
> > >   	default:
> > >   		KVM_BUG(1, vcpu->kvm, "Unhandled realm exit_reason");
> > >   		return -ENXIO;
> > > -- 
> > > 2.43.0
> > > 
> > 
> 
