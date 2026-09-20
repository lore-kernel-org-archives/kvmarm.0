Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B6147CA78;
	Sun, 20 Sep 2026 21:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789940663; cv=none; b=Y9UqPBSJcCZCh4tZ6U9k207lMS20aLDe6biFbUVK8Wjq9tYQtXDKxAbOxWwFyHVj98ZTTH3DAGNkjVIcNjv7kf0ZN8gw7iooUl8x6182IV+LoqvEo8pV4OE3DCVpxzhtpNjpKJdSDo1twuPzMpqY1O9yrut5md6CVLgCW1UZYb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789940663; c=relaxed/simple;
	bh=qhT5C6zKySKu1rSsPNT8ibOTVYUw2vcAXIPCmejvnLg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oImIWCgDcZKOaXgvwAgX5ga5TLjRuN4RXYFlCHsqEylW3uF92hAz2Fe4liUZ99jdzs93GG2wBXbfRzIrYuocGpksFVU/GhZIj6ePip9RUQ2TilBQD/lKt2BOD1eaKGDp1xkeCixbHspQFcxVHjI/TZOa4KVlTuOaP/ypF8YoRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J1sH415G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1sH415G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84B81F000FF;
	Sun, 20 Sep 2026 21:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789940662;
	bh=eHhSSxLGVoPebUWjHE8p0EIJe3Z1HUGjjOLRQNBoKb0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J1sH415Ghlc7B+j+Xq2hED7VZvkU3taWbs5O5LmOqLHMrrFsbCxLzbA9YV5wLnRgf
	 uYpyC1ZZTJdT5E4hrxMC7TAJVLre0kgveXOiNVKNkh7QBl1ybmGeY0IJEtrtaORHMl
	 2XlgDQsmtB0NKa8+3xcgMNwhkL8aZxVzp1eJr8teTX4Af1HnFx8xKf9siqzNee0WvB
	 20BHhcp1ffoyeXUyyLUlm9w1mmqR/uldJOtPR9ITmXW5/MTTw46Z9HVglRUX/XsFTu
	 Yx0XD++NDRjRko9htKr9DnfQOj1NA/djnkKrOt6VGygtZHeQ3LFkA5N580DI9zP5zy
	 gUs7baWdo/OYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 02/20] KVM: arm64: Disable Steal time accounting for
 protected guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260920212845.707-3-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
 <20260920212845.707-3-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 21:44:21 +0000
Message-Id: <20260920214421.D84B81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] arm64: kvm: contradictory SMCCC advertisement for PV_TIME on pro=
tected VMs
--

commit db2c057e4ceefd58162587d4fd417788a4db3dbc
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

    KVM: arm64: Disable Steal time accounting for protected guests
   =20
    PVTIME support is advertised by KVM_CAP_STEAL_TIME, which doesn't take =
into
    account the kvm instance. Even with that, a VMM could skip the CAP check
    and proceed to configure the PVTIME as we don't do further check on the
    DEVICE_CTRL. Tighten this up by passing the KVM instance around wherever
    possible and catch things early.

> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index 4ceabaa4c30bd..579e0a4720ad2 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -67,9 +67,9 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
>  	return base;
>  }
> =20
> -bool kvm_arm_pvtime_supported(void)
> +bool kvm_arm_pvtime_supported(struct kvm *kvm)
>  {
> -	return !!sched_info_on();
> +	return !!sched_info_on() && (!kvm || !kvm_vm_is_protected(kvm));
>  }

[Severity: Medium]
Does this create a contradictory SMCCC advertisement for protected VMs?

A protected guest querying ARM_SMCCC_ARCH_FEATURES_FUNC_ID for
ARM_SMCCC_HV_PV_TIME_FEATURES in kvm_smccc_call_handler() will receive
SMCCC_RET_SUCCESS because the KVM_REG_ARM_STD_HYP_BIT_PV_TIME bit is
still set in std_hyp_bmap:

arch/arm64/kvm/hypercalls.c:kvm_smccc_call_handler() {
	...
	case ARM_SMCCC_HV_PV_TIME_FEATURES:
		if (test_bit(KVM_REG_ARM_STD_HYP_BIT_PV_TIME,
			     &smccc_feat->std_hyp_bmap))
			val[0] =3D SMCCC_RET_SUCCESS;
		break;
	...
}

However, when the guest actually invokes the feature,
kvm_hypercall_pv_features() returns SMCCC_RET_NOT_SUPPORTED because
the IPA is unconfigured:

arch/arm64/kvm/pvtime.c:kvm_hypercall_pv_features() {
	...
	case ARM_SMCCC_HV_PV_TIME_FEATURES:
	case ARM_SMCCC_HV_PV_TIME_ST:
		if (vcpu->arch.steal.base !=3D INVALID_GPA)
			val =3D SMCCC_RET_SUCCESS;
		break;
	...
}

This violates the SMCCC ABI by advertising ARM_SMCCC_HV_PV_TIME_FEATURES
as supported but returning NOT_SUPPORTED when it is invoked. Should the
KVM_REG_ARM_STD_HYP_BIT_PV_TIME bit be cleared for protected VMs?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920212845.707-=
1-suzuki.poulose@arm.com?part=3D2
