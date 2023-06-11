Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB653C121
	for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 16:01:11 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1b3b9413baaso46755ad.1
        for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686499271; x=1689091271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQ1N9WL3eNjzq+2JvC0LUbWsGxnsU5gHhKdxp1bQqFI=;
        b=U8eWpW1rIOgTjrfHfL9mjGce1SYCiKyBeUe6GqsDOC8+bzv+lB4PDBxVYZuGAsjpjH
         7RqWf6wU/o4g9qZm6DzCgFzZYzlfFfvWFbuppfyzF+yqRHHIaCKFvJxj4/0DNs0xXF9c
         ZYcfKWxVJrzjqXgFtBTHm6opCgTv71HMSx8KrNJGRpucE/he9778RoDeK8yka70p/FXs
         l5a1REe0Ol7VTM1VCz8/H3C6LMNCbBK/bXls/d9qcu5PYKFdFQIpNvQhnHUpozuHINaf
         zGRmN7pmot8+rHPlBW0GQtAGNF964hrbTwVr9svom9UFaKPkT2of2rcGT5TDJNDKc28h
         mhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686499271; x=1689091271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQ1N9WL3eNjzq+2JvC0LUbWsGxnsU5gHhKdxp1bQqFI=;
        b=k4PZUZ8VUI2x3AmKyU3KrcoUgJJn7mY8Yb0zeojhk6JAa5ohWpIgj45sgHbdiBiznI
         L7ufyJTI9xLwCO1jjc96XxOpSNLWbMQE4ZF27wSBw72fWRwyjVMW8JpVM5CiUO7Cia8j
         tt48bvPsoaHwr27bmkMRYnp4lMAJiUXTgkv3uQqniuPxWkR1JNAAD/rYclZDacYmomFe
         W3E3xRoiLlPt0DzG5mblLcAInoa1t177W4FVZYcKWk9OAmrg65MQvGDsi/m2BcjcD7xB
         aaymVGl4W9WSXJ0kc7vquHK7bYqlbZocsdMOtqHJXIGenktqEd8Bvc7hEb7R33kadunF
         nOJw==
X-Gm-Message-State: AC+VfDwQ4ZlWRFbTyVNc688YNaiuBSEivWnINLauQ+s6N5iCh7ktFT0p
	9Hyh3jdURlr3YaOur2beiHqj9VntkTSVwM10QOG6+Q==
X-Google-Smtp-Source: ACHHUZ4c9Ppxv2ytbhO39hoK8kL3OhVbcHzWUsLHWOkWT0338uHA/UlBtmrY7QVbcNPZ4wXUXhk9Sw==
X-Received: by 2002:a17:902:c407:b0:1ac:36e6:2801 with SMTP id k7-20020a170902c40700b001ac36e62801mr146004plk.12.1686499270925;
        Sun, 11 Jun 2023 09:01:10 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id h5-20020a63e145000000b00528513c6bbcsm5995565pgk.28.2023.06.11.09.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 09:01:09 -0700 (PDT)
Date: Sun, 11 Jun 2023 09:01:05 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <20230611160105.orvjohigsaevkcrf@google.com>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIV7+yKUdRticwfF@linux.dev>

Hi Oliver,

Thank you for the clarification!
But, I still have some questions on your comments.

> > > We emulate reads of PMCEID1_EL0 using the literal value of the CPU. The
> > > _advertised_ PMU version has no bearing on the core PMU version. So,
> > > assuming we hit this on a v3p5+ part with userspace (stupidly)
> > > advertising an older implementation level, we never clear the bit for
> > > STALL_SLOT.
> > 
> > I'm not sure if I understand this comment correctly.
> > When the guest's PMUVer is older than v3p4, I don't think we need
> > to clear the bit for STALL_SLOT, as PMMIR_EL1 is not implemented
> > for the guest (PMMIR_EL1 is implemented only on v3p4 or newer).
> > Or am I missing something ?
> 
> The guest's PMU version has no influence on the *hardware* value of
> PMCEID1_EL0.
> 
> Suppose KVM is running on a v3p5+ implementation, but userspace has set
> ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
> the preceding line would advertise the STALL_SLOT event, and KVM fails
> to mask it due to the ID register value. The fact we do not support the
> event is an invariant, in the worst case we wind up clearing a bit
> that's already 0.

As far as I checked ArmARM, the STALL_SLOT event can be supported on
any PMUv3 version (including on v3p0).  Assuming that is true, I don't
see any reason to not expose the event to the guest in this particular
example. Or can the STALL_SLOT event only be implemented from certain
versions of PMUv3 ?


> This is why I'd suggested just unconditionally clearing the bit. While

When the hardware supports the STALL_SLOT event (again, I assume any
PMUv3 version hardware can support the event), and the guest's PMUVer
is older than v3p4, what is the reason why we want to clear the bit ?


> we're on the topic, doesn't the same reasoning hold for
> STALL_SLOT_{FRONTEND,BACKEND}? We probably want to hide those too.

Yes, I agree on that.  
I will include the fix for that as a part of this series!

Thank you,
Reiji
