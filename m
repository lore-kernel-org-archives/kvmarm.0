Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537624825C4;
	Mon,  5 Oct 2026 13:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205712; cv=none; b=HQpXTPDd1usIS3M59oX9aKG1DLf8R5ltPnVkcxoXaM5CL36DZWqjOPEZdbPpCwGwBkLs0KDcZ1o50WYVMu0yH4XH2rT8ryVQwR//0pt6WYJ7X4fzzvChrsXTyM/QEuwXGgekfziS1J89TRENkZRtAGZ4Fcr5bS3m/G1V5RLtFrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205712; c=relaxed/simple;
	bh=lYST04BH3VQZzexEJ/zChuLkdT8K4wYmGOYVKpKfUzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FEPcP3Cf9TzEGlijYy1AtNbTLfRvWZOsSMjz06vYJwo0ibUCSOWZhIh2ca/stqydNPaMKjaL8cPURj7V3Vr9MQKi+Bo3WA22wxcjk/Xl6T5WGZlx1bEzB/1Bk0h07VK/7zJh/Hjqb5Siao69Q2EaK6EhWmAVGlXOxIEVViRD4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JNXmxrcF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JNXmxrcF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4AA62152B;
	Mon,  5 Oct 2026 06:08:25 -0700 (PDT)
Received: from [10.57.13.4] (unknown [10.57.13.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B91B13F86F;
	Mon,  5 Oct 2026 06:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791205708; bh=lYST04BH3VQZzexEJ/zChuLkdT8K4wYmGOYVKpKfUzQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JNXmxrcFr0Mms66c/CAvaOPDeA1md3eCGPJ/w4oAcyi/Pn9zp3tUdv+UHyOc/YWj1
	 teYXPygbOQoWVaWaLoQ0LFf/cvwUKu0ekIwjRX3uR56fE3htJrfxfs420/+bhSIFIO
	 8jmjagWihz8WLuhoUa1U77aslxhmy8iXa/pf+0xU=
Message-ID: <d18fc122-744e-40c7-b10b-cc29c0a88e20@arm.com>
Date: Mon, 5 Oct 2026 15:08:25 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 23/23] KVM: arm64: CCA: Control user register access
 for Realms
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-24-suzuki.poulose@arm.com>
 <20261005093006.928C41F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261005093006.928C41F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/10/2026 10:30, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] kvm: arm64: missing lifecycle checks for Realm configuration registers
> --
> 
> commit c1323429b568607fedbbcbc78dbc0df5d8c3cfd9
> Author: Jean-Philippe Brucker <jpb@kernel.org>
> Subject: KVM: arm64: CCA: Control user register access for Realms
> 
> This commit restricts the host access to register states for a given Realm,
> aligning with RMM restrictions. It exposes certain registers for initial
> Realm parameter configuration, as well as specific core registers at creation
> or during specific exits.
> 
> [Severity: Medium]
> In arch/arm64/kvm/guest.c within validate_realm_set_reg at line 769, the code
> returns true unconditionally for KVM_REG_ARM_ID_AA64DFR0_EL1 and
> KVM_REG_ARM64_SVE_VLS. Does this allow an unprivileged VMM userspace process
> to write to these Realm configuration registers even after the Realm
> Descriptor has already been created? If the VMM calls KVM_SET_ONE_REG after
> finalization, it appears KVM might silently accept the write and update its
> software state, while the RMM ignores it. Could this lead to a silent state
> desynchronization between KVM and the RMM?

The KVM doesn't have any control over the DFR0 after the Realm is 
created and the KVM doesn't get to access the SVE for the Realm.
This is similar to the approach we take for GET_ONE_REG where
there is no guarantee on what the KVM sees.

> 
> [Severity: Medium]
> Similarly, in arch/arm64/kvm/guest.c within kvm_realm_validate_core_reg at
> line 86, the function returns true unconditionally for the PC register. The
> comment above states that the PC can only be set before the realm is
> activated. Without an explicit lifecycle check in this path, can the VMM
> modify the PC via KVM_SET_ONE_REG even after the Realm Execution Context
> has been activated?
> 

Same as above. The state cannot be synced back to the Realm state. So,
this is intentional

Suzuki

