Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7924A2E1D;
	Thu,  2 Jul 2026 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000257; cv=none; b=HbegA36ly9Hd44z0w6AX6ugFKI+NjE017E94HEB45jQPdGhiISHJqEIJ0+BCkhpEgPySIGVNVxsHc+E7ooej5Oh9c1SNw3bMNsdsh+/YWxLAH+DEUJx6dmBDz9BqcVIDkqqQGfUIA6PtvCO5bMlSzGnmW/QajdSSoEGzo+l0Qao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000257; c=relaxed/simple;
	bh=xnklOfOMgd3lTWP7dbDjW/8W/dMixSDLsT9X9yUD6WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ai6AZtstSwoVzzlVHRt9yvgaDKis735WM9GxlJblkgWt+7uev5HBsFtHV2fzLKfZfTjze7N0vD3Kw9nyL6g7Uivm55q+vjTHnfLYhiKc+pjhkeKGUTAZYweSvRnzY7D+xRvYX9j86HipelocwpdbM85a/fG43g+zr0pKalwCURg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=TO0p8yKQ; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="TO0p8yKQ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1783000255; x=1814536255;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xnklOfOMgd3lTWP7dbDjW/8W/dMixSDLsT9X9yUD6WE=;
  b=TO0p8yKQg+meCnv5cmY6Kl+iI9ROqtLmKV5LLxkICN2KMxAKmv/5xkou
   qa02oi1rBU+lvr/93/GkFwahPmo/IztEaaKi2IoEgjHGRG4d8qZTdOWMO
   dWbeb6WLQi3joI3EPOGAM1tghsM3vnzen1XIze3NRUpb7PTo34QAJYUQ5
   Kz6/BnnxvsDaIc0eO7iVC5p6+Mp9HhYpfHu3XX+MMKouTG39rr+Xja/NN
   E5cX408dREg3PKnIxeKxP8KUIFO3QHIa7XAJy5emaS+kFwdQ/xhpYWfcS
   ecX8OmvuobBoSQ8hclNBSU60Bv3oHGDtOcUSxCvnxtzxgVJeNfaTpVPlY
   Q==;
X-CSE-ConnectionGUID: WSsKnXjGRNOP4NhgOhCZcw==
X-CSE-MsgGUID: NKXlobrqR16pBJG3k49Q5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11835"; a="232267521"
X-IronPort-AV: E=Sophos;i="6.25,143,1779116400"; 
   d="scan'208";a="232267521"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 22:49:44 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 65AA0407577;
	Thu,  2 Jul 2026 13:49:44 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 0A3751C1C27B;
	Thu,  2 Jul 2026 13:49:44 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.40.135])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with SMTP id BDCF5402885;
	Thu,  2 Jul 2026 13:49:35 +0000 (UTC)
Date: Thu, 2 Jul 2026 22:49:27 +0900
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
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 00/44] arm64: Support for Arm CCA in KVM
Message-ID: <akZnzMt145i7s-dY@FCCLS0092175.localdomain>
References: <20260513131757.116630-1-steven.price@arm.com>
 <akR0eX0nCumIgnlh@FCCLS0092175.localdomain>
 <8c0e6a32-2de2-4b94-9fe2-e32f5e9bcc4a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c0e6a32-2de2-4b94-9fe2-e32f5e9bcc4a@arm.com>

