Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793101728;
	b=XLZRVc2LprupbKMo789rkChEcabEi/bBIfhT651aFjiku6ZGIcqoJP7BJ3jXoj9p7xQf
	 Dbmly21N4Yjxz65WeUHAbzFBX56rRzydmylnZKuZcL/m+6fb2SVgLKW05of+RTG1YCP7d
	 XADDIjNAMIUaDTSjt3oh1E79Cz0+bRgYuU03MgbJQuqyoshrmUU5PB1T0jcXrumKEkWmd
	 /QrAl0T3GMn6h2QnTg2dSOt7M9iWsRyXSTl0yWI+rEbPPe+QdzaYJlNwQc7Mjt2vpZ0re
	 SKhH2X9Ud1f0B1VdqZ0FBZmUFkfXUuEXo/p9d1Rn1V+cqspaEqn5LhUfnwelFw7IBmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793101728;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=O7vhfK9LUwcbCXy6Lz5w2AgaOehiRMtoFkoe6sMjwzU=;
	b=nc/a8LTRK7WdksuLNiqcrH/jkDqoLigqMgxr0gVJaDTLf+l4iINwDpBaXoyWl/NAoCbc
	 qZ/3dgBHJrRlZyTXX+MlMsvFgXRnh/lV8Id1zdQ2hK6aYtPq3h6W8ngNgP5iiBQQe9DhV
	 kKm3tgLwWv2P6frWU+DkL43JXsO1Oj4mGiCzRw3HI60H6zpEwIVpiYt1P7azxROIZ/bbY
	 c5rnr0GxpGbA8yVrF4zkPC9C9scaqcIEpCw+X2qDPCFniRPspZ1ID83qVpdOtw/FS/lFA
	 TdYT13MTPcUOahBhICn2kBFnibNfowf4tsLTxbFG3CcPKSq95BIavyO25SSXQywZRxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kVgmw+6F;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD51606A336
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 11:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FD51606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=kVgmw+6F
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CA0A2C1E;
	Tue, 27 Oct 2026 04:48:43 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 324883F59E;
	Tue, 27 Oct 2026 04:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793101726; bh=4i03Lff+oqO8PKJE3CBuMVnwfvifHeKsuOaAebMHbYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVgmw+6Fqmnn0FVvLxNLgUv3QdifXiyMmx7F/nnk1SuZwg+ZsRZaXVxBrH8+ZzjhM
	 LGl8H+mmx9XFZf1mLf9ZyJce8nQudSfO1zhncune6e/lbKr65mEVNy2jNt01tDb2hF
	 e9Kkwk1FnLMDDMoiow4zCil36BIDElArpf50BJF8=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] Set DBM bit on writable pages
Date: Tue, 27 Oct 2026 11:48:41 +0000
Message-ID: <auCPmYvvkwILa4j-@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <auCOj9dgk42AE1WX@LeoBrasDK>
References: <20261026144413.441566-1-leo.bras@arm.com> <at-lSy7H-K60LhCB@kernel.org> <auCOj9dgk42AE1WX@LeoBrasDK>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Oct 27, 2026 at 11:44:15AM +0000, Leonardo Bras wrote:
> On Mon, Oct 26, 2026 at 12:08:59PM -0700, Oliver Upton wrote:
> > On Mon, Oct 26, 2026 at 02:44:06PM +0000, Leonardo Bras wrote:
> > > When HAFDBS is enabled (VTCR_EL2.{HA,HD}={1,1}), having a DBM bit allows 
> > > hardware to promote a non-writable page to writable by setting (S2AP[1]=1),
> > > without having to take a fault.
> > > 
> > > The reason for this patchset is to add the DBM bit when setting-up writable 
> > > pages, so the code is prepared for future patches that make use of 
> > > HDBSS/HACDBS to accelerate dirty-tracking. Write-bit detection still 
> > > happens based only in S2AP[1], so no change in that aspect.
> > > 
> > > Having DBM set on block entries is undesired, as we benefit from the first 
> > > fault for splitting it in PAGE_SIZE entries, which is the granularity used 
> > > to track the dirty pages in KVM. So introduce a new walker that, on top of 
> > > clearing S2AP[1] for every entry, also clear DBM for block entries.
> > > 
> > > Also introduce a new VCPU request to reload Stage2, as it will be needed on 
> > > future HDBSS/HAFDBS patchsets. 
> > > 
> > > Please let me know of what do you think!
> > 
> > I'm pretty sure I shared this feedback before, but patches that enable
> > DBM do not make sense in isolation. We need a single series that
> > contains the DBM enablement as well as the corresponding HDBSS support.
> >
> 
> Right, 
> My reasoning is that we can discuss this new version, and make the needed 
> changes, so Tian could pick this for his own patch series for the next 
> version. I do not intend to get this merged by itself.
> 
> Next time I will make sure to state this in the cover letter so it's clear.
>  
> > > Changes since RFCv1:
> > > - Dropped patch #5 on enabling HAFDBS on non-dirty-tracking guests, as it 
> > >   proved to be counter-productive on wrprotect, contrary to expectations
> > > - No more moving writable-bit to DBM. That does not seem to be the intended 
> > >   use. It makes sense and it's easier to convert code to new DBM approach.
> > 
> > Sorry, where was this concluded?
> > 
> 
> Sorry, this is my viewpoint after re-reading the documentation and 
> being really pedantic while trying to get a proper answer from the people 
> responsible for keeping/improving it. 
> 
> > The abstract permission flags need to have a WRITE an DIRTY state, which
> > we then map to hardware based on the capabilities of the system.
> > 
> > !FEAT_HAFDBS:
> > 
> > 	DIRTY	=> S2AP[1]
> > 	WRITE	=> S2AP[1]
> > 
> > FEAT_HAFDBS:
> > 
> > 	DIRTY	=> S2AP[1]
> > 	WRITE	=> DBM
> > 
> 
> I agree that it could work, and my first version was based on that.
> 
> But looks weird to me that we have to decide the writable bit based on 
> having a feature enabled.
> 
> Take in account that we can only have DBM being the writable bit while 
> HAFDBS is enabled (not only present), and that it is just enabled during 
> dirty-tracking. 
> 


> It means we would need to convert the whole pagetable between DIRTY=S2AP[1] 
> and DIRTY=DBM every time we enable or disable dirty-tracking.

s/DIRTY/WRITE/


> 
> My suggestion with this series is to have WRITE=DIRTY=S2AP[1] at all 
> times, and have DBM to act as a "can be promoted to writable on write" bit.
> This way we don't actually need to convert between encodings, and it still 
> works and complies with the architecture.
> 
> > Beyond making the whole HAFDBS easy to reason about, I want this for
> > FEAT_S2PIE which reimagines bit 7 as a literal dirty bit that can be
> > managed by software or hardware.
> 
> Humm, and would not that work with the above suggested approach?
> I mean, bit 7 (Dirty, S2AP[1]) will both mean WRITE/DIRTY, but it will be 
> able to get promoted (nonW->W, or clean->dirty) based on the indirect 
> permissions.
> 
> What do you think?
> 
> Thanks for reviewing,
> Leo
