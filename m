Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC2647D440
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 12:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328204; cv=none; b=SgkfcNyqIi4szgV9AAZdENcKzvzU/Dt7zGEjjBUZJxr9fLOr5VW5e3yZCOahnq0x2y2b/cP2JBzB0cA2W5inT3PcbCe5VeF4+M8h+AC2qdq9SufVRYx/ZS18ljITGbe0tqKxcXFbBtzwv/uC+ryQ98u4mToX3IQw9N1wxzGwOmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328204; c=relaxed/simple;
	bh=6h+vpDkqukyinOI1Pe6FiKAE0NB7q9hxe59U8iylY5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iEEyz9lkywcSin6KKtLtuk8pcw1KdRvAMhwX9JgPg2Ywn8kzsq1A9V0a7NeVO4Ab2KqL+0V9TjgBT0wUu5ateZV0enFRs6ThX9NgolbRlYpph5XiCSXvi56h60slaAVxlsL4qbaYKyR6uVg7wVURd5SA81dGC7wPK1D5OQvlwHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcyjzLdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcyjzLdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28501F000E9;
	Wed, 29 Jul 2026 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328194;
	bh=2ljHMH4ALLfROFPvYxZYne/mXaypQvO2rxY0vVcqfyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bcyjzLdF74c4TYF14gPGpRuSxfs1g/xo8YKN8JW2AmWSef+ESgvHlCg3P4t5F5Gg9
	 LwMlBe9hIU0TrAglwWaZedAIQxvWlkJM+Kh1s6BlsYqViGBlzygK7oHhaWrLQsRKYT
	 nBvtYuVc6knAQ6NtmHgqv8xvBf+ObOvLtsPuWrdU2l3pc4EX5mO7UvZ2VUhiRBDgyA
	 /WXUA0gwmJJ/9C2TMt4zkImZgkQ4w5Gi6Dcd1Lk3z8dIPh5WjkAf7WrmmWNNPfYH8h
	 8Q9/eXtZjKXnLr6fZ+6kyxHl8XX+uZXBAo1lX/bWdpeU1HEHo2Zx7hyHIwM4qkYMZ4
	 0hYFcGq/Ui4nQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP
 calls to Trustzone
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260729121306.1519473-3-sebastianene@google.com>
References: <20260729121306.1519473-2-sebastianene@google.com>
 <20260729121306.1519473-3-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:29:54 +0000
Message-Id: <20260729122954.A28501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing validation of reserved (MBZ) arguments before forwarding=
 FFA_NOTIFICATION_BITMAP_CREATE and FFA_NOTIFICATION_BITMAP_DESTROY to EL3.
--

--- Patch [1]: [PATCH v8 1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP c=
alls to Trustzone ---
commit 7c773174b9942d3484859ba47f60655d48005460
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone

This commit allows FF-A notification bitmap messages to be forwarded to
Trustzone from the host kernel driver. It implements a new handler that
enforces the host VMID check before forwarding the call.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178a..ecc13b795f2c3 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c

[ ... ]

> @@ -862,6 +860,21 @@ static void do_ffa_part_get(struct arm_smccc_1_2_reg=
s *res,
>  	hyp_spin_unlock(&host_buffers.lock);
>  }
> =20
> +static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> +				struct kvm_cpu_context *ctxt)
> +{
> +	DECLARE_REG(u32, vmid, ctxt, 1);
> +	struct arm_smccc_1_2_regs *args;
> +
> +	if (vmid !=3D HOST_FFA_ID) {
> +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> +		return;
> +	}
> +

[Severity: Medium]
Does this missing SBZ check allow the host to pass arbitrary data in reserv=
ed
registers to EL3?

The FF-A specification requires unused arguments in these hypercalls to be
zero (MBZ). By not checking them here, EL2 forwards the raw host register
context (such as w3-w17) directly to EL3.

Other FF-A handlers in this file enforce this using
ffa_check_unused_args_sbz().

Could we add a call to ffa_check_unused_args_sbz() before forwarding the
call, to ensure we don't unnecessarily expand the attack surface of the
SPMD/SPMC in TrustZone?

> +	args =3D (void *)&ctxt->regs.regs[0];
> +	hyp_smccc_1_2_smc(args, res);
> +}
> +
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729121306.1519=
473-2-sebastianene@google.com?part=3D1
