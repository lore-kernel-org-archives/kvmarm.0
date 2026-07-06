Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7ED38238A
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 15:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783352008; cv=none; b=Z8zW5hxRirJCgNyBc2EIoZdICTayf4V7wDY+rVISkUNtnBAhuWKJ8KZxo/EKMFbP1zUQdF2zYDWnDoZ42Ru5nS0PD5wPKLCiByLUKwiufP5p3DWcg1Nqee8uydN2pPxfMW4BG+XHgh8UhAS/xJy7SIah46jTIIIaqLNt5RtqjHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783352008; c=relaxed/simple;
	bh=maL0BNYhvr2QfHPnX5dCkuL2XYtxHjcR0qs6j+Dl0A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YpiI27MHfTrWv4x8LssQnrrSIsXizmg1niX365n6TGGbxex54xN8/cCHFCvJQUaF8YfY8hxVyZU6uKR5YRgB3oElyD5f9SJt5dngz+jQE48crEvbU0VJ8QE04YTuX70VE+OAB+n2wqQ09SIMiH8ceef3D5NMqLWchlU7ynOrMF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YghzYDnF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YghzYDnF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 819BD236D;
	Mon,  6 Jul 2026 08:33:21 -0700 (PDT)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BA623F7B4;
	Mon,  6 Jul 2026 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783352005; bh=maL0BNYhvr2QfHPnX5dCkuL2XYtxHjcR0qs6j+Dl0A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YghzYDnFDXnaph394rzzwrEwATxrs/wW6+lZ2Qrw68ZBJdHA7p5IraQmQiErm0KDH
	 WR67beGRF7VN0Lg+v0GzYKhxZ4/gj2B0d6cqHaWRU8vSRGpY5kt96r/NJLaB2vUvF5
	 rCFzZnWkjrJXbJxKYirQoHPViCiP/w8JtQerwLqk=
Date: Mon, 6 Jul 2026 16:33:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tangnianyao <tangnianyao@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>,
	oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, "guoyang (C)" <guoyang2@huawei.com>,
	"huanglingyan (A)" <huanglingyan2@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
Message-ID: <akvKvePWiu4pB47Q@J2N7QTR9R3.cambridge.arm.com>
References: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
 <xx4obnrmf6lp5dbyo2uwn4pglq7q5nw7ccoyude4zavrgejctg@ll25qpga7qef>
 <292b5734-9005-6db0-da08-3da04628e620@huawei.com>
 <86o6gkpokm.wl-maz@kernel.org>
 <21eb51aa-443c-4d08-b4dd-3f813bbc9880@huawei.com>
 <86jyr8pkw8.wl-maz@kernel.org>
 <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5685cdb9-95d8-9ead-4d24-d6ad06dd9547@huawei.com>

On Mon, Jul 06, 2026 at 10:15:04PM +0800, Tangnianyao wrote:
> Two SMT threads(PE0,PE1) on the same physical core share TLB.

Critially those are *NOT* allowed to share entries allocated with
CnP==0, and are only allowed to share entries where CnP was enabled at
stage 1 (and stage 2 if applicable).

Please see the ARM ARM:

  https://developer.arm.com/documentation/ddi0487/mc/

Specifically, section D8.12.3.4 "Common not private translations":

  https://developer.arm.com/documentation/ddi0487/mc/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Architecture/-D8-16-Translation-Lookaside-Buffers/-D8-16-3-Use-of-ASIDs-and-VMIDs-to-reduce-TLB-maintenance-requirements

> VM0 has 2 vcpus, vcpu0 and vcpu1 that share all architectural context
> except the address translation context.
> 
> Vcpu0 may observe TLB entries that are supposed to be private to vcpu1
> in the following case:
> 
>     PE0(core0,smt0)         PE1(core0,smt1)
> vcpu0 load           
> vcpu0 va->pa0        
> vcpu0 put            
>                                        vcpu1 load
>                                        vcpu1 flush local tlb
>                                        vcpu1 modify desc to va->pa1
> vcpu0 load
> vcpu0 hit *va->pa1*

How is CnP managed in this example?

If *either* of the vCPUs don't set TTBRn_EL1.CnP, that is not permitted
to happen.

If *both* of the vCPUs set TTBRn_EL1.CnP, then surely that is
indistinguishable from physical CPUs:

    PE0(core0,smt0)         PE1(core0,smt1)
    cpu0 va->pa0        
                            cpu1 flush local tlb
                            cpu1 modify desc to va->pa1
    cpu0 hit *va->pa1*

Mark. 
