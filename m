Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5AD2E7397
	for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792336557; cv=none; b=eRrr3f4FGPS2NLoH7poP8k0piFXD7ZGTchzLnw1Zz9kaukToSrnetoO76zt8csZ4fl2AE8ZuBw3crXvFdrNN7BGiybqAObkFcyrm6JhM6Upk+Wv+wcw0bR0L7geUgFWR2j3P9qW3rpN0RSbYZK0+8H8QwDm595fctJX1EqUX1i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792336557; c=relaxed/simple;
	bh=RUm21wybWqL1C0tU5LmH7zuYeC/MbYwsi6nzJRHIrMo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F90i+FAY6DJl1vWDf2joCOtpPQhNizqx6azq3BFDI4+sR0OQxdrf1UjXk0Y9CwZexVgffUwx2iyNV4a3R9xLdgdx5eUQIsnTcFe+UoQ8rssCUCXXVbw6+EGUZMDML5DFgQZDhSsq9xRey+kkRsq+7Cyq8J19jO06ZMgtOU/VGYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AsoCKV+t; arc=none smtp.client-ip=95.215.58.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AsoCKV+t"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=RUm21wybWqL1C0tU5LmH7zuYeC/MbYwsi6nzJRHIrMo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792336553; v=1; x=1792941353;
 b=AsoCKV+tOsUOtIoRNiId21Jp8WMKr8R3gbuepPEwuSs98nX5+tnvP7QH/WAS+DiWncjFC4Ya
 jj9Pl7ruLK4GPMWIcLnJgX8UzkfoUUBOT+b7y4dPHSMk1UA7ZS3QLH2bgsHgr+TcXtD602xu58d
 5zw8lZDo6DpxBZnAIewK65p8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 871f49ed8eddb8e9;
	Sun, 18 Oct 2026 15:15:53 +0000
X-Mizu-Trace-ID: 871f49ed8eddb8e9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so5767e87.0
        for <kvmarm@lists.linux.dev>; Sun, 18 Oct 2026 08:15:52 -0700 (PDT)
X-Gm-Message-State: AFq9FYIPKa7jUZ7Jz5ogmWpqmjszkn6JQ2lG8ctkJ7dQ0culaFtDIY+4
	4aR80v23CbnUqJiM0aT+pW926Ipb15MIiRKTSBJ0GTe/K+P6FdpRmGEkfHkmcZjsBMYA0WnOrC5
	NnW/CuUCev8kbhL7PdJRXuDO8J+v1upPCXe5Z/KQ2
X-Received: by 2002:a05:6512:10d2:b0:5be:58ad:1ba4 with SMTP id
 2adb3069b0e04-5be58ad1cccmr43392e87.6.1792336551261; Sun, 18 Oct 2026
 08:15:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261018080921.3942517-1-fuad.tabba@linux.dev> <sashiko-outbox-176009@kernel.org>
In-Reply-To: <sashiko-outbox-176009@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 18 Oct 2026 16:15:14 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyQ-fMMAdVbNpRBRmABox9PT4qYZ7sA3_6oY8R4QVRnvA@mail.gmail.com>
X-Gm-Features: AclHuK8dSQbR9LjwbMs0rF-y41vhMpIYsrkhkNskk6dXGkghovZjiIfZf9BAEHY
Message-ID: <CA+EHjTyQ-fMMAdVbNpRBRmABox9PT4qYZ7sA3_6oY8R4QVRnvA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Only enable S1PIE and S1POE with the
 features they imply
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Sashiko, I see you're on Argon now... way to go!

On Sun, 18 Oct 2026 09:29:22 +0100, sashiko-bot@kernel.org wrote:
[...]
> Won't a nested guest with S1PIE or S1POE and without TCR2 still leak and
> corrupt the physical PIR_EL1, PIRE0_EL1, and POR_EL1 registers across
> guests on VHE via PIR_EL2, PIRE0_EL2, and POR_EL2?

Yes, these trap through HCR_EL2.NV and no FGT bit covers them, so the
FGU misses them. v3 will UNDEF them along with their EL1 counterparts.

> Similarly, if userspace enables TCR2 alongside S1PIE or S1POE while hiding
> ATS1A or HPDS, leaving kvm_has_s1pie() and kvm_has_s1poe() unchanged means:

With TCR2 present, the world switch saves and restores all of these
registers, so nothing leaks. The rest is KVM's handling of an ID
register combination the architecture doesn't allow, which this stable
fix leaves alone.

Cheers,
/fuad
