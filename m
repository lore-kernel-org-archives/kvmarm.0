Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AF536A352;
	Fri, 16 Oct 2026 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164973; cv=none; b=JnJyf+CiDR9cua0XFm+x8bghR0RCq65ldNdyKJJJOe55H6zBrdr31ft6vs8LVV4pTpU535XT4g2wyVmR8ovA5JkWc0pwRWB5g9f161qyoIgSoeRhyG9cgKO1CxxJLT5ksIz3/rKkxH2fpGlCLUCY3E7U1IEjn0/b5APi9qNyrFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164973; c=relaxed/simple;
	bh=xOjat9Vi4PtYQbqy1AbKVZKYAZ1zqEoi+h2S0JYOTj0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oqORQjFwjjJSNURlWqlNIHIKT3RNycsfEgY2/iq23L3nOrU9qtTAxxP+bTfYomy/H+2D48+wqIEK3sKpW0Uf5vwfpIeoGJtb6S+YlOukU2RXsXrYFrRmW9ClH9oDIgNMnKiQELT3HTzeSSyD5IdpsS4ta4a6kjbTthMktQpgFNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kWj8+IFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kWj8+IFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C441F000C4;
	Fri, 16 Oct 2026 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792164972;
	bh=mEei+TK3DrwBKD32VXKwO/G8X0N42GnJzGwgLfMGo1Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kWj8+IFUvqP8lyDXBxxSxlCebVqpj6tqWIZeCaZUqvtPvLI1bhMM5dAzYMDAr2LiB
	 oGh3gAKEY0YIXtQfhYsJnJBg4MODL9SaPnzoHQvmCnhfMkjOA2Uci8F3h6pRylhawx
	 PE2ObeI3i6m+dEUPo8lCWr20e7C9v5axVB2jyFGNKGK1u85L1YMER3rl0vAEzJGESz
	 fbKRgngIrU783qeSeTfTAjj89KNCO+fc6QbQkClZ8J1DEQ/JJ2hfVJnbNWW01wiz5Q
	 I5wYDIrZvKZVgRCdQzjh2oBnsaVRhTPZjDf+G5fjrQSpO0f16M2Zba7k/6WPnKXe+N
	 Ff2JqWnsPJwnQ==
Message-ID: <sashiko-outbox-174571@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016152225.898761-3-sascha.bischoff@arm.com>
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
 <20261016152225.898761-3-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 15:36:11 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests: vgic_v5.c uses ad hoc skip messages and direct exit()=
 instead of TAP
--

commit 1b97dfda1bac7a30c8395c0645ac8efb945b4639
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: selftests: Reject GICv3 ITS with a GICv5 VGIC

Check that a GICv3 ITS and a GICv5 VGIC cannot be paired, regardless
of which device is created first. Skip the check when the host does not
expose a GICv3 ITS.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/=
selftests/kvm/arm64/vgic_v5.c
> index d5df742b23001..5bf7d99d29147 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_v5.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
[ ... ]
> @@ -2003,8 +2003,40 @@ int test_kvm_device(u32 gic_dev_type)
>  	return 0;
>  }
> =20
> +static void test_vgic_v3_its_with_vgic_v5(void)
> +{
> +	struct kvm_vm *vm =3D vm_create_barebones();
> +	int gic_fd, its_fd, ret;
> +
> +	if (__kvm_test_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_ITS)) {
> +		pr_info("No GICv3 ITS support; skipping mixed-model test.\n");
> +		kvm_vm_free(vm);
> +		return;
> +	}

[Severity: Medium]
When running test_vgic_v3_its_with_vgic_v5() on a host without GICv3 ITS
support, this prints an unstructured skip message and returns directly.

Could this be converted to use a TAP reporting macro like
ksft_test_result_skip() instead of an ad-hoc pr_info() and return?

Additionally, running the test suite on a host without GICv5 support calls
exit(KSFT_SKIP) directly in main() instead of using ksft_exit_skip().
Are there plans to update the main() exit path as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016152225.8987=
61-1-sascha.bischoff@arm.com?part=3D2
