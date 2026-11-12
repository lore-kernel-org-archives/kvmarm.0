Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.139.117
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794474505;
	b=1VGyPlsBFt5sVBgmhGzy1AMzsF7thcx+LjSdL3hUn/oEa6ApJ0xsjuxABayfTlxgGhU5
	 AiKl+zUVlg61MNIQJoZ0gTbc3dDDttuYw6OHZ8a88wZYfBrAVX604Gps05zR/s2b4m6SD
	 Sz3+sOrrbWk3Vxy+ygPxkafQ319k5wH2ZRrcimHfFk/C33W2eX+1Zg+x0iNdvTdxUIAP4
	 5MJVBdJqbEJir9t5yIO8Y6ygGyvmcui92sZXaWcZUhOs6JuSnsic0/X63qKEEEegHuUFT
	 BTqyQdB0y6CwXrM9ti9bUGxBEWwh6FXdZFkTsIiUzQ9YRgh7l0GA+1jsV+R6k/5g6FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794474505;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=s27wvHS07SuwEnoAPuKZTYMrrXbi2Voqx1f7y+dH6O0=;
	b=q8fg1aJAjfefaIoZ5mqoJeAK3Axvn8xNUdjpx5oq7QIAkWZ26SFRedqcHnOArID4oyZ7
	 48v2cTM9s7a0FQHO4UkDYZA5R3XxoynDRv5bkaUUOq6Rq09aTjzkovx/iDAH1LqvyZMCf
	 V6m35vwoUAijZDbOdnkfWBFjMVA4JNZ4EyhC7/Voj+bJ2bASt6tn9bvBLQn8wAhZHXYhk
	 zA97e/Y+Pvm2vdOw8NnD2KP9lfAkh9259HneFHKiw/rIKuHHsnpOR5i5eTrNpv+l383ET
	 4cv646HTXbf+8yIc7C3nNFDpu6DhioAoN13voSTnMPQYMxos9XXzj2mH7tjA66C1EBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b="epVh3cc/";
	arc=none smtp.remote-ip=68.232.139.117
Received: from esa4.hc1455-7.c3s2.iphmx.com (esa4.hc1455-7.c3s2.iphmx.com [68.232.139.117])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E806606A33C;
	Thu, 12 Nov 2026 09:08:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E806606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=epVh3cc/
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1794474512; x=1826010512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9Tx2kYwYrf5VVNfDHDCGqna3I8YOzDbxeRSc934oNm0=;
  b=epVh3cc/pkQhLt3UJdzvm86Y3kYvCJLNwaNki17DbQXtEzkIRLkOGHby
   EK4nuiDMTsJXGpmSsUjeajFTQphuvbxYDyoQHn40j3g3VFmzjpjlMatyy
   U2yUK3aQqQMy3sOXnl9gplkvZBgV8flXp1v3ekdMSiK+ICh69GFiF6OlD
   tZDbjCddW4HiSxK5nJYlAxrht6FwH2Zg+GTxRzW4xErPOutt6MqHmHgKL
   lBvoWJQETE8lnq1XWjaBu9Rf5+UwM+CEaqGpnuIfsLK+1IJs1St8qFWnH
   m6twrJOmy/8SzaDnuaVQVU6fQosg0EClOyY7RGS7JrmndrtSMRkyooEQg
   w==;
X-CSE-ConnectionGUID: 3h1yph7MRC2YipYBTHzwXw==
X-CSE-MsgGUID: qYWnFbrhQCWBoWz2lpHaZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="261091051"
X-IronPort-AV: E=Sophos;i="6.27,209,1786978800"; 
   d="scan'208";a="261091051"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa4.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 18:08:24 +0900
Received: from az2nlsmgm4.fujitsu.com (unknown [10.150.26.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id CF33F100008B;
	Thu, 12 Nov 2026 09:08:16 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm4.fujitsu.com (Postfix) with ESMTPS id 7B5DA1000246;
	Thu, 12 Nov 2026 09:08:16 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.86.149])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with SMTP id 706EA405EFB;
	Thu, 12 Nov 2026 09:08:07 +0000 (UTC)
