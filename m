Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C04C5464D;
	Fri, 24 Jul 2026 15:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784907513; cv=none; b=Ma5qCJaamEpDzMqWUh1d36m2aQrwIWlt2NOIdFLin/nu5qcxyMI2yn96Mk1SxiA+1W5hLXinmxjR6lGNq27TeK9wO3tFcU7XgTddNImXrwpUO08EN2U38/i2IiNw8UfOvZvFTASBXrmn836HOJPlopT1zeebqx921MnRrNYKLPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784907513; c=relaxed/simple;
	bh=STe3l81ZzYWmrYt3MRzUBujSbUlThRL6gf8a/dbofg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MAwk6zdp8nGuo1bKvJnS+6XJSX+VaC3cntOQR850gB5UqSkrRQtnW8I+SlDKOEhfmKnHAB/wXIrtHZ5CDJlKSBy/AK9Rs/yoXnjkVQm4ej3KsHaFT5N4m8imLgENWwWT4jrcOFCMeyKHLHFMEFWxKJLfUh58uqYebZuWMMxKRU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=l2SKkJSB; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="l2SKkJSB"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1784907512; x=1816443512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=STe3l81ZzYWmrYt3MRzUBujSbUlThRL6gf8a/dbofg4=;
  b=l2SKkJSB+Z/B1F3Vxu+jZj4/Y6xE7+zlRV5rXiqZzZRj9AbI1VNaNPDK
   9CDK0TDLULBtwhe510KRCuTTqyp1l2lq9ZqpRUF1fm+L0SH2iC538+etZ
   nJ3cjLDl+cTODsVNRS68/xtyH90KV0rF0SzwAFFk78xT0aDVr0SDWIVne
   rRQTKAAvYjXcO/i7nQft5Zbb8O6LMidZm2ULGkAVv8rSa0TK/T7Dv470t
   JCm81rtqns8brg2Pdf1fC5k4Qns44P7yuvmCJCO8oJkgTn5THr8CzC7du
   jM1JajH1Ar2kLqiDCtQAhpGcghwuE8gfgdlwmnHN4EGZyYY5WuAx0CHDZ
   Q==;
X-CSE-ConnectionGUID: 7OkvkYffQqCetytVEms42Q==
X-CSE-MsgGUID: eGcAdFcOS0GZ5eH3nXvAlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="246657630"
X-IronPort-AV: E=Sophos;i="6.25,182,1779116400"; 
   d="scan'208";a="246657630"
Received: from gmgwnl01.global.fujitsu.com ([52.143.17.124])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2026 00:38:24 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id E8F8A42A312;
	Fri, 24 Jul 2026 15:38:23 +0000 (UTC)
Received: from az2uksmom2.o.css.fujitsu.com (unknown [10.151.22.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id A01F7C09353;
	Fri, 24 Jul 2026 15:38:23 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.9.54.178])
	by az2uksmom2.o.css.fujitsu.com (Postfix) with ESMTP id CCF811400248;
	Fri, 24 Jul 2026 15:38:17 +0000 (UTC)
Date: Sat, 25 Jul 2026 00:38:10 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, cgroups@vger.kernel.org, linux-coco@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH v1 2/2] cgroup/misc: Add support for Arm CCA MECIDs
Message-ID: <amOCt4r72ge-Iw5h@FCCLS0092175.localdomain>
References: <20260724094120.166536-1-enju.kohei@fujitsu.com>
 <20260724094120.166536-3-enju.kohei@fujitsu.com>
 <amNfGkkI5OIBqpmZ@localhost.localdomain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amNfGkkI5OIBqpmZ@localhost.localdomain>

On 07/24 14:52, Michal Koutný wrote:
> Hello Kohei.
> 
> On Fri, Jul 24, 2026 at 06:40:56PM +0900, Kohei Enju <enju.kohei@fujitsu.com> wrote:
> > Arm CCA MECIDs are limited platform resources. Add a misc cgroup
> > resource to allow the system administrator to account for and limit
> > their use.
> > 
> > The cca_mec resource represents the number of Realm VMs using the
> > private MEC policy. Each such Realm consumes one MECID. Charge the
> > resource when the Realm is created, and uncharge it when the Realm is
> > successfully destroyed.
> > 
> > Realms using the shared MEC policy don't consume this resource.
> > 
> > Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
> > ---
> >  arch/arm64/include/asm/kvm_rmi.h |  2 ++
> >  arch/arm64/kvm/rmi.c             | 44 +++++++++++++++++++++++++++++++-
> >  drivers/firmware/arm_rmm/rmi.c   |  4 +++
> 
> (mainly for this)
> >  include/linux/misc_cgroup.h      |  4 +++
> >  kernel/cgroup/misc.c             |  4 +++
> >  5 files changed, 57 insertions(+), 1 deletion(-)
> 
> Conditional
> Acked-by: Michal Koutný <mkoutny@suse.com>
> (it makes sense along the other arches' miscresurces)

Hi Michal,
Thank you for taking a look.

> 
> Why? I see this [1] (or followup) needs to be added first.

Yes, [1] should be added first.
As also stated in the coverletter, the following series is anothor
dependency, because this RFC series is on top of those other series.
https://lore.kernel.org/all/20260715142841.80544-1-steven.price@arm.com/

The [1] series is a dependency of the one above, and I didn't mention it
explicitly in the cover letter. My bad.

My intention was to get feedback on this RFC series about the
architecture and the basic design until those dependent series are
merged, after which I will send this series as non-RFC.

Thanks,
Kohei

> 
> Thanks,
> Michal
> 
> [1] https://lore.kernel.org/r/20260715142739.80398-4-steven.price@arm.com/


