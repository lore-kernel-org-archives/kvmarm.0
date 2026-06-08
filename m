Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD936D9EA
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780952683; cv=none; b=OqahRaTY+Td/QCJa4eMHRP1BhnECEp+3sOXQKOOGhU03YX/yVT7bEZWdI55ouXBsvPQkiA0jgaIqKG9XzYoZnjfJ6Ur1HTRZIa+PWa2xeOJbTibomxSAZ2Bc9ZAyUm6iiLt5Zqq+i7EjUTWhAAzVCsAxFP7/xzb3h/UzMgK5Fug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780952683; c=relaxed/simple;
	bh=kzGuJ8Tv8puO792p5yIHjlisPN4dpB4spNDc9DIhLpc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3mCljTpS3EBzU0RYt5IFClJR/C8pn5zh5im1xTs1LqdbfBFQ3rjVCBeZkPNqZOZ9ugObGJOYpXpzMm0j2f5u3jfEPzAOccQ9IFhBvA7TirkfvyHhThFnP9EQZMkrpFyd9zaC2bEMw+ox+KQUjsZIkDCDNnY8UcUT6getgAXIQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=q1rtfQCk; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="q1rtfQCk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780952682; x=1812488682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UZ7fi7G4wG/VICbBP425q7BvhHSQM4WDDJd2mZZW7Mo=;
  b=q1rtfQCkgYqJQjllgKuHtcdT41Li6nVUURnW0KQgFg8AKzQ+B0U04Luv
   r21wnxSxzr16dxxNuOLQIJPgWKoItDmmVgHsPNRBk1dIES9kAelyBCbng
   9nggInjf6GCETwe9OpXxe3bc2BvzC+iyrtjjNz1Kzsp1VHIbq0q6xWBxx
   qi5QDeo78WIZrL1KG8HxTbwa0m4I7wXmJmWz6/Imvct/Ls00sJU+Fu7Ct
   VIY7U+10oZ0iiRXunIbC6l6ls1ZT1VZjvsSegUScMNb5xQc5misO9hprb
   lAUyS2x5kt8NGp2FzmRYpk8gyDwLtcnp5Yw/6SatVjv+QHBYnvTsSU1Jk
   g==;
X-CSE-ConnectionGUID: 5ZKbgY3QT1yv7tc8A9BTLg==
X-CSE-MsgGUID: OUNhnm5qR0ag07ym5ofabg==
X-IronPort-AV: E=Sophos;i="6.24,195,1774310400"; 
   d="scan'208";a="21376921"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 21:04:42 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:7913]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.143:2525] with esmtp (Farcaster)
 id 86900df2-f338-4972-80ae-43ba72e810f2; Mon, 8 Jun 2026 21:04:41 +0000 (UTC)
X-Farcaster-Flow-ID: 86900df2-f338-4972-80ae-43ba72e810f2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 8 Jun 2026 21:04:41 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Mon, 8 Jun 2026
 21:04:41 +0000
From: Congkai Tan <congkai@amazon.com>
To: <oupton@kernel.org>
CC: <blakgeof@amazon.com>, <catalin.marinas@arm.com>, <congkai@amazon.com>,
	<harisokn@amazon.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<mark.rutland@arm.com>, <maz@kernel.org>, <suzuki.poulose@arm.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Date: Mon, 8 Jun 2026 21:03:59 +0000
Message-ID: <20260608210359.1757125-1-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <ah3mObchzwb80_3S@kernel.org>
References: <ah3mObchzwb80_3S@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Jun 01, 2026 at 01:06:17PM -0700, Oliver Upton wrote:
> We can't change the value of PMMIR_EL1 unconditionally since older KVM
> treated this register as RAZ/WI. This also mixes poorly with the default
> PMU garbage that we have since as the value of the register can change
> based on where KVM_ARM_VCPU_INIT gets called...
>
> Considering everything, I'd like to see this wired up where:
>
>  - PMMIR_EL1.SLOTS takes the value of the underlying hardware PMU only
>    if the VMM explicitly selects a particular PMU implementation
>
>  - KVM allows userspace to set PMMIR_EL1.SLOTS=0 for backwards
>    compatibility

Thanks a lot for the review! Makes sense. We'll work on v2, and here is
the high-level design we plan to follow:

  - Introduce a new VM-wide field, e.g. kvm->arch.pmmir_slots.

  - Seed it from the underlying hardware value only when handling
    KVM_ARM_VCPU_PMU_V3_SET_PMU; otherwise it stays 0.

  - access_pmmir() returns whatever is in pmmir_slots.
  
  - set_pmmir() writes pmmir_slots to 0 if the user input is 0;
    otherwise it no-ops or rejects.

This way the guest only sees the underlying hardware value if the VMM
selects a PMU via KVM_ARM_VCPU_PMU_V3_SET_PMU, and userspace can pin
SLOTS = 0 through KVM_SET_ONE_REG for backwards compatibility.

Please let me know if there are any concerns. I'll send v2 once it's
ready.

Thanks,
Congkai
