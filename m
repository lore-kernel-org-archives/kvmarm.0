Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C8529A309;
	Thu, 10 Sep 2026 04:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789015804; cv=none; b=go+uyzRxLIliKAjStu74mUOtZ6PmEVIWOvq6sqTo3W9Ax+4bO7qtgc2UPk2iakQ01srdxHGFkG6AchW7zbcNCWckA7A8sgn2S4HZ2qSGlAYqop4RMYtl9YzzOYGrLxohpmS9xAWxWs9xxkKtQozSkCe09s6Cgp02xCkfKLiD9vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789015804; c=relaxed/simple;
	bh=Xk47tdIucK/5Zzi/z/QsVNoFQM47eXx+3YilT3u56PI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQx2TrgLRkYQygi83MKVcq3r0qoFucICICNMIoOXLtUOjUoo6bvfkmu621uTy9vTuwxqpeM1LnsE1FmlKsTwTibQY+7X/QkARAk6SUd71pjc9vLbh3nCNenmjJ6oDLWQ1toARsR7KAukuiKnsKIpHAxGIpy4vLrTj1RVrmAltLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=hU1FE3bl; arc=none smtp.client-ip=68.232.139.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="hU1FE3bl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789015807; x=1820551807;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Xk47tdIucK/5Zzi/z/QsVNoFQM47eXx+3YilT3u56PI=;
  b=hU1FE3blOSc/P1bhwBvbW4fTdkCAZ9EZB4Nf1uCJ4UaeNLxU8G2odxmJ
   WB/ILSiqF9z5ibaVlyOTeXKD7tDKp3GKEy5qwnRS8QS8L/9IdXaJJSw0H
   53KGmJ5rL7A2ZL5W15UHEsIBOe0rY8RoL9Naah0naiI0MVNFp1t4zdlS8
   WNFQVEzmVdK9UmVDkleqYJAOiBVSBksKwh0QCK0phhsQdOwCgCxVIQoLi
   D21EE4IOZboWn1agM+9ONMG9pHY6woqZ3keSPuc6sZiNJLgCmswdjJUNX
   ySl+fo/w+6U+f2PSGzG8ByHRk1NDBHKzzgou9VZadh5Sph+v8Huwl0BVn
   g==;
X-CSE-ConnectionGUID: 2hmhwn76SBukl5FA8eGK1A==
X-CSE-MsgGUID: 72PMBzoqTHGO4Fp9xnBrww==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="254058856"
X-IronPort-AV: E=Sophos;i="6.25,271,1779116400"; 
   d="scan'208";a="254058856"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 13:49:59 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 43D49821104;
	Thu, 10 Sep 2026 04:49:55 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id EDB9518000E9;
	Thu, 10 Sep 2026 04:49:54 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.22.105])
	by az2uksmom2.o.css.fujitsu.com (Postfix) with SMTP id 0379A14000ED;
	Thu, 10 Sep 2026 04:49:47 +0000 (UTC)
Date: Thu, 10 Sep 2026 13:49:44 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, joey.gouly@arm.com, 
	tabba@google.com, yuzenghui@huawei.com, linux-coco@lists.linux.dev, 
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, alpergun@google.com, 
	fj0570is@fujitsu.com, WeiLin.Chang@arm.com, lpieralisi@kernel.org
Subject: Re: [PATCH v17 06/20] KVM: arm64: CCA: Add a new mode for supporting
 Realm guests
Message-ID: <aqI2eI8IbCJQMx5d@FCCLS0092175.localdomain>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-7-suzuki.poulose@arm.com>
 <aqDFcgzXOTWUkPtp@FCCLS0092175.localdomain>
 <86zexq3dk5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86zexq3dk5.wl-maz@kernel.org>

Hi Marc,

On 09/09 11:48, Marc Zyngier wrote:
> On Wed, 09 Sep 2026 04:26:41 +0100,
> Kohei Enju <enju.kohei@fujitsu.com> wrote:
> > 
> > Hi Suzuki,
> > 
> > On 09/08 17:22, Suzuki K Poulose wrote:
> > > Add an explicit mode to support Arm CCA guests.
> > > 
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > ---
> > >  Documentation/admin-guide/kernel-parameters.txt | 3 +++
> > >  arch/arm64/include/asm/kvm_host.h               | 1 +
> > >  arch/arm64/kvm/arm.c                            | 5 +++++
> > >  3 files changed, 9 insertions(+)
> > > 
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > index 68647ff4bdd24..1afe3df3b923e 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -3256,6 +3256,9 @@ Kernel parameters
> > >  			nested: VHE-based mode with support for nested
> > >  				virtualization. Requires at least ARMv8.4
> > >  				hardware (with FEAT_NV2).
> > > +			rmm: Support for running confidential guests in Realm
> > > +			     world using RMM, as defined by Arm Confidential
> > > +			     Compute Architecture (CCA)
> > >  
> > >  			Defaults to VHE/nVHE based on hardware support. Setting
> > >  			mode to "protected" will disable kexec and hibernation
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index b2e99c5cb1cd3..31ae9d8d8e92f 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -69,6 +69,7 @@ enum kvm_mode {
> > >  	KVM_MODE_DEFAULT,
> > >  	KVM_MODE_PROTECTED,
> > >  	KVM_MODE_NV,
> > > +	KVM_MODE_RMM,
> > >  	KVM_MODE_NONE,
> > >  };
> > >  #ifdef CONFIG_KVM
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 9af3bbb2f8c24..50f0adfadab38 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -3264,6 +3264,11 @@ static int __init early_kvm_mode_cfg(char *arg)
> > >  		return 0;
> > >  	}
> > >  
> > > +	if (strcmp(arg, "rmm") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
> > > +		kvm_mode = KVM_MODE_RMM;
> > > +		return 0;
> > > +	}
> > 
> > Does this make NV support and CCA Realm VM support mutually exclusive?
> > 
> > Until the v16 series, we could run Realm VMs with:
> >   'kvm-arm.mode=nested'
> > 
> > As far as the AArch64 architecture is concerned, there does not seem to
> > be a reason to make them mutually exclusive. I am therefore wondering
> > whether this restriction is intentional.
> 
> I have a hack somewhere that will allow this, but this requires to
> change the above to be a capability mask rather than a simple
> enumeration. I'll see if I can spin that as a separate series.

Ack. Thank you for the clarification.
Looking forward to seeing the series.

Thanks,
Kohei

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
