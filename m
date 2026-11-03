Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793730681;
	b=kJfl+DZYMvQ/sJ6Cw9EU2qEqbZ0O4jn4LPCrz9zp6FnTebMKDZNeLC0Uqvnpp4M/VEg4
	 BhRJ7TtSDELAM7JPcrD89STyZIbR5OSNXLHRcldNj8YPGdkwYadVQtrvDe+lxuP/gdzNW
	 zLIkg3vkcG/8jwny7lMq5eTsnOeb0mk+M8ieFT7kNbdsrosF7k+fwmtvtEVb2+ZsDquxL
	 yMrdjuSpDGPvdCAP03WjOxqU33sYUXSeI0QqPN6dKKXHq6KySeYuyF9X54ZooWOzfW6pT
	 Dx5bh/1DRh3+vNA0X0r6T+VoeVb36djRjoVmQf94HpwoHl05o1z5aWzbO7jZzpZVj/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793730681;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Bx3Axi7kmYN6HEZS0ZMX6Y3+JCnWA7wgIjqfYLJTD5A=;
	b=3XHZKwRw5tHejGW2RszsKDSfU+UGt7o6OFMJpJofpDuVoX2zxsALOFI7lEpN9Zspnyj7
	 7KsHfaXX7ydZB1VACj4xTmbnWNT4J7nMM/2UerR5GTKBEskUQWRza4JUMKri/XkQTSdSu
	 G2rbb6imDyFPUylCI++rZbuWkm2L9EvD8CQueExIKh1kSllRFCsn+04vpX3hCVl1TK20p
	 SJrcp+MSxrcCQCh8UwWTbk7FOiBdvtRKtNeUbTLORpTpjE5IW7L9C6ypvX2Y9pKC+ezKO
	 cRQNx8Jnm06xP7AsovzgMFhCEHDGArZ7QI4iNw/t7W+5rUc2hGTyUd1y++QdoUeX9sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FeUVFkLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC20606A32F;
	Tue,  3 Nov 2026 18:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FeUVFkLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1333B1F000C1;
	Tue,  3 Nov 2026 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730680;
	bh=Bx3Axi7kmYN6HEZS0ZMX6Y3+JCnWA7wgIjqfYLJTD5A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FeUVFkLv+d4UD6VxK6RWXHmiYjf9+SWtAqQifjG5tFA6pcLvjO1xXaKDuR6ZRPXNN
	 eZzLzDtbfe9jnG3mO30+NPWrRIXp8LCH3jwcM7/xQYEUatuX5VIM+ylAVm12oCvjWC
	 fbZbidf1pDMiwEMQlVVMOtv+Luv6mpu55JR3+kq1TJfl7eWD4EyDK0bRaik+tvujF6
	 qfOxpv9f5AAaj/U7wYi1YFqSGSlfCozcWWM8Q3WNNxP0b0+T/EJekmH2rj1JiqOY33
	 9nq8y034lWAxy1ODkbvxL20QE23YEbV69/gK9Mz1GAuv8Ya/w1V70ITdg3IhEqmLq5
	 katzo/XMTGHag==
Message-ID: <sashiko-outbox-195843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 3/3] KVM: selftests: arm64: Make set_id_regs bitfield
 validity checks non-fatal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Brown" <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261103-kvm-arm64-set-id-regs-aarch64-v9-3-ab32bc79fa9c@kernel.org>
References: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org>
 <20261103-kvm-arm64-set-id-regs-aarch64-v9-3-ab32bc79fa9c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 18:31:19 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] KVM: selftests: arm64: fatal vcpu_set_reg() in test_reg_set_success=
()
--

commit 528a199af5ef8c602f0139ccc2860e91e650c762
Author: Mark Brown <broonie@kernel.org>

KVM: selftests: arm64: Make set_id_regs bitfield validity checks non-fatal

This commit converts fatal assertions in set_id_regs feature register
validation checks into non-fatal kselftest result reports that include the
affected bitfield name and allow subsequent tests to continue running.

> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/test=
ing/selftests/kvm/arm64/set_id_regs.c
> index 37107eadd9854..d7f8b8efe1e28 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -423,6 +423,7 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcpu=
, u64 reg,
>  	u8 shift =3D ftr_bits->shift;
>  	u64 mask =3D ftr_bits->mask;
>  	u64 val, new_val, ftr;
> +	bool match;
> =20
>  	val =3D vcpu_get_reg(vcpu, reg);
>  	ftr =3D (val & mask) >> shift;
> @@ -435,7 +436,10 @@ static u64 test_reg_set_success(struct kvm_vcpu *vcp=
u, u64 reg,
> =20
>  	vcpu_set_reg(vcpu, reg, val);
>  	new_val =3D vcpu_get_reg(vcpu, reg);
> -	TEST_ASSERT_EQ(new_val, val);
> +	match =3D new_val =3D=3D val;
> +	if (!match)
> +		ksft_print_msg("%lx !=3D %lx\n", new_val, val);
> +	ksft_test_result(match, "%s valid write succeeded\n", ftr_bits->name);

[Severity: Low]
As reported by Sashiko on v8 [1], in test_reg_set_success() in
tools/testing/selftests/kvm/arm64/set_id_regs.c, vcpu_set_reg() is still us=
ed
to write the register value before checking whether the write succeeded.

In tools/testing/selftests/kvm/include/kvm_util.h, vcpu_set_reg() calls
vcpu_ioctl(), which triggers a fatal assertion if the KVM_SET_ONE_REG ioctl
returns a non-zero value:

tools/testing/selftests/kvm/include/kvm_util.h:vcpu_set_reg() {
	struct kvm_one_reg reg =3D { .id =3D id, .addr =3D (u64)&val };

	TEST_ASSERT(KVM_REG_SIZE(id) <=3D sizeof(val), "Reg %lx too big", id);

	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
}

When KVM rejects an ID register bitfield write in arch/arm64/kvm/sys_regs.c,
set_id_reg() returns -EINVAL from the ioctl rather than succeeding and
leaving the register unchanged:

arch/arm64/kvm/sys_regs.c:set_id_reg() {
	...
	ret =3D arm64_check_features(vcpu, rd, val);
	if (!ret)
		kvm_set_vm_id_reg(vcpu->kvm, id, val);

	mutex_unlock(&vcpu->kvm->arch.config_lock);

	if (ret =3D=3D -E2BIG)
		ret =3D -EINVAL;
	return ret;
}

If KVM unexpectedly rejects a valid write during
main() -> test_vm_ftr_id_regs() -> test_reg_set_success(), wouldn't
vcpu_set_reg() abort the test binary immediately before reaching
ksft_test_result() to report ftr_bits->name and continue running the remain=
ing
tests? Should test_reg_set_success() use __vcpu_set_reg() and handle a
non-zero return value non-fatally, similar to test_reg_set_fail()?

[1] https://lore.kernel.org/r/20260929163445.0D9331F000FF@smtp.kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-kvm-arm64-=
set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org?part=3D3
