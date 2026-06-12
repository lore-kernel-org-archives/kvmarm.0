Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D467392823
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 10:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781260822; cv=none; b=ZssL2HhdJfo/RT/+0Wrfcp5wwbMvzNUSz/U/kdA+v6m0HCRpOe87ENh59Y9T5iaSms8/mjXSlPVeffSsKQ7QIOy3f52/t7KfFdrjLtHoUGHkW2y1iM/txstZYh1Q0v4hTV2XybxJYc3/i2dGJYPY2uJxR/ygvUNf2SQXKhrWC2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781260822; c=relaxed/simple;
	bh=GuZusS2c25bbva1AGIc/3njn+DkQSORJtGBSQm9c4VU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N+yhRS56nuSAxztA07upod9yuzHXEE5NA+LTC9suetu/Qw9eKUu7/puvJ7LRtO+dGdt38ni3TxdegI3WJW2r6rAy5fF/BcuelrkL2Ae//qAPR79lweMvQWZXE9y2kPHuPRm4061Wg47cPsQgUKgumEZu45o3KHVS9Rl+kkxB15U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZfAgm/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZfAgm/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4EE1F000E9;
	Fri, 12 Jun 2026 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781260821;
	bh=IXtGE9QAyfCKQrurALapem3i9AOBfk2ZwAoXv1DSYmA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lZfAgm/W4g+ThcLM7CrsXz6PJhIhYZ8YJ0Rp1mUwfaxI/kDNL7c/LcGNiY8VmYwYg
	 DOKj4gfKzHLymkSuy8x82hAf8sYKV8auFubrJ0oNslV7KnfzAf/9ZIFO9Nm0PnZZwI
	 g//V953jd6p2+Or9PebqMBwarm9yV8OKVJyuiMaIE8Ui18PQ9JsbcvXF+aH4U+ep2G
	 yUUrFbVruzGB8fgE9BH/8+hB0/qlzGBYayDt7RIuvYgv4/n7SJ9eNO/rWr94XO8CM/
	 KtCQyKEE6Pp2n1OYsKb5lW4r95ea6az7bc67KfNQ+gpb4O2aD9vUtVeZLhlOvcZPU9
	 vXK7t8hPK/8Uw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Sync SCTLR_EL1 when injecting an exception
 into a pVM
Reply-To: sashiko-reviews@lists.linux.dev
To: tabba@google.com
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260612102347.914994-1-tabba@google.com>
References: <20260612102347.914994-1-tabba@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:40:20 +0000
Message-Id: <20260612104020.DD4EE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] inject_sync64() fails to write the trapped PSTATE into the guest's=
 hardware SPSR_EL1 register, causing the guest to observe a stale SPSR_EL1 =
when it handles the injected exception.
--

commit 0025a59d79e472c72e387019776838f814e85578
Author: tabba@google.com <tabba@google.com>

KVM: arm64: Sync SCTLR_EL1 when injecting an exception into a pVM

This commit updates pKVM exception injection to synchronize SCTLR_EL1
alongside VBAR_EL1 so that the newly injected exception observes the
correct PAN and SSBS bits.

> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe=
/sys_regs.c
> index 8c3fbb413a06d..7608cc4030b88 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -257,10 +257,11 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u6=
4 esr)
>  	*vcpu_cpsr(vcpu) =3D read_sysreg_el2(SYS_SPSR);
> =20
>  	/*
> -	 * Make sure we have the latest update to VBAR_EL1, as pKVM
> -	 * handles traps very early, before sysregs are resync'ed
> +	 * Sync VBAR_EL1 and SCTLR_EL1, both read by enter_exception64(),
> +	 * as pKVM handles traps before sysregs are resync'ed.
>  	 */
>  	__vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
> +	__vcpu_assign_sys_reg(vcpu, SCTLR_EL1, read_sysreg_el1(SYS_SCTLR));
> =20
>  	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
> =20

[Severity: High]
This is a pre-existing issue, but looking at the end of inject_sync64(), it
appears we fail to write the trapped PSTATE into the guest's hardware
SPSR_EL1 register.

Later in inject_sync64(), the code updates the hardware exception registers
for EL1:

	write_sysreg_el1(esr, SYS_ESR);
	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);

While SYS_ESR and SYS_ELR are manually updated for EL1, SYS_SPSR (EL1) is
omitted. Since pKVM returns control directly to the guest without restoring
sys_regs from memory, will the guest's exception handler read a stale
SPSR_EL1 from hardware?

Should the code also sync the memory-backed SPSR_EL1 to the hardware
register here to prevent corrupted exception state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612102347.9149=
94-1-tabba@google.com?part=3D1
