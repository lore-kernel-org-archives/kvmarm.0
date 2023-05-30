Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A8E134C8
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 12:53:31 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1b025aaeddbso297925ad.1
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 05:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685451211; x=1688043211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6koIQhkVmhWdRRt+kcMPERrPT5zK+VP4WbBi9dIh878=;
        b=0ZbKnBQb3RTmhl/iyyBZyhicWNfEy8GN3w/IM+LC/c5+R0wcT80mJyHr+vzegZhN8M
         wSjPUB7vunHICRQ2x4sReR6XsInh2OzQZIhAuJD79P4KMrLtWmxA0+JKGKrdyNpPqjaI
         AHlg6ySj7oHxPJyf9MgUL4hqQZE5LGBJRSEDj81zSl56Fe8PFKIv3ctYaf4OVW7/uNLX
         x2TIERQDoL3aJsUsMBwa6bpjzxY4Igum6h2/S/csmbZuHbJBXooTwjUrg/jvyCp1xgPC
         vzLmWIV3drEz76/vpbIw/t9ylGk/z02+kHHhuAiqB6G64OOYXdFKzCvFo/RvfVqOjy2t
         3lIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685451211; x=1688043211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6koIQhkVmhWdRRt+kcMPERrPT5zK+VP4WbBi9dIh878=;
        b=TJhwJcLDk1Abp3NZT8zObApa8frT06TrhtSzFy99uzB26f6hCrs8QYiLybX6iOaRFm
         9ZtGYK2aoA3iBXfQY+2q9SDAJ4W2FZKcwOGD1j0FR0Et+JbAuj4hmVhQvnuMQdmceQyP
         HlUzypJRLfLyzeTu4raf5S2MUOxkaGR73XJKucSaprucPi3JekeKwufmxjpylFUdl3xH
         yEwv+8lnmOqzlOs82XbLa1mNMblC1o/PJUMDhBTi9K6s8uOGguHlwUxwqEgs5knv2GgZ
         UZsplNUzNkQfMScnYer5Roh2aqDXTt85Ati2rGIREUXVYrlGTTTePMFm2yVe1XHKiXrD
         09og==
X-Gm-Message-State: AC+VfDxC/W1Spgf6HXN7kkRUMwAMC/CPnBRzONJZOmo/zcbd2KCzzMz9
	hurbldJkXEPEOnAz5VJI9Ny1yQ==
X-Google-Smtp-Source: ACHHUZ4R6ppmrf+7RXpaMp+0mg4mZEN9CR2Y1X0Xf0Sr/bTTTPh0apsP/evrOuSgMmI5bK0+koTmzw==
X-Received: by 2002:a17:903:55:b0:1aa:ea22:8043 with SMTP id l21-20020a170903005500b001aaea228043mr113015pla.7.1685451211116;
        Tue, 30 May 2023 05:53:31 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id 2-20020a631842000000b0052c22778e64sm8634695pgy.66.2023.05.30.05.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 05:53:29 -0700 (PDT)
Date: Tue, 30 May 2023 05:53:24 -0700
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/4] KVM: arm64: PMU: Fix PMUVer handling on
 heterogeneous PMU systems
Message-ID: <20230530125324.ijrwrvoll2detpus@google.com>
References: <20230527040236.1875860-1-reijiw@google.com>
 <87zg5njlyn.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zg5njlyn.wl-maz@kernel.org>

Hi Marc,

On Mon, May 29, 2023 at 02:39:28PM +0100, Marc Zyngier wrote:
> On Sat, 27 May 2023 05:02:32 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> > 
> > This series fixes issues with PMUVer handling for a guest with
> > PMU configured on heterogeneous PMU systems.
> > Specifically, it addresses the following two issues.
> > 
> > [A] The default value of ID_AA64DFR0_EL1.PMUVer of the vCPU is set
> >     to its sanitized value.  This could be inappropriate on
> >     heterogeneous PMU systems, as arm64_ftr_bits for PMUVer is defined
> >     as FTR_EXACT with safe_val == 0 (when ID_AA64DFR0_EL1.PMUVer of all
> >     PEs on the host is not uniform, the sanitized value will be 0).
> 
> Why is this a problem? The CPUs don't implement the same version of
> the architecture, we don't get a PMU. Why should we try to do anything
> better? I really don't think we should go out or out way and make the
> code more complicated for something that doesn't really exist.

Even when the CPUs don't implement the same version of the architecture,
if one of them implement PMUv3, KVM advertises KVM_CAP_ARM_PMU_V3,
and allows userspace to configure PMU (KVM_ARM_VCPU_PMU_V3) for vCPUs.

In this case, although KVM provides PMU emulations for the guest,
the guest's ID_AA64DFR0_EL1.PMUVer will be zero.  Also,
KVM_SET_ONE_REG for ID_AA64DFR0_EL1 will never work for vCPUs
with PMU configured on such systems (since KVM also doesn't allow
userspace to set the PMUVer to 0 for the vCPUs with PMU configured).

I would think either ID_AA64DFR0_EL1.PMUVer for the guest should
indicate PMUv3, or KVM should not allow userspace to configure PMU,
in this case.

This series is a fix for the former, mainly to keep the current
behavior of KVM_CAP_ARM_PMU_V3 and KVM_ARM_VCPU_PMU_V3 on such
systems, since I wasn't sure if such systems don't really exist :)
(Also, I plan to implement a similar fix for PMCR_EL0.N on top of
those changes)

I could make a fix for the latter instead though. What do you think ?

Thank you,
Reiji

> 
> Or am I missing the problem altogether?
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
