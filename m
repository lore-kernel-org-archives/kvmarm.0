Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EF1322DC1
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 18:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767636428; cv=none; b=dGuhfkdAwHUV+p4Ua7xCRdL4vYROOpqbRXxycftv/3JqmRp6RXVBv/xfUQ31GiKoUrM5hK1WclBkl0t/tXCpfDFgLQREefexx23I6/KVlVUz8x4r2ERldfahLCdT+Dx2Ypi7e0hw7PzCyaJ8jv1HlwpP/neJtSUT0DkoCJnrgY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767636428; c=relaxed/simple;
	bh=wMtq55yehU7jxMKK4y/AuGl1pnUMI3BU12K6DYUkvnQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MJ56KS2t8O8hu/auhRAa+UPVz9h2OWVAxjtwhuR1jPTJsEoASCvYHgJkvoYG6+6iBYfaBbuHaO/Qe3EPF6dKjKGCGNyzfQOFfq14SefCJ71K+hp2BaPvQr7LQ1d62WRBLT30JNt8iLjr+i2Xkb9SoFznBjifmw3IdiLNGPOvSso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlMh73cXdzJ46BT;
	Tue,  6 Jan 2026 02:07:03 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id C6D5040086;
	Tue,  6 Jan 2026 02:07:03 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 18:07:02 +0000
Date: Mon, 5 Jan 2026 18:07:00 +0000
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
Subject: Re: [PATCH v2 22/45] arm_mpam: resctrl: Add CDP emulation
Message-ID: <20260105180700.000037c8@huawei.com>
In-Reply-To: <20251219181147.3404071-23-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-23-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:24 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> Intel RDT's CDP feature allows the cache to use a different control value
> depending on whether the accesses was for instruction fetch or a data
> access. MPAM's equivalent feature is the other way up: the CPU assigns a
> different partid label to traffic depending on whether it was instruction
> fetch or a data access, which causes the cache to use a different control
> value based solely on the partid.
> 
> MPAM can emulate CDP, with the side effect that the alternative partid is
> seen by all MSC, it can't be enabled per-MSC.
> 
> Add the resctrl hooks to turn this on or off. Add the helpers that match a
> closid against a task, which need to be aware that the value written to
> hardware is not the same as the one resctrl is using.
> 
> Update the 'arm64_mpam_global_default' variable the arch code uses during
> context switch to know when the per-cpu value should be used instead.
> 
> Awkwardly, the MB controls don't implement CDP. To emulate this, the MPAM
> equivalent needs programming twice by the resctrl glue, as resctrl expects
> the bandwidth controls to be applied independently for both data and
> instruction-fetch.
> 
> CC: Dave Martin <Dave.Martin@arm.com>
> CC: Amit Singh Tomar <amitsinght@marvell.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

Minor thing below.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index 5a78299ec464..ba0312b55d9f 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -5,6 +5,7 @@
>  #define __LINUX_ARM_MPAM_H
>  
>  #include <linux/acpi.h>
> +#include <linux/resctrl_types.h>

This seems odd as nothing added to the header in this path appears to need it.
Maybe should be down in the c file or in a different patch?

>  #include <linux/types.h>
>  
>  struct mpam_msc;
> @@ -56,6 +57,8 @@ void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>  void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
>  void resctrl_arch_sched_in(struct task_struct *tsk);
> +bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
> +bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>  
>  /**
>   * mpam_register_requestor() - Register a requestor with the MPAM driver

