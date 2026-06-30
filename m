Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1443EC2F8
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 10:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814422; cv=none; b=ukt53Q7ojH6HLNgDn6sVEzQDfjv5ByvOeqhoTKvGtSgo717PF6jWpT/Yc7LBj2ZZ4RrEN85+OYMpDMMqpa1PXxaOm1YD4xxt+TCwWTPDbjW73M5LeFPOxUs9y++O4eethyu6u9mSDDOKRxP6sOi/Nfus04oAM4gVAHqQavCzZCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814422; c=relaxed/simple;
	bh=jdoruG0XkGLtsZcjNxuxgP7FOLDaDulHcK8+yFEDLVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZvPDZg5L1XkF7HmmsZEq1xRKlvCBim4mJGnHPiU1w+zXeoryHwvglhZWJz4Unf4qf/f4cBM0PD9WrFZiTCwO+ttIxHz9afUT3jRfwbYAZROU4sJaSTCrcNYQnQM0GYkayB6S9SzQkM7y4wXdXOZFg3tMLyD1cbysLzwAQNBxcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dvlB+F95; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvlB+F95"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4926e5803e5so42065e9.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 03:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782814420; x=1783419220; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nMjuFcF1JOSdoZXexZR3W9kBR6KPAe7iuNXDZe8pc5M=;
        b=dvlB+F95FTCDwztCSDufv4A/zFa5LpyJ0S1hyjYIVtgZUcxlu0JUiGj8Sv45YolCAD
         YYRmuN9TwM1rsq83jwDQ+BAEgfYGyqZhDELn8CdIR7ojAIDQRFKisve5H4OwbCNNe6DO
         7DIUZdXqc4yYk0Es+8xJMLJAotetHca/ckkFnk4g2g+vrspsKbAmV7hJZoi0Mt9jLYph
         H8h7C8cKA4jU2/oZoXJ4UImj5bGIOSNBEhVR4X7Vt7nch0G7uzR8OjcZnsFmg2OMQtMZ
         VxG2OB4zi4jyxaeUPdhNN2ui9JZzvOxcpk3UZVtREqK/HN6DqUh1mniR8P3UUEltbMux
         JnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782814420; x=1783419220;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nMjuFcF1JOSdoZXexZR3W9kBR6KPAe7iuNXDZe8pc5M=;
        b=GSFF+1cqjy9ebqx9Z2R+hA4HUuSLx2QmqCHlvXtkNLXDIs68RXF+jOHWA16Sj7gDtp
         zpzjtuZf2Cq0f+Y9yM1WhPXjsYdXvQPm+9IgHXiltEaZx9aab4CN6ZgvkCMDIAAVN88L
         X7XIPTvpxtBxuXsPBQRGS0dZKNqGx5NES8Msxx/wFTS9kLQCL8Szp3k5s8vzDswMko5l
         KotmeJcar+GK/tDS2xumCDkMX1JIHB0mOYNklNl5A3x6lmuU5YP5Z68YPVPCZDJqX7GV
         Qeg1ZIp41n9zU/TbJptn1S/1ciXEuYenVVs6h7h5nM5t+SLeGVdJ/bCdH3TVAWM99IJt
         utQw==
X-Forwarded-Encrypted: i=1; AFNElJ99jc+X0WB1Wz7C7fnGMWhEkRHwSJqGyhUboNVxiDWl65ZhV30omTp8G61d5JybSY+AOfsTTlY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOO3ZVeWRz8p8/ZFpWQgK1shv74YNluf2c7cZTqWDYkHnYBOlS
	ac6MAshHEtURBVFZ+vMsxOv/CEbbkpBpEEWfMVmUj9oJj6CYObRh8VUk7GtPkt9wrw==
X-Gm-Gg: AfdE7clpWVIsA1EAm+s0c7LvDZopv6h4TJl3iRbXavk9D+/vo8Z3n/5GfaQxw6BfQHg
	nbxXC00Zcgvq9NlkeZM72UiJNcl0MEmrSZD3ZAA7mPH7ARcDfz+qOQ90bczPKKYKAWfDkPHWHhC
	9BysZL6mCRnZMYAtN1T1D8JPK8IFl+gcl80T7sZepP+sSOG43R7liGpmSJuLg4svyNq0ZUEc9KP
	IYqHJtjZ4AbpqjwW0uVww7odb5FPyHG54OdhROR1tkm6HH3M1SrAt0G85TuaLD7KeMmtiVgMRt1
	tLNQchIHMPgtRQ4Ba+WDVJve5NVShxmmmfBR7rtQ55oi5l556uVeKi8RfF5zSCJTSVO3BKFZkjS
	3xTD5yvan+qSz8LXpiX1iGB7Bs0c36YmvV/UGrFcV2mxYMkRerdV/LY25viaoCq+gWzENOLTizH
	smPS7ZTOqWnvh8ptZ6R0ycoK5PT1UughReRTgqa9Lti44sOhnDGziALPR7GhARAt1TIofwUQ==
X-Received: by 2002:a05:600c:3e0d:b0:490:ab15:b9e8 with SMTP id 5b1f17b1804b1-493bd6f0744mr57395e9.2.1782814417931;
        Tue, 30 Jun 2026 03:13:37 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-475671d02f5sm6914506f8f.28.2026.06.30.03.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 03:13:37 -0700 (PDT)
Date: Tue, 30 Jun 2026 10:13:33 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, joey.gouly@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH v7 1/7] optee: ffa: Add NULL check in
 optee_ffa_lend_protmem
Message-ID: <akOWzVB_yw1-u5uN@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-2-sebastianene@google.com>
 <CAHUa44GST=efeDepEHWs_=ehr7JVnkg+y0ZLebcLAGZXxpNegA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHUa44GST=efeDepEHWs_=ehr7JVnkg+y0ZLebcLAGZXxpNegA@mail.gmail.com>

On Mon, Jun 29, 2026 at 10:53:33AM +0200, Jens Wiklander wrote:
> Hi,
> 
> On Wed, Jun 17, 2026 at 4:51 PM Sebastian Ene <sebastianene@google.com> wrote:
> >
> > From: Mostafa Saleh <smostafa@google.com>
> >
> > From: Mostafa Saleh <smostafa@google.com>
> >
> > Sashiko (locally) reports a possible null dereference under memory
> > pressure due to the lack of validation of the allocated pointer.
> >
> > Fix that by adding the missing check.
> >
> > Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > ---
> >  drivers/tee/optee/ffa_abi.c | 3 +++
> >  1 file changed, 3 insertions(+)
> 
> I'm picking up this isolated patch from the patchset.

Thanks for letting me know, I will spin a v8 but not include this patch
anymore since you picked it.

> 
> Cheers,
> Jens

Sebastian
