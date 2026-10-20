Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=207.54.90.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792480829;
	b=EqDagmavPe6rPkIdhef6XOMjLqy7VUA2oPQ2w6oUlpvxyrpPa0UMUbikeaxrZ0OMjUkJ
	 2XAcgT+dUEejGUyUCtqpmezZgzsp9B3y+DqlGrw/BJrvyDjMCXWyF8iJklH+iyIFgE6nm
	 pyXj7AA1DDGyVHmtc6hEjqYByClfLsofEnwvn/wnsiIKzmkhHcF8hkZBL3LXla3aUQReB
	 R1or/xrmJVQq7xVPRfrHEM5CYyopxYgSugk0Xg7YyZjMr60s6JCK5Nf5gz83xpS1hB//g
	 KmV+rWjJdpki/itHnEjeYj7M0yxVdGHLcRuB1W4ZA9gJoYAneKq0UHaBTQathHwTN7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792480829;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=gTfcY3KbdiQmLNtrA7EgWSIO5XWoep6EANOAU6klbBo=;
	b=k4g5ddzyuHnYcelKXK2XDxV17A7ALhyEOuin/WBrnRGE3j8uI9A2FVFdpuwwbKNChDjq
	 2uKQtWPpK+avo2+w3YN+AmZnyT0jnl7363Vi7Px7qdDUpjSOXz54TjVashzWN4YuoeSpo
	 LWFD4src+AmvKbioJPJB09uy55asBItI/wjFv6GOYreydtZsPfjLAIwZlVt5W/wQYNqQa
	 xWRfE5BTNEDZ6GJkxURdZ78L5drM+cL0WlcIUgAzvKrAWhGl40L3SAAl49K1OhGpvejFv
	 KOoQOW1Pg+y+K83n/qZYLVF5vJahLdmg5i4lkL+4Yeq6stlKdXg0xEOyJZsRsD//E4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=f9Zno0Wq;
	arc=none smtp.remote-ip=207.54.90.47
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C37606A31B
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 07:20:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C37606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=f9Zno0Wq
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792480829; x=1824016829;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=refqq25nv2RRzQpG9iY5BlA9ExyL3HdRLNTWhTg6kFM=;
  b=f9Zno0Wq5iaLRHSyOfMv3M9jGsTEEmLU226RizcGN3EOG7XnZvvn9RLG
   G78YsWlMIrfudOCGVRN+PORrI/Bsmf3czX1jz/kvIsrBJxphJovQas5Ph
   vqeV0zqwd4RH7il996lkD3dqIfYRV/YEXEC4+nCdcEm8vf8XFm2YIqZCX
   qBDn4ugEKudd5Rbb7W3Sgt96+abvzjo3oytbuSbundGHZyU/rbikIkbQP
   s//7GbrDC0Hy5QFkrrS5PTxXHybQcr+7k5HEcyLDPBoFvXCx/KQMWyQ7S
   2AHakTuQNRRtYxqL4KePO+7MT0pxorwHhz9bx1cTXr8RjBmq+b4xRWvtW
   g==;
X-CSE-ConnectionGUID: h5nW5A4FSxid67NFJfvb+w==
X-CSE-MsgGUID: rF2BqvV4QgevoQxsJI5+UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="258794089"
X-IronPort-AV: E=Sophos;i="6.27,168,1786978800"; 
   d="scan'208";a="258794089"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 16:20:21 +0900
