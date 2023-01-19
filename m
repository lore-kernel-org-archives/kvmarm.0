Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37FB43E
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 19:38:12 +0000 (UTC)
Date: Thu, 19 Jan 2023 19:38:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674157085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H6H/+GrpC5ozTA0QyGnONZD4lm6LEL1WMI8opKr9p4U=;
	b=rLcXA9s8GMAEiuzs/GY0vRCq7owrSN043xwnUr2oJMiLfJUP82mSjFyYqA9+bYcdG1mD9h
	+WRueuBGjYyziSUaDRoJyCIpJe/hTSUPqqxjcQ7Diq8O9q4W9vC4LTokGs7K+cVVU4RSRV
	B2BmYr2z5WjMx1pDjt47/SlfvHiCo0o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Pass the actual page address to
 mte_clear_page_tags()
Message-ID: <Y8mcGfapmXJSHkdH@google.com>
References: <20230119170902.1574756-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119170902.1574756-1-catalin.marinas@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 19, 2023 at 05:09:02PM +0000, Catalin Marinas wrote:
> Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
> initialisation") added a call to mte_clear_page_tags() in case a
> prior mte_copy_tags_from_user() failed in order to avoid stale tags in
> the guest page (it should have really been a separate commit).
> Unfortunately, the argument passed to this function was the address of
> the struct page rather than the actual page address. Fix this function
> call.
> 
> Fixes: d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>

Yikes, looks like we should pick this up for 6.2.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
