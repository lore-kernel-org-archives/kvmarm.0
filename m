Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793108956;
	b=x8hByPgYhP3Yrfin7XDnao1Rqq7NM95ASG+Lrwg2+wkzJHFNmpM9Ps6klxIrC4z6YiEx
	 iEz9fdx1OdqF0/+d+CkVtf0gsbHb7UmcyZDXwM29Txlf/R0jNM2DTpZZscdGwd/KD45P6
	 NvWekpG7jE2RpdkhUL0btY8PUWd1DS9hru4XKzywHh9JOcbfkXR1dhLsFNiAKBzj5S3u8
	 StMnLT6/rn7lzHPTAKJVanhUru70LDckVmj8mwlUcBBI+gbPL/lvPC+JEuOTBMsm7cir2
	 0ZUJ9fv9Jhmpcw1nfFQxuU4JSE8HS/LOeknITUZLiJeB0xwWW8OGkETFCkE5O2CmM4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108956;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=GEmx/sUPQ2VMJDaiqbyGhNC0GffzmoblRKDktdSOsjs=;
	b=hozi4wYaYBLfaRDJTQ9cnx+zBfDLAWfoj0pJ2ZRpu/3CH1G6r+IPxwu5uahOo6WeUpHH
	 0rotMX/DMEI9uR7wGySliniK1ntJ7WPgfcbhexGfz44N2/bdnzWJQua3+gqs7TUthW1sK
	 bghGjJHzEP0pfWKwniM+gVZ5bvBh5SZAfWn4aSh2WZ76XJYz710geIpHLfDhsvPh6/KQ7
	 8iz9S+39keyTrl2UXpTXlutgFuBNmVnrAQ9JxTQWISfM3cWleiJv7mHHBnN71YygyV8u/
	 RQmTQb/V6wpY2MuhEGnLckK7an67HKmVSIFOhvIvbhZ//Xd8noUaDKnRTAh70XnA3PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=mTTn8ZWR;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Z0LOYJhm;
	arc=none smtp.remote-ip=202.12.124.144
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A0C606A32F
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 13:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33A0C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=mTTn8ZWR;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Z0LOYJhm
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 44B011D00120
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 09:49:15 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 27 Oct 2026 09:49:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793108946;
	 x=1793195346; bh=GEmx/sUPQ2VMJDaiqbyGhNC0GffzmoblRKDktdSOsjs=; b=
	mTTn8ZWRIuh6yCC8N7zM1RkyjRwCnYj5ApXsvRRDF4DShqntltu32cedImYWxCZW
	3T3+rX3vuwWPL5BhK3RzggeyxYrft8Aa0815cxCyq8/KAlrCQQgYJqtyYcVcPEAE
	QZBFcR5xocMUdNEC/Ss256l4ZTh36L0yA6nnDmsTbvCqx+aGJldnAm0J34yVwDd5
	m04wU9UA04ybLZrICroOAcmeVLw2Ys3YtKcCDiKCNrxuqwql7L/kxY1RPM3o8joN
	8/N1a/j2bRPmUrjsWmf/ailBEue48H+ng2y83WUFWdeq+wi0PRYNxXfVLZstF6Am
	KGujzhZxqmlaOMguIzoIhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793108946; x=
	1793195346; bh=GEmx/sUPQ2VMJDaiqbyGhNC0GffzmoblRKDktdSOsjs=; b=Z
	0LOYJhmXY4ILhQ1ZEb9qsYJQb6aASLrmEzl9aoPc7z19rsBh9FMGWNyVNLU7hfmy
	eZxpXf2mvRssP8XDq5BwNlaRlz5VE7OO5sTjTAUHeCklgX95D9UEE6KYLyNRa5py
	1buGciWMGbz4a8FiV2/B0WZzxZLXehhPunxe710+MHMw23z0UhckVw58ZTZY1OFF
	K7sJFwa+taHtRtekI+ovUwvgLNKhqphGmdlgaxNz94Ecd56bxmn/eEDHONbdfZSV
	GC+WA7Llt0rFNrzwSacSwSzAnXm8emS5XWDdgAx/ihLYXUr3Kuu0StEEeQIx4iyU
	s2anVNpi2GVaFVauFQC6w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793108946; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGt2bWFybUBsaXN0cy5saW51eC5kZXY+;
	s=fm2:rsa-sha256:bkrNYWpt3DZY3gYQ4QTRgaABMFvTyyK+1lrK3KY7srSFz5/
	p/fVpp1EVr4pl8NbFe/xD9iZl0o7JULl/Dt9pHps5fTatXsl28861DHO2L6qroJA
	xVu1VstTn4LH9wg+l/k+HbOKH4bMFqCpRMXenvvOEmU4RK8CX/Nv5DoAiKuHguwo
	xEOknX425GQskcfDR4IL+TA4S3zoThWuu2z+GE6AK6SVmmGJIohn4XkP3y4/Ri0+
	iiGwPUDkCP3AC42zjuRPrhNhejB0pO1WqaTrDAwMwtOksb28P5tXtlGvWhD0mO7t
	ZlEkzx5eDeDfl/BlobpCuRTWwVVxidUFrmtkRdg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:rJDu4bsxco/gIMrD+dD00LfJT4/xDEIwd0IpCUvE7Ok=:KdZkVqaRMOJUI0d/ETxpGSeypZPRT8HH1n5VL0jRLOY=;
