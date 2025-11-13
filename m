Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B1E2D238C
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763051216; cv=none; b=BifuFaBPuhd8tVq0J6leweWNPAsyI0eyoaZx0V29IOBrLfZn3bfUyJ9BoAUoxv5ML5C1Ba5OAdcH7nEm8vyVnkZ5RQto25D/M4xjPWKIra2VPf2dBsjrSFO0CwX2UgmYmrBE3OaJdhX48/TGhE/3OHmBKZgce4BOclNduupBEzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763051216; c=relaxed/simple;
	bh=wcHGxpLWXBfDimZjVtBBZ4seqRcuy2mAnnSl6IOiv+Y=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=kiN4oEyykgVqeIoHSjJWrwhMzzyph+dMnxW9ng1B9mR6EptAVwDkcIlC6Uomu0xjd90TvTwqxpaa/z/1Pt3Lg6TahoD4NshelC53Mi8gHMkfrjhoHucMVRLQjSpbsdjhJciaCp5cE7oUG55lWk9op+wc5Q7H8/AkS+GMKmpUiEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=HY1WGiKv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HcC1NRHL; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="HY1WGiKv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HcC1NRHL"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 43FAB7A018B;
	Thu, 13 Nov 2025 11:26:53 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Thu, 13 Nov 2025 11:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763051213;
	 x=1763137613; bh=f4w9gz1EStBnmNqFWjlwX42Oe9RoSqgVszNo3p/wZFA=; b=
	HY1WGiKv3Dv07Gf3cqg+/2xDskMOOGV0jt5JvYBUdKYGp6ztUDzClykx6Yq17Duw
	AdDTNfCFup0Ghro47BorJ7YyzNRprjkhReyrsefVCOTvP7DxuWB4betgNyzaRrQ3
	Fq5R5qpljb7tsmJXKnOtzmhuBFn2NpTOgIbsVpsmjTdxLlvWXPjMaJF34pu6DD0T
	UpGf5jg88gaglTKnSFUleWb7ZSaUk5kXySVo6FXlEni5yrnNqnK0tE8Z/U67Ij4t
	wfZJYZI3+XcaUGVbK+vCrbiM4NhPHEBPrirHcNyLcPo1gN9iDlRoVzLDiHv1f2D3
	XC/9Gp9wWBe6xPKbSz/8vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763051213; x=
	1763137613; bh=f4w9gz1EStBnmNqFWjlwX42Oe9RoSqgVszNo3p/wZFA=; b=H
	cC1NRHL27jqhuSEpLo0hwXaS2f1KKdPRh8xFXia70l7kBPmocwH2nwm4eHk7PlL1
	BSyF4eZiByo4Oz70F+LgVGdHWC8063zS47uy5HGdTZOTpftjQb1VCJpk/JtcDl7m
	cV1ndcLV3SGgEGhJesGojGIN3oBOgKn2DhqF6VG9sYA14stpx2HXSqjpkCFdB5MX
	p6bYaG6Lf/0h9LFpAZa2eD7d+e4CCW+fO0OMem48xcgOUWwdXfZN3zS6YVdKy7pp
	yIIafaTgcoLhwB5FKosXge1UV5kEEFuOjWsx8ymeKejZiVMV9QnEQUJCOj+hNJQc
	48kUJIS4OwFwdc7usv+Zw==
X-ME-Sender: <xms:zAYWaedsIvVhMymcRHbxPns-YWGddKglCyyT7BLfEAv3PBZME49jLw>
    <xme:zAYWaTC8AuB5Ibtt7FJZj7TbzF7UX0gT4qhdXcy75S8_O8N0T1Wc7JdkG4U_8_hWW
    kpvMSTeVQk3GOevWt_FUJ2AiGoZsQRNhY1v4p7K_H1AtW3usHi9GI8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvtdejgedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepgfeiveevuedvkeeltdduieehgeekkeetheeuhefhvdeihfefjefhffdvtedttdfh
    necuffhomhgrihhnpehptghishhighdrtghomhdpkhgvrhhnvghlrdhorhhgnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhn
    uggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    jhhovgihrdhgohhulhihsegrrhhmrdgtohhmpdhrtghpthhtohepshhuiihukhhirdhpoh
    hulhhoshgvsegrrhhmrdgtohhmpdhrtghpthhtohephigrnhhghigttggttggtsehgmhgr
    ihhlrdgtohhmpdhrtghpthhtohepphhrihhmvgdriigvnhhgsehhihhsihhlihgtohhnrd
    gtohhmpdhrtghpthhtohepfigrnhhgiihhohhuudeshhhishhilhhitghonhdrtghomhdp
    rhgtphhtthhopeiguhifvghiheeshhhurgifvghirdgtohhmpdhrtghpthhtohephihuii
    gvnhhghhhuiheshhhurgifvghirdgtohhmpdhrtghpthhtohepmhgriieskhgvrhhnvghl
    rdhorhhg
