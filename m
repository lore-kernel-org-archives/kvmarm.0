Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52DC4B1264
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 13:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442121; cv=none; b=l9hzswBDARS1Hwpu6ix6yuYAoN7NDql41Ro5IyeMIKW3Cx2fAF1pO0DNo1F//3wtJofOcmNwYUznL/Z1mENZUalC6zz6dskAfDC3pf3oLh3+Lf0Fwtirt45BxysrX41oWrPENwy7BdC9g/FzKpObSHkLwa0vm0oCuDOr9KDRWIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442121; c=relaxed/simple;
	bh=+jGgT7hK4TtDO3DhbLQAW1lvQ0wVzLhxVC4xl/JmQdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOMMjO8tMzaynK4I8HsH/2HCSbLMDO9wzejnLk6JAkx9Sgj0oM/q5mC2Za55/CJHW+bNhmsmlllw9msbGfhIr+V+igXn4K5TEa8VzAr0XbAVH74VnFtRJ7rKOk0mmd9PifgY5ldY82YmgDEsGaWqawPbEeTBAvL+9yi9LkDSFRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KQAQFGxl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KQAQFGxl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 559CE1596;
	Thu,  3 Sep 2026 06:28:26 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4B203F7D8;
	Thu,  3 Sep 2026 06:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788442110; bh=+jGgT7hK4TtDO3DhbLQAW1lvQ0wVzLhxVC4xl/JmQdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KQAQFGxlsIdiiIPgPxKshJUIDgxfHsawpgx+YXV51nBSHdspWkkH+n8yWYWo1uwVQ
	 /IOWGMiClJCeeP2I/cej/Hg7orK7DY0FV8m9WW6IddxyOtvlCMl8epntHnudof3KYk
	 rS0Yz3IaIOMVOdAgxSjyzEth+kGeZuGhAzWPQW8Q=
Date: Thu, 3 Sep 2026 14:28:16 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>, Wang Han <wanghan@linux.alibaba.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, oupton@kernel.org, tabba@google.com, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, 
	ljs@kernel.org, itaru.kitayama@fujitsu.com
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
Message-ID: <wsnf276xrun3g4hjr3t6alprapctg5z4kpj422v3hujqdjnrsa@swq4blkqvvj5>
References: <20260810205038.118843-1-weilin.chang@arm.com>
 <20260902163500.1841671-1-wanghan@linux.alibaba.com>
 <877bl26aqg.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bl26aqg.wl-maz@kernel.org>

On Thu, Sep 03, 2026 at 08:43:35AM +0100, Marc Zyngier wrote:
> On Wed, 02 Sep 2026 17:35:00 +0100,
> Wang Han <wanghan@linux.alibaba.com> wrote:
> > 
> > Hi Wei-Lin,
> > 
> > I tested this series on a Yitian 710 system with an ARM Neoverse-N2 CPU
> > (128 CPUs, 2 NUMA nodes).
> > 
> > Test environment
> > ----------------
> > 
> >   L0 kernel: Linux v7.2-rc6
> >   L1 guest: Ubuntu 26.04 LTS, kernel 7.0.0-27-generic (aarch64)
> >   QEMU: 10.2.3
> > 
> > L0 NUMA balancing was enabled (`/proc/sys/kernel/numa_balancing=1`).
> > The host was booted with `kvm_arm.mode=nested`.
> > 
> > This series fixes a functional hang that is exposed when NUMA balancing is
> > enabled.  The previous nested stage-2 unmap path is too slow for this
> > workload, making the performance problem user-visible: NUMA balancing can
> > leave the L1 guest unable to make progress and eventually hang during boot.
> >
> > The L1 was started with 8 vCPUs and 32 GiB of RAM using:
> > 
> >   qemu-system-aarch64 -smp 8 -m 32G \
> >     -machine virt,accel=kvm,gic-version=3,virtualization=on \
> >     -cpu host -nographic -enable-kvm \
> >     -drive if=pflash,format=raw,readonly=on,file=pflash0_bak.img \
> >     -drive if=pflash,format=raw,file=pflash1_bak.img \
> >     -drive file=./ubuntu-vm.qcow2,format=qcow2,if=virtio,cache=none,aio=native \
> >     -nic user,model=virtio-net-pci,hostfwd=tcp::11234-:22 \
> >     -serial mon:stdio
> > 
> 
> Puzzling. If you are only running an L1 in VHE mode, there is no
> shadow S2, and therefore nothing to unmap. For shadow S2s to be built
> and affect the MMU notifiers, you need to run an L2.

I was thinking the same at first, but realized even with L1 in VHE mode
there is a small period of time where L1 runs in its EL1 during boot, so
one nested MMU will become valid for each vCPU. That causes
kvm_nested_s2_unmap() to iterate through the entire IPA space 8 times
(-smp 8).

What I am curious about is whether one single notifier unmap is enough
to hang L1, or were there multiple notifier unmaps.

QEMU with -machine virt uses 40 IPA bits only, unmapping that takes:
1024  (4KB pages,  unmapping 1GB per iteration)
32768 (16KB pages, unmapping 32MB per iteration)
2048  (64KB pages, unmapping 512MB per iteration)
iterations for each page size. There aren't many mappings in each
iteration too. Does this really take that long on real hardware (even if
this must be done 8 times)?

Thanks,
Wei-Lin Chang

> 
> So what are your actual test conditions?
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
