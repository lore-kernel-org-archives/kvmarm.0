Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB367C
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 13:22:50 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-309553c5417so682543f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 06:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684502569; x=1687094569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RlMw0paf1cFnYLwJc02VyWBZPHrMJyJVDdAIIhmPwpE=;
        b=ifbctZ+naKOekbPoCfJl/TWwhdWu3SuO5GBuQWCD/ojbKvEMAcAW9ckP4qGjRvXOwR
         DGgXvZmITPzqylDJj2ver01RktPpN2fYCGo2sBBj2bpUTbYVHRnJ29AADoA/2Dj/FV4s
         3I1vK3bR30pqUsnUKcnywVOXELNNT6gAWPEXYa6+nOH6E9mEmFF4/4JCFTfuxpEmKzBq
         b/XRvbELeFufclHqty7uR1sTV5ci31bNWg4LgdpKMdbFxDsYqx26PYgrc8l+blIciIuU
         jihYK3htw6Fvz5oUHUHsepa4e00auUVZX/o45YCH0BZSDhhdgectLjYMb1Wl1SjF0yw6
         BmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684502569; x=1687094569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RlMw0paf1cFnYLwJc02VyWBZPHrMJyJVDdAIIhmPwpE=;
        b=cXw38eCO1eBy+AP/3TgWdSSqg5a4gl66FrosUzPJcICwQkOIRvkkg8Dex/7C/EdXAr
         mDQDUVzKGi+hdvybjncTftugPM6HldMO6pWemCeJ1tw3hODNdo5ZxR1OelWdSR/3/eW1
         hpkKAYrrlF4CTg68prsnTfi/mNL3C8teHtSBnW46YkItCyEMmhAkS9uJBsWpHUlEr1xp
         QEl0D2C2rNbH1T0zOdPka8VYVfBJqy5OTIo+roYMXobh76WRjDgfgls5xNukknOVUlZP
         u3P0G0ubSeVeFkqJM8FauTAw/fr4A7WqwsevhwNtxA3JIAwxFwXIjuSq1n9lfG4Tinga
         eidA==
X-Gm-Message-State: AC+VfDwd/lWz+zDaSkthpn8Q8SLYB60OKcMs6HG4sOoLnPgI+MS3mhJd
	0NsUgms/lq1Y51W0aItaJ4d6NA==
X-Google-Smtp-Source: ACHHUZ5+Audctj3y8gm6RTHI8EcbARoOXLPH+SvSqZHTe5QNUlkBpu+1ADgc/kR0BC0fyu1zEWChLg==
X-Received: by 2002:adf:eacf:0:b0:309:3da5:be89 with SMTP id o15-20020adfeacf000000b003093da5be89mr2035226wrn.71.1684502568753;
        Fri, 19 May 2023 06:22:48 -0700 (PDT)
Received: from myrica (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id t18-20020adff052000000b0030922ba6d0csm5274205wro.45.2023.05.19.06.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 06:22:48 -0700 (PDT)
Date: Fri, 19 May 2023 14:22:51 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Locking fixes
Message-ID: <20230519132251.GA2976986@myrica>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
 <86cz2wlnd6.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86cz2wlnd6.wl-maz@kernel.org>

On Fri, May 19, 2023 at 09:46:45AM +0100, Marc Zyngier wrote:
> On Thu, 18 May 2023 11:09:14 +0100,
> Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:
> > 
> > Another fun locking puzzle, between the new config_lock and srcu.
> > Patch 1 attempts to fix it, and the other patches fix simpler issues.
> 
> Thanks for that and for your excellent description of the problems.
> 
> > I got these lockdep reports while running KVM QEMU on a TCG QEMU, but it
> > can also be triggered by running the vgic_irq kselftest on TCG QEMU.
> > Now, with the fix and lockdep enabled, vgic_irq hangs but I believe it's
> > an unrelated weirdness: if I introduce a separate lockdep warning for
> > some made up locks, then the test passes again. So I'm sending this out
> > now for discussion, and will investigate that one later.
> 
> I've taken these patches for a spin, and I cannot reproduce this hang,
> though I'm running on actual HW and not QEMU. It would be really
> annoying if lockdep actively introduced issues... :-/
> 
> Any chance you could dig into this as you have a good reproducer? I'll
> try to setup a TGC environment on my end as well.

Sure, I'll investigate this. All I know so far is that it is stuck
somewhere in the first test_inject_preemption()

Thanks,
Jean
