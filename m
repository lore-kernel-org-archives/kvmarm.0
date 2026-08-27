Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653BB4582EB;
	Thu, 27 Aug 2026 12:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834810; cv=none; b=f8BJBs8PjqwOXTOGD0FRLyicB00YvhogRWfhgjFU/ZO1h9Bt+8H0F8LcV2/kY5lO28g5nKviAs5Nr0LtkmwpK2j4BAZjblPTwzbUJKzGqHIUEGXcVC00QB1iuhW+OTeHnt4iSqUHlGZWTsB8KMBV6eOc8Sck0BcXkOOVr8n8gSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834810; c=relaxed/simple;
	bh=yhLGac+hnxttD0mvPQYVOBAXrJFS7tYd78dMHRj3ECw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sVuD5+LzoH8dVO+Iqank/GzpxmC/wO2ONSI/j+BCr1lo3hJQSHD3xMzXJkibjv1U2Zo9u6H+XcuPF/P5LOtrbjKJIPRC5XhynhB3E2+7zXvbHY8CdcJxMLxzmvBij9n+EAVJ7pPoak9DgrJHQuVmeGkqCiM1tP/7QnZe82shUu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=BA4UK59n; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="BA4UK59n"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1787834806; x=1819370806;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yhLGac+hnxttD0mvPQYVOBAXrJFS7tYd78dMHRj3ECw=;
  b=BA4UK59n7NJS28wCnxoyRP8KpY0mRDVbmMKA+IvFt1GnuaUDCxSX3Jha
   rWzvMEU55MSpzHI4lyUgFSiCNvW7SffrARXNGEq7evm6n4Og/SRt9EhhF
   ZT1eut/yfsKL+B4snascy9Z/NZT3P1n4Z6vn2Z9xf1mPQFFwhV6Pd8XsQ
   54gRfcgRiY9njwdbq4y90nyusv/goY5ZH65sKD85KD6Pdw41/SgFLo68E
   uRlQ/UuqCYZsm/FGJzdQImrFYqr0hKTQ7qopNgBiaD4DKBgU0ji2ouZ3D
   nh7dM2HdndCTfC9WsgDZO1LwSbBcvv37miK6NVd569w/Uz9CG6ADJtRF8
   A==;
X-CSE-ConnectionGUID: yonyhMeyTlSoMvyXLtH3EA==
X-CSE-MsgGUID: y7QxqrSCQ6ytjZrCef+kFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="239076453"
X-IronPort-AV: E=Sophos;i="6.25,246,1779116400"; 
   d="scan'208";a="239076453"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 21:45:28 +0900
