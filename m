Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2133E53D0B1
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089989; cv=none; b=FJIrsxNVlemy8q4KhwY95ZmUHzJtD7hfBP1n6/qaNL0C/o7Wo/FFKCIeNaw1kKH2isd1VYspUP6TTUt05M4DL1XdfHFnLBQ04JqK3lVgUkUrLIPw8J5UE0k9rsJ6OHu6k15En1BQ/bWNO+3dN4X98/Z+qNwzbafihGgNJ5YwsMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089989; c=relaxed/simple;
	bh=BYdjDLssy8JKv6FM/v/3nDxGoG02feMVhVR5WwpnGqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bz65ADZ56Z+FyjcnviwkykexrSeSSjTl2zV5vadJhY8FsU3LLTz2XFkxilvRXddTBhuXZLjZ5wLUCKb28gBPSmoXujciKEHFCIr1JscULjbBmsoQEXuDu2bZZxXCnHM5GcODIr8sjwKa8h00GwC5hxa/p7kynfXVQVSfU9jFfK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bjJFsP4G; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bjJFsP4G"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49ccf12bed0so51545e9.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 08:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790089984; x=1790694784; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ycaWp9SoS5hGz6SolD0/sJBzyQ5A16vDCKKDe4NgaW8=;
        b=bjJFsP4GTgbWlBulSEBf28nbfc5dQjMqcZaXuSYH1oQj7n3YmpoGzUuwMuL6Rab0hP
         /RKLamWatRGjFKlUCIegib5bzzWukpCdWcfizCUaXmeSTkWs0hIpxW4WOc0xOYX5ayra
         FVTHbrQj8xRpdF0cTMKk8okg6KSe5RmTwBnJkWtMXfY1zwrJ3se98uBCA+80oKtkrcpz
         xXBRDK2xKmTVpZvx9NsG5D3EuzBKpl8F+hSk1c4wi864m+wiGUP0fNlxhO3VzSaco3hU
         aX7GcORDsVy15gAECWDQ77GToOi6qzIr2osjc18+hdoWLCMCjpoL/RnZB4FpbGgMflrS
         YlKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790089984; x=1790694784;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ycaWp9SoS5hGz6SolD0/sJBzyQ5A16vDCKKDe4NgaW8=;
        b=CFuwHFDGSVly/N6Q9hRL8NN7j8LDN6hLNrZFiWTx4T7j8DTuZq7nuyI5shBMPxS1Qg
         f9JjaaO2h4fJ/IrcsGb6pajD52vQOxKZd6klfzt2yLpgv0kOMpDHTLPM2ynYk0XfNXIC
         kMNmEQCPTzuCzHy3ATUvSRKBQzfpbELL59SuFSZWuUVhaA3ZTrsDoFtLqpVAN/1fH3q3
         RCRyTSS69dgY+V5UKSZMkziOgV0+pngq9Gt1gWJ0Qfc0TyqNBoI3Nw81nh+eI34MCWKi
         wD06aJmmTKiguYkW8nrjJomBvNV7FVe+fEQFp0hFzmHMTyTS1cWicbzPmLKDgE2fIpoQ
         Vjxg==
X-Forwarded-Encrypted: i=1; AKwUvBwdVNXPrv9xdm22Njim7Lu7wSSarleH7vQdhoFmvwYIzhLbZvzYl+hJ+hXHM3oTMRfH5/crY30=@lists.linux.dev
X-Gm-Message-State: AFuF++kiiT2bOux6VlyAzAefFGHc/z+o1+ny+Pa4NCZAHEIDWuvnMjIj
	V+HIi1jz7v4ewfeEgxuvL1mBBgDqutv8Lmv9j9a798sKdwCpj8NYFCvlQg8IYJkEkZ5gfjJ0nvP
	xEKARtg==
X-Gm-Gg: AYBFou1vcqymkHM9Z1x4UL4HtIyk1FDYme0SrOZYKmKHXFnBH7vRdw15WIYZyAPBo+n
	cDagehMQZ11jTBvAU26OL96S2Ff93d+mcWDI8CHRNvfqnImUjVYCoXne0ED5bAelFYBkFm7NWjE
	HZvIT0psNWMP2ACr8aRlxD17KEblE+OmUBq5t7ZrdEyU8susXuMy+oy9m+uqM8OEt1TVTv6CwMk
	6Pk2AH8cBd4reqmhPX4KXiRxrwzA601cIIKFXDdF/VFn9GPwk6rWhWUnVQDFRU1ATohR4XsX1+r
	i+axFC1ybQUqEXGfTURB4f28GUHSW0anLGUVluUbEj0aSvuOHhnsL0tnFU9goSG9CvK3XLWlKcC
	yaI8ecZ6qeWE7szPo5LUoxbIUGnIOHtH5QzFeGag1KvfpXEW8KOd2qh+n3Z+rKUI3Lh193FLifQ
	NOsojMi0uYyJCtgBV5b5a4Pyx0eHrgvNYLr4+su/hhUsyAMp415UoDib1RVAWdT3NGCQWB7Z/Gk
	6cy0k390eOK5AogvQzzUvgRqKRd1AV2SmdTcjmDYw==
