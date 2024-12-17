Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224DB1F543D
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 14:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734445901; cv=none; b=m2XO9nnWkrU4jvEq4YPiG/T83gT7Sg3iLUbu1uZi+9170Tc2R07BMngSOQDuvfno5ek5DXx5jOsa8aQY8miLZ6igCkv1EoDCaaEJ6ftFgC6T+qW8iyPylrpNgJyZiBrXRVBUDCjcI/9VkkHblHlOgaobkS7jZLp+cyZFkNCbBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734445901; c=relaxed/simple;
	bh=MCDsTtrRcGELOG9sKHeryzP5B0DQFbLGyo/mki1UYKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDQqL0BLC1MG6/3RL6U9uNY4Fr7Ww0turgUrwtPGL4F1gEfIYZgzAIh1CHhOZyk6Uy8NWLBSLncI7K190coK/TT9i4EPkTs63TtwUEAK6sKICvwps5VzDNxicZoMdUKX8ivfncdcfT78cy7NJRtfyQS9B7nPLoz0/UaSp52cuT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VsQQaE0Q; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VsQQaE0Q"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so2035360a12.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 06:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734445898; x=1735050698; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MCDsTtrRcGELOG9sKHeryzP5B0DQFbLGyo/mki1UYKs=;
        b=VsQQaE0QkBVljwunYZMfFKB1etHBojNlSMLXMcq8wpwo8GB+GF1OnJzEWidnPGesC/
         MgqhSDwAeMk/HYywh2yFDA4kwLOc7vonVpz+M+BrAadQiKLrUmRNpUXLG0CgmneH4FFY
         04OmWgWp0Cl6l1ZuF38QeJFgBui24Korh439Zkw3VF4ARHDDPYVysANAu0jHWipAd70q
         YGTUTWULMUJxNONRvcUnCz3UlsU1rvGNZ3ulqYX45XUt4PUr1dONM7sH4RJYtBqLppdq
         r0z92ThtcPlecpx2FzTKHaUKiAe0Cbg3SyK+tv1i0gQIpApK1jGroKkKYaGwIpq1ecqG
         K84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734445898; x=1735050698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MCDsTtrRcGELOG9sKHeryzP5B0DQFbLGyo/mki1UYKs=;
        b=BuDKZcP5KB/xUGyRNSX1Ufez2M9nKMeBGpMB1kjUNrqUE9ZllQGlZWUX09SBLM9SgI
         s+ZGzLDS+YZh2YoeTpZGncLZ4pZGKGQp9iR9e9otUr2Q42I11Ng/CpivK2U6O3QLtEDh
         izBpy7gL2Ce/vRHNnh11OKoton7hk6Ct4g9pYqSQzxyIxOHysAR6sKjk2mR+0VNF70NH
         OCILfmkV+tpH/QbsDXh+f7FvaMZLbDLEJ6VUq2GvObB+Dj64b+7K4PmgD7zdBzpwkL4h
         x8RELhN5Y4bCW31PJO2UZ3g5asIqGOfG/R2jeoHbmngelOOMC0VcLkmW5q6EHFTBomLF
         hITA==
X-Forwarded-Encrypted: i=1; AJvYcCVR4uu1jpNB1xMaKQVOy8Rj/OtDePQZbsuOn9a4/uoQh5n4olHexjrYG/YLAem1bHxG2vATP0M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBl5iah18ZjJWtF1IKfXoszO32qCq23q9v3e/kLm28W33x1PHC
	Nr502n3q6V+qGbw33ItBhnHeAk+DNEW3tixivfUSuINHo+Hei0Gxun0mlmcwkg==
X-Gm-Gg: ASbGncvOOGwjn+9UP0ObBHOvVJIaEcGU0U+w22NaPMez85rL+L08j51rbce/xMxIXAn
	l8Mct/1B7o+CAvVsLgKaCthGe4j+SgrAiL3XS653TXMt8x3YGkrchNh+BpHxeeBLPwSAnrfzA3x
	0V6ij63yOE6nFvfRqLmY2A9om8AD7xk2YrNwbJUneCiI93SWsa1uAVcCa1x8gsVgJ8QSOBgOGY+
	P05CULzPJ4s+rb4V0f5c09hTAJKzIzHO3y2QZVNfNbC5hgv2obhB8s24klcQxh7aBhLV1DA4w9k
	Rk4zGhow42+SmcU=
X-Google-Smtp-Source: AGHT+IHVex9Gn4i1ejnUteG2TKmCzHX4xTSH5m8KzVP1ilACtngEv4xPjgW00hut0PjQct6YRA2HvA==
X-Received: by 2002:a05:6402:2708:b0:5d0:b51c:8489 with SMTP id 4fb4d7f45d1cf-5d63c3067d6mr13054348a12.12.1734445898291;
        Tue, 17 Dec 2024 06:31:38 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d652ad187dsm4505071a12.28.2024.12.17.06.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 06:31:37 -0800 (PST)
Date: Tue, 17 Dec 2024 14:31:35 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ene <sebastianene@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 18/18] KVM: arm64: Plumb the pKVM MMU in KVM
Message-ID: <Z2GLR8KZzJn1YpUu@google.com>
References: <20241216175803.2716565-1-qperret@google.com>
 <20241216175803.2716565-19-qperret@google.com>
 <86ttb2qudi.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ttb2qudi.wl-maz@kernel.org>

On Tuesday 17 Dec 2024 at 14:03:37 (+0000), Marc Zyngier wrote:
> My gripe with this is that it makes it much harder to follow what is
> happening by using tags (ctags, etags, whatever). I ended up with the
> hack below, which is super ugly, but preserves the tagging
> functionality for non-pKVM.

Ack.

> I'll scratch my head to find something more elegant...

I find your proposal pretty reasonable -- I had a few different ideas
but they were all really over-engineered, so I figured relying on a
naming convention was the simplest. And any divergence will be flagged
at compile time, so that shouldn't be too hard to maintain looking
forward.

The __S2 name isn't massively descriptive though. Maybe KVM_PGT_CALL()
or something? Thinking about it, this abstraction doesn't need to be
restricted to stage-2 stuff. We could most likely hide the
__pkvm_host_{un}share_hyp() logic behind a pkvm_pgtable_hyp_{un}map()
implementation in pkvm.c as well...
