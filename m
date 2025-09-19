Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45F32F5498
	for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 10:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758276073; cv=none; b=Z2o3XeveHzBW0RehKiVrZIskvfd7oSf0F8xFhdF6GONJ99ZCQmwZzJVzxEgmMDJkAKTxYYyfQJWk2OJUL31buCd+1CDZ/FaXj1GAag2x5udg4fiuZgJx2UP97LGfMVn5pH4hJQk1pNJ4b9S3pxj82Iv6vKqHbcVGIpWK9ezP2Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758276073; c=relaxed/simple;
	bh=a24Hq/d5xl+UD7TQZLap4eYY4wWFTTqYOyEXcefWYQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7bCLW2uEvcET4pakpdnj4WZlmaI5l9RaAjEjIkY7hZq1tAtKesgyXbWuLfFhy5gP4u4jT9oQjZcR9OZh+g+ic8Xdgiukeahg3LXAO/9Q8YFA0kOCic7T94TV7sJelkV3DdAKIoYikrp/d6GmNc9NExYQAft7OgqILjc+J0Gwrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1vOT7ruT; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1vOT7ruT"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45f2c5ef00fso15120845e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Sep 2025 03:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758276070; x=1758880870; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6BBuzYX2ggeSMziBzTCfJEdNNCXHrTj/jX8IugZvuU=;
        b=1vOT7ruTL9Y4ULUD5G1RJ4G9c1BLMep+uNF4/Lq7xkSuRJXwKWOTN+sIf+64I4NjE7
         cb1d+qHdIfejBWeZsXSoCgA5Te6k8NbXG6Hiwnx8nfapBmsojiMsqfWIuAP3FNaoQg1R
         5GkOgD0YS42gIkKF4VeqjrbuARNc7Kiufp+uvts7hkQrSrelx5NcT0z3s1o76dx1slT/
         TsTWTIVqZWLnhn/hGot8aSlKkFHebwx4mj8S8CwlPspUV/XI/VLyvmS5HgX0OSq1PQOO
         um/oWu62Bot613Lya3u9r2R8EZ/8eVl/0laOLfYECgszudj7hBHRFaV+heV07NQ6tQCZ
         Tppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758276070; x=1758880870;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6BBuzYX2ggeSMziBzTCfJEdNNCXHrTj/jX8IugZvuU=;
        b=r0GM5SD2O+1afBawSi/lREHFnFq7kypCQvqTvSqSI5nqgnj9xf/+UBfoWss0x4gveg
         uRwckVrEMAEpUvyQvWFSqopynJuvYz4zSaFCKpbiQQOlGEsadQw3kcCmUPvqRuzzQ8qu
         8XmsOahABvJss7XTvDE8hUe4MUg48TDJ5EFvtI91pxLCfGNWwAfbKER0x5XzCfY07NaO
         lIEd9Yh+wCboXQKmrJFmN7lgeWA9Ruo2gTMMDvjXE/oF9I88QSvK2N/E/TZA/ApdYCVx
         s1CZkzk60hhhZFFDlK3FNSggM9BULzrpqSujvnl95y59ZeH4glh1l6MuGg9M3sBTR3sO
         h8RA==
X-Forwarded-Encrypted: i=1; AJvYcCVdkcSRl6YT9sLNe4MI0tfCz4EHduAa5tHiKUQ2tArOKe76CtxkwjEy1/34ACqXIV9VgoC3r3U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxS39SV+ZbCnaWDDY0yEaotTFMQvDaYB9dk6m7DFBMmIfC8US9V
	EjoRlG8eEO1J8DLHCw2k0nyyet68XKJwIg1lUsqUjHT8ELq61Gm7sItrKgBNfO+2Qg==
X-Gm-Gg: ASbGncs9pSvTNftO1JlkcfcEbFeRZnYvwtvGWa6ozP/cIqqQ5utaF0tXNUEYZuJ3rBA
	mfqb5SzjrnoAwA4uZnXy/qpjO6l3c5X30t9jHOWJAeNk4DQ6awU/0iwjCOEybeVbQdj0Yk6C8lT
	ZbL6T+Nq+KF+TAM20LA9TAyttCa2rnaqOzlXEH2bPEnWtneFIeHl80plTNrghbcDNO6s0PqRdjn
	yJGeAt3BTU4S3L9C/smNgvaVoIrwCVyufLaJEjwu8kXsrG8XDZxKE7YuoM4c7J4nvOJ4dGMm1h5
	JiaKVyIP8CaO9YKsOz6PYL8Dni9+yJV9jMAcBLHzp+fwDbVOyaxSE9rZepHKkIa3OX5ZElc1LYJ
	qP16DDOcDltua7Gr81KS5iDFJiB2OzBB/c6yLCi56nSLnic9rhvTQ7mM/WRY9dDovwslAPyMhFu
	hH
X-Google-Smtp-Source: AGHT+IFWHUGX+juK2JjqWprgLEQZc6/GNyQ1PYUKoMGX9rAYPkExud465f+KLZFJxbpo3+wQG/eGhw==
X-Received: by 2002:a05:600c:4688:b0:45b:8504:3002 with SMTP id 5b1f17b1804b1-467eb8e1ddbmr27074115e9.10.1758276069808;
        Fri, 19 Sep 2025 03:01:09 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f325a32f6sm77324365e9.2.2025.09.19.03.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 03:01:09 -0700 (PDT)
Date: Fri, 19 Sep 2025 11:01:05 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, sebastianene@google.com, keirf@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Validate input range for pKVM mem transitions
Message-ID: <aM0p4UB3TNnsKcfC@google.com>
References: <20250918180050.2000445-1-vdonnefort@google.com>
 <aMx351jkCPIv_j61@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMx351jkCPIv_j61@linux.dev>

On Thu, Sep 18, 2025 at 02:21:43PM -0700, Oliver Upton wrote:
> On Thu, Sep 18, 2025 at 07:00:49PM +0100, Vincent Donnefort wrote:
> > There's currently no verification for host issued ranges in most of the
> > pKVM memory transitions. The subsequent end boundary might therefore be
> > subject to overflow and could evade the later checks.
> > 
> > Close this loophole with an additional range_is_valid() check on a per
> > public function basis.
> > 
> > host_unshare_guest transition is already protected via
> > __check_host_shared_guest(), while assert_host_shared_guest() callers
> > are already ignoring host checks.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 8957734d6183..b156fb0bad0f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -443,6 +443,11 @@ static bool range_is_memory(u64 start, u64 end)
> >  	return is_in_mem_range(end - 1, &r);
> >  }
> >  
> > +static bool range_is_valid(u64 start, u64 end)
> > +{
> > +	return start < end;
> > +}
> > +
> 
> I'm being unnecessarily pedantic but isn't something like [-2MiB, 0) a
> legal range if we had 64 bits of PA? Looks correct though so:

Apologies, I am not sure I see what you mean with this -2MiB range.

> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Thanks,
> Oliver
