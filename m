Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC243D380
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 18:23:47 +0000 (UTC)
Date: Thu, 18 May 2023 18:23:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684434225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CnFlALddlgo/f9aI1dtyKN5GyhA2U0e+HVCZ9TESVBk=;
	b=vCIqvVmrK1voIplVWkWbNgJQidyriRakXGLVhXA1HWqS2viQQKFH0asilGn+W6rWM1PT2c
	nm76e2+Io3q3oRfYD45YI+t5yuRcGjAtD5q3PbzBchnrxbYuNg5up8A3ovVv+FxHbKgWQB
	0Omk3KfSytiGnr4DOdyQlmHqtzgwVZI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Locking fixes
Message-ID: <ZGZtLS+WW5iZ6Ge9@linux.dev>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518100914.2837292-1-jean-philippe@linaro.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 18, 2023 at 11:09:14AM +0100, Jean-Philippe Brucker wrote:
> Another fun locking puzzle, between the new config_lock and srcu.
> Patch 1 attempts to fix it, and the other patches fix simpler issues.
> 
> I got these lockdep reports while running KVM QEMU on a TCG QEMU, but it
> can also be triggered by running the vgic_irq kselftest on TCG QEMU.
> Now, with the fix and lockdep enabled, vgic_irq hangs but I believe it's
> an unrelated weirdness: if I introduce a separate lockdep warning for
> some made up locks, then the test passes again. So I'm sending this out
> now for discussion, and will investigate that one later.
> 
> I run the host with:
> 
> qemu-system-aarch64 -M virt,virtualization=true,gic-version=3 -m 2G -smp 8 -cpu max -append 'console=hvc0 root=/dev/vda rw' -kernel Image -nodefaults -chardev stdio,mux=on,id=virtiocon0,signal=off -device virtio-serial-device -device virtconsole,chardev=virtiocon0 -mon chardev=virtiocon0,mode=readline -device virtio-blk-device,drive=hd0 -drive format=raw,if=none,file=virt_root.bin,id=hd0 -nographic
> 
> Jean-Philippe Brucker (4):
>   KVM: arm64: vgic: Fix a circular locking issue
>   KVM: arm64: vgic: Wrap vgic_its_create() with config_lock
>   KVM: arm64: vgic: Fix locking comment
>   KVM: arm64: vgic: Fix a comment

Damn! Thought I had this sorted.

Thanks for taking a crack at this. I've looked it over a couple times,
and overall looks good.

For the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

Once I get some free cycles this afternoon/evening I'll take the patches
for a spin.

-- 
Thanks,
Oliver
