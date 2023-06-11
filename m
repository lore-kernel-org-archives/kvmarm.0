Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D5615CA
	for <kvmarm@lists.linux.dev>; Sun, 11 Jun 2023 05:03:34 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1b3b9413baaso28395ad.1
        for <kvmarm@lists.linux.dev>; Sat, 10 Jun 2023 22:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686459814; x=1689051814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qi24DtFAZsmrHNEajEMdxjivstNNvDufpgTl6tgbS4Q=;
        b=vDdGiQM9kknKiSTNdri3wDlj3hkc5o2RYQEvLzGZN/lzVybEkCVqMcaTiQIPXoUCPv
         BdnPZWCOXtY1RYRiY4pKHIF75foWlXuELw6wZDQMK0qgFJTWHDQO/NepoMI9MeUW7AhP
         H5/14D1DQfmyF3kLUdh3plDwF5y4RjjUF82ptcZtIjNMyHGsjeJEPlz+XlHYCllAyPLq
         173Ym0P+uC8jJHa96C24lzTEf7bYMvmX8j9PIDkltIF027u7XETReqia4Z2+HPpH6RXb
         knPUm1pnVo4K6C35XJW7d9cWqmxouSTr4vZ3ZhUVKuA96o68ueM6Lcpx4FGSJwpy8+5N
         2VRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686459814; x=1689051814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qi24DtFAZsmrHNEajEMdxjivstNNvDufpgTl6tgbS4Q=;
        b=Nk3YLtiDOsbGnMAEfNTwkGpQsW4E1eEuVdl+SQyCRTafUa3hs/WYGFpUrmphMEg1oN
         x8l5HFSE5UuUx/ED8DBNy/cxONeRyAQj/ieDIF2eWsiy83zWnCCTWPV0HhCyFotxVTPp
         kYzu97sc4zz7qlg7qaIrl4/pfMpI5q2OZXAYTmM0m2BDIiv2XMrCE8g9CvPxl+OZN/PG
         mt8TBfyyuwm536T1ofpRzBeOQ9Y1j1f3Xmi28ZqhouhslQwE2xyzrBZaMD/YMzW09ArI
         gXoKIsrGprQRtex9xNzIVy/aF3HTl99ofsECDIjKtI+2jsMtyt23XlQEt1vBOlEWe61u
         nHNw==
X-Gm-Message-State: AC+VfDzIW/lRMEX943a+3koa5hWHled/w20El8jcCEEBA4ObztuD645V
	WJ47nRrBuC7eHLKoOsK4MNRQKK0+bdOdJihWod6/Zw==
X-Google-Smtp-Source: ACHHUZ7m5wKCwbG46Igxsl4l4bkC+p8WBdNwdgSwmJpMXakjdWkTqdovzDL6QSXuqmxFwa4srv1CGw==
X-Received: by 2002:a17:902:e74e:b0:1b0:2670:7d49 with SMTP id p14-20020a170902e74e00b001b026707d49mr120852plf.16.1686459814091;
        Sat, 10 Jun 2023 22:03:34 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id u1-20020aa78381000000b0064f7c56d8b7sm4764643pfm.219.2023.06.10.22.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 22:03:33 -0700 (PDT)
Date: Sat, 10 Jun 2023 22:03:28 -0700
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
Subject: Re: [PATCH 2/2] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
 systems
Message-ID: <20230611050328.jr65a56n4mmb6xk7@google.com>
References: <20230610061520.3026530-1-reijiw@google.com>
 <20230610061520.3026530-3-reijiw@google.com>
 <ZIUx5c//d4txXbUB@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUx5c//d4txXbUB@linux.dev>

Hi Oliver,

On Sat, Jun 10, 2023 at 07:32:42PM -0700, Oliver Upton wrote:
> On Fri, Jun 09, 2023 at 11:15:20PM -0700, Reiji Watanabe wrote:
> > Disallow userspace from configuring vPMU for guests on systems
> > where the PMUVer is not uniform across all PEs.
> > KVM has not been advertising PMUv3 to the guests with vPMU on
> > such systems anyway, and such systems would be extremely
> > uncommon and unlikely to even use KVM.
> 
> Ok... Now your changes are starting to make sense. This patch is rather
> relevant context for interpreting the other PMU fix [*], so I'd
> recommend you send this as a combined series going forward.

Sure, I will include the patch [*] in this series.

> 
> [*]  https://lore.kernel.org/kvmarm/20230610194510.4146549-1-reijiw@google.com/
> 
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index eef17de966da..af1fe2b53fbb 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -105,6 +105,14 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >  
> > +static inline void kvm_arm_set_support_pmu_v3(void)
> > +{
> > +	u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
> > +
> > +	if (pmu_v3_is_supported(pmuver))
> > +		static_branch_enable(&kvm_arm_pmu_available);
> > +}
> > +
> >  #else
> >  struct kvm_pmu {
> >  };
> > @@ -114,6 +122,8 @@ static inline bool kvm_arm_support_pmu_v3(void)
> >  	return false;
> >  }
> >  
> > +static inline void kvm_arm_set_support_pmu_v3(void) {};
> > +
> 
> nit: Give this thing a more generic name (e.g. kvm_pmu_init()) in case
> we wind up needing more boot-time PMU initialization.

Sure, thank you for the suggestion!

Thank you,
Reiji
