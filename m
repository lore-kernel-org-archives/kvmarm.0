Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792742376;
	b=gqHN7jgd5GvGy0Hl3Rl2EgujjQWqu/GwqaW+dA05vnJq7QBGh9z1fR0A5usxOnw9m2I9
	 9Y0qsyna8HglQl7NGV8KhvgO0TcQT+QF9J6Yex9lo604QF1eShMP+XBFDxGziWZdmekPN
	 s0JXaAt1zDQlAw5ptQ7bwmgO0lJQ3eAsbLdG/d/XbcwtdoIUXDeVlvFjDQ2G/fmIlOKjO
	 o1JJZ6tmw6eepNIw0g4oIvp+zKpGqkJiOeArL3g9iOv4h6PLPzfbK1Lb+8IIAZJ8Qxzh1
	 EF6822pIrdii6PETyGbnqV98cmx+6RZjWeUOmSbclgFb7I398IEyAmA4+TZNaj4yBwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792742376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=5jkvtV8P/+s5qJ2kbqgOKMQCk58hvpuAEYMAliw2L+E=;
	b=gQz4Xf4mZRnX6GH2rKdJWL2Fz0/rCV5xx8brXRR3Y5vIt8VwUwWU2huBl14wYJS8QqQQ
	 AnwS+mNbraW5dnaeQ/Kh8xd1jgPFeiNgeKWg9eVgN6gugUwAnTctXIFflbvFPn/7122kA
	 /uGabqr3gxrLCy1fVOxYT/+Rhv1/1WAjUiDkL2YpNP6/KWKjoaDXZbtSwwgV7MI5fRqsM
	 duOS3g+XuR0JRfgNORdFnhSY3Uw+lOaeyIYH1ZiK6vC1XFgivqjs/iEgGhKuySmKztY26
	 SEAL2nHrM9p6EMvPq2872OKuV//9clZ2277irb6nHJqpnjBR9KFMnqzikAJWfpgwpjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=u5BV6j4A;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D3606A31A
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 07:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A08D3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=u5BV6j4A
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so193685e9.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 00:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792742374; x=1793347174; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5jkvtV8P/+s5qJ2kbqgOKMQCk58hvpuAEYMAliw2L+E=;
        b=u5BV6j4A12HiHIbg6gQlUBL5X0t6O1C3ddixjrZop6JI+2TKTFJmOXd9weEDZpktFm
         GSfpnEY18rSUyBHXuvtvidSe2wjY1SQ0ugvkdCeKpgbxQ5WuV4/rW0LjBALuJGzgo6I/
         wChGjifTcPjMVXvJQtVi5jp7G9naGiO10finMycewx9eV4hox1OYNzolG6NXj6qzSVCI
         1MXUVyM0NAPnjq30Oo7GCnkNLoqyeVoj0GFcBT30w7jt/HQNfzJSbwhVDS/NqJhj/O73
         90vGz83YHXe3owWT1y1JMfExqI4zKc0p3Ifoz/rWlLFcRflHlRweU+7oEMyd7yWrKwSR
         VCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792742374; x=1793347174;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jkvtV8P/+s5qJ2kbqgOKMQCk58hvpuAEYMAliw2L+E=;
        b=D0G8FtFSTeG1PKjmTWvxgo6xly+juDa+k6H8+qSwVeKOBZBqFlv8EAxoIYaACrXNDa
         SakIIyUXJ7fM3hm9Cjf8skXJ07Ov251icns182AAXCV+0mcguFaUivHB37XIcVE2Tj+R
         Pr31t32423I4uqnTCC/h7d3ES2NPaS3GlRNJZ0Oeq5eETcCuiV3nKaOq2R5ThaSjcqo/
         TLwx+FKJgCMAgbWeR+GSWkc+lmu0Tr0s4WXexGqppe1QPLnawllfM6hN2urjQjhSqvmV
         +EpES1Tiexg1Gwms8Qt4Y6LJ/E58w2/ltgCC7bjwRe4eFCq3QfRU/SGeW7kR6sn9/sy5
         BKwA==
X-Forwarded-Encrypted: i=1; AKwUvBzM4k+K67clY2TcVv51UeBTqM6NGKwm4JP7/ffb2RpmSS47hivqPVitQ2nq3mIu7LMB2Uiarp0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJmMyzVQp3N+6tHmWLm5AxwdIG+x5BL37CTOJntcuaOYflAaI/L
	2ULaD4bITl4f43DwOfbKKxKH/GmxtnQv8QdCqDTe9UFvn39swc4BeiLekQHNj56XFw==
