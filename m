Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A482641C6;
	Mon, 20 Jul 2026 06:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784527746; cv=none; b=JHFA1x5TMKMwF+2U/5k/umPPmyUTfXhR9trmYeec2LMkdSpF0jTfFCGZTMd634E1Vd2FpaytebAx/ypBtkFLTSQMlxuxmvUSmUdvoW7g/5z/kNxSzcxUnPHzz4v2o3Av9YiK3TCd3f6lZZDJqiRW8gzRj43WLNydhbrAeb98HtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784527746; c=relaxed/simple;
	bh=wTutGr7OxqWv56r+Epx+x2x/ozyzTYSrnx8JSMrmIT4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NdBRRWt5JyqV1rrReh24gB3ZTKLfCrp+u1ooMdk6Foii6ZuQH6l9PHtmtERN0q+UgUKlaIJu1T4tTHSz58b3h5colWuE1MYua0bw2Dd9/GHaoIfC4UIhpiKpHEPzUfFhZXLbAZ+dOXr+jhg29Wy8tr7kaNPdYcEpj8fFnqGu4IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4OFtvOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4OFtvOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB11F00A3E;
	Mon, 20 Jul 2026 06:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784527738;
	bh=MYq+sXYCF1Dr9j8SVKF6XQI//KSrWMXyv47JaidXXug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W4OFtvOCWVUru17Q+vsdrVUUZqQRNkVJhvJMbdy8GTgDjSRtEuERzI89RdSOp304q
	 mw4bg9isNkYLcRVupj+Gi60NZs3j6X//SAU/6nWa24/EKbGB3VbE11Tgpf8jbTQX9r
	 qtLXCP9qVFa2tB2lHpGDBV9z1Vk1bl3Tpg1dqNt+U/GUgUDZsQXCgdj6doF71lkXno
	 2tV/z5MaJBEbl0pgsHL2eeTd/ABI3F4RoHlgUYMQONQl15OME0sINv0rDswJm3lDYC
	 rd2izNFLdlLB4ezuq64350sc34Xlw2V88ac3GpM9NUJDV4LLPH0L0ljjuwKpDTUVlq
	 HW+7u88CgW+Ow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS
 after first run
Reply-To: sashiko-reviews@lists.linux.dev
To: "Akihiko Odaki" <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
 <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 06:08:57 +0000
Message-Id: <20260720060858.5AEB11F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The test ignores the guest's exit state and `ucall` status after=
 executing `vcpu_run()`.
--

--- Patch [4]: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS=
 after first run ---
commit 0382d3a32df9349f988ca69c7b11c92e61c3d384
Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

KVM: arm64: selftests: Test SET_NR_COUNTERS after first run

This commit adds a regression test that runs one vCPU and then tries to cha=
nge
the VM-scoped PMU counter count through an idle sibling to verify that
SET_NR_COUNTERS fails with EBUSY once any vCPU has run.

> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/to=
ols/testing/selftests/kvm/arm64/vpmu_counter_access.c
> index 22223395969e0..3b5bb421f401b 100644
> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c

[ ... ]

> @@ -622,6 +627,37 @@ static bool kvm_supports_nr_counters_attr(void)
>  	return supported;
>  }
> =20
> +static void test_set_nr_counters_after_vcpu_run(void)
> +{
> +	struct kvm_vcpu *running_vcpu, *stopped_vcpu;
> +	unsigned int nr_counters =3D 0;
> +	struct kvm_vcpu_init init;
> +	struct kvm_vm *vm;
> +	int ret;
> +	u64 irq =3D 23;
> +
> +	vm =3D vm_create(2);
> +	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
> +	init.features[0] |=3D BIT(KVM_ARM_VCPU_PMU_V3);
> +	running_vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code_done);
> +	stopped_vcpu =3D aarch64_vcpu_add(vm, 1, &init, guest_code_done);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +			     KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
> +	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +			     KVM_ARM_VCPU_PMU_V3_INIT, NULL);
> +	vcpu_run(running_vcpu);

[Severity: Medium]
Does this code need to check the guest's exit state and ucall payload?

If the guest payload crashes or hits an unexpected exception, this will sil=
ently
ignore the failure and proceed. Since the test only checks for an EBUSY err=
or on
the subsequent ioctl (which will still be returned because the vCPU has been
run), the test will pass despite the guest crash, potentially masking=20
virtualization bugs.

> +
> +	ret =3D __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
> +				     KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS,
> +				     &nr_counters);
> +	TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EBUSY,
> +		    KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
> +
> +	kvm_vm_free(vm);
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720-hybrid-v9-=
0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=3D4
