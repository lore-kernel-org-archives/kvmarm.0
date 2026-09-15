Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518143BBFBA;
	Tue, 15 Sep 2026 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475055; cv=none; b=EZJiZWr3Pp7iljjnOuc3jPmxdY6C8FmC2ZzfWt6LsT/2CDMgwhFXk7AY2mR57y7Q8Q7Kb64UH0yMP82s9x+tFQHP4bklqRQFhSJz/Lk2MOoW98lU06fOV12PYKqwgUMPwZIQ1S2MeOCVEMqOfK5QQPLJ0iNJuEcZu3XGSl6wSgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475055; c=relaxed/simple;
	bh=18Wi83CNhlzACjOHe6SRF3KvHUzXVD4Y+YHs4xCXX7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToOOkIA66+Z7gVi2sG5E0V9nIql7Tsj6V2SHTCAFkSFfAdMp2sGCq2dvLMj/XKoQ4K9OI8icKPrcm09uYZLQwvVV/CFUFOJrQIx+5Z0rjoOl5z/Uux0qf+vtGikSjCHX0+PdQgXqJRK3Q6FYsT5K+K44ByA/lNa3LvHwCijKe/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=nZ3auYnZ; arc=none smtp.client-ip=139.138.36.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="nZ3auYnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1789475053; x=1821011053;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=18Wi83CNhlzACjOHe6SRF3KvHUzXVD4Y+YHs4xCXX7M=;
  b=nZ3auYnZoaLi+17E4O3zAZ/IlF98DKgpYOmu9Y9Ru/eNRlDlfcEmuixW
   m8x0sy4HCWYlzoLOiqYFE5t0Zb/98JGsny6cau11lz6e48VbGAW4R3IxC
   Ybxl3JCrPHuGqi/ZeRtmyONu9xMfnc4Iqt9AM/Xs2oIyvl9/VsGavu8Ph
   qL/d9vj4i1SLE/wcdxrRPo7EHP+wXcBWJj9J7p+JvWeLvis91yi6a0bNa
   YyeYZoni7f0AMWkYvGhr3KZFSNZ5mnDqbhBY2uGtAi/w+K2mGMh0pRt5i
   qKmXo25KEx1P4KIjfxcs5hAV6P+AwPlvcGbKf5ETINLcwwfLhPFbSMYu2
   g==;
X-CSE-ConnectionGUID: AzkrH6sqSwSK0GI879xs2w==
X-CSE-MsgGUID: ypxWjfw8SbCVC5xX/7jEsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="242628484"
X-IronPort-AV: E=Sophos;i="6.27,103,1786978800"; 
   d="scan'208";a="242628484"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 21:24:06 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id 63B87C020E9;
	Tue, 15 Sep 2026 12:24:06 +0000 (UTC)
Received: from az2uksmom1.o.css.fujitsu.com (unknown [10.151.22.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 19A768D29E1;
	Tue, 15 Sep 2026 12:24:06 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.185.122])
	by az2uksmom1.o.css.fujitsu.com (Postfix) with SMTP id EE8BE1800156;
	Tue, 15 Sep 2026 12:23:57 +0000 (UTC)
Date: Tue, 15 Sep 2026 21:23:49 +0900
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
Message-ID: <aqk4TTHgBiKUvvew@FCCLS0092175.localdomain>
References: <20260803134403.80630-1-steven.price@arm.com>
 <20260803134403.80630-45-steven.price@arm.com>
 <anlZCIauOq4Lvv0I@FCCLS0092175.localdomain>
 <bdd0cf41-05e8-4d66-930b-5a7a1b3e643a@arm.com>
 <apAwQeTW-JvCISEt@FCCLS0092175.localdomain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apAwQeTW-JvCISEt@FCCLS0092175.localdomain>

