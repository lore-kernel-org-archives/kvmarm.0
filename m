Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8438E3A962E;
	Mon, 20 Jul 2026 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527149; cv=none; b=EqMTBXIELPVvMIZnlE0flq7eyvqWkWdOGGFuoKA+0UD8k2H8wrfSEJT8EH6j4Vs6S0AopeVoocc/nA28nFYRvMCyWj2rHvPOU9ZD0tXyxK3YsNGtHqvQ4BODS48HdOUAqCmAj3SyN82lzhOutUD1WzUQBvACX9f44O1HGfyruy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527149; c=relaxed/simple;
	bh=3uECCj9ObJ4TNv3l0/M3WOVpwCywEJ+qJc4tUztpAVM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pe4n7Fs+fGaTWdFDeldNVFQC3DIKmNJJKC/eHBtTR8k7MnVF1V3v/+MzwQR4IkleSyUPjXQymvhy+uSkuhwwMDPxeXI0NDH6qgQfni60iguCFERRyN3u71VZbvJQmgcOmn/nuLQgPXoKF4oTqibA97sgVupeB8biL3a3N8/2Bz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBDDI25g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBDDI25g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7D11F000E9;
	Mon, 20 Jul 2026 05:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784527138;
	bh=8k9/hzwOymF3CxAGn8gAYbE/a7jA7EZEjqNj/7aOrCY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OBDDI25gHTWxIGsg9ydjcDjhJeQvCfRuSnMNhT8cScZ4/hSabCpnYgtj4h3MVYOXA
	 vwJ9eKDZpJTWGw9T8EXF+D4rT+idAz5W94Qm4S0hdLeKbox7umOnk/qnt6jv/7vPSi
	 6LxkAY708Gg+VLMOgm0v1bYRgPbqKCgwctrwtZba7ctkoevQOkEUg+nfmzZq/q36hF
	 K5nZHnkyR9T7naoe6hdsqib4wdoi6slm5fEtQILKEY/NOoQ+bUVP6FGvZtG9nUGGWk
	 /OrrRH0cBLwDldB386IyHP15l4bf0gh/C4QVAyHnTGPQn/OiicuawbEag+pE797MJv
	 Yn5EdDZjMSmhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/16] KVM: arm64: PMU: Stop updating MDCR_EL2.HPMN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260720-hybrid-v9-2-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-2-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 05:58:58 +0000
Message-Id: <20260720055858.8C7D11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS attribute handler allows p=
ost-run reconfiguration of VM-wide PMU state, violating finalization requir=
ements.
--

--- Patch [2]: [PATCH v9 02/16] KVM: arm64: PMU: Stop updating MDCR_EL2.HPM=
N ---
commit 3727863e040affba175d6ddaaa4d17f6dbc0e769
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: PMU: Stop updating MDCR_EL2.HPMN

This commit stops KVM from rewriting MDCR_EL2.HPMN for every vCPU
whenever userspace changes the PMU or its counter count. Instead, it
updates nr_pmu_counters directly and relies on reset_mdcr() to initialize
HPMN at VCPU init time.

Closes: https://sashiko.dev/#/patchset/20260706-hybrid-v8-0-de459617b59d%40=
rsg.ci.i.u-tokyo.ac.jp?part=3D6

> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 98305bbfc095a..b5df6843dbcd5 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c

[ ... ]

> @@ -1111,7 +1093,7 @@ static int kvm_arm_pmu_v3_set_nr_counters(struct kv=
m_vcpu *vcpu, unsigned int n)
>  	if (n > kvm_arm_pmu_get_max_counters(kvm))
>  		return -EINVAL;
> =20
> -	kvm_arm_set_nr_counters(kvm, n);
> +	kvm->arch.nr_pmu_counters =3D n;

[Severity: High]
This is a pre-existing issue, but does this assignment allow post-run
reconfiguration of VM-wide PMU state?

The caller kvm_arm_pmu_v3_set_attr() gates this update using only the
local VCPU state:

	if (vcpu->arch.pmu.created)
		return -EBUSY;

If VCPU 0 has already run, and userspace configures a new VCPU 1 (where
vcpu->arch.pmu.created is false), couldn't a call to KVM_SET_DEVICE_ATTR
reduce the number of counters and overwrite the VM-wide
kvm->arch.nr_pmu_counters here?

When the running VCPU 0 accesses a previously valid counter, KVM's
pmu_counter_idx_valid() would read the newly reduced nr_pmu_counters and
could inject an Undefined Exception. Does this need to be gated by
checking if any VCPU has run?

>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D2