Received: from az2uksmgm2.o.css.fujitsu.com (unknown [10.151.22.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 0417FC006EC;
	Thu, 27 Aug 2026 12:45:28 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (unknown [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id B1BE61800245;
	Thu, 27 Aug 2026 12:45:27 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.202.6])
	by az2uksmom3.o.css.fujitsu.com (Postfix) with SMTP id DB97610000B4;
	Thu, 27 Aug 2026 12:45:19 +0000 (UTC)
Date: Thu, 27 Aug 2026 21:45:17 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH v16 44/45] KVM: arm64: CCA: Require ICH_HCR_EL2.TDIR for
 realms
Message-ID: <apAwQeTW-JvCISEt@FCCLS0092175.localdomain>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-45-steven.price@arm.com>
 <anlZCIauOq4Lvv0I@FCCLS0092175.localdomain>
 <bdd0cf41-05e8-4d66-930b-5a7a1b3e643a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bdd0cf41-05e8-4d66-930b-5a7a1b3e643a@arm.com>

On 08/24 15:50, Steven Price wrote:
> On 10/08/2026 05:58, Kohei Enju wrote:
> > On 08/03 14:44, Steven Price wrote:
> >> KVM advertises realm support when the RMM is available, and allows
> >> userspace to create a VM with KVM_VM_TYPE_ARM_REALM on that basis.
> >>
> >> On CPUs that lack ICH_HCR_EL2.TDIR, KVM uses ICH_HCR_EL2.TC for
> >> normal guests so that ICC_DIR_EL1 is still trapped via the common GICv3
> >> CPU interface trap. Realms cannot rely on the normal hyp-side trap
> >> handling for that fallback, so advertising RMI support on such systems
> >> lets userspace create a realm that cannot safely run.
> >>
> >> Require the finalized ARM64_HAS_ICH_HCR_EL2_TDIR capability when
> >> reporting KVM_CAP_ARM_RMI and when accepting KVM_VM_TYPE_ARM_REALM.
> >> This leaves normal VM creation unchanged on systems that need the TC
> >> workaround.
> > 
> > Hi Steven,
> 
> Hi Kohei,
> 
> Sorry for the slow response.
> 
> > Thanks for your work on upstreaming CCA.
> > 
> > In the v15 discussion [0], you asked whether the system I was testing was a
> > "hacked up test system" or closer to "production hardware", and I said I would
> > share more when the time came. I can now say that this is not a hacked-up test
> > system. At Fujitsu, we have real hardware (FUJITSU-MONAKA) which implements CCA
> > (FEAT_RME) but does not implement FEAT_GICv3_TDIR. The hardware details are as
> > follows:
> 
> Cool, I suspected that might be the case - it's good to know there's
> real hardware on it's way.
> 
> >   - GICv4.2 compliant implementation
> >   - Supports FEAT_GICv3, FEAT_GICv3p1, FEAT_GICv4, FEAT_GICv4p1, and FEAT_GICv3_NMI
> >   - Does not support FEAT_GICv3_LEGACY (deprecated)
> >   - Does not support FEAT_GICv3_TDIR (ICH_VTR_EL2.TDS == 0)
> > 
> > For reference, compared with Arm Neoverse V3, the virtual GIC configuration is
> > largely equivalent. The only missing non-deprecated architectural feature is
> > FEAT_GICv3_TDIR.
> > 
> > The issue I see is that the CCA KVM code currently does not support a
> > configuration (non-TDIR/common-trap) that normal KVM already supports. For
> > normal guests, KVM handles systems without TDIR by using ICH_HCR_EL2.TC and the
> > existing GICv3 CPU interface emulation path. However, Realm guests currently
> > fail because the CCA path bypasses that existing emulation path, as Marc also
> > pointed out in [1].
> > 
> > Also, this is not limited to systems that actually lack TDIR. The same failure
> > can be reproduced on a TDIR-capable system by booting with:
> >   kvm-arm.vgic_v3_common_trap=1
> 
> As Marc says that's a debugging option - handy for those of us who don't
> have a platform without TDIR to test with.
> 
> > So it seems that the current CCA KVM implementation does not yet cover a
> > configuration that normal KVM already supports today, rather than this being a
> > limitation of the RMM specification or the underlying hardware.
> > 
> > I've included a patch below which reuses the existing GICv3 early emulation
> > path for Realm sysreg exits. This patch does not add any new vGIC emulation
> > code, and leaves the existing vGIC emulation code unchanged. So I believe this
> > is in line with Marc's request in [1]. With this patch, Realm guests can run
> > when the common CPU interface trap path is enabled.
> > 
> > I tested the exact patch both on our real silicon and on QEMU, and
> > confirmed that all Realm-related tests in kvm-unit-tests-cca passed.
> > 
> > I'm not attached to this exact implementation, and I'm happy if the solution is
> > reworked to better fit into the next revision. 
> > 
> > Given that this configuration can be supported by reusing the existing KVM
> > emulation infrastructure, I think it would be reasonable for CCA to support the
> > non-TDIR/common-trap configuration rather than requiring ICH_HCR_EL2.TDIR
> > unconditionally for Realm support. 
> > 
> > Supporting this configuration would also allow us to validate the upstream CCA
> > KVM implementation on real silicon using upstream code paths, and contribute
> > additional real-hardware testing coverage as the implementation
> > evolves.
> > 
> > I'd be very interested in hearing your thoughts.
> 
> So personally I think your patch is a good compromise. It gets the
> hardware working and I'm keen to enable real-hardware testing. Marc has
> a very valid point that in terms of performance this could be very bad.
> Pseudo NMI in particular will be terrible because accesses to GIC
> registers are used to "emulate" the NMI so the number of traps will be
> large, and the traps are much more expensive with CCA.

Yes, in that case ICV_PMR_EL1 would be accessed frequently, and the
resulting traps would be expensive.

> 
> So I'll attempt to incorporate the changes in your patch, but obviously
> you'll have to decide for yourself whether the performance of the
> product is suitable.

Thanks for the clarification.

I agree with the performance concern, and I'll run some benchmarks on
our hardware.

Thanks,
Kohei

> 
> Thanks,
> Steve
> 
