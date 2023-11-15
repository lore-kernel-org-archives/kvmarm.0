Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7057A43AB4
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 22:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZStRS4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D53C433D9
	for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 22:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700087634;
	bh=MRhItKtLmcP3MGw/uE8Sv8g2sxpNK7WnjzdhDPkJZB4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gZStRS4jxyvhCNIpmveMcAbCtbqIowAXALwpz+8y616Q3tgFIwQAEjhaU5ogv4r+h
	 jjvYDWeZC9XoJYBuck1hT7XMzljqq/Re7gMjLNAN8G/LXhznJVlz9ZJ1fVruKD1pcG
	 IChuHbnayhfsrjMuVpFD+zPMDuo0bNnNjNIvP0KwhPMKilbKkEBz/JMGUa90EfpWU8
	 tOc9jX7amS3Tu+aZtP38HrohGBXnTGiQ9VJDJkoe+hx3ees6K5ZQVt2C86f05PiSMX
	 NkI/oL+drG4CIhgSymH2NR4oFWsCNvEUdc/hp5oX3vFL/cD4b8ytt23zHkOQJb1hiN
	 LTgJ6nn+RDmUw==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2c7c7544c78so2101271fa.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Nov 2023 14:33:54 -0800 (PST)
X-Gm-Message-State: AOJu0YyfMqrhKGeUD8xw2ICQuwBJsK6EPGPA9FmibQc7OiKzlivaqWyG
	dIedU65cRipVARcPFMRdPTKjJS4p17kcG5vwrDc=
X-Google-Smtp-Source: AGHT+IE5MerhpnD9nPfsgdKWSqZhJTMySWF1dwxqowp1F1VSpyAWPzfzODJyNFCd8PwoumPsWYrfLh+wQZRqNBfyn0I=
X-Received: by 2002:a2e:87c2:0:b0:2c5:582:fd8e with SMTP id
 v2-20020a2e87c2000000b002c50582fd8emr5330887ljj.21.1700087632996; Wed, 15 Nov
 2023 14:33:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
 <3800df70-73f2-44b7-a6ed-15ec0bd63f5f@arm.com> <ZVIkPm4uxbCNsOgh@arm.com>
In-Reply-To: <ZVIkPm4uxbCNsOgh@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 16 Nov 2023 08:33:40 +1000
X-Gmail-Original-Message-ID: <CAMj1kXG0MRkN2pH6XAonGUjeaLkQr5xoOtpEuGQk5yBdsOxh4g@mail.gmail.com>
Message-ID: <CAMj1kXG0MRkN2pH6XAonGUjeaLkQr5xoOtpEuGQk5yBdsOxh4g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Update tlb invalidation routines for FEAT_LPA2
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@google.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mark Rutland <mark.rutland@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Kees Cook <keescook@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse <james.morse@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Nov 2023 at 23:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> But first we need to split Ard's series into
> at least two: reworking the memory map together with moving (some of)
> the init code to C and the actual LPA2 stage 1 support. We might even
> through LPA2 stage 2 on top if we feel brave ;). We can queue them all
> together but having separate series gives us an option to drop bits if
> needed.
>

I have rebased the changes onto v6.7-rc1 and squashed or added some of
the followup fixes:

https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=arm64-lpa2-v5

I am happy to carve this up any way you like. A natural split would be
to include everything up to and including

arm64: mmu: Make __cpu_replace_ttbr1() out of line

and queue the rest later, but perhaps you prefer to start with a smaller subset?
