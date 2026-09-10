Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D613B95FF;
	Thu, 10 Sep 2026 04:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789015937; cv=none; b=VyIdvjJcj7/kvX331xkGHyzUR8OEIHi6BeVzZieLRKOICqx2ed1E9IVdx7vUwfp+KEuu2D8oMDnhWfk0aFp3dG8eI+HpzTVYcUVdQrBNL5Dkx14IN35I5B9j3Ji8yybvbifvTSIXOHlnCz+02YPiy8+u3Zvw0kYsFDkB0Px5Wzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789015937; c=relaxed/simple;
	bh=nBF6tOIyB/K1smAps/PmomhzUk3BKaarthp+S5mLB4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dseou0TVJF7zrc1lxqr/ot9Jd6tLBU8KPzNPhCpZv1B3D1dlafgMjMPNImTRxQXYOIE1L0k9/0MoZyhcKEZGaE6ao32+INPIvxjfHj3/OM8WNX36GxQPQL/rLR32z53iCiSnaLraCXnwsqoLx1JdMthMWog3RWkjIXJgY/KCsLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=S/brS/Wa; arc=none smtp.client-ip=68.232.139.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="S/brS/Wa"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789015936; x=1820551936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nBF6tOIyB/K1smAps/PmomhzUk3BKaarthp+S5mLB4w=;
  b=S/brS/Wazg7ZGLZGPs/T2+MwAxO4l1euJqsj6CgDJPKo3JYT/olG1f4t
   qzAYZK2XpdRIaRqfDyNnrmiHv1TK/L9xIFs72lBCArBYLRppHaz+LGFix
   uGDa1t7K7Msvs6ALCN0ZmpKeUYd5ftAF8HG1y+XmLWUJrr948qO027Wsu
   xRKkhtyaPoHXTETgAOmn6YAywKpQIbLzbpqXjZ0/Pp6DBixUiLAo0uOb0
   2h0fETQK3F2yxvOuYBSY2MCrR08ohOtHg7NJgTuvEnjXeqZg0gvKHdeEd
   0TPLS/woetm0gIzK/ItFZMlrxUfTwOCrPbGv03bGYtdrQIKACjycFpndS
   w==;
X-CSE-ConnectionGUID: zRUQ7AvOSzag3he5kvlXjQ==
X-CSE-MsgGUID: wxEfclryQf6llfykC4hvMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="254059274"
X-IronPort-AV: E=Sophos;i="6.25,271,1779116400"; 
   d="scan'208";a="254059274"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 13:52:14 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id B6DE6374;
	Thu, 10 Sep 2026 04:52:09 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (unknown [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id 664571C00146;
	Thu, 10 Sep 2026 04:52:09 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.22.105])
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with SMTP id DEF3B821217;
	Thu, 10 Sep 2026 04:52:01 +0000 (UTC)
Date: Thu, 10 Sep 2026 13:51:58 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Gavin Shan <gshan@redhat.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, maz@kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, joey.gouly@arm.com, tabba@google.com, 
	yuzenghui@huawei.com, linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, 
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org
Subject: Re: [PATCH v17 0/7] firmware: arm_rmm: Add RMM v2.0 base RMI support
Message-ID: <aqI3Cewih7oobhdG@FCCLS0092175.localdomain>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <ap-C6NLnxuWWTMzi@FCCLS0092175.localdomain>
 <9086ca6a-5dce-493f-ac76-487dedc60758@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9086ca6a-5dce-493f-ac76-487dedc60758@redhat.com>

Hi Gavin,

On 09/09 20:52, Gavin Shan wrote:
> Hi Kohei,
> 
> On 9/8/26 2:09 PM, Kohei Enju wrote:
> 
> [...]
> 
> > > 
> > > [1] RMM spec : https://support.arm.com/documentation/den0137/2-0bet3/
> > > [2] This series: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/fw_rmm/v17
> > > [3] KVM CCA v17 integration branch: https://gitlab.arm.com/linux-arm/linux-cca.git cca/cca-host/kvm-integration/v17
> > > [4] Gmem inplace conversion https://github.com/googleprodkernel/linux-cc/tree/guest_memfd-inplace-conversion-v12
> > > [5] TF-RMM https://git.trustedfirmware.org/TF-RMM/tf-rmm.git main (commit: 134266ae)
> > 
> > I understand that QEMU-virt is not intended to model a realistic
> > production platform and that QEMU-SBSA is generally preferred. However,
> > I sometimes use QEMU-virt to test functionality quickly because it runs
> > slightly faster than QEMU-SBSA.
> > 
> > I tested this series with QEMU-virt and found that RMM initialization
> > failed during boot:
> > 
> >    [...]
> >    INFO:    BL31: Initializing RMM
> >    INFO:    RMM init start.
> >    ERROR:   RMM init failed: -8
> >    WARNING: BL31: RMM initialization failed
> > 
> I also ran into same issue and attached TF-A patch leads to a successful
> RMM initialization, please have a try to see if it can resolve your issue.

Thanks for the patch! It works perfectly for me on QEMU-virt.
Much appreciated.

Thanks,
Kohei

> 
> 
> Thanks,
> Gavin


