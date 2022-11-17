Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACFB15A5
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 01:21:02 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id b29so267540pfp.13
        for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 17:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9RXOutukKu5blPlWvexAz9n9/ERlHayplCb37e/A/4=;
        b=BCJ2yFn1tsn53sy1KM+C8Zdkm82sOpVH7Y2IEhdM8rEe13KY0+JzJibXQNw49jtg0F
         YJpEGHLSia5ik4xDLNtUdQIGQn0Mnvq5shG/tD+yC5C36OKusWOkmEEIIWPLzDz+LDeJ
         +EbWB3TGbfUThJkJrUqfMhcfj7xrboNt4Z3Q1/VY4vEMS6ja/gEVrEgQtOn4PLLnvf0+
         Dknem1k3dNWoBkp4GT9fG6BrZjEyaqrE8zcMCpiFHFeZs/CeijWHWxsjzlujxeDGbT4a
         ZNQETjJ5XpC/A7xD7UgpSEMubrDNSt+PhkWikvJsLXLMyToq6DkALWrxQCrz4tbZ83dw
         bSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9RXOutukKu5blPlWvexAz9n9/ERlHayplCb37e/A/4=;
        b=CCNmtZrOJG/TX0O3s8DxeDHyi/aALU52rV6dCHCC22beXVBjzr7pwI6ibAFpn9yDYk
         mNLfcrV+WuAtZRl0+PvFcJ4hTh/as9CKY3uuY1el1uUUZnIkthsYYTlpiH4+Cn5RbDx3
         JGP1QevachU+UDlv4DfbI2uCmTpc2RZEcYeI9D+1PvulPKnaq556Rjp+wizpy+n/74pb
         wE8kCNL9mdC+UfZjLnqNGlha77B8W5/T+wR+yvrbG8kz+YnhEUboFk0z7O570pW3LqBp
         nhRbEMXyz4PzaHh2JXwYJWqwVuVi2HKJxOJzG6CWUoARjlEtvYtwpLFJPd58wsBgCAi7
         8ChQ==
X-Gm-Message-State: ANoB5pl1yR/eRmEdtnTdGGYuLJz7Lh6ZCO2KSoOr29aVBXF0RSz52hgA
	o30HOM1gfzVDE65MKqwZV8580g==
X-Google-Smtp-Source: AA0mqf5o9XatuCWD5GyO3XSpaGxhhYlntr2oFTRpGlCI7pnvkOwR1rcY7hYGwMMPWemsdnVer00SUA==
X-Received: by 2002:aa7:9518:0:b0:56c:8c13:24fd with SMTP id b24-20020aa79518000000b0056c8c1324fdmr778700pfp.2.1668648061959;
        Wed, 16 Nov 2022 17:21:01 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e12-20020a63544c000000b0047048c201e3sm4864960pgm.33.2022.11.16.17.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 17:21:01 -0800 (PST)
Date: Thu, 17 Nov 2022 01:20:58 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Disable single-step without
 relying on ucall()
Message-ID: <Y3WMeovid9z1qOjD@google.com>
References: <20221117002350.2178351-1-seanjc@google.com>
 <20221117002350.2178351-3-seanjc@google.com>
 <Y3WF8YlvFm8NGYHd@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3WF8YlvFm8NGYHd@google.com>
Message-ID: <20221117012058.bsMcDlITMJk1SmvdfW5hsich5deI6LJs7IP9BkBbdiE@z>

On Thu, Nov 17, 2022, Oliver Upton wrote:
> On Thu, Nov 17, 2022 at 12:23:50AM +0000, Sean Christopherson wrote:
> > Automatically disable single-step when the guest reaches the end of the
> > verified section instead of using an explicit ucall() to ask userspace to
> > disable single-step.  An upcoming change to implement a pool-based scheme
> > for ucall() will add an atomic operation (bit test and set) in the guest
> > ucall code, and if the compiler generate "old school" atomics, e.g.
> 
> Off topic, but I didn't ask when we were discussing this issue. What is
> the atomic used for in the pool-based ucall implementation?

To avoid having to plumb an "id" into the guest, vCPUs grab a ucall entry from
the pool on a first-come first-serve basis, and then release the entry when the
ucall is complete.  The current implementation is a bitmap, e.g. every possible
entry has a bit in the map, and vCPUs do an atomic bit-test-and-set to claim an
entry.

Ugh.  And there's a bug.  Of course I notice it after sending the pull request.
Depsite being defined in atomic.h, and despite clear_bit() being atomic in the
kernel, tools' clear_bit() isn't actually atomic.  Grr.

Doesn't cause problems because there are so few multi-vCPU selftests, but that
needs to be fixed.  Best thing would be to fix clear_bit() itself.
