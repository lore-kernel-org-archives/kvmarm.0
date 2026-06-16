Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765494657DA
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 15:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625540; cv=none; b=Y/65hKP6mIiOh68wXxSLIM41VB87DwRShlcP031RErpx8SIbDgO76FN+f9wOdep8f/e696OeKBXeskUejHcsoi2wN2k9GC2drA9bThDgeqpJOh/xeGPlj8C5Vzbq/1ve3YHv+wwd+pccf6CvSNO/7tRiJ27KsMlx76pZvbA1ZH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625540; c=relaxed/simple;
	bh=cjCUx94fHJCk6YF8Fo9+N5/IZD123O0+qBMdYMWfmL4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XorqN/0VedE15pcPufJQ7/xlN4aeceFJl1LAPv1In1S5W+feBK2LEVm7W5kcQ1cbzxdXRQBpFzB8WJTgYaGY234BUbyPoTzOcf2EFXs3b+7UFu01+tYt8aw0xsWmhiLIhPceq45BF9sRTx25HaNL27yiL3w7j3OrYtNZ6C0piMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhQNb7gi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhQNb7gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2670B1F000E9;
	Tue, 16 Jun 2026 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625539;
	bh=F/UnawLcJvqnqACK3bfPGlBOqpd+HsffHO2FGcuuf2o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VhQNb7giv2ux7vopxxSKqsKUySL3ceImrlVka9j4VDJjDvlMHZya3rYWenr8PWUhH
	 PViGUgnqTstfQo6K2iserRxk4kKqf+tIss/2y95Qo7uFWa7xmD0PqzuP2Vg1mR54ls
	 0ka6lBID37lVEExCDSPPvyETmqBd6g8mExblFTCx4vxTibXZUZHDkDSH1cuJQYKm5I
	 +e/xrtpClXinlCvDSaXEjJzUKjoygm35uEUGz8Ezppo4XmrVHwymIgjnHmIJOSQeGm
	 rvbrmYajJDHuRh3XKgG6LWBYZryuwlnTYrRBtdJVrpIh6xv3T1Sb2V99tevts8Omn8
	 LBqsnVP+vSXbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP
 calls to Trustzone
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260616154149.2763214-3-sebastianene@google.com>
References: <20260616154149.2763214-3-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 15:58:58 +0000
Message-Id: <20260616155859.2670B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The FFA_NOTIFICATION_BITMAP_CREATE handler fails to enforce SBZ/=
MBZ checks on the upper bits of the w2 register.
--

commit d7fbb4e364c5dfed4241ae740e49c01e3b35077f
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone

This commit allows FF-A notification bitmap messages to be forwarded to
Trustzone from the host kernel driver. It also intends to enforce checking
for SBZ (Should Be Zero) fields.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -909,6 +907,27 @@ static void do_ffa_part_get(struct arm_smccc_1_2_reg=
s *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
> =20
> +static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	DECLARE_REG(u32, vmid, ctxt, 1);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (ffa_check_unused_args_sbz(ctxt, func_id =3D=3D FFA_NOTIFICATION_BIT=
MAP_CREATE ? 3 : 2)) {

[Severity: Medium]
The commit message mentions enforcing checks for SBZ fields. For the
FFA_NOTIFICATION_BITMAP_CREATE call, the w2 register contains the
vcpu_count in bits [15:0], while bits [31:16] are defined as MBZ
(Must Be Zero) by the FF-A specification.

While ffa_check_unused_args_sbz() correctly verifies that fully unused
registers (w3-w17) are zero, does this miss validating the upper 16 bits
of the partially-used w2 register before it is passed to TrustZone?

> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	if (vmid !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +
> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616154149.2763=
214-1-sebastianene@google.com?part=3D2
