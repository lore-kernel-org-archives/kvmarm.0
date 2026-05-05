Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D2348B36F
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777997837; cv=none; b=tziEVP/qMk8czQn/8yDcm/MnkleAlQ9iCcIftlO6+AGAcRrRskR7sQh2kGvADha0tx8OmNt9mkiGQVJtn7n5fEqSTabqdyky5w+XPe30ofv6Wi4ZTjuvTm2gLXZsmE5F+VIHFXAO5/SWOITtjjcpy5/F3vSQ2SZO1hinE0YsN4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777997837; c=relaxed/simple;
	bh=RNrRjG8F7y7vIp8q5Xm5bg/bZGzosl29uygoNMwlHPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5GV8jeEzIwKLg7MyfcHL1CtsMdt5CJT4L/xqpkSRIFY9kUo+Zr21zrGT7wL/qd6Zze6hgQ3J/o+T27uJToWkIvVcWF6853Q/ojEor05F4k7mWZTjLNmpRX2+ZUXgpO4LtXIKVeISb1Pfr+5XnqyI/sC9+c/zUTaG1mVtUoOiCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bdBujji7; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bdBujji7"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so86138185e9.2
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 09:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777997832; x=1778602632; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RNrRjG8F7y7vIp8q5Xm5bg/bZGzosl29uygoNMwlHPY=;
        b=bdBujji7MgLiTwOlBRKnU49SpFjMW41TKaQBTe86cZY+0uinViGp2rEaBhLs7VYx7i
         jKCITy7yfreFbfgs3UhKRt2pMnPbZMpTrYtXzMIg3RuNaVYjCnYauYYB7oaHewfpuIm2
         8aej4Rjg0zrV9vneDANTBs8RNlWQWVzulgr9JzGP/C1wz0tHx3Y+Z0e04SE7OMh6CeTD
         DZWfqZaqJp9oR+HBA31LuoBYyWI9ogWRK0todMiJ7+agJ5Bs321+KhDneszuG1OSg0xc
         RkyRhp9VyD4LKQuWk1ReAhUNPMQcei8RD0P1xRSz2s7TU1Lk8ptuxvKysGVJLzshIJKU
         mjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777997832; x=1778602632;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RNrRjG8F7y7vIp8q5Xm5bg/bZGzosl29uygoNMwlHPY=;
        b=l38FSxwRycZJRAGt3NqZrxt9sXwZbNixe0+q2ZhiRCCZiOW31xwCnZt7A9bdG/X9jS
         vXe+H6bJZ8LyiJl2NFZ/PSrw0WZDGjZd43cw2PSIOMCaDjezH7qOuH8kLaRb23rFnuyT
         1eiXwR55HSurE6mYKbNvNtex70DXCv+zckUTWPr9Cu6qeDo1FXHV0P9iuBr5L+r3yl1z
         +hA5ePuKD4f25yACo220YzqjXYYXareshMMbFgUy6tC6g+/ZgU+/g2Gt/Jnf9Vq2vZ5S
         KhcXeHmY9giOGbfrpLLxE0PBM8jfhj58qjFW/EnqR/v34x2FfS+jw6fQSXfTrKVazz/E
         R2Tw==
X-Forwarded-Encrypted: i=1; AFNElJ/cmWc9yGzBtOO3/GW0vZgcN2xMZ+RNGW7LjU69/eVxhyAIOSAKnvJ3wDXAakWt2WNUl3+MW8A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCbG0BxvgWDhm5vmG45UxNukwFDc5Dawzgp9aLLLAVNl2HJ7HA
	MzSpUMn1JBsqnWttXQTTdBH06DEp+I8tsEpIeTpUSUFRbkV67kxngR1Lw6deTffNY94=
X-Gm-Gg: AeBDiesgiHBjnSpeTjxzoVBaqDC4H+GvYEQt0p27IIRGslJZaad4uK7HEYNf7y210Q0
	MQA5A/aR9QsrXU+6GxqJ86Qn+Y2iC/3FHLaWmOfpZec31T49qtgJ2G5nDcEzCa2JughQBpCf8xo
	tzUmR050/5MykbnaLC42roMNdacwVMcyDroHSHdlEHRtqlZUdktt9jffRGrE3fkTSsNIGrvTdFP
	vCFUIji/t4Muut9pw/DEfuaA0PbEJLiU+AQQZd/XbIpr973lsjYx+JjV3fqOMXCYEZtErulAf7I
	RnMpW7HUVM+KUITQhApG2faVMdAlBWQACRaZepZinUYjq9xwofsCRIHW5ckMxzvo6qU8jQgaR3a
	FYSsbIjzUJe705qPsUNfHWA9/UOsxwEr54AWLhG8QUrZbCfN7J/ib68tmVBmwEv2Rw5Z7xtT+hm
	FvPJMyTVg=
X-Received: by 2002:a05:600c:64c5:b0:48a:5574:3a48 with SMTP id 5b1f17b1804b1-48e51c6ade9mr1520075e9.16.1777997831520;
        Tue, 05 May 2026 09:17:11 -0700 (PDT)
Received: from ziepe.ca ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a82307f28sm692460135e9.13.2026.05.05.09.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 09:17:10 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1wKISL-000AN3-Vc;
	Tue, 05 May 2026 13:17:09 -0300
Date: Tue, 5 May 2026 13:17:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <afoYBYIJOTClsdLS@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afiN1UwS9q6F6A_v@google.com>

On Mon, May 04, 2026 at 12:15:17PM +0000, Mostafa Saleh wrote:

> I am not sure if it’s worth it, the hypervisor is much simpler, there
> is a single page table, it’s locked (also identity mapped), it’s
> updated on VM boot/teardown only, we don’t even use iotlb_gather at
> the moment, although possible but I wanted to keep this series as
> simple as I can then we can add more features later.
> So this patch is the least intrusive change, as whatever the main SMMUv3
> driver does, the range tlb invalidation logic is the same.
> But I am happy to experiment with that when posted.

Okay, then maybe just always push a full invalidation?

I didn't like seeing the range invalidation lifted out, especially how
ugly that will turn into after my next series. So, don't use range or
use the proper full gather flow seem like the right two options.

I'm not so interested in minimal change, but maximum forward
maintainability. It is much easier to manage if you double compile
more of the driver exactly the same, and call functions in a fairly
normal way vs make special cases and special functions..

Jason
