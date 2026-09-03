Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4024F646E
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788456003; cv=none; b=W1zGajSZR1fovomg7hA0YkDlaWHxoIXpU66LIL+2tEQSU2R1iuOgY2Bg4ZJX47N3zCiE+j1Dgd7o5eQ07z5GSs4HD9G2Xd4lrfkHNIv/mMVpIZnY9IbUsX0N/fz31UzcRA9JtCgFZ4s2CXq16JqIkac+rE1H4GVXFdbl8UhVLmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788456003; c=relaxed/simple;
	bh=TvPo92pdtlY8GQQ43OPNhXsu18ZiYLAliP3gJ6Ty5EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ta96jcuosW6gN5i3mlKYkbMpM0fnXD8oLG5+LDDdewbG5XtQBBvZtEgnZwWDguXCvYGVqtFwrLqkJwJNxT9z6GQ30Z+FBfsHdst6x5eYS/RoBlOTvO6oyGj37hOKBy60HsflAk2s2D3hzJgD4aRjOqldwL+yBpNL2aMti7z5V+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=nkpOAQ9h; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="nkpOAQ9h"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-9392aa26b25so1952085a.2
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 10:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788456000; x=1789060800; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2HzZSHSS3HI/mCzuK+4yTezfsReb9f4u2CLSOp9ExL0=;
        b=nkpOAQ9hE52eqSce1jzMWgnDTgzN7ACoFfdnpQk7bX31oVlVcz7hV6my3He7yjahMR
         9DWbVdWHhCjxRZTKIAhWKr53azNjgzqBKAEwiJsMCMRPOOMUFoLDJgjODw8HP0A8xh5Q
         YeaePW9jidtPO1pJdIrpqGAQPDWmqrimzgb0u2eroOAgxxb4T5Ac6rwQ6MO7Cjo/rINh
         9ptAUwtZBWWhxpiZaioU9LD58dHDo8qpa5rgz3JaKAGBFGUfkyn9A7sHJQOVeZltxojM
         /rQMpOtSeE3xh8Y75Ple5d+kAolhURTQgYoSqFuM55DSXSs+o8mCA2ZWpgwVeXqz9ppu
         RPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788456000; x=1789060800;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2HzZSHSS3HI/mCzuK+4yTezfsReb9f4u2CLSOp9ExL0=;
        b=EyTCiVBKtMLfF8svncGEfpcoGJ2PfKvon0Yo89LkhrkU6ZpH/ztDE+h8AsgatdZwmx
         qi138pjHv9a0beM1OkNNbAOFuObXx1qeZcSZerA2+WF41oPkLJp23wYTwjC85uAYWwQX
         45TQsEQdj6d3qJ/J5EC20lYuyEN6pg9RU7XzZ9ZkJ1vMtZc6U02VtPyulEKj4SEIhIK6
         GA+KcNqSzf2aMSXrjNXRC05qzhRakoLSSo/xa+NvDAiulLVXmD6eaLmX6Ho0Ls0o8bp7
         E8gub9oHeEn+27rbg6TatMIOn6Db7RP3ep3NuBK6lBbDgmdfFLONc48W83sF3gdzjVg8
         nhrg==
X-Forwarded-Encrypted: i=1; AKwUvBzISXd3h3PveNpf9whAn4zPt9V73uZT+JR2xkSyJHUA7RLJ9v4puxDA6pYMFHDT9JsB16VP3Vo=@lists.linux.dev
X-Gm-Message-State: AFuF++lnr8R77cDIthGayqYW7nj7/P9h/nOkUROge7ulLC3mr+M5NC/z
	ehZuqkn1Wl1YIJxF8Ga1vissayhbBGj/HNJlFUFZDQEYIy0r20w4hjxUPrXYidw/cG0=