Received: from az2nlsmgm3.fujitsu.com (unknown [10.150.26.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id 1A29033FB
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 07:20:21 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (unknown [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm3.fujitsu.com (Postfix) with ESMTPS id C15B618026C7
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 07:20:20 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.226.149])
	by az2nlsmom4.fujitsu.com (Postfix) with SMTP id A09772000281;
	Tue, 20 Oct 2026 07:20:13 +0000 (UTC)
Date: Tue, 20 Oct 2026 16:20:12 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Tomohiro Misono <misono.tomohiro@fujitsu.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 4/4] irqchip/gicv3: Add workaround for FUJITSU-MONAKA
 erratum E#030003
Message-ID: <atcTtojPd1BSS8fr@FCCLS0092175.localdomain>
References: <20261016-monaka-fix-for-upstream-v2-0-fc7ede7f9f48@fujitsu.com>
 <20261016-monaka-fix-for-upstream-v2-4-fc7ede7f9f48@fujitsu.com>
 <87wlrg8qc7.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87wlrg8qc7.wl-maz@kernel.org>

On 10/17 13:27, Marc Zyngier wrote:
> On Fri, 16 Oct 2026 11:00:48 +0100,
> Tomohiro Misono <misono.tomohiro@fujitsu.com> wrote:
> > 
> > From: Kohei Enju <enju.kohei@fujitsu.com>
> > 
> > On affected FUJITSU-MONAKA CPUs, the erratum may occur when an SGI is
> > generated by writing to ICC_SGI0R_EL1, ICC_SGI1R_EL1, or ICC_ASGI1R_EL1,
> > if the operation races with CPU interface processing triggered by the
> > arrival of a higher-priority interrupt, an update to a pending
> > interrupt, or a transition of the PE to the Sleep state. When the
> > erratum occurs, the SGI is lost and the system register write does not
> > complete, causing the issuing core to hang.
> > 
> > Guest accesses to these registers are not affected by this erratum, as
> > they are trapped to EL2 and handled without issuing the affected system
> > register write.
> > 
> > Work around the erratum by writing 1 to the bit corresponding to the
> > target SGI INTID in GICR_ISPENDR0 of each target PE's GIC Redistributor,
> > instead of writing to the affected system registers.
> > 
> > Accessing a target PE's GICR_ISPENDR0 requires its Redistributor base to
> > have been discovered. Affected platforms conform to SBBR, which requires
> > PSCI for secondary CPU boot. They therefore do not use the ACPI Parking
> > protocol, which sends an IPI before the secondary CPU has initialized
> > its Redistributor. With PSCI, a secondary CPU discovers its
> > Redistributor before becoming an IPI target.
> > 
> > Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> 
> You are posting a patch on behalf of someone else, you need to add
> your own SoB:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v7.3-rc7#n448

Thanks for pointing this out. I'll let Tomohiro know.

> 
> > ---
> > Changes in v2:
> > - Clarify the erratum description and document that virtual accesses are
> >   unaffected.
> > - Remove the gic_send_sgi_via_rdist() helper.
> > - Remove the write-count rationale.
> > - Use the CPU MIDR instead of the SoC ID for filtering.
> > 
> > Note that I have left the dsb(st) after the GICR_ISPENDR0 writes
> > unchanged, pending clarification of the required completion point. If
> > the writes must be observed by a specific component before
> > gic_ipi_send_mask() returns, I will use the appropriate mechanism to
> > provide that guarantee.
> 
> See below.
> 
> [...]
> 
> > @@ -1386,6 +1391,17 @@ static void gic_ipi_send_mask(struct irq_data *d, const struct cpumask *mask)
> >  	 */
> >  	dsb(ishst);
> >  
> > +	if (static_branch_unlikely(&gic_fujitsu_030003_erratum)) {
> > +		for_each_cpu(cpu, mask) {
> > +			void __iomem *base = gic_data_rdist_sgi_base_cpu(cpu);
> > +
> > +			writel_relaxed(BIT(d->hwirq), base + GICR_ISPENDR0);
> > +		}
> > +
> > +		dsb(st);
> 
> What is this DSB achieving? As far as I can tell, not much. The memory
> type is nGnRE, so DSB doesn't force writes to reach the end-point, and
> only guarantee ordering that system register SGI generation doesn't
> provide.

Yes, you're right.

> 
> So either
> 
> (a) there is a functional requirement on this HW to have a DSB, and
>     needs to be documented,
> 
> (b) or there is a need for end-point synchronisation, which needs to
>     be enforced by a read back (knowing that the sysreg doesn't
>     provide this guarantee), and this needs to be documented,
> 
> (c) or this is completely superfluous and can be dropped
> 
> Which case are we in?

I think this falls under (c). As far as I can tell, there is no
requirement for ipi_send_mask() to wait for the writes to be observed by
the hardware. I'm not aware of any hardware-specific requirements for
this DSB either. I'll drop the DSB and test the change on our hardware.

Thanks,
Kohei
