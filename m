Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDC43EF0A1
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308193; cv=none; b=sutGXZM8VLnwNEqYiPbDSEfm4rUEFJK8b6vKGj/FGNMKVGNCuRGopbL5386xbY87cRzd2xY3oIzyjMIud/DCj/GI1cwHYNbASNkbnOt/+Dkn6aAiiwBwoFi2383aAoAFhmfih+nVbFMRzTkXPgwRCKQb76tfZ1y4X+jE5feAn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308193; c=relaxed/simple;
	bh=MNkzB34P7cQqRXT25Kr9JHE2YCRHfmQ0v7uYbpp8pzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts3iElYDptYPvuOSpOdLDIR887h4UJJszlytGzOzGaPj2Ait/1uIi+0lCPqe+sUEj5UK6oaSrR5eHBolL3I/3ZDwwtCAZ+W6bEtaCgiMilO9y6VdTpLLCQOisCC+NKTwizgeMmnHLo++CR06RqvZf0HENQDi5/KfKUuzJZnmQyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56515339;
	Thu,  5 Feb 2026 08:16:25 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E314C3F632;
	Thu,  5 Feb 2026 08:16:25 -0800 (PST)
Date: Thu, 5 Feb 2026 16:16:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
	dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
	fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
	jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	peternewman@google.com, punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com, reinette.chatre@intel.com,
	rohit.mathew@arm.com, scott@os.amperecomputing.com,
	sdonthineni@nvidia.com, tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com, will@kernel.org, corbet@lwn.net,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
	zengheng4@huawei.com, linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: Re: [PATCH v4 04/41] arm64: mpam: Context switch the MPAM registers
Message-ID: <aYTCV8E9ZFn4_FND@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <20260203214342.584712-5-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203214342.584712-5-ben.horgan@arm.com>

On Tue, Feb 03, 2026 at 09:43:05PM +0000, Ben Horgan wrote:
> From: James Morse <james.morse@arm.com>
> 
> MPAM allows traffic in the SoC to be labeled by the OS, these labels are
> used to apply policy in caches and bandwidth regulators, and to monitor
> traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
> equivalent calls these CLOSID and RMID, but they don't map precisely.
> 
> MPAM has two CPU system registers that is used to hold the PARTID and PMG
> values that traffic generated at each exception level will use. These can
> be set per-task by the resctrl file system. (resctrl is the defacto
> interface for controlling this stuff).
> 
> Add a helper to switch this.
> 
> struct task_struct's separate CLOSID and RMID fields are insufficient to
> implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
> PMG (sort of like the RMID) separately. On x86, the rmid is an independent
> number, so a race that writes a mismatched closid and rmid into hardware is
> benign. On arm64, the pmg bits extend the partid.
> (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
> this case, mismatching the values will 'dirty' a pmg value that resctrl
> believes is clean, and is not tracking with its 'limbo' code.
> 
> To avoid this, the partid and pmg are always read and written as a
> pair. This requires a new u64 field. In struct task_struct there are two
> u32, rmid and closid for the x86 case, but as we can't use them here do
> something else. Add this new field, mpam_partid_pmg, to struct thread_info
> to avoid adding more architecture specific code to struct task_struct.
> Always use READ_ONCE()/WRITE_ONCE() when accessing this field.
> 
> Resctrl allows a per-cpu 'default' value to be set, this overrides the
> values when scheduling a task in the default control-group, which has
> PARTID 0. The way 'code data prioritisation' gets emulated means the
> register value for the default group needs to be a variable.
> 
> The current system register value is kept in a per-cpu variable to avoid
> writing to the system register if the value isn't going to change.  Writes
> to this register may reset the hardware state for regulating bandwidth.
> 
> Finally, there is no reason to context switch these registers unless there
> is a driver changing the values in struct task_struct. Hide the whole thing
> behind a static key. This also allows the driver to disable MPAM in
> response to errors reported by hardware. Move the existing static key to
> belong to the arch code, as in the future the MPAM driver may become a
> loadable module.
> 
> All this should depend on whether there is an MPAM driver, hide it behind
> CONFIG_ARM64_MPAM.
> 
> Tested-by: Gavin Shan <gshan@redhat.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Peter Newman <peternewman@google.com>
> CC: Amit Singh Tomar <amitsinght@marvell.com>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
