Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8663BED7B
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 10:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782989329; cv=none; b=g5Q5yMBuxi6w8tKo7eP9SNOFboKmVXDX8dxp+PSXti/rWQx9tFIF1YHl80sezISmDpA9vh38jkHFCyLLvhbqU2nwiABaZ0Up/1QB9Yu7mVEOslJDrAUhFXmpxu2SFXu2E0dMGProwE9duuw6nHpMyD2LRdRVvhHohmsM+9PiqeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782989329; c=relaxed/simple;
	bh=11FOirbKHp5I01k7N5quP6/+laMK07HakTvOvUmPKaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GYuiVFd3ddKJ44NClDhVAy/IuxQ0xikLbh0D3xrWu3QpshPIU8L9NUcfsc6iFtMeEKWIA8RsAMvz+Mzn/bo0yABCsGMTMUXvsWm79u7C1cwMNwIeSip21M8FFNQoPv1r8UTbVExF7wyyPpcyX1Uu8I3dUNQHSR3MJSD5T/UOW/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVrvGrZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVrvGrZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F157E1F00A3A;
	Thu,  2 Jul 2026 10:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782989327;
	bh=KUVfm1KgGhQZ13ZFRT6USRYppx7Fnxv3+kUJuGmEgiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GVrvGrZvS7Zohj55rNz2IU/79A+ICrNhrqaskomPdo2O/9q+Q72W3vY+HnJpUWHMC
	 Wd0EdBYewQmy1LLfSiZdYoHNQIpe0aFZH5Le8JbzCSa8lVM8qyOdBoDsC5behRapfx
	 dxIo9o1zWaqZTBIqJGfvlxhW3VMBKQvuhtoRDccnRbGkapbyafI/i30l1EEMpYXlKF
	 Psq7nOBzkHTVw8j8lw9+k/nMl6BNd3cjUhRWnCmH8ya+c9ZkRAiYkYX161ECvKHc/U
	 x8ngCoa0GWK1Xu2KcxIQPEsy3fhiVZ/OF6RnpSLwmWTjkjhVUXWbhbPjMKfX6Wl9cL
	 KiR6eqHqIx7qQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 6/6] KVM: arm64: Zero out the stack initialized data
 in the FFA handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260702103848.1647249-7-sebastianene@google.com>
References: <20260702103848.1647249-1-sebastianene@google.com>
 <20260702103848.1647249-7-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 10:48:46 +0000
Message-Id: <20260702104846.F157E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] EL2 silently accepts a downgrade response from EL3 and incorrectly=
 uses the host's requested version as the negotiated version, leading to ve=
rsion desynchronization.
- [Medium] Host can trigger a reliable EL2 hypervisor panic (Denial of Serv=
ice) by passing a fake handle to FFA_MEM_FRAG_TX alongside an invalid PFN d=
uring rollback.
- [Medium] Optional FF-A 1.1/1.2 interfaces not implemented by pKVM are not=
 masked in `FFA_FEATURES` queries, allowing them to be passed through to EL=
3.
--

commit 04220564e97901b7aa4aa40ada1444ec9b7ccea7
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Zero out the stack initialized data in the FFA handler
   =20
This commit initializes the arm_smccc_1_2_regs structure with zeros in
kvm_host_ffa_handler to prevent leaking hypervisor stack data.

Link: https://lore.kernel.org/all/20260616160016.C62C81F000E9@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 9c96e72e522e5..a327c2bbb6b64 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -880,7 +880,7 @@ static void do_ffa_part_get(struct arm_smccc_1_2_regs=
 *res,
> =20
>  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
>  {
> -	struct arm_smccc_1_2_regs res;
> +	struct arm_smccc_1_2_regs res =3D {0};

While reviewing this code, I noticed a few pre-existing issues in the same
file.

arch/arm64/kvm/hyp/nvhe/ffa.c:do_ffa_version() {
    ...
    hyp_smccc_1_2_smc(&(struct arm_smccc_1_2_regs) {
        .a0 =3D FFA_VERSION,
        .a1 =3D ffa_req_version,
    }, res);
    if ((s32)res->a0 =3D=3D FFA_RET_NOT_SUPPORTED)
        goto unlock;

    hyp_ffa_version =3D ffa_req_version;
    ...
}

[Severity: High]
This is a pre-existing issue, but does EL2 silently accept a downgrade
response from EL3 here and incorrectly use the host's requested version as
the negotiated version?

If EL3 accepts but returns an even lower version in res->a0, EL2 ignores it
and sets hyp_ffa_version =3D ffa_req_version.

Could this version desynchronization between EL2 and EL3 lead to mismatched
memory descriptor parsing and break guest isolation?


arch/arm64/kvm/hyp/nvhe/ffa.c:do_ffa_mem_frag_tx() {
    ...
    ret =3D ffa_host_share_ranges(buf, nr_ranges);
    if (ret) {
        /*
         * We're effectively aborting the transaction, so we need
         * to restore the global state back to what it was prior to
         * transmission of the first fragment.
         */
        ffa_mem_reclaim(res, handle_lo, handle_hi, 0);
        WARN_ON(res->a0 !=3D FFA_SUCCESS);
        goto out_unlock;
    }
    ...
}

[Severity: Medium]
This isn't a bug introduced by this patch, but can the host trigger a
reliable EL2 hypervisor panic here?

If the host provides an invalid memory range, ffa_host_share_ranges() fails.
In the rollback path, if the host also provided an unauthorized or fake
handle_lo or handle_hi, EL3 rejects the reclaim and returns an error.

Does this cause EL2 to hit the WARN_ON(res->a0 !=3D FFA_SUCCESS), which exp=
ands
to a fatal BUG() and causes a denial of service?


arch/arm64/kvm/hyp/nvhe/ffa.c:ffa_call_supported() {
    ...
    /* Optional notification interfaces added in FF-A 1.1 */
    case FFA_NOTIFICATION_BITMAP_CREATE:
    ...
    case FFA_PARTITION_INFO_GET_REGS:
        return false;
    }

    return true;
}

arch/arm64/kvm/hyp/nvhe/ffa.c:do_ffa_features() {
    ...
    switch (id) {
    case FFA_MEM_SHARE:
    ...
        goto out_handled;
    default:
        return false;
    }
    ...
}

[Severity: Medium]
This is a pre-existing issue, but are we missing masking for optional
FF-A 1.1/1.2 interfaces not implemented by pKVM?

ffa_call_supported() omits several optional interfaces such as
FFA_FN64_NOTIFICATION_INFO_GET and FFA_MSG_SEND2, returning true for them.

Then in do_ffa_features(), it returns false for these unhandled queries,
causing kvm_host_ffa_handler() to forward the query to EL3.

Could this incorrectly advertise optional FF-A features to the host that the
hypervisor does not actually implement?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702103848.1647=
249-1-sebastianene@google.com?part=3D6
