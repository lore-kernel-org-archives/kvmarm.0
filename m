Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98A8A955
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 10:02:04 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-686e0213c0bso2557248b3a.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 03:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692007324; x=1692612124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VEHQ1GcXOq53Dab+zMuzQTvtwyYcdquVeUtbNvaHWOU=;
        b=J8n1LwD7YQqqD+OMXwLUxYtQhyW8IbVjSZ6b92hvJKOpz6HTHWoZxRbb18TUNodwvZ
         J37PVrJf1TAiLPoaoGOJRI6QZkmlgB/zILlYxuyUABWsn8ZwEgGtfOoYm2KO/5vLMP/J
         oX80WVe/CaU87udWpAzqbBCUzb5cKrIOludcsxPs/SC8agwXd0oPDMzyiFuD1mmQ2oxA
         HOZzMEwPb5KMbhPOvcBDqhAXuC+Q/pqVqSDLdQhAi8orN8Rpbyz+ZwKTbmEmlw8ODcRj
         4bgSZ22GwL0QBhXitxApnZi9aU3P1CaccvhVo6bGW+w2JkYLR9drKaE0q5BXJ8SUK2rK
         r9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692007324; x=1692612124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEHQ1GcXOq53Dab+zMuzQTvtwyYcdquVeUtbNvaHWOU=;
        b=KhOBQp6QCfgkWodFcIK4E0rX1kU6Yk8KeIIcdL0V+rkyKR3UL9h65EkguhT3hy4cuq
         HMr8L54MhjeAI/B25H2rtULqpwLsbkCathDlauAfdTqYDUM0mt59SpS0SaX9f+r/VGOJ
         7C/+hQFA/xMSIzmmNuhUNQDOgs9mH6T6siE0YeTeHzv25l36RyVq8VjVsPczOROu5b5A
         RAMvi82wsCep+RHhWj7hBLAOROii2/+DfMbpiP9H0KmFf5NsOhJZFA/FqYlk38uUXAPI
         LTShRM16sqxIHZ1fVRzEnNddLft5PQh2RN8p8irtajszwc8+z5SgfKBVIGFyVOW0WRER
         3ggg==
X-Gm-Message-State: AOJu0Yxle/GFOUDfjsWYksg9LTukREC9XvhJOKb0udvgRFSpP2muKpmJ
	rg/MbEkjfSxPD6kQfmFdfBPYoQ==
X-Google-Smtp-Source: AGHT+IFtXQ+JjRdMcJ2DIlnBVrUvtOTbNWEKxiMz2Ldb8N2R3N3PRBqrFH/d1/DDuZN8TPtJOtYJ1Q==
X-Received: by 2002:a05:6a00:2e84:b0:687:1c2c:7cf7 with SMTP id fd4-20020a056a002e8400b006871c2c7cf7mr8235847pfb.19.1692007323946;
        Mon, 14 Aug 2023 03:02:03 -0700 (PDT)
Received: from leoy-huanghe.lan ([150.230.248.162])
        by smtp.gmail.com with ESMTPSA id v8-20020aa78088000000b0068790c41ca2sm7592840pff.27.2023.08.14.03.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 03:02:03 -0700 (PDT)
Date: Mon, 14 Aug 2023 18:01:54 +0800
From: Leo Yan <leo.yan@linaro.org>
To: Shijie Huang <shijie@amperemail.onmicrosoft.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pmu: Resync EL0 state on counter rotation
Message-ID: <20230814100154.GB69080@leoy-huanghe.lan>
References: <20230811180520.131727-1-maz@kernel.org>
 <20230814071627.GA3963214@leoy-huanghe>
 <5608d22d-47c3-2a03-a3d9-ba8ec51679a3@amperemail.onmicrosoft.com>
 <20230814084710.GA69080@leoy-huanghe.lan>
 <8640c3c7-b117-5754-6ac4-910988e5374f@amperemail.onmicrosoft.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8640c3c7-b117-5754-6ac4-910988e5374f@amperemail.onmicrosoft.com>

Hi Shijie,

On Mon, Aug 14, 2023 at 05:29:54PM +0800, Shijie Huang wrote:


[...]

> > Seems to me, based on Marc's patch, we need to apply below change.  In
> > below code, we don't need to change the perf core code and we can
> > resolve it as a common issue for Arm PMU drivers.
> > 
> > 
> > diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> > index 121f1a14c829..8f9673cdadec 100644
> > --- a/arch/arm64/kvm/pmu.c
> > +++ b/arch/arm64/kvm/pmu.c
> > @@ -38,14 +38,20 @@ struct kvm_pmu_events *kvm_get_pmu_events(void)
> >   void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
> >   {
> >   	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
> > +	int resync;
> >   	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
> >   		return;
> > +	resync = pmu->events_guest != set;
> 
> If we set two events in guest, the resync will set
> 
> For example:
> 
>            perf stat -e cycles:Gu, cycles:Gk
> 
> 
> If so, this is not reasonble...

You mean if set two guest events, the kvm_vcpu_pmu_resync_el0() will
be invoked twice, and the second calling is not reasonable, right?
I can accept this since I personally think this should not introduce
much performance penalty.

I understand your preference to call kvm_vcpu_pmu_resync_el0() from
perf core layer, but this is not a common issue for all PMU events and
crossing arches.  Furthermore, even perf core rotates events, it's not
necessarily mean we must restore events for guest in the case there
have no event is enabled for guest.

Thanks,
Leo