Date: Thu, 12 Nov 2026 18:08:06 +0900
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
Subject: Re: [PATCH v2 00/12] KVM: arm64: CCA: Prepare Realm memory management
Message-ID: <avV-P2_fOkFWQVnM@FCCLS0092175.localdomain>
References: <20261111145758.217946-1-steven.price@arm.com>
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
In-Reply-To: <20261111145758.217946-1-steven.price@arm.com>

Hi Steve,

On 11/11 14:57, Steven Price wrote:
> This series adds the memory management plumbing for CCA, building on the
> basic RMM support [1]. Thank you to those who reviewed v1 - I'm
> attempted to address all the comments.
> 
> The patches introduce internal Realm VM state and RMI feature checks,
> prepare Realm stage-2 setup and teardown, and provide RTT mapping and
> invalidation helpers. Realm memslots are restricted to the lower half
> of the IPA space because the protected and shared halves alias each
> other. The final patch connects the helpers to KVM's stage-2 MMU
> operations.
> 
> This is the memory management portion of the larger Realm host series.
> Realm descriptor creation, REC entry and exit, activation, and the new
> uAPI follow in the integration stack. This series alone does not enable
> Realm creation.
> 
> As before there's an integration branch[2] that includes the realm
> creation, REC entry/exit etc building on top of this series. I've also
> pushed a git branch[3] of just this series.
> 
> Changes since v1:
> - Add a guest_memfd prerequisite patch that checks whether the backing
>   file supports mmap when preparing an arm64 memslot.
> - Combine the RMI availability and feature checks into one patch, and
>   move Realm vCPU feature restrictions to the integration stack.
> - Correct Realm IPA sizing and RTT teardown, including teardown before
>   activation, RTT accounting, and handling of missing or folded RTTs.
> - Rework RTT mapping to respect IPA and physical alignment, handle
>   partial RMI progress, and retry interrupted operations.
> - Preserve private mappings when a Realm guest_memfd memslot deletion is
>   rejected, and tighten Realm fault handling and stage-2 destruction.
> 
> [1] https://lore.kernel.org/all/20261007073537.2454351-1-suzuki.poulose@arm.com/
> [2] https://gitlab.arm.com/linux-arm/linux-cca
>     branch: cca-host-mm/v2/integration
> [3] https://gitlab.arm.com/linux-arm/linux-cca
>     branch: cca-host-mm/v2/mm
> 
> Steven Price (7):
>   KVM: arm64: CCA: Reserve the RMM mode
>   KVM: arm64: guest_memfd: Check mmap support when preparing memslot
>   KVM: arm64: CCA: Check RMI support and features at init
>   KVM: arm64: CCA: Add basic infrastructure for creating a realm
>   KVM: arm64: CCA: Tear down RTTs
>   KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers
>   KVM: arm64: CCA: Support runtime faulting of memory
> 
> Suzuki K Poulose (5):
>   KVM: arm64: CCA: Introduce Realms
>   KVM: arm64: Handle attributes in stage2_unmap_range
>   KVM: Allow architectures to reject memslot changes before invalidation
>   KVM: arm64: CCA: Prevent memslot modifications after Realm creation
>   KVM: arm64: CCA: Add Realm stage-2 MMU operations

I've tested the integration branch [2] including this series on our
hardware using the QEMU-VMM proposed in:
  https://lore.kernel.org/qemu-devel/20261002202026.1204110-1-mathieu.poirier@linaro.org/

The Realm guest VM (32 vCPUs, 16 GiB RAM) booted successfully. To
exercise the guest with a more realistic workload, I also performed a
full Linux kernel build, which completed successfully.

A Tested-by tag might not be carried over to the next revision, if any,
but anyway, for this series:

Tested-by: Kohei Enju <enju.kohei@fujitsu.com>

Thanks,
Kohei
