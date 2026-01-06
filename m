Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AFA32D7D9
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767708215; cv=none; b=qg/noAKuY54YqJ0C7IA1D4dFAtT90ikGsTcvNBrDjj8Sa0lfzHG5Ypsd2pUb/phsJ74UI18LA3GGbm0V9L6LjC9aTk2+L2irX5Uy1gdNR7UYGzm++EY+/pnunLX3NkAwHLQ5Sj/1VKYwZOV2cs9j7QC/OjmmNMQBCTTZ/8TwxEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767708215; c=relaxed/simple;
	bh=VogI00ZKNUSa3pk/s2kGxJwpOat9pzY/FBQyo6J0/Fk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqPQ1rMtkauuZpHwWBi01lqdKZ+2LLMGtUxa9fx0BaKVDh41bcplUi2BfpuBeYFAAfCYCK6B2p2anTU8c1KnMxXThDQ0MNuWWLCfcsjAHk0zdg0N/JuZWu26iolIs9WBm6K7e5lvh+Psq9ii+TVhg/SIesYy+CsT4DMZDReymo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dltDd4Sw3zJ46dK;
	Tue,  6 Jan 2026 22:03:29 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 477A24056A;
	Tue,  6 Jan 2026 22:03:31 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:03:29 +0000
Date: Tue, 6 Jan 2026 14:03:27 +0000
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
Subject: Re: [PATCH v2 07/45] arm64: mpam: Context switch the MPAM registers
Message-ID: <20260106140327.00000466@huawei.com>
In-Reply-To: <1837fd2e-8795-4a26-b961-fdef59afd03f@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-8-ben.horgan@arm.com>
	<20260105170451.00005669@huawei.com>
	<1837fd2e-8795-4a26-b961-fdef59afd03f@arm.com>
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

