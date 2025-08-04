Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B14262FE5
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318500; cv=none; b=axgI6i2dIS1CKZGQPii/dw3fUm4iog9goPBs2HUlJENG9rrD/ZXjQ2ZXX4ATBu0gHgfwZbkQW4DGGoSrrDPMtpJ+IM0w+jaBL5YXmnvIl162t1kS87Cd7WdkQvF8T0nS0W+umaSH7irSs+ZrFOGYyVX32iYahuxNzNQiZnnGcbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318500; c=relaxed/simple;
	bh=Th1GGzHEXSIXAEjGF2bwBj2++NDa6AYjz2/R1sVcQg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9G2uTXTN3dXd5lATffcQfE6fhLs+UqjuDvMl6ZGVqSvbxzHtug2qqvt40nmcQLNWhWFCS3p5mY5xILKBq7cbh+YlEVeNpwyzGpgHpzBfenXc3VxX0gLrckr/lTupxtO3ofU32HQOTYWHRWgkK96bJPaW0gH6vMdYWo7TCMj0qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iFiME3vR; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iFiME3vR"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-459d5ab32d1so73075e9.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Aug 2025 07:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754318495; x=1754923295; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7wNH0ejjUe8Lj8uB8nKw5WFsHsij9Aanrkc89iq3IGY=;
        b=iFiME3vRrXIApAkdCJDO+jvkUu00v/zP6M65w1EIT/mDXkx1nP5+j546PrF92nz4Yt
         dTQdk9xjb/QC2TGTK7/j4+8gxLvdeolchVChkQTDgpfO5wg97WOEjfcPGtG7kL+0U9HP
         FV18+7GI/ljVsCf0yyoD0qoX2ctO2khQO+z0pBv4QHJfk1P2Dys4f5KeHukhfhcj+grz
         kaHnM1WelNSA9Y6T/+Of1BtH2NF4c3AWNFf3Bd1hp5EMUewkgcrTYlMYUcIszQLi5OOe
         LI5rGx7O7Ibv5eSnjY0oWO0V2BuLkUgPvmCQSdf+2YFM/PeNV4JEdjRnfWqsvZQ8gef3
         2CdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754318495; x=1754923295;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7wNH0ejjUe8Lj8uB8nKw5WFsHsij9Aanrkc89iq3IGY=;
        b=RritvgT9LFCmBmNPzSovrSSCFI2g/if0SDqak9SfIgH0xomI7NoW9yi47JJCXD89ce
         qWLabR1ePKvKuCEFJZbrN1/32TqV22zCFvOn7tTBx304SEo8YAlG4xXf3PILuQ5QAHTu
         7XRELjwBHXtDVAIfPCMtgMInUBt2JRpUYmI+EiKPv2NvVToT01Bmol+3IafgYCGyBcGS
         KMStCQUslT0J3PQx7Ql3jqqWMzP2CMw47jC6XJx35J/luu3KekWbDix6NfdQO8pLvkYg
         L2TBsRKK3xH0poq1WruXRedPp7MAXwTQLQeq+DZsyyEy4qDxoe1ktDMIA20XgORUtPvf
         2jdw==
X-Forwarded-Encrypted: i=1; AJvYcCU3TYsNvFMyY4lOd8jhtpH8jUKuK8gB+YZwOcHuy9ezu97I2X2yW9SLTyns1Ve0pphQWHbZkks=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgbE41Vv+ZEcEjEdbAhiTEdlS1cQW0I4zx92DELgtaYJKkUpzW
	g8QklVj2IRcDmPn8ecQsB1pqCqSCbM13vDUp+YvHDh2nSx2bmOObc9GrSvmG7caYmA==
X-Gm-Gg: ASbGncuicB+TZTaL0AkWMUXxo4BfuvZdkuIEKGqprznd3alS3Nw9VO+rRn6pYT73lm2
	Jq3CKLgjOhMoLhGACJxzInyrsxVhUdwQWD6AD0OYySwcnsgiSW0dB2NzGwiWE9SskHI6qwkyu6t
	W95knqK/VArbBnD00/fnHlVzvm1njM697V/3RkljJdUKWWimYDzZputo5zZm7ixg5LMIK64iKwe
	1hydMclu/3sFounfvveL83Xjk86AsFt4aM7LTMDM7n4crrDvjorMfalvhdp6Gw5RDlzLO9HRgni
	EnVr8pqCni4+wJWt9J8fdreytbPYsq27hTBZwMWYOt6j92TkwfhiKq7BgdQdPwzeyQz9JRyBgyE
	9ZkJBIYChRmfxF6RFzr1ob1nPPsDfXi7NDrqAe/VmyWOLsZ4a/PMxNEy19N05143qgw==
