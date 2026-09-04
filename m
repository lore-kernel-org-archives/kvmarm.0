Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A473D4E8E05;
	Fri,  4 Sep 2026 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545237; cv=none; b=Fxpr0ayRhEd18yKs0OWKwChQrP+BK2qyUAzC31zdvvvYBWy3eiwr8ES7oRTwx2VsVb5DDxigdX9sGyp+EgE9iBLy8ZIuRxRMwcHQ5DnwXJR3LdXq+StXm5HDrQzg8H0yD80TtUvwjXxCi/vr0Y6mKxo53NJwkS2YmAJGDhndmy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545237; c=relaxed/simple;
	bh=IxHSg/j8Ki9ahRhZ1QDt1Hr+tNfCwmkxXt1918EHDwc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rIReMKMBrQzaeSpT16AQP/uHl/wUBeiepeh2FCa2bFsCi+ia9T8KfD6jPdaymirNCdkzegSF1T/jesnokUELN8u/PXzYy5jnwNzpdd3sG0t+AOxX8zuW6Ibs1FmQTH+Y4K331SvFx8fUt3uZL9cpp5q6yLcfdyXBhxbQs88mM5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vc8uahzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vc8uahzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CD51F00A3E;
	Fri,  4 Sep 2026 18:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788545236;
	bh=6kSxY6CUMEM3rUpzTBliWX0F364RXnjJy6IcmREJPzg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vc8uahzLtn6GTxZ74bpMMJ6o7DwngJHMZT+OVQMsKe/XuCOzoSEr0CUzbCJ/EhBmx
	 bUteT/s1dpqFVCYJwjqyocZEzgmVCZn425+WLNNWkayYHmRcEgDiZVomfD3xIkXTT6
	 B/7LdnffOEfhCNz3NH7PYNyfrHDu/+WDjDkN4TpGtmhwTwm2oM7/ztwEU4KjmV+y1B
	 KjapKpvnObw18FxcXnbZ5f15PF3J7wji56s7EInhu2hAci4pSoyWc20kErFT7JgTAs
	 rtljYeD+47u1JA0ySpIgNM02fnz9PlQ8Q5OZUiXabrYp6OeBpSxx0mi17yCoFbUxrD
	 FOazz+4avRDNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] KVM: Move last_steal to common struct kvm_vcpu
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dongli Zhang" <dongli.zhang@oracle.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260904175550.430266-2-dongli.zhang@oracle.com>
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
 <20260904175550.430266-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 18:07:15 +0000
Message-Id: <20260904180715.E5CD51F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Host-userspace reachable WARN_ON can cause a host crash when updat=
ing guest steal time.
--

commit 8f2f1662b1b75cda859eddacb4ef288871960d3d
Author: Dongli Zhang <dongli.zhang@oracle.com>

KVM: Move last_steal to common struct kvm_vcpu

This commit moves the last_steal cache field for the per-vCPU host task's
run_delay from architecture-specific structures into the common struct
kvm_vcpu. It updates x86, arm64, riscv, and loongarch to use this unified
field and introduces the HAVE_KVM_PV_STEAL_TIME config option.

[ ... ]

> diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
> index 60e50296a0085..9a77d3bde7c72 100644
> --- a/arch/riscv/kvm/vcpu_sbi_sta.c
> +++ b/arch/riscv/kvm/vcpu_sbi_sta.c
[ ... ]
> @@ -67,8 +67,8 @@ void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *=
vcpu)
> =20
>  	if (!WARN_ON(get_user(steal_le, steal_ptr))) {
>  		steal =3D le64_to_cpu(steal_le);
> -		vcpu->arch.sta.last_steal =3D READ_ONCE(current->sched_info.run_delay);
> -		steal +=3D vcpu->arch.sta.last_steal - last_steal;
> +		vcpu->last_steal =3D READ_ONCE(current->sched_info.run_delay);
> +		steal +=3D vcpu->last_steal - last_steal;
>  		WARN_ON(put_user(cpu_to_le64(steal), steal_ptr));
>  	}
> =20

[Severity: High]
This is a pre-existing issue, but I noticed these WARN_ON() macros wrapping
get_user() and put_user() accesses to host-userspace memory in=20
kvm_riscv_vcpu_record_steal_time() (as well as the sequence_ptr accesses
just above this block).

Could a malicious host-userspace process trigger these kernel warnings by
unmapping the shared memory area or protecting it with mprotect(PROT_NONE)
before this function runs?

If the virtual memory area is made inaccessible, get_user() or put_user()
will fail with -EFAULT, causing the WARN_ON() to fire. This allows
unprivileged host userspace to trigger a host kernel panic if panic_on_warn
is enabled.

Would it be better to handle these user-memory access checks as normal error
paths without the WARN_ON() wrappers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904175550.4302=
66-1-dongli.zhang@oracle.com?part=3D1
