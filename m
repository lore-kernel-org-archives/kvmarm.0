Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B0860844
	for <kvmarm@lists.linux.dev>; Wed, 24 May 2023 12:40:42 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3063433fa66so535102f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 24 May 2023 05:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684932041; x=1687524041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bNqHVjiAPgcoX4AAtv5Chj9IfcChBtd2gbcHB24g+D4=;
        b=HnXXezDYG17WebHzWaeBvSzjE6X5zZ93pBJRnP1uus8Z47y5c4ecwWgXRFimW2mvIm
         Rbi4sRvb6Gq0HpItiOOaOkKxnGok7GAvz4VlWya9wKiv+yJsCvetAhkaLCRaW6MpipQc
         duoL79rzF23C90aeofuyMUj0FrHjYIGyeSljHuUgxwJ4tg/FQ9jG0J8mu5Ql7GIWTx4N
         dH2jyl9J7Aceg6afbTsYDhVnpebnDqi9N/XCkkOUCMahiE7msN0rA0vaGHYfl1VDy06X
         Q2hR90Q6znvXMQtcNjnqmog2rfKhFFkuvXP2C+kjDIU/Mhp4Y0IYizjD1JpNgS73M/I5
         knrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684932041; x=1687524041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNqHVjiAPgcoX4AAtv5Chj9IfcChBtd2gbcHB24g+D4=;
        b=E5c/V4ry5I7VnvL2Dn3v+HuyEq+NrhBwwSZ6TB1bKjiuDpmMeEoTbT+0E4xcnAQArC
         SVJ/gPufhgwVjRbJa1elGQAWIEW0VeVhml5TiRaVyXyHQfRpl3svePO/tjA6rY9GAdQP
         1WqTeKmgdHy0TCz3adbBUNi41k9Fw9HuniN05sG1u6J9t94PUHoNHe6j1pYmtXhu36Jk
         bsR9yuHnkXkXGMLd0IZrsD96tQ/8iJnQqwTgMaQu6X1gL95sFjieB/t8+uEF9bQ7yp9/
         xDL6Pl8JNmlxLKSzMhTKEX11olnZ2Wf8MLYX+kD9ubIMXHY5SxBd2lq78oIkV4EpJxTR
         z8ug==
X-Gm-Message-State: AC+VfDyrMLZZzFFxKBNGJvmP4SjytOOdPr6Kpr6pdnA/hZmzC7TMEXY8
	0o9Am70k8cDlfBjLmIPWDMwWfA==
X-Google-Smtp-Source: ACHHUZ7nIrqPldKdUyRyL1Ju/ax0rCU5vJ28/C0/Xl8RckP1R2RBfphk946YNTbndFjLzoFRPtUylg==
X-Received: by 2002:adf:f342:0:b0:306:30ea:a072 with SMTP id e2-20020adff342000000b0030630eaa072mr11215655wrp.53.1684932040673;
        Wed, 24 May 2023 05:40:40 -0700 (PDT)
Received: from myrica (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id l3-20020a1ced03000000b003f4ddde398csm2303897wmh.21.2023.05.24.05.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 05:40:39 -0700 (PDT)
Date: Wed, 24 May 2023 13:40:42 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Locking fixes
Message-ID: <20230524124042.GA48723@myrica>
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

I'm not sure this is a fixable problem, didn't find anything obviously
wrong. It's just that when running with lockdep and KASAN (forgot about
that one, sorry) on an emulated platform, some tests can't make progress.
In this config I can boot a guest without problem, but this particular
test gets stuck when trying to inject 32 interrupts. What I see is:

1. KVM prepares to enter the guest, spends a lot of time dealing with the
   vGIC with interrupts disabled.
2. Just before entering the guest it sees ISR_EL1 set (the timer interrupt
   is pending), so cancels the return to guest, reprograms the timer and
   goto 1.

For this particular test, trying to inject several interrupts
simultaneously, I think kvm_vgic_flush_hwstate() needs to take and release
lots of locks which takes forever with lockdep. I measure about 4ms inside
that function, which corresponds to the timer period at HZ_250.

Previously, I guess getting a lockdep warning would disable lockdep and
allow the test to make progress. 

So maybe the vGIC could still be optimized, or maybe this isn't worth
fixing, we could just say that this setup is too slow to reliably run KVM
and leave it at that.

Thanks,
Jean
