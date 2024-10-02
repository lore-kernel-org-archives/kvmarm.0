Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0D21D0DDC
	for <kvmarm@lists.linux.dev>; Wed,  2 Oct 2024 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727882147; cv=none; b=h71GGFXgUApRXxaGfVr0uwbOiAxF5JoI5UHTjTXohoNSkWBuqw4DxjckmV8SqqoIQXpG4IAyDsp0rf3q3+VebqW/bfa91Z4RC3XwfwmH7fydocgR8JR+/+obT056egHDRC735UKh/LoCM2s/0+5PL4DPfSIZGFpuwTHghV2FKSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727882147; c=relaxed/simple;
	bh=cSqy+Y3vymMzfEFegTaxBbJQYuRNrId6yjcvXt55yYc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=e4Bpyqy0VQyrj5Y/G0ETZB2obfKatHfX0HBf0qLaKC2si7SmZLJGOOT/L3atCnsjf25eXqotT/oTe1L+sSvOpy4wsasZ0suXj/FpMonndHtebzRGsUU7kPLjxMlGFW+upxO35jjJ718liz7CE62YJZ7qRpue3OmeL4WNhroI6XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=rDvCacMz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=FhIpWKKa; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rDvCacMz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="FhIpWKKa"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1727882144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BmmHochcpTDD7Nu+HELtF8u1Zb7Blq+ChOF2S341j/0=;
	b=rDvCacMzuet95MZzwovEdkA+zsyx3l+zIP/ab4c4JTEvqWEQ6FKDCvoq1/IwwFkFD8NzA/
	P6hBvqRJdInQoqm8kPzJOuXU3yFafwEar1L2ZiBw6IUCUGHipNr3kQC7Dn7tmKSE3pNzeW
	LWVOsmuZrFYYIVP4zdn1hqrq5JeAGIR9lnnTZJ5jlWYLQ6GTRFIOsMfxlgYffXZDCr3ql5
	amScW/N6ty5nLZ17mtHTFVmLQp7VZ3MtmCw4KHQ17gsFuZFwYCkbVKgOaSXRi8iaxJcs7t
	tt72ObY0P76yQOuC/LQuyG1S2lNSq5CdkQHuMqB7wJK05L8IgBK4ReVLS55WcA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1727882144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BmmHochcpTDD7Nu+HELtF8u1Zb7Blq+ChOF2S341j/0=;
	b=FhIpWKKaMXGVRmZoXfaPmBClAoeNc5GNzkxYHFHf39NSc8KrEoqj1zUbkyqd4lEQ8Ap2r5
	V/21uE2P1FuWl7BQ==
To: Vincent Donnefort <vdonnefort@google.com>, rostedt@goodmis.org,
 mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, maz@kernel.org,
 oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com,
 kernel-team@android.com, linux-kernel@vger.kernel.org, Vincent Donnefort
 <vdonnefort@google.com>, John Stultz <jstultz@google.com>, Stephen Boyd
 <sboyd@kernel.org>, "Christopher S. Hall" <christopher.s.hall@intel.com>,
 Richard Cochran <richardcochran@gmail.com>, Lakshmi Sowjanya D
 <lakshmi.sowjanya.d@intel.com>
Subject: Re: [PATCH 04/13] timekeeping: Add the boot clock to system time
 snapshot
In-Reply-To: <20240911093029.3279154-5-vdonnefort@google.com>
References: <20240911093029.3279154-1-vdonnefort@google.com>
 <20240911093029.3279154-5-vdonnefort@google.com>
Date: Wed, 02 Oct 2024 17:15:43 +0200
Message-ID: <87r08ywn6o.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Sep 11 2024 at 10:30, Vincent Donnefort wrote:
> For tracing purpose, the boot clock is interesting as it doesn't stop on
> suspend. Export it as part of the time snapshot. This will later allow
> the hypervisor to add boot clock timestamps to its events.
>
> Cc: John Stultz <jstultz@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Christopher S. Hall <christopher.s.hall@intel.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

I've queued this in on top of v6.12-rc1 as I have upcoming time keeping
changes. I've tagged this commit so it can be pulled by the arm64/kvm
people to base the other changes on:

 git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git tk-for-arm64-kvm

Thanks,

        tglx
