Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65D15B21A;
	Wed, 19 Aug 2026 22:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787179815; cv=none; b=JLFtxfLaYvJKRrf0f/u7QyMRNJX5d4uc8zmYwhon5ztn+YoBm+p9qYHkWnwdUrtqbJeZJees34QpUIQ9aIzDschcVHCPX17VxbSiFRvdt2VbhQ2wZO988+zF6fily8A2aQC/7K/x6d6KtS1gJTqVHQrOMU++dHPTMYPpsXORtE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787179815; c=relaxed/simple;
	bh=f6iQjopPewZQLt+lVKPxt4vH49z6HR2eHi9vomFhaws=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J1QF6AlUVuRYjoG/6+ceF5k8m5fEj8v7GckVc/PwO2FbigQabRawWkNXcENJgqbRFBoIq/zY15EHf+JVwNUrrCmLD00NktnWF2RkWsY6yvnWbg2LPA/AHZ13wIws8WjD1jCaZ1lRRUso3MQhzncqqCYDp8SM5OcEJyGmNDZRFLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMBWbXvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMBWbXvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029011F000E9;
	Wed, 19 Aug 2026 22:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787179814;
	bh=nTme3z134HdDjeEBbrEUXvmW2gMzPjhMklo9ErDVQzI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GMBWbXvZdkJcMDa8jpdmfeRLDOLjzLbXb9xcCS8iF7CamKHSqpZ4nB3Sjul+d4sVc
	 /fEfvckohLE5A8KPj4ShIyWWYv2gu+ekSpX8xZCHazkIwUYsrbLRp55rIF0ziHbJch
	 a8cuYb0T+kZiskc8pLuwphwpJ8luo56nlZ1yw2fE/mzL+iB3ytRb+Ht1e+9rfAlMfC
	 FhuKIj4v5DA745zRRYyh67nDxO3WypO4Fp+PNxZW4InoOctiNSq5gB1cObxBEtKlWX
	 oyNo/oYcVOKptBIqsG8P+jqsKUDmW5aZvGkpgY7YsJwta73VqIZAcJePIjPUZ5umOG
	 eQMXY6hhHwnig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/5] KVM: arm64: selftests: Pass guest code to
 vm_gic_create_with_vcpus()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260819224229.82948-5-kmehltretter@gmail.com>
References: <20260819224229.82948-1-kmehltretter@gmail.com>
 <20260819224229.82948-5-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 22:50:13 +0000
Message-Id: <20260819225014.029011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The `guest_fn` parameter restricts the guest entry point type to `v=
oid (*)(void)`, deviating from the selftests standard `void *`.
--

--- Patch [4]: [PATCH v2 4/5] KVM: arm64: selftests: Pass guest code to vm_=
gic_create_with_vcpus() ---
commit 6c09a6b348b8fbe5cd4e0cef1198db5d49812401
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: selftests: Pass guest code to vm_gic_create_with_vcpus()

This commit adds a guest entry point parameter to vm_gic_create_with_vcpus()
and updates the existing call sites to pass guest_code. This allows tests
with different guest code to reuse the common VM and VGIC initialization
sequence.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_init.c b/tools/testin=
g/selftests/kvm/arm64/vgic_init.c
> index 47e34b43afb29..91484fd4f7869 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_init.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_init.c
> @@ -73,12 +73,13 @@ static int run_vcpu(struct kvm_vcpu *vcpu)
> =20
>  static struct vm_gic vm_gic_create_with_vcpus(u32 gic_dev_type,
>  					      u32 nr_vcpus,
> +					      void (*guest_fn)(void),

[Severity: Low]
Does this unnecessarily restrict the guest entry point type?

The underlying kvm selftests API, such as vm_create_with_vcpus(), typically
uses a generic void pointer for the guest code. If a future test tries to
reuse this setup function and pass a parameterized guest code function, the
compiler might emit an incompatible pointer type warning.

Would it be better to change the type of guest_fn to void * to maintain API
consistency with the rest of the selftests framework?

>  					      struct kvm_vcpu *vcpus[])
>  {
>  	struct vm_gic v;
> =20
>  	v.gic_dev_type =3D gic_dev_type;
> -	v.vm =3D vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
> +	v.vm =3D vm_create_with_vcpus(nr_vcpus, guest_fn, vcpus);
>  	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819224229.8294=
8-1-kmehltretter@gmail.com?part=3D4
