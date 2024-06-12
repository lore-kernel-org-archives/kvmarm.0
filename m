Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7641517DE39
	for <kvmarm@lists.linux.dev>; Wed, 12 Jun 2024 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203114; cv=none; b=boEMtWSdcP3VOmYdFSEfOQ94ijiQfVF+k8A+pgQUYiXxsbQxeYw5zkwyaXpJHjwTiijojkkCjSsdm7WsPIcCrvF2TAhC0S1v7QRHHpSHAyjWb3K1CROrs8VH9Sm/Nhd49Jh2qjcPMjvgY+NOb18uAQRpCbUNj4yGST99S7y9pDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203114; c=relaxed/simple;
	bh=bCrxt2my4m4yrSCXVplFBO+/qFMZHZ9RKEK/ZDlmOM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EyYWNl1mfcIf4ioJb6z/dMo/SM3qDsYY6JnE1Gf9r4+mtzd2KGFWArHAMw40f5jArpIUtx414u5/NUZFzxUhq4OqQVZfriqi2KTjN7fjN60zvnXyszrFNdmbKepbLsl1E0sZHE9d3MDllnhB+lbI1DU7JPorFD1bmx9ukfdx+9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42D121063;
	Wed, 12 Jun 2024 07:38:56 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC7633F64C;
	Wed, 12 Jun 2024 07:38:28 -0700 (PDT)
Date: Wed, 12 Jun 2024 15:38:26 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	Sudeep Holla <sudeep.holla@arm.com>, maz@kernel.org,
	oliver.upton@linux.dev, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, lpieralisi@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Fix the identification range for the
 FF-A smcs
Message-ID: <Zmmy4pmgLFZNhXqp@bogus>
References: <20240515172258.1680881-1-sebastianene@google.com>
 <20240515172258.1680881-4-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515172258.1680881-4-sebastianene@google.com>

On Wed, May 15, 2024 at 05:22:57PM +0000, Sebastian Ene wrote:
> The FF-A spec 1.2 reserves the following ranges for identifying FF-A
> calls:
> 0x84000060-0x840000FF: FF-A 32-bit calls
> 0xC4000060-0xC40000FF: FF-A 64-bit calls.
>
> Use the range identification according to the spec and allow calls that
> are currently out of the range(eg. FFA_MSG_SEND_DIRECT_REQ2) to be
> identified correctly.
>

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>

Not sure if this needs to be fixes though. With addition of notifications
in the FF-A driver(since v6.7), host can send FF-A messages beyond 0x7F.
But since the pKVM FF-A proxy support is not yet updated to v1.1, so I
don't think it needs to be tagged as fix. Just thought I will mention it
here anyways.

--
Regards,
Sudeep
