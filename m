Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDD02D46BD
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 02:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770603764; cv=none; b=KAm4R6G+fWDYl52zLzgqp+DVm7v6Ef9xB6sxgdqyvsh3Qax5YJgnNX1xDIgd0OvK5bpXd5fgJFckhPGbYQhzdDi5zBKXLEuzaIkroYWPItWP5bFzTC15+xuEXaxBk51lbCxtf5MJKPNYmhySjTm62zi2IcDg07TMuSsTjYtgBdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770603764; c=relaxed/simple;
	bh=uEoAxL7Z0R6R42jyAePfMGOhe3kCV3QDCbGYYM4fPo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txTkirwdkH/sKNK0qbe1J7CmgSy/l2SFk5VnfY0bxluQk+y717eirad94RPewHK0gyPDZmgIbC2FODGKGf+Yxg1iA5To9Rf1vvKPAI39gZdt/VPMVfFD34HmfrRqbIVMxSfuxvPotfxnSNXLqz8lrI/EccwrTxD5aSNeSQA/me4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=WwIDbQso; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="WwIDbQso"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1770603764; x=1802139764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uEoAxL7Z0R6R42jyAePfMGOhe3kCV3QDCbGYYM4fPo4=;
  b=WwIDbQsod9VDYLyMKxlYBUb40pSZti09BMFu5DgARc0dnjCZm+ZP1Npz
   cNKqbnEuXJN8DWdlCzF0UhurtfMxt35gzLnyuOBL/+wawXYGZiCDsGNJ1
   7h9H7geEY6wet5V+owHRg3fLkBgbAOw7mP5Zgd4AglxXfYCERWyE9HU3d
   b8U1bteF1+3at2Fwszkf3KzmoL3pF8OIj/hFuuKArtHV8l/9xu3mlPjRX
   3/GYjCxsKNKlF9vRYv9zgZEVGzNy612EsBDig1ldEQcD5tJLe+uJCmA8z
   G655r9/lR56nQ3QuAJZINRaCbOt6CHQL0z0AYpMR/IsThYiPy61jjjRzp
   g==;
X-CSE-ConnectionGUID: Zac7IUiOSL+kWT3Sscj8rg==
X-CSE-MsgGUID: engSUfV4Qre3gBiCjFa8Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="216391492"
X-IronPort-AV: E=Sophos;i="6.21,281,1763391600"; 
   d="scan'208";a="216391492"
Received: from unknown (HELO mail.fujitsu.com) ([20.61.8.234])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 11:21:27 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgr2.fujitsu.com (Postfix) with ESMTPS id 64D6B304E
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 02:21:27 +0000 (UTC)
Received: from az2nlsmom1.o.css.fujitsu.com (az2nlsmom1.o.css.fujitsu.com [10.150.26.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 1A689C012B4
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 02:21:27 +0000 (UTC)
Received: from sm-arm-grace07 (sm-x86-stp01.soft.fujitsu.com [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom1.o.css.fujitsu.com (Postfix) with ESMTPS id 38D95829F2E;
	Mon,  9 Feb 2026 02:21:22 +0000 (UTC)
Date: Mon, 9 Feb 2026 11:21:19 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH kvmtool v5 0/7] arm64: Nested virtualization support
Message-ID: <aYlEn74Td8vHSmgJ@sm-arm-grace07>
References: <20260123142729.604737-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123142729.604737-1-andre.przywara@arm.com>

On Fri, Jan 23, 2026 at 02:27:22PM +0000, Andre Przywara wrote:
> This is v5 of the nested virt support series, fixing a corner case when
> some maintenance IRQ setup fails. Also there is now a warning if --e2h0
> is specified without --nested. Many thanks to Sascha for the review!
> ========================================================
> 
> Thanks to the imperturbable efforts from Marc, arm64 support for nested
> virtualization has now reached the mainline kernel, which means the
> respective kvmtool support should now be ready as well.
> 
> Patch 1 updates the kernel headers, to get the new EL2 capability, and
> the VGIC device control to setup the maintenance IRQ.
> Patch 2 introduces the new "--nested" command line option, to let the
> VCPUs start in EL2. To allow KVM guests running in such a guest, we also
> need VGIC support, which patch 3 allows by setting the maintenance IRQ.
> Patch 4 to 6 are picked from Marc's repo, and allow to set the arch
> timer offset, enable non-VHE guests (at the cost of losing recursive
> nested virtualisation), and also advertise the virtual EL2 timer IRQ.
> 
> Tested on the FVP (with some good deal of patience), and some commercial
> (non-fruity) hardware, down to a guest's guest's guest.

Hi Andre,
I wonder if you have also tested this series with the latest QEMU which
has FEAT_NV2 support; I ask because when I tried to create a nested
guest with (again) lkvm it got stuck forever.

Thanks,
Itaru.

> 
> Cheers,
> Andre
> 
> Changelog v4 ... v5:
> - bump kernel headers to v6.19-rc6
> - print a warning if --e2h0 is given without --nested
> - fail if the maintenance IRQ setting attribute is not supported
> 
> Changelog v3 ... v4:
> - pass kvm pointer to gic__generate_fdt_nodes()
> - use macros for PPI offset and DT type identifier
> - properly calculate DT interrupt flags value
> - add patch 7 to fix virtio endianess issues
> - CAPITALISE verbs in commit message
> 
> Changelog v2 ... v3:
> - adjust^Wreplace commit messages for E2H0 and counter-offset patch
> - check for KVM_CAP_ARM_EL2_E2H0 when --e2h0 is requested
> - update kernel headers to v6.16 release
> 
> Changelog v1 ... 2:
> - add three patches from Marc:
>   - add --e2h0 command line option
>   - add --counter-offset command line option
>   - advertise all five arch timer interrupts in DT
> 
> Andre Przywara (3):
>   Sync kernel UAPI headers with v6.19-rc6
>   arm64: Initial nested virt support
>   arm64: nested: Add support for setting maintenance IRQ
> 
> Marc Zyngier (4):
>   arm64: Add counter offset control
>   arm64: Add FEAT_E2H0 support
>   arm64: Generate HYP timer interrupt specifiers
>   arm64: Handle virtio endianness reset when running nested
> 
>  arm64/arm-cpu.c                     |   6 +-
>  arm64/fdt.c                         |   5 +-
>  arm64/gic.c                         |  29 ++++++-
>  arm64/include/asm/kvm.h             |  25 ++++--
>  arm64/include/kvm/gic.h             |   2 +-
>  arm64/include/kvm/kvm-config-arch.h |  11 ++-
>  arm64/include/kvm/kvm-cpu-arch.h    |   5 +-
>  arm64/include/kvm/timer.h           |   2 +-
>  arm64/kvm-cpu.c                     |  64 ++++++++++++---
>  arm64/kvm.c                         |  19 +++++
>  arm64/timer.c                       |  29 +++----
>  include/linux/kvm.h                 |  47 +++++++++++
>  include/linux/virtio_ids.h          |   1 +
>  include/linux/virtio_net.h          |  49 +++++++++++-
>  include/linux/virtio_pci.h          |   3 +-
>  powerpc/include/asm/kvm.h           |  13 ----
>  riscv/include/asm/kvm.h             |  29 ++++++-
>  x86/include/asm/kvm.h               | 116 ++++++++++++++++++++++++++++
>  18 files changed, 394 insertions(+), 61 deletions(-)
> 
> -- 
> 2.43.0
> 
