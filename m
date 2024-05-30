Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201C72C6AE
	for <kvmarm@lists.linux.dev>; Thu, 30 May 2024 20:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100092; cv=none; b=ZNl8omRZMOSCWTl3278/yBlJbUH6SnEiBlZWQFZGa0YZQjhJXzJYNe6Q20PQ4xy9BJgVpTk1sd8xFXucXJ1otRl0JH7QTxO/9xPecSwmtAGnuUEIbTBJMKwInxBk8cv+n+/X2ehw7SCDN1cuGrslUp/978TXQBiFUqbDDCQm0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100092; c=relaxed/simple;
	bh=pm2OHvdbws4GBAdykMfTLSXD4OTTixmMjN8EQXO86AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sbr763otXfV+ftRa0k1hVWxpBeV8tdZEbI/C4oiOS3zLtcJiDF0GYWPHjsxwEXvU5BosSegfR3VqiPIMdWCz+IHpxaoftE/8dV7JWPuUpgjk14oX2624jLVupfGyFZ5vpE/lk88YEbEfwtzrawoNfTNQNMBaVU/OTGNNN14a304=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kMlrjMDk; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kMlrjMDk"
X-Envelope-To: tabba@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717100088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WHqrYM/90+56hmxuy9Uro70YD/JFnM5OGmbHcZz5hJc=;
	b=kMlrjMDkrIskoOtDBcp7rAV4z2Js5kzIUEm/mhkmMYb5d+FyJM5W6VlNV/2r3uwqXyXfRs
	0DXIEKI7G4b7u4bwijlFGV9dzYAWFlLEGBQyot+2O3Z6e/5lW2j/08+p6y4HLbXV25Ya7T
	HkyCiAkJNXFcuFU+k5HJiGdEwjUpcEs=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: maz@kernel.org
X-Envelope-To: will@kernel.org
X-Envelope-To: qperret@google.com
X-Envelope-To: seanjc@google.com
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: catalin.marinas@arm.com
X-Envelope-To: philmd@linaro.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: broonie@kernel.org
X-Envelope-To: joey.gouly@arm.com
X-Envelope-To: rananta@google.com
X-Envelope-To: yuzenghui@huawei.com
Date: Thu, 30 May 2024 13:14:40 -0700
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	seanjc@google.com, alexandru.elisei@arm.com,
	catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com,
	suzuki.poulose@arm.com, mark.rutland@arm.com, broonie@kernel.org,
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 11/11] KVM: arm64: Drop sve_cond_update_zcr_vq_*
Message-ID: <ZljeMATYCy8yOesJ@linux.dev>
References: <20240528125914.277057-1-tabba@google.com>
 <20240528125914.277057-12-tabba@google.com>
 <ZljD8pu5Z5ujHny2@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZljD8pu5Z5ujHny2@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, May 30, 2024 at 11:22:42AM -0700, Oliver Upton wrote:
> Hi,
> 
> On Tue, May 28, 2024 at 01:59:14PM +0100, Fuad Tabba wrote:
> > The conditional update likely doesn't help performance, but makes
> > the code a bit more difficult to read. Remove these macros and
> > just write directly to ZCR.
> > 
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > This patch is meant as an RFC, and undoes the previous patch.
> > Please feel free to accept/drop whichever patches you think make
> > sense.
> 
> The motivation behind this helper is to avoid unnecessary synchronizing
> behavior, since as you note the architecture does not require
> explicit synchronization for the value to become visible to subsequent
> instructions.

*indirect reads from subsequent instructions :)

-- 
Thanks,
Oliver
