Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9711F190E
	for <kvmarm@lists.linux.dev>; Thu, 30 Jan 2025 21:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738273756; cv=none; b=XGietWTdz5lZr7LhNujWIsoovaPzIWIGo2Jd6+uA7K6oPkcNr/772+JLLlqhTmSXt1Y3ADHADcyiLjsE3HpsA/m7FQgYSzy9eeDc14VbKOF6VgthbowxZPTtiw31M8xDBU9RMI090Gj6ZN2Px2wQw7HEZ3DJfmQlIuZRinDcpeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738273756; c=relaxed/simple;
	bh=/jk17HKnQBqsrFufLUi6DJFpzmOrK7kYtCZ6DXenHvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jKxDBLq0UMRcL8PC0NNvyaD+YuUb9snH06NDrU7SGITmPKIQ9gd89bgbR8nC+ImR1ODttVf0VqtZKWC1Z5j5grnw0sbyjdGF+hoVDClBoX2jD0xqyXLqg9ADZRuEEmrw0l2ENqU6Fwfi59P2/V+a4MmoOF/Lp8tt0FB5/qlpt0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wyAaLoFx; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wyAaLoFx"
Date: Thu, 30 Jan 2025 13:48:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738273752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DzIpYfPJ/7jjY8MUJnl7/c0IRpxedLFzmYOrf95yEwg=;
	b=wyAaLoFxTNp7NtBA7ltJEMgmkgZO1t5kHhHTzCXxMrz5xWIfjVjv3QdkQ6cXfS5HPml0/8
	Z4+cXx4xfC+VGlDRB81J7NwSxF8Ewppka2gBvqBstQitdKe8hBYvIpKdK42lFeB3LfS/Ye
	wL/lwc0bKiNOv+qRXy1s98i7sfyPDio=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	joey.gouly@arm.com, kvmarm@lists.linux.dev, maz@kernel.org,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH 0/4] arm64: mitigate CVE-2024-7881 in the absence of
 firmware mitigation
Message-ID: <Z5vzxWX4AY-JY4TV@linux.dev>
References: <20250128155428.210645-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250128155428.210645-1-mark.rutland@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Mark,

On Tue, Jan 28, 2025 at 03:54:24PM +0000, Mark Rutland wrote:
> On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
> a hardware prefetcher to form an address using the contents of a memory
> location which is accessible by privileged accesses in the active
> translation regime, potentially leaking the contents of this memory
> location via a side channel. This has been assigned CVE-2024-7881:
> 
>   https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881
> 
> Arm's recommended mitigation is that firmware configures an
> IMPLEMENTATION DEFINED control bit (CPUACTLR6_EL1[41]) to disable the
> affected prefetcher, and updates to Trusted Firmware-A are available to
> do this. For systems which have not yet recevied a firmware update, KPTI
> can help to mitigate the issue.
> 
> These patches enable KPTI for affected parts when the firmware
> mitigation is not present. The presence of the mitigation is identified
> by the presence of the SMCCC_ARCH_WORKAROUND_4 SMCCC call, which was
> deployed with the mitigation. This is documented in the SMCCC 1.6 G BET0
> specification:
> 
>   https://developer.arm.com/documentation/den0028/gbet0/?lang=en
> 
> I have tested this on a few configurations of virtual platforms. I'd
> appreciate any feedback, especially on the KVM changes.

The KVM changes look reasonable and follow the usual model for this
crud. It would be nice to report the mitigation state to userspace
somehow as I would like to have a KVM selftest for all of the hardware
vulnerabilities.

But anyway,

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
