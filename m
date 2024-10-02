Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBF41D2B00
	for <kvmarm@lists.linux.dev>; Wed,  2 Oct 2024 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727883907; cv=none; b=fc2M3WMXIbEOO2jkPCEbVU+xnYQaPhV+X4AfSIPgFac0vxhmtzC5VDkCyW31HTq1j4d+X3kaN/JSQUyo/3Orlq3Suo5+HMDyQgHDzOJabnz4y7WIRmCN+r4270sbebmGts9OO8RhznY+T4fdbyfxPXGgpIZe8/XczjSiSgfYdMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727883907; c=relaxed/simple;
	bh=XhEkyMPnd7QPKpP6cWGqvwHoptTT9TVgsgWK3bsOzFg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pb8+XCYp9jeKR2QopD/y+OVzUJgFl7EVr5z2QBFCaqJ13/weteep/CpnnmIAk+yWrsVEB3wFx8IwPPsHeZtgYADffJ+yvIPOxvuHtWpnIZNv81cHrr3OUhfVygUWkb31c+/Ngep0R/3C7S6vMm9rENxMZ1Kqgi1oCJQDAPu51sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q8bSSi2P; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q8bSSi2P"
Date: Wed, 2 Oct 2024 15:44:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727883901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wEAc2RAWQRgyOGkrtK+hXeUGOKjWMXazGBlHNjqjAxY=;
	b=q8bSSi2P8Cw0ujL9ST61nvd/gqIWijgFSbaaZ0INnXV/5HM8EP0m0sHcjlHxdpCWefrmaq
	W/MfEY8alBRwsV7PMVEECMiCOYhMp5qbXshOkbrcAbTQnbPo2APWPzE173u8A1mByCfZMx
	MhnJ9IvBERVDfSkv+67X2Ldhmi9HdnE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: James Clark <james.clark@linaro.org>
Cc: kvmarm@lists.linux.dev,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	will@kernel.org, tabba@google.com, maz@kernel.org
Subject: Re: [bug report] KVM: arm64: BUG when reading kcore with
 kvm-arm.mode=protected
Message-ID: <Zv1qeOOHjF0mv5Su@linux.dev>
References: <f99c7436-502f-4f51-9a3c-c402b70bac58@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f99c7436-502f-4f51-9a3c-c402b70bac58@linaro.org>
X-Migadu-Flow: FLOW_OUT

+cc relevant folks

Hi James,

On Wed, Oct 02, 2024 at 02:23:32PM +0100, James Clark wrote:
> Hi,
> 
> I noticed this when running the Perf tests so I'm reporting it here (I don't
> actually need kcore FWIW). I tested from 6.1 to 6.11 with the same results:

Yeah, this is (somewhat) intended behavior. By reading kcore you wind up
reading from memory that isn't in a visible state for the host (e.g. hyp
text).

Protected mode is very much a WIP, and is expected to be rough around the
edges like this. Eventually the hypervisor will inject an abort into the
host for disallowed memory accesses instead of tripping a BUG_ON(). We
don't have that upstream right now.

>   # On the host:
>   $ cat /proc/cmdline
> 
>   BOOT_IMAGE=/boot/vmlinuz-6.11.0-rc6+
> root=UUID=090f43e8-dbb2-48e4-a9e2-efd6291fb21f ro earlycon=pl011,0x2A400000
> kpti=off vfio-pci.ids=10ee:9038 kvm-arm.mode=protected
> 
>   $ sudo dd if=/proc/kcore of=/dev/null
> 
>  # Wait a few seconds
> 
>    kvm [732]: nVHE hyp BUG at: arch/arm64/kvm/hyp/nvhe/mem_protect.c:540!
>    kvm [732]: nVHE call trace:
>    kvm [732]:  [<ffff8000090c2654>] __kvm_nvhe_$x.158+0x44/0x80
>    kvm [732]:  [<ffff8000090c88d4>] __kvm_nvhe_$x.90+0x34/0x124
>    kvm [732]:  [<ffff8000090c4844>] __kvm_nvhe_$x.1+0x4c/0x84
>    kvm [732]:  [<ffff8000090c3864>] __kvm_nvhe_$x.0+0x64/0x64
>    kvm [732]: ---[ end nVHE call trace ]---
>    kvm [732]: Hyp Offset: 0xfffeffff97e00000
>    Kernel panic - not syncing: HYP panic:
>    PS:a04003c9 PC:00008000712c89c8 ESR:00000000f2000800
>    FAR:ffff0000712bf000 HPFAR:0000000000f12bf0 PAR:0000000000000800
>    VCPU:0000000000000000
>    CPU: 1 PID: 732 Comm: dd Not tainted 6.4.0+ #54
>    Call trace:
>     dump_backtrace+0x100/0x158
>     show_stack+0x24/0x40
>     dump_stack_lvl+0x60/0x80
>     dump_stack+0x18/0x28
>     panic+0x148/0x360
>     nvhe_hyp_panic_handler+0x110/0x1a0
>     _copy_to_iter+0xd8/0x520
>     read_kcore_iter+0x54c/0x768
>     proc_reg_read_iter+0xa0/0x118
>     vfs_read+0x1b4/0x290
>     ksys_read+0x80/0xf8
>     __arm64_sys_read+0x28/0x40
>     invoke_syscall+0x4c/0x120
>     el0_svc_common+0xd0/0x120
>     do_el0_svc+0x3c/0xb8
>     el0_svc+0x44/0xb0
>     el0t_64_sync_handler+0x84/0xf0
>     el0t_64_sync+0x190/0x198
>    SMP: stopping secondary CPUs
>    Kernel Offset: disabled
>    CPU features: 0x000000,4040180c,6400720b
>    Memory Limit: none
>    pstore: backend (efi_pstore) writing error (-5)
>    ---[ end Kernel panic - not syncing: HYP panic:
>    PS:a04003c9 PC:00008000712c89c8 ESR:00000000f2000800
>    FAR:ffff0000712bf000 HPFAR:0000000000f12bf0 PAR:0000000000000800
>    VCPU:0000000000000000 ]---
> 
> 
> 

-- 
Thanks,
Oliver
