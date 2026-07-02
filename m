Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B4E363C59;
	Thu,  2 Jul 2026 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010591; cv=none; b=f9uvpP2fAiGkAPjQOwdBpR5tSwmRJPlKjfHYyIla8BeKrspRcW5E253aK2w1GZaKObaGUrwsjTnPSJLf7eM3HZYauGdLG0iYxoz/fOMilr2TQf7urIg92seUYS3dnQCeFGAPU39KXIoLtkGeop0HvPkApu6hum2+RzGT11EXx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010591; c=relaxed/simple;
	bh=YWoaX/sB8YWbHDwLpHkrBRN1QZP4ANbsGrzc+q+4sUY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KQRvnNTxU4Fg/WY1JNNL5UvVEJM+sIUAr/tQNh1NtyayhYcCERgMUZ6wIjt0Ws4+npMsGDI8kDSc+/KHtAuYUsoFMhFv7NMJvIj2txHzv1Z1UWy3TowRR0m7yh6NzmscOS/mK3/8K242Z+StOJCQ1JCVP8BYsutCf9k0n/ivxmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVsgNl3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVsgNl3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AAC1F00A3A;
	Thu,  2 Jul 2026 16:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010590;
	bh=TsCXAVKw7nUwn5VnEjsDcVc/4pnplNNrHfHURKoK89c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DVsgNl3lpYaU3DA4q2WX/cZNQMJQatHLc2SIgbHAHRJ4MvqgvODiybL9dwQfI1Um7
	 xzm+mluge0qbzVjRxLxcuHnL1L4Do/s6RaIdo6UJ7v6hPyX2E9qKSekqPuZ4Y8Yz8K
	 z5dv1KRpTthQsWjozxNwz/x8vTEnILcIEVXgLrz7FL94g8uA6AsnNje15qiqwWUT+n
	 MNwPtxajWUpdZew6uJwwx9U/K6U8EeY/OMYhKF8bKIlslYNGOpVBojexE6xNjYH6qR
	 KOTcUKl80SHxHoXuFgXfLRG59LmLhzVU5XJBFb3E/uObGsezBL0+MJHLo2fA7g8tcR
	 fmGgj577FpgcA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 23/28] KVM: arm64: Add NVHCR_EL2 context switching
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260702160248.1377250-24-maz@kernel.org>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-24-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 16:43:09 +0000
Message-Id: <20260702164310.03AAC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Cross-VM Information Leak via unswitched SYS_NVHCR_EL2 physical re=
gister
--

commit ce2ffdc8cef6935283480a976d01a70bb788a885
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add NVHCR_EL2 context switching
   =20
This commit adds context switching for the NVHCR_EL2 register to manage
the HCR_EL2 state of an EL1 guest. The switch is conditional on the guest
using NV3.

> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/=
hyp/include/hyp/sysreg-sr.h
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -172,6 +172,10 @@ static inline void __sysreg_save_el1_state(struct kv=
m_cpu_context *ctxt)
> =20
>  	if (ctxt_has_sctlr2(ctxt))
>  		ctxt_sys_reg(ctxt, SCTLR2_EL1) =3D read_sysreg_el1(SYS_SCTLR2);
> +
> +	/* Retrieve L2's HCR_EL2, and save it for future use */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		ctxt_sys_reg(ctxt, NVHCR_EL2) =3D read_sysreg_s(SYS_NVHCR_EL2);

[Severity: High]
Could this leak information between VMs when the host hardware supports NV3
but the guest doesn't have it enabled?

If the host hardware implements FEAT_NV3 and runs an L2 guest with physical
HCR_EL2.NV=3D1, the hardware will redirect EL1 accesses of HCR_EL2 to the
physical SYS_NVHCR_EL2 register.

Since is_nested_nv3_ctxt() evaluates to false when the guest lacks the
virtual NV3 capability, __sysreg_save_el1_state() skips saving this registe=
r.
Does this allow an untrusted L2 guest to read the SYS_NVHCR_EL2 state left
behind by a previously running VM, bypassing software isolation?

>  }
> =20
[ ... ]
> @@ -285,6 +289,13 @@ static inline void __sysreg_restore_el1_state(struct=
 kvm_cpu_context *ctxt,
> =20
>  	if (ctxt_has_sctlr2(ctxt))
>  		write_sysreg_el1(ctxt_sys_reg(ctxt, SCTLR2_EL1), SYS_SCTLR2);
> +
> +	/*
> +	 * Publish the L2 view of HCR_EL2 to the HW if L1 is using NV3.
> +	 * Otherwise, the data is already in place in the L1's own VNCR.
> +	 */
> +	if (is_nested_nv3_ctxt(ctxt_to_vcpu(ctxt)))
> +		write_sysreg_s(ctxt_sys_reg(ctxt, NVHCR_EL2), SYS_NVHCR_EL2);

[Severity: High]
Similar to the save path above in __sysreg_save_el1_state(), should this
context switch be based on the host's hardware capability rather than the
guest's software configuration?

If the physical register isn't explicitly overwritten in
__sysreg_restore_el1_state() because is_nested_nv3_ctxt() is false, the
L2 guest could potentially read the stale configuration state of a
completely different VM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702160248.1377=
250-1-maz@kernel.org?part=3D23