On 08/27 21:45, Kohei Enju wrote:
> On 08/24 15:50, Steven Price wrote:
> > On 10/08/2026 05:58, Kohei Enju wrote:
> > > On 08/03 14:44, Steven Price wrote:
> > >> KVM advertises realm support when the RMM is available, and allows
> > >> userspace to create a VM with KVM_VM_TYPE_ARM_REALM on that basis.
> > >>
> > >> On CPUs that lack ICH_HCR_EL2.TDIR, KVM uses ICH_HCR_EL2.TC for
> > >> normal guests so that ICC_DIR_EL1 is still trapped via the common GICv3
> > >> CPU interface trap. Realms cannot rely on the normal hyp-side trap
> > >> handling for that fallback, so advertising RMI support on such systems
> > >> lets userspace create a realm that cannot safely run.
> > >>
> > >> Require the finalized ARM64_HAS_ICH_HCR_EL2_TDIR capability when
> > >> reporting KVM_CAP_ARM_RMI and when accepting KVM_VM_TYPE_ARM_REALM.
> > >> This leaves normal VM creation unchanged on systems that need the TC
> > >> workaround.
> > > 
> > > Hi Steven,
> > 
> > Hi Kohei,
> > 
> > Sorry for the slow response.
> > 
> > > Thanks for your work on upstreaming CCA.
> > > 
> > > In the v15 discussion [0], you asked whether the system I was testing was a
> > > "hacked up test system" or closer to "production hardware", and I said I would
> > > share more when the time came. I can now say that this is not a hacked-up test
> > > system. At Fujitsu, we have real hardware (FUJITSU-MONAKA) which implements CCA
> > > (FEAT_RME) but does not implement FEAT_GICv3_TDIR. The hardware details are as
> > > follows:
> > 
> > Cool, I suspected that might be the case - it's good to know there's
> > real hardware on it's way.
> > 
> > >   - GICv4.2 compliant implementation
> > >   - Supports FEAT_GICv3, FEAT_GICv3p1, FEAT_GICv4, FEAT_GICv4p1, and FEAT_GICv3_NMI
> > >   - Does not support FEAT_GICv3_LEGACY (deprecated)
> > >   - Does not support FEAT_GICv3_TDIR (ICH_VTR_EL2.TDS == 0)
> > > 
> > > For reference, compared with Arm Neoverse V3, the virtual GIC configuration is
> > > largely equivalent. The only missing non-deprecated architectural feature is
> > > FEAT_GICv3_TDIR.
> > > 
> > > The issue I see is that the CCA KVM code currently does not support a
> > > configuration (non-TDIR/common-trap) that normal KVM already supports. For
> > > normal guests, KVM handles systems without TDIR by using ICH_HCR_EL2.TC and the
> > > existing GICv3 CPU interface emulation path. However, Realm guests currently
> > > fail because the CCA path bypasses that existing emulation path, as Marc also
> > > pointed out in [1].
> > > 
> > > Also, this is not limited to systems that actually lack TDIR. The same failure
> > > can be reproduced on a TDIR-capable system by booting with:
> > >   kvm-arm.vgic_v3_common_trap=1
> > 
> > As Marc says that's a debugging option - handy for those of us who don't
> > have a platform without TDIR to test with.
> > 
> > > So it seems that the current CCA KVM implementation does not yet cover a
> > > configuration that normal KVM already supports today, rather than this being a
> > > limitation of the RMM specification or the underlying hardware.
> > > 
> > > I've included a patch below which reuses the existing GICv3 early emulation
> > > path for Realm sysreg exits. This patch does not add any new vGIC emulation
> > > code, and leaves the existing vGIC emulation code unchanged. So I believe this
> > > is in line with Marc's request in [1]. With this patch, Realm guests can run
> > > when the common CPU interface trap path is enabled.
> > > 
> > > I tested the exact patch both on our real silicon and on QEMU, and
> > > confirmed that all Realm-related tests in kvm-unit-tests-cca passed.
> > > 
> > > I'm not attached to this exact implementation, and I'm happy if the solution is
> > > reworked to better fit into the next revision. 
> > > 
> > > Given that this configuration can be supported by reusing the existing KVM
> > > emulation infrastructure, I think it would be reasonable for CCA to support the
> > > non-TDIR/common-trap configuration rather than requiring ICH_HCR_EL2.TDIR
> > > unconditionally for Realm support. 
> > > 
> > > Supporting this configuration would also allow us to validate the upstream CCA
> > > KVM implementation on real silicon using upstream code paths, and contribute
> > > additional real-hardware testing coverage as the implementation
> > > evolves.
> > > 
> > > I'd be very interested in hearing your thoughts.
> > 
> > So personally I think your patch is a good compromise. It gets the
> > hardware working and I'm keen to enable real-hardware testing. Marc has
> > a very valid point that in terms of performance this could be very bad.
> > Pseudo NMI in particular will be terrible because accesses to GIC
> > registers are used to "emulate" the NMI so the number of traps will be
> > large, and the traps are much more expensive with CCA.
> 
> Yes, in that case ICV_PMR_EL1 would be accessed frequently, and the
> resulting traps would be expensive.
> 
> > 
> > So I'll attempt to incorporate the changes in your patch, but obviously
> > you'll have to decide for yourself whether the performance of the
> > product is suitable.
> 
> Thanks for the clarification.
> 
> I agree with the performance concern, and I'll run some benchmarks on
> our hardware.

Hi Steven and Marc,

Sorry for the late response.

The results confirm your concern. Our initial hackbench measurements showed
considerable performance overhead for the non-TDIR Realm configuration with
pseudo-NMI enabled. Due to restrictions on disclosing performance data for our
hardware, I cannot share the absolute results or further platform details.

However, with pseudo-NMI disabled, performance was comparable to the
TDIR-capable configuration. The difference was at most a few percent across
runs.

There is a real need to run Realm VMs in environments that do not require
pseudo-NMI, and non-TDIR hardware can meet that need. Pseudo-NMI is not enabled
by default in many commonly used distributions, and native NMI support through
FEAT_NMI may also reduce the need for pseudo-NMI in the near future. As a
result, the number of use cases in which the observed performance limitation is
relevant is likely to decrease. Therefore, the pseudo-NMI result does not
necessarily make non-TDIR Realm support impractical for all current or future
use cases.

Note that the initial measurements used pre-production versions of TF-RMM and
TF-A. During our evaluation, we applied preliminary tuning to these firmware
components and have already observed substantial performance improvements.

For the production release of our hardware, we plan to further tune the
software stack, including these firmware components, together with the hardware
configuration. We therefore believe that there remains meaningful room for
further performance improvement, although we cannot yet quantify the final
improvement.

I agree that non-TDIR has a performance limitation for trap-intensive
configurations. However, given the actual customer demand for running CCA
workloads that do not require pseudo-NMI, I believe that supporting Realm VMs
on non-TDIR hardware still has clear practical value. It would also allow us to
accelerate validation of the upstream CCA KVM implementation on real silicon
using upstream code paths and contribute additional real-hardware test coverage
as the implementation evolves.

Thanks,
Kohei

> 
> Thanks,
> Kohei
> 
> > 
> > Thanks,
> > Steve
> > 
