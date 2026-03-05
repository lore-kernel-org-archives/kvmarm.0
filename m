Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762F37D10E
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772735740; cv=none; b=Vv95GYKDLrAm2t75xj9W44j8klRTha0GceyZaqimL2KrQLsbpj1IV0os2SviZ5xOuo+n8QKtWqq9fGHWzLcY3hdjSWRoJO7neD2LWhmk5C5CjP+u2R6hmap6pfUVLhsLqzRlzd+d4FquhkGi+8BmsiAc5hg4udUHaBB6qae5RTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772735740; c=relaxed/simple;
	bh=/2DbjUHnT80T7lxCR3Ys8zzU7qzwgw+67gVahd1hgzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfsTZnC3xrxVXzSQXSwscFJx4uD9YFTdSEaQTE7/i+YdbrotoozvQpcniFsxyPLtoq2zoG0ggyspEWlkGsZcO1tjVd5ZOY+OIyaLjelLkJT2HMeXfd1hwzhQ64d15e2S6vQv+Mx/ePN5ePiJRRnnSikudiCQx6OOITW4TnkoseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r8EjijEy; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r8EjijEy"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48372efa020so74527835e9.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 10:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772735737; x=1773340537; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rT3HFFE0hN5Iv+Nkv4cLwwjitenY62fCR7k08+CamVo=;
        b=r8EjijEya1h/5V1e+q10ixgLjv+hS679C8SmClLc5ytrhfyn1shqO2olo8uIdxL+3y
         hqeMfhVGzUme0N7Gx5ThUw1rA3WZ0PvLwkLS9YzBmdYrGuYqg8ibD+PcBtMRvbKiwxMX
         7QMoDFCc80H4gZv07NPa57xVvGEv7dMGZX1ZywzMFphU8NyMMIoROu4x5ACVXQUtkHq/
         lHt4TuKEPCMjLPXigzl3TSfeoGyGmEkJMNbYPTkdL0aA3YD/JsySIAcVLQ8ycp8DwfHV
         yQiSgE05ET25h+xnnf4XiHRsXH3HFIAIszYNH82fHnM/OpostvRV9JfbOAYvhUbSjMhX
         adlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772735737; x=1773340537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rT3HFFE0hN5Iv+Nkv4cLwwjitenY62fCR7k08+CamVo=;
        b=VCOnuEn1xM5w+YEL/KpBJ47LJ5V6dHU9mcaO6mQq4UCN53ma+q9CJpMLRc2Ff+SUth
         gujk8ATwwFnibpl2BB5EKnDOhxr7a1EUjx2mukH6KuZ5ZSB3vEumEQuG7c8OdM+y1rns
         FeK+A5k7HtGUBpclxA671i6PZCGE2WL0U5FcplFP06DEx3/rxDjnfuAPGxfptXIuTAKQ
         ZFfNSiKTlW1lRfkwB4xoVdC9C6BJm9tw6sE4he9EHOhZj6sX6BJ8iZK7CzaTTgs2ylMO
         RToymvfzSAgmIuyffq7gecUBHFz0+SR/zks/XBuKS098yAQghPHT4a199OtJMbMbmKIk
         piPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIbccfq7Lbsyb5+9vd6LMrtjEuf9PTTKBkhpJ6dJDhByWngve2Oq+2tVuiEyBxxeE5snDmKrU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaM+VOVEiiTsoVbs8qECyKxDpWqqsnJ8BAt05BRjhhbX3Nyc3j
	0Crz0FuKd52rNIS//6dqQVcBw/mUmOtuDedzDGSQcQGA5hRXf/uXvzmOXvf9yD0D0w==
X-Gm-Gg: ATEYQzyibGTeyrFHk5pD8uG5IEE0EaGxe5qeHlBy+qAIRhAupBU8zu9eiQGYLekqWog
	zBd+y9qgZNLuT9bmoh2taoVpzIwX1d6Yuwc/5SHJMIF9lFsdW3My9zlcRwm0ZLpe5ycF1X3NXyL
	LiF6MaI2VYESXFCPwvXyyleG9JPGCYS5fpINBBz8BrQg10ncaG7IiGyxG+dffnoodl7GHT21fPa
	O/wCUSyAhsTClCYCmrcdsgPClcJGEONjbgU3R9ZDhRaF/1N2RzO00ngcGrBtK75e9dA+Qk4Anja
	sZMAzDZt0Qb/eiAzdDa3LxnXS9GW0XBhvVWHzAUEgnQKF6FGSmf6m9K7pXiLB7tPWKIofHI3xHl
	Y2xbfEaajbke7xRvErrT9UbpVh8fFg1j5TfHGo8mpZ2WLJvmg0BPxYE3D4SskjNf+z5nP+MTE6/
	NOCkWxDKAh37uZNeR72TIXmK6D3K58VdTZZ+ly5SyryyKQv6TJW8+Q0Bz0Ygx/39T6zOg=
X-Received: by 2002:a05:600c:529b:b0:47d:25ac:3a94 with SMTP id 5b1f17b1804b1-485198840ddmr121717605e9.17.1772735736986;
        Thu, 05 Mar 2026 10:35:36 -0800 (PST)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4852378de86sm2222085e9.4.2026.03.05.10.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 10:35:36 -0800 (PST)
Date: Thu, 5 Mar 2026 18:35:32 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Marc Zyngier <maz@kernel.org>, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, linux-trace-kernel@vger.kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, jstultz@google.com,
	qperret@google.com, will@kernel.org, aneesh.kumar@kernel.org,
	kernel-team@android.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/30] Tracefs support for pKVM
Message-ID: <aanM9DL_jKkhHHAF@google.com>
References: <20260219150307.14538-1-vdonnefort@google.com>
 <20260219130220.063c8db3@gandalf.local.home>
 <87cy20eeg6.wl-maz@kernel.org>
 <20260305111703.6346b243@gandalf.local.home>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305111703.6346b243@gandalf.local.home>

O Thu, Mar 05, 2026 at 11:17:03AM -0500, Steven Rostedt wrote:
> On Thu, 19 Feb 2026 19:11:21 +0000
> Marc Zyngier <maz@kernel.org> wrote:
> 
> > > 
> > > Then the arm/kvm folks could start with that branch and add the arm/KVM
> > > portion of this series on top of it. This will prevent major merge
> > > conflicts in linux-next.
> > > 
> > > Does that sound OK?  
> > 
> > That works. Just send us a link to the branch after -rc2 and we'll get
> > that sorted.
> 
> Vincent,
> 
> There's a few minor conflicts with this series and v7.0-rc2, can you rebase
> and send again?

I'll send a rebased new version tomorrow.

> 
> Thanks,
> 
> -- Steve
