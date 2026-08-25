Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B907A3D5222
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645451; cv=none; b=JJpX7e9QTou6jPKxfHmBmENTIZl6os/5Zbjm5GWzBDHTT+CGLjlkkHOWOuZqD/4lKNOBrSP26QZlFpsoxB7CmEA/DivcUw3RmXiNfM7NttL9I9qCKqVrHMAm1z8GyYGA4H7JXhVks1xkBAAHjmg1674u0lcu/Ob8fU7D6cnofvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645451; c=relaxed/simple;
	bh=oNXoiNSTNG1k9IXXk9hQXp+kbQrk6sYw032LVeO7rXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0hfczB9KoAEhyumt09CHs0lETmadKGrrwoNTZQmXNxm5MRUawmSNwrw8b18kB/5vm2nFb9Ua0P7yr3Zhz33ymmNvOZV/jaHxFqffqquBj1btqWgWZKPr6nOCm3E4J53mqjMGKFINZ+bIz0H4yIXZKhggiHvPua54SXHq+jVz/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X01gljrQ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X01gljrQ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4954df200ddso24148565e9.0
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 01:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787645448; x=1788250248; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ego9HMrjkuLUDdeK1Iq+KNPEGXEGkY7+DINyeWm7S4E=;
        b=X01gljrQ6i4/zWOCObub2nf/MobMhk7US7HwHjBakddW5wmArJ9aFqyMeMB91GbEv/
         CuNG8USWFNhtQTMFKCT1kQIE0qiD40LrUwj4PXpNuqR6k8NDVSQ0Zk0MZFQyblRxmY0l
         dVQyb7dm+AoKu8JMu/+G/msRoTsC5XaWmzQunSv4ZvVHhN6bKk+3u03ex4AeeK9JBEXG
         RV9iAPPfXfoEW+yMQZN9wRZYs1P9wSb/r1OTlFJfjvrJ+kdEOK4+BLFQSQXBYAxSnOrk
         RrzqEppTiXpCpmz18gNzA3WcwSy/5RrbtM/eQqQ+45xoFmQBFyc9Z3HtnWlX8a6ti1ra
         kWdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787645448; x=1788250248;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ego9HMrjkuLUDdeK1Iq+KNPEGXEGkY7+DINyeWm7S4E=;
        b=TZ/wDS33IKly2kYGuF2RFsi00HBnQzwG8ugS4VmSfHloAbV0/6zCck+zMzDSjqo9ld
         BUthFQ8H5pfOrZmhV2Cd6xYUTSRm3i2sBjrGvo68kiy04MA9/HH7CbI/p4AzXxzesIly
         eiEzXIRGfZZ2WJdi8gq1p/hWgiXb70fqUe6S8mTUu7o4DvAyGBTH3Nbbje5JLi3pxulc
         Q3e9CNp9wnTjOHVEjIrWlCcyloITsGLi5OTTm0FZuoErr7vIvCb/Gepwevuq11Aj6Z2C
         lRW0dgAcXtfH8whmCz2SbgTyegrcxob2OTmrms+OkloQzZwqm+rLU9X7RNRNqmQcGSkr
         ycXg==
X-Forwarded-Encrypted: i=1; AHgh+RprWtVrmrTN05LWYRXDixc5KJ4PZr0pNtO9xyNdZxOCsbnGtEgSMpPd3Ao+FVubK8pQF+tVhvs=@lists.linux.dev
X-Gm-Message-State: AFuF++lHyMlkveOVXGkyBhzm7bagMQFHDF6tpLLUrK9B2NqcwlxomgDu
	nL/GC7T2baKnrs/tLwT+lVij5pB2VxopkQ8AXCnWvJULPi/896yyoVp3xAssCEoRcQ==
X-Gm-Gg: AR+sD11ElklTjtndR1nSobAoBZC6BHsA4QXMPVLiPT/ZCLop6bcGK1FXzWu0TcWdpli
	voEZA4o8rZWn2Jh1dLl1cOAsAYJG2mqvQXVUnJCYJQ/pYHv/HWO/gMeB/I3mhjL1cBo36+yK6Dy
	iBDvWDR/Q1VbfDAAY/bMfep6h0JzQahLVC52fKPc7vFK7OuIr+s5nRSqGfTZrnC7z2AzZHoTxyq
	OAQDOot8qKDiDXjr0nPqhMiimhbip8Pcm+tZqvNmcWvJBQ+bUFO/IufjGRDEG81hKOOUFVkxHE/
	TLmrZe1mYC7z2vM4FGR8goCoG91Zg4uQO/ov0SM+jmgY1ohQQRBkov31VrHNu6kFuogPuvFmrfI
	sZZY6FOXF5Uz5u/4GqEhCFsx0VhPgQBi0YCEyKgEsIcnkf7thpm34y+6OVSryRDXiiFzX0zE8aA
	hBFyKIKLvpE7ArUwy+RYxhBzymPkj0Mf9NGsrZoiEieDK0jcB1E/VyDqCIKToKn9XC9AxaOHTH9
	gS4fIC+vXBhDD3wkolgc/yb8gIdxBW9
X-Received: by 2002:a05:600c:3f0c:b0:499:79b9:e226 with SMTP id 5b1f17b1804b1-499c178db57mr292491155e9.0.1787645447447;
        Tue, 25 Aug 2026 01:10:47 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499d65c326esm18410685e9.10.2026.08.25.01.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 01:10:46 -0700 (PDT)
Date: Tue, 25 Aug 2026 09:10:43 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	fuad.tabba@linux.dev, qperret@google.com
Subject: Re: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure
Message-ID: <ao1OAx_zLwpaw_5Y@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-7-vdonnefort@google.com>
 <yq5afr02wstl.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5afr02wstl.fsf@kernel.org>

On Tue, Aug 25, 2026 at 01:11:10PM +0530, Aneesh Kumar K.V wrote:
> Vincent Donnefort <vdonnefort@google.com> writes:
> 
> > Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
> > resources from the host.
> >
> > Provide serialisation helpers to transport these requests via SMCCC
> > registers (starting from a2):
> >
> >   pkvm_hyp_req_to_smccc() to encode into the SMCCC args.
> >   smccc_to_pkvm_hyp_req() to decode them.
> >
> > When the hypervisor raises a request, the host must handle it and retry
> > the HVC. To automate this sequence, introduce the pkvm_call_hyp_req()
> > macro. This intercepts pending requests, invokes the handler and retries
> > the HVC.
> >
> > Additionally, introduce a trace event to track the handling of these
> > requests.
> >
> > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> 
> This is very similar to the memory-transferring SRO operations described
> in section B4.3, RMI operations, of https://support.arm.com/documentation/den0137/2-0bet3/
> 
> The SRO model covers more details than the pkvm_hyp_req infrastructure.
> Should we look at making the two more similar?
> 
> -aneesh

Hum, this is really just a few lines of code. Also, pKVM doesn't need a stable
ABI with the kernel. Implementing a portion of a spec here sounds way too
complicated for that simple usage IMO. I struggle to see in what way this would
make pKVM better.

-- 
Vincent
