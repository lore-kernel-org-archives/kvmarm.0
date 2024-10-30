Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5BC8F58
	for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 04:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730262822; cv=none; b=bbZn73qCwPjrjSNYNN7CkaivrBfZcShFh7F1D26DNpGCswWyTUisMUoVA+Tshm34MG3S93u1OdFFQ4uChWSYoH+97r7AzN6GVJmSOIL17jsepSz3a0kYTCiD6nbUCCC1jy1PBrzhtVsmMiJzH9YdhM1uN6+PK3YdnO/5TDNTxUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730262822; c=relaxed/simple;
	bh=3XtaH1BiWzirciy/LORb2lh4SJeC3+q/sIRLiQuMCxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuqzSHU0FyyTyGVzXoSZMHuWEmZEBd+i5X3NQN08Z4dZi5+q59HWaIaGasoZlK3pytnlw27zeJdEkzJOfquAWUuvtuDZU9Z82GMsP6ts8BTW8jdvZTBcYHTV56LuGI3COA+9itc/E+OtMqhHQbRYMBqxYZbgojhby8WyvFQ/aPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I0Kvuc9+; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I0Kvuc9+"
Date: Tue, 29 Oct 2024 21:33:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730262814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EtDw6vWJIIC3gJtRYGxss7dFOHsmI80k8IdsIMFE7QA=;
	b=I0Kvuc9+ckIDmK+mwbhgcipc+bnKkkO7Hjh0aDrfZHMDtSzAg1EJwnzXJ740zoLli84GEo
	hGJgagWNyszpE1TZS+XUSQuq33DAMIurCnnxbniJx8d/0tOBiJkhI+wNHSpVkqx4559v69
	n8Qr42y/l61lHHbUECsQqtKXRzdQxyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"maz@kernel.org" <maz@kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"cohuck@redhat.com" <cohuck@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	yuzenghui <yuzenghui@huawei.com>,
	"Wangzhou (B)" <wangzhou1@hisilicon.com>,
	jiangkunkun <jiangkunkun@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Anthony Jebson <anthony.jebson@huawei.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>
Subject: Re: [RFC PATCH v2 3/3] KVM: arm64: Enable errata based on migration
 target CPUs
Message-ID: <ZyG3FiUiyOi4t3rQ@linux.dev>
References: <20241024094012.29452-1-shameerali.kolothum.thodi@huawei.com>
 <20241024094012.29452-4-shameerali.kolothum.thodi@huawei.com>
 <Zxr2JMNzOWT3zPWH@linux.dev>
 <0a23971725644a9bbfe7ec60b5e05033@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a23971725644a9bbfe7ec60b5e05033@huawei.com>
X-Migadu-Flow: FLOW_OUT

Hey Shameer,

On Mon, Oct 28, 2024 at 05:29:14PM +0000, Shameerali Kolothum Thodi wrote:
> > I don't know if you saw my suggestion on v1 [*], but it'd be great if we
> > can hide the array of implementations from users of is_midr_in_range()
> > and friends.
> 
> I did see your suggestion but my bad,  misunderstood it and thought that you are
> referring to _midr_range() functions in cpu_errata.c only.

Ah, no worries. And yeah, for this to be a general solution we're going
to need to cover all our bases where MIDR checks are used.

> > There's other junk keyed off MIDR (e.g. Spectre) that also needs to be
> > aware of all the implementations where the VM might run. The easiest way
> > to do that is to stop using a caller-provided MIDR and have
> > is_midr_in_range() either walk the array of implementations or read
> > MIDR_EL1.
> 
> So the suggestion is to use something like this?
> 
> bool is_midr_in_range(struct midr_range const *range)
> {
>         int i;
> 
>         for (i = 0; i < errata_migrn_target_num; i++) {
>                 if (midr_is_cpu_model_range(errata_migrn_target_cpus[i].midr,
>                                             range->model,
>                                             range->rv_min, range->rv_max))
>                         return true;
>         }
> 
>         return midr_is_cpu_model_range(read_cpuid_id(), range->model,
>                                        range->rv_min, range->rv_max);
> }

Yep, pretty much like that. Except that the guest should either use the
values from the hypercall *or* the value of MIDR_EL1, not both.

> Or do we need some kind of hint to these functions to specify which 
> MIDR to use? I think there are at least couple of places where it looks like
> it make sense to do the checking against MIDR_EL1 only.
> (eg: has_neoverse_n1_erratum_1542419().

I don't think we need a hint or anything. The fact that the hypervisor
is exposing this hypercall interface indicates the MIDR of the
implementation the vCPU currently runs on is subject to change.

So the concept of a per-CPU erratum is completely out of the window, and
every CPU is subject to the errata of every implementation advertised by
the hypervisor.

-- 
Thanks,
Oliver
