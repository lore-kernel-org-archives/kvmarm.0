Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D867F
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 13:45:27 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bf6ea270b2so15660265ad.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 06:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692711926; x=1693316726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2pdIJkwJb26+2W2iCXEOozbm0Klva0FzdGK7hVu8EGo=;
        b=QC+dl4RBMWFG+Vyg2wPTTMfqUXTo6EkdhfppCFSDR68s/OvCmsi5JCs8khGim0sZf2
         4dZCiZEtW8FMDzuiRSXtrOL72pqZZxRYVFqeuYP1FX1Ed/J6M1/3+nKlSk949JRkna9F
         QXn/EuuQh5WtCkLuMFejtNJ7MRBFGg5i4tlHWBBtyuXhH8UefNbP//gx+H18OAMZRu+8
         iINFffcfMOnh52lbWYeDN28QJIBzUX6uwJ6MIRCLVOAw87F8veXL6Try5aXKJPUg/eg/
         DF4kAWjRFmJxoxS3tGPK1omR+96pR4yUKCgm1QBRb/QI5GwFMr9MCtfki1253diiSKea
         DInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692711926; x=1693316726;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pdIJkwJb26+2W2iCXEOozbm0Klva0FzdGK7hVu8EGo=;
        b=kfGA4OAMCFPCNbLOgmQnlY7mPZNKel4FeUmVl+j+5JfKrNj1g3lA57OS7TL+HvCs6Q
         Ii2PaijSBSEY550ejH0hg/wr3QzfCt6Q44MctirZYj9erpA9/eS2b5MQQZfp1elxaQLv
         wrNjvDNz2B56nuaKOuuMiGDG3vKm+PBNQRiLLwSeCaVH0nAj0eno0iEBEowfIGkyw/Tw
         ZkHhLzXmwl0AbX6IP5ZblssZm/N4BhAn6YlaGdjXF4ofKRA1azFtIkkXozLuHSucutp1
         KvhzucPE7RpfooFJT4gC/1U8XelT3iZ8fDM2GXd/NO+5OR9zdScbktU5TVBtxlGlpu/z
         d1wQ==
X-Gm-Message-State: AOJu0YzAEJFQ+46crZtR4ccNhohqLdR+zmZSsNwnTmNDqGjVGTVcnKs1
	oFrhRvcSY7SpYnBkpMohPC7HdFCPKxALCNxAliWgcJfI
X-Google-Smtp-Source: AGHT+IFNBAV4UqQj2/1i97hcCATnDPDrNLOLjdzcBiWaKzJmpiND5FXxF0VqsUjRbZsA2vCThmXkgA==
X-Received: by 2002:a17:902:820d:b0:1bb:ee1b:3cdf with SMTP id x13-20020a170902820d00b001bbee1b3cdfmr6327318pln.67.1692711926394;
        Tue, 22 Aug 2023 06:45:26 -0700 (PDT)
Received: from leoy-huanghe.lan ([94.177.131.100])
        by smtp.gmail.com with ESMTPSA id v7-20020a170902b7c700b001c0a3df39a9sm19154plz.205.2023.08.22.06.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 06:45:25 -0700 (PDT)
Date: Tue, 22 Aug 2023 21:45:16 +0800
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
Message-ID: <20230822134516.GC57731@leoy-huanghe.lan>
References: <20230820090108.177817-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230820090108.177817-1-maz@kernel.org>

Hi,

On Sun, Aug 20, 2023 at 10:01:08AM +0100, Marc Zyngier wrote:
> Huang Shijie reports that, when profiling a guest from the host
> with a number of events that exceeds the number of available
> counters, the reported counts are wildly inaccurate. Without
> the counter oversubscription, the reported counts are correct.
> 
> Their investigation indicates that upon counter rotation (which
> takes place on the back of a timer interrupt), we fail to
> re-apply the guest EL0 enabling, leading to the counting of host
> events instead of guest events.
> 
> In order to solve this, add yet another hook between the host PMU
> driver and KVM, re-applying the guest EL0 configuration if the
> right conditions apply (the host is VHE, we are in interrupt
> context, and we interrupted a running vcpu). This triggers a new
> vcpu request which will apply the correct configuration on guest
> reentry.
> 
> With this, we have the correct counts, even when the counters are
> oversubscribed.

I gave a test for this patch, It works well.

However, I do see this patch can introduce huge amount invoking
kvm_vcpu_pmu_restore_guest() when using 'perf record' command.

As I mentioned in the patch v2, we can call kvm_vcpu_pmu_resync_el0()
in the function kvm_set_pmu_events() rather than in armv8pmu_start().
With this change, the kernel only syncs PMU context when the host and
the guest have different traceing for EL0.  Just paste the suggested
code for reference:

@@ -46,6 +48,8 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
                pmu->events_host |= set;
        if (!attr->exclude_guest)
                pmu->events_guest |= set;
+
+       kvm_vcpu_pmu_resync_el0();
 }

Below is the comparison result for counting resync, the result is for
counting how many times kvm_vcpu_pmu_restore_guest() is called for
'perf stat' and 'perf record' commands.

                  |  perf stat(*)    |  perf record(**)
 -----------------+------------------+-----------------
 Patch v3:        |  2506            |  47325
 Proposed change: |  2514            |  2504

(*): sudo ./perf stat -a -e cycles:G,cycles:H -d -d -d sleep 10
(**): sudo ./perf record -a -e cycles:G,cycles:H -d -d -d sleep 10

Thanks,
Leo
