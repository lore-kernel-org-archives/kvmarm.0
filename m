Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252AB311959
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 05:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779947254; cv=none; b=DiKL4yNR8m+aN4/6yC48d5koNYplFNESBt8NEj9ULy4sB8s9enLqznNdH05ngj6/j6YLj8eJ9pt9DGsfEGZd9pR5Li0a51Ghvho0ZsXiDbiHNdtAd6X84f1hrzwt/nXXKwjdyTEYdutgr1ajS5v30ZdUTC5SCDqoEMriBK+BIyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779947254; c=relaxed/simple;
	bh=lmWdNZbaObnmUVm75cZcwL9UP/kZ4ZTAnqFm1Ag82PM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=tUHz3wpjyLRB6n/FhtI5M1KLAItYrlH/jmpK13j39OXavS9NwrV9zQJyZC/+uS74UK1jc8JYDP9VUQ1QGkZ68VlAd9mixDBVDKgR2YEy9+cDBP6wikXYwbQqaM1wHkdCDeTNW7zACbnw7ZqQbxTmj5uLBocaMl881E5cldEpYk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BM0OLeP4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BM0OLeP4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877E31F00A3C;
	Thu, 28 May 2026 05:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779947252;
	bh=DK6yOv4xVJ9/sneezKNDMIziZQjzaXiJRFbqLkrGSqc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=BM0OLeP4IqgBFjupjSqHpKqGZ0CI7GcreyYu6eF+5cG2e56PRt+bDgQuRxJU5XM3a
	 yL7aepyQEwwJq7GSHNWP46Qm6kB2zZ7NlLGuWnFHS9CXmzQIjS7Z7eiMPNdH6xIgVv
	 SoYHFeXl6UIrJIAcj8ileVYkyy0bXGHxLpJdEmMlA6rhP1pXx3T7V24T9bS2DnEnld
	 TaEqPQlm3KCoWgi/Eipv68ow5pNNSNjW/ESTc+A9IKOGy18DBPywS2IDw34erfpogy
	 4D7j8qrD0NM6HKTXsdgjFRST7GmaQvUgQdUW1PjpV538EaUYvG6A2SJuZWnYVgjutY
	 9bVhlcyjO8BZg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id A9096F4006C;
	Thu, 28 May 2026 01:47:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 28 May 2026 01:47:31 -0400
X-ME-Sender: <xms:89YXamHwIhO2-DK_eX2bOskcf21oK0bJwYhPB43mQPLpxuVB-cLQaw>
    <xme:89YXajQ-iIrWPH87J7IF0CbG8KnhkBp0RR8zHnme_t_zQ2j8RKmj2pzIGo_jII5RM
    kEzaUv1lV2l3iRZo9uBB30qE04HnWXpLpKp4aI_hWu1DCYgdiqhuPI>
X-ME-Received: <xmr:89YXamTQtpaWnK5UCTLZ7-b9eYy8dkmgZzsEEp4TWfP2UfkWIRM3RnqhUjROM_tMqyqNZrCkJqg8ZYCwySgs3IMU9emCdPm3DPI>
X-ME-Proxy-Cause: dmFkZTFmXmnPUHBlXPEK4FO4blsX5JSlZandmPSXAd6sisIa25T738qOMv8vIvRtp8+Gfi
    kkf5MFJ/TlcuCSx6EbZublixxFqyZrQyhUsYzuuStoGOA0r55OFFemjxQCK7Vyj3RBs0tg
    43Zsu1ApoTCk/fyNdxkqBok1DfImK8KzMGcBlVo4Eq56QJ8QpBgbEfR06tuNwxjV1IzyTs
    bNgK9089KeZPQYq7QlLAAxnPqnoX+5IacmXXiQ3R7EV2whsTMmjlO316QnTmXmooip4XXc
    k5Y1964dU+bdg8zThNP1aHBJAEXcc6aMIbc+9LNp+WikJx0Ye9P+fKqq0pfg0ESEorroOz
    ymajd1CY8h9gOuU+4GoHA9X8re4ZOKTtm01mV+FgWU0SstdACkHYIk8OgKEDfXLslmj+gs
    J1ios7bHGxhV8x/nKTHrOCxZKG+5YUVgIcophJTykeGdnFibXCyzs4lzXCNZjd8HPX16DE
    O0RNwkBQshONJDsSc3yTkxPOqKcNSlEBzTN1bWrfZpZHeDA1mOweToYFoPWEMzWzGV2FTF
    Gk8vGEfChl1pt/bPPiiKWaatIAHenqYb3X1+U1NAC3ge/jxJoCaShamQH4DPW/JpgIo0DE
    mxukymeW0NMVElViFDBeayF6WjBVulDjSOm6o3RbJ50V6h1vMiphgGE+PAfA
