Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2BA31D365
	for <kvmarm@lists.linux.dev>; Tue, 23 Sep 2025 08:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758616206; cv=none; b=JViZUrXagThrsVDbDxw7B2a9NNuKNSI4bI2Ra3/5wqSmN7HVCVwPtqDxTJcUhKQ8Q7shs9gm1AILDZBSXJYkwkF2bsXNFi+85PEOkLEmH+/RuBJWkF6kNvKJIpd9Ps4r1RF1dchOEn9hP2ZNscemi3YGmZMn0gbx8e+0kU9TcLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758616206; c=relaxed/simple;
	bh=9fhFjemDaxrZP5fRDtkRJGTFA853obiHje/fluk36po=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTRtIxNcuVvfBbLKivajqjp3uY5eIRbtabatNYfHWIqrf1CDp6s8SZ0i+F/XrdxYjDlAjwLbvXIw8bg2/2kTGbhWfXmGtdpcTRoe6iYM1y9yOtSaHaoVejrI0VBKa29WtZoGONvzLLEw7SIvN4AufuEHCpywsm+Uj0uJaKc6eCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=An2XW3sm; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="An2XW3sm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758616205; x=1790152205;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KeaqGM/dnSt7VQMXlKJMzUPAvYn4X0kFJnsfUt3Memw=;
  b=An2XW3smu0r0KW6KRYLfGp5kuJ7dJ1sqQRd5ElueQ503Xm3mFVNytSXr
   aPIgsRIRf+A4lAJwYTY+dHhWwuUaI90S8/3zFywRvKWG/ej4Cs522dB1v
   GrSlbKV2R5PjnTNup7TSTiOHvsqkWYJ+GDOmpZ5BUtW8vwt7UGdAIbqBj
   nPIkt94Fx2etEEtW2CVHq/ts3kARHfPmL0ErkTbE9WLINDJmw5uqr4daH
   Y2ikNfHmV+PoSj4UO4JabTMrWcIEp2MD8+C8t88Fe0J/K0HyMpQVhFwMF
   msI15C/dehBRrmQywWovceFtk9c+lGYvBycAyTdUAjXCSiasVnQtkg3E1
   Q==;
X-CSE-ConnectionGUID: Y+SxHihJTXaZjG3dAprjYQ==
X-CSE-MsgGUID: xfFWRL0GTsqKazJJtxEOcA==
X-IronPort-AV: E=Sophos;i="6.18,263,1751241600"; 
   d="scan'208";a="3553817"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 08:30:04 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:11530]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.21:2525] with esmtp (Farcaster)
 id a2aa504d-997f-4357-87ea-aa2904c81b42; Tue, 23 Sep 2025 08:30:04 +0000 (UTC)
X-Farcaster-Flow-ID: a2aa504d-997f-4357-87ea-aa2904c81b42
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 23 Sep 2025 08:30:02 +0000
Received: from c889f3b3a561.amazon.com (10.106.101.44) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 23 Sep 2025 08:30:01 +0000
From: Priscilla Lam <prl@amazon.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>
CC: <christoffer.dall@arm.com>, <dwmw@amazon.co.uk>, <graf@amazon.com>,
	<gurugubs@amazon.com>, <jgrall@amazon.co.uk>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <prl@amazon.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>
Subject: Re: Re: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
Date: Tue, 23 Sep 2025 01:29:55 -0700
Message-ID: <20250923082955.66602-1-prl@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: 86frcd1tp4.wl-maz@kernel.org
References: <86frcd1tp4.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Hi Oliver and Marc,

Thanks for the detailed feedback.

> But at the end of the day, what do you need KVM_TRANSLATE for? This
> interface is an absolute turd that is unable to represent the bare
> minimum of the architecture (writable by whom? physical address in
> which translation regime? what about S2 translations?), and is better
> left in the "utter brain fart" category.

Regarding motivation, this patch is intended to give a userspace vmm
the ability to handle non-ISV guest faults. The Arm Arm (DDI 0487L.b,
section B3.13.6) notes that for load/store pair faults, the syndrome
may not provide the specifics of the access that faulted. In those
cases, the vmm must manually decode the instruction to emulate it. The
introduction of KVM_CAP_ARM_NISV_TO_USER
(https://lore.kernel.org/kvm/20191120164236.29359-2-maz@kernel.org/)
seems to have anticipated that flow by allowing exits to userspace on
trapped NISV instructions. What is still missing is a reliable way for
userspace to query VA->IPA translations in order to complete emulation.

> Please do selftests changes in a separate patch.

Ack, will split the kernel changes and selftests into 1/2 and 2/2.

> So arch/arm64/kvm/at.c exists for this exact purpose: walking guest page
> tables. While it was previously constrained to handling NV-enabled VMs,
> Marc's SEA TTW series opens up the stage-1 walker for general use.

Thanks for the reference, I wasn't aware of this. I'll drop the bespoke 
VHE/NVHE paths and use the shared S1 walker in v2.

> "linear_address" is a delightful x86-ism. I'd prefer naming that was
> either architecture-generic -or- an arm64-specific struct that used our
> architectural terms.

I'll switch internal naming to VA/IPA. For uAPI, I'll retain the field
for compatibility and translate internally.

> Thanks to borken hardware, this needs to go through the write_sysreg_hcr()
> accessor.

Ack, will use write_sysreg_hcr().

> KVM supports both FEAT_S1PIE and FEAT_S1POE, so this is not a complete
> MMU context.

Understood. v2 will rely on the shared walker to avoid missing S1PIE/S1POE.

> The AT instruction can generate an exception, which is why __kvm_at()
> exists.
>
> And this is where reusing the existing translation infrastructure is
> really important. The AT instruction *will* fail if the stage-1
> translation tables are unmapped at stage-2. The only option at that
> point is falling back to a software table walker that potentially faults
> in the missing translation tables.

v2 will use __kvm_at() and the fallback software walk.

> What about permissions besides RW?

I'll add support for the additional bit (execute and EL0) in v2.

> Yet another interesting consideration around this entire infrastructure
> is the guest's view of the translation that the VMM will now use. KVM
> uses a pseudo-TLB for the guest's VNCR page and maintains it just like a
> literal TLB.
>
> How would the guest invalidate the translation fetched by the VMM when
> unmapping/remapping the VA? Doesn't the stage-1 PTW need to set the
> Access flag as this amounts to a TLB fill?
> Understanding what it is you're trying to accomplish would be quite
> helpful. I'm concerned this trivializes some of the gory details of
> participating in the guest's virtual memory.

My intent is for this ioctl to be side-effect free with no AF updates 
and guest-visible TLB fills. I’ll send v2 as two patches with the above
changes.

Thanks,
Priscilla
