Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A6F186298
	for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 07:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727335542; cv=none; b=Nlv6O8vqqHdQPwMyNbE+BirTGMRxgDCtplkh+44f+/BHnVc68hETPnvdo7e1n4bKsse5roLVOsM9JcB0L1zW7kJFhQB6MYmffT6UrwRc/0zA0f8BKs77HI81QebVkuC0udlzJnrzfkttBMa3MQmVYt9SxT/Jaxf/WEDQ6oxLX0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727335542; c=relaxed/simple;
	bh=LKz2BWYlC1wcCer0rqsExIwaiuKqjGdcgjs7mcfIdhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4puzyzkcYn+V2i368OqPZ/XmkBX0NL5vAjbF4IZ2kedQpiUmtd65QrhI/vlNIfP8kaRoE7osVn7CdhYQ+IpiTWjogspSfyFdhuzfPrgM86F/He3s0KyIVbAak/hnXFMfiVDrCVGZl1bFcJLg4OoxDRSKy7qyHb49dkzI1X5BSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K/mwP0jE; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K/mwP0jE"
Date: Thu, 26 Sep 2024 09:25:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727335538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t68Dgt6yWbqsMukshTyhqyh1jY4+yGJXlpezi6ogjkA=;
	b=K/mwP0jEZ9zsREYyIkWCF/42FhlrEamH5wF/IFzcqHKsIW6MJBvoRP1V/k3VcPfu1BkbM0
	K76Z+dAiueYbH4gfnlB1BthHvEPE9kAY9shbmhT/pgCObYpbXzOA3pYgNidL+fAEuOPv8h
	Y6x6Zt2+CImb7+xufZgCmHxz9WNfmk8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/2] KVM: arm64: Allow the RAS feature bit in
 ID_AA64PFR0_EL1 writable from userspace
Message-ID: <ZvUMZFdY_j3pUisX@linux.dev>
References: <20240926032244.3666579-1-shahuang@redhat.com>
 <20240926032244.3666579-3-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926032244.3666579-3-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 25, 2024 at 11:22:40PM -0400, Shaoqin Huang wrote:
> Currently FEAT_RAS is not writable, this makes migration fail between
> systems where this feature differ. Allow the FEAT_RAS writable in
> ID_AA64PFR0_EL1 to let the migration possible when the RAS is differ
> between two machines.
> 
> Also update the kselftest to test the RAS field.

Please do kernel + selftests changes in separate patches.

-- 
Thanks,
Oliver
