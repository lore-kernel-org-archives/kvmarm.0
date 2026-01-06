Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D128427A103
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767708294; cv=none; b=KG8YgiQNWslrxB58md7CzDVtZn6v91PHU52ITbGcvmjSiXi/DBkZcOPkhuGItWHn6MT5vvVTMhaCEzhJzYvPu7qkxFWQhiKAg9LJxEV5zP0/yT7jxykY9Yt/37ccICh8TPTNc8V0ZkLJ6y6hV7g0IpuUDjAHF7m5ZCDUx6wnHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767708294; c=relaxed/simple;
	bh=/+aYCLQJz/LIiXMM1R2l/ENH3NmgO8Ha8uP1xnEZuPQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcSNwlNQO9liVkOvYDhYo9cQ3b3TPfINvDwN4lwIJx0JHV4OHNhCvyj5Qu5A7tVIdPuZS0wIEu0Ru+CJbGOioOLpZ6AcCwlulMjkpu+gNeyS7oOeEG7jEsiUggZ8zXFiZWSrjt5KwDfdu6txuMr7B5F3vV4hFf70OFaz4LllRqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dltG903gZzJ46Zc;
	Tue,  6 Jan 2026 22:04:49 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id A2E974056F;
	Tue,  6 Jan 2026 22:04:50 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:04:49 +0000
Date: Tue, 6 Jan 2026 14:04:47 +0000
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
Subject: Re: [PATCH v2 23/45] arm_mpam: resctrl: Add rmid index helpers
Message-ID: <20260106140447.0000602b@huawei.com>
In-Reply-To: <316c5635-75af-4ebb-ad2c-fab0742beb20@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-24-ben.horgan@arm.com>
	<20260106112115.00000201@huawei.com>
	<316c5635-75af-4ebb-ad2c-fab0742beb20@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Tue, 6 Jan 2026 11:33:44 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> Hi Jonathan,
> 
> On 1/6/26 11:21, Jonathan Cameron wrote:
> > On Fri, 19 Dec 2025 18:11:25 +0000
> > Ben Horgan <ben.horgan@arm.com> wrote:
> >   
> >> From: James Morse <james.morse@arm.com>
> >>
> >> Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
> >> data structures by index. This allows x86 to map indexes to RMID, and MPAM
> >> to map them to partid-and-pmg.
> >>
> >> Add the helpers to do this.
> >>
> >> Signed-off-by: James Morse <james.morse@arm.com>
> >> Signed-off-by: Ben Horgan <ben.horgan@arm.com>  
> > one comment inline.
> > I messed around with GENMASK + field_prep()/field_get() - new
> > versions of these with no need for runtime constant masks, but
> > it ended up as not that much more readable than what you have here.
> > 
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>  
> >> ---
> >> Changes since rfc:
> >> Use ~0U instead of ~0 in lhs of left shift
> >> ---
> >>  drivers/resctrl/mpam_resctrl.c | 28 ++++++++++++++++++++++++++++
> >>  include/linux/arm_mpam.h       |  3 +++
> >>  2 files changed, 31 insertions(+)
> >>
> >> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> >> index 4275b1a85887..bdbc5504964b 100644
> >> --- a/drivers/resctrl/mpam_resctrl.c
> >> +++ b/drivers/resctrl/mpam_resctrl.c
> >> @@ -120,6 +120,34 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *ignored)
> >>  	return mpam_partid_max + 1;
> >>  }
> >>  
> >> +u32 resctrl_arch_system_num_rmid_idx(void)
> >> +{
> >> +	u8 closid_shift = fls(mpam_pmg_max);
> >> +	u32 num_partid = resctrl_arch_get_num_closid(NULL);
> >> +
> >> +	return num_partid << closid_shift;  
> > 
> > Given I think you restrict mpam_pmg_max to be power of 2 elsewhere,
> > doesn't this end up the same as something like
> > 	return mpam_pmg_max * resctrl_arch_get_num_closid(NULL);
> > Maybe its worth keeping it in the form you have here as
> > it sort of provides documentation for how you pack those IDs  
> 
> We only warn if (mpam_pmg_max + 1) is a power of 2 and so I'll keep this
> as it is, although yours is equivalent in the expected case.

Do the resulting 'holes' in the values that are valid here cause
trouble it isn't power of 2? 

> 
> >   
> >> +}  
> >   
> 
> Thanks,
> 
> Ben
> 
> 

