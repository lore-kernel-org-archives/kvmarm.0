Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BFA31B128
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355820; cv=none; b=Y0UfApmyHo5xOEmN2SZxV2c4vbSDPu9eiAztWkwFXc86oPpxh13uga8asPA40/+iHtwfiUOigW3LgTkmDoa9GrGotfE0/Ih5OD2EbLybxRPwZatlBUl6acMaLzK3WS4UDAkWM+5EvMnNXsHz/100F/x7GjRqY403acUaFUy5KNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355820; c=relaxed/simple;
	bh=ag+FLIW9TcRTeXefgOCiuIDZYedilutf7L3HblgW/cs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a+IkQFHBGeOlwQnQUdLUK9JUHIhVX82WNJQH17fwukG+JjGK74QBxojY90xZUiX/bPlfPsAmeUam4Fsx8NosLWCxAlB1yteil6HLIYw9iPkGQLIyJNcxtuXU7VGeVGmwnemqo2US2yIykMD854mHZcofqkbXaunc/C8KYGagJUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D6rKnMve; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D6rKnMve"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757355815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JVGGqRZBAm24OtLHJX+wyXUcc8yBv/hwqlqTCh+kbiI=;
	b=D6rKnMvef2XGDvo9OwgPQQ3inWRixjXsipxt2M7RJVwLnY4Iq3qWvesP8y5QqgvP2qLdBv
	YV5oobdQrWxYjDbX5YoiWAK6bqsImHyddB2e5uM4mCL9Jec3RemC7Laia3BbXDNKVkypfo
	imMM7/YOWf85hVWpiUgeRt0p6Pm9uj8=
From: Oliver Upton <oliver.upton@linux.dev>
To: jintack@cs.columbia.edu,
	christoffer.dall@arm.com,
	maz@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: vgic: fix incorrect spinlock API usage
Date: Mon,  8 Sep 2025 11:23:23 -0700
Message-Id: <175735577932.2363175.14048203051041035424.b4-ty@linux.dev>
In-Reply-To: <20250908180413.3655546-1-alok.a.tiwari@oracle.com>
References: <20250908180413.3655546-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 08 Sep 2025 11:04:11 -0700, Alok Tiwari wrote:
> The function vgic_flush_lr_state() is calling _raw_spin_unlock()
> instead of the proper raw_spin_unlock().
> 
> _raw_spin_unlock() is an internal low-level API and should not
> be used directly; using raw_spin_unlock() ensures proper locking
> semantics in the vgic code.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: vgic: fix incorrect spinlock API usage
      https://git.kernel.org/kvmarm/kvmarm/c/2d0478279fc7

--
Best,
Oliver