X-ME-Sender: <xms:zKvgamIraj1gKKF0eAeZnUhaYnPU1FGpZQXoPCi9QC9qq4y6HIW4Rw>
    <xme:zKvgao9YFV_HCtCeHk0_T4CjvW0coaEmOrDF5Z2kFhRAfjJFVdAfJCZgMYi2KAs4y
    3f0xiWGAzDybQFUZvrDJOKx47W96PA_q1fy2h9Hfuu1yJwKNNKxT-HG>
X-ME-Proxy-Cause: dmFkZTGzAS/DSW4CsdWGOtMkgyUDpHtAQSg7qB+7/Ys6E0HD63N/Pcrnnyg0NyVoPg7+rI
    ROPODo20FS22WszwXXzPBCSg8LrAc4Gs0zt1FYqdFSEzsiYNN6B+Zdt10yoE6tItpi5jSF
    QuM9+Ljs5u0qdw3cXSYAYD7nPRBHPOx8gzkFNpi6Gbseu+z6gAkwtVDJbRXCWlJjnurtGi
    Pmj6Er35n4sJoC87PBTI4TELC6x88vYuf+atC7A7hhxb4VyPJywRy4I+EgvWCkwzhpkRvn
    nMptqgxqOXAcIdYDrgrCRIhV3oZrEOQDiLoCeq3SRJUVU6ykskJEuUkSjrW9OFNct6siFR
    fRCHMvYkK6bV80wdgi788H8hwIJ8b9THhB9ckSuR1RmxxvD7WxOIPSotO3yOc02D3nKnM3
    e5m4h7NOqMTkmL+0dH3YuEt+ZM4fUlHTkD+MOGsV2QC0axBtB9LuC6UF/Hga2d60sEaMeM
    40YHfXH1iCpHr3TKPHgkxz6Pj9XU+ZkKAllecoPy6beK8+P2VrT9S8dyN4ldk28HsXkye6
    rxBtxqQVDFqXb0+HrrMWnKRsiap6QZrMWRBn1XhjGmbJBKSbQuPyhm0bn9y/0hzTeACm5g
    ExZO57S+I1i8J638jlcrb+h37dguBbsFt1hT6dF/Yp3L+Unc9SLLJFjplqEg
X-ME-Proxy: <xmx:zqvgaiR9mD7HzWGzG7wCHl-DWnL2Zp7N8DEi80yl8Lf6Z1YFmMmqog>
    <xmx:zqvgaosexHicgu3YXFdciJAflEvO83wUz3WY2lZdgiSFEu0DpPk1pA>
    <xmx:zqvgagLpwi8qhmSfz4hjB85clzUCUokk2iF93sfQYo-JIMnIelfEzA>
    <xmx:zqvgasfLrqodpNqK86D1uz78eKcESEEdMr7W4hbdXGZ5NycJfIS3Zw>
    <xmx:0qvgaqh-ax7aBUwe4VoD-hxpmbytdLt64gvmlJ3Psa0VesPsIERnIBlT>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 0259C32A0093; Tue, 27 Oct 2026 09:49:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AmcrnnMArev7
