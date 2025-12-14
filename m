Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E031DDF3
	for <kvmarm@lists.linux.dev>; Sun, 14 Dec 2025 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765714732; cv=none; b=GHO+iQpKi2HlOK7eU1/JRnVCg72qlCrjhtjCiBHq/oZthiKcwV7AUyT10dNOG7c5iO+SDVvFDCaDUcCQrAoSGkFEIxwuBXjE8jXKm2Z+coQ6B3pnnGTax5i8JwW/JdsOUstAMrK7wTriscn777PefqCBxVP50z6tpJF1egkCMvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765714732; c=relaxed/simple;
	bh=Wca8yvalyxtSQH/XJSSaImT9Ra4CF5mpJ5QmuhAfhAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUZJTOv3bMgWPc5LPkIC8wVyNwLpBwGI788RocUwOzaIlOFbQq++o7m//7xEBWopmw16JXA4lXEsqh5EgoZ5GRJugkJa0/qYtzxEGvYgJy9aljvmh6HN1QTu7OYlp76qsnh0SStg4GaALMjY0zDYGBaLe0oCu6TVKOR0Djb8m9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vTv9hKGM; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vTv9hKGM"
Date: Sun, 14 Dec 2025 20:18:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765714727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e0Rtq02u4ALdXbWLdQuFWEAwLztJaqUa3MxILk+qipg=;
	b=vTv9hKGMVqpUCNXD7Kr50vG8fAIReJ542cYQqEEak4yI4RoUqGG6jT41ppiGt+T6TY+Siy
	I29EoPf4ZlKjjCw9+0OIAIrXHOjTE2b34qjlqACRhKNVzB4k5V2LLkk5mfBVfWmyxChlq0
	64w0lUqBVOVz9sOjOb+t7KVunN6jGIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leo Yan <leo.yan@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, james.clark@linaro.org,
	mark.rutland@arm.com, james.morse@arm.com
Subject: Re: [RFC PATCH v6 05/35] KVM: arm64: Add KVM_CAP_ARM_SPE capability
Message-ID: <20251214121842.GA16796@debian-dev>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-6-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114160717.163230-6-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 14, 2025 at 04:06:46PM +0000, Alexandru Elisei wrote:

[...]

> +void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
> +{
> +	struct arm_spu_entry *entry;
> +
> +	guard(mutex)(&arm_spus_lock);
> +
> +	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return;
> +
> +	entry->arm_spu = arm_spu;
> +	list_add_tail(&entry->link, &arm_spus);
> +
> +	if (list_is_singular(&arm_spus))
> +		static_branch_enable(&kvm_spe_available);

We can simply check if list_empty(&arm_spus) in kvm_supports_spe(), thus
the static key kvm_spe_available is not needed.  Another benefit is this
is consistent with CPU PMU's virt implementation.

Thanks,
Leo
