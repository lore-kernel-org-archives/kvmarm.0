Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12B258B6BF;
	Tue,  8 Sep 2026 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886323; cv=none; b=sk3Gw0+g/0BGzSIVy4l9tgbmzI+lfQ1GwTyK8WqEe7x+HAuYtZe9FKKSyeZDjbNOcOnGxZbYn/qMJfoxRCmFhWssbKMYNT3u+bsIHKj5E/TX1mSskAFZPklP7tjU2xSaDpsDBFmw80OkB7omVV2t6/+s/zynPGH+1pl6BWHz2rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886323; c=relaxed/simple;
	bh=2Cc6fvEtbThO+7TwbL7WlAK4aKN3tdX8XO213maLjdE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aJ5TTEuxPz4wXWhCBwDQdmk8Nd+3s/A80ADUkY5AjpE7totSsfo/MttKLNOzAIO7CwRUZjqKM/IdsaliHFCCnXxhsxvdtJfYqvGY5Fg/FaEMM0n9pzlFH3CFF6ZlecYmtztfClTW3/wMWHuBAVioHtaQJTvut2ghJDxxvzs5ejo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXAZKTCo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXAZKTCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348181F00A3A;
	Tue,  8 Sep 2026 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886321;
	bh=cx3hDRLSlAKBcuxYm59AS62+FLW34wleKQYIdaONh5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JXAZKTCoDUPYp4tRK8VpwzeykQrNclVm2S3kvepQqewj3X11TZ9zAwul1uiOsOo9L
	 P9N53LAjMTJ9uf3xhWgEzopNKgD4SrPRvQW85jIkp7BVUATQtP/xyGFDrWn/PTt0bx
	 sYDnI7eXZpk0MHZ/in9WE9n5i8WcWhzT8FSXBtj6sUplQA5S3cqZek1xJeYJE6QFXx
	 jPTDPXbWvP0srUCcuqEIsDuhBknhh+bKdNeKfyh+tsEXiLn+fC/5KPlv20yLoJNaKg
	 2+mcFozkOzN1q67Od+CdI2MTLim8NDbT0IN9t1iU1L94grYb/GICzZveBvNV0oLxVS
	 Jy7gOZokJ77nA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 14/20] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260908162223.1683432-15-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-15-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 16:52:00 +0000
Message-Id: <20260908165201.348181F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Redundant NULL check on the 'kvm' pointer in kvm_vm_ioctl_enable_ca=
p().
--

commit 849adae1adab6cdadc3f93c498689cfc52591e9d
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests

This commit restricts the extensions visible to realm guests to an
allowlist, as RMM v2.0 provides no mechanism for the host to perform
debug operations on the guest.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3dfe0e03fab7a..fbb4d6651ab51 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -148,6 +167,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
>  		return -EINVAL;
> =20
> +	if (kvm && kvm_vm_is_realm(kvm) && !kvm_realm_ext_allowed(cap->cap))

[Severity: Low]
Is the kvm && check strictly necessary in kvm_vm_ioctl_enable_cap()?=20

Since this function is only called as a VM-level ioctl (dispatched from
kvm_vm_ioctl() where the pointer is extracted from the file descriptor's
private data), kvm is structurally guaranteed to be non-NULL in this
context.

While kvm_vm_ioctl_check_extension() handles global /dev/kvm calls with a
NULL kvm pointer, this function does not appear to need the same check.

> +		return -EINVAL;
> +
>  	switch (cap->cap) {
>  	case KVM_CAP_ARM_NISV_TO_USER:
>  		r =3D 0;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908162223.1683=
432-1-suzuki.poulose@arm.com?part=3D14