X-Received: by 2002:a05:600c:6005:b0:49e:642a:9279 with SMTP id 5b1f17b1804b1-49fdd97d911mr116335e9.4.1790089983699;
        Tue, 22 Sep 2026 08:13:03 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fddfdce15sm1497315e9.10.2026.09.22.08.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 08:13:03 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:12:59 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <arKa-8QbSSQFrUbJ@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
 <20260922132814.D398D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260922132814.D398D1F000FF@smtp.kernel.org>

On Tue, Sep 22, 2026 at 01:28:14PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] iommu: pKVM DMA isolation bypass via unbound SMMUs falling back to host driver
> - [High] iommu: Use-after-free of smmu during platform_device removal
> --
> 
> commit a8ae8dbe858fbefdcb8b149d519f07175f91d794
> Author: Mostafa Saleh <smostafa@google.com>
> 
> iommu/arm-smmu-v3-kvm: Add the kernel driver
> 
> This commit introduces the pKVM host driver for the Arm SMMUv3, allowing
> the hypervisor to trap and emulate SMMU management when KVM runs in
> protected mode. The driver probes these SMMUs and creates auxiliary
> devices for them on the aux bus.
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> > new file mode 100644
> > index 0000000000000..9947d3a44304b
> > --- /dev/null
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> [ ... ]
> > +static int smmuv3_nesting_probe(struct platform_device *pdev)
> > +{
> > +	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
> > +	struct device *dev = &pdev->dev;
> > +	struct resource *res;
> > +
> > +	/* Only device tree, ACPI not supported. */
> > +	if (!dev->of_node)
> > +		return -EINVAL;
> 
> [Severity: Critical]
> Can an adversary bypass pKVM stage-2 memory protections here?
> 
> If an SMMU fails to bind to the hypervisor due to early returns in this
> probe function (like missing a device tree node or hitting the cavium
> erratum below), it is excluded from kvm_arm_smmu_array and the hypervisor
> does not trap its MMIO.
> 
> When the native host arm_smmu_driver registers at device_initcall, it can
> successfully bind to this unbound SMMU. Does this allow an adversary host
> kernel at EL1 to natively program this untrapped SMMU to perform arbitrary
> DMA into hypervisor or guest memory?

Yes, nothing really we can do about this, the system might have:
- Incompatible SMMUv3 instance.
- Device behind another IOMMUs.
- Devices without IOMMUs.

A system shipping this code should ensure that the driver is probed
successfully on their HW.

> 
> > +
> > +	if (kvm_arm_smmu_cur >= kvm_arm_smmu_count)
> > +		return -ENOSPC;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -ENODEV;
> > +
> > +	if (of_property_read_bool(dev->of_node, "cavium,cn9900-broken-page1-regspace"))
> > +		return -EINVAL;
> [ ... ]
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 2043c6dc1bdf8..d6d1e2d30ef63 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> [ ... ]
> > +static int arm_smmu_device_probe_emu(struct auxiliary_device *auxdev,
> > +				     const struct auxiliary_device_id *id)
> > +{
> > +	struct device *parent = auxdev->dev.parent;
> > +	void *group;
> > +	int ret;
> > +
> > +	dev_info(&auxdev->dev, "Probing from %s\n", dev_name(parent));
> > +	group = devres_open_group(parent, NULL, GFP_KERNEL);
> > +	if (!group)
> > +		return -ENOMEM;
> > +
> > +	ret = arm_smmu_device_probe(to_platform_device(parent));
> 
> [Severity: High]
> Can this devres setup lead to a use-after-free during platform device
> removal?
> 
> If the parent physical platform device is destroyed (for example, via
> dynamic DT overlay removal), the driver core calls devres_release_all()
> which processes cleanups in reverse order of addition (LIFO).
> 
> Because arm_smmu_device_probe() adds the smmu allocation to the parent's
> devres list after the auxiliary device was created in
> smmu_create_aux_device(), the smmu memory gets freed first.

Two points:
1) At the moment the device can't be released as suppress_bind_attrs is
   true. There is no kernel user for the dynamic overlay it is added
   for testing AFAIU.

2) AFAICT, __devm_auxiliary_device_create() calls, devm_add_action_or_reset()
   for the device destroy, so the aux device will destroyed before the
   platform device.

> 
> Following that, the auxiliary_device_destroy devres action executes,
> unregistering the aux device and triggering driver unbind via
> arm_smmu_device_remove_emu() and arm_smmu_device_remove(). Does this
> result in dereferencing the already freed smmu struct?
> 

Same as above.

Thanks,
Mostafa

> > +	if (ret)
> > +		devres_release_group(parent, group);
> > +	else
> > +		devres_close_group(parent, group);
> > +	return ret;
> > +}
> > +
> > +static void arm_smmu_device_remove_emu(struct auxiliary_device *auxdev)
> > +{
> > +	arm_smmu_device_remove(to_platform_device(auxdev->dev.parent));
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260922131259.2975334-1-smostafa@google.com?part=11