X-ME-Proxy: <xmx:89YXamdr5mG4v_h_Vb4izNDk9TUVmxpxdNKIBRM5wmrH6F_e3cMbeA>
    <xmx:89YXaqf3TRVr2MjmhtDiUHFGtlB_-AYPvLgypAGFGAZcUKxFd7iZEA>
    <xmx:89YXas8Xz9vpo5EgSYmp6RhUnhtK5XrjS8YcOEvBpVbDhdBWykw1ew>
    <xmx:89YXaqM8BGbgkimRsvJVubk-we0T44jdadPoMfVRcghOgc3qG9EGPw>
    <xmx:89YXaqXapuCpmqupvBRIQ0-s-NaFxX9PhKQmmkAahRyvsfKWaRnSsnxk>
Feedback-ID: i67ae4b3e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 May 2026 01:47:30 -0400 (EDT)
Date: Wed, 27 May 2026 22:47:29 -0700
From: "Dan Williams (nvidia)" <djbw@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, 
 linux-coco@lists.linux.dev, 
 kvmarm@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, 
 linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, 
 Jonathan Cameron <jic23@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, 
 Samuel Ortiz <sameo@rivosinc.com>, 
 Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <Suzuki.Poulose@arm.com>, 
 Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>
Message-ID: <6a17d6f1d6371_2b1fb710057@djbw-dev.notmuch>
In-Reply-To: <20260427065121.916615-2-aneesh.kumar@kernel.org>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
 <20260427065121.916615-2-aneesh.kumar@kernel.org>
Subject: Re: [RFC PATCH v4 01/14] coco: host: arm64: Add host TSM callback and
 IDE stream allocation support
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Aneesh Kumar K.V (Arm) wrote:
> Register the TSM callback when the DA feature is supported by KVM.
> 
> This driver handles IDE stream setup for both the root port and PCIe
> endpoints. Root port IDE stream enablement itself is managed by RMM.
> 
> In addition, the driver registers pci_tsm_ops with the TSM subsystem.

Do you want to call out that this is an infrastructure / scaffolding
patch that only handles the PCI-TSM skeleton. The CCA meat comes later,
in particular IDE key management. Tell a bit more of the story 

Otherwise, mostly looks good.

Minor comments below...

> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/include/asm/rmi_smc.h         |   2 +
>  drivers/firmware/smccc/rmm.c             |  12 ++
>  drivers/firmware/smccc/rmm.h             |   8 +
>  drivers/firmware/smccc/smccc.c           |   1 +
>  drivers/virt/coco/Kconfig                |   2 +
>  drivers/virt/coco/Makefile               |   1 +
>  drivers/virt/coco/arm-cca-host/Kconfig   |  19 ++
>  drivers/virt/coco/arm-cca-host/Makefile  |   5 +
>  drivers/virt/coco/arm-cca-host/arm-cca.c | 225 +++++++++++++++++++++++
>  drivers/virt/coco/arm-cca-host/rmi-da.h  |  46 +++++
>  10 files changed, 321 insertions(+)
>  create mode 100644 drivers/virt/coco/arm-cca-host/Kconfig
>  create mode 100644 drivers/virt/coco/arm-cca-host/Makefile
>  create mode 100644 drivers/virt/coco/arm-cca-host/arm-cca.c
>  create mode 100644 drivers/virt/coco/arm-cca-host/rmi-da.h
> 
> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> index fa23818e1b4c..109d6cc6ef37 100644
> --- a/arch/arm64/include/asm/rmi_smc.h
> +++ b/arch/arm64/include/asm/rmi_smc.h
[..]
> diff --git a/drivers/firmware/smccc/rmm.c b/drivers/firmware/smccc/rmm.c
> index 2a6187df3285..7444cc3a588c 100644
> --- a/drivers/firmware/smccc/rmm.c
> +++ b/drivers/firmware/smccc/rmm.c
[..]
> diff --git a/drivers/firmware/smccc/rmm.h b/drivers/firmware/smccc/rmm.h
> index a47a650d4f51..37d0d95a099e 100644
> --- a/drivers/firmware/smccc/rmm.h
> +++ b/drivers/firmware/smccc/rmm.h
[..]
> diff --git a/drivers/firmware/smccc/smccc.c b/drivers/firmware/smccc/smccc.c
> index fc9b44b7c687..2bf2d59e686d 100644
> --- a/drivers/firmware/smccc/smccc.c
> +++ b/drivers/firmware/smccc/smccc.c
> @@ -97,6 +97,7 @@ static int __init smccc_devices_init(void)
>  		 * the required SMCCC function IDs at a supported revision.
>  		 */
>  		register_rsi_device(pdev);
> +		register_rmi_device(pdev);
>  	}

Would splitting the above three hunks make this series stand on its own
relative to the base CCA series? I assume likely not as soon as we get
to patch2.

Otherwise, just curious what your intended merge strategy is for this,
tsm.git or arm.git, and what help this needs?

[..]
snip code that looks good.