Date: Tue, 27 Oct 2026 14:48:29 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, "Steffen Eiden" <seiden@linux.ibm.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Yicong Yang" <yangyicong@hisilicon.com>,
 "Zhou Wang" <wangzhou1@hisilicon.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <040cf379-baba-4e3a-bf3d-6bc009a9e28d@app.fastmail.com>
In-Reply-To: 
 <CA+EHjTyLnAXanf9R7SuoL3gFZUNewX7QOnW=mc3qzwvaxg7jJg@mail.gmail.com>
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
 <20261023070110.1833446-2-fuad.tabba@linux.dev>
 <86fqxwzul7.wl-maz@kernel.org>
 <CA+EHjTw08SZC_3Uodt6ew6vXVH-doW-8G41fVCF-rmaKsv+0fQ@mail.gmail.com>
 <86ecdgzp6m.wl-maz@kernel.org>
 <CA+EHjTy0jpY3sdVCENJRj_kfRDwbZ6TpkCAHQ2xUO-7ZuErpcA@mail.gmail.com>
 <ad724195-3452-495a-a50a-5e5c8093a483@app.fastmail.com>
 <CA+EHjTyLnAXanf9R7SuoL3gFZUNewX7QOnW=mc3qzwvaxg7jJg@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Hide FEAT_LS64_ACCDATA from guests
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, Oct 24, 2026, at 09:14, Fuad Tabba wrote:
> On Fri, 23 Oct 2026 15:10:23 +0100, "Arnd Bergmann" <arnd@arndb.de> wrote:
>> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
> [...]
>> @@ -254,6 +269,8 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
>>          if (prev != next)
>>                  __switch_mm(next);
>>
>> +        switch_iommu_mm(next, tsk); /* FIXME: is there a better place to do this? */
>
> switch_mm() isn't enough when the same thread also runs a vCPU. In v2,
> which I'll post soon, KVM will save and restore ACCDATA_EL1 only for
> the guest, since nothing in the host uses it today. So after KVM_RUN
> returns from a guest that has LS64_ACCDATA, the VMM thread's next
> ST64BV0 would use the guest's value, unless KVM also saves and
> restores the host's.

Right, makes sense.

I was a little unsure at first how ACCDATA_EL1 gets handled on PCIe
TLPs when there are both host and guest users that set it. As I
understand it now, this only works if the PCIe requesterID is assigned
to the guest VMID for stage2 translation, so a guest st64bv0
uses the ACCDATA_EL1 as PASID in combination with that VMID.
The host would just use ACCDATA_EL1/PASID for its own stage1
translation without stage2.

This means that with your v2 patch and the switch_mm() code I
have, this should be safe. There is a possible optimization to
skip the host ACCDATA_EL1 save/restore if current->thread.sctlr_user
does not enable SCTLR_EL1_EnAS0 (i.e. the same process that
runs the KVM guest has mapped the MMIO area of an SVA device).
This would make a difference if ACCDATA_EL1 access traps to
EL3, but otherwise likely does not much much of a difference
(I'd have to do some measurements on hardware).

>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> [...]
>> +static bool try_enable_st64bv0(struct pt_regs *regs, unsigned long esr)
> [...]
>> +        isar1 = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
>> +        if (!(isar1 & ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA))
>> +                return false;
>
> v2 will add an ARM64_HAS_LS64_ACCDATA cpucap, so this could test that
> instead. As written it tests bits [1:0] of the register, not the LS64
> field, since ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA is the unshifted field
> value.

Thanks for pointing it out. I have rebased on top of your patches now,
so this line is gone.

>> +
>> +        sysreg_clear_set(accdata_el1, ACCDATA_EL1_ACCDATA, pasid);
>> +        sctlr = current->thread.sctlr_user;
>> +        sctlr |= SCTLR_EL1_EnAS0;
>> +        current->thread.sctlr_user = sctlr;
>> +        update_sctlr_el1(sctlr);
>
> On a host that runs at EL1 (nVHE or hVHE), this also requires
> __init_el2_fgt to set nACCDATA_EL1 in HFGRTR_EL2 and HFGWTR_EL2, and
> __init_el2_hcrx to set HCRX_EL2.EnAS0. Without them, the ACCDATA_EL1
> access traps to EL2 and the hypervisor panics, and so does ST64BV0
> once SCTLR_EL1.EnAS0 is set. Happy to write those and the KVM change
> once you're ready to post this.

Thanks for the offer, that part is definitely not my area.

     Arnd