On Tue, 6 Jan 2026 11:14:50 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> Hi Jonathan,
> 
> On 1/5/26 17:04, Jonathan Cameron wrote:
> > On Fri, 19 Dec 2025 18:11:09 +0000
> > Ben Horgan <ben.horgan@arm.com> wrote:
> >   
> >> From: James Morse <james.morse@arm.com>
> >>
> >> MPAM allows traffic in the SoC to be labeled by the OS, these labels are
> >> used to apply policy in caches and bandwidth regulators, and to monitor
> >> traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
> >> equivalent calls these CLOSID and RMID, but they don't map precisely.
> >>
> >> MPAM has two CPU system registers that is used to hold the PARTID and PMG
> >> values that traffic generated at each exception level will use. These can
> >> be set per-task by the resctrl file system. (resctrl is the defacto
> >> interface for controlling this stuff).
> >>
> >> Add a helper to switch this.
> >>
> >> struct task_struct's separate CLOSID and RMID fields are insufficient to
> >> implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
> >> PMG (sort of like the RMID) separately. On x86, the rmid is an independent
> >> number, so a race that writes a mismatched closid and rmid into hardware is
> >> benign. On arm64, the pmg bits extend the partid.
> >> (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
> >> this case, mismatching the values will 'dirty' a pmg value that resctrl
> >> believes is clean, and is not tracking with its 'limbo' code.
> >>
> >> To avoid this, the partid and pmg are always read and written as a pair.
> >> Instead of making struct task_struct's closid and rmid fields an
> >> endian-unsafe union, add the value to struct thread_info and always use
> >> READ_ONCE()/WRITE_ONCE() when accessing this field.  
> > I'm still hammering on this one ;)
> > 
> > The comment below is better way of putting that it would basically leave
> > some fields that look like they can be used which can't. Given they
> > are under ifdef CONFIG_X86_CPU_RESCTRL anyway it would be very odd
> > to use a union. Would just be a new appropriately ifdef protected variable
> > right next to them in the file.  I'd be tempted to just drop the bit
> > about union and say why it makes sense to instead put it in
> > struct thread_info (basically because it's arch specific and we can
> > avoid even more ifdef mess?)
> > 
> >   
> >>
> >> Resctrl allows a per-cpu 'default' value to be set, this overrides the
> >> values when scheduling a task in the default control-group, which has
> >> PARTID 0. The way 'code data prioritisation' gets emulated means the
> >> register value for the default group needs to be a variable.
> >>
> >> The current system register value is kept in a per-cpu variable to avoid
> >> writing to the system register if the value isn't going to change.  Writes
> >> to this register may reset the hardware state for regulating bandwidth.
> >>
> >> Finally, there is no reason to context switch these registers unless there
> >> is a driver changing the values in struct task_struct. Hide the whole thing
> >> behind a static key. This also allows the driver to disable MPAM in
> >> response to errors reported by hardware. Move the existing static key to
> >> belong to the arch code, as in the future the MPAM driver may become a
> >> loadable module.
> >>
> >> All this should depend on whether there is an MPAM driver, hide it behind
> >> CONFIG_ARM64_MPAM.
> >>
> >> CC: Amit Singh Tomar <amitsinght@marvell.com>
> >> Signed-off-by: James Morse <james.morse@arm.com>
> >> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> >> ---
> >> CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message
> >> Remove extra DECLARE_STATIC_KEY_FALSE
> >> Function name in comment, __mpam_sched_in() -> mpam_thread_switch()
> >> Remove unused headers
> >> Expand comment (Jonathan)
> >> ---
> >>  arch/arm64/Kconfig                   |  2 +
> >>  arch/arm64/include/asm/mpam.h        | 73 ++++++++++++++++++++++++++++
> >>  arch/arm64/include/asm/thread_info.h |  3 ++
> >>  arch/arm64/kernel/Makefile           |  1 +
> >>  arch/arm64/kernel/mpam.c             | 13 +++++
> >>  arch/arm64/kernel/process.c          |  7 +++
> >>  drivers/resctrl/mpam_devices.c       |  2 -
> >>  drivers/resctrl/mpam_internal.h      |  4 +-
> >>  8 files changed, 101 insertions(+), 4 deletions(-)
> >>  create mode 100644 arch/arm64/include/asm/mpam.h
> >>  create mode 100644 arch/arm64/kernel/mpam.c
> >>  
> >   
> >> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> >> new file mode 100644
> >> index 000000000000..2ab3dca6977c
> >> --- /dev/null
> >> +++ b/arch/arm64/include/asm/mpam.h  
> >   
> >> +/*
> >> + * The resctrl filesystem writes to the partid/pmg values for threads and CPUs,
> >> + * which may race with reads in mpam_thread_switch(). Ensure only one of the old
> >> + * or new values are used. Particular care should be taken with the pmg field as
> >> + * mpam_thread_switch() may read a partid and pmg that don't match, causing this
> >> + * value to be stored with cache allocations, despite being considered 'free' by
> >> + * resctrl.
> >> + *
> >> + * A value in struct thread_info is used instead of struct task_struct as the
> >> + * cpu's u64 register format is used. In struct task_struct there are two u32,
> >> + * rmid and closid for the x86 case, but as we can't use them here do something
> >> + * else. Creating a union would mean only accesses from the created u64 would be
> >> + * endian safe and so be less clear.  
> > 
> > I'd just put this as something:
> >   * The closid and rmid in task_struct can't be directly reused as a u64 is needed.
> >   * As such, a suitable variable in struct thread_info is used instead with the
> >   * benefit of that being clearly an architecture specific location.
> > 
> > or be more cynical and keep it for the patch description only. To me location
> > of this u64 doesn't really feel like a design decision we need to record for the ages.
> > 
> > With something like the suggested text, or the paragraph just dropped
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>  
> 
> Thanks! I've just dropped this comment as it seems like more trouble
> than it's worth and updated the paragraph in the commit message to read:
> 
> "To avoid this, the partid and pmg are always read and written as a
> pair. This requires a new u64 field. In struct task_struct there are two
> u32, rmid and closid for the x86 case, but as we can't use them here do
> something else. Add this new field, mpam_partid_pmg, to struct
> thread_info to avoid adding more architecture specific code to struct
> task_struct. Always use READ_ONCE()/WRITE_ONCE() when accessing this field."
LGTM

> 
> >   
> >> + */
> >> +static inline u64 mpam_get_regval(struct task_struct *tsk)
> >> +{
> >> +#ifdef CONFIG_ARM64_MPAM
> >> +	return READ_ONCE(task_thread_info(tsk)->mpam_partid_pmg);
> >> +#else
> >> +	return 0;
> >> +#endif
> >> +}  
> > 
> >   
> 
> Thanks,
> 
> Ben
> 
> 

