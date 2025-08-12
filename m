Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912CC1FDE19
	for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755002236; cv=none; b=eFdkAM+9t2VzavCYLChOQH5MDKfRrLxbQYJuR/CrZlKyA5LOOqWev1/M08VTlL4xw4/asVe2TLffCjwudQGKLcnnr/X15gCgyaI/YK+UE24HTx6XxWWd7kn/dMc93KGtstqPcJV63PGM2E0cx7vpMs26XQhZ5+Ng/EoYnT2Ycww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755002236; c=relaxed/simple;
	bh=6+vPV+bK6DJ6nXeb3jB5k6SS93vCnToxb34PAPFuCJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ombjy1KTjlqPo54E6JM9wVVtwhcFeF8Dqf7bynVlEmVi7zFeBazGBTf01WFChdoTb2ME5D2Iyg5PbGrJ7/ugMTc47DMdlhaWNEP7lfA3laftrr98vQUBmaSwHBDqF28IagOWOvTYUbYm2rdxCiy3cngHLMGs+zsm5xWL6LGrzQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4tkEyXfK; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4tkEyXfK"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-459fbc92e69so65015e9.0
        for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 05:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755002233; x=1755607033; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PtQo1+YnKpPyJJuFIk2dQE6YfNoW6wyzVP6JiM6d+x0=;
        b=4tkEyXfKTS8vLTHvhqx3m6UmYNhoJtSfYBpOwg/g4ZT8f32N3UD2zBhnmF8EyIUCuT
         ++zhE6guhrhTME3l6tdUnSQCxkjBIZNy4iJ1qlEfNHHZz7Lahn9g5foB5qf0TaFmieQo
         Ghrp+8q+vNxZRTv6QaaN4/wf+r/ctAtQ5jlNmAddZRkmmKyxw4UJSy8MVzdnuWiOnNYs
         UnoaJtXKMeCJvZPJShxh9ecTpF2K873aNkRZ0kooRgFtMHytqdLhtZC+LGn2WhwQAMb0
         UQkrkAuzPzy4+O+Y42F6yEg235zkeMZzebmzSBzmXVWHZah7re+upGfai5gA8cbF9neD
         jm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755002233; x=1755607033;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PtQo1+YnKpPyJJuFIk2dQE6YfNoW6wyzVP6JiM6d+x0=;
        b=b8GZv5vEqUrKBLM+SHxi4IBx+TAjGCFBoU6Dbo4KM2cdQnSBHKoOjvMsDJFcuCZSk5
         hmzatImeLdiOuhZPNrhYRJ5kBPEkm/6rOMDa/Ft4z7cHWPHicmbVGNwPdnMOlsRUghpq
         tEco3YVNKmhCR8nGUP2PnyZ88msx7wVBOvc2FA8nlOnYKaBv4BYSVK5Q7N1yUBAKoo7S
         lOYWX7K9bx9vPXI2XqrbMZPVRqvis5GK5bNyDJejX3flHut0ubApJJdj82IjbU9oxgH3
         6p7UvueHCKHwnVP3bKY1BwtDdqBo8ggG2mYyrhlDuyMBROKE4wWBtuO41Zw3NDwuW7pu
         OVJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqXE7ggueF3KM7btaeWOvL6PlsDOFeVf1msZHKqqtVDiaywfmwN/328uLeUJHpoVeF7CWjd/I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4qdlihyakCs16iWUwuNHnUXp5WdIFE0TCHMhxHW8CcgB2eZLG
	Dtm/bu8XC9I4x+h6k4E63+c59hcmmeUO9lDjkbwbkcLEb1EcfINmf90excwup870pw==
X-Gm-Gg: ASbGncs4Y1WaiDsKXxnzh4Wkqp8li0/uIycnCWMEoRF+kV+jSgyJgaGmUUGHmqol1qq
	ZPESfkk9cs7Zph2xZS56iJaoWs/XyshgihgAn6db542O/gFhJRKv9NpeVccxPmnd9lOzuJ7sY2U
	PcV65AZh20sFH2x0NcNJPA+xWTt/NndcR2r86L3ST5grp4n0VxFYDcSGn6OOL0QJYl9uQYGOtY0
	MeceillPOAZi+imrPP7ea8JXQR0CDcKUerrpm9vJPqK2h080SCvICqYLHGnyCwszFngpzOVkuYz
	Khxvfe/wgj34Ugk6L/a3ASc8CWIYde2s5VjSmQC2H1lVXZoR0ETFGlDS/RRxcdWaYFf4z7YgjT0
	y6wzsDrC4m/n/ipV8ioOiMQD5OTsGEA357ITBWj6cZuba1crCptDfBSHK7BY1jVHAjw==
