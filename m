Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=139.138.36.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591232;
	b=vi3pN2BRu4QnlOXleYmuH8rPyqYfaY8CyqCqJG2pF7eL+2O6kFTYIXSaJxF+kYZytPXf
	 xr0dXWdT1SdHjd9EYL/4LJdeb9gM4g7hkug+4b5s5TahXi4886Z5gyoui9DJr3akdlhpb
	 zOVv040+gaEySCtyNOvGIFnlAw+Ob+mfhwt0BoyZEStg2VVRljeJq8KUoiPq0oLVMGMWd
	 ehMo3dkJS5J7fWvGKgnwqvGxXZLCFskW6HWouRC1qScc+xDfX19X5E5e5ujMt+ioLOK33
	 MS/u6nbw3iT4uMTpjbHSlPAn1BRJ1e0vmOTxjDs3Wvc/5jv2Q05xXMVaHP8wYnAwMrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591232;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:Date:
	 From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=wqSXevxtbUPzruyogfRR5D3qm9uGXtBSUWQoF9Cs71Q=;
	b=KlqGFgbVKlJryyMQBlaHsw90a1RFwdT8cM/7+ejFKUWtwipnXvOc75PQ5j7hum16neIZ
	 q5f97RA8HVe0vq3FabCJ9fh/0UjC+pkQQeFtHkmdQY1o/7CIUSrKu8QkLy6dg0uY9W6Iv
	 bU6RoPpU6PNp+FJjytl/JPcGlUAOhETihDu8vIb8M7PZjy2zelnZpF7LVZLgJW/wVCJf/
	 7cEmAaSn/Eg5Kzo2p+TtDZdFX2m/5o+4SR8xNYRz4eVn3AhrQhkI+bDi1CWrOKk+gX0u2
	 IZonRlLboUr8krfYp4Z5pDOyE+V7lyPbdPy6gJqgiHarUDNgbDZMLiSWmXXqTJ8wd8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fujitsu.com;
	spf=pass smtp.mailfrom=fujitsu.com;
	dkim=pass header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=ti4bDzX5;
	arc=none smtp.remote-ip=139.138.36.225
Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E290606A31B;
	Wed, 21 Oct 2026 14:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E290606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fujitsu.com header.i=@fujitsu.com header.a=rsa-sha256 header.s=fj2 header.b=ti4bDzX5
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1792591238; x=1824127238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9DK2OEbFztWGhhecyDGTA244bbTa6mPCoyishduGujU=;
  b=ti4bDzX5TfNQI0MmG5RNnjlRENPq3LZdbFWUFdNoXRWv/QVKwULgnOKv
   YB/3QOL/RTnUJW//FNFgb5fYW11E+zN1K2b5TxeLbg9fYvT6cMM/J3/5i
   2G6ESxsCQiDc8iCOw6F8rrDEj3QWM9tWe2VNV4x2C8XfRO5Dirc8aZoZi
   +H0TF48HXmYtDx8cyJ/kTJkbVXE190hYJfuChJAWPFnbIV0ydOJ/QOEVS
   2MEgTdPI7TpTOsct7Fy5ipGkUw1/HmOjlEx9SSSvsk+v2UDDKZTgD8DK/
   nixXxOUiJ5TFYwL24b82uV8ELYcBigELFl5RSPwWQSPGCODCfL7y2jxyc
   A==;
X-CSE-ConnectionGUID: t4dpKXZASVuzsI89BybXUQ==
X-CSE-MsgGUID: aODQ6NbERZm6jcqd1kHi1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11942"; a="245174878"
X-IronPort-AV: E=Sophos;i="6.27,170,1786978800"; 
   d="scan'208";a="245174878"
Received: from gmgwuk01.global.fujitsu.com ([172.187.114.235])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2026 23:00:30 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gmgwuk01.global.fujitsu.com (Postfix) with ESMTPS id E948F1C1C734;
	Wed, 21 Oct 2026 14:00:23 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id 99172C02F31;
	Wed, 21 Oct 2026 14:00:23 +0000 (UTC)
Received: from FCCLS0092175.localdomain (unknown [10.8.62.79])
	by az2uksmom4.o.css.fujitsu.com (Postfix) with SMTP id 28952405E2E;
	Wed, 21 Oct 2026 14:00:14 +0000 (UTC)
Date: Wed, 21 Oct 2026 23:00:13 +0900
From: Kohei Enju <enju.kohei@fujitsu.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org, 
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com, 
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com, 
	Soby Mathew <Soby.Mathew@arm.com>
Subject: Re: [PATCH v22 06/10] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Message-ID: <atjEkyLimpQSL4d4@FCCLS0092175.localdomain>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-7-suzuki.poulose@arm.com>
 <atiyZ7_S7aBxowIQ@FCCLS0092175.localdomain>
 <34bf0c98-35b1-4402-842f-a100245cb9a7@arm.com>
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
In-Reply-To: <34bf0c98-35b1-4402-842f-a100245cb9a7@arm.com>

