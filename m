Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993CF485939;
	Tue, 15 Sep 2026 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490631; cv=none; b=G+kClC/oi06pnQGzY+HExgtlxJUwQ3QR1y5+hZotiQJZsBfeM7j5sAVyAud+JqPB4cLfpUQF0HWshPAKb20BGW8+2GCul8UU2BX2b7SR34FjVFdrSyFCT/Q0372jgI4zdjCSL5o7eXPlcn5gSI3qo0vHJBiEisnpxthJ32hHwrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490631; c=relaxed/simple;
	bh=ldQeaUKYTLEakev2hYgPCK2QN9M8tQODLMhNfXbPp4M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MPxflFjtdfmvKUZCkrhwAgsh6X+CzIWPTzHgbGIN27DM3mDSalxiWNoz4VMtTYeQix4htBYihwgHubGtqljBL9VujgHnTSyvDGPozMkf4w2W7UYDE1Fvm+qiK+tCQ6s7MdzF9Q1G1mxUabOfpExSGZUl/l2D1+yHMkXxL/ia7Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PW/QLwgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PW/QLwgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49711F000FF;
	Tue, 15 Sep 2026 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789490627;
	bh=TJbmUmxtpj6kfQp8djndKejSCzmy/kUVV0BqJIlBkwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PW/QLwgD3KuOxBggfyiySlwabfGhFo3y7s68iX0r9Dfz5L1LM7HY4wd5nW1+q5qN0
	 LvN2MipAoWAqHU0N2zEcvtO5X4HudfAcg8cG71tLZtA3W0S76eEzprKmvmnM4xOpxe
	 jB8PdIfV1aT/vkA8rXLqUxvGB7vZoZiRNcjfrrPuLyOc4hWJN38itE0Jx6pFVtD7k2
	 Irdcy3RR92bnp/JBVdmWAjHpE4cvDSPteFKMJNoojgkuBvqUgx/HgrtCfI5F6pCucj
	 Og+NKIsryPvga9uqsnm9kc+jKsR/6O5fNgKnsWn5dJMbZg6UQrQ2a/KD/K1hu83X4N
	 LL7YXLu9r/SgQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 20/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260915160141.3543048-21-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
 <20260915160141.3543048-21-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 16:43:46 +0000
Message-Id: <20260915164346.D49711F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: host Denial of Service via WARN_ON_ONCE in kvm_arch_vm_ioctl_=
allowed()
--

commit f9fdb12a2363dfa41ace289596ec2d2bd95cde48
Author: Suzuki K Poulose <suzuki.poulose@arm.com>
KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests

This commit limits the capabilities allowed for Realm VMs and blocks
vm_ioctls backed by unsupported capabilities. It introduces generic
capability and ioctl filtering helpers kvm_arch_vm_ext_allowed() and
kvm_arch_vm_ioctl_allowed() to support both pKVM and Realm guests.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> +static inline bool kvm_arch_vm_ioctl_allowed(struct kvm *kvm, unsigned i=
nt ioctl)
> +{
> +	long ext;
> +	int r;
> +
> +	r =3D kvm_get_cap_for_kvm_ioctl(ioctl, &ext);
> +	if (WARN_ON_ONCE(r < 0))
> +		return false;

[Severity: High]
Could this allow an unprivileged host userspace process to crash the host?

When kvm_arch_vm_ioctl() receives an unrecognized or garbage ioctl,=20
kvm_get_cap_for_kvm_ioctl() returns a negative value. This evaluates to true
and triggers the WARN_ON_ONCE() here. On systems configured with panic_on_w=
arn
(which is common in production and Android environments), this results in a
kernel panic and a complete host denial of service.

[ ... ]
> @@ -2150,7 +2202,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned i=
nt ioctl, unsigned long arg)
>  	void __user *argp =3D (void __user *)arg;
>  	struct kvm_device_attr attr;
> =20
> -	if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, ioctl))
> +	if (!kvm_arch_vm_ioctl_allowed(kvm, ioctl))
>  		return -EINVAL;

[Severity: High]
Does removing the is_protected_kvm_enabled() check expose the WARN_ON_ONCE()
above to all ARM64 KVM deployments?

Previously, the warning in kvm_pkvm_ioctl_allowed() was strictly guarded by=
=20
is_protected_kvm_enabled(). By unconditionally calling=20
kvm_arch_vm_ioctl_allowed() for all VMs, any local user with access to=20
/dev/kvm can open a VM file descriptor and issue an unrecognized ioctl to=20
trigger the warning. This exposes the panic condition to all ARM64 KVM=20
deployments rather than strictly limiting it to pKVM configurations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915160141.3543=
048-1-suzuki.poulose@arm.com?part=3D20