X-Google-Smtp-Source: AGHT+IFFzsEa9cITaRrgMdyauTFUB3XSIIAjCGeM6bXsRwPoXP8edKN4pm8dt4hrGOEGeaKzytXWkQ==
X-Received: by 2002:a05:600c:1c16:b0:442:feea:622d with SMTP id 5b1f17b1804b1-45a118c8a81mr1414775e9.1.1755002232511;
        Tue, 12 Aug 2025 05:37:12 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e0a24bf1sm317915135e9.1.2025.08.12.05.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 05:37:11 -0700 (PDT)
Date: Tue, 12 Aug 2025 12:37:08 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <aJs1dMiomjtxVwl4@google.com>
References: <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
 <20250805175753.GY26511@ziepe.ca>
 <aJNiW48DdXIAFz8r@google.com>
 <20250811185523.GG377696@ziepe.ca>
 <aJsXkidmcSl3jUJP@google.com>
 <20250812121056.GB599331@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250812121056.GB599331@ziepe.ca>

On Tue, Aug 12, 2025 at 09:10:56AM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 12, 2025 at 10:29:38AM +0000, Mostafa Saleh wrote:
> > On Mon, Aug 11, 2025 at 03:55:23PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Aug 06, 2025 at 02:10:35PM +0000, Mostafa Saleh wrote:
> > > > I am not sure I understand, the SMMU driver will register its IOMMU
> > > > ops to probe the devices
> > > 
> > > You couldn't do this. But why do you need the iommu subsystem to help
> > > you do probing for the pKVM driver? Today SMMU starts all devices in
> > > ABORT mode except for some it scans manually from the fw tables.
> > > 
> > > They switch to identity when the iommu subsystem attaches devices, you
> > > can continue to do that by having the paravirt driver tell pkvm when
> > > it attaches.
> > > 
> > > What is wrong with this approach?
> > > 
> > 
> > My confusion is that in this proposal we have 2 drivers:
> > - arm-smmu-v3-kvm: Register arm_smmu_ops? binds to the SMMUs
> 
> No, I don't mean two iommu subsystem drivers. You have only the
> pkvm-iommu driver. Whatever you bind to the arm-smmu does not register
> with the iommu subsystem.

I see.

> 
> > I am almost done with v4, which relies on a single driver, I don’t think
> > it’s that complicated, it adds a few impl_ops + some few re-works.
> > 
> > I think that is much simpler than having 3 drivers.
> > Also better for the current SMMUv3 driver maintainability to have the KVM driver
> > as mode, where all the KVM logic is implemented in a new file which relies on few
> > ops, similar to “tegra241-cmdqv.c”
> 
> I don't understand how you can do this, it is fundamentally not an
> iommu subsystem driver if pkvm is in control of the HW.
> 
> And I still strongly do not want to see a para virt iommu driver hidden
> inside the smmu driver. It should be its own thing.
> 
> The tegra ops were for customizing the iommu subsystem behavior of the
> arm iommu driver, not to turn it into a wrapper for a different
> paravirt driver!!

I see, but most of the code in KVM mode is exactly the same as in the
current driver, as the driver is not HW agnostic (unlike virtio-iommu).
In fact it does almost everything, and just delegates
attach_identity/blocked to the hypervisor.

IMO, having a full fledged KVM IOMMU driver + faux devices + moving
all shared SMMUv3 code, just for this driver to implement a handful
lines of code, is an over-kill, especially since most of this logic
won’t be needed in the future.

In addition, with no standard iommu-binding, this driver has to be
enlightened somehow about how to deal with device operations.

As mentioned before, when nesting is added, many of the hooks will be
removed anyway as KVM would rely on trap and emulate instead of HVCs.

Otherwise, we can skip this series and I can post nesting directly
(which would be a relatively bigger one), that probably would rely
on the same concept of the driver bootstrapping the hypervisor driver.

I am generally open to any path to move this forward, as Robin and
Will originally suggested the KVM mode in the upstream driver approach,
what do you think?

Thank,
Mostafa

> 
> Jason
