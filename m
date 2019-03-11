From: Leo Yan <leo.yan@linaro.org>
Subject: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Mon, 11 Mar 2019 14:42:48 +0800
Message-ID: <20190311064248.GC13422@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 734504A447
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 02:42:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jncb5ztyEh2C for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Mar 2019 02:42:55 -0400 (EDT)
Received: from mail-yw1-f65.google.com (mail-yw1-f65.google.com
 [209.85.161.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 46D2D4A3B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 02:42:55 -0400 (EDT)
Received: by mail-yw1-f65.google.com with SMTP id x20so2997092ywd.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Mar 2019 23:42:55 -0700 (PDT)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com
Cc: Daniel Thompson <daniel.thompson@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

I am trying to enable PCI-e device pass-through mode with KVM, since
Juno-r2 board has PCI-e bus so I firstly try to use vfio to
passthrough the network card on PCI-e bus.

According to Juno-r2 board TRM [1], there has a CoreLink MMU-401 (SMMU)
between PCI-e devices and CCI bus; IIUC, PCI-e device and the SMMU can
be used for vfio for address isolation and from hardware pespective it
is sufficient for support pass-through mode.

I followed Eric's blog [2] for 'VFIO-PCI driver binding', so I
executed blow commands on Juno-r2 board:

  echo vfio-pci > /sys/bus/pci/devices/0000\:08\:00.0/driver_override
  echo 0000:08:00.0 > /sys/bus/pci/drivers/sky2/unbind
  echo 0000:08:00.0 > /sys/bus/pci/drivers_probe

But at the last command for vifo probing, it reports failure as below:

[   21.553889] sky2 0000:08:00.0 enp8s0: disabling interface
[   21.616720] vfio-pci: probe of 0000:08:00.0 failed with error -22

I looked into for the code, though 'dev->bus->iommu_ops' points to the
data structure 'arm_smmu_ops', but 'dev->iommu_group' is NULL thus the
probe function returns failure with below flow:

  vfio_pci_probe()
    `-> vfio_iommu_group_get()
          `-> iommu_group_get()
                `-> return NULL;

Alternatively, if enable the kconfig CONFIG_VFIO_NOIOMMU & set global
variable 'noiommu' = true, the probe function still returns error; since
the function iommu_present(dev->bus) return back 'arm_smmu_ops' so you
could see the code will run into below logic:

vfio_iommu_group_get()
{
	group = iommu_group_get(dev);

#ifdef CONFIG_VFIO_NOIOMMU

	/*
	 * With noiommu enabled, an IOMMU group will be created for a device
	 * that doesn't already have one and doesn't have an iommu_ops on their
	 * bus.  We set iommudata simply to be able to identify these groups
	 * as special use and for reclamation later.
	 */
	if (group || !noiommu || iommu_present(dev->bus))
		return group;    ==> return 'group' and 'group' is NULL

	[...]
}

So either using SMMU or with kernel config CONFIG_VFIO_NOIOMMU, both cannot
bind vifo driver for network card device on Juno-r2 board.

P.s. I also checked the sysfs node and found it doesn't contain node
'iommu_group':

# ls /sys/bus/pci/devices/0000\:08\:00.0/iommu_group
ls: cannot access '/sys/bus/pci/devices/0000:08:00.0/iommu_group': No
such file or directory

Could you give some suggestions for this so that I can proceed?  Very
appreciate for any comment.

Thanks,
Leo Yan

[1] http://infocenter.arm.com/help/topic/com.arm.doc.ddi0515f/DDI0515F_juno_arm_development_platform_soc_trm.pdf
[2] https://www.linaro.org/blog/kvm-pciemsi-passthrough-armarm64/
