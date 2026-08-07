Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F1B4746CF;
	Fri,  7 Aug 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115072; cv=none; b=BmrOz8V1lQkKJcIwWDOQV3ClwfV7lhbgLQyEcZm8BF25q3y7wRhZYpqphzKpsn7kcN56Y4MNhugcRUEyAwqRx6iDlEagO7T+QIb1+i3ww3i7pw6Pt/0QPibY72vjoJSW11pQbvxf0In6E3qkDqle3suuZyJdiKExu/eGtZZzSrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115072; c=relaxed/simple;
	bh=XZE9BARKpKFZg2IMmsCIniaMo8/ibzzaSgfT+yUqVII=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WrWCc/SrYSOgjOBBVE4pTVAtxT4aFLpSv7JkS4iM7GMYbKf0jjKUPBzqWWyahEOdPixpkPRWpk5jXxrLIqFenZalk+GuzC8SYCsiMzIqWU30oN1juHC+95afoGMCiSDEzkSwPdvC99uG8FJYSl1kSZjeWLIBFroHutxJAgWSPpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQRpATmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQRpATmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261E51F00A3E;
	Fri,  7 Aug 2026 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786115061;
	bh=z4ICCEIxcyvaGkvmVKOfgQez8GKHPxHtCj9jW0TWkTc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QQRpATmEmFGQRuCqTHeAUh/i6TvcOudlE4Gjrlae9L0jjh7fE7XwnqbhXS4xNJGm1
	 j+bdI9betbOB3IwSyxSPCeJkX6RCAdDjXWf8qshuy2G6vNDdJE1KhatlWmL53xJmcq
	 yWHxt2gpCUMHAl6B8tLpGW3KvoIrlVgaUvRf/ALkZ0mewwB1Ov3aio3m1VnqLs56bI
	 monBWnHVTELydv5CyVK1swX+zfSlThRFSn8qY72/rIStX8ArNFBJnhl1fz+lJlCC1r
	 QtDCyxVTYrku+XUnDRlJY0tF+UT5Lgc+t1Zpj2+EFCAIlAzsOU6NPCKI0lw9gb6oJo
	 vmrVpjM/N9EzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/49] KVM: arm64: selftests: Update vGICv5 selftest
 to set IRS address
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-25-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-25-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 15:04:20 +0000
Message-Id: <20260807150421.261E51F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The selftest unconditionally sets the newly introduced `KVM_VGIC=
_V5_ADDR_TYPE_IRS` device attribute, which will assert and fail on older ke=
rnels that support GICv5 but lack this new UAPI.
--

--- Patch [24]: [PATCH v5 24/49] KVM: arm64: selftests: Update vGICv5 selft=
est to set IRS address ---
commit ea26c5c169753d8ee7936265dd3dd56864a96817
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: selftests: Update vGICv5 selftest to set IRS address

This commit updates the vGICv5 selftest to configure the IRS address
before initializing the VGIC. Setting this address is now mandatory for
running a GICv5 VM, as resources cannot be mapped without it.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c

[ ... ]

> @@ -116,6 +117,11 @@ static void test_vgic_v5_ppis(u32 gic_dev_type)
>  	for (i =3D 0; i < NR_VCPUS; i++)
>  		vcpu_init_descriptor_tables(vcpus[i]);
> =20
> +	/* Set the address of the IRS before initialising the GIC */
> +	attr =3D GICV5_IRS_CONFIG_BASE_GPA;
> +	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> +			    KVM_VGIC_V5_ADDR_TYPE_IRS, &attr);

[Severity: Medium]
Will this cause the selftest to fail when run against older kernels that
support GICv5 but lack the new KVM_VGIC_V5_ADDR_TYPE_IRS attribute?

Because kvm_device_attr_set() asserts on failure, running this test against
an older kernel might abort the test suite entirely rather than gracefully
skipping it.

Should this code use __kvm_has_device_attr() to check for the presence of
KVM_VGIC_V5_ADDR_TYPE_IRS before setting it, or gracefully handle the error
if it is missing?

>  	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
>  			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D24
