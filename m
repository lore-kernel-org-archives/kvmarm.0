Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C6542B746;
	Thu,  6 Aug 2026 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786054138; cv=none; b=D58Oz82ij+jIAHioi3o5IYyUwbIp+zIK0mWTChuwHDGRM6m+BfN0ilOi70sZuNBaXEBQrAJ3QazSjljC2MlCWItUium2x84Yg+3dVX3Pxu75ZV4IrnLMXqb03pjRWlPN9TUtqCqyEwMpeWBnrvVz5TdCPK11qHc+D4ae2/6eS10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786054138; c=relaxed/simple;
	bh=paeeDzpwYwAN44xifcX52Grdu1d5RPlO9Mk52SxZH+Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Jun9llVEXGfxytg9Hh8X4tSiykoGkI47ijD4OBDfasmZ2k/koUtfwOGqkkVLTVJsbg0Cxkyx+BUljha2O+7NeU9XGjxsddd7g+WNaLetHMZdZHgaFwyOMhNwfen+63cSpraWCOb7uWh7B1cyaV8LoWj0Me41AphCy7JWqq41aVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aV8V8bPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aV8V8bPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A3B1F000E9;
	Thu,  6 Aug 2026 22:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786054137;
	bh=Xq+m5yCM5O4Z8ywB4LhvL+t/FOjgDTz++vtRL372EDU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aV8V8bPZ1e4JtreDj/5DU7l/u3jxnKBy5L3QjSewZTykWM2OC7IBkxB/R+TVq+Jdf
	 WJy3t5eaYoZTJGqmWpLekrkEy3sdz3klgL9jzFfBLOpCgFYn0Ah0N9SkZIuVDsWkn0
	 nakiLzclTkXERkIvjAyT8uJ3uIkgYqL33PBpMbZLcRKLJTh/rIFAlY41NCTedYKGhr
	 3k/rQBgWCk4hRlk0sZuhK5I9JJjstJo1EDCq4FwmSoCzDcG6D7N5oZYJozAv2xj8ZP
	 tPO3KnHh6e/LJ6FJb2iUQZ5FoFwHFtIZRsr19Md+0COGKtQBe8bXUSYCnbUCsCGMZt
	 ZC9C4M7LFj4Sg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260806214618.82180-1-seanjc@google.com>
References: <20260806214618.82180-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 22:08:56 +0000
Message-Id: <20260806220856.D7A3B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unhandled KVM_REQ_VM_DEAD across multiple architectures (s390, RIS=
C-V, PowerPC, LoongArch) causes dead VMs to either improperly resume guest =
execution or get stuck in an infinite kernel loop.
--

--- Patch [1]: [PATCH] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's reque=
sts ---
commit c8b0ec7047292dc9b84167da2e2a4d9abf600813
Author: Sean Christopherson <seanjc@google.com>

KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests

This commit modifies KVM_REQ_VM_DEAD checks to use kvm_test_request()
instead of kvm_check_request(), ensuring the flag is never cleared. It
also adds a build-time assertion to guard against clearing it via standard
APIs.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 03bfc92864b6e..cf7fe835c4ad2 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2324,13 +2324,18 @@ static inline bool kvm_test_request(int req, stru=
ct kvm_vcpu *vcpu)
>  	return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
>  }
> =20
> -static inline void kvm_clear_request(int req, struct kvm_vcpu *vcpu)
> +static __always_inline void kvm_clear_request(int req, struct kvm_vcpu *=
vcpu)
>  {
> +	BUILD_BUG_ON(req =3D=3D KVM_REQ_VM_DEAD);
> +
>  	clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
>  }
> =20
> -static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
> +static __always_inline bool kvm_check_request(int req, struct kvm_vcpu *=
vcpu)
>  {
> +	/* Once a VM is dead, it needs to stay dead. */
> +	BUILD_BUG_ON(req =3D=3D KVM_REQ_VM_DEAD);
> +

[Severity: High]
This is a pre-existing issue, but while tightening the KVM_REQ_VM_DEAD API,
should this request be explicitly handled on other architectures?

Currently, s390, RISC-V, PowerPC, and LoongArch do not check for
KVM_REQ_VM_DEAD in their request handling loops. Because the flag is never
handled, kvm_request_pending() remains permanently true when a VM is marked
dead (e.g., via KVM_BUG_ON() in common pfncache or MMIO paths).

Could this cause the vCPU run loops to infinitely spin inside the kernel
without returning to userspace? For example:
- arch/riscv/kvm/vcpu.c:kvm_riscv_check_vcpu_requests()
- arch/powerpc/kvm/powerpc.c:kvm_arch_vcpu_ioctl_run() calling
  kvmppc_core_check_requests()
- arch/loongarch/kvm/vcpu.c:kvm_check_requests() inside kvm_pre_enter_guest=
()

Additionally, for s390:
- arch/s390/kvm/kvm-s390.c:kvm_s390_handle_requests() returns 0 when no
  other requests are handled. Can this cause the dead VM to improperly
  resume guest execution via sie64a() with a broken host state?

>  	if (kvm_test_request(req, vcpu)) {
>  		kvm_clear_request(req, vcpu);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806214618.8218=
0-1-seanjc@google.com?part=3D1
