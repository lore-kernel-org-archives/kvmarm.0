Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA4A47DFA8;
	Wed,  6 May 2026 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778077401; cv=none; b=NHeMw+PeZwxtenK8W3oJI6xF9hR01Dom77UNRmr4DA53g0QhiXaMnsv6m+iiL2g+XizLlQhjODjzaJIQKkQU+2qs1jQA5DoDzW87nXbq/2UtPgeaDk/Gfe68TrKg0l3nLCHJjt2Mc4SgL1hIuoZ0hoNxn7P0tyPyev5O7iYfPkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778077401; c=relaxed/simple;
	bh=c1KSkEhGkgjTtE0mW/P5fl7nv0e6sQl0nC4LywPg2jA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DxutokfkGTGKIiR9iKIOm1zjgygN9bp9T2juZH8GhZc7Q80WB/y8AFeF5xKCkCvMbftGBmS2LE9dTnTfpukTcTWbd+oneBC9SeMztIDYMmLepFF3doDxdaiAE87+FQu/hvVxaj5p3449y+zwb7SMblL7Chk4/C8VSk6ht8YPtzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEwt1g3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEwt1g3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E8C2BCB0;
	Wed,  6 May 2026 14:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778077400;
	bh=c1KSkEhGkgjTtE0mW/P5fl7nv0e6sQl0nC4LywPg2jA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=oEwt1g3WbZaVC75K30zWVTBZeP2GzhD/cAV8r18lBJbwxYV7ExIy3ntAICoUAaody
	 DIItMuwdbmTxCv0Tj6q/OJp2S3gF0D7ILUZP4v0v/H9Op48bYJK7Z26hnaq2qbv6sg
	 HQc16yz1CVBiVBfquOvsk2Ye7hP/7KPIXOy+fu7VW6NEQWN37TJjpeL9SWkG4uDICU
	 tX611tgTeWss1ucyWwCt2cf1jCyFP9Ri2TQv+haPvQ1Ke+nIThSrrzhppFzel1AgPR
	 2N5rBcUkQ4fdgMdFnxPt9WqUWOAzJs29IlGpHIng/viXrtzbl1tGzrbRVlays/7Ecw
	 KhGGipTVyGcQQ==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 3/3] coco: guest: arm64: Query host IPA-change
 alignment via RHI
In-Reply-To: <86tssvyz2v.wl-maz@kernel.org>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-4-aneesh.kumar@kernel.org>
 <86y0i8zo9f.wl-maz@kernel.org> <yq5a4ikv1c7p.fsf@kernel.org>
 <86tssvyz2v.wl-maz@kernel.org>
Date: Wed, 06 May 2026 19:53:11 +0530
Message-ID: <yq5ase84d3cg.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Marc Zyngier <maz@kernel.org> writes:

> On Tue, 28 Apr 2026 13:49:46 +0100,
> Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>>=20
>> Marc Zyngier <maz@kernel.org> writes:
>>=20
>> > On Mon, 27 Apr 2026 07:31:08 +0100,
>> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> >>=20
>> >> Add the Realm Host Interface support needed to query host configurati=
on
>> >> from a Realm guest. Define the RHI hostconf SMCs, add rsi_host_call()=
, and
>> >> use them during Realm initialization to retrieve the host IPA-change
>> >> alignment size.
>> >
>> > I don't understand what "IPA-change" means. What you are after is the
>> > host's sharing granule size.
>> >
>>=20
>> This is part of the RHI specification, and the call is named
>> RHI_HOSTCONF_GET_IPA_CHANGE_ALIGNMENT. The intent is to determine the
>> alignment requirements for changing IPA attributes (protected vs.
>> unprotected IPA
>
> This really is a terrible name. Why the 'change' part? It doesn't
> change, it is a constant.
>

How about rhi_get_host_sharing_alignment()? or can you suggest a better
name I can switch to?

> Oh well...
>
> [...]
>
>> >> +static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_=
call)
>> >> +{
>> >> +	phys_addr_t addr =3D virt_to_phys(rhi_call);
>> >> +	struct arm_smccc_res res;
>> >> +
>> >> +	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
>> >
>> > Errr... What guarantees that *rhi_call is *IPA contiguous*? This is
>> > incredibly fragile. You should at the very least check that this isn't
>> > vmalloc'd.
>> >
>>=20
>>=20
>> I didn=E2=80=99t quite follow that. We have other RSI calls (even RMI ca=
lls)
>> that do similar things, and the caller understands that the address
>> should be IPA-contiguous.
>
> Does it? Where is it documented?  All you get is a pointer, so all
> bets are off.
>

We have multiple rmi and rsi calls that takes ipa values. asm/rmi_cmds.h
and asm/rsi_cmds.h. Some of them takes phys_addr_t while others take
unsigned long. The spec mention these as 64 bits values. May be we
should switch them all to u64. x86 also having similar discussion=20
https://lore.kernel.org/all/afOrd7JYkUfe7wcZ@google.com

>
>> Are you suggesting that all RSI calls should
>> add checks for this?. or are you suggesting to update the API to
>>=20
>> unsigned long rsi_host_call(unsigned long rhi_call_phys) ?
>
> I'm suggesting that this API is subtly broken because it makes random
> assumption about the physical contiguity of the VA space. It does so
> without any check, without any documentation.
>
> Simply changing the parameter to phys_addr_t could at the very least
> capture some of the requirements, but I'd like something in big bold
> letters.
>


virt_to_phys() emits a WARN if the address is not part of the linear
map. Are you suggesting that we should add additional checks to the call
sites that pass such addresses?

Sorry, it=E2=80=99s still not clear to me how you want these calls to be
updated.

The pattern I=E2=80=99ve been following is:

Lower-level calls that use arm_smccc_1_1_invoke() take parameters as
unsigned long. I initially wanted to switch this to u64, but since
kvm/rmi.c uses unsigned long, it was decided to keep it consistent.

This approach is used in cases where the same argument is passed across
multiple calls, for example:

phys_addr_t rd_phys =3D virt_to_phys(realm->rd);
rmi_vdev_create(rd_phys, ...);
rmi_vdev_lock(rd_phys, ...);

For calls like rsi_host_call(), I chose to pass a struct pointer to
maintain better type safety:

static inline unsigned long rsi_host_call(struct rsi_host_call *rhi_call)
{
	phys_addr_t addr =3D virt_to_phys(rhi_call);

	arm_smccc_1_1_invoke(SMC_RSI_HOST_CALL, addr, &res);
}

Note that virt_to_phys() will WARN if the address is not part of the
linear map

Could you clarify what changes you would like to see in these
interfaces?

-aneesh

