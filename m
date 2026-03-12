Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB852E888C
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773322530; cv=none; b=jYmoy4xl6ZyY7V2kfjTGXk9j/vJ4b5bDMiiN9TiiyZjksX2yawQPKr+swVOqTES4qWpqVwOdJMZSCGdBdiWs8V3lH+O8f9je7hyR3FNpKBxMob3uusA6IPKZblPQQfgnTE+i+A0v3nEkJmuQrHOpiVkaxasaNAmGGoiYMn74nmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773322530; c=relaxed/simple;
	bh=z+YjvX2LUHTIQYypaRoSgiH4yP50cb0mbNSWyK1pIbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c480x8YPOjZfXpwHS24DkSz+uRUU96zYZQQUv0MPBZxj3mX0tf4lH/MxPvsGsPakJixPqCwWTz76CmpliXbdslgrB0AvjYiDCk+8d9jfrfcZG/TL7kDxdSATvLfsFYwG66/KH3owP1wVPbZKUKGyEf++8m52VNQgk11VFQSIA00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i1bxcNj2; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i1bxcNj2"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439b8a3f2bcso840489f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 06:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773322527; x=1773927327; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e9Os4cgNh5i6cWimFgT9mmwNd3gOQ8i7NcYfdN809vU=;
        b=i1bxcNj2bsRTdz9THXhdS+YTdV6NLVCSmBqgFxrO2iiAFkESMxt0XUUGlE3g6pL0s/
         Qg4D+Ji1YRO/7QwL3LyPuNAYaZpcQuj4s0G3mjcH2O/Ge+70fO6ai4vGg9Y5vXmf0Xms
         rMOzCkphRABA6xAdXQZhUqc5GECT7dgjzS0Ew0DHVFKXT9eFg2xlQd3cb2NoG6qk+KPm
         JXsMduP1/aEQZ5gU0vYvMSmRkW9VHEL9/4NyfCmDUTv8mRFZZeu32rR2EwX688B7y1Cu
         CXmWnl/UV1YrRi+khjIna08PgGl4vXjKkGR72ZIEcZGVEnCYpBxv4oxLV1FKR9srp8m2
         nylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773322527; x=1773927327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e9Os4cgNh5i6cWimFgT9mmwNd3gOQ8i7NcYfdN809vU=;
        b=l7QcBcYOehJ0jxhVRHokB0EVVtTdqJIObgxzpbTO4XFPxaGvjuDCDjS4Gd7+sIJ1TQ
         pVgZrLSb5a5Qx/XCa8fzEZS0QNksBbHUel/Crk1CSAbY0/2GQyR/RGpOiyfSdydx66Ja
         QjwT+dhVIbArvPraajS7/Pkuckq+oZBPPtaefqKgGmnj9uGqZTiRKLBFNDQrJQMkbrXA
         lnyBM6sL4TeRUD4R2wxbeq4v9fjBnbZ54I+itlyJXJ5BK05LwH5lYyXrTIJPQ4OUF+ge
         0dXcV5IU8ngN2z9nulH14xYx9pPG3h6ZtFuBLbYkbfvWg6I9frJfw+ipt96wRa4/ijh0
         tTtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWl7qjnfK8I7D/oVJzaPFtkajwYKWBSa+XdIae8vXgLzPmn9WudgCp3OH5pnqyZIoZHy4ugpLY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSPlFxmU/kNMWT8HqdCbCQ5c7gJksGNtW7hGMQHbOyIMEpIqxL
	SwL5kVwknWbiR1IBBSRSDWFmc3nlHir0ueQGcF5zFhK7dOqRB8EXYCGqCr6tJNfQvMADv/X4oBY
	kshroyQ==
X-Gm-Gg: ATEYQzyUIsp9ZWbbO4KkeM57hGQQw0blo5CgH4+/qlZ5sTYDmAIDWG6/8k+kE3peVN1
	AFP6SEHXUAGi0m358VL68K12TEKlGbs4Zf7I0zG2kz9g2VkPdCZFy/Lp4z5+6QbhLZS5qrARLku
	nTiCcoQGjLeNx9cBHPgtTj/HGCX3aZZW33liodmtpiU0Idu/52UoUpQzc4EKJp7qvGT5Gnm4o+R
	bJq3Gw6X3VtfSe0crJWkPl+nC8kl1kScegIcXbMQECATITRE1ZtYzE2J6P8BgTeaup2u3Y1wM2E
	sGlzny9mr6URYEFt/RIHEHJgSsIxqGcLHx5hNqizc1gvJBopYHivL61fJ/d5K0DF38j7r3urVaL
	vrkPrG2p2a0QMIKyGfT6zLqTYI28prlCxGtRK/rbcO9+jQEOBdUqZ2qEi4/cDUrolCOnwytX34Q
	ypMFpsJk/YTNtz9rsYDC0bdcKs/dqN0G7NMHs+La05MPa6/CCnh16vcmuHKwNpO5A53pQ=
X-Received: by 2002:a05:6000:2c04:b0:439:bfaa:ed99 with SMTP id ffacd0b85a97d-439f822309emr12897737f8f.44.1773322526701;
        Thu, 12 Mar 2026 06:35:26 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe19acc6sm8523527f8f.8.2026.03.12.06.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 06:35:26 -0700 (PDT)
Date: Thu, 12 Mar 2026 13:35:22 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: fix include path for ring buffer
 implementation
Message-ID: <abLBGqgPkwYVYMa7@google.com>
References: <20260312123601.625063-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312123601.625063-1-arnd@kernel.org>

On Thu, Mar 12, 2026 at 01:35:42PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The simple_ring_buffer.c file is in the source tree rather than
> generated at build time, so the include path is wrong when using
> separate object trees:
> 
> arch/arm64/kvm/hyp/nvhe/trace.c:16:10: fatal error: simple_ring_buffer.c: No such file or directory
>    16 | #include "simple_ring_buffer.c"
> 
> Include it from the source tree instead.
> 
> Fixes: 680a04c333fa ("KVM: arm64: Add tracing capability for the nVHE/pKVM hyp")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I believe Marc has taken a fix already for that one

https://lore.kernel.org/all/20260311164956.1424119-1-vdonnefort@google.com/

> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 143d55ec7298..3d33fbefdfc1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -33,7 +33,7 @@ hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
>  hyp-obj-y += $(lib-objs)
>  
>  # Path to simple_ring_buffer.c
> -CFLAGS_trace.nvhe.o += -I$(objtree)/kernel/trace/
> +CFLAGS_trace.nvhe.o += -I$(srctree)/kernel/trace/
>  
>  ##
>  ## Build rules for compiling nVHE hyp code
> -- 
> 2.39.5
> 
