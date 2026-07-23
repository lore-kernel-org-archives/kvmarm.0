Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29305175A7D;
	Thu, 23 Jul 2026 06:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784788785; cv=none; b=DmqUv5iwqkBmhqZJJyz4b0vjZROdTXX7pXWweRkK4+GORTI+CvHXKIxKK+j9V39xOL3OZBBNWbuja8juT2BIt68E8ZcdborfWF68tsfvmqXEOEsQAc/VlONKpjMgRm1nXIB2WilpCT5tepk5Et1nk2BfTEK9F8E3aKeiu/l4/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784788785; c=relaxed/simple;
	bh=payJ3POf8Eo8bsLxE8/JrwlXF6UVj18G9W8zHieXETk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SblwWw5Jvmes+qgDxblxmMhi9rPWxKf7Z81x/E4McYSDRAluB9fgLywv+CJ7IQGG/FmfBI+XLg6F3r5pCGhMB8hXjCaMFQW8uHs5kKgpodNl9PE6nZ2vqj7/orX//CBTnO2X2l+6aXwwoxzgeVPlWCCBE61Ku1Chn6ALw+qd5Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=hTMyS3+Q; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="hTMyS3+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784788786; x=1816324786;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=payJ3POf8Eo8bsLxE8/JrwlXF6UVj18G9W8zHieXETk=;
  b=hTMyS3+QIerG5potnVft9uOm1UAbox7f7ZUbGGKRCUYrzlKqmK3vveHa
   pyWeRvblCNxRv8bO08rMVeCMPMQYTlvbqhlK2tDswseMiBVbExYHBw7Zs
   pPR3SvPYL2KVPVmWXcm7Qq738U66f23yaZ+dvsoZVutSoQ+2JJjEghn27
   OE48x/Gxw7vvwqH+sVjHL/cS5igVw5HM8F2QixTUjy+mkAcsqwPJAhd4B
   bbXMQGL+TqH1ijRZqtmHBaz5PZ0ms2QB1a4VigdQOJcmsioXCof39Dic/
   u+K3J8q8x0+WsC+sgeSy1JUmZdpeoEXunEAP3wBnGpiKGcYu5OBFJMP5/
   Q==;
X-CSE-ConnectionGUID: 3s2iGWesSAeNLtZNzmNNeQ==
X-CSE-MsgGUID: MZW9sqVLTYaR7qpI4k+rVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="246483168"
X-IronPort-AV: E=Sophos;i="6.25,180,1779116400"; 
   d="scan'208";a="246483168"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 15:38:35 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id C34D08203D5;
	Thu, 23 Jul 2026 06:38:32 +0000 (UTC)
Received: from az2nlsmom2.o.css.fujitsu.com (unknown [10.150.26.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 75CA6C06082;
	Thu, 23 Jul 2026 06:38:32 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.10.80.137])
	by az2nlsmom2.o.css.fujitsu.com (Postfix) with SMTP id C57BB1802ED6;
	Thu, 23 Jul 2026 06:38:23 +0000 (UTC)
Date: Thu, 23 Jul 2026 15:38:16 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v15 12/37] KVM: arm64: CCA: Support the VGIC in realms
Message-ID: <amGwgAfHWX2P9pZx@FCCLS0092175.localdomain>
References: <20260715142841.80544-1-steven.price@arm.com>
 <20260715142841.80544-13-steven.price@arm.com>
 <amB-opawGgF6jNHB@FCCLS0092175.localdomain>
 <86cxwfe5m8.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86cxwfe5m8.wl-maz@kernel.org>

On 07/22 10:27, Marc Zyngier wrote:
> On Wed, 22 Jul 2026 09:27:29 +0100,
> Kohei Enju <enju.kohei@fujitsu.com> wrote:
> > 
> > On 07/15 15:28, Steven Price wrote:
> > > The RMM provides emulation of a VGIC to the realm guest. With RMM v2.0
> > > the registers are passed in the system registers so this works similar
> > > to a normal guest, but kvm_arch_vcpu_put() need reordering to early out,
> > > and realm guests don't support GICv2 even if the host does.
> > > 
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > 
> > Hi Steven,
> > 
> > I've been testing this series and found that when the host CPU doesn't have
> > ARM64_HAS_ICH_HCR_EL2_TDIR this series doesn't work as expected.
> 
> What modern CPU doesn't support TDIR? The only CPUs I know of that are
> stuck in this mode are old ARMv8.0 CPUs, and anything else was fixed.

Hi Marc, thank you for the response.

I'm afraid I can't share the details due to my company's policy, but at
least I happen to be testing on such a system.

> 
> > 
> > Since commit 2a28810cbb8b ("KVM: arm64: GICv3: Detect and work around the lack
> > of ICV_DIR_EL1 trapping"), when the host CPU doesn't support this feature, KVM
> > traps all GIC sysreg accesses in the common group. However, currently trap
> > handlers for ICC_{PMR,RPR,CTLR}_EL1 registers are missing [0]. So when Realm
> > guests try to access those registers, KVM traps them but just emits the warning
> > shown in [1], and Realm guests fail to boot.
> 
> This isn't missing. This is handled by the early emulation in
> vgic-v3-sr.c, which of course CCA completely bypasses. Too bad.

That makes sense.

> 
> > 
> > As far as I can tell, the CCA requirements don't require the
> > ARM64_HAS_ICH_HCR_EL2_TDIR feature. If that's the case, this seems to be a
> > problem. Is there any workaround for this issue, or should we implement trap
> > handlers for those registers?
> 
> No. Either you support TDIR, like any modern CPU, or you don't run
> CCA. I'm not adding yet another level of emulation for this.

However, I'm still not aware of any requirement in the CCA architecture,
or in Armv8-A/Armv9-A, that mandates TDIR support.

When you say "you don't run CCA", is that because the architecture
requires it, or because that's the current KVM policy? If it's the
latter, we'd be interested in adding the required emulation to make it
work.

Thanks,
Kohei

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
> 