X-Gm-Gg: AYBFou0hP4aKg8/AI7hYcgVlka3w7J211yfJkkqi41dKkrndapp8HQjE6nOIaB+SmEh
	dwVOooYLRA+Qhg5ZfZ8Q54HEWNIx80NqmX0OMJv+dWevZGvoUoLLcUl8jZNrJNh6ifFoEbhRCg0
	rVul9MyILXUEHxuhXU3rMXiWWyRwYPTJ0GYj0O0vwTh1NLcQRhdM3PsX6UZRlQ2daw/JUEMPMoh
	LFVttcVibyz8PWVNYrDPud7gCzYnnQTvKAmZvRoc4kgcqmhGSNzW2vijuSqR1LsXK4aDue4zpmV
	roAy9JkMSLm8S6Y0s3uUnqh6P8Lx4QxkE27iEVXtkZWigXv2v9kGeB4jUWydzLtwL/nqq4LxZvn
	HbaDB3Ar555ihRun5UNCf83zRg0Nax698bAYv5BWF7INq5yxAXiJcw9LVFTW4iZWqllf39e2xuD
	dFG8OG63sUSR1PryURyWx/xTUdIxJ8OLoiNjKHazu7RildXowRYqiie6hVwPHxpvjKIqJDzMCLs
	JZfzs4unHBKPZu2qqd+tDHn5EpsjIhemcE0Ivu0N+NQNw==
X-Received: by 2002:a05:620a:8010:b0:936:576e:227b with SMTP id af79cd13be357-9397ecc749emr148166785a.24.1788456000170;
        Thu, 03 Sep 2026 10:20:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397f9f4b3csm14121485a.5.2026.09.03.10.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 10:19:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x2B6U-0000000HYPU-3heJ;
	Thu, 03 Sep 2026 14:19:58 -0300
Date: Thu, 3 Sep 2026 14:19:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260903171958.GL2890729@ziepe.ca>
References: <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
 <20260902193014.GF2890729@ziepe.ca>
 <yq5abjaezyxl.fsf@kernel.org>
 <20260903144729.GJ2890729@ziepe.ca>
 <39c8cec6-002f-456e-9e5e-7af2158047fa@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c8cec6-002f-456e-9e5e-7af2158047fa@arm.com>

On Thu, Sep 03, 2026 at 04:13:20PM +0100, Suzuki K Poulose wrote:
> On 03/09/2026 15:47, Jason Gunthorpe wrote:
> > On Thu, Sep 03, 2026 at 10:58:06AM +0530, Aneesh Kumar K.V wrote:
> > > > Do you mean the SMMUv3 driver triggers RD creation? That feels
> > > > wrong. Did you mean the VMM just does it earlier?
> > > 
> > > Currently, CCA creates the realm lazily as part of another operation.
> > > Realm creation is triggered by kvm_arm_rmi_populate() or
> > > kvm_arch_vcpu_run_pid_change()
> > 
> > Okay, that's not what I would have guessed. But critically is there
> > some way for userspace to specify any realm creation parameters (like
> > rpv, ats_plane and so one) prior to the lazy creation?
> 
> There would be, eventually. Based on the feedback from KVM arm64
> maintainers, we are trying to keep the ABI as generic as possible as the
> normal VMs. Thus, for now we have not included the Realm specific
> parameter configuration (which was present in the earlier versions)
> in the latest version of the KVM support.
> 
> We have some ideas on how to do the configuration step. e.g. for MEC,
> see the following thread :
> 
> https://lore.kernel.org/all/46d78aa2-cacb-4efd-ae62-3026f5fe9b3f@arm.com/

I see, well please convay to the KVM folks that the iommu side needs
the RD to be setup prior to creating viommu objects and needs to be able
to supply realm parameters like ats_plane to work..

Don't see a reason to twist the API to accomodate KVM being out of
order for now. It is up to you if you want to try to do the lazy
create or try to get a defined creation momement with parameters (I
prefer this from an aesthetic perspective at least)

Jason
