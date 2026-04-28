Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0751A6816
	for <kvmarm@lists.linux.dev>; Tue, 28 Apr 2026 01:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777339925; cv=pass; b=NQezG2S9Dm8DQ1N4SoR7G4Z5zN0ZTwOqDtrGfNgQAWMtWfxwBVhWof1TJOm5i5e3ppgjcb+156M7sQRjB5JZx7N8ntRTLLDxNpDVgD2NmHbcV8acSuIyebWv5Amzhf4bOTfhPZ7EqCgFbHxGkvHU2MIbOo8TtN7f2GOMov5NJhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777339925; c=relaxed/simple;
	bh=Lp0NVo10PoigQtDjm/3ukLN/BhlWLdcFx2DFRGXFAn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cWhfo2oZRZ3Sa+L4j8lsobUjnQZ+vS8WehZsK+91CDZP0fah9ugmS+6+Y7eXC1YZrd6ec18NV6lXH6udLQpvanIi93zln8gQmfTge6eoNn5P2xjD5osRa8M9J4qiOR8OaX1fX/wYaQ6qMahAEHB4Jzgwgqqr+oJL900IQ7ymQ5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=SjCaQCWe; arc=pass smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="SjCaQCWe"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-362bb3260f1so5139573a91.2
        for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 18:32:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777339924; cv=none;
        d=google.com; s=arc-20240605;
        b=FKvFWLa0y08eTB7Uptl9w6lwv/uxi0AR0dmcSITxecKaQMFHV5EhHfGmYvC3kYLciI
         Bf4qhhKi8dDOAOnZzMkRy/FWSD6UfIVNHDDJ381rpcp86R8UXNwyjA8JuwXBcMAz1Pdd
         If/vt0tg//OxUgewMFVghpG5bZoBsvWJAc5h4Q9Qep7sWIW72yb9lHfS0PDnlllau7CT
         BWhTPu7+XqGXFYzGrEt5YSWCEyiuWkkxdRIjuj0+ySpS3gGk7zBiQfwmzAMDlCnvmmd+
         YnmmQszEake7quKodp0quhwIc88NDGfqI4E4+7rZ8lhVtLSIgEvJgJ5VpVrc4t5rxW3q
         8ajQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dkNNLielDoU+waGJTxz6K7Cs44v4hc05yCRBP0rYkY4=;
        fh=9xcyLyFOxUhxhESwquqK4YjqtFyenfBIfxV9PpXGnaQ=;
        b=doFq2liS9CY5ClrBmXz53JSPytxcZTB1fZbZeaOusH1qc8gBEMzd6t3s43+kIHBA/k
         ocidgMlRyRzZ4xJdWe6ejdneQqno1AByOOFW24SoYLTbKkLiujuE01hoxPZdc6EXK+2s
         pnlZ/OyOJhXG8dxKAJSiUoncuag5NUASNhgset+z0IDJG74HVo3mU4q8ihdPiTuF7OZv
         u3LFAdFkqEFgkQ4EfQVIt54mU4J9Zi3FVcmAb74ZWWgQkdSujQn4SBBdM+LvSK9j/jbG
         YclHu1NILcKgFRPPfYxGeng8W34wrjfvFLKHY3hg5M46APwzoF2oiO4NunhJAJOvxMww
         Nt1w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1777339924; x=1777944724; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkNNLielDoU+waGJTxz6K7Cs44v4hc05yCRBP0rYkY4=;
        b=SjCaQCWeCnn+6/RYH+E+UFgYuQh08x6Os2vyrKd3esJpiS5AbGDlLe12OPblZRnTMo
         iOu4pvEow+C2g7d/A5kIIs12Q5pHUJ+LD62HNp0Q9CgMJtz3d3K+24EaiduDyH7HVIFU
         L0tpBYC/AF4rQ9pne8mMzQ5kcZuBdRLSa4BfMPjvYS2mbFA5Y6pkmX/JqWci561uGETb
         rRksZ5GsMKN2p/qoawvf1Pzp6lwGHZyZI6YEZo399d7KseDCair41aU8F0wNhwjlfIIY
         Na1t7e3Ki+XpQTKu95hicRi+38+x6li9I5tcQ6ukpKwNckfPER2ztmHEnl3BH5Uqgyyy
         +STQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777339924; x=1777944724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dkNNLielDoU+waGJTxz6K7Cs44v4hc05yCRBP0rYkY4=;
        b=d0asS457nmZNN26M1pzXBfP8BEdP5P6vbXjLPp9Od0DS/6TNIcRJihsMxMv2ONjLlP
         2DUDhcLa/cNakE4llWFFP4eICPdAvpjA7geMKtFngVG6TzATQAO3EjtvbXwZY5QGf/Dv
         4a66YqGznz1JkpZx5ikqFJq2imASFghxtpMVr/b9quk0JnDOLBgw7gQ28yXGcNQcXlS/
         JX6S7wifO0Rv825hOi4q/s0TrQWNCrqQQHZRcTG6Af9jcOfLV4jU5qXvwnn5xaofeoDE
         9lwc31jLbANJEkP/hpOsvqQSUBUTf8nL15/PjRVjBqc9wD0bx19E2Wi9HecPYLms4I9v
         ubBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+iJDzO7SPR9dbaap43Kfx87kM3wGWc42UVpyt+vgjjMk58I8CLYB4IyQNJngXEAHBWcAVQR6c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVI5Yr3UMyHifQYjszT/yLMi3LZwN0Mnv2ttFbidNxlJkm26hY
	EdTDR8ykf2P7K1E30Ayl1CsrDXBPsaNf3qDNWFNKnFO+vEnXDRFB09T8817Cd5qdtmwcjFBzFr0
	oqevt6FM1veSkJNY6Yslkgd42OO+5V5Pf7nkKehJD
