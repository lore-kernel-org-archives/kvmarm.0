Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2902C35C1B7
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 16:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625618; cv=none; b=QU4ydqOKq5SHE74JmsMXucHnRYyJlgZspODv0KHZkil49PuUrjSMaqWrYypn0C3CaiVpIet870s3+Y12VTrTm1Yy8ilnRPngfpF3uQI5DaQ0OyrqsuThWHxNQudUrW+2X4L4lgp9/GTd9ccnju1JCLn8nfkUwO7/bc5Sk5YLOpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625618; c=relaxed/simple;
	bh=XDlLEqIPYN1K/+QQkWma9H/3gzqZUbA59BBesyA+5Vk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FVo+WF5/fsHVhkDvWQmYQAqXe7Te8uMyYdqa5AiW90P6VNhW/8ZyyNhnHNpzRRJC8uA07yENngFMr1c4ScUyak8MIH48Nx+5tzKkuGm6L8SHpjHlB304N91aSYwasJBNZ4Rs8yLudG4ygy/vlg9rK279UdjOuVfUYomldFF0lmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLyw38X8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLyw38X8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62C81F000E9;
	Tue, 16 Jun 2026 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625617;
	bh=JbbexXZLd0A4nb2ax632uh9dH45j/WaY7seQPR3aXFM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JLyw38X8n9fuFWKw5ARrQKzZbwxPITYkh7TgdvIvSB2gtpwZCS/C4c998Tq+F+y0q
	 UJIczAa4x1YNzE1SCT88KWV93Zzt3lDWbi5i6c7TGsTkuJW4sb2fIlZrPMN8UtWoyi
	 +2VVQbdZdWabSa0Rnry1vbjyinsXdkQ8zNrOz886TTLHsMHQoyC6ExFS57Qap6wtRm
	 BDEpeczvl2b/b3RU3L75EQIntf3/B6R2i/Qj67Rvy02ZInt0hJt8B4ZNF8QFz8xEfJ
	 A7+zC9vTkhsXzKAaNKP+p8IkQpwi/+cMt5UGpD3ctfH1yW6/ynWwipS/OrKGh5DTsh
	 5jokI7TZUt0nw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/7] KVM: arm64: Enforce strict SBZ checks in the
 FF-A proxy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260616154149.2763214-2-sebastianene@google.com>
References: <20260616154149.2763214-2-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 16:00:16 +0000
Message-Id: <20260616160016.C62C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] `ffa_check_unused_args_sbz` incorrectly checks preserved registers=
 and the upper 32 bits of parameter registers for SMC32 calls, causing spur=
ious rejections.
- [Low] Missing strict SBZ validation for `FFA_FEATURES`.

Pre-existing issues:
- [Critical] Parser differential between KVM (EL2) and SPMD (EL3) regarding=
 the `ep_mem_offset` field allows the host to bypass pKVM memory isolation.
- [High] Uninitialized EL2 stack memory is leaked to the EL1 host in `do_ff=
a_version`.
--

commit 5972f4c57539fa5e01e7e9c49f62766ed5e85d37
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Enforce strict SBZ checks in the FF-A proxy

Introduce a helper method ffa_check_unused_args_sbz to enforce strict
arguments checking when the hypervisor acts as a relayer between the
host and Trustzone.

> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178a..c64c704f22f8d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -71,6 +71,18 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
> =20
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int =
first_reg)
> +{
> +	int reg;
> +
> +	for (reg =3D first_reg; reg <=3D 17; reg++) {
> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +

[Severity: High]
Does this loop incorrectly check preserved registers and the upper 32 bits
of parameter registers for SMC32 calls?

According to the SMCCC ABI, SMC32 calls pass parameters in W0-W7, while
X8-X17 are caller-saved preserved registers. The caller does not need to
zero X8-X17, and the upper 32 bits of X0-X7 are architecturally unknown.
Checking these bits using cpu_reg(), which reads the full 64-bit value,
could cause KVM to spuriously reject perfectly valid, spec-compliant SMC32
calls (such as FFA_VERSION and FFA_PARTITION_INFO_GET) if the host or guest
has application data in those registers.

[Severity: Low]
Is the ffa_check_unused_args_sbz() check missing from do_ffa_features()?

According to the FF-A specification (v1.1, section 13.2), parameters W2-W7
for FFA_FEATURES are MBZ. Since this patch introduces strict validation for
other handlers, should do_ffa_features() also enforce this check to prevent
the host from sending garbage in the unused registers?

[ ... ]

> @@ -482,6 +509,11 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	u32 offset, nr_ranges, checked_offset;
>  	int ret =3D 0;
> =20
> +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> +		ret =3D FFA_RET_INVALID_PARAMETERS;
> +		goto out;
> +	}
> +

[Severity: Critical]
This is a pre-existing issue, but is there a parser differential between
KVM (EL2) and SPMD (EL3) regarding the ep_mem_offset field?

In __do_ffa_mem_xfer(), KVM uses ffa_mem_desc_offset() to locate the
endpoint memory access descriptor:

ep_mem_access =3D (void *)buf + ffa_mem_desc_offset(buf, 0, hyp_ffa_version=
);

For FF-A v1.1, this helper statically returns sizeof(struct ffa_mem_region)
and ignores the host-provided buf->ep_mem_offset field. However, SPMD (EL3)
parses the unmodified buffer forwarded by KVM and honors buf->ep_mem_offset.

Could a malicious host set buf->ep_mem_offset to a large value, place a
benign descriptor at the static offset KVM checks, and a malicious
descriptor at the SPMD offset, thereby bypassing KVM's isolation?

[ ... ]

> @@ -769,6 +806,11 @@ static void do_ffa_version(struct arm_smccc_1_2_regs=
 *res,
>  {
>  	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
> =20
> +	if (ffa_check_unused_args_sbz(ctxt, 2)) {
> +		res->a0 =3D FFA_RET_NOT_SUPPORTED;
> +		return;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but does returning directly here
leak uninitialized EL2 stack memory to the EL1 host?

In kvm_host_ffa_handler(), struct arm_smccc_1_2_regs res is declared on the
stack without zero-initialization. If this SBZ check fails, the handler
assigns res->a0 and returns immediately without using ffa_to_smccc_res()
(which zeroes the rest of the structure).

Since kvm_host_ffa_handler() then copies all 18 registers into the host's
CPU context:

cpu_reg(ctxt, 17) =3D res->a17;

does this allow the host to actively trigger a leak of sensitive EL2 stack
memory by supplying non-zero unused arguments?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616154149.2763=
214-1-sebastianene@google.com?part=3D1
