Received: from out-7.mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB00CBA3E
	for <kvmarm@lists.linux.dev>; Tue,  4 Apr 2023 15:55:31 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680623729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GuYBin76hkfJiYTtPD829OLQWP5hqDXuQw4VPR0xUHw=;
	b=rESjDZzNTvYOlJSw825fCcuh48L+JbFC6F/lBV7DLxLbFQZRuCmQtmcuY0MTko87JLTM4q
	CemWslabU/Z6GlJZbwChujWRleIMnUqz3G6EcvF/h+dYXM5XKdwzJG6p+/dw3uWTKJBFMW
	8YNq8PfsGD4h25WcUAU4N4Y2t2bRvoI=
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev
Cc: Oliver Upton <oliver.upton@linux.dev>,
	maz@kernel.org,
	reijiw@google.com,
	pbonzini@redhat.com,
	will@kernel.org,
	james.morse@arm.com,
	alexandru.elisei@arm.com,
	jingzhangos@google.com,
	ricarkol@google.com,
	rananta@google.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v5] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
Date: Tue,  4 Apr 2023 15:55:02 +0000
Message-Id: <168062368625.2273324.5598128605478041262.b4-ty@linux.dev>
In-Reply-To: <20230404152321.413064-1-tabba@google.com>
References: <20230404152321.413064-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 4 Apr 2023 16:23:21 +0100, Fuad Tabba wrote:
> The existing pKVM code attempts to advertise CSV2/3 using values
> initialized to 0, but never set. To advertise CSV2/3 to protected
> guests, pass the CSV2/3 values to hyp when initializing hyp's
> view of guests' ID_AA64PFR0_EL1.
> 
> Similar to non-protected KVM, these are system-wide, rather than
> per cpu, for simplicity.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
      https://git.kernel.org/kvmarm/kvmarm/c/e81625218bf7

--
Best,
Oliver
