Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CE538E100
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768478973; cv=none; b=E4FJi6cmQtUYRn77GqsSfdOjv+h05pn7TfL/bbWiAX5WSqtufWc4uOM8PxRKUEsbJ+aTGOJnIWjXbap7mkPJLDGvC/yUVvduoIxLYOG2EOavXbY5ZOkhdJJ9ydSVlP0zotYc+SzEFVspQx8zM3zQ5pdl+KN2LaeOkVDZGBoUpxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768478973; c=relaxed/simple;
	bh=wKnTEikqhS4NMm/VDSqQnliYLJaNLFe5Z2Y8Fwg2fBI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QqRESQW5QGt0Dq8sSJU6mA0OzrgZ8lj27PxclibXAybkZ6+ol0/OK/I/+13IVRUoV6hN50AOaxpaxsPvH44E/eu/p4TEAr3Hy6m45oaROku5hgSVGEy0Vg5qBzaBKR64gXecqJjceBlEKbd0Mjl8on+Fs0GCJKSUvhe0hU0kXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsMGS2wBgzHnH8m;
	Thu, 15 Jan 2026 20:09:04 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 406CC40570;
	Thu, 15 Jan 2026 20:09:26 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 12:09:24 +0000
Date: Thu, 15 Jan 2026 12:09:23 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gavin Shan <gshan@redhat.com>
CC: Ben Horgan <ben.horgan@arm.com>, <amitsinght@marvell.com>,
	<baisheng.gao@unisoc.com>, <baolin.wang@linux.alibaba.com>,
	<carl@os.amperecomputing.com>, <dave.martin@arm.com>, <david@kernel.org>,
	<dfustini@baylibre.com>, <fenghuay@nvidia.com>, <james.morse@arm.com>,
	<kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v3 06/47] arm64: mpam: Context switch the MPAM registers
Message-ID: <20260115120923.000079fa@huawei.com>
In-Reply-To: <12779ebc-1928-42db-8a44-ee97e2a58fd1@redhat.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-7-ben.horgan@arm.com>
	<12779ebc-1928-42db-8a44-ee97e2a58fd1@redhat.com>
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

On Thu, 15 Jan 2026 14:47:28 +0800
Gavin Shan <gshan@redhat.com> wrote:

