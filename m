Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4907F
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 13:49:20 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5654051b27fso2896775a12.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 06:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692712160; x=1693316960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5h7+qUO0omnn5FGFlX6GxD/r2siYs9YlF+eLfFrmYU=;
        b=e6GkpzOu/lNcFEoI+f/yDK1Y7h/zRWksZa3DoLx9g9/wbXT/BcLwC6Qb5RBkiKH0j1
         X5RRCK5nU8DCd8LXr9lFIFNakvfdwhgBvHaQasKYBMyGLnTmTLM7+qBoeUjP+OgcH8Qe
         tFTMCmFEeSXnxi/LzI279HMGu7gViPXFMx00DsmMS+zwXihGtbZF5afZMwraesDqVWs0
         fPjTxue7MEb/Hkgg87O+gI9Qt7vr6a0zySkyaHDzWY/K6tEJWzvkmNca/Tq0AY0AJzW0
         T59nMvtFs8K9cZr2J+lpFPS1aMQ4pZ6/zlhzSASiOTrBgtdp7CWcyowkzyu4eQid6OCz
         GzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692712160; x=1693316960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5h7+qUO0omnn5FGFlX6GxD/r2siYs9YlF+eLfFrmYU=;
        b=Wo58ZYCXbXIWngZju8ptJzhq+oxYLBQ/tpInLcx+RNRYuBiJjVDfXmMfnlH1vUKPo4
         ScnkmM6Orp/XbEI2ns6MvLIjrUe16E0IGfxLVcvNdBALjh0D3C4bwRBOiSBzZxEtwfgW
         Skzt8AlxlQ8BMgYuZC688Fjf6IeUPWHWM+nOBhqq8RYrJElcOj7cj3rP3YQ9Yff4k8ym
         YQ75yicN9oqLDxO8eNhcvBz0rSU2I9ay7qr+Kq+r6TuZ+SBndA9gUHyeS2l5tMKkLcWB
         kygvwwF+TBJwKImOzHtbSnu/6vijcCXlEWlAo30HAGkEJeVnJdB9pomMPHylSK3f/mx8
         52Aw==
X-Gm-Message-State: AOJu0YwJ8aD0V1KmeqTlZdUl47E4B78aCHLwucfetuDDdTEG7E3oorg5
	KyBlWDw34a86++GKydzkOx9c+Q==
X-Google-Smtp-Source: AGHT+IEBMrd+myE8dEIe+4eFc+Nie0XvCrz3oRIZL8U+J8LpndkUKhfUH50RweUtGX6Acl/RLdowVQ==
X-Received: by 2002:a05:6a20:429f:b0:140:fd3b:5d4c with SMTP id o31-20020a056a20429f00b00140fd3b5d4cmr12537889pzj.38.1692712159880;
        Tue, 22 Aug 2023 06:49:19 -0700 (PDT)
Received: from leoy-huanghe.lan ([94.177.131.100])
        by smtp.gmail.com with ESMTPSA id d190-20020a6336c7000000b00563da87a52dsm2116862pga.40.2023.08.22.06.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 06:49:19 -0700 (PDT)
Date: Tue, 22 Aug 2023 21:49:12 +0800
From: Leo Yan <leo.yan@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: pmu: Resync EL0 state on counter rotation
Message-ID: <20230822134912.GD57731@leoy-huanghe.lan>
References: <20230820090108.177817-1-maz@kernel.org>
 <20230822134516.GC57731@leoy-huanghe.lan>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822134516.GC57731@leoy-huanghe.lan>

On Tue, Aug 22, 2023 at 09:45:16PM +0800, Leo Yan wrote:
> Hi,
> 
> On Sun, Aug 20, 2023 at 10:01:08AM +0100, Marc Zyngier wrote:
> > Huang Shijie reports that, when profiling a guest from the host
> > with a number of events that exceeds the number of available
> > counters, the reported counts are wildly inaccurate. Without
> > the counter oversubscription, the reported counts are correct.
> > 
> > Their investigation indicates that upon counter rotation (which
> > takes place on the back of a timer interrupt), we fail to
> > re-apply the guest EL0 enabling, leading to the counting of host
> > events instead of guest events.
> > 
> > In order to solve this, add yet another hook between the host PMU
> > driver and KVM, re-applying the guest EL0 configuration if the
> > right conditions apply (the host is VHE, we are in interrupt
> > context, and we interrupted a running vcpu). This triggers a new
> > vcpu request which will apply the correct configuration on guest
> > reentry.
> > 
> > With this, we have the correct counts, even when the counters are
> > oversubscribed.
> 
> I gave a test for this patch, It works well.
> 
> However, I do see this patch can introduce huge amount invoking
> kvm_vcpu_pmu_restore_guest() when using 'perf record' command.
> 
> As I mentioned in the patch v2, we can call kvm_vcpu_pmu_resync_el0()
> in the function kvm_set_pmu_events() rather than in armv8pmu_start().
> With this change, the kernel only syncs PMU context when the host and
> the guest have different traceing for EL0.  Just paste the suggested
> code for reference:
> 
> @@ -46,6 +48,8 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
>                 pmu->events_host |= set;
>         if (!attr->exclude_guest)
>                 pmu->events_guest |= set;
> +
> +       kvm_vcpu_pmu_resync_el0();
>  }
> 
> Below is the comparison result for counting resync, the result is for
> counting how many times kvm_vcpu_pmu_restore_guest() is called for
> 'perf stat' and 'perf record' commands.
> 
>                   |  perf stat(*)    |  perf record(**)
>  -----------------+------------------+-----------------
>  Patch v3:        |  2506            |  47325

Here should be "Patch v2", sorry for typo.

>  Proposed change: |  2514            |  2504
> 
> (*): sudo ./perf stat -a -e cycles:G,cycles:H -d -d -d sleep 10
> (**): sudo ./perf record -a -e cycles:G,cycles:H -d -d -d sleep 10
> 
> Thanks,
> Leo
