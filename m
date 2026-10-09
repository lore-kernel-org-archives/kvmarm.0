Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B9419CD0A
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 00:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504252; cv=pass; b=IFZ5lRgPMPPLDDEoro20vI+jXWI9VAQFaggCYSeSfgCGq9a/RW2iW9KNcjvmp1YfLDvmAefRMe4EU3f+sMLaqj6xRaTpOUJusmNLb48ULjUn4ZVUFe+yLvXWiNs1tfCNdwEItIVJHFbpSCVgWfmPg9wc0JcqsRAuFTEhyu1lYB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504252; c=relaxed/simple;
	bh=AfAyWJyoYAUZVrBF2564jVEKZBur8MkqHqXOz3xZdYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nV8pYpSM+vfSRFxgwQIgh8neIgKAafwy9Ax3ZAeTbfTvsd/mALBkwNjtiiXF20nk66rdvqIsTlxg+OcOrbWjIBdTNEpO1zrAE5Mnvp2gZdqrNnx3E4YUA/ubolAJeRU/flMxS1GOl7Qemb1f+76xv9xTHb37p42XrO1HMTBIQ2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hkwaHsBn; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hkwaHsBn"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ab43af5e97so13824407b3.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Oct 2026 17:04:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791504249; cv=none;
        d=google.com; s=arc-20260327;
        b=fjtiFlzEb/AZQIcUAxnLSvGtMfzHrYmOiXAwsRQgwdcDT4FgPcnJF8mL8gPY2oVXr0
         Kub9f6BlsAECo/fEHOYuHCkIFxKTp9e+PgWQOqLR3eqDwT9ZKvOStHBD0MqS4iUa2XSP
         0rjHy/lUJZL8VnlQZWkO9kwOHOPZSs9ilNLft8meTT/nNA4OXLhQmIijYRzQxLYVPx+q
         M0F2WIjh0H5ET+DfbXerjqnxayVqedyYPE0TMiU30CboeewY8hhBZ2UOgzZvBv49P0re
         yKjEjPKHSUD9toHTceyT5XCvIu9iakODihxZ/5h70PlsBbYCtd4R8nitTnnN16fqh8P5
         n7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AfAyWJyoYAUZVrBF2564jVEKZBur8MkqHqXOz3xZdYU=;
        fh=cHl7dxN949JQ3n+ONbhFusRUDNVsjpJbblhi9BVOjhQ=;
        b=BIEz3zxWHtiNtiDEyg8xOt7Hitz3qwbVq6SzWCUj6IEgY4MbNBFKrjc/46R7/czDhj
         D1bWQKV9KwNl+m7pdj47yCFQn2Aio1bFUCGwxiUIQJB9iLGjJ+c7NdO1Ji4YBCzifioE
         arWnK3gRNzqMGAYmMWPnJpmsRMCp5iXNNb/R52eWyJ3l/ghmO/K0Jxf0WYWjkfPv2fP5
         TK8tHFSYabT2XJoBCW8ju5Hmk1y5bzqGnoqcVwwT5mSCbOj7eaHX4fDFIVdiIb3acw9K
         RnNKmcgMc+VZkGf1H0WNjN73J0bKu8PgXrbvakyftXUDbAycWbrEw4cyvyOWrEcpkcgb
         1TTw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791504249; x=1792109049; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AfAyWJyoYAUZVrBF2564jVEKZBur8MkqHqXOz3xZdYU=;
        b=hkwaHsBnJztaefPX1jmdpc6Gd4h0kWVPmbIdkUOsNjUT1uFjDelyF2ZXKPfKMRmLK3
         gISlSvqt1bQgO8V0gG/wl4Tbpfm4aseyijga9wS+97FruU2lRZe9xByaEEM+dqvnQqDK
         1FEVrea0SUK2yXWgHLI6vDXUNKSOJ+CXRLouOZ33jMpDhCcwr+MJl1UjnQFNJSf8Yzsc
         PxDXA3QTF9xlQ8FDDc0EyAlAGrHoino6r/25zlb1KCtSFnFc1Xj7tC29Bp/0RBpBvIJP
         0IEdxVI4x8a2ms8DFqsni/N1E8E6EpxbggemcYcEsZcbYL5eL90w3Iru1A9zT4Ne8zEO
         Xq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791504249; x=1792109049;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AfAyWJyoYAUZVrBF2564jVEKZBur8MkqHqXOz3xZdYU=;
        b=nf2gpgpwInTBK/uZkJ/YRgsdCr+9lSch6Z82JMUiapb+3jm35ZqSj8SJF+cu3HT85u
         KtbGxFNr1gLxI/m5ulhCqp+etx7B/73WQ94eSGpVmBScMiXVj6HqS2Yb91fZZ30HWlBW
         o4H0z+7TqXeDTte+ESAcfLK/D++mD1PZH1oMVlgSHs/5YXj/GeWqOQZ7S4u2yiQ8fsPC
         1LlxVyqOzjWDP+Do66JswJNFgLnuUZuoM9rZuNlcTl9AeprJyIWKIdbP+BV1XWVnyErI
         I84nEUPVZUHbXjfADP9kY9HfsHwZuV9ashs+RfJ3Jzhb4bubTRDg5WLgL+3yRRMACpjC
         bt0Q==
