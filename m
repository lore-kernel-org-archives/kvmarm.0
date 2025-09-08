Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213E8212B3D;
	Mon,  8 Sep 2025 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757342396; cv=none; b=b/HvJKFbOHkFNU7wfLqPTZaby86D7gYjl/SYlcAzJLLKLL1GLIkTOtbYU9wSv6xbc/3m4kGj1FdXVoDMZEffJDV8vjvt6jziCoj6gjX+XnaND/4XdQ8ikk+9c5lDSKmtcLKe/E6XCfdd+3wBEmiHHSXdnR3cqL60L/c1xCij+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757342396; c=relaxed/simple;
	bh=S6WX4UEjuqO1DjiVJfdEOy8b5lP1YnGAEtNNX0N44k4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdzcSFBoeZuHPL1kbGQX4tdshMl8kFrCRPJPg/1J0vJ6rEU4OJu5Z9iuy3Svv0YtfapFi3D6x7Eov2hEYyNvHw+aEWrh8PbzBuqpMcfv/MPdL3mWjn6N1wJRNAJK6wzYqJwKx9wvWcZFR/NZVgX6ENiQhQGcEbYjVZ6wwxfjFjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1mAET3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1mAET3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B66C4CEF9;
	Mon,  8 Sep 2025 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757342395;
	bh=S6WX4UEjuqO1DjiVJfdEOy8b5lP1YnGAEtNNX0N44k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G1mAET3hpxgDQuf9PK8DeAaybICZ6ZbbDQPG8mny4p4OYpZ1YlVDysFNLyIk9JbzT
	 1N2i2qOAyFPjx6/H5ouI5OWihPZQr7NsLYx1dmEROjpd6t9xBUjPdAhsLgSAnwfZGC
	 S4dDV2MJ4ZNfaYquNM7vkyYf69mzvHtFs/U+ohkzS1UEoAX38/tPmYNIQ8/DyHPBZ5
	 S6HyvEQWj2O39/yO+UOVDuBKKPrBfB1VWR9XMMVM+WtbXUQeaYYgRX1CR2QUQzyaDd
	 PJvsv8dzOo0vXL3K8P0vOU1qk97fnFiGPt5oGceWZT3ZsMwoNupBkaqmCz4wLE/LhC
	 us80IcHqaqu/w==
Date: Mon, 8 Sep 2025 15:39:49 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v11 0/6] KVM: arm64: Support FF-A 1.2
Message-ID: <aL7qtRZtT687R2IC@willie-the-truck>
References: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820-virtio-msg-ffa-v11-0-497ef43550a3@google.com>

On Wed, Aug 20, 2025 at 01:10:04AM +0000, Per Larsen via B4 Relay wrote:
> Hi,
> 
> The FF-A 1.2 specification introduces a new SEND_DIRECT2 ABI which
> allows registers x4-x17 to be used for the message payload. This patch
> set prevents the host from using a lower FF-A version than what has
> already been negotiated with the hypervisor. This is necessary because
> the hypervisor does not have the necessary compatibility paths to
> translate from the hypervisor FF-A version to a previous version.
> 
> Support for FF-A 1.2 in the hypervisor is added as a precursor to the
> addition of the FFA_MSG_SEND_DIRECT_REQ2 messaging interface. Notably,
> this patch updates all smc calls to use SMCCC 1.2 as it makes it simpler
> to support interfaces that need to accept more than 8 arguments and/or
> return more than 4 values. The list of optional/unsupported interfaces
> was updated to reflect additions in FF-A 1.2.
> 
> Tested by booting Android under QEMU and loading Trusty as the guest
> VM and observing the SEND_DIRECT2 ABI being used successfully during
> guest boot.
> 
> Changes in v11:
> - 2/6:         ffa_set_retval: Add more details about anticipated FF-A 1.3 update. Fix typo.
> - Link to v10: https://lore.kernel.org/r/20250809-virtio-msg-ffa-v10-0-189eeecf8ae8@google.com

Thanks, this all looks good to me now.

Assuming Marc's happy, this should go via the kvmarm tree.

Will
