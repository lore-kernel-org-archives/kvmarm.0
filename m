Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A886945C0B
	for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 13:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755006492; cv=none; b=oqCNnBFt5Tyeev+wdPYCWRFcc/B8z6+VRhIC7N2SdKozZr4vMZjgMJNdCFRv2aJK7v5Ue/YyS/pBT+FfC1PQnJ2RIU1RO4HGzpDD7IeQDFS9LSxnWJznHNlcnO74AGSWXCOh8zcdeapKT9n7/DbiTMXVxFMVxEAA9OHsJoi71fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755006492; c=relaxed/simple;
	bh=8w8dsb/uFPEAy0xmEBycHMX3X/m+wobouE+WgPVe6Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6weyiLEjhDmUGCRC8NU34lKhqswTWC0HcSBvcqwKyrxvO6kZBihKtBxe/6Zk27Fx87hDlnZGVkx+8ogQtENwxjfXRWQ1q3ekEJi93THVX+gj5J53Iu9Y5Wwjw5bkpaNehXE74oer3DFMO8SYK5zKu2wYUTIYj9rfOn2pYZSzNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AAOpoPE+; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AAOpoPE+"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b075cd3cdbso90255261cf.2
        for <kvmarm@lists.linux.dev>; Tue, 12 Aug 2025 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1755006489; x=1755611289; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FR8GU0OhyrXp1118wyyWRxkyUnIP7crv/d61bMyXgwE=;
        b=AAOpoPE+MldvIJC2M/hcezDOhOUg1Ee9igxLqWIOoME23JmsJY6PQ+T0Z7UDtkH6or
         uRq5xYxB95Vo3bPx6DC4WxlOSZUTw7CBmygGaHCrN2T7xZ3PzWl+mgUD0DcloHFvjK+7
         1jQJuOv6mPQgG0+Ew8WMQQWJzXr9Ocf2Kub+hzvrQTH2WhwWzwmCvWjI8TToV2RE26FS
         dqVAGN3elQjIvtTbhHf6Uy1ASo3zIpvwM0GlYxHG9h2NMsOHDR/QWV5PRwd96qAGYARL
         6G3BfUUX0oliPN/bhPC4lFqbvDQa/LalIzoQ3T8SY9GRUOayxCZdYyD3xC5WMtGrk4wH
         XIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755006489; x=1755611289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FR8GU0OhyrXp1118wyyWRxkyUnIP7crv/d61bMyXgwE=;
        b=mcrXvjB2fPidhwzCQMtPzRXvKc5nYTSwv7B4GUx2uScIhLHLGOv/F7ixJcxBmD0MzX
         tRqsYJaf2IcLhI4J/oEQn2vGhVBSpmUOWROvVOlh5lheSn3a3uOQBnxTY1GtjgZNNWni
         vcQl6yzpoCafT+AQyVV7mf3Rj6ZFaUdyTeIBSJIyxvLzJyGGT2LVMvJ7gz4ZPWWLxB/U
         OXhcPoNjRihVYMpH6+KPRMRNPygWyhgVKheCL4pu2CJ8tNmz803XVFYIC5hAxwY5BAzs
         7xUrhkCheBZxDJtlxLnVkFm4wZF+kGUnb696DkymS9FQZAEcPxlKFDX7vBCOHUGd3s9/
         /dEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdKffXds8hI9YJQokdY6+qpNgdFbbsZaTTHpm2TMAedYtw13ifiylpRfFtFdFD/+RmxyHhIFo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKworJeYoCF8+CplpcZuXHPQ0rtt2sziqUw/4yR5YlgXMGttCv
	jeh4L+D/pjAzitcPvTSsU+ZL78Ixnn/tr/p85PWADZRC1AMNgGrzXmKcjr4qvOYlim07mJvEEqM
	fLdnb