X-Forwarded-Encrypted: i=1; AKwUvBw6q0RJUjQWCDv6tjYAz2QWtGgd0feonj1vpBUcLN5X2gAswFrN7SfWIYyIjHdHz97yPqGtM3o=@lists.linux.dev
X-Gm-Message-State: AFq9FYJgA8gzGajB/uoDYNEvMjYgeE8EoJWTSOWPlfyVL3lson31vpnk
	pws7ofAC7FwGde472daukq5q4XRxjwOtiSkh8qFKJdVz/dhSlDBUXOy1YqDFheXnFVtaqf9OfER
	3NiLuPKVaYMh/hpnmm9JjrCbpq/pIEB8=
X-Gm-Gg: AYBFou0miIRw+G4ZyWqg7UAmpXxAaWod58Nk9Xuj3gngt+390sTx4/802PA2EY2jvQR
	x5lsYdW/cZoWkIFyxF7BbbxZjaTMJxTNg9q2rClyaPoIOm+yN+OT+747/ZDDj/Ffk9y0ZVxNpl5
	D4g7IReM9XQkASuoeMkobth18ZoAhZSC1I9UF23GtW1nl6MDJffE63kicregtOnc4YjvLZCbfh0
	MmXcuWwnF9p02088lpBVKBlO5lSjs8u93PJJLHcFLr7W3mpiH/TQdXHwOb88QBbbeOuUirkZr43
	yvqo0A5EYPA4xGURAzBGycmU3L/QY6U3YAbKCNgzu8pYByzpS/gi8Hdj1fZ/5g7P/kk8le0AEMc
	bhHuDNXISEQ==
X-Received: by 2002:a05:690c:6e81:b0:8ad:7131:9178 with SMTP id
 00721157ae682-8b07d3bee19mr2337247b3.12.1791504249249; Thu, 08 Oct 2026
 17:04:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261008-apple-m3-m4-kvm-v1-0-7bb4cbf3d63b@gmail.com>
 <20261008-apple-m3-m4-kvm-v1-2-7bb4cbf3d63b@gmail.com> <86cxtk2utm.wl-maz@kernel.org>
In-Reply-To: <86cxtk2utm.wl-maz@kernel.org>
From: Michael Reeves <michael.reeves077@gmail.com>
Date: Fri, 9 Oct 2026 11:03:57 +1100
X-Gm-Features: AclHuK9Ag9bDa5bK4MghchktXbtliwMAsOllt0WW00_OPCRuwhkusEjtb_E3AmA
Message-ID: <CANpmGNv4uYRLALMLKZn-HJwTiqJO90Fx23DOO7K7d-PfSWn=2w@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: Apply existing Apple CPU workarounds to M3 and M4
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Myria Sarvay <myrialsarvay@gmail.com>, Yureka Lilian <yureka@cyberchaos.dev>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, Sven Peter <sven@kernel.org>, Janne Grunau <j@jannau.net>, 
	Neal Gompa <neal@gompa.dev>, asahi@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

> How have you established that these CPUs suffer from the same SEIS
> erratum? I'm all for working around bugs, but I'd like to make sure
> the new fancy stuff is indeed just as broken as the old shit...

We tested both the PMU and SEIS fixes together (as in 7.3, both fixes were
combined into just the one apple_cpu list). It's probably a good idea to test
them in isolation, thanks.

> For the record, the EDKII build in the QEMU EFI package that was in
> part of Debian Bullseye was able to trigger the bug semi reliably
> (series of writes to ICC_EOIR1_EL1 for interrupts that were never
> active). This happens on handover to the guest kernel.
>
> I can provide the binary (and a few scripts) to test this easily.
> Should they have been fixed, we can always create a second
> implementation list to cover the PMU.

Can you please send that so we can try? That would be much
appreciated, thank you.

Thanks,
Michael
