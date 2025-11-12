Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589CE3043A2
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762944017; cv=none; b=e2cmdyICc6eBKlE2eB6iuSrt7OMTZTS8XqxOXgfdHxLw6sNct12Lu6H2sLvmJFQdJMQI23BjsSKzH/9xh+27MOgeAuwcAOjW3SQbz+hW27w8ahFGu9BP7d4t33QbHbmRyEqNyd+L6Vfva9HnCdLR1ZbkBvx4oOh/1PtCyJ32wOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762944017; c=relaxed/simple;
	bh=fArjS5d1VGJyoJlpK8/kTVa4co5DDb54sPzWb1uYDc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3Tr07jbBeT4VfOBnW/69XMqC6vPjdtOmhATqpQaRhScfnlV7w8bQLKqIipoBfe24Qbud6FXChrg22W4JNgdnjT9x7DQNsBOrBXufvZ1ye0WTuZw4VxkLn/WunchaMdbKJ630R5y/xhURylI8dOol5gx4CBq5NgZMI1tk5zCotA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAlWKDOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAlWKDOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6A7C4CEF5;
	Wed, 12 Nov 2025 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762944016;
	bh=fArjS5d1VGJyoJlpK8/kTVa4co5DDb54sPzWb1uYDc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jAlWKDOpXUvGtie/QpUH+R5pbt+HZLKyo1ngtEYsp9M7sLAx0VkhBTqkXBZX78u/N
	 FRidhlc2r+Q9D5wm+9z+UosLMufqhdAedmRaXwY1wAyfAft6MkuY9INsucXOimoFxs
	 7Bj9sFmD6QV/1jJcGsn9wZUW6jeHovuREBQZ5MqzN9W0uyeQCMRqvgZMDgDrYFHxeE
	 hCr0tKZOoCRWGVTe+GimUKc//n0iPDFy3QMDjmFjRqGWylh7zeiOQu+wKKraA0piYi
	 D7Z9spKmDIxyDukveDYhUsjIOtWDKffJgqa4WIsB20xtbkjy8GAwqN9Ke/vu4NkF3s
	 FQjeQIEpmtISg==
Date: Wed, 12 Nov 2025 02:40:15 -0800
From: Oliver Upton <oupton@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: VHE: Compute fgt traps before activating them
Message-ID: <aRRkD8tAVcGp5zsY@kernel.org>
References: <20251112102853.47759-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112102853.47759-1-alexandru.elisei@arm.com>

Hi Alex,

On Wed, Nov 12, 2025 at 10:28:53AM +0000, Alexandru Elisei wrote:
> On VHE, the Fine Grain Traps registers are written to hardware in
> kvm_arch_vcpu_load()->..->__activate_traps_hfgxtr(), but the fgt array is
> computed later, in kvm_vcpu_load_fgt(). This can lead to zero being written
> to the FGT registers the first time a VCPU is loaded.

Yikes! This is no good, thank you for spotting it.

> Also, any changes to
> the fgt array will be visible only after the VCPU is scheduled out, and
> then back in, which is not the intended behaviour.
> 
> Fix it by computing the fgt array just before the fgt traps are written
> to hardware.
> 
> Fixes: fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Oliver Upton <oupton@kernel.org>

> ---
> 
> Stumbled upon this when running a Linux guest on FVP with FEAT_S1PIE
> enabled.  Linux touches PIRE0_EL1 very early during boot, in __cpu_setup().
> HFGWTR_EL2 was 0 the first time the VCPU was run, KVM would then trap
> the access to PIR0_EL1 (PIRE0_EL1 is an inverted trap) and trigger the
> BUG_ON(!r->access) from perform_access().
> 
> I hacked __activate_traps_hfgxtr() to print the register value for
> HFGWTR_EL2. Before this patch, during the first vcpu_load(),
> HFGWTR_EL2 is 0, then it has the correct value. After this patch, it
> always has the correct value.
> 
> If I were to venture a shot in the dark, it might be that the name is a bit
> misleading - it's kvm_vpcu_load_fgt(), but it doesn't load anything onto
> hardware, it just computes values. Might be worth renaming to avoid
> similar ordering issues in the future.

Ack, naming isn't quite the best here. The idea was for the name to make
it obvious that it is meant to be used at vcpu_load().

Thanks,
Oliver
