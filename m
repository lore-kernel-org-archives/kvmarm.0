Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBE01DFFD;
	Thu, 30 Jul 2026 07:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785398329; cv=none; b=nrWPWY53jJDBw/l9d4Vv9trrsYF3MNP+afzWTADUW+lFZHgO6sorWo5MbTVg7JaZUEe29Kej1F29JSaDPqMejokrkfaXYwj9FgSFzYFRqhe/tCHu2kbw+SuQMreI1XFgUPYLnk8qOpz5tWi2CkFAyMFNPWAPRnNiKfZfLvcaG8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785398329; c=relaxed/simple;
	bh=pPjUGrqSKKnR0ntNbXoVvZiEmbEIZKF2CaKkWWCpgMs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GBnL+/v/DfOTwjkTwZfKQe0pQSE57mEYbNtYrkamf9HdkD8JrtxA8o1+RkwUN3CvEduzD1gTlY/R04c0u11r5q7tzvzfpOrAFapyZDzfiSNBSrvHTcvswz0RzTb2kcCbTT+04zSdMiV36UTvG37hyUn8UWC+E/EUsEKEToSxfI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mV+TwV28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mV+TwV28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF311F000E9;
	Thu, 30 Jul 2026 07:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785398328;
	bh=Y8U1eJiaACO+CExTkMPE6RD//AHCyIx6QkeOunFBeAQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mV+TwV28NWpFXco2WUu8xv0SgtwsxncCBEGiIpX+/3z//38nwnF8GuwHZcJugV1Hi
	 +wCaCHibFOmgJvXWp4tMFq0IfMoZJo1u2WUt56i/u3bLhtkMHuh22HuE0vrEblpvPm
	 /z3Zu9CS/RwmDIYP2u3HaPHjJAofHlrdO/2QhDnR5iD1hfTTt7Djq1y9gt5f1+ctzy
	 uNIgjV9thnIsQIhSRRyFLUdccRl1JQJqqCuPaExzgMyPGAvrMi3GDX0gN5vLh2zadx
	 +uNHJ14hpUUBP+O+NwnUAxDy418oj5jnbXmHdXP11JAysN8PHN/V4DTknGpvu4UEvO
	 tVeiKCcx6Bhgg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 21/29] KVM: arm64: Add NVHCR_EL2 handling to the
 sysreg array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260730071022.296811-22-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
 <20260730071022.296811-22-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 07:58:47 +0000
Message-Id: <20260730075848.0EF311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Inverted context logic for NVHCR_EL2 in locate_register() incorrec=
tly maps the register to an unmanaged hardware CPU register.
- [High] Missing explicit Context Synchronization Event (ISB) after writing=
 to the architectural control-plane system register NVHCR_EL2.
--

--- Patch [21]: [PATCH v4 21/29] KVM: arm64: Add NVHCR_EL2 handling to the =
sysreg array ---
commit aea2461c165a3a2d9e5915b4946e1ec44773006d
Author: Marc Zyngier <maz@kernel.org>
Subject: KVM: arm64: Add NVHCR_EL2 handling to the sysreg array

This commit exposes NVHCR_EL2 to userspace and treats direct access as UNDE=
F=20
to catch exception routing bugs. It also updates generic accessors to handle
the register's location.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9439c5b2b1fe8..0aeb2e736fde3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -221,6 +221,20 @@ static void locate_register(const struct kvm_vcpu *v=
cpu, enum vcpu_sysreg reg,
>  		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
>  			loc->loc =3D SR_LOC_SPECIAL;
>  		break;
> +	case NVHCR_EL2:
> +		/*
> +		 * Yes, NVHCR_EL2 maps to itself when loaded in nested
> +		 * context. If you feel like the architecture is double
> +		 * backing on itself upside down, you're not alone.
> +		 */
> +		WARN_ON_ONCE(!kvm_has_nv3(vcpu->kvm));
> +		if (is_hyp_ctxt(vcpu)) {
> +			loc->loc =3D SR_LOC_MEMORY;
> +		} else {
> +			loc->loc =3D SR_LOC_LOADED | SR_LOC_MAPPED;
> +			loc->map_reg =3D NVHCR_EL2;
> +		}
> +		break;

[Severity: High]
Does this invert the context logic for NVHCR_EL2?=20

If !is_hyp_ctxt(vcpu) (meaning the vCPU is running a nested guest), this ma=
ps=20
the register to an unmanaged hardware CPU register rather than the guest's=
=20
VNCR memory array.=20

Since KVM doesn't save or restore the physical SYS_NVHCR_EL2 register on=20
context switches, could this cause KVM_SET_ONE_REG to lose the guest's=20
NVHCR_EL2 state, and KVM_GET_ONE_REG to leak uninitialized host physical=20
register state?

[ ... ]

> @@ -298,6 +313,7 @@ static void write_sr_to_cpu(enum vcpu_sysreg reg, u64=
 val)
>  	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
>  	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
>  	case DBGVCR32_EL2:	write_sysreg_s(val, SYS_DBGVCR32_EL2);	break;
> +	case NVHCR_EL2:		write_sysreg_s(val, SYS_NVHCR_EL2);	break;

[Severity: High]
Is an explicit context synchronization event (isb) required here after writ=
ing=20
to NVHCR_EL2?=20

The write_sysreg_s macro modifies a control-plane system register but is=20
followed immediately by a branch (break), skipping the architectural=20
requirement of having an isb as the very next instruction.=20

Could this leave the CPU pipeline operating in an architecturally undefined=
=20
state when userspace calls KVM_SET_ONE_REG?

>  	default:		WARN_ON_ONCE(1);
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730071022.2968=
11-1-maz@kernel.org?part=3D21
