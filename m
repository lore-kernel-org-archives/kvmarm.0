Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA58371053
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 07:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789631205; cv=none; b=uv1uPLse9TAQ3zSpojyd3T1RN+WiqF8v6+KdTbd/ReFXpAmbIXLZROpOb1GLcFlHHCTCXE/iFBW1V8AP0Usi+clB4cfVPpJ8P6BAIJk4bHPkQ85T9X8whcm2kfD4SU/vCsCvOhP6VirZf0+rfpVyZRRF2XmY0Zoq/1phhzB9BtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789631205; c=relaxed/simple;
	bh=ffn4Z8w2vbV/yjMAVjCF39Xnvzt5sDQWpk/k1VIoL50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMQaULMaQOM0xAijOygtsu5dyBPcN17Fg8vowuqDIbZiXi2mxeOZCpenBfknTfQJYZBayAmptzN8n/gCaWS+lDAL0eYeMou5Y5dWb5LY9h34RdIy1QSME/nHZobn27qs3zbNKbM342ELOLHz8bIqlS1vWjyk18xeC6UaXp3Wp8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=gTzEk1sz; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="gTzEk1sz"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789631203; x=1821167203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ffn4Z8w2vbV/yjMAVjCF39Xnvzt5sDQWpk/k1VIoL50=;
  b=gTzEk1szDXb9QjNlYfW/DVteMhvH4od08/73eoBP01ncWKeEWclk9IT6
   wWa0UWzbDqRmVmOclrmntsCHJFqlr+I6F1urnw0g4Cv4cg69alPYhsL+r
   IsnFNI3wPDVeB73ZX5LcHtEokoLrZ4CA4hp/gaFIbLZUN3q4qvb9r3J3x
   LMXzBGgNGabRTV4NSRPICSO8PvmaPJzogn8aAQWhTqoc0MZsHZotwKJdy
   O0vXXNpTWFDR0xyfORG1eo3P0EsP98ygqoKArIRzcWyHOz2G0juFLdFdC
   w2SA2XV4UM0FPa9HrgPMcHE62Q/1GKNPLTTrXOyssgUc0oiU+IMQYTCtm
   Q==;
X-CSE-ConnectionGUID: 8WwHEIH5TpCZlgs0vxdZuQ==
X-CSE-MsgGUID: dQTTfOV8TtGIl+0fcrsjNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="255297879"
X-IronPort-AV: E=Sophos;i="6.27,103,1786978800"; 
   d="scan'208";a="255297879"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2026 16:46:40 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 803D9820C0C
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 07:46:39 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 328068D65F4
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 07:46:39 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with ESMTPS id 400491800B10;
	Thu, 17 Sep 2026 07:46:32 +0000 (UTC)
Date: Thu, 17 Sep 2026 16:46:30 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: ptdump: Shadow ptdump fixes
Message-ID: <aqua1jotej32hxLP@sm-arm-grace07>
References: <20260916230337.4162485-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916230337.4162485-1-weilin.chang@arm.com>

Hi Wei-Lin,

On Thu, Sep 17, 2026 at 12:03:35AM +0100, Wei-Lin Chang wrote:
> Hi,
> 
> This is v3 of fixing the sleep-in-atomic problem of the shadow ptdump.
> The approach taken this time is simply creating a file for each nested
> mmu.
> 
> The ptdump files are created alongside the nested mmus in
> kvm_vcpu_init_nested(), in a sleepable context, and removed when the VM
> is destroyed (kvm_destroy_vm_debugfs(), before the nested mmus are freed
> in kvm_destroy_nested()). This allows us to store the kvm_s2_mmu pointers
> in the ptdump code, after Marc's nested mmu lifecycle fixes [1].
> 
> For the shadow ptdump, for valid nested mmus the first line will show
> the nested context's VTTBR and VTCR values, and whether s2 is enabled or
> not. The ptdump then follows.
> 
> The first patch fixes mmu->pgt accesses after the VM MMU teardown in
> ptdump.c, the second patch switches from per nested context ptdumps to
> per nested mmu ptdumps.
> 
> Tested with CONFIG_PROVE_LOCKING, CONFIG_DEBUG_ATOMIC_SLEEP, and
> CONFIG_KASAN.
> 
> Series based on kvmarm/fixes.
> 
> * Changes from v2 [2]:
> 
>   - Changed from creating a file that contains all nested mmus to
>     creating one file for each nested mmu.

I've booted your kernel built only CONFIG_DEBUG_ATOMIC_SLEEP enabled
mentioned above kernel configs; on Grace CPUs shadow_stage2 test did 
not trigger the sleep in atomic message.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

Thanks,
Itaru.

> 
> Thanks!
> 
> [1]: https://lore.kernel.org/kvmarm/20260911162203.1919330-1-maz@kernel.org/
> [2]: https://lore.kernel.org/kvmarm/20260630121005.1130996-1-weilin.chang@arm.com/
> 
> Wei-Lin Chang (2):
>   KVM: arm64: ptdump: Check the page tables aren't freed when accessing
>   KVM: arm64: ptdump: Fix shadow ptdump sleep-in-atomic-context problem
> 
>  arch/arm64/include/asm/kvm_host.h |  4 --
>  arch/arm64/include/asm/kvm_mmu.h  |  6 +--
>  arch/arm64/kvm/nested.c           |  9 ++--
>  arch/arm64/kvm/ptdump.c           | 75 ++++++++++++++++++++-----------
>  4 files changed, 54 insertions(+), 40 deletions(-)
> 
> -- 
> 2.43.0
> 
