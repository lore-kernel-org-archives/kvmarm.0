Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6F1D517
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:40:55 +0000 (UTC)
Date: Wed, 16 Nov 2022 17:40:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668620453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UeHzaO43ieDLq7wwhIBNc0s+wJATCXogm0raxMCfGWE=;
	b=pqyd2RsnfABs06vS5s5WxiQGhS1jRoM4fH9iQsAOtiiS8O6XHYiigIlXxmCrSjoF4nMzly
	pY5mZkvWrJSuVRNxiqWNrnZenDNsvOeGKDMFOO0zdxlmTp4wH0/E5dYOxICw9PktqrNXG/
	6DZliVD5ffi7Gn6qCuvX0xTylIrybgY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	Andrew Walbran <qwandor@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 03/12] KVM: arm64: Block unsafe FF-A calls from the host
Message-ID: <Y3UgoIlukWSrT1WY@google.com>
References: <20221116170335.2341003-1-qperret@google.com>
 <20221116170335.2341003-4-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116170335.2341003-4-qperret@google.com>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221116174048.iRRKNAtGlRduBEKrCe11fIJ51nD6v5SWCZCZHg_syKM@z>

On Wed, Nov 16, 2022 at 05:03:26PM +0000, Quentin Perret wrote:
> From: Will Deacon <will@kernel.org>
> 
> When KVM is initialised in protected mode, we must take care to filter
> certain FFA calls from the host kernel so that the integrity of guest
> and hypervisor memory is maintained and is not made available to the
> secure world.
> 
> As a first step, intercept and block all memory-related FF-A SMC calls
> from the host to EL3. This puts the framework in place for handling them
> properly.

Shouldn't FFA_FEATURES interception actually precede this patch? At this
point in the series we're outright lying about the supported features to
the host.

--
Thanks,
Oliver
