Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BA23A4F22
	for <kvmarm@lists.linux.dev>; Thu, 15 Jan 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498247; cv=none; b=dHmiMtPbTZ+iNWoVMFrxWuvOICsosE+e/tiEMkp+EnecYx0GKGfCwsptHcngEQgi+N6Q1nN4VeJa+qskI7ukjtQIjkr+3+Yow7ORWZ9DLmqjndRkPxZqZM14qiJ6EL+gyA16/Z0yC186tZCdqXgZEBNdpIqW3+3nJZtePvNqV1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498247; c=relaxed/simple;
	bh=nmUei4TWMFsrDZxn9CRbm7JZt9iyQJlLYr+BqeItqEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9Bkbk2i5WxB19BvBQAxpZcsbbt1L3CjE/58zuLO4l4SN4L72MEWMX4gtO8jZUKGV1ECioVBT9X4qUoOcUEX5MQF2DmAB/3KCIc9o0zjtWomDQrnduoQLS59QF2aKywdTNGrjNsQIq9UEE3qdkqaFdtQw1WBxGDflPFY1E99c8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bEflFjYi; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bEflFjYi"
Date: Thu, 15 Jan 2026 11:30:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768498244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2XHCcQ5RvNV9rRhdnbL/hMu704i8VbVjyaw00qwkV0E=;
	b=bEflFjYiGuXC7+zHZXJxoor97+7TsWxRGl+QCxVaObdb5aep1oFhRPDPshOX4HOSYG6yZK
	z3QIHAGuxnvqDTAyuJYkcQqE1X/8qHnqbRj3xDzsWOGmIWKYRtMH9ypQr2q0UvaDx+msnZ
	/N83R45xXXclaseaJYMvJN8JpK74PG4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	maz@kernel.org, kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v5 08/11] arm64: selftest: update test for
 running at EL2
Message-ID: <bsdenjgak5hzc43qlik7lx7krvlm36qijto24kwpfk76haciaw@wkbpo2wgv5fp>
References: <20260114115703.926685-1-joey.gouly@arm.com>
 <20260114115703.926685-9-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114115703.926685-9-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 14, 2026 at 11:57:00AM +0000, Joey Gouly wrote:
...
> +static void test_exception_prep(void) {
> +	expected_level = current_level();
> +}
>

This failed checkpatch ({ needs its own line). I fixed it up while
applying.

Thanks,
drew
