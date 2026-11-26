Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795723281;
	b=Y86fBzu8KR3WMts17/KnW7EJWMoAVbqhyyVd4AQ67+mr0L8VPHXUKLG0pM84AGwz+Smp
	 HU3hr8HaEg2yovpYx47JOhXmwuOraBZWXG/3noYw7LHC0UXQMZNOuyyl3qM/qgFA2WxqV
	 uj8J5BnPyEb3JUK1fT4DHDjISpmJ652I7k/KNvMvX2iune8s+R5nnJBcXuWAJ3Jj526wD
	 XNHW72Iqvzgq0ntR/Wq8joWQidNy8jDox4VpvDLXyyb5HtAQ23GMEcYa4qsurHrfHVRsj
	 HF956FfT18fdj9xTiB1fntSkY8gB5IXn3vjQ2Dd95NPKMjVoT1kf5AKrx2/qXRnjA1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795723281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=RzcN8ipRXfPFoZcXCVEK2wVxpyT4qgwWkbcZIigmQvU=;
	b=gjrG2J93pF21GRW6oskmswOzmVQW2zy7V6hWCiikwM2ViuJYe0mwza/K+/1zZq23bKoa
	 R9nT9oYOA55MFAT3uAixTChQ9ZWtaAyHxakn11BzDhIzpitd7bfAmxQqS7d53Jy+8Ophd
	 lHzoD2Mpr1ZJPvCZtIpIojZ7N+i30wjFUUUPYiQhrHadbMsgI++VxUoZiM9KMbWHeQTqm
	 wEPYi15lxHIKGWz38Tb3potv7379OA9/e6U5o7T9dLf4zZBB1CyNeV7DUrNtFOWvsAOXI
	 nECM0pmz3EDGyDYWm+bzaUSPvknor/HDl42fQVwkLsegBauHThpHVsec66zUW/nHpCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UzkdZoRf;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A6606A31C
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 20:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 125A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UzkdZoRf
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so60323635e9.3
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 12:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795723279; x=1796328079; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RzcN8ipRXfPFoZcXCVEK2wVxpyT4qgwWkbcZIigmQvU=;
        b=UzkdZoRf0jkXRRpXRmN4ttdcN8tXBhI5YVqWa/RBLjiT0FrmHzzykGsjZLkbxX7LM2
         tqri5DJM7d+eNwfuotM0NT2MQvmTi1oUdy+u39S61udmcj1wVCfPz9OCJcaEJAymJF3l
         dyabwUlfMXapwRopIRxaIAwl1A21ZL9W+5zwV+lY6/xWUtrRIRv5xnLH2OX1vP/6JNmA
         t51tQjuTaD8UvyUuE4pbV3WOvr1oaF0w2a4FI1yWwbrWNnEVWMC3pyd/wtnJELn5abxE
         LldREpCqJmgShjPZKa+ebxi263CLan8ZUxtb8BMyrDDBzydFiGe5VIyU4rZSk0KPHWZ+
         0JMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795723279; x=1796328079;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RzcN8ipRXfPFoZcXCVEK2wVxpyT4qgwWkbcZIigmQvU=;
        b=LTGvI4HNxycXhhOCHgcTsAwfTgTHtbnwe06KauQeRmpA4cXa7cueLNTiInC5nU94a/
         K7tBYPrU6Vpo7nh2K/Vf+o37xJBZc7el1Bw3nOUOREHwXWOa+9oW9kc56gNraV6Byzdb
         yRFCq3AXNcPvp8+kP68SlbzvNHt4/PEMyAPG3Qw2zcCS7VgjYJCK5FydAFiBhE230vIc
         95i1pivY5ti2a5UfXEwdTV+30XJY7gbS59uv7HszeXGntWFyBMiK6wWvBpt6xdvSmLqd
         +qAHgz/BfbFSlLSYGJObizJvVOMuYmlN5I5H6h41zUBM0aj6pzV4stT5mohr2/VZw+16
         OPQw==
