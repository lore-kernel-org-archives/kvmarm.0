Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE0A2E739B
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 13:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035184; cv=none; b=ntt8P5XcXsY9bIJqM/wL8pPIRqZMXN9+/vZ0JKHgUoA+by6qlXxWY6dbuyv7CgXy3GAdl2vO8bi40BV0b7z8EHux3SPx6YuhuDrEY+NcOp8xuwn5Z3+t3yH2wMdkDqT2rWl4TPYT5KaomwFMy0/2feOjG2mWeRxTOUKjLi5UaAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035184; c=relaxed/simple;
	bh=gNQbWMo3+xuQy6Kz29z7hYNh1vRqVYw1Xiy6UBJ5LhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lmt2BVDI+s0O8s9U9GbnmZhhzi1SduK3et4SQc9hxqYDgzYghkM9fhU4ge1cM3rSd/ALa15KHnudYrVelSed9YJEVwdHHK953FmeuOFXXzwep5GtIyieJceinZxLnwBmdm4sWQJLAn7S9RhCAERWGde5AdgzZT7ttLB42r1yYj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PEaihdJg; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PEaihdJg"
X-Forwarded-Encrypted: i=1; AHgh+RosKBpxxEJprOg5LXbyYrx5CmaJoOS8AaPU0er/GdQOG7zs3yem9Tm+0z0bg8HK7o/Ht2CYNZA=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784035177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MisgD/Dm4jfxdL+N9uTf8UsCLM0Rw/O7yRZ2Ejr0nAU=;
	b=PEaihdJg9Ga2ACVY4o/uUtS6AItn9nXXOVCWZUeSnuQ7z1UQQ5CdhfafuTOAgD1X0k5nbt
	lzLdaX6ISDn4k4uFtDd3P+aUDyNY/0Tkh5h+eO12KfAn20aFHhLeQ9Yq32DLlmhG1JN6vI
	WIf1sx5BLqDvSTkdmPKnFKkOhZXAvm0=
X-Gm-Message-State: AOJu0YxNyfBcnXVZiEmngn4DjitDdhcXWaeStzpBzDellDSazQ5w/wJs
	KMlyMerxgsHDkZEg7Gb6FXzS7Oe7lTdle9Z3bUa/oF5toDyg2DQ03mmp87yPTt6oXN0OuVE0BU4
	pgMuWQlbAxjZTb+eeAcMwPSraLISUUZu41AZMa+8D
X-Received: by 2002:ac8:5787:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-51d7bcc7aacmr14328561cf.8.1784035170138; Tue, 14 Jul 2026
 06:19:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714091641.1970822-1-maz@kernel.org> <20260714091641.1970822-13-maz@kernel.org>
 <20260714094609.4ACD11F00A3E@smtp.kernel.org> <86wluxokv5.wl-maz@kernel.org>
In-Reply-To: <86wluxokv5.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 14:18:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzFRbu+woK8yyGLdhrVe+qEerw2cZVaQ-06XKDx8mX8UQ@mail.gmail.com>
X-Gm-Features: AUfX_myOmQ_-286nUyOzdr2MXl-dvEjJDih84jWWsiAddgpppNcY09PrjHTx-ho
Message-ID: <CA+EHjTzFRbu+woK8yyGLdhrVe+qEerw2cZVaQ-06XKDx8mX8UQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/28] arm64: Add FEAT_NV2p1 detection
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Marc,

<snip>

> Fuad, can we please either teach Sashiko about out of context register
> updates not immediate requiring synchronisation? The constant
> insistence on having ISBs all over the map is pushing people in doing
> the wrong thing.

Done:
https://github.com/masoncl/review-prompts/pull/87

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
