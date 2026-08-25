Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4FC3DCD95;
	Tue, 25 Aug 2026 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787693537; cv=none; b=p+jD4FBZmdRgNnjorPpnC382m0zY99FXFv875n7elRRjcqz7ZLadg/fglMG/YYImF3/fTCJwK9r0aCw+COw5ja7TUGDKcWaxzfM15D0QVqyN7d1lAC4YBNcbq0/+uLEBxdjNKIQF3aZ0qRpg9NFuv9KrChrbNaXT5DX62/bmI5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787693537; c=relaxed/simple;
	bh=E6RvJQRgHJNZPUAAXJnzY5DTvboa4AHl1jNFv06USBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pl2Y8Y6RqGg5BfndRYV2VBMYmcz9UDlU3Vj4P+zmHAYM1nxkJVV4QHW4eo2Azch9RfkPdmdLWstNWM+K3Zuh/f+GbBJ6oOYCgnuQ1MfcfXA7TnvtGdOLCgHb5REnm97xA9tEH83XaBV8qja22RnM+E/3i2S1/4Y4sqf/DU18RSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jchd667e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jchd667e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356791F000E9;
	Tue, 25 Aug 2026 21:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787693536;
	bh=j2fVbiozqMBlTWSRDO414l06emxFIXo9GO8Rr2qHsmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jchd667eMFlGmqDSbHJSxBjXlp0RVXr63LNmJCZleM+2T4LiVfMkFfCDzHLwZt3bX
	 XZoMJt2DTMC1FftyO+SRDRP/OT/LqORn4XPpkf6rsIHJTce+ZE6rm+9l/oIOlk/ZVt
	 pcWVLY5OHtfjiYgAAWKfhAHbU25r4WimzYAN7k6qg5LknRJpurNehx0Jbg07RYekse
	 +0DhGYP6IM/W0h+9yKPAvJKHpIvv5y1naFIducsW2b5yboEJYQMJ0BXVy6Z0Bsames
	 FUDtOU+EpxxMU75ULWcrSeZrSYPQ52bPAV5BniWsl/1SV5xP8Rv3LLw9DOg6XoGTVP
	 EV0ry+CXjGwig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] KVM: selftests: arm64: Add 52-bit VA guest modes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Itaru Kitayama" <itaru.kitayama@fujitsu.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260826-arm64-52bit-va-v1-2-14ec98211363@fujitsu.com>
References: <20260826-arm64-52bit-va-v1-0-14ec98211363@fujitsu.com>
 <20260826-arm64-52bit-va-v1-2-14ec98211363@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 25 Aug 2026 21:32:15 +0000
Message-Id: <20260825213216.356791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incorrect TTBR0_EL1 base address encoding for FEAT_LPA2 (4K/16K =
pages) with 52-bit physical addresses.
--

commit 7fa14109ad0da6af47dd28e3d16f9d1ca4d12232
Author: Itaru Kitayama <itaru.kitayama@fujitsu.com>

KVM: selftests: arm64: Add 52-bit VA guest modes

This commit adds P52V52 guest mode IDs for 4K, 16K, and 64K translation
granules. It advertises the 4KB and 16KB modes when the corresponding
granule supports a 52-bit IPA, and additionally requires 52-bit VA support
for the 64K mode.

> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testin=
g/selftests/kvm/lib/guest_modes.c
> index 7a96c43b5704d..4f121e2987e9a 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -21,10 +21,15 @@ void guest_modes_append_default(void)
>  	{
>  		unsigned int limit =3D kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
>  		u32 ipa4k, ipa16k, ipa64k;
> +		u32 va;
>  		int i;
> =20
>  		aarch64_get_supported_page_sizes(limit, &ipa4k, &ipa16k, &ipa64k);
> +		va =3D aarch64_get_supported_va_size();
> =20
> +		guest_mode_append(VM_MODE_P52V52_4K, ipa4k >=3D 52);
> +		guest_mode_append(VM_MODE_P52V52_16K, ipa16k >=3D 52);

[Severity: Medium]
Will this corrupt the TTBR0_EL1 base address for FEAT_LPA2 (4K/16K pages)
guests with 52-bit physical addresses?

When a VM is created with the newly added VM_MODE_P52V52_4K or
VM_MODE_P52V52_16K modes, aarch64_vcpu_setup() configures TTBR0_EL1:

tools/testing/selftests/kvm/lib/arm64/processor.c:aarch64_vcpu_setup() {
	...
	switch (vm->mode) {
	case VM_MODE_P52V52_4K:
	case VM_MODE_P52V52_16K:
	case VM_MODE_P52V52_64K:
	case VM_MODE_P52V48_4K:
	case VM_MODE_P52V48_16K:
	case VM_MODE_P52V48_64K:
		tcr_el1 |=3D TCR_IPS_52_BITS;
		ttbr0_el1 |=3D FIELD_GET(GENMASK(51, 48), vm->mmu.pgd) << 2;
		break;
	...
}

Because TCR_EL1.DS is set for these LPA2 modes, the hardware expects the ba=
se
address directly in bits [51:x].

However, the code above incorrectly applies the 64K (FEAT_LVA) format inste=
ad,
masking out bits 51:48 and shifting them into bits 5:2.

Can this cause a translation fault if the root page table is allocated
above 256TB?

> +		guest_mode_append(VM_MODE_P52V52_64K, ipa64k >=3D 52 && va >=3D 52);
>  		guest_mode_append(VM_MODE_P52V48_4K, ipa4k >=3D 52);
>  		guest_mode_append(VM_MODE_P52V48_16K, ipa16k >=3D 52);
>  		guest_mode_append(VM_MODE_P52V48_64K, ipa64k >=3D 52);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826-arm64-52bi=
t-va-v1-0-14ec98211363@fujitsu.com?part=3D2
