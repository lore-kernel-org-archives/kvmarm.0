Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7A647DD44
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789402987; cv=none; b=ZeCEZA4z66c1UGgL+Rkb+hRhxHRRLuvkR1Gsp9GiWwZBSayJL4Kr8cOPrFLK8CfIU+1Eco44UGEg002p+oO8QazdTlM5kpP1QTkdSuFuMhDwjoPQwWbKXT0259soRuysBIEKfa8uLSdTDShitebYp95IROV4ayBPoN9Fx7C2NSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789402987; c=relaxed/simple;
	bh=lsztI7xSTtuNUD0MNXX26uzFQaeUbFImiEJu0Xv7rt4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N4y9ruXUojhqdghtyKgb/1nDxV4kUz3Bt7Ib7SspP+vbo2FFTIzrpbKn/t9EGgAk6+z7p1jJU0rg+aktI0VHxDzir8zTa5qKmMp3W1E678bG+XPKnOBRgZzxriMwAWiFFU/3wpyF0sJREq5u07Nlav+bZArePwgSlda2JbsaHFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NV8vh6en; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NV8vh6en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0054D1F000FF;
	Mon, 14 Sep 2026 16:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789402985;
	bh=LuCt8zWedbt7RsRso3ShQGUEAUJuv+nPMo5OrWMdRqI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NV8vh6enELDRzRrncJkzG+MMumYOjHcSZJ2XpcnQn2wGkhVixFNt9rRnstD2tSJJf
	 ZxdNilhkHce+2rXmKA3ifpDrd9ZejuMtS7G+sjboMojKsyNzy2PZuUvOzQCBLCkXFN
	 ksXqsjM+ioblHFKcjeyzwTfsnJ6jL230t3DKqn17ZKURzfNkq1GYYXFApzq9Ld5d/A
	 MTV49PWKl2xTe030lKSQHYf1VYLcC1IzGJqII1EPaoq4K8h9xct1TNXliXgJXGYKSa
	 cShx4nNz0Q+ERXnfDZUe3fJuQlV+cnXg80ZvKr2mnUnHp7etpZeqv9LYnHczlftFc4
	 iadyf9oL15Xpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/18] KVM: arm64: Advertise the capabilities that
 protected VMs support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260914113338.159227-18-fuad.tabba@linux.dev>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-18-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 16:23:04 +0000
Message-Id: <20260914162305.0054D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Software SError injection via KVM_SET_VCPU_EVENTS silently fails f=
or protected VMs and permanently leaves the host vCPU in a degraded state.
--

commit 3a73d995c015585fa4c9bb7392c4fb3d6d828c9c
Author: Fuad Tabba <fuad.tabba@linux.dev>
KVM: arm64: Advertise the capabilities that protected VMs support

This patch updates kvm_pkvm_ext_allowed() to explicitly allow a list of
capabilities that are expected to work for a protected guest, including
various VCPU event and IRQ line capabilities.

> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/k=
vm_pkvm.h
> index fbea052fa3e16..a165af0d75689 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h
> @@ -42,6 +42,15 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kv=
m, long ext)
>  	case KVM_CAP_ARM_VM_IPA_SIZE:
>  	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>  	case KVM_CAP_ARM_PTRAUTH_GENERIC:
> +	case KVM_CAP_ONE_REG:
> +	case KVM_CAP_MP_STATE:
> +	case KVM_CAP_VCPU_EVENTS:
> +	case KVM_CAP_VCPU_ATTRIBUTES:
> +	case KVM_CAP_IMMEDIATE_EXIT:
> +	case KVM_CAP_IOEVENTFD:
> +	case KVM_CAP_IRQFD_RESAMPLE:
> +	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
> +	case KVM_CAP_ARM_INJECT_SERROR_ESR:
>  		return true;

[Severity: High]
This is a pre-existing issue, but advertising these capabilities formally
exposes a bug where software SError injection is broken for protected VMs a=
nd
leaves the host vCPU in a permanently degraded state.

If userspace sets an SError pending via KVM_SET_VCPU_EVENTS,
kvm_inject_serror_esr() in arch/arm64/kvm/inject_fault.c attempts
injection based on a stale host pstate. It sets PENDING_EXCEPTION
and writes to the host's ESR_EL1.

For a protected VM, this is mishandled at EL2. If the VM traps on an MMIO
access, handle_pvm_entry_dabt() in arch/arm64/kvm/hyp/nvhe/hyp-main.c sees
the PENDING_EXCEPTION flag left by the software injection and incorrectly
injects a Synchronous External Abort (DABT) instead.

Furthermore, EL2 does not clear PENDING_EXCEPTION on the host vcpu. When
the host vCPU returns to userspace, kvm_arch_vcpu_ioctl_run() in
arch/arm64/kvm/arm.c sees the uncleared flag. Because pkvm_adjust_pc_get()
returns NULL for protected VMs, __kvm_adjust_pc() returns early without
clearing the flag, triggering an unnecessary hypercall loop on every return
to userspace.

Does it make sense to delay advertising KVM_CAP_VCPU_EVENTS and
KVM_CAP_ARM_INJECT_SERROR_ESR for protected VMs until the software SError
injection path is fixed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914113338.1592=
27-1-fuad.tabba@linux.dev?part=3D17
