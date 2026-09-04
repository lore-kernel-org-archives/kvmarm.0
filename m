Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD9244C66D
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 22:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788561750; cv=none; b=N937zQEGxVZWpdnZAghvzh1OopxzMRcJQFuNw4yKrWzLchN8qQl/KT0cTrwfTOQVT4rGPbbvOa+X4J9FYusa1obvDQ9OM045ny1B/icNCvA/LH6fOFBlLcAWHLE0dzPdRVXMrSX2O/zLmgXzK543/cExyLpizZl55Nz9ju+uIyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788561750; c=relaxed/simple;
	bh=rR1eH2wW2i/JEuOr8EFz618T5pL01rNqEvXg57Ahkls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzSuq/zun2vLMmUxYKAmO9d+++iZM1jGlZRFGgN42GaeHDcPCb+R5y3woKqNxfWzcSY96gCnHIjwEm2O0d+VJGqx7OPhvsssK66qQJ0yR/f/ImPwqmU8oz25ob6k74W7QYKf19W5hUtdEeA4661tIPLk5943+VKjQ3JebGpkfgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LObNHE3L; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LObNHE3L"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3949D1477;
	Fri,  4 Sep 2026 15:42:23 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4CA93F882;
	Fri,  4 Sep 2026 15:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788561746; bh=rR1eH2wW2i/JEuOr8EFz618T5pL01rNqEvXg57Ahkls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LObNHE3LPAhzFKAFLLp09Rc2itWYjVcwjba/VQpDr9oz4nvxxpmGHlFnomJvxVurG
	 K2Jx2j1ulInTavrbMF53oQknXko3+98UCJgoWLgYYhqcUS1XzJT+e0yatbcdUuxM8Y
	 IaG6AEBKANyf3Idd2ER+sbkEevrYTNw4ht27eE1U=
Date: Fri, 4 Sep 2026 23:42:15 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Wang Han <wanghan@linux.alibaba.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	oupton@kernel.org, tabba@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, ljs@kernel.org, 
	itaru.kitayama@fujitsu.com
Subject: Re: [PATCH v5 0/6] KVM: arm64: nv: Implement nested stage-2 reverse
 map (new data structure)
Message-ID: <eylfcgxs2xzu57czyuhkpmum45lpxyccyu2yh3mipr67aq3xo6@xinygxzavoja>
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

Guess what? I am completely wrong once again.

The complete range of the nested mmus isn't about the value
supplied by KVM_VM_TYPE_ARM_IPA_SIZE. Instead it is the PARange exposed
to the guest. That's because the guest hypervisor is allowed to expose
whatever memory map it likes to its nested guests, as long as it is
within the guest's PARange. This is explained clearly in
init_nested_s2_mmu().

Now the PARange exposed to guests should be much larger than 40bits. On
the neoverse-n2 it should be 48bits (256TB), therefore the iterations
required for each unmapping would be 256x:

262144  (4KB pages,  unmapping 1GB per iteration)
8388608 (16KB pages, unmapping 32MB per iteration)
524288  (64KB pages, unmapping 512MB per iteration)

I think these numbers match the hang time Shuai have shown.

Just to demonstrate the difference I have tried manually limiting
kvm_ipa_limit to 40, and tested with software emulation. Before the
manual change a kvm_nested_s2_unmap() finished after 42 seconds, after
limiting kvm_ipa_limit kvm_nested_s2_unmap() can finish in less than a
second.

With this, I think there aren't other underlying issues, it just is that
slow unfortunately..

Thanks,
Wei-Lin Chang

> Could you please have a look?
> 
> 	M.
> 
> -- 
> Jazz isn't dead. It just smells funny.