X-Gm-Gg: ASbGncvWzRTzww6gvPgpT9t88QhKkuSpkYto7dSAO+up1kPiEk8v7gi0fxuPGTgdA+3
	KmasOi6KewVXSpuUn/3peFEwEyxeJTuGDhO31sKxcDViR/+5tOZ3L5oQqrkidIps6cfa7S9hQob
	N6bDyTBqOuo2qeaqOWXFE9H1vIuaf+NG4eq0tr5igXuPe7x2+h+wkcBjoS5eHB8MtrPgL2Gwy6m
	f0EzoINGGXTugKTpQvJ51f31e538vvOTocZtq0zKE2k8t+1zDNIpNBp3dMtofdZWF8288BPP+UM
	dAuqHDCPNAivLbEhAtFHVpT3vaF7ZKsVxHRzUmUCeykkHwTLX8ZBdnLTxi/fD6prf6SXCoO4S+o
	+obekvkcdTSquki0cnJ/v4JF5eOKpqd/sXdSi+KepuNx+l3GBHrgv5/0S7ogYkT9Swpt8
X-Google-Smtp-Source: AGHT+IHI6EhFhIRzAESYthEtnG0baUD5Q9gVXq2RPFWP9iicVSAJltUOiMffIa1QwE25DHjgtqhMEw==
X-Received: by 2002:a05:622a:6:b0:4b0:86b4:2520 with SMTP id d75a77b69052e-4b0ecbe5777mr52212061cf.22.1755006489353;
        Tue, 12 Aug 2025 06:48:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b09c11bf8bsm83500631cf.20.2025.08.12.06.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 06:48:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ulpMG-00000002cyr-0e38;
	Tue, 12 Aug 2025 10:48:08 -0300
Date: Tue, 12 Aug 2025 10:48:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250812134808.GC599331@ziepe.ca>
References: <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
 <20250805175753.GY26511@ziepe.ca>
 <aJNiW48DdXIAFz8r@google.com>
 <20250811185523.GG377696@ziepe.ca>
 <aJsXkidmcSl3jUJP@google.com>
 <20250812121056.GB599331@ziepe.ca>
 <aJs1dMiomjtxVwl4@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJs1dMiomjtxVwl4@google.com>

On Tue, Aug 12, 2025 at 12:37:08PM +0000, Mostafa Saleh wrote:
> I see, but most of the code in KVM mode is exactly the same as in the
> current driver, as the driver is not HW agnostic (unlike virtio-iommu).
> In fact it does almost everything, and just delegates
> attach_identity/blocked to the hypervisor.

How is that possible? the kvm driver for smmuv3 should be very
different than the iommu subsystem driver. That seemed to be what this
series was showing.. Even the memory allocations and page table code
were all modified?

This delta seems to only get bigger as you move on toward having full
emulation in the hypervisor.

So, I'm confused what is being shared here and why are we trying so
hard to force two different things to share some unclear amount of
code?

> In addition, with no standard iommu-binding, this driver has to be
> enlightened somehow about how to deal with device operations.
> 
> As mentioned before, when nesting is added, many of the hooks will be
> removed anyway as KVM would rely on trap and emulate instead of HVCs.
> 
> Otherwise, we can skip this series and I can post nesting directly
> (which would be a relatively bigger one), that probably would rely
> on the same concept of the driver bootstrapping the hypervisor driver.

I think you end up with the same design I am suggesting here, it is
nonsense to have one smmu driver when it is actually split into two
instances where one is running inside the protected world and one is
the normal iommu subsystem driver. That's not just bootstrapping, that
is two full instances running in parallel that are really very
different things.

> I am generally open to any path to move this forward, as Robin and
> Will originally suggested the KVM mode in the upstream driver approach,
> what do you think?

Well, I'd like to see you succeed here too, but it these series are
very big and seem a pretty invasive. I'm very keen we are still able
to support the smmuv3 driver in all the non-pkvm configurations
without hassle, and I don't want to become blocked on inscrutible pkvm
problems because we have decided to share a few lines of code..

Are you sure there isn't some inbetween you can do that allows getting
to the full emulation of smmuv3 without so much churn to existing
code?

This is why I prefer adding new stuff that you then just erase vs
mangling the existing drivers potentially forever..

Jason
