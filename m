Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF1A441D
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282236; cv=none; b=Tp1ek5+hdyBZmCcKfWkL/vzWsLvuXdEy15uQdCx56qLncCAP7M7jzN+DKW1+li7VrVqEQeZIpwemenNfoGJyiiQuYYCVT1fYvGfjHPYxAtPUsInRzKS3JwTsBGmxv/WsnrTluJ8ehVs+vkuEq17nNggSy822hAHdYNvipLn2vMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282236; c=relaxed/simple;
	bh=/13ngaRTyPeB4vBu9MQ8WJijEgAX5lH/Z0IZ+QKcV+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXVFGGAMJ+jNxSwoS9Leh1e4lnfCxmfOEvEp+pNPP6Bsa8PvO7LGKpN+lm+mreKP9y3hlhKSJoy52yabHmvH5AdMY8v0g9McHqJ/wCaPfaWOXLKcZgH/uBLOFkE2TsS/GfWapBoQchyxmfsQc361UZgksBkoDWK+1RKSHrT2NHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xg4rB3J+; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xg4rB3J+"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-57c6cb1a76fso11000a12.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 05:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718282233; x=1718887033; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MznSC12yYzkye/+ENgqiPXuQSrlPFjsWMKgcvI0Z2PU=;
        b=Xg4rB3J+td0pq0TSe+sUl1vA2mDGeRVLcjvbMNifYQXLhT/j7e1mXA3/6lvyss0ACW
         V3ZbXX8XaVLXvfb5ZYh4Y6/BqXaWvSHM4YmHCX2WHj8DYc4EGWR2t0qQiP0N71ctLvqr
         y+GU3er2a/EkYKFy8NRFOWOC2H5KPbJW1UwGcqmduu1mdN3mbqsYPnymjcjAK8u83o0/
         mtE22++211bZq6fRLY8RphvD7uzttKPu0fCxt0BrVn1+zHUaJYYFRedE1FgZmmEmp73V
         PB4lCvdMsqJ5beXmdqKL0q7pW8qjvWqlHJ1Z9K/SwH8sv3QeKt1tqxf/o/uEWHYzYoAN
         iM+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718282233; x=1718887033;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MznSC12yYzkye/+ENgqiPXuQSrlPFjsWMKgcvI0Z2PU=;
        b=VrjGBysVM46FpG+totQnzl/CwqDjOJHOO3NyeC+Yuwby4a+YOsRlJLGmt9nrFkXFRX
         xZu5UPB3a0Cou5rzy8jhJ9EmxCmJks43TAiw8bGT2bs3Q/hwQVbwhg8R7YQ/gh6Th10h
         or3Z9xQi/MpsExp1ufCD2IADZ4SQIrqmlnu3EhI3MAIvZb/nQzdO5RgFa3yw9t3j+GI8
         PaqxqJo8p7PXS/dCSSpODUwaoIfLa+vE/zuCnlJU4ph1iAlkNOC8mp6HPyazq+SVoPbG
         yfJp2PEU4/xtuxmzKTQNE4j9x74vLhSHTFd721FLQ2LL/tBfI7Yz1iKQgRZ31WMDLvkz
         765A==
X-Forwarded-Encrypted: i=1; AJvYcCUggdCnZJZHN5jDfI64DBAMcdQDhtOb2LuOSBLNpSdFGmsg7hdaOSCzAoY43SAUzXz+jQDkZiXefjmNvkjXXnJ5JH7lBupY
X-Gm-Message-State: AOJu0YxpCZO3wWHIatMR6AXN5G+1I3d+hixNYtACEnpXVRe5NCJUd1M7
	FUIpRNECOPm24tvwQZ9VllacpBPXsMbAeqsuksxe1d793oz5kurbbKlKMaRwuQ==
X-Google-Smtp-Source: AGHT+IFP8djsGWBB5M7AJLJBWEREHC1E9615rPjaCU+riDmr7PzZ+qpZx22Wb8eUXNrKQ7Be+vXNdg==
X-Received: by 2002:a05:6402:524f:b0:57c:b799:2527 with SMTP id 4fb4d7f45d1cf-57cb7992890mr126050a12.7.1718282232985;
        Thu, 13 Jun 2024 05:37:12 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c890sm1628667f8f.28.2024.06.13.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 05:37:12 -0700 (PDT)
Date: Thu, 13 Jun 2024 12:37:10 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, suzuki.poulose@arm.com, tabba@google.com,
	will@kernel.org, yuzenghui@huawei.com, lpieralisi@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 3/4] KVM: arm64: Fix the identification range for the
 FF-A smcs
Message-ID: <Zmrn9u8pJ0nduxfQ@google.com>
References: <20240515172258.1680881-1-sebastianene@google.com>
 <20240515172258.1680881-4-sebastianene@google.com>
 <Zmmy4pmgLFZNhXqp@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmmy4pmgLFZNhXqp@bogus>

On Wed, Jun 12, 2024 at 03:38:26PM +0100, Sudeep Holla wrote:
> On Wed, May 15, 2024 at 05:22:57PM +0000, Sebastian Ene wrote:
> > The FF-A spec 1.2 reserves the following ranges for identifying FF-A
> > calls:
> > 0x84000060-0x840000FF: FF-A 32-bit calls
> > 0xC4000060-0xC40000FF: FF-A 64-bit calls.
> >
> > Use the range identification according to the spec and allow calls that
> > are currently out of the range(eg. FFA_MSG_SEND_DIRECT_REQ2) to be
> > identified correctly.
> >
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> Not sure if this needs to be fixes though. With addition of notifications
> in the FF-A driver(since v6.7), host can send FF-A messages beyond 0x7F.
> But since the pKVM FF-A proxy support is not yet updated to v1.1, so I
> don't think it needs to be tagged as fix. Just thought I will mention it
> here anyways.

Yes, good point. I will rewrite the title of the commit to remove the
fixes tag.

> 
> --
> Regards,
> Sudeep

Thanks,
Seb
