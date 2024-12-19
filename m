Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7F9221D8E
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734606871; cv=none; b=EEW+PCbYL8TIFXEp+JL03nK/6GJMo7lq3TDjUEGV4/fsYfcwozm0/dHZdhw0zG/5EUJPcPqJAWlQuoMcwOOTB4QWWesuWbfJMW7WOJkVA+DFv1VcBgk7w2ZCTzYtk1TG+TsGtWEwdPlbzft8xCKRw64uThztHRJaMOhQSpRqO68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734606871; c=relaxed/simple;
	bh=8RuIoJ0q/4dY8lZ6nY/JYhaMNSssJ3bm0ZjjKWMF2fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UvDS8tGQwWdUBeea/xs7qN8c7gYCo4/tjwp1cdjrF9ayPvF4QVxqjzQBBLDj4ukGSVYuG2FV3CAoTVSFKVZ/XnHYDWOuxs12iZ0Evg2Bm9+Pv0ZxwA1N39ep1LBOmXkDWnTnAYS1Ya+Umhb+zH9+RIOdqK06mE+16UYCnRZZG3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QMkvzoIv; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QMkvzoIv"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aa67ac42819so98892166b.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 03:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734606866; x=1735211666; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k232UiDWZ9i334Ovjw0KByCgbnjokcMOWAtrXY0DoWA=;
        b=QMkvzoIv9MNy3/tmOszVE2kQknWv+fyaExkIC/1C1/p6EyytgO7PVUnNiLCrmeXawE
         Zqc2dqX/UBvaGNFA33Ep5VmLqKLLDiPm5dLPlgAJm+rMKI1hNVxulf3PNziH8PJnEfb3
         FLrudClVl8OogiDZO7wFmf8KiWy6okKfbNG62KOJKYil0Bek6gxzC8ZA9naZJXBVGq0r
         QDZqD9mGmGjckDlFUXYucstv+5loic1z0Rr8wtvfmMuI4zJuTOfhf+tNkjRfyHxV28Vd
         qB03ftMPejweliF4mooSk+ibuzr8gUAPc+PYrBk5luZxHzRDVuT/vuDI7WXAcq3n9ApX
         bsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734606866; x=1735211666;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k232UiDWZ9i334Ovjw0KByCgbnjokcMOWAtrXY0DoWA=;
        b=Evrsy2udT3j3smNlfpJKrr3s06j5Yrfqo8nkuOM6C2dF0O1vxV8Og/N9CtCVU0lAYL
         97uizFztmHxwA8mMn/MN4Ve52cdMff/kN/SamhRO8/U0eUGgiFuO0le8dhoOSdowhOJA
         3jCHH3yjfRxrdjqd0sN2zjHV6G+oCUHwkKn4/UR1iY4D+MMShhZI3Mt6dzQxjvQIISql
         6KSQ4LfSq/jg+AmOWXt6ryuxzoBJ+Ekt6PvDhhnSkaOT9dPYzVkwCuGN9RaxuudXONW9
         5Pv1SrIqtjlUjcZgMWa+P48fkZlb4R3Zq/m9aBGsrUaRTuEHKhA4SWOs8tUJofhhGZVi
         3bNg==
X-Forwarded-Encrypted: i=1; AJvYcCXbNGurhsuC4Pqu9xalDYc2mxMty6ClYeXZ003UzcohpnwT1NbRouc32c2X9XKUgoQVNZMuSQU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXxSPAi4FG9ZF9W26OWIoqd00TH4m6d0uoUoLEytHNv59G9KaC
	6z2H00robywoqKBgjxYpEzLElK7Hax4v6cOn8At3KFWZpcv0hIb64hZ9q92mog==
X-Gm-Gg: ASbGnctAi64w9nDXMdJ5s3JMbCHi6x3Q+x7d7dxoftRAE3RuqbLM6kNEQX9M4F9cd4g
	FJiz0qCWgf0mxIlhFpXYowQ+w37r5rwVGWQM5bKV1LZdyt4daXa58XJB/0o0zemWlQNlqDcrOE6
	vKzcAdYIW3qo3qiAUVtaB03YW4uFnZMbv9qE7afHoGwWdL5Vsy0rD9xEJBahYLUEJykwbbldZio
	ES/+xhO1uTs3CZRp/uWPLz+/o87wGAk8uVsoJTj+Q3rLtzl0M7dT3wMZtbGR+4lU2iFrdXzvrnp
	kG1elSNhgOY1TTc=
X-Google-Smtp-Source: AGHT+IHKoh5EsN1uLkOfWMRdI2tQtHhYwKploXkp4V8soZqdefYj8PoGPzqWp1FX9+8rm326OJSgBg==
X-Received: by 2002:a17:907:1c90:b0:aa6:85d0:1486 with SMTP id a640c23a62f3a-aabf496eb16mr518756966b.54.1734606866353;
        Thu, 19 Dec 2024 03:14:26 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e8954adsm55343466b.64.2024.12.19.03.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 03:14:26 -0800 (PST)
Date: Thu, 19 Dec 2024 11:14:23 +0000
From: Quentin Perret <qperret@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca,
	nicolinc@nvidia.com, vdonnefort@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 11/58] KVM: arm64: pkvm: Add pkvm_udelay()
Message-ID: <Z2QADxbdoYi5q9iT@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-12-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212180423.1578358-12-smostafa@google.com>

On Thursday 12 Dec 2024 at 18:03:35 (+0000), Mostafa Saleh wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Add a simple delay loop for drivers.
> 
> This could use more work. It should be possible to insert a wfe and save
> power, but I haven't studied whether it is safe to do so with the host
> in control of the event stream. The SMMU driver will use wfe anyway for
> frequent waits (provided the implementation can send command queue
> events).

Mooh, I'm thoroughly hating that we need this -- pKVM is non preemptible
so we better not wait for too long.

I can surely figure it out from the following patches, but could you
please expand on the use-case?

On a side note I'm not too worried about the power impact of not having
a wfe in there, again we better not be spinning for long enough that
power starts to be noticeable.