X-Gm-Gg: AYBFou0h7l7gNTuZ8ci7wdGQ9UweCnZ8L93z324FadeSxkhoaXN1NUOVyo2d916PK3I
	D+z7UgQDP1wlOG5hoDweK4YIg9/Me1KFUT3Jz2X8zmWyHj0Eu/ktcdgxTVI/CyghF+EqcPPGNPm
	yySugZU9P0r8I1ZJo0otQ3YxzeT1K19qlGQkd5g4Y36ltnuW9qCZUSkLKgDvPX2HXsASDzWIGTt
	fBrAJLAWYonuLAdHqXvgq9g01ALhNxYn2XukwIy7U5FFkl6p7LaT0kkjg6e7JpOK3QjXm1Cl7Cq
	9YiY3JtSzbL8yyzlxBYTNsxAQU2VbDEbMTeSTd/yQtIUSB4a3qvv1CCk9aVLTU1rHUXrjyZp26P
	di86NuiH/3avd9+GwP474FxJmIu4KCgZ+zJdnkim/UO0B4naPcZj0pLRAdmAUUxIxdxF7swRl1+
	BaxPd7gWBKOpg3ISU/Cn5CuvfRCih13V3v80ewxDOjoGJLWVceAXpqAya2lYE2xySlvTIaMa6bd
	UIVcMVL8XcB050LBTO/JaTYiaIqDel3jqDqt3lHVmpdEywJ+KKFmzgsGDzLPHcy2PSvWiO3Y4xa
	1WchI8GVD+L7Inl/KVru7smU
X-Received: by 2002:a05:600c:a04:b0:4a1:e7ce:107b with SMTP id 5b1f17b1804b1-4a211c7facemr22799255e9.2.1792742373535;
        Fri, 23 Oct 2026 00:59:33 -0700 (PDT)
Received: from google.com (197.183.140.34.bc.googleusercontent.com. [34.140.183.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a210473567sm56280825e9.12.2026.10.23.00.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:59:32 -0700 (PDT)
Date: Fri, 23 Oct 2026 08:59:29 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	tabba@google.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
Message-ID: <atsT4c-JLRSxSreo@google.com>
References: <20261022140048.2522787-1-vdonnefort@google.com>
 <20261022140048.2522787-3-vdonnefort@google.com>
 <20261022173604.3710390-1-fuad.tabba@linux.dev>
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
In-Reply-To: <20261022173604.3710390-1-fuad.tabba@linux.dev>

On Thu, Oct 22, 2026 at 06:36:04PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Thu, 22 Oct 2026 15:00:46 +0100, Vincent Donnefort <vdonnefort@google.com> wrote:
> > The vGIC LRs are architecturally UNKNOWN when the CPU boots or resumes.
> > However, in protected mode, only the used ones are reset, because the
> > HVC __vgic_v3_init_lrs() is never called:
> 
> Could you say here what happens to a guest when an LR isn't reset, as I
> asked on v1? Without this series, on QEMU changed to leave a pending
> vINTID 100 in the top LR at CPU reset, the guest warns "Unexpected
> interrupt (irqnr 100)". With only the EOI bit set there, the npVM
> doesn't print anything in 150 seconds, since the maintenance interrupt
> is asserted on every entry. With that in the message, could you also
> bring back the Cc: stable you had on v1?

Sorry I missed that.

Actually I don't know if this should be backported. I believe it was working
until now because all SoCs do reset their LRs even though they don't have to do
it.

-- 
Vincent

> 
> [...]
> > Then, cpu_hyp_init() is only called from init_subsystems and
> > kvm_arch_enable_virtualization_cpu(). Remove the kvm_hyp_initialized
> > gate: when pKVM is enabled, the cpu_hyp_reset() will just return an
> > error while for other modes, we already know kvm_hyp_initialized is
> > false at this point.
> 
> In init_subsystems(), only the CPU that ran do_pkvm_init() returns an
> error here. The others are still on the hyp stub, which returns 0 for
> HVC_RESET_VECTORS, so they go through the full init. Could you reword
> this part?
> 
> [...]
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> [...]
> >  static void cpu_hyp_reinit(void)
> >  {
> > -        cpu_hyp_reset();
> > -        cpu_hyp_init_context();
> > -        cpu_hyp_init_features();
> > +        if (!cpu_hyp_reset()) {
> > +                cpu_hyp_init_context();
> > +                cpu_hyp_init_features();
> > +        } else {
> > +                if (WARN_ON(!__this_cpu_read(kvm_hyp_initialized)))
> > +                        return;
> > +        }
> 
> Could you make this "} else if (WARN_ON(...)) {", as elsewhere in
> arm.c?
> 
> > +
> > +        /*
> > +         * Even if the hypervisor didn't allow resetting the vectors we can
> > +         * reset what we have access to.
> > +         */
> 
> nit: "what we have access to" is the LRs, so I'd name them.
> 
> With the above addressed:
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> 
> Cheers,
> /fuad
