Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A767157A72
	for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 12:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713962839; cv=none; b=kO9SX4NRNK3o05xv/fMpKuk5GBJBObzUiPlWHuNzmxR4zAGM2pCUYzXxFd+lYbj8R7llwrRh55Tpid2Uv2tRVyhM9HKWPxenTBtzDK7x93EtHuIbuePktjrjalcfPa07fzoA/ExT1rcVP0V79rJZ90ULDMAafSZJP5OAnbJrFfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713962839; c=relaxed/simple;
	bh=/JDvhrg++qny8xTBIRuDmIsP0lXSnFvUn+rNxOIG9i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWac1yFlvK70nda7pFEQ+U7S5lOatfQVrNtI97bbCdH0ungnvCkmHcWaBGCQ4ypiNyb7hsesbOYAkaDLReplslp4DTgiDdyQpdGndTYFhNpkW/R9PvQ1cpgBIamiywW6PIOXseOL4Ar16nzNqpUTin2IfxCr/BuSpONjgwUckTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CkSeLMDy; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CkSeLMDy"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-41a442c9dcbso27625015e9.2
        for <kvmarm@lists.linux.dev>; Wed, 24 Apr 2024 05:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713962836; x=1714567636; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7cxL1j8SNtUqcNrIi140yb/enDP0ohNkvqWAfKb7t/o=;
        b=CkSeLMDyka7rN3M2YYNgV+9wwi+aQEBTQO1mQGtkE3SX5cL9HA8zYD0+A7dTPal+8C
         sP1gviAguDAKGkiJyvLpWo3xoHwoVRRNE5AVn+4MHaROY4dTPYY7PohpCDf4C+5dZiTR
         yo8O718hPS9nsfwzIaq2zkeC8P0Cz/aF1PGDwE/wuuWTEimNamWll8ESwHqWuxwh87Kf
         ZDNBOE+kruTAlI1nG55jv4l9Fr/OBVt3xunalc2oZZ5IZgG+0MGXHC1xD3eVopntvTqL
         3qmFwtss6WzPjdlQ/fuDHDGjwMEuExo/gr5+Q+zLTEESaDd00R1s+GCaEJmyN4bxv2D+
         tJ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713962836; x=1714567636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cxL1j8SNtUqcNrIi140yb/enDP0ohNkvqWAfKb7t/o=;
        b=OwsgW/CtBA16HDhmQcymKyuSsaF2NYvSQiaTj/wjnY4OW1i1RdpbhAXZLNHZ68Hxss
         Kp6FV2Xzp+eDE6Q33KfJHOQCv7DV8cUPX+X5ZmuwryAsyOg1n8BLPjksAZhhyimSTJ4E
         zzdLHVYvewNGy3pLNB7w3E5LyBKeFLA0jZpZSOI1lqRovxT+hBI3iIC3VpE+fOyCBA9e
         SWqa6fVmFAlFErQWcbDeNqNEM7ynpdmF1u6jLBqym6oJQgCyRh2vr+fQ5wlYHn9Xdp1O
         M7idXvOcHWHO+bn1GUBhGkdunvtdozvwNwq/pKwK/CDUBKWLfrFq+uqYUt2ytTRBPHwd
         Zlyw==
X-Gm-Message-State: AOJu0YxBfl7oyCVq27K4kEZ/Zo1dq4ZdAqn0vYkwLLCnMDT+59ALwDOk
	81gVdwz3a/Oys9A0DWKb+OButBtjnDe7LVmN2PVlSm+si7z1uJzgdP/7vwvaE5I=
X-Google-Smtp-Source: AGHT+IELRWwqRIWM1u8jqyPR1P59KBBKHxFqcaWp7quliYiBK4B/JtP+aAyDcOcKhtr1Lz9yrN9DiQ==
X-Received: by 2002:a05:600c:4707:b0:41a:e681:dca4 with SMTP id v7-20020a05600c470700b0041ae681dca4mr1367606wmo.27.1713962836083;
        Wed, 24 Apr 2024 05:47:16 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id hg16-20020a05600c539000b0041aa8ad46d6sm6380331wmb.16.2024.04.24.05.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Apr 2024 05:47:15 -0700 (PDT)
Date: Wed, 24 Apr 2024 15:47:11 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev
Subject: Re: [bug report] KVM: arm64: nv: Handle ERETA[AB] instructions
Message-ID: <ca37bc54-cfcd-462e-9416-40ca3a9d3d22@moroto.mountain>
References: <e23f90d2-306d-4290-8247-845472eeb860@moroto.mountain>
 <87mspjt05u.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mspjt05u.wl-maz@kernel.org>

Crud.  I should have seen that.  That's my bad.  Certainly don't change
the code to silence the warning.

The issue for Smatch is that it doesn't parse bitwise tests or pure
functions properly...  I know *how* to fix it and it's not *complicated*
but it's quite a bit of code and I haven't gotten around to doing it
yet.

regards,
dan carpenter
