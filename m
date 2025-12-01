Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297C5201004
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 23:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764631021; cv=none; b=hwa5u8j9XvI6DNWwDQIhXyZasPHU7mb/r5RlVRtRnPcgCYioG5EVPdoqeqTHYHW1knvG/JOpi6/Gf8F1BI9jI4nFcTapXgXcrOsVFOcx8XEX1136b4z8lNeBqHLK3fRAdFnOPC7UUuRJgzCFPW4EIZ+RqXpWJk01MXpC8TCqgIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764631021; c=relaxed/simple;
	bh=1KLyi85UmFzTZFUsXb82Lsd70mhIYwu67P6P78TQTYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uFcV5MqL67iyDlpWtSS7ywsiES0wbZpUJEinbfyYwGNFzQNz8WaWAoWatdK3VGVdUYNftQxjSfWgLcP+i/6tztQV80QftcTfF0VzopAeMhj6NcisumwXKrzZE4hY/r+z4g6cAJMSQXsWZpPhOgtd/e09LjYd/ObYlAfNPwXNrZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cq+ULEt8; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cq+ULEt8"
Date: Mon, 1 Dec 2025 17:16:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764631016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1KLyi85UmFzTZFUsXb82Lsd70mhIYwu67P6P78TQTYA=;
	b=cq+ULEt8h6+yhwbAxcraNneWQG/qcmSc3/vgwxWQ+q5zWbhoGE4v9A42gEeh+G4KQ6uYco
	UXKJF0T2apAN+LYsm1Np9PACcs2uuBahH62gI2vK/nqoIuYQe3TRJcSXplGOK9fNaonUTf
	PLFDpayr5rOn3tQ4qd1YypsQzW75dOc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	alexandru.elisei@arm.com, kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251201-2ae3e986e3c1242e7bafc247@orel>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
 <20251127110832.GA3240191@e124191.cambridge.arm.com>
 <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>
 <20251127145207.GA3265987@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127145207.GA3265987@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 27, 2025 at 02:52:07PM +0000, Joey Gouly wrote:
...
> I will send out a new version with this fix, missing sob/reviews/acks, after you've had a look!
>

Also please run checkpatch on the series if you haven't already. I think
it should have complained about the C++ comments, for example. And, in
any case, please change the C++ comments to C comments and generally use
the kernel's coding style.

Thanks,
drew
