Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBE7433BBD;
	Mon, 14 Sep 2026 10:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789381668; cv=none; b=khEeMj7ziGgEoq+fuaEbyuFfmbqMbSSqft3+h+TsL+FYjF+s8MunpML6fiGys2OWQMwkhq22VPunXk3Uk7ZRIdqVZZnhr1FrFVLfmayCU/BQHvX+Cn+aRA1TcPmp7sAxUGtztL6XFAjscju1QTrhrsCRRjJgfCnqDeG0pu3KvpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789381668; c=relaxed/simple;
	bh=Pqby7/raelVyTS+mHmIrdGeadonbP9M4SDCZFoQ/Ois=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KK6DpmrsQ3McoA21QZPtdjIU3uLnerwqCcE7nmhVS7r4dVeTZmwIb1Nw8zuVpcgxk4U9tWC10wCgw/xv8ptcVohzX1uCRW5xypw5GQTRSwQ/DS4IajUxtM/lIAnqs3df6yUaroTmORt/1fZOsP+Rg5umqQGFgVWevBVTOjiSntQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=el9UUB8K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="el9UUB8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4861F000FF;
	Mon, 14 Sep 2026 10:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789381664;
	bh=vRxMGoDpTwq9LCPo6am3xiYDTxZ0V1j1TOEM418TNfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=el9UUB8KFLWk3BECCbN0rFvBxBfsOeTb5BeP2XIlAeiak8DQr36rxCsaC4rbxXPkL
	 fVajd+aLMaY5iaPvzQqStycmoxpTVpbWfmUdaLVJTpUVJLbdwIgX481arVagH40jKJ
	 FrHNgadgpYwF0A/TztVd7Uy1hn8ijVct+uAIK0+Eqb08E5cYfwYHfJHePzb3KkOQH2
	 GoAdL6LC9GXQ9aA/cVXMa4GlqexfE2yeuGCiwdmg7B3L3J6lPJvcGm+T2WoUGFKf7D
	 MjPuED9OWrLiw2aQxmDstQPanUak4z49eXwc5AZqRhOViYHknTzuqSverlgsWlk2ZE
	 OGt4Sr0kcG7+Q==
Date: Mon, 14 Sep 2026 11:27:39 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
	yuzenghui@huawei.com, linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com, sdonthineni@nvidia.com,
	alpergun@google.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com,
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18 2/7] firmware: arm_rmm: Check for RMI support at init
Message-ID: <20260914-nano-narwhal-of-blizzard-dbc6a0@sudeepholla>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-3-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912083611.2513845-3-suzuki.poulose@arm.com>

On Sat, Sep 12, 2026 at 09:36:05AM +0100, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> Query the RMI version number and check if it is a compatible version.
> The first two feature registers are read and exposed for future code to
> use.
> 
> We only support this for Little Endian kernels, the Big Endian kernel
> support is anyway marked BROKEN and is being removed.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> v18:
>  * Always use arm_smccc_1_2_invoke() for all RMIs making sure the unsused
>    parameters are 0 - Sashiko
>  * Move rmi_features() calls away from the arm-rmi-cmds.h to rmi.c - Gavin
> v17:
>  * Rename ARM_RMM to ARM_RMM_RMI to make it easier to add Guest facing RSI
>    support, which is also in progress
> v16:
>  * Update Kconfig text to include PCIe TDISP.
>  * Export rmi_feat_reg() here rather than in a later commit.
> v15:
>  * The code is moved again, this time into the 'firmware' directory.
> v14:
>  * This moves the basic RMI setup into the 'kernel' directory. This is
>    because RMI will be used for some features outside of KVM so should
>    be available even if KVM isn't compiled in.
> ---
>  arch/arm64/Kconfig                |   1 +
>  arch/arm64/kernel/cpufeature.c    |   1 +
>  drivers/firmware/Kconfig          |   1 +
>  drivers/firmware/Makefile         |   1 +
>  drivers/firmware/arm_rmm/Kconfig  |  26 +++++++
>  drivers/firmware/arm_rmm/Makefile |   2 +
>  drivers/firmware/arm_rmm/rmi.c    | 122 ++++++++++++++++++++++++++++++
>  include/linux/arm-rmi-cmds.h      |  36 +++++++++
>  8 files changed, 190 insertions(+)
>  create mode 100644 drivers/firmware/arm_rmm/Kconfig
>  create mode 100644 drivers/firmware/arm_rmm/Makefile
>  create mode 100644 drivers/firmware/arm_rmm/rmi.c
>  create mode 100644 include/linux/arm-rmi-cmds.h
> 

[...]

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> new file mode 100644
> index 0000000000000..9792bf0e00cb9
> --- /dev/null
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + */
> +
> +#ifndef __LINUX_ARM_RMI_CMDS_H_
> +#define __LINUX_ARM_RMI_CMDS_H_
> +
> +#include <linux/arm-smccc-rmi.h>
> +#include <linux/bug.h>
> +#include <linux/processor.h>
> +#include <linux/types.h>
> +
> +
> +/*
> + * rmi_smccc_invoke: Invoke the RMI call and return the results in @regs_out
> + * @regs_in: Registers with the arguments filled in.
> + * @regs_out: Ouptput results from the call.
> + */
> +static inline void rmi_smccc_invoke(struct arm_smccc_1_2_regs *regs)
> +{
> +	struct arm_smccc_1_2_regs args = *regs;
> +	unsigned long status;
> +
> +	while (1) {
> +		arm_smccc_1_2_invoke(&args, regs);
> +		status = RMI_RETURN_STATUS(regs->a0);
> +		if (status != RMI_BUSY && status != RMI_BLOCKED)
> +			break;
> +		cpu_relax();
> +	}
> +}

I haven't done a detailed review, this is just a drive through comment.
The while(1) gained my attention.

Should RMI_BLOCKED be returned to the caller instead of retried here?

RMM spec defines RMI_BLOCKED as persisting until the Host takes action.
It also says it is returned when another SRO on the same context is
incomplete. You may be running it on different CPUs and hence different
context I assume. But this loop takes no such action and hides the status
from the caller, so a command issued against that context if that can
happen can spin indefinitely while the operation which would unblock it
cannot run. Ignore me if it taken care not to happen elsewhere. I am
just looking at this in isolation.

Could this retry only RMI_BUSY and propagate RMI_BLOCKED so that the caller
can arrange for the incomplete operation to make progress if the above
scenario is possible ?

-- 
Regards,
Sudeep
