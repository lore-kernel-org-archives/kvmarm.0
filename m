Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783EEED8
	for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711366185; cv=none; b=mdPnHHQewQEspfSYkMNkN48tFfBNiGBxH7dNfcwsRq3y/EHrScYx6lvxq0cg/s6Z3hSylTHmL0cK595Hzr1K16QCu5RV92iDhS2QkjjFCZbRkotckXZIEw8gUJ+v5by306oIguK5Knj8RWb7Cwx7tHq7zQFLE7VrtoqkKsX+518=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711366185; c=relaxed/simple;
	bh=DfPqsjzS7hM0pHS4XcLmOdcjRtfbF39TxfamCWHwy68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWMJQACc8tMe8IOs70QuKc9MqNedK1nSXH8VPHdPY5rJMO7+KwMaEM9aXWkQmEFR3D7n7DVH+OyvlbIW/Scbd80K7gFMdi1v8oKoVY8NGTmZWKLPvcLfX5PISVMswuK9+mcT38qLNZCjYeT1KEsqhvAnVyMFHjgJsVgKtqujCXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zbZjaEJe; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zbZjaEJe"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4140eed8a4fso91915e9.0
        for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 04:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711366182; x=1711970982; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GkNYJvsdSYu5fwK3ocDdS3LzfZ1gl4LLmO/SR89+rGY=;
        b=zbZjaEJeftACFWNvnobThVdcFn3YuKcb2QZJm7zxek3iK3lFAm1K4nBrpuC+NYqBO4
         eRQH3RyRfKVwBZA7xg/2hF/T1riBNoHRMWyZk1LthMQTb9G0tRc2g/+a9ry8BGdCJC8E
         KCejmrC9bj8S3GO5aWTR49gs0zhtgorogAxI5dtkmo6pgvlhILDIAGcvwOYMBOgoCN74
         SCQG3CdzK0EZh/PSCq0JT4d+ByJNe6ut6hBAyewBOsqF8sYeurj1kMPdTe2kDDpobrqD
         b0JYSbd3kqrPPOCgcpoo8NWzcp4VuH91sXoPgmENLzQXAqeW/ZLOI/FmWTc8pjxPWG+Y
         +VeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711366182; x=1711970982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GkNYJvsdSYu5fwK3ocDdS3LzfZ1gl4LLmO/SR89+rGY=;
        b=gx+7Q+eCfVPf/B0P24PHjmXEW5Vdl0SZpq9+bLTkKP3fX+XIbAXtDsR7DnyulN2C4x
         DLbj2995r4y7rCFJlGUYutYROK0VT+1tW44caF3fMLmBVBFl96KnBTrgCYTxhZfI9bUl
         w6DPbmreHC2U5i2WSBiea2Fgs+EbZMEqGQZPtgg1uplHgJ+5xNryHoPJQUiXCQH3dC8t
         XrUO8WWsQCuGtkWdmg6+JVJyh/ml3E1qHYfcGZ9F152fmwaoF8AT/HJ6WwEkugulJvQh
         fy1bjSr/2DnDJjkfsl2VNRCj7D0bKP2PoVeOVV8B8OrLVpNBvpOhdRjOUojp7PZu7htS
         98PA==
X-Forwarded-Encrypted: i=1; AJvYcCVyUxOVoXIZe1aqS4Ku0Gy2v9u8StJ2/Zm9FUADWPSWgVRSCj9LIj7R+fntKe4iyWMONuqAkhQbV5qGMORndCezxJlAuWT/
X-Gm-Message-State: AOJu0YylVxtAM1gnp0mav9QJXOX53FicezRx3Hc14RAxHvPrsf1MpPVM
	0WhLpHknES0Xh44zsh0W68W8FpJOYW7MHgmeq4RCn5VV9XhArsFHNiiuL70BZQ==
X-Google-Smtp-Source: AGHT+IEqrqZ/kvgiywLjCv3Lnov4/3EfG9IoekwC7LJMklqp7fgDJFEOrVMhVA0far1ZCvdOK2vGMQ==
X-Received: by 2002:a05:600c:35d6:b0:414:866e:4437 with SMTP id r22-20020a05600c35d600b00414866e4437mr203074wmq.1.1711366181603;
        Mon, 25 Mar 2024 04:29:41 -0700 (PDT)
Received: from google.com (248.199.140.34.bc.googleusercontent.com. [34.140.199.248])
        by smtp.gmail.com with ESMTPSA id o24-20020a05600c511800b004148090cf86sm2943880wms.0.2024.03.25.04.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 04:29:41 -0700 (PDT)
Date: Mon, 25 Mar 2024 11:29:39 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, qperret@google.com, qwandor@google.com,
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH 2/2] KVM: arm64: Allow only the specified FF-A calls to
 be forwarded to TZ
Message-ID: <ZgFgI0Ky2m4MUbw-@google.com>
References: <20240322124303.309423-1-sebastianene@google.com>
 <20240322124303.309423-2-sebastianene@google.com>
 <Zf45eDs8Bd1UQ94Z@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf45eDs8Bd1UQ94Z@linux.dev>

On Fri, Mar 22, 2024 at 07:07:52PM -0700, Oliver Upton wrote:
> On Fri, Mar 22, 2024 at 12:43:03PM +0000, Sebastian Ene wrote:
> > The previous logic used a deny list to filter the FF-A calls. Because of
> > this, some of the calls escaped the check and they were forwarded by
> > default to Trustzone. (eg. FFA_MSG_SEND_DIRECT_REQ was denied but the 64
> > bit version of the call was not).
> > Modify the logic to use an allowlist and allow only the calls specified in
> > the filter function to be proxied to TZ from the hypervisor.

Hi Oliver,

> 
> I had discussed this with Will back when the feature was upstreamed and
> he said there's a lot of off-label calls that necessitate a denylist
> implementation. Has anything changed to give us confidence that we can
> be restrictive, at least on the FF-A range?
> 

I remember your proposal for having an allowlist instead. The current change makes
sense if we have https://lore.kernel.org/kvmarm/20240322124303.309423-1-sebastianene@google.com/
which opens the window for more FF-A calls to be forwarded to TZ.

Let me know if this clarifies, thanks
Seb

> -- 
> Thanks,
> Oliver