On 10/21 14:35, Suzuki K Poulose wrote:
> Hi
> 
> On 21/10/2026 14:07, Kohei Enju wrote:
> > Hi Suzuki,
> > 
> > I've tested this series and found a possible TF-RMM issue.
> > Please  below.
> > 
> > On 10/02 07:15, Suzuki K Poulose wrote:
> > > From: Steven Price <steven.price@arm.com>
> > > 
> > > The RMM maintains the state of all the granules in the system to make
> > > sure that the host is abiding by the rules. This state can be maintained
> > > at different granularity, per page (TRACKING_FINE) or per region
> > > (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
> > > underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
> > > all pages in the region must be of the same state, this implies we need to
> > > have "fine" tracking for DRAM, so that we can delegate individual pages.
> > > 
> > > For now we only support a statically carved out memory for tracking
> > > granules for the "fine" regions. This can be extended in the future to
> > > allow modifying the tracking granularity and remove the need for a
> > > static allocation by the firmware.
> > > 
> > > Similarly, the firmware may create L0 GPT entries describing the total
> > > address space. But if we change the "PAS" (Physical Address Space) of a
> > > granule, then the firmware may need to create L1 tables to track the PAS
> > > at a finer granularity. Linux therefore checks if the platform firmware
> > > manages the PAR region. i.e., the firmware is in charge of managing the
> > > L1 GPTs (creation and the required memory for the GPT tables - via static
> > > carveouts) without host intervention. Support for dynamic GPT creation by
> > > the host will be added later.
> > > 
> > > If the firmware requires us to manage the tracking or GPT memory,
> > > deactivate the RMM and reclaim any memory donated at RMM activation.
> > > 
> > > Apply the same checks when hotplugged memory is brought online.
> > > 
> > > Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Tested-by: Gavin Shan <gshan@redhat.com>
> > > Signed-off-by: Steven Price <steven.price@arm.com>
> > > Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > ---
> > [...]
> > > +/*
> > > + * We do not support creating L1 GPTs yet. So, make sure that all the regions
> > > + * are managed by the firmware.
> > > + */
> > > +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
> > > +{
> > > +	unsigned long l0gpt_sz;
> > > +	unsigned long next, par_state;
> > > +
> > > +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
> > > +					  rmi_feat_reg(1)));
> > > +	start = ALIGN_DOWN(start, l0gpt_sz);
> > > +	end = ALIGN(end, l0gpt_sz);
> > > +
> > > +	while (start < end) {
> > > +		long ret = rmi_gpt_info(start, end, &next, &par_state);
> > > +
> > > +		if (ret != RMI_SUCCESS) {
> > > +			pr_err("RMI_GPT_INFO failed for %llx-%llx: (%ld)\n",
> > > +				start, end, ret);
> > > +			return -ENXIO;
> > > +		}
> > > +
> > > +		if (WARN_ON(next <= start))
> > > +			return -ENXIO;
> > > +
> > > +		if (par_state != RMI_GPT_PAR_PLAT) {
> > > +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
> > > +				start, next);
> > > +			return -ENODEV;
> > 
> > When system RAM starts at a non-L0GPTSZ-aligned address, the alignment
> > in rmi_verify_gpt_firmware_managed() may cause the queried L0GPT range
> > to include a memory hole.
> 
> > 
> > On out platform, the relevant memory layout is:
> > 
> >      800c0000000-800dc3fffff : memory hole
> >      800dc400000-82fffffffff : System RAM
> > 
> 
> Thanks for the report.
> 
> > Consequently, Linux queries the following L0GPT range:
> > 
> >      800c0000000-80100000000
> > 
> > The query fails with RMI_GPT_PAR_RESERVED:
> > 
> >      [    8.551855] GPT for the region is not managed by firmware 800c0000000-80100000000
> > 
> > and arm64_init_rmi() subsequently fails.
> > 
> > As I understand it, smc_gpt_info() in TF-RMM checks only the beginning
> > of the aligned L0GPT range. Since that address is in the hole, the whole
> > range is reported as RMI_GPT_PAR_RESERVED, even though it contains
> > platform-managed System RAM.
> > 
> > I believe this should be addressed in TF-RMM. Do you have any thoughts
> > on the expected RMI_GPT_INFO behavior in this case?
> 
> I believe the RMM should report a value that represents the situation
> better. In this case, there is a hole, and some conventional memory
> areas. For the conventional memory, the RMM has to manage the GPTs.
> (This applies to the tf-RMM implementation of TRACKING Granule state
> too. It only looks at the first granule and reports the type of memory.)
> 
> RMI_GPT_PAR_RESERVED is not accurate as the memory region is not
> reserved, unless it is reserved for firmware (in which case the
> memory description is wrong).
> 
> I would say RMI_GPT_PAR_PLAT  is accurate if the L1GPT exists, as the
>  region covered by the L0GPT has some memory that are delegable.
> 
> Otherwise it must be reported as RMI_GPT_HOST_NOT_CREATED.
> 
> The information that a given memory region is not "memory" (i.e. hole)
> is basically TRACKING_STATE returned as RMI_MEM_CATEGORY_NONE

Thanks for the clarification. Could you please raise this with the TF-RMM
team? Please let me know if I can help with testing or provide any
additional information.

Thanks,
Kohei

> 
> 
> > 
> > As a side note, we tested this series and the v23 integration branch
> > with a Linux-side workaround to avoid the problem above, and we have not
> > observed any other major issues. Sorry for the delay in testing this
> > series.
> 
> Thanks for the testing !
> 
> Suzuki
> > 
> > Thanks,
> > Kohei
> > 
> > > +		}
> > > +		start = next;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> 
