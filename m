Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE9F328B0
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 16:47:44 +0000 (UTC)
Date: Thu, 28 Sep 2023 09:47:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695919662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wveZV/OpMnfjYWiQaY9ODeOIzpESq4cgbicBnYivGwk=;
	b=AD+KxXFw3jS2YoHuX20ZNxTD8+hrALeFSW0wAeV6Vjor2bsIyDZYKI++uX1ccll5mauxTK
	3vNa+wMJFMgf7fC52qho8oaplJQ1YmKsx2wkjjIVQOibksmRnua8ruhBqfkhPU7zhxNTaH
	gu+EXU2wTEIgkokCVjRRcrZJyrWRncM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
	catalin.marinas@arm.com, dave.hansen@linux.intel.com,
	maz@kernel.org, shuah@kernel.org, will@kernel.org,
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 06/20] KVM: arm64: Save/restore POE registers
Message-ID: <ZRWuJ9jses6b7Lmc@linux.dev>
References: <20230927140123.5283-1-joey.gouly@arm.com>
 <20230927140123.5283-7-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927140123.5283-7-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Joey,

On Wed, Sep 27, 2023 at 03:01:09PM +0100, Joey Gouly wrote:
> Define the new system registers that POE introduces and context switch them.

I'm not seeing the latter part in the diff. I was anticipating that the
POE context switching hooks into __sysreg_{save,restore}_{el1,user}_state() like
we do for most other bits of sysreg context.

--
Thanks,
Oliver
