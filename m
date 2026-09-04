Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DE6372B27
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521848; cv=none; b=ul80WHfmKadrl7CxLN1mqw73hn0nGCr9yCsOQN/aAsjA6T87gYL1DhlQNA8X+0FHaJa1Z4GMtWSa7rRiEYjFnxjUTON6HVBQ7AchUmZzYl5zqZCaGFBRxi+pBxGKU7uxnBGR9/+AU94mW2VWL09Z1pvU2A4nAC1nUgVATVHjuH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521848; c=relaxed/simple;
	bh=m2jJiBlsGUl4iHLP2o7iADnOmSK5Bj/o7he5EW66eco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X0ytpoR0Jnm1FVPSCbBvZNyTCTt4FT/phsDx2scCzWv237ktJYzbtHN4TvgIWCKTcTlj7AfPCkIeiTE+UKi17iRRk03zUgTf1zMLkTijjYx6tulOcGl2haOL8XmpMMxLCrScJHGYM9/9mRCESEK1ZdKTdot9mqdnJcdo9aBeDX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eiar/h/1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eiar/h/1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6699C153B;
	Fri,  4 Sep 2026 04:37:22 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F1323F7D8;
	Fri,  4 Sep 2026 04:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788521846; bh=m2jJiBlsGUl4iHLP2o7iADnOmSK5Bj/o7he5EW66eco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eiar/h/118H3a26KLPtyaEh01KpT6iuhc/C4MWOEQVSZ71ewPamnAN4Sh8c8NOBT5
	 tf8GjBQDEl+RQyte6ly7DVyLotsZugzcktiZLPkqB4ujHbpMgcQUZ3Z2umKCC/eKYP
	 DNTgvTtQVNGmE01bJbFg1pGSyX2iOOzLE+dDleTM=
Date: Fri, 4 Sep 2026 12:37:17 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Wang Han <wanghan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	oupton@kernel.org, tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, ljs@kernel.org, 
	itaru.kitayama@fujitsu.com
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
Message-ID: <nhqjbq4kwx2n7id4eovyhg4htgbh34m57o2vx2swbuxc5lu2pl@xelx6xh2qvq6>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260902163500.1841671-1-wanghan@linux.alibaba.com>
 <877bl26aqg.wl-maz@kernel.org>
 <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
 <875x0l5udh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875x0l5udh.wl-maz@kernel.org>

On Fri, Sep 04, 2026 at 08:49:14AM +0100, Marc Zyngier wrote:

[...]

> > > >
> > > > The L1 was started with 8 vCPUs and 32 GiB of RAM using:
> > > > 
> > > >   qemu-system-aarch64 -smp 8 -m 32G \
> > > >     -machine virt,accel=kvm,gic-version=3,virtualization=on \
> > > >     -cpu host -nographic -enable-kvm \
> > > >     -drive if=pflash,format=raw,readonly=on,file=pflash0_bak.img \
> > > >     -drive if=pflash,format=raw,file=pflash1_bak.img \
> > > >     -drive file=./ubuntu-vm.qcow2,format=qcow2,if=virtio,cache=none,aio=native \
> > > >     -nic user,model=virtio-net-pci,hostfwd=tcp::11234-:22 \
> > > >     -serial mon:stdio
> > > > 
> > > 
> > > Puzzling. If you are only running an L1 in VHE mode, there is no
> > > shadow S2, and therefore nothing to unmap. For shadow S2s to be built
> > > and affect the MMU notifiers, you need to run an L2.
> > 
> > I was thinking the same at first, but realized even with L1 in VHE mode
> > there is a small period of time where L1 runs in its EL1 during boot, so
> > one nested MMU will become valid for each vCPU. That causes
> > kvm_nested_s2_unmap() to iterate through the entire IPA space 8 times
> > (-smp 8).
> 
> It should be one nested MMU for the whole VM, not one per vcpu.
> That's assuming they share the same VMID+VTCR.

(sigh) Yes, rookie mistake from me as always.

> 
> > What I am curious about is whether one single notifier unmap is enough
> > to hang L1, or were there multiple notifier unmaps.
> > 
> > QEMU with -machine virt uses 40 IPA bits only, unmapping that takes:
> > 1024  (4KB pages,  unmapping 1GB per iteration)
> > 32768 (16KB pages, unmapping 32MB per iteration)
> > 2048  (64KB pages, unmapping 512MB per iteration)
> > iterations for each page size. There aren't many mappings in each
> > iteration too. Does this really take that long on real hardware (even if
> > this must be done 8 times)?
> 
> This should be close to being at zero cost, so something else is
> amiss.
> 
> Could you please have a look?

Of course.

Thanks,
Wei-Lin Chang

> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