X-Gm-Gg: AeBDietQy4WCvTTfNh/HHMzyR6ma3HZPtLQEp/YInm2fyIFEhy5m1HETuRyRZZDzgOX
	hAqKztlMtnpqnhaG5U+OA6ouhEV5f0lV1CBpHpqgyMYkbR/6Wy4YxTkFyMzILqxYtfoio5x/870
	6mZFZtcWh8Z2WQzm7BQgllgDxNFp5S8wtyw6MJScoUmxPFjA09+796wR0iVPugNq7qA6uXgmbln
	UzJ0s85Rh22ChCSsQqz8JYmdMRouG9fLcSIGCllqknnfNINDIMzxhZf0xGlXmknfJbBbNWohSuJ
	eistMoxaWGbUjLb+Nw==
X-Received: by 2002:a17:90b:52cc:b0:35f:b714:e516 with SMTP id
 98e67ed59e1d1-3649202f6b2mr1031930a91.16.1777339924049; Mon, 27 Apr 2026
 18:32:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <bd908e28298d968740d03c97bc7e441de188b7b4.camel@linux.ibm.com>
 <aeokwrC86WI7uT+K@e129823.arm.com> <aeomlp3I0eVE5mce@earth.li>
 <aeotq8nPVu4wvEx5@e129823.arm.com> <e4e242ae5533d5762a3647186a178764881bf9ff.camel@linux.ibm.com>
 <aephL3MzYoqFGaT5@e129823.arm.com> <CAHC9VhRQWHEWQ5NzOPiu8jtYv6UsRm8WVS4fd74AbkOcAd4y_g@mail.gmail.com>
 <aesGU8a3mbVzvteH@e129823.arm.com> <CAHC9VhSaT_quKYnpFjAfqvL07JNbWMgM6c4pB9F46NHawX3DCA@mail.gmail.com>
 <014cf39aa8d6a0bcfa1a95c069675977ac67b843.camel@linux.ibm.com> <aexIwJpno3iPIdRD@e129823.arm.com>
In-Reply-To: <aexIwJpno3iPIdRD@e129823.arm.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 27 Apr 2026 21:31:51 -0400
X-Gm-Features: AVHnY4JvmD_vpNd2uBimzy27N58OmiHGYAhJK_BGt8LuvH5xnPjA0AMhCSfE4Tk
Message-ID: <CAHC9VhRT1v3mM9CFvz7Dh5Zrv_MF3vgBk+BZ=q8wOMkPB6O6Fw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] security: ima: call ima_init() again at
 late_initcall_sync for defered TPM
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, roberto.sassu@huawei.com, 
	Jonathan McDowell <noodles@earth.li>, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	jmorris@namei.org, serge@hallyn.com, dmitry.kasatkin@gmail.com, 
	eric.snowberg@oracle.com, jarkko@kernel.org, jgg@ziepe.ca, 
	sudeep.holla@kernel.org, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, noodles@meta.com, 
	sebastianene@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 25, 2026 at 12:53=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> =
wrote:
> > > I understand the need to ensure that the TPM is available, but if it
> > > isn't safe to wait to initialize IMA at late_initcall_sync() then it
> > > would seem like this is a bad option and we need another mechanism to
> > > synchronize IMA with TPM devices.  If it is safe to initalize IMA in
> > > late_initcall_sync(), just do that and be done with it.
> >
> > Within the same initcall level there is no way of ordering the initiali=
zation.
> > Yeorum attempted to address the ordering issue in commit 0e0546eabcd6
> > ("firmware: arm_ffa: Change initcall level of ffa_init() to rootfs_init=
call"),
> > which is being reverted in this patch set.
> >
> > Ordering within an initcall level needs to be fixed, but for now retryi=
ng at
> > late_initcall_sync works for some, hopefully most, cases.
>
> Ordering within an initcall level is not good idea.

Agreed.  That's why we have the different initcall levels.

--=20
paul-moore.com
