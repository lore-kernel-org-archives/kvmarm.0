Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793787827;
	b=MTYYdPnIoD9tqhmwszdEjZO2nmUD60LiDi/wJBZpKC/U4A1+icAZlTfCxQ3ISwX58Ft9
	 7cIXc5vNlxVckmG1TvXjndB7npBJXToDjFR1xhvwZUo4NjXoxHBuQhwtXr8abmW3Cg2fW
	 SFnHOiz8d8txCu6ZONeq1XZFRqOJsF9lfPi9KBTrP42YWa7ZfJy1CUS19OmsUzhUt0ave
	 1eoVTyP23bQ/wBdtySTVIloA5s1Xo9iF7EWfAW0ZqXyD/xZH0WA5DNK/4lM0Ar5OJ5o88
	 REnJHvN/eMzc2SAetQsPBlFB5sUyn5mUsHR0T7zGM7a4qg11XN1DfxjW7GinEoPxNLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787827;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=n4Ps0qSkWYG+d69oSo/IEmxe2Snl/v2IpZ6SrpXA0rw=;
	b=z/GbHRZ6hWlcZZkN0yP66c79BiGBo4t5aHmXNLN85hcKTLEwhNMZC8Hd/aZLFWiY73jc
	 dlDQOvzpCBhVwHGrAZZwzBFIZIytxoQmBaFPHZSLE+rgYQ6bRMmhuwiFeWB/4OreoaqFF
	 pyEMNtWyOtrsyBuOUZr4yLxMgRelygxReSCZAX6ZDqDf6bKIMwAK6+HgslSZEPz+WLi4M
	 9USKf5XycmjOGo3d5+I/3uA5m/Fk44yKh2ojvcD0yMpfY0yPccyHLm5UNuwfwSpH7pzOX
	 bZTwFr/T9g2qIfD3ttSLfUYo5Z4wpOuhWVE3Y4D1pxI+k/oO9Eosr4+G8JWWwPiah0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=EVcWL1oD;
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9FA606EE9E;
	Wed,  4 Nov 2026 10:23:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D9FA606EE9E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=EVcWL1oD
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1793787834; x=1825323834;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NSpsS79pjRX5vqOjgAJTbb2PTGzrYCU3NoXWTJpFtPw=;
  b=EVcWL1oDVOymQe6JjTHju7W9JkWfAQVZOOkeQ96RDhE1E1BBb5bG0jO2
   K3e+8NdQfirvk0Gh1A8BrsLf06RPLCczociGIj4JeVYgv5dzZpHg3Ha46
   gRxAoFPooK/UL/X+9IlzkAreozG0l8YZOdRgXkFwQuk5tuOmz24CbSbpb
   6cE7ZhQCwqYL5xgXUQG5WHZ3ZeCeBy0o5geq5GwCEURiDSSjy4x4DqtJh
   0K3rWU8poEF+2HghyQUUCwww1vSc5SO9/SdfCosx6mh6FI4eA6ftnXNfM
   Jbg/fkaj0ThaD+FctCOnEnP14UZzH2/hpLUevPhj2yWAZFj/1ev2qmTmB
   A==;
X-CSE-ConnectionGUID: UTX1WSFbQoemdzvNS2/lfA==
X-CSE-MsgGUID: bcw5kWJhQhydycJ4ndmXOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="260576447"
X-IronPort-AV: E=Sophos;i="6.27,195,1786978800"; 
   d="scan'208";a="260576447"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 19:23:47 +0900
Received: from az2uksmgm4.o.css.fujitsu.com (unknown [10.151.22.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 56FCB820C25;
	Wed,  4 Nov 2026 10:23:39 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm4.o.css.fujitsu.com (Postfix) with ESMTPS id 0D4471400365;
	Wed,  4 Nov 2026 10:23:39 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.61.160])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with SMTP id 12AB04059A5;
	Wed,  4 Nov 2026 10:23:30 +0000 (UTC)
Date: Wed, 4 Nov 2026 19:23:29 +0900
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
Message-ID: <ausEnXB1TE_moI0E@FCCLS0092175.localdomain>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-4-steven.price@arm.com>
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
In-Reply-To: <20261102141304.126883-4-steven.price@arm.com>

Hi Steven,

On 11/02 14:12, Steven Price wrote:
> Check if the RMI support is sufficient for using in KVM. Specifically, we
> will only support creating realm VMs when KVM is set to 'rmm' mode.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/kvm/Kconfig | 1 +
>  arch/arm64/kvm/rmi.c   | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index cecea0820e52..d067063a3686 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -34,6 +34,7 @@ menuconfig KVM
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>  	select KVM_GUEST_MEMFD
>  	select KVM_GENERIC_PRE_FAULT_MEMORY
> +	select ARM_RMM_RMI
>  	help
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 5ecc8b349869..9d118768550d 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -3,6 +3,7 @@
>   * Copyright (C) 2023-2026 ARM Ltd.
>   */
>  
> +#include <linux/arm-rmi-cmds.h>
>  #include <linux/kvm_host.h>
>  
>  #include <asm/virt.h>
> @@ -12,7 +13,8 @@ void kvm_init_rmi(void)
>  	if (kvm_get_mode() != KVM_MODE_RMM)
>  		return;
>  
> -	/* TODO: Check if the RMI is available */
> +	if (!is_rmi_available())
> +		return;

From an admin/operator's perspective, kvm_rmi_is_available would
silently remain FALSE in either of the following cases:
- kvm-arm.mode=rmm is set, but RMI is not available for some reason.
- RMI is available, but the admin forgot to set kvm-arm.mode=rmm.

So I think it would be useful to emit diagnostic messages for these
cases, for example:

if (!is_rmi_available()) {
    if (kvm_get_mode() == KVM_MODE_RMM)
        pr_info("Realm VM support is disabled because RMI is not available\n");
	return;
}

if (kvm_get_mode() != KVM_MODE_RMM) {
    pr_info("Realm VM support is disabled. Use kvm-arm.mode=rmm to enable it\n");
	return;
}

Thanks,
Kohei
