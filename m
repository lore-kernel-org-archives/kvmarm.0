Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766FC272903
	for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 23:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697964; cv=none; b=g85B4v5ccHX2vZlxRsVaTpi9opfEFJ11AuLrH/HdPhHoCGGcLLDkbrbTYz32cEscIwG2p9nyOWYRxZoQBIilepw+kO/KzGEfdUGvIZW7I20Z0u/j1W3Zvw5oLtbx0Ux3wbSMWyX7zhRaH22SBnVMQeixpVpJ5iAAXZSWEjEi6YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697964; c=relaxed/simple;
	bh=qXZYUb+38s6T7BVpnd2FbZlzNg9yTJdtjrYvUzxnbAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RDebrqnfez59YgMjXoKKME5OsOWZW31wLQO/3k89MuW8LW1zvXmCzwczBRMnI7uaPxkKok3DrP77J04PVUhYtLZ6itJsOyK41aMyz2HKhwU0KCVKupV+YpzjUqDnW12wxN6Q3TQ0SHaaRPL4KR7vHLD+P75cqBoxfbWbPscJDqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A2MMqoDS; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A2MMqoDS"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43a9e6cd0b4so8925e9.1
        for <kvmarm@lists.linux.dev>; Thu, 27 Feb 2025 15:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740697961; x=1741302761; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fj7LGOSrk0w5SNsFMZf4HWgkzLmJvJuks0dPBWfMtzY=;
        b=A2MMqoDSUURpGXpFP944BZUjkUIs6hnyzmAICrCLWzoGYgzBwCRma/a3oLUxReg4Ur
         NBlr05poUYJO8lQZiGky834kUZUJtMAGLliWSNq1pP/Mzbsi6zmHz0eR3HpzAgBEZbrv
         uvf1Yv8tB3nfGmSwYD9Pz8CGyZYRLDBXgKk1Cz7S1IEcOY2UUyPP7+GWNkEpJKt2IkIU
         Oa4bt7dLcdbBCh8z00i3cj/MDzc27V67U28MX4F3SHx6j8/B9qxEj1bzoGLRYQ/j1jnG
         Vyi1L2wK+pU/CXcgicnDCpVm41QGqu99i5GU60mTSb99WAn4lT5HNBOS/dkGu2z2m6Y5
         bIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740697961; x=1741302761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fj7LGOSrk0w5SNsFMZf4HWgkzLmJvJuks0dPBWfMtzY=;
        b=IcUihL3pt6iWnRXFx1+CIowtRxVxp1+VotieodUg8IJf0eVnyfCFzuPRkbtgGA7azX
         mh/dHg//yI/SicLSI9ZgvRCrJy/I6Aqrtz27ketmngd1rqGdW2PAkVOcOcEevrzwLHeU
         kJ/6l4XVQXGmeuKPf6jynXuCyXhmbqlNLOgr3s26HHfC7BzrpqaTgjrbtROkfoimsy80
         KBXDJXK5HKJXEJT/BCBDF/6Jsyb4QejsbrOBduwWrE14NdD0tf+A9SNptoRlrYgtdt/q
         xQZcsE5L/qsvvZEmQqxS6BTvb+XcCchRDIzAbq9CoOQ19qpB2lnVKxrKCbkg7VGL1u2L
         XK/w==
X-Forwarded-Encrypted: i=1; AJvYcCUhhA9v+1bTJJ0fqwcnCTLpKhVQG+/zTy7NffDneUNbIcNXDz8JTWtf2sTDQIeeBFo7DQ5wi5M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM0HLWJDHC/a+lRkxgPPjw62Mtozt9+5mrvIOhsI90SIHZq/MQ
	++6u5M7MeUCIbrR67OZkrmNfVURyxItJCZFXxXNBDepKGCu5ChkAuqkNKrb+Wg==
X-Gm-Gg: ASbGnctPYWBS+ckaRmFs+re4HnkwubluHmV7xGjHRlYFAOZklSpXly/CgG2OJDzwhlU
	PudjJ9o0vU0flGDORY5EAfUpuUSCbljSqTndBO1Hsoy/58EPcJ+9Ns0910hj5H67x0hWvluxDMU
	FzeD3dWWPUv3V/lJPRCsCv79iRJdc5NSNOy8mAQTf5/XN/XTkjV8WZ2Kei5VOgPVSVdF9PFu6/u
	sPHmy5K1EIryA/FbqoQAOY/PYrF3J2txXHtgRJ0hCPEhF+AGznEK6pfxCCzKXLwZQNieOQP4N+D
	tTHzGAeCQIQ/5bUvNUGTMB1FQZhKRLmSdJLo/tIYqpCl6fIImq42hifWswHKTo1vzM2mKA==
X-Google-Smtp-Source: AGHT+IFqQLaqdVWxc8waBGwgBaSF4yEsnQkEr61vpanM2YcoX/7/V0zwkd6V54Vs2QrQ3ETgd2DUJA==
X-Received: by 2002:a05:600c:5618:b0:439:8739:b82b with SMTP id 5b1f17b1804b1-43ba6edd7bbmr333605e9.4.1740697960527;
        Thu, 27 Feb 2025 15:12:40 -0800 (PST)
Received: from google.com (100.235.22.34.bc.googleusercontent.com. [34.22.235.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485db82sm3254105f8f.88.2025.02.27.15.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 15:12:39 -0800 (PST)
Date: Thu, 27 Feb 2025 23:12:37 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, snehalreddy@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, will@kernel.org,
	yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: Move the ffa_to_linux definition to
 the ffa header
Message-ID: <Z8DxZY-09R6lwEW3@google.com>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-3-sebastianene@google.com>
 <20250227202557.d3fd6ylzbaho4pvx@bogus>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227202557.d3fd6ylzbaho4pvx@bogus>

On Thu, Feb 27, 2025 at 08:25:57PM +0000, Sudeep Holla wrote:
> On Thu, Feb 27, 2025 at 06:17:47PM +0000, Sebastian Ene wrote:
> > Keep the ffa_to_linux error map in the header and move it away
> > from the arm ffa driver to make it accessible for other components.
> 
> Do you plan to push/target these changes for v6.15 ? If not, I can take
> this patch with other FF-A changes in my tree for v6.15. Otherwise, it
> is must go along with other changes.
> 

Yes, feel free to pick them with your changes and we can push them
later.

> --
> Regards,
> Sudeep

Thanks,
Sebastian
