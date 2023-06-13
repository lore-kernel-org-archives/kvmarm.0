Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD70F17E
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 00:26:40 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1b3b9413baaso45825ad.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686616000; x=1689208000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sG+y868fGGwtVP8PKGF9VF3f/ok7RNLP2cQ05nH3HUE=;
        b=iWHBXILMJIPATpHcRZR4K1vDWcdjC9GrHG/2SCQKB+qQux//FBSWKENP5iHy2ZTKSK
         lexK9lzm24crVVGD/M+6lGwOghCYJPsk6VJGNt6JOJO8Vb85Rziw+Xo17R12cN9bJczB
         Iw20rMMwG6iReqNa6VmAdNg5LOo0KPTgycf9hY+AbaXLHOoZT70xB/lFaWt46aWw8C2f
         sOx+UHc+HxE8tjb8+si1A91i2C+v4VNATOVwsZjf3UEMTWXRnid6hURKa2jwf1PG1TNA
         IRPQLqwoHzdideu67RL8A3Q8sivQ1F5h4Hcy2NSmFagKG7LWbgwYqP/Mgdawax0TPilF
         xDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686616000; x=1689208000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sG+y868fGGwtVP8PKGF9VF3f/ok7RNLP2cQ05nH3HUE=;
        b=WjxSDAZJCoLlOj6ayoSgr10y+WlTGE+JzIGXW66QCJdscRyZIsMiNjE8did7rN7Vud
         d67CC1rEGog/KA4mE9I860q9l0fvilrgSv7f23y3uAppuZWtM5A67SPrdlwEMa00/uF+
         1hAGuv5tAQcLR4Fak81hWIidODgSzVzVxKKdDdzJoz68ioJ/1MJDqMtURSGIA2laR0hL
         Vrmk23Lo7jsZvvkA/0o79aLxnjGy0OeVOt0N/ABFoJdtea4KU6ZTlfRJJEs6PZCKavxg
         i9Qh3vB7L7FEQlvxuOcZexYhs2CPKOjMC9k1sn4WkY+nmttCswPRDb3dZdN7g71F51HA
         DX3w==
X-Gm-Message-State: AC+VfDxoIvQhhmyADd6Y8V9rjIx/atEm7963tfi3W6WtZnfc3wouCyoG
	wXY0GRUdeMtal3PJu25Qa2RDPg==
X-Google-Smtp-Source: ACHHUZ5JkU/ii+XmIgB87RwAT7Cx/A9282/kfWxND7P1Sgc1Ov+FJ2HY/A4GhuBLgDV2fuWre9y5tQ==
X-Received: by 2002:a17:903:22c6:b0:1b1:b2a9:f256 with SMTP id y6-20020a17090322c600b001b1b2a9f256mr6266plg.1.1686615999648;
        Mon, 12 Jun 2023 17:26:39 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b001af98dcf958sm8841656plg.288.2023.06.12.17.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 17:26:38 -0700 (PDT)
Date: Mon, 12 Jun 2023 17:26:33 -0700
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
Message-ID: <20230613002633.gdttlmn5bnkr4l5i@google.com>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
 <20230611160105.orvjohigsaevkcrf@google.com>
 <ZIdzxmgt8257Kv09@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIdzxmgt8257Kv09@linux.dev>

On Mon, Jun 12, 2023 at 09:36:38PM +0200, Oliver Upton wrote:
> On Sun, Jun 11, 2023 at 09:01:05AM -0700, Reiji Watanabe wrote:
> 
> [...]
> 
> > > Suppose KVM is running on a v3p5+ implementation, but userspace has set
> > > ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
> > > the preceding line would advertise the STALL_SLOT event, and KVM fails
> > > to mask it due to the ID register value. The fact we do not support the
> > > event is an invariant, in the worst case we wind up clearing a bit
> > > that's already 0.
> > 
> > As far as I checked ArmARM, the STALL_SLOT event can be supported on
> > any PMUv3 version (including on v3p0).  Assuming that is true, I don't
> > see any reason to not expose the event to the guest in this particular
> > example. Or can the STALL_SLOT event only be implemented from certain
> > versions of PMUv3 ?
> 
> Well, users of the event don't get the full picture w/o PMMIR_EL1.SLOTS,
> which is only available on v3p4+. We probably should start exposing the
> register + event (separate from this change).
> 
> > > This is why I'd suggested just unconditionally clearing the bit. While
> > 
> > When the hardware supports the STALL_SLOT event (again, I assume any
> > PMUv3 version hardware can support the event), and the guest's PMUVer
> > is older than v3p4, what is the reason why we want to clear the bit ?
> 
> What's the value of the event w/o PMMIR_EL1? I agree there's no

I agree that the value of the event w/o PMMIR_EL1 is pretty limited.


> fundamental issue with letting it past, but I'd rather we start
> exposing the feature when we provide all the necessary detail.

To confirm, are you suggesting to stop exposing the event even on hosts
w/o PMMIR_EL1 until KVM gets ready to support PMMIR_EL1 ?
(guests on those hosts won't get PMMIR_EL1 in any case though?)
Could you please explain why ?

Perhaps I think I would rather keep the code as it is?
(since I'm simply not sure what would be the benefits of that)

Thank you,
Reiji
