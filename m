Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1512BCF4F
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742565; cv=none; b=N2XiC7yY2yxY+AffDlkGOxUT+WEFGU3a2btRfzB94WTnELo3Jn9wwE28m3g+QFulYG7KIJLIiCTN+lxGAfufRht8Mv9GP/xDhv1fRsg+CPv+sOE+sAcKcXgxThx3Z4u2zc2NcZsFQoKkBzzTZx6Pf632GK5Uc3GHKqGr7EqOMXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742565; c=relaxed/simple;
	bh=pE3dXpj0aU78BzL+r7JOJkXrxfff4V+18vm+u08QL6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V0b5TaUXvYqVJlMb5/yCjQ7o6v1sG9TCq/CFe/pRZh0zSC3CdU4NL+Up63xN6e42ga3qYvHmaq0RFJyYmg/TjlGrBmfJ09oaBeK6bu1gP7tKyPgcWOjr8NsdHEtnwdTRQ4fKa2g+zuTU0cXN76IQoFZ+PGxm2QdLFjwxb70D3tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zoNRKl1Y; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zoNRKl1Y"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7086dcab64bso9681927b3.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 08:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749742563; x=1750347363; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pE3dXpj0aU78BzL+r7JOJkXrxfff4V+18vm+u08QL6w=;
        b=zoNRKl1YPV9qwFpIfczg2dYxcqYVG8WDjtfiVPAAec212ky9wXNgIrphYHAApUVSs/
         SKiIecmIZN/lde3WK+bbXgS1esCfQiW12Cf7U3GFaWVtDKihAZGli51qYr6hGD5CDUDR
         NYihsnyXTHPCgDy7HLJYXzOiCfgpXrtw1BevQ+9qKB7ZWQcLtJbPc2T9CGQZgzsKMWeQ
         dlS3t7/gBbdPEwQAH4PCIUBDBua8sYfoZ79YZUS1wyA7F8rjV9WfP0db11uw9SnLrBRe
         hj6seQ+h8yaV8V4iUyRqjugy4MJQNQHkOSz2Hzs5zfL2XYDnHrbe3BMRZ4EgbFA9PVKz
         Hejw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749742563; x=1750347363;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pE3dXpj0aU78BzL+r7JOJkXrxfff4V+18vm+u08QL6w=;
        b=RqrbsjLyhb4SrirBPoSDjebO80aSUvuwFztG8p1Lrq8xvTUB0v6lu4peFGVbIeqDV3
         HRAFlGpUib+PBCh7HP09HjTT9GK7HZbo17SdGgedmvvPOoRU2VTXtf9SSnwz3uFLMrLt
         i2HQBA3wDAm5f4GwFZ8wC67EJ/WrWXvRcQtZG6BThh2Onil55yPjwF+8kbgVo1uDXf1F
         7GOoQ9wpoFHz1XkL8f3nPpPJRhHoDJTLKtnIZA6Q7QfufeSU27w5BeW4T+iFbY63FOeU
         6pVIf1rm2xwqvyMjvCIisz1BbqA6NUPX8x+kL9wIncjNrQLk2khnEtyOZopTeHMri2vJ
         rLqA==
X-Forwarded-Encrypted: i=1; AJvYcCXnhsJBEATBxiy1BSbTMnPeSX7Vu247828iZxb1SAlpRsfJLpGj1NF9DwX9+fSF2xo7FSqTe8E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7vSERepmehhmulHsH7OnpVBm5hYSCgBCgAW5hjHxg4zFPkLlz
	rlo2SG5M1LVPHushT78E2nH+3UnbFYoA3Ors4nYvE1kXdWSWwn/smVnc+6WdM8RGqxRedAdtIua
	4ST4+F7w1nsHHK/H2Ugh9kfyQKZLfRQqZ+Q4NMfngQg==
X-Gm-Gg: ASbGncsCUeEovF4fpvmdj4fhzstOat2VjpURv8KX3D6F/+nb9TBPqW0/J26WgvdfGRO
	PWKCxUWhgkohG+6xkE+WdSikeYeaMtuytiAYc6EUuTgPvXuMunaTHeiCGkqhj2OT9RYgD9ugUH5
	6jABQj+fHyctPJe8JCMumpiseDKXYCnk8O1cG5+xA/+NmD
X-Google-Smtp-Source: AGHT+IH2bhKZzKb6cAcO9aAfVWto22hSljzV0S+7R7pK1D5q7Y11fAWUU2asfygNKJWUNlKlB22V1KDNnY4CSfoYMMM=
X-Received: by 2002:a05:690c:6203:b0:70d:ed5d:b4dd with SMTP id
 00721157ae682-71161f29c5amr4894467b3.25.1749742563057; Thu, 12 Jun 2025
 08:36:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250515153907.151174-1-cohuck@redhat.com> <20250515153907.151174-14-cohuck@redhat.com>
In-Reply-To: <20250515153907.151174-14-cohuck@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 12 Jun 2025 16:35:51 +0100
X-Gm-Features: AX0GCFtP59qPc4EAjuw9klqXVx2ltBaNeP6BsMTmWbNtC3d5QuHXLs0a9yWRCu4
Message-ID: <CAFEAcA_Ju4QBUwiOyt9thPxuAFMcm6jVTZHpE8FFJeed5cJgsg@mail.gmail.com>
Subject: Re: [PATCH v7 13/14] arm/cpu: switch to a generated cpu-sysregs.h.inc
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org, 
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev, richard.henderson@linaro.org, 
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev, 
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com, armbru@redhat.com, 
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com, 
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 May 2025 at 16:40, Cornelia Huck <cohuck@redhat.com> wrote:
>
> Generated against Linux 6.14-rc1.
>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---

Does it make sense to include all these extra registers?
Some of them are not simple ID registers at all,
for example ID_CCSIDR_EL1 is an array of registers, not
a single value (in QEMU, stored in cpu->ccsidr[]),
and CSSELR_EL1 is not an ID register at all, it's a
normal read/write sysreg.

tahnks
-- PMM
