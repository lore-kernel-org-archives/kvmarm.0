Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A683372B24
	for <kvmarm@lists.linux.dev>; Tue,  9 Jun 2026 20:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038614; cv=none; b=rB/aN6Xp7PPkKA1jCY2aGTjY9NPMXgUiySpdQY/kkprQAQ5oD20oLrPkQYFTGqt0XeYHS2hEApNTpKbaPynQWos2IzvHnM5KeZHS16mPTiguu0mf49q3tnTlWboPqwa7sbWc9aVpDvDOfQEkYhOVsb1mLfqnDtndjUkOp75rL6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038614; c=relaxed/simple;
	bh=y5l/ZoN7FDzXRaE9QmP240LlQRqXbiNY0URNw/PAVDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0wcu+yliI6xZXlvvGEquijkCPhRUPNrMx2UmiLWbFbQs5GuK5URuYZ1vRXv/zuPdhmoCo+/61Or9CFQU5g/6BQOTN4vBCzIGNVMsKblEzShjipd1X/T+TwhlG89RVK6csDlOSzrt1vMm+L18BO5KM3ZP1fMlU2FElI9ovqN974=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=hYLL0ii5; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="hYLL0ii5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1781038613; x=1812574613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LESoFZ3sjnNgjQODSouywqTG6UHJOI9DT0ddkuNcF5g=;
  b=hYLL0ii56yA8EpoldLAeeUKl8syu02/m0+bJV6BexhCgSv8eOLukryVV
   mOcI36J5Hf29Y8jVxGpWk+8LpqEswu4djyc0GcQ7EzkvqBOY8VkUFjm85
   EzZrWxEsq25nJJ7Og0BCix9p3BvA8SiqdVe9U20YL8ZuyhPej8PTPVEui
   XthLjNiXPik+cgK0/MMpsK7nzroPU0Xa+NoY+3hWgbX7kHsSf+5SB4bk3
   /zpjs0gTeLeR8HPkinpHOLYV9Ldvit0goR5vV6ffHpaLXd8iEvfjvb2C8
   4prptSMInSGOMSSwVCQO7jBvEmX/pZOXEQJlD2UKkrO4TXdZ42JEJhxIf
   A==;
X-CSE-ConnectionGUID: 7m59Ayi0ROC+I+wdQ0n6uA==
X-CSE-MsgGUID: W4y/ImxzQyCm1T/AImIcGQ==
X-IronPort-AV: E=Sophos;i="6.24,196,1774310400"; 
   d="scan'208";a="21208045"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 20:56:52 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:18031]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.253:2525] with esmtp (Farcaster)
 id 03f7cd46-cc75-49bf-99db-d82e40443859; Tue, 9 Jun 2026 20:56:52 +0000 (UTC)
X-Farcaster-Flow-ID: 03f7cd46-cc75-49bf-99db-d82e40443859
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 9 Jun 2026 20:56:52 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Tue, 9 Jun 2026
 20:56:51 +0000
From: Congkai Tan <congkai@amazon.com>
To: <oupton@kernel.org>
CC: <blakgeof@amazon.com>, <catalin.marinas@arm.com>, <congkai@amazon.com>,
	<harisokn@amazon.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<mark.rutland@arm.com>, <maz@kernel.org>, <suzuki.poulose@arm.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Date: Tue, 9 Jun 2026 20:56:21 +0000
Message-ID: <20260609205621.2327622-1-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aieclTmL1op0AYfS@kernel.org>
References: <aieclTmL1op0AYfS@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jun 08, 2026 at 09:54:45PM -0700, Oliver Upton wrote:
> >   - set_pmmir() writes pmmir_slots to 0 if the user input is 0;
> >     otherwise it no-ops or rejects.
>
> Reject is always better heh :)

For sure. Just to see what happens when migrating a guest onto a PMU
with different SLOTS - after pmmir_slots is set to the new value, the VMM
tries to restore the original non-zero SLOTS via SET_ONE_REG and gets the
error. I think it's a good design to force VMMs to be aware of SLOTS
changes?

> So I was previously under the impression that we already expose PMMIR_EL1
> to userspace but we actually don't. Grr.
>
> The UAPI around PMUv3 is crappy enough that we should just add a new
> vCPU feature flag. When that flag is set:
>
>  - KVM will not create a 'default' PMU, userspace must select a PMU
>    implementation to init the vCPU
>
>  - PMMIR_EL1 becomes a user-visible register with the behavior that you
>    outline above
>
>  - No PMCEID masking for STALL_SLOT* events
>
> There's a couple larger PMU features underway (e.g. Colton's partitioned
> PMU, Akihiko's fixed counters PMU) that we can also condition on the new
> feature flag.

It makes sense to guard everything behind a flag. Just to confirm my
understanding, by "a new vCPU feature flag" are you referring to
extending the features set through KVM_ARM_VCPU_INIT? If so,
since the flag may guard more PMU features later, do you have a preferred
name in mind that best reflects its planned usage?

For v2 I'll work on 3 patches:

  - Patch 1 adds the flag, skips the default PMU selection behind it, and
    checks for/rejects absent PMU

  - Patch 2 implements the new PMMIR_EL1 behavior

  - Patch 3 implements the new PMCEID1 behavior

Thanks,
Congkai
