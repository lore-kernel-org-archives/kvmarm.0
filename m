Received: from outbound.mr.icloud.com (mr-2001c-snip4-2.eps.apple.com [57.103.68.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BC63803DB
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 12:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.68.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294134; cv=none; b=FbL+ZjPUOLOIrLKL4mow1NpCLmZSnmjyS8qtoNmmlkkphHXikUnQavu1awQDDFoOkxmBlcCxn4WwbYPALkKdOGs+Om8ZnBPRbobTFRVGIwhPZX96ew21ddjuUuHc1Zc/19gyAJjH/MG8I3Gn3FahYOUIQcc2xnPX+ErWQ/dZjm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294134; c=relaxed/simple;
	bh=wxPc0ctIPlgLp/QH7M2KHxrGTAeLfOFCUscG08xXyg4=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=gBzzXyK2WcCeuFJcI8+XNwmfeZn9iVqz1J6SG6CpiBC8RMfOUbQFl3uNMeUboEbdCFvw0jsdA1ag5JwEiatBroTUhbSB34BXEEzZXXqLK2XiHV32/qEOKetXoV4DUmoeS5G4jD769Hji1EQiApV30CRwjxwMZ+u8E+fugiz6zz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=kyxIoO8Q; arc=none smtp.client-ip=57.103.68.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="kyxIoO8Q"
Received: from outbound.mr.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-2a-10-percent-0 (Postfix) with ESMTPS id E255818000AC;
	Mon, 27 Apr 2026 12:48:43 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQxWB1sZUgNeCEoBTVIPDxRMFVIDWg5aHVwMQAxaDkYwUBtfAkIPHBNWFRMLU1ZWBVQZXQBSA18VTQtSAFIfchlaFFwYU0VRH1RYQQ4KWgVQUR1fAgoERwRbF0YDU0VfAhcRUAFYHlZeWhdeTUcfQE1iSQFaGVscQBdKbk1TDw8ZWhRcGFNFUR9UWF4EU1YOM31PA1QEXHFdejsHVRpfd0Z8VXFYDy0fNAhNA1QPXHZDejsBLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777294128; x=1779886128; bh=OtPT9hDGi1toDup0/zFEOrZ1Yq1keXYkFN7hG5Y4Qhw=; h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:To:x-icloud-hme; b=kyxIoO8Q0Qk8hnAJLN1gPL0MgmnoFRLRvFSQ/3ompeg28OwYLot9u1xF5TAaCkBobYIrv2wqCME2Y01Ounft6uRk3zwyFqVAGqAqme7oSNHcJDmXeAbblUo+LTOYM0DqgqWTRI3dAnU+uNpSNJ9EFv926KN7zsv75q4kMbxY//d539wUFeB4Z6NuckCTtF2YR90GIKa4ptmBQvmgYkOdFtFL0ZeYaUv50Tqu4DtrlqLsRW6k+1jjw6F70DJX1B3lO7bbmDPIWKcmt3wgMKTDRag9cetJZ4f9toXAJecJE/LTwkJ3GsX2CiMecjqPyr5G4WwbU6uOyQBE+ylPLMgteQ==
Received: from smtpclient.apple (unknown [17.57.152.38])
	by p00-icloudmta-asmtp-us-west-2a-10-percent-0 (Postfix) with ESMTPSA id 9A44F180013E;
	Mon, 27 Apr 2026 12:48:42 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: "M.samet Duman" <dumanmehmetsamet@icloud.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] KVM: arm64: Validate the FF-A memory access descriptor placement
Date: Mon, 27 Apr 2026 15:48:29 +0300
Message-Id: <CD70937C-CC48-4E6E-B58F-D150987D3CC2@icloud.com>
References: <20260422102540.1433704-1-sebastianene@google.com>
Cc: maz@kernel.org, oupton@kernel.org, will@kernel.org, ayrton@google.com,
 catalin.marinas@arm.com, joey.gouly@arm.com, korneld@google.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, android-kvm@google.com,
 mrigendra.chaubey@gmail.com, perlarsen@google.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, stable@vger.kernel.org, sebastianene@google.com
In-Reply-To: <20260422102540.1433704-1-sebastianene@google.com>
To: Sebastian Ene <sebastianene@google.com>
X-Mailer: iPhone Mail (23D8133)
X-Proofpoint-ORIG-GUID: AdBxYoPQUhORC3_2tMs9NKhlz6Ar6-cA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDEzNSBTYWx0ZWRfX0NuQS8plZYiH
 rKNKnFloAoGAVUOtZFe6Voyqg8pvDFPxAdINTYBNGGoIoXmTBvFEPOAeNPm4Vnz43AcXOYhsVQ2
 aYV0kqZ1AArkgObvx53kL4Bp5TXrJuCS1Bn6mnzJtN24ihEyNXP6X/971Hu0xTdf3QZ0bEQY0gV
 JLaympk1KarA2Fjwhr/hW0pH2lQ7eEYG2+T8lpAlGOIY2GC+OZYZAc/dnYEEIPpJHQCOvxAFF14
 8ABDtzgNuMvc+NiZlofkn2bCX0oldpL31R7idOWMVjKTLpvc4ZpoFartgzCR8J6kZ1ucEGQGQsA
 Fmub0dHnqDz+aVsN063v9a8XdNmPl9PuHYW5Bi+AbOd0A7zpm7g2DgPZbFtmW0=
X-Authority-Info-Out: v=2.4 cv=Uq9u9uwB c=1 sm=1 tr=0 ts=69ef5b2e
 cx=c_apl:c_pps:t_out a=9OgfyREA4BUYbbCgc0Y0oA==:117
 a=9OgfyREA4BUYbbCgc0Y0oA==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=aRhIMoA-k8UA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=ziF__pklwX3jhVluTDYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: AdBxYoPQUhORC3_2tMs9NKhlz6Ar6-cA

I haven't tested this, but the change looks reasonable to me.

Samet

> 2026. 4. 22. =EC=98=A4=ED=9B=84 1:27, Sebastian Ene <sebastianene@google.c=
om> =EC=9E=91=EC=84=B1:
>=20
> =EF=BB=BFPrevent the pKVM hypervisor from making assumptions that the
> endpoint memory access descriptor (EMAD) comes right after the
> FF-A memory region header and enforce a strict placement for it
> when validating an FF-A memory lend/share transaction.
>=20
> Prior to FF-A version 1.1 the header of the memory region
> didn't contain an offset to the endpoint memory access descriptor.
> The layout of a memory transaction looks like this:
>=20
>  Field name                | Offset
>                     -- 0
> [ Header (ffa_mem_region)               |__ ep_mem_offset
>  EMAD 1 (ffa_mem_region_attributes)    |
> ]
>=20
> Reject the host from specifying a memory access descriptor offset
> that is different than the size of the memory region header.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
> arch/arm64/kvm/hyp/nvhe/ffa.c | 6 ++++++
> 1 file changed, 6 insertions(+)
>=20
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c=

> index 94161ea1cd60..0703c0ad8dff 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -508,6 +508,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>    buf =3D hyp_buffers.tx;
>    memcpy(buf, host_buffers.tx, fraglen);
>=20
> +    if (FFA_MEM_REGION_HAS_EP_MEM_OFFSET(hyp_ffa_version) &&
> +        buf->ep_mem_offset !=3D sizeof(struct ffa_mem_region)) {
> +        ret =3D FFA_RET_INVALID_PARAMETERS;
> +        goto out_unlock;
> +    }
> +
>    ep_mem_access =3D (void *)buf +
>            ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
>    offset =3D ep_mem_access->composite_off;
> --
> 2.54.0.rc1.555.g9c883467ad-goog
>=20
>=20
