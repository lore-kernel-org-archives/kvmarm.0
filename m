Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A844E341AC5
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712531; cv=none; b=OAZ4FVvSaYXjw76U4g/HjuvL/Wx5OGcOjOlOX8W/j4UD7ykzWJWJVDMibRsIgs+KRDf0oDT6UiiFGPdnPoJL5ifUqUaNwLs2/hlVRFdZAbemZaSIBt9qCYpblmYOrHfpWfP/+KELWFObeMh5kj8yZSTgYRK4KnWRQKrnF68csoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712531; c=relaxed/simple;
	bh=Nhu8A4N14QLze2lTcHQz/loSLLC8l3xvcxuIVMxQ6Y8=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tnfFMgVl2SveutbXgXHqlV9LxMB3wqwWnPJ++UDdF2Whs3kxffkTf1Eh9OTkAxunmxrlX1/Gi7+z49rdTJ/Y5Z8gWEBwHlRK+vzjxn5FS+3zpe+siA3HgzducTDqnf4rqHdVD2wp8p7dFTrjO2KLoMRoZP7OjiliKk/TON8OMR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlvqc4LHPzJ46dX;
	Tue,  6 Jan 2026 23:15:24 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 545DB40570;
	Tue,  6 Jan 2026 23:15:26 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 15:15:24 +0000
Date: Tue, 6 Jan 2026 15:15:23 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 41/45] arm_mpam: Add quirk framework
Message-ID: <20260106151523.00004778@huawei.com>
In-Reply-To: <20260106151415.00002119@huawei.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-42-ben.horgan@arm.com>
	<20260106151415.00002119@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 6 Jan 2026 15:14:15 +0000
Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

> On Fri, 19 Dec 2025 18:11:43 +0000
> Ben Horgan <ben.horgan@arm.com> wrote:
> 
> > From: Shanker Donthineni <sdonthineni@nvidia.com>
> > 
> > The MPAM specification includes the MPAMF_IIDR, which serves to uniquely
> > identify the MSC implementation through a combination of implementer
> > details, product ID, variant, and revision. Certain hardware issues/errata
> > can be resolved using software workarounds.
> > 
> > Introduce a quirk framework to allow workarounds to be enabled based on the
> > MPAMF_IIDR value.
> > 
> > [ morse: Stash the IIDR so this doesn't need an IPI, enable quirks only
> > once, move the description to the callback so it can be pr_once()d, add an
> > enum of workarounds for popular errata. Add macros for making lists of
> > product/revision/vendor half readable ]  
> 
> Review comment that got left over? 
Ah. I see, it's just change log for what James did.  Seem enough to add
a co-developed to me and maybe just leave this info under the ---?
> 
> Otherwise looks fairly standard for quirk handling.
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 
> > 
> > Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Signed-off-by: Ben Horgan <ben.horgan@arm.com>  
> 

