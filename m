Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D97A31
	for <kvmarm@lists.linux.dev>; Sat, 23 Mar 2024 02:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711159684; cv=none; b=L0uxGIujP/eCagg303j39axf26+beHGXANtX3v64z3whbkgoogun793fkiOFGzvl/A18pFz/FE1Sns0NfYTCCRiYSqR9SzjvS3/IJvlVLl9YEmywNQbIXYO8Cow5Md1zUMXr8N8I0m7fbZ2Vfz6SLFEBamR1D5JYAk7G3yKnG6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711159684; c=relaxed/simple;
	bh=G0qqejbTt8x+fQsE2uIDzXF2fMgwgfYI1BMVmDEbtVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1pK5Q4LAyAhB8d1CWofbh2Jw7OsQ8TZl9WlCE0KWvl173io7/IiujDxScFhWU2g2SDbtHnIsSSd/m1O12lCG+9XsC1fR6AT2Wq0s4qex1RnnZb1nlAJqAAT++QIHpsgHnqQizUohTTOT+xV7I1wQ1w4FiAMAKsiEcvRnQz2+sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SDHpXhFd; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SDHpXhFd"
Date: Fri, 22 Mar 2024 19:07:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711159681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5VkD5z9YkAdX6FArt2jg1nT/B62sh2p7lPRadskyhS4=;
	b=SDHpXhFdepH9Nj+WO/hIIjmvTRVCgXX6AKi+TQQXTYMd1JS/R4MWvwg2QeCz5Aza55n83d
	GkB2zofd2b4riHxCi3zhFaTsWoBg0QiEQG46JIHRc+WKtDgpogxfMXOXnsnveH9HCUaWhT
	pXFNjI9dkhah5sJIwmnK7NeD46SWwrs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 2/2] KVM: arm64: Allow only the specified FF-A calls to
 be forwarded to TZ
Message-ID: <Zf45eDs8Bd1UQ94Z@linux.dev>
References: <20240322124303.309423-1-sebastianene@google.com>
 <20240322124303.309423-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240322124303.309423-2-sebastianene@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 22, 2024 at 12:43:03PM +0000, Sebastian Ene wrote:
> The previous logic used a deny list to filter the FF-A calls. Because of
> this, some of the calls escaped the check and they were forwarded by
> default to Trustzone. (eg. FFA_MSG_SEND_DIRECT_REQ was denied but the 64
> bit version of the call was not).
> Modify the logic to use an allowlist and allow only the calls specified in
> the filter function to be proxied to TZ from the hypervisor.

I had discussed this with Will back when the feature was upstreamed and
he said there's a lot of off-label calls that necessitate a denylist
implementation. Has anything changed to give us confidence that we can
be restrictive, at least on the FF-A range?

-- 
Thanks,
Oliver
