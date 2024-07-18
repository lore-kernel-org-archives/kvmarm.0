Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B804D8BC
	for <kvmarm@lists.linux.dev>; Thu, 18 Jul 2024 06:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721282963; cv=none; b=sfjLrlMddXKvf46vKrsFWXT3DpemN+iJ8L8MJZaSpmHDus7EwLQ/QwLauJVYBsQGpphTfBCQ6F06ezATdhAL3MfHD3055yzEsKxbMwvj+V26kX5FRR7wvRQTBgw/fBQ/4/TcwmhPBpuAvfrVu/qpAypK7rd2oHbhfup18RrUwlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721282963; c=relaxed/simple;
	bh=8TELw1GSGX+NLZTXJBpEVR3AisUwDBU+WRnsu8/phTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nt0aNqmbbNtUbreCKs6U3aOzf+QbCMUxuiFibSmbqLoxeecZjunEbfV7tkMAsGb4qhAUb83aopclY9qaQA+u2Adc79MrqmHy49cp000ZoMH+HZEHYIBaipfVI2OwvBqNyEByAL4i7Nnx+Y5tiSemRDQ1gR4fS5P4ZOjTxun3kvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e1SBxS09; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e1SBxS09"
X-Envelope-To: shahuang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721282955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wUojTRMLIjKYQq/hlr2+G8wV6gdnpgRx4UJFibcBjBU=;
	b=e1SBxS09mQ3CMf4e+UZpBoSQDSzMz1BJzitVzq98YCRnQS3ndTKz7jp+cC68IJ+RNx6VUQ
	TaAbG1IGb/gycpsjVZrl2K+oYxRLylCdnHuDyeXPA2z7WvmvaUJOwv1GdeoxqR7jH9YAUq
	6YCpUdssAdsYsyMPD2OrAzqavsge2zI=
X-Envelope-To: maz@kernel.org
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: broonie@kernel.org
X-Envelope-To: eauger@redhat.com
X-Envelope-To: sebott@redhat.com
X-Envelope-To: cohuck@redhat.com
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: will@kernel.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Wed, 17 Jul 2024 23:09:08 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] KVM: arm64: Disable fields that KVM doesn't know
 how to handle in ID_AA64PFR1_EL1
Message-ID: <ZpixhBjsqhWTpEQH@linux.dev>
References: <20240718035017.434996-1-shahuang@redhat.com>
 <20240718035017.434996-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718035017.434996-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Shaoqin,

On Wed, Jul 17, 2024 at 11:50:14PM -0400, Shaoqin Huang wrote:
> For some of the fields in the ID_AA64PFR1_EL1 register, KVM doesn't know
> how to handle them right now. So explicitly disable them in the register
> accessor, then those fields value will be masked to 0 even if on the
> hardware the field value is 1.

It is probably important to note that the only reason this is safe to do
from a UAPI POV is that read_sanitised_ftr_reg() doesn't yet return a
nonzero value for any of these fields.

-- 
Thanks,
Oliver
