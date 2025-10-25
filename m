Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE3A13AF2
	for <kvmarm@lists.linux.dev>; Sat, 25 Oct 2025 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761351875; cv=none; b=ehIktWABuELczfv79cnjSmBpOkoGp3i8cNnDiaEW8wQzC+Him2ZZum20gAGWG0I0UfWe+CUSJNmzHlusinVd8iMW3ZWj8ohGUkhCUY08dT7z4fw9Lh2h31CCnRceAKomfcqMQh5HtFXrlboTt37b6eyDQTaaRKyTslQr7Abjb0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761351875; c=relaxed/simple;
	bh=RfxD0nv7ICdGquVmQh9dlxeiMTjpixItryatLCD5tQM=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=EhaI51bBX6J0TLXGVXPYTub1Lqvkw6EpgpY7+vHu1cjbK9q3htWY8BARpBQB72U1611WEwEwcQidRcQSK5g/VKnIm2FI8eb62zGAL8/ZZJEndp8iv5v2L6oSPUCWqsfVnE1FQDwcs7LFqnPmGyqn41bGK/WN2inmIrQCxBpSWuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rb4+ZpBQ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rb4+ZpBQ"
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761351869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K63L7hxS6I4G5mSoWOtNBzpOLAvH4IkCKx0AthDDqQQ=;
	b=rb4+ZpBQ7YibMLzV7DJquvd8bTzLMftjGuhksBTTG0YjLpIejGHeYn6rbalZtyRIO7nlzD
	HhUf+lpgb/Dy4Qa4Lt+uCLnfk22KWO2VzkYD2eJOzVtQHsfYBBSZ4ugCZ7OPXw0lQZDdx6
	1FUB/lpFAFVFzsMxJLPCfVqUgnXRmac=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: RFC KVM: arm64: selftest: stage 2 mapping helpers 
Date: Sat, 25 Oct 2025 09:24:12 +0900
Message-Id: <80DD0C0D-A056-493F-A12A-B24D8663F3E2@linux.dev>
References: <aPieUS7BTQB_dUFs@linux.dev>
Cc: kvmarm@lists.linux.dev
In-Reply-To: <aPieUS7BTQB_dUFs@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

Hi Oliver,

> On Oct 22, 2025, at 18:05, Oliver Upton <oliver.upton@linux.dev> wrote:
>=20
> =EF=BB=BFOn Wed, Oct 22, 2025 at 02:25:42PM +0900, Itaru Kitayama wrote:
>> Hi Oliver,
>> Thanks for your review. Below is the updated helper patch and a test prog=
ram
>> which does ERET in L1 guest (in guest_code). However, upon execution I ke=
ep
>> getting IABTs from lower EL.
>=20
> I don't have the time to help debugging this, you'll need to spend some
> time on this if you can.
>=20
>> int main(void)
>> {
>>    struct kvm_vm *vm;
>>    struct kvm_vcpu *vcpu;
>>    struct kvm_vcpu_init init =3D {};
>>=20
>>    /* Check we're on a NV2 hardware */
>>    if (!kvm_check_cap(KVM_CAP_ARM_EL2))
>>        exit(KSFT_SKIP);
>>=20
>>    vm =3D vm_create(1);
>>=20
>>    kvm_get_default_vcpu_target(vm, &init);
>>        init.features[0] |=3D BIT(KVM_ARM_VCPU_HAS_EL2);
>>        vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code);
>=20
> Keep in mind that aarch64_vcpu_add() will wind up initializing the EL2
> CPU context when HAS_EL2 is set. To get a functional EL1 you'll need to
> initialize the EL1 CPU context, including the MMU and allocating a
> separate stack.
>=20
> You can probably get away with reusing the EL2&0 page tables at EL1 so
> long as the stage-2 translation is an identity mapping.
>=20

I seem to have a selftest that does launch an L2 guest form an L1 guest. Man=
y thanks to your helpful comments. However in the current KVM selftest libra=
ries done provide exception handlers for L2 guest thus I wonder how you thin=
k we implement those. Just extend what=E2=80=99s there in handlers.S?

Thanks,
Itaru.

> Thanks,
> Oliver
