Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DF04C602
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 18:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717093375; cv=none; b=FxbCdw+3Q48eoWxZXnbPcsn8h/GCITtoRzi1BVC5ISptWqAJBZ0VI99UYldNAtTrkRqSUDbwPwvdlZK48c5CDJi399M8g2x4qw/vQB9OGKZv69aZtdHXK6dHan6jEwNPI0Z2Q/DMG+69WDSgeXgW1leO8szOYYE2GMaseA0H3AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717093375; c=relaxed/simple;
	bh=ra9lg76e31jVLXeUi+YkRMILBYm8WpwK09DQo5Cp6j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGk1UKyRjOyiWxMn+kS36+MLHjHW8YmQNouYP3ng/hdzcE2XbU2F6+aBAShX2CvSR5WREKXKjIgkxejAFJ/oqqXAiu0PMJlSMec3lymoes+/fHTtNQgT9FXGx8rR1KIwzW+HKDlfNptYdsWgrpGj2QB8DBp5/ZOE9RexEV+HSV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pOsEI3uV; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pOsEI3uV"
X-Envelope-To: tabba@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717093371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QSPX1FdincyYLkPXPIkPhXLJz2aAmMImLOXrXB0/Whs=;
	b=pOsEI3uVmMjv3KIHQGeT3EUqH00Rfdb/uHiw5lqDnWajvJNv5dxOfC0q7WxEvHdFuxQzGs
	xyDLEntOC9tirHdoSItkCb5ngxYmg691fd4+35WYpi8dUFcM5+ZC8KpnoL+XoucFUOPkle
	yjMOxVXKg7sEwN5M/mIO5JaaC+EP0QI=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Thu, 30 May 2024 11:22:42 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 11/11] KVM: arm64: Drop sve_cond_update_zcr_vq_*
Message-ID: <ZljD8pu5Z5ujHny2@linux.dev>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-12-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528125914.277057-12-tabba@google.com>
X-Migadu-Flow: FLOW_OUT

Hi,

On Tue, May 28, 2024 at 01:59:14PM +0100, Fuad Tabba wrote:
> The conditional update likely doesn't help performance, but makes
> the code a bit more difficult to read. Remove these macros and
> just write directly to ZCR.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> This patch is meant as an RFC, and undoes the previous patch.
> Please feel free to accept/drop whichever patches you think make
> sense.

The motivation behind this helper is to avoid unnecessary synchronizing
behavior, since as you note the architecture does not require
explicit synchronization for the value to become visible to subsequent
instructions.

Now, that doesn't _necessarily_ imply full blown context synchronization,
but it isn't too far fetched to think a conservative implementation does
exactly that upon ZCR write.

-- 
Thanks,
Oliver