X-Google-Smtp-Source: AGHT+IGJiKUaLoknW9Epd8+LfOGYhki9ay4O/9N7wqTlXSABK7cHrsudr7MdE3msBmIPHpRZjQ9T/Q==
X-Received: by 2002:a05:600c:4928:b0:453:6133:2e96 with SMTP id 5b1f17b1804b1-458b6c0e62cmr3626715e9.0.1754318495186;
        Mon, 04 Aug 2025 07:41:35 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459ded356b9sm19744015e9.12.2025.08.04.07.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 07:41:34 -0700 (PDT)
Date: Mon, 4 Aug 2025 14:41:31 +0000
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
Message-ID: <aJDGm02ihZyrBalY@google.com>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250801185930.GH26511@ziepe.ca>

On Fri, Aug 01, 2025 at 03:59:30PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 31, 2025 at 05:44:55PM +0000, Mostafa Saleh wrote:
> > > > They are not random, as part of this series the SMMUv3 driver is split
> > > > where some of the code goes to “arm-smmu-v3-common.c” which is used by
> > > > both drivers, this reduces a lot of duplication.
> > > 
> > > I find it very confusing.
> > > 
> > > It made sense to factor some of the code out so that pKVM can have
> > > it's own smmv3 HW driver, sure.
> > > 
> > > But I don't understand why a paravirtualized iommu driver for pKVM has
> > > any relation to smmuv3. Shouldn't it just be calling some hypercalls
> > > to set IDENTITY/BLOCKING?
> > 
> > Well it’s not really “paravirtualized” as virtio-iommu, this is an SMMUv3
> > driver (it uses the same binding a the smmu-v3)
> 
> > It re-use the same probe code, fw/hw parsing and so on (inside the kernel),
> > also re-use the same structs to make that possible. 
> 
> I think this is not quite true, I think you have some part of the smmu driver
> bootstrap the pkvm protected driver.
> 
> But then the pkvm takes over all the registers and the command queue.
> 
> Are you saying the event queue is left behind for the kernel? How does
> that work if it doesn't have access to the registers?

The evtq itself will be owned by the kernel, However, MMIO access would be
trapped and emulated, here the PoC for part-2 of this series (as mentioned in
the cover letter) This is very close to how nesting will work.
https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-smmu-v3-part-2/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c#744


> 
> So what is left of the actual *iommu subsystem* driver is just some
> pkvm hypercalls?

Yes at the moment there are only 2 hypercalls and one hypervisor callback
to shadow the page table, when we go to nesting, the hypercalls will be
removed and there will be only data abort callback for MMIO emulation.

> 
> It seems more sensible to me to have a pkvm HW driver for SMMUv3 that
> is split between pkvm and kernel, that operates the HW - but is NOT an
> iommu subsystem driver
> 
> Then an iommu subsystem driver that does the hypercalls, that is NOT
> connected to SMMUv3 at all.
> 
> In other words you have two cleanly seperate concerns here, an "pkvm
> iommu subsystem" that lets pkvm control iommu HW - and the current
> "iommu subsystem" that lets the kernel control iommu HW. The same
> driver should not register to both.
> 

I am not sure how that would work exactly, for example how would probe_device
work, xlate... in a generic way? same for other ops. We can make some of these
functions (hypercalls wrappers) in a separate file. Also I am not sure how that
looks from the kernel perspective (do we have 2 struct devices per SMMU?)

But, tbh, i’d prefer to drop iommu_ops at all, check my answer below.

> > As mentioned in the cover letter, we can also still build nesting on top of
> > this driver, and I plan to post an RFC for that, once this one is sorted.
> 
> I would expect nesting to present an actual paravirtualized SMMUv3
> though, with a proper normal SMMUv3 IOMMU subystem driver. This is how
> ARM architecture is built to work, why mess it up?
> 
> So my advice above seems cleaner, you have the pkvm iommu HW driver
> that turns around and presents a completely normal SMMUv3 HW API which
> is bound by the ordinately SMMUv3 iommu subsystem driver.
> 

I think we are on the same page about how that will look at the end.
For nesting there will be a pKVM driver (as mentioned in the cover letter)
to probe register the SMMUs, then it will unbind itself to let the current
(ARM_SMMU_V3) driver probe the SMMUs and it can run unmodified. Which
will be full transparent.

Then the hypervisor driver will use trap and emulate to handle SMMU access
to the MMIO, providing an architecturally accurate SMMUv3 emualation, and
it will not register iommu_ops.
Nor will it use any hypercalls, as the main reason I added those is to tell
the hypervisor what SIDs are used in identity while others remain blocked, as
enabling all the SID space doesn’t only require a lot of memory but also
doesn't feel secure.
With nesting, we don’t need those, as the hypervisor will trap CFGI and will
know what SID to shadow.

However, based on the feedback on my v2 series, it was better to split pKVM
support, so the initial series only establishes DMA isolation. Then when we
can enable full translating domains (either nesting or pv which is another
discussion)

So, I will happily drop the hypercalls and the iommu_ops from this series,
if there is a better way to enlighten the hypervisor about the SIDs to be
in identity.

Otherwise I can’t see any other way to move forward other than going back to
posting large serieses.

Thanks,
Mostafa


> Jason
