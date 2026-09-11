Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B52423A72
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 07:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110162; cv=none; b=skfp1gy4O2ttGE2Xk6DIkhIBnJuDdqbd0KCxa+QAlPVBJktOMm0C4AJORdTKSbkBgoPGU3TZD4W7dxzGDRgcTP4UOrf1pqq+zkBL0Lbc0w/UAfciRZ54tmEKf305CnEcLq9AFrOhz/5OGXaEL+rN2PM+VJJLGlwgiwa9HU4C91o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110162; c=relaxed/simple;
	bh=+g+42iif6IVcRrIokUZrLgCvAoBdHhejpcI6IQl7UoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=igwz+892pD/QhWf6PpPwu5d471abaSMwI4W632rVNVQtvNmcr1241KwfbqTijRYfO+f+oMNWL/x7nvk6+UTnrcNckf3QRBa4KjHzcex4tWzU1s2JFbcN1TunSEEp9gFctbalKdmoAJlECKa7fbN6VGc29A8COUvKWE5vA5OhUIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gWwJK+O0; arc=none smtp.client-ip=91.218.175.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gWwJK+O0"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+g+42iif6IVcRrIokUZrLgCvAoBdHhejpcI6IQl7UoA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789110145; v=1; x=1789714945;
 b=gWwJK+O09uPeiaDDSrxDp6RoulnIuDh9FOO3WWuNVMcDE1Qj0Dsu4P2Gn/jzmfvRDfFF9eQS
 DadaAuZ0xvUMSGrJke4PzijdS62nd+x5jN2jbwPOWisOi40YnuSH7SdHq31X1aW0jL17fLJykhn
 hUuMk5ZGY9HVB/bwgWUG9Q9w=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e217872e2430734d;
	Fri, 11 Sep 2026 07:02:25 +0000
X-Mizu-Trace-ID: e217872e2430734d
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so2542e87.0
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 00:02:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByRk/CFjjx9t8JBmkh4tReEiFMXNNbQI8Lw2Syhtq3uxWhIZ+35+ASJQgErR+mIrrNXPG6FJdU=@lists.linux.dev
X-Gm-Message-State: AFuF++nNO8Zim6qe1P2Ar26Krf0wG4TvFIy54We4BcZ6mBid95kFBUzk
	8PXny+2eeliQsEqu292U41VqaTIv1nsCZNzMGunfFMmq4hGuoyb0+3xHYj4tMACwPYBYQ85B1NW
	4hFIoDARpE+lvo36LUxAAic6KxY/q577AgSfQWU52
X-Received: by 2002:a05:6512:460f:b0:5ae:b9c5:f29f with SMTP id
 2adb3069b0e04-5b8a05a180fmr90471e87.2.1789110143622; Fri, 11 Sep 2026
 00:02:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260908145651.2828597-1-fuad.tabba@linux.dev> <aqKJM3CF-i3VyJk2@willie-the-truck>
In-Reply-To: <aqKJM3CF-i3VyJk2@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 11 Sep 2026 08:01:47 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwxm1BxDq2Aqy2tfF0sXRZvfRLiSn5jaHYf=g1S2ARHRA@mail.gmail.com>
X-Gm-Features: AcwNN1XCuogT4WkezybFayrxqhUNrhZMDnWGz-WkLBJOTExg2uTnRtgxv1nD4YU
Message-ID: <CA+EHjTwxm1BxDq2Aqy2tfF0sXRZvfRLiSn5jaHYf=g1S2ARHRA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, 
	Ben Horgan <ben.horgan@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 10 Sept 2026 at 11:40, Will Deacon <will@kernel.org> wrote:
...
> > +static bool
> > +test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
> > +{
> > +     /* The registers exist whether or not firmware enabled MPAM. */
> > +     return detect_ftr_has_mpam();
> > +}
> > +
> >  static void
> >  cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
> >  {
> > @@ -3116,6 +3123,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> >               .matches = test_has_mpam,
> >               .cpu_enable = cpu_enable_mpam,
> >       },
> > +     {
> > +             .desc = "Memory Partitioning And Monitoring system registers",
> > +             .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > +             .capability = ARM64_MPAM_SYSREGS,
> > +             .matches = test_has_mpam_sysregs,
> > +     },
>
> We already have two system capabilities for MPAM so I'm not overly keen
> to add a third, especially as the MPAM code is largely confined to the
> resctrl driver. In fact, this feels a bit similar to things like TRBE
> and SPE in the sense that (a) we have to probe it per-cpu (b) it can
> be disabled by a higher EL and (c) most of the code is in a driver, but
> KVM needs to know how to switch it.
>
> Neither TRBE nor SPE need entries in arm64_features[] at all, so something
> isn't right here...

I think I've overthunk it. The problem isn't in what the host is
doing, but that KVM is basing its traps on whether MPAM support exists
and whether that support is enabled.

V3 should be more in line with what you're suggesting...

Cheers,
/fuad

>
> Will
