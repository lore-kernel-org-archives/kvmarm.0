Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0AF22313
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 01:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707788634; cv=none; b=urfYi5zLjdgYulnu9Y42kcLMP6x5tc9l9ZMy5WQydcjjnzuQ+Da2dUZuMe8tMJ6zBXFIrrpRwg91rGXBIk+tcEItJk0QRhTQPICmiA2rhFh5sZlftUe800ERnap0e4lGNHtpJY8+HR09LRlC7nhu9Jd4/Gb/WG5cgdNWkj2Sdeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707788634; c=relaxed/simple;
	bh=TXuS2TssiOSkJMhoxy8H08CjJ973E8uafU+ukFCKIhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lj5vp6LzHRQSE/ffcR3gmNYKXQXRcOkgCmp+WYWBrCB0vJVz3H3BNHo45AE7tlFijokXrKNlq8lLIC7Gbf8DOH5EShXRgsQnQSVgjTBFYX/7z34bV8AFV251D4fGIAkPAgEGK5qPm+FEYQxse1IL//3fjHVV1g2oWjLfy8GplV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vyKXQ2px; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vyKXQ2px"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707788630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBqvF0QUm2o6p7011Huo34bPUEy9yxCkZTpXlg9c17E=;
	b=vyKXQ2pxsLXd4w42dHlvY922AIwxv3hFacw0GJO6An1Y2TRLP/zJfTdWyMOQRe8YT01Smu
	yxnEoraK3kwDAtCYjUNxXCbNZa+S3wZTYp5R5Out0rfUfbsu6gkYD4jGZOSHgNztZajEjs
	yLXmVulb+bP5/BpZtTvgcZ066ml9A+c=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	Raghavendra Rao Ananta <rananta@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: selftests: Print timer ctl register in ISTATUS assertion
Date: Tue, 13 Feb 2024 01:43:37 +0000
Message-ID: <170778861235.3388601.17324166104482314804.b4-ty@linux.dev>
In-Reply-To: <20240212210932.3095265-2-oliver.upton@linux.dev>
References: <20240212210932.3095265-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 12 Feb 2024 21:09:33 +0000, Oliver Upton wrote:
> Zenghui noted that the test assertion for the ISTATUS bit is printing
> the current timer value instead of the control register in the case of
> failure. While the assertion is sound, printing CNT isn't informative.
> 
> Change things around to actually print the CTL register value instead.
> 
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: selftests: Print timer ctl register in ISTATUS assertion
      https://git.kernel.org/kvmarm/kvmarm/c/8cdc71fbf655

--
Best,
Oliver
