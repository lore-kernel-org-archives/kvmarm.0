Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287083659EB;
	Fri, 29 May 2026 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780068752; cv=none; b=dvLWF8dlew/u57GT362uGjwq90/bh5wepYioVyKRS4/o9RLJes/TWFz7P1ra8Niq6zlTZwDATztnJQMbdw30GtBLO6InPP304kw5G0P/8ZEuWUMLvDtlPxPi4Y9jF+n6T1EasycgednhrWYiVpzmLpKTBIChYhHyhGR9QsnOjc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780068752; c=relaxed/simple;
	bh=PaOL9OFYQHOiY4nBl5UhDkML+6X5notbspaX2VqRNd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lfJc1ThXPfTWDVH5p7oNL6w9JKWRjX2icsBXuWnbWP3RiKrEpQRUYYclDh66fBNnFoLQ+FQOqLaLQtiTygm6c/tVPhzs/VDgGNopN+6lQHmn88voTLSyLd1ePrcJ+9qiaLB71pG6FZ2F/5OqUZeft+uTHfpHtUCQnqChPHttZXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMvL7YXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMvL7YXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DABD1F00893;
	Fri, 29 May 2026 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780068751;
	bh=PaOL9OFYQHOiY4nBl5UhDkML+6X5notbspaX2VqRNd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HMvL7YXkOKjoSHY3EbotLPeMvGmQ92s0pJvOwoTsS6LqXH8rZWyQILgrQm7p2sGo9
	 8cz4W+VbLPqZDup2cB3toxzjsbFLthob4OxFGghE1957lBTT3K9Xm3QPK6SXRKEL7c
	 U1kf+F6G7PEMiYkHyE2saaJoX8At7+hUR5fKVz8h+EAL80aujSzmAt7kCimQ4ARTSL
	 lMWEgylkqNPlTzQFWyfMrAFJPMjM7RTE0EMLTWvhZfep92xiOFn/DeoeQz6nBsSIVN
	 r/YSeyeJLygcv8I51MAu8jo1WVKzJTmUXx9HlZXUmj/gprRAPHBctOPUwTryz4wEqF
	 NVxTu3RH4Zdkw==
Date: Fri, 29 May 2026 16:32:24 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: Marc Zyngier <maz@kernel.org>, catalin.marinas@arm.com,
	oupton@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Message-ID: <ahmxiFXXTupafbXw@willie-the-truck>
References: <20260501114447.2389222-2-sebastianene@google.com>
 <86wlxgy00t.wl-maz@kernel.org>
 <afxuDpecPCVA56cL@google.com>
 <86se83xrwx.wl-maz@kernel.org>
 <afyd8u85L5XIl6dh@google.com>
 <86qznnxptx.wl-maz@kernel.org>
 <af3fW468-f1KXCrC@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3fW468-f1KXCrC@google.com>

On Fri, May 08, 2026 at 01:04:27PM +0000, Sebastian Ene wrote:
> While at it I discovered that none of the FF-A calls in the proxy
> currently check for these SBZ registers. Would you be ok with a diff that
> fixes this before the patch with the notifications ?

I'd probably structure it as a separate patch per call, tbh. That way,
the commit message can talk about the specific fields that are reserved
for a given call. See below.

> Refactor the handling logic in pKVM FF-A proxy to support checking for
> SBZ/MBZ values. While at it, drop the do_ffa_mem_xfer macro and replace
> it with two functions that make it clear that we re-write the
> function-id with a 64-bit variant, to keep the same behavior as before.
> Keep each handler in an array of structures together with a mask that
> corresponds to the SBZ registers the spec expects.

Although I agree that we should be enforcing SBZ/MBZ paramaters (because
we have no idea what they might do in future versions of the spec), I
also think that doing this at the register level is too coarse.

For example, the VM ID parameter to FFA_NOTIFICATION_BITMAP_CREATE has bits
31:16 as MBZ. So I think we probably need to do the checking on a
per-function basis, like Per is doing in his series:

https://lore.kernel.org/r/20260501-host-direct-messages-v6-0-3f4af727ed85@google.com

Will