X-ME-Proxy: <xmx:zAYWaSQh-VUXUXMuKp3YKXX49zc96e8ybu5KeSqtVRi-NGqS-GuFoA>
    <xmx:zAYWaUfAs0EZwWfmLsUhJ5XZXCpgQUn4BF39u9WtqlYVtlyIc5OqaA>
    <xmx:zAYWaTuLqsV3A1Hm_nT3-0anhLoaaMsJ34oAAJbycoX15Y0fZ_vwKg>
    <xmx:zAYWaYI93oTD6qaeLFmdZlMcrFpy9skIDJnqow082zg2CBrQdG1Xpg>
    <xmx:zQYWaSzSFz-TDnYp836JkDeyCCoj0TvI3ZZI8eS_Ii_Lv4E5qiUkMCUI>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E8E0E700054; Thu, 13 Nov 2025 11:26:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ThreadId: ALjut8WcExBk
Date: Thu, 13 Nov 2025 17:26:30 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Zhou Wang" <wangzhou1@hisilicon.com>, "Marc Zyngier" <maz@kernel.org>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Oliver Upton" <oliver.upton@linux.dev>,
 "Joey Gouly" <joey.gouly@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, "Yicong Yang" <yangyccccc@gmail.com>,
 prime.zeng@hisilicon.com, xuwei5@huawei.com
Message-Id: <c72411f9-a77e-4a72-a401-5110b919a2df@app.fastmail.com>
In-Reply-To: <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <861pm4vn02.wl-maz@kernel.org>
 <b1407660-9b69-7e21-328a-0f969fffa554@hisilicon.com>
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Nov 13, 2025, at 15:40, Zhou Wang wrote:
> On 2025/11/11 19:15, Marc Zyngier wrote:
>> On Fri, 07 Nov 2025 07:21:25 +0000,
>> 
>> But this doesn't mean that the system actually supports this. It is
>> also trivial for EL0 to spoof a PASID using ST64BV, by populating the
>> bottom 32bit with whatever it wants (hiding ST64BV0 doesn't prevent
>> this).
>
> I am confused here, we enable FEAT_LS64 and FEAT_LS64V in this patch,
> so only LD64B/ST64B/ST64BV are involved.
>
> Sending the value of ACCDATA(maybe a PASID) is defined in ST64BV0, which
> is not enabled currently.
>
> If a bad system implements ST64BV wrongly, isn't the fault of this bad
> system?

As far as I can tell, the design of ST64BV/ST64BV0 is a bit vague
on this, both on the Arm architecture and the PCI side [1], which each
leave the meaning of ACCDATA open to system design.

However, when the intention is to implement a shared hardware workqueue
in the style of drivers/dma/idxd/ [2], the only sensible implementation
is to follow the way that the corresponding Intel instructions work:

- movdir64b/st64b is a nonprivileged instruction to produce a posted
  atomic 64-byte write TLP to a PCIe device, which can only be used
  with a dedicated workqueue that is preconfigured to a fixed PASID

- enqcmds/st64bv is a privileged instruction to produce a non-posted
  atomic 64-byte write Deferrable Memory Write (DMWr) TLP, which can be
  used on a shared workqueue from kernel space, using an arbitrary PASID
  value per transaction, which would normally correspond to the
  physical address space when the kernel initiates DMA.

- enqcmd/st64bv0 is a nonprivileged instruction like enqcmds/st64bv
  using the pasid from accdata that corresponds to 
  current->mm->iommu_mm->pasid value [3] in the kernel for the task
  that initates the transaction in userspace.

A PCIe device can tell the difference between a posted write and a
non-posted DMWr, but it cannot tell the difference between st64bv
and st64bv0, so the kernel must disallow st64bv from userspace if
it can be used on a device that expects the PASID value in the
low bits.

Things would be different if there is a PCIe device that expects
a DMWr transaction but does not use it for a shared hardware
workqueue with the PASID in that field.

Are you using a particular device, or are you trying to enable
the support in general? If you have a specific device you are
working on, does it use the PASID data or not?

Things will clearly get a lot harder if we want to support a
system that can have devices with conflicting interpretations
of the ACCDATA value. Ideally we could always use the
iommu_mm->pasid value here and enable st64bv0 globally like
idxd does. If any devices requires the use of st64bv, that
would have to be mutually exclusive with another driver
handing out access to shared hardware workqueues.

     Arnd

[1] https://members.pcisig.com/wg/PCI-SIG/document/14237
[2] https://www.kernel.org/doc/html/v6.1/x86/sva.html
[3] drivers/iommu/iommu-sva.c