On 07/01 11:53, Steven Price wrote:
> On 01/07/2026 03:15, Kohei Enju wrote:
> > On 05/13 14:17, Steven Price wrote:
> >> This series adds support for running protected VMs using KVM under the
> >> Arm Confidential Compute Architecture (CCA).
> >>
> >> This is rebased on v7.1-rc1, but still targets RMM v2.0-bet1[1].
> >>
> >> The major updates from v13 remain but have been more fully implemented:
> >> the RMM uses the host's page size, range based RMI APIs mean we don't
> >> have to break everything down to base page sizes, the GIC state is
> >> passed via system registers, and the uAPI has been simplified.
> >>
> >> The main changes since v13 are:
> >>
> >>  * The RMI definitions and wrappers have been fully updated for RMM
> >>    v2.0-bet1. In particular the temporary RMM v1.0 SMC compatibility
> >>    patch has been dropped.
> >>
> >>  * The PSCI completion ioctl has been removed. RMM v2.0-bet1 still
> >>    requires the host to provide the target REC for PSCI calls which
> >>    name another vCPU, but KVM now performs the RMI PSCI completion
> >>    automatically before entering the REC again. Userspace no longer
> >>    needs to issue KVM_ARM_VCPU_RMI_PSCI_COMPLETE. A future spec should
> >>    remove the need for the host to provide the MPIDR mapping.
> >>
> >>  * The generic RMI init, RMM configuration, GPT setup,
> >>    delegate/undelegate helpers and SRO infrastructure have moved out of
> >>    KVM into arch/arm64/kernel/rmi.c. RMI is expected to be used by
> >>    features outside KVM, so this code should be available even when KVM
> >>    is not built.
> >>
> >>  * RMI_GRANULE_TRACKING_GET has been updated to work on a range, this
> >>    allows it to work when the region is not aligned to the tracking
> >>    size. Solves the problem reported by Mathieu[2].
> >>
> >>  * SRO support has been moved earlier in the series and improved. It
> >>    provides a cleaner way for the host to provide the RMM with the extra
> >>    memory it requires. However support is still incomplete where the
> >>    TF-RMM code does not yet implement it. This is noted by FIXMEs in the
> >>    code.
> >>
> >>  * The ARM VM type encoding has been reworked to coexist with the
> >>    upstream pKVM KVM_VM_TYPE_ARM_PROTECTED bit.
> >>
> >>  * The private-memory documentation now notes that arm64 uses
> >>    KVM_CAP_MEMORY_ATTRIBUTES.
> >>
> >>  * PMU support is dropped for now. It will be added later in a separate
> >>    series. Similarly for selecting the hash algorithm and RPV.
> > 
> > Hi Steven,
> 
> Hi,
> 
> > Is there any plan to add support for selecting the MEC policy (shared or
> > private)? We have been working on adding support for this on top of your
> > series. If this is not already in the works, we may upstream our
> > implementation later.
> 
> I've been trying to focus on getting the minimum useful series
> upstreamed before looking at additional features (such as hash
> algorithm, MEC policy etc). If you've already got support then yes
> please do upstream it later when we've got this series landed.

Thank you for the clarification. That makes sense.

I agree that the non-RFC patch should wait until your series has landed.
Before that, however, I'd like to send an RFC patch to gather feedback
on the design from the community while your series is still under
review. I don't expect the RFC to interfere with the upstreaming of your
series.

Thanks,
Kohei.

> 
> Thanks,
> Steve
> 
> > Thanks,
> > Kohei
> > 
> >>
> >> There are also the usual rebase updates and smaller fixes, including
> >> changes to the RMM v2.0-bet1 range APIs, removal of REC auxiliary
> >> granule handling, fixes to the address range descriptor encoding, and
> >> cleanups around realm stage-2 teardown.
> >>
> >> Stateful RMI Operations
> >> -----------------------
> >>
> >> The RMM v2.0 spec introduces Stateful RMI Operations (SROs), which allow
> >> the RMM to complete an operation over several SMC calls while requesting
> >> or returning memory to the host. This allows interrupts to be handled in
> >> the middle of an operation and lets the RMM dynamically allocate memory
> >> for internal tracking purposes. For example, RMI_REC_CREATE no longer
> >> needs auxiliary granules to be provided up front, and can instead
> >> request memory during the operation.
> >>
> >> This series includes the generic SRO infrastructure in
> >> arch/arm64/kernel/rmi.c and uses it for REC create/destroy. The other
> >> cases are not yet used by TF-RMM and a future revision will be needed to
> >> finish those paths in Linux.
> >>
> >> This series is based on v7.1-rc1. It is also available as a git
> >> repository:
> >>
> >> https://gitlab.arm.com/linux-arm/linux-cca cca-host/v14
> >>
> >> Work in progress changes for kvmtool are available from the git
> >> repository below:
> >>
> >> https://gitlab.arm.com/linux-arm/kvmtool-cca cca/v12
> >>
> >> The TF-RMM has not yet merged the RMM v2.0 support, so you will need to
> >> use a branch with RMM v2.0-bet1 support. At the time of writing the
> >> following branch is being used:
> >>
> >> https://git.trustedfirmware.org/TF-RMM/tf-rmm.git topics/rmm-v2.0-poc_2
> >> (tested on commit 3340667a291a)
> >>
> >> There is a kvm-unit-test branch which has been updated to support the
> >> attestation used in RMMv2.0 available here:
> >>
> >> https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca cca/v4
> >>
> >> [1] https://developer.arm.com/documentation/den0137/2-0bet1/
> >> [2] https://lore.kernel.org/all/acrj-cKphy4hJsEG@p14s/
> 
> 
