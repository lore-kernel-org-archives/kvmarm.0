Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793788081;
	b=v4moZCcxxtbIBbi0wGClV4WUTNK6uQG2fCY8E2nNsznLoF9vQlQy6/DUGAfrRF2YlyNf
	 EQl0xRd5cPdrCpbpke9iOUUlZriro9dEKUM2kUwlzjCK39A1qL9FR8RaD5VZeEKYVgRk2
	 SW5NEaQzsuttDUgsECWCtybaJdCa8Uh8ascnFN/oPrPfjcHUL6HAzteV3s4fdtNNCsZlq
	 4+rTUlVaicui4Q4JHhgnU0Jxl22pIE0DICu3rAm2uvMcJ3XKHl/8hY6XlXiSvfbrz4YXY
	 ueeQL+7QvV04hHeKrQtZHiLQxiWDD7zBw9QAR79jcTdvjqsg37QFLvvwUSNguivSeCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793788081;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=7veRrT8eWAeBKJG1Q0lJd1x2zWh4g6/qHWjAZxV9nEY=;
	b=KJciWFHePYeYhPyPr5ULY4pP8qkSyb871wDTC9C83MoucmjtpCIoUuW3l9LpMNFeggal
	 l8XCkSFA6zcS4krpa99YC4zOUK8mlI0bIpdSJyZKgSYpgQgUbb+qCkmtbS1LVdQIDPm0t
	 KT3yNwhezhIJNR23ArzjTLKL83zm52eqlsS0oP5mI5Hi94QkdLcqXMFtZYPdl4Aj9wpo/
	 PbxnWzznPkfoZViyJEZay0iqDOo5AoA1osCzRi5YUuLaJNsg/uf2dqbMsOTiagwS5KGXf
	 7k/olnzKqOmKMosfZ7KTC3EfDtblGLSeWVaof2SGyGK2PTEdBfvkwd11z/MNzw1h4hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="YBYxhWN/";
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B518606A31B;
	Wed,  4 Nov 2026 10:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B518606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=YBYxhWN/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1793788088; x=1825324088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wlmr7Aue0wdrqc12Gk8qvFNC+7tKFeGN9AZd173LYv8=;
  b=YBYxhWN/X3+U45suicMQa7rPQ+NRnk7JFJWFFYM+Kh17Zt/sc4sSQ5z/
   RR6oJm1KckuLsc24gojw0SaSYbCKNjmmg2Q78AShxfVJ5hzutV16Ew12J
   QGV4zqG/s477v0sVDuGGva3Sw6TtSgoXDwOODYWL5x+LZWrpl9/W15w4z
   AHl4ftuFuvv5GcRfu1YV3QEx7bQ4dDVnIjeoHHih9vJBO86Pdf9FQWsF1
   YHaqFYYATwF1TnZB24IZZo7Ov/w2T0AtEswOf+m1X4PjCNyh1EwUp2AuE
   J+C5dXKw39/tNCCx7bNU2bTBWwTFAMDvJnPvufRrKVCVQEJWcED02GWSy
   A==;
X-CSE-ConnectionGUID: bpOWm/sESAyG2ktmLYFGKA==
X-CSE-MsgGUID: 8wf6eRZbTXa9/iFVezyNnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="260576736"
X-IronPort-AV: E=Sophos;i="6.27,195,1786978800"; 
   d="scan'208";a="260576736"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 19:28:06 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id A34E610000C4;
	Wed,  4 Nov 2026 10:27:58 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 557141000395;
	Wed,  4 Nov 2026 10:27:58 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.61.160])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id A62E61800599;
	Wed,  4 Nov 2026 10:27:50 +0000 (UTC)
Date: Wed, 4 Nov 2026 19:27:49 +0900
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
Subject: Re: [PATCH 03/11] KVM: arm64: CCA: Check for RMI support at KVM init
Message-ID: <ausIgejq7Io9VjZL@FCCLS0092175.localdomain>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-4-steven.price@arm.com>
 <ausEnXB1TE_moI0E@FCCLS0092175.localdomain>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ausEnXB1TE_moI0E@FCCLS0092175.localdomain>

On 11/04 19:23, Kohei Enju wrote:
> Hi Steven,
> 
> On 11/02 14:12, Steven Price wrote:
> > Check if the RMI support is sufficient for using in KVM. Specifically, we
> > will only support creating realm VMs when KVM is set to 'rmm' mode.
> > 
> > Signed-off-by: Steven Price <steven.price@arm.com>
> > ---
> >  arch/arm64/kvm/Kconfig | 1 +
> >  arch/arm64/kvm/rmi.c   | 4 +++-
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index cecea0820e52..d067063a3686 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -34,6 +34,7 @@ menuconfig KVM
> >  	select GUEST_PERF_EVENTS if PERF_EVENTS
> >  	select KVM_GUEST_MEMFD
> >  	select KVM_GENERIC_PRE_FAULT_MEMORY
> > +	select ARM_RMM_RMI
> >  	help
> >  	  Support hosting virtualized guest machines.
> >  
> > diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> > index 5ecc8b349869..9d118768550d 100644
> > --- a/arch/arm64/kvm/rmi.c
> > +++ b/arch/arm64/kvm/rmi.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (C) 2023-2026 ARM Ltd.
> >   */
> >  
> > +#include <linux/arm-rmi-cmds.h>
> >  #include <linux/kvm_host.h>
> >  
> >  #include <asm/virt.h>
> > @@ -12,7 +13,8 @@ void kvm_init_rmi(void)
> >  	if (kvm_get_mode() != KVM_MODE_RMM)
> >  		return;
> >  
> > -	/* TODO: Check if the RMI is available */
> > +	if (!is_rmi_available())
> > +		return;
> 
> From an admin/operator's perspective, kvm_rmi_is_available would
> silently remain FALSE in either of the following cases:
> - kvm-arm.mode=rmm is set, but RMI is not available for some reason.
> - RMI is available, but the admin forgot to set kvm-arm.mode=rmm.
> 
> So I think it would be useful to emit diagnostic messages for these
> cases, for example:
> 
> if (!is_rmi_available()) {
>     if (kvm_get_mode() == KVM_MODE_RMM)
>         pr_info("Realm VM support is disabled because RMI is not available\n");
> 	return;
> }
> 
> if (kvm_get_mode() != KVM_MODE_RMM) {
>     pr_info("Realm VM support is disabled. Use kvm-arm.mode=rmm to enable it\n");
> 	return;
> }

Sorry, the indentation got mangled :(

> 
> Thanks,
> Kohei