> diff --git a/drivers/virt/coco/arm-cca-host/Makefile b/drivers/virt/coco/arm-cca-host/Makefile
> new file mode 100644
> index 000000000000..c236827f002c
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-host/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +obj-$(CONFIG_ARM_CCA_HOST) += arm-cca-host.o
> +
> +arm-cca-host-y	+=  arm-cca.o
> diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
> new file mode 100644
> index 000000000000..67f7e80106e8
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
> @@ -0,0 +1,225 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2026 ARM Ltd.
> + */
> +
> +#include <linux/auxiliary_bus.h>
> +#include <linux/pci-tsm.h>
> +#include <linux/pci-ide.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/tsm.h>
> +#include <linux/vmalloc.h>
> +#include <linux/cleanup.h>
> +
> +#include "rmi-da.h"
> +
> +/* Total number of stream id supported at root port level */
> +#define MAX_STREAM_ID	256
> +
> +static struct pci_tsm *cca_tsm_pci_probe(struct tsm_dev *tsm_dev, struct pci_dev *pdev)
> +{
> +	int ret;
> +
> +	if (!is_pci_tsm_pf0(pdev)) {
> +		struct cca_host_fn_dsc *fn_dsc __free(kfree) =
> +			kzalloc(sizeof(*fn_dsc), GFP_KERNEL);

kzalloc_obj(*fn_dsc)

> +
> +		if (!fn_dsc)
> +			return NULL;
> +
> +		ret = pci_tsm_link_constructor(pdev, &fn_dsc->pci, tsm_dev);
> +		if (ret)
> +			return NULL;
> +
> +		return &no_free_ptr(fn_dsc)->pci;
> +	}
> +
> +	if (!pdev->ide_cap)
> +		return NULL;

Bailing early?

Maybe the RMM knows something about this device not needing IDE? I have
a similar question in patch2 around trusted sources for whether a device
is internal or not. 

> +
> +	struct cca_host_pf0_ep_dsc *pf0_ep_dsc __free(kfree) =
> +		kzalloc(sizeof(*pf0_ep_dsc), GFP_KERNEL);
> +	if (!pf0_ep_dsc)
> +		return NULL;
> +
> +	ret = pci_tsm_pf0_constructor(pdev, &pf0_ep_dsc->pci, tsm_dev);
> +	if (ret)
> +		return NULL;
> +
> +	pci_dbg(pdev, "tsm enabled\n");
> +	return &no_free_ptr(pf0_ep_dsc)->pci.base_tsm;
> +}
> +
> +static void cca_tsm_pci_remove(struct pci_tsm *tsm)
> +{
> +	struct pci_dev *pdev = tsm->pdev;
> +
> +	if (is_pci_tsm_pf0(pdev)) {
> +		struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
> +
> +		pci_tsm_pf0_destructor(&pf0_ep_dsc->pci);
> +		kfree(pf0_ep_dsc);
> +	} else {
> +		kfree(to_cca_fn_dsc(pdev));
> +	}
> +}
> +
> +/* For now global for simplicity. Protected by pci_tsm_rwsem */
> +static DECLARE_BITMAP(cca_stream_ids, MAX_STREAM_ID);
> +static int alloc_stream_id(struct pci_host_bridge *hb)
> +{
> +	int stream_id;
> +
> +redo_alloc:
> +	stream_id = find_first_zero_bit(cca_stream_ids, MAX_STREAM_ID);
> +	if (stream_id == MAX_STREAM_ID)
> +		return stream_id;
> +
> +	if (ida_exists(&hb->ide_stream_ids_ida, stream_id)) {
> +		/* mark the stream allocated in the global bitmap. */
> +		set_bit(stream_id, cca_stream_ids);
> +		goto redo_alloc;
> +	}
> +	return stream_id;

Is 256 total an RMM limit, and/or does it require globally unique
stream-ids? If not you could do what SEV-TIO does and just set stream-id
== stream-index.

> +}
> +
> +static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
> +{
> +	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
> +}
> +
> +static int cca_tsm_connect(struct pci_dev *pdev)
> +{
> +	struct pci_dev *rp = pcie_find_root_port(pdev);
> +	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
> +	struct pci_ide *ide;
> +	int ret, stream_id = 0;
> +
> +	/* Only function 0 supports connect in host */
> +	if (WARN_ON(!is_pci_tsm_pf0(pdev)))
> +		return -EIO;
> +
> +	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
> +	if (cca_pdev_need_sel_ide_streams(pdev)) {
> +		/* Allocate stream id */
> +		stream_id = alloc_stream_id(pci_find_host_bridge(pdev->bus));
> +		if (stream_id == MAX_STREAM_ID)
> +			return -EBUSY;
> +		set_bit(stream_id, cca_stream_ids);
> +
> +		ide = pci_ide_stream_alloc(pdev);
> +		if (!ide) {
> +			ret = -ENOMEM;
> +			goto err_stream_alloc;
> +		}
> +
> +		pf0_ep_dsc->sel_stream = ide;
> +		ide->stream_id = stream_id;
> +		ret = pci_ide_stream_register(ide);
> +		if (ret)
> +			goto err_stream;
> +		/*
> +		 * Configure IDE capability for target device
> +		 *
> +		 * Some test devices work only with DEFAULT_STREAM enabled.
> +		 * For simplicity, enable DEFAULT_STREAM for all devices. A
> +		 * future decent solution may be to have a quirk table to
> +		 * specify which devices need DEFAULT_STREAM.
> +		 */
> +		ide->partner[PCI_IDE_EP].default_stream = 1;
> +		pci_ide_stream_setup(pdev, ide);
> +		pci_ide_stream_setup(rp, ide);
> +
> +		ret = tsm_ide_stream_register(ide);
> +		if (ret)
> +			goto err_tsm;
> +
> +		/*
> +		 * Once ide is setup, enable the stream at the endpoint
> +		 * Root port will be done by RMM
> +		 */
> +		pci_ide_stream_enable(pdev, ide);

The end point of these patches follows the spec recommendation of
delaying enable until after key programming.

> +	}
> +	return 0;

Should this be making security claims to userspace without taking any
action for non-endpoint devices that happen to be passed in?

Thinking about a bisection case this should either fail here, print a
message that is removed in the final enabling patch, or do the
__maybe_unused arrangement to land all the CCA bits first and then do
this hookup. Up to you.