X-Forwarded-Encrypted: i=1; AL+hErGfAYXxxEo/GE7ByC9I3HQNdelWFvNAVsZYX5PwWRshwFMYaynEuqjUTv7kgEYGG7fUHXzXrJ4=@lists.linux.dev
X-Gm-Message-State: APuU4Z/J7dPEkw2PdSP/VDtXq7PWJBVRQJjiek8HzcPi7SDQ/19+DZ5N
	Bx/26PzVTKuGxLUbVd1tY8SrtpCp/A/xHM5HGhEriIqNOJxG4IV2ENu4DCLK3FcnN3nYY2b38EG
	0ezQalg==
X-Gm-Gg: AZFdTZePUxIHIKK/PK9ihZsgMijvwW6qtF4AlT2kSTnCigCN5uG45v2QSqLR9QuSyAY
	z0SzDEVvAppldO3e6TabJRjs8cdasHEQA2lW3hZDjSDD8KhLTErQSP1vj3IZpKCZrXoTSxL7xkb
	BOAkPfkki2KEBwQ38kUxu2QS5ehLJGUbBhY2/G3GEAYoUqeCRMIq+Gjz3qSdF3bWfxJSs053Fmd
	uuKkiPYqhAFyJDibsE7GAuAJBu221hA6mlDfuQ/TzPPD3pnPokyZQhf4g9hLN5YNTxe6BW5NN3e
	yj2cQ+OV/9uyypKz5fih9+cme9KiTH2wGVgzgaAkRaDUFnzvEq+XOif6dbHH7G+8nwvt8/ZEOAf
	nWtVPzKHyEXXXGDMLbEtMpEDu3abloGKZb0cDsj+T6KyrUmObjUSvg2ZbxeNiTEEW7IwtbOP11F
	25o9Zgxiu349vH3iI0K99ovJ30+6Tfk6EmvkWMUUL8dN28rU1Ay3kxJQQyjjlJaRDvrftaavYyc
	SF8rGQricPX1/7X40Tg/Hswdum4EpPLezlB8AnluxgFF5WjsT1elj3tBQBUuqrW0T8xug1A1HXG
	sUfsbFNYfbsUn869icH7e+4KhclXolBxM3jbX9NFTXhP90N5m4zxuVUI0SwqPwdXVVTGD0nBVd4
	RBpHlwVVSCjRDGARlckUEFVs=
X-Received: by 2002:a05:600c:4ec9:b0:4bb:6a5a:782d with SMTP id 5b1f17b1804b1-4bb88925fcdmr459719625e9.17.1795723278915;
        Thu, 26 Nov 2026 12:01:18 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8533579csm543682885e9.2.2026.11.26.12.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:01:18 -0800 (PST)
Date: Thu, 26 Nov 2026 20:01:15 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com, weilin.chang@arm.com
Subject: Re: [PATCH v4 15/23] KVM: arm64: Add a range to pKVM ownership
 selftest
Message-ID: <awiQC1Mhw9Y_gwhK@google.com>
References: <20261117174403.58762-1-vdonnefort@google.com>
 <20261117174403.58762-16-vdonnefort@google.com>
 <CA+EHjTyzbeZ34bp-TnvVibHubgwZFuFbLZCRRSF-kbM1wXb=Wg@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyzbeZ34bp-TnvVibHubgwZFuFbLZCRRSF-kbM1wXb=Wg@mail.gmail.com>

On Mon, Nov 23, 2026 at 07:56:49PM +0000, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Tue, 17 Nov 2026 17:43:54 +0000, Vincent Donnefort
> <vdonnefort@google.com> wrote:
> [...]
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 4c80e0960154..ae53c701206a 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> [...]
> >  static void __init pkvm_ownership_selftest(void)
> >  {
> >          unsigned long pgtable_order = 5;
> >          unsigned long pgtable = 0;
> > -        unsigned long page = 0;
> > -        long ret = -ENOMEM;
> >
> >          /* Memory for the VM page-table */
> >          pgtable = __get_free_pages(GFP_KERNEL, pgtable_order);
> >          if (!pgtable)
> > -                goto out;
> > +                return;
> [...]
> > +        __pkvm_ownership_selftest(0, pgtable, pgtable_order);
> > +        __pkvm_ownership_selftest(PMD_ORDER, pgtable, pgtable_order);
> 
> Could you skip the block case with a message when its allocation
> fails? With 64K pages it's a 512MB contiguous allocation, and the
> selftest prints a failure when it can't get one.
> 
> Cheers,
> /fuad

That's a good point. I'll also GFP_NOWARN.

-- 
Vincent
