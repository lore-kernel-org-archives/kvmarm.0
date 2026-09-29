Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899183E49C4;
	Tue, 29 Sep 2026 11:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790679640; cv=none; b=Up+0GZBhn5nNpAFIWx6c+MJtCR9B3/uf9LFbTTAlrg9E33sGYAZ7Rt6V4UYnwrOg0k94wJgkZ1Rn1T7G1ElWq4R20jyTLh4KXR5bFpdo6kT+mWPOi42Ic8mxvLD+P3emvqXWZ9wnmepF0l2yVkGvSQi+j1UMvQX4m5djo9ozHbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790679640; c=relaxed/simple;
	bh=lS+0A+DdmauQ+xlTKpMHOI3V3lsXJfd6BmK3X3NPW00=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bwP0hyMTy9DiNT3LPrzcTkdIT/C9XQKgniyF/Mhhmr5LlzGLMOtY6nawnwMMKtqlAKqpKUrVKXlB6JxvBQRqj2kultpp0ScnV4HeBbx3pRK0X3RXzGIPruhjKwfmnC0z4fVyyM50Q0Q9M1ZRl2UkEjvaD3JLflBuMmPFO41qt7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kG4oloR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kG4oloR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FB41F000FF;
	Tue, 29 Sep 2026 11:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790679635;
	bh=7kKZtyyvkJsdy+7BuXlZ0qrabjEcLoNuV3CPN4wtZwQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kG4oloR7vT0HAbyfBPV00EsMVRhR3ZbFxJUQw8uUhGHCi7OB8/zv9AqU4/9xYMVzo
	 UJIcMN+8sz2ZvhoMLh7LqthGCGR7+95IHjMu9sDPGz8w3eZgu1k42ic2JojXVyVhNP
	 +2lK6gILinQDW88MxQzVAo/k5fliyg24c3pqF2RthaKweR1uaoA/dMujEVX2oqglSs
	 sRSnhJQn1655xte1HWGmm6xI6OFXswn091O8ioC4D/jWwDsa6GwPHWZBGueDAKvKh3
	 o/2S0XATcBB7XO3QWE3DY7HQQQyo7CbZZfCSJJSRmLEyDIAI205Pn63qXOjX5+Ihqm
	 FULIXI63d7pWQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/15] KVM: arm64: Reserve dirty ring space for the
 HDBSS buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260929103655.85107-12-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-12-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 11:00:35 +0000
Message-Id: <20260929110035.71FB41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm64: kvm: UAPI breakage for dirty ring size on 64KB page systems
--

commit 38dde0ab2f10c37402c620c7b1328624808205ad
Author: Tian Zheng <zhengtian10@huawei.com>

KVM: arm64: Reserve dirty ring space for the HDBSS buffer

This commit reserves space in the dirty ring for CPU-side dirty buffers by
implementing kvm_cpu_dirty_log_size(). It also pins the HDBSS buffer size to
PAGE_SIZE when the dirty ring is enabled.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 7bf82d65041c8..c1e09ba98d48a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -2841,3 +2841,11 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool =
was_enabled)
> =20
>  	trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>  }
> +
> +int kvm_cpu_dirty_log_size(struct kvm *kvm)
> +{
> +	if (!system_supports_hdbss())
> +		return 0;
> +
> +	return kvm_hdbss_buffer_size(kvm) / sizeof(u64);
> +}

[Severity: High]
Does this calculation break the UAPI for standard dirty ring size requests =
on
64KB page systems?

Since KVM_ARM_HDBSS_DEFAULT_SIZE is tied to PAGE_SIZE, this calculation sca=
les
with the system page size. On a 64KB page system, kvm_hdbss_buffer_size() y=
ields
65536 bytes, returning 8192 reserved entries (65536 / 8).

When a userspace process requests a standard dirty ring size of 65536 bytes
(64KB) via KVM_ENABLE_CAP for KVM_CAP_DIRTY_LOG_RING, it seems the ioctl wi=
ll
now fail:

virt/kvm/kvm_main.c:kvm_vm_ioctl_enable_cap() {
    ...
	if (size < kvm_dirty_ring_get_rsvd_entries(kvm) *
	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
		return -EINVAL;
    ...
}

Because (8192 + 64) * 16 =3D 132096 bytes is greater than the requested 655=
36
bytes, the ioctl rejects previously valid userspace configurations with -EI=
NVAL,
which would cause QEMU and other VMMs to fail to start VMs.

Could this buffer size be decoupled from PAGE_SIZE to avoid the entry infla=
tion
and ABI breakage on 64KB page systems?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929103655.8510=
7-1-zhengtian10@huawei.com?part=3D11