> Hi Ben,
> 
> On 1/13/26 12:58 AM, Ben Horgan wrote:
> > From: James Morse <james.morse@arm.com>
> > 
> > MPAM allows traffic in the SoC to be labeled by the OS, these labels are
> > used to apply policy in caches and bandwidth regulators, and to monitor
> > traffic in the SoC. The label is made up of a PARTID and PMG value. The x86
> > equivalent calls these CLOSID and RMID, but they don't map precisely.
> > 
> > MPAM has two CPU system registers that is used to hold the PARTID and PMG
> > values that traffic generated at each exception level will use. These can
> > be set per-task by the resctrl file system. (resctrl is the defacto
> > interface for controlling this stuff).
> > 
> > Add a helper to switch this.
> > 
> > struct task_struct's separate CLOSID and RMID fields are insufficient to
> > implement resctrl using MPAM, as resctrl can change the PARTID (CLOSID) and
> > PMG (sort of like the RMID) separately. On x86, the rmid is an independent
> > number, so a race that writes a mismatched closid and rmid into hardware is
> > benign. On arm64, the pmg bits extend the partid.
> > (i.e. partid-5 has a pmg-0 that is not the same as partid-6's pmg-0).  In
> > this case, mismatching the values will 'dirty' a pmg value that resctrl
> > believes is clean, and is not tracking with its 'limbo' code.
> > 
> > To avoid this, the partid and pmg are always read and written as a
> > pair. This requires a new u64 field. In struct task_struct there are two
> > u32, rmid and closid for the x86 case, but as we can't use them here do
> > something else. Add this new field, mpam_partid_pmg, to struct thread_info
> > to avoid adding more architecture specific code to struct task_struct.
> > Always use READ_ONCE()/WRITE_ONCE() when accessing this field.
> > 
> > Resctrl allows a per-cpu 'default' value to be set, this overrides the
> > values when scheduling a task in the default control-group, which has
> > PARTID 0. The way 'code data prioritisation' gets emulated means the
> > register value for the default group needs to be a variable.
> > 
> > The current system register value is kept in a per-cpu variable to avoid
> > writing to the system register if the value isn't going to change.  Writes
> > to this register may reset the hardware state for regulating bandwidth.
> > 
> > Finally, there is no reason to context switch these registers unless there
> > is a driver changing the values in struct task_struct. Hide the whole thing
> > behind a static key. This also allows the driver to disable MPAM in
> > response to errors reported by hardware. Move the existing static key to
> > belong to the arch code, as in the future the MPAM driver may become a
> > loadable module.
> > 
> > All this should depend on whether there is an MPAM driver, hide it behind
> > CONFIG_ARM64_MPAM.
> > 
> > CC: Amit Singh Tomar <amitsinght@marvell.com>
> > Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> > ---
> > Changes since rfc:
> > CONFIG_MPAM -> CONFIG_ARM64_MPAM in commit message
> > Remove extra DECLARE_STATIC_KEY_FALSE
> > Function name in comment, __mpam_sched_in() -> mpam_thread_switch()
> > Remove unused headers
> > Expand comment (Jonathan)
> > 
> > Changes since v2:
> > Tidy up ifdefs
> > ---
> >   arch/arm64/Kconfig                   |  2 +
> >   arch/arm64/include/asm/mpam.h        | 67 ++++++++++++++++++++++++++++
> >   arch/arm64/include/asm/thread_info.h |  3 ++
> >   arch/arm64/kernel/Makefile           |  1 +
> >   arch/arm64/kernel/mpam.c             | 13 ++++++
> >   arch/arm64/kernel/process.c          |  7 +++
> >   drivers/resctrl/mpam_devices.c       |  2 -
> >   drivers/resctrl/mpam_internal.h      |  4 +-
> >   8 files changed, 95 insertions(+), 4 deletions(-)
> >   create mode 100644 arch/arm64/include/asm/mpam.h
> >   create mode 100644 arch/arm64/kernel/mpam.c
> >   
> 
> With the following nitpick addressed:
> 

I commented on the nitpick.

> Reviewed-by: Gavin Shan <gshan@redhat.com>

> > diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> > index 76f32e424065..15979f366519 100644
> > --- a/arch/arm64/kernel/Makefile
> > +++ b/arch/arm64/kernel/Makefile
> > @@ -67,6 +67,7 @@ obj-$(CONFIG_CRASH_DUMP)		+= crash_dump.o
> >   obj-$(CONFIG_VMCORE_INFO)		+= vmcore_info.o
> >   obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
> >   obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
> > +obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
> >   obj-$(CONFIG_ARM64_MTE)			+= mte.o
> >   obj-y					+= vdso-wrap.o
> >   obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
> > diff --git a/arch/arm64/kernel/mpam.c b/arch/arm64/kernel/mpam.c
> > new file mode 100644
> > index 000000000000..9866d2ca0faa
> > --- /dev/null
> > +++ b/arch/arm64/kernel/mpam.c
> > @@ -0,0 +1,13 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (C) 2025 Arm Ltd. */
> > +
> > +#include <asm/mpam.h>
> > +
> > +#include <linux/jump_label.h>
> > +#include <linux/percpu.h>
> > +  
> 
> Nitpick: Needn't include those two header files since they have been included
> to <asm/mpam.h>

That is a non obvious include chain that we should not rely on.
Please keep the headers and continue to follow include what you use
style (with exceptions when a given header is clearly documented as always including
another like some of the bit map stuff.) It is more obviously correct and
causes less grief if headers get refactored in future.

>   
> > +DEFINE_STATIC_KEY_FALSE(mpam_enabled);
> > +DEFINE_PER_CPU(u64, arm64_mpam_default);
> > +DEFINE_PER_CPU(u64, arm64_mpam_current);
> > +
> > +u64 arm64_mpam_global_default;

> 

