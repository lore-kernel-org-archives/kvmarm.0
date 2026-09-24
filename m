Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2709543CEF8
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245714; cv=none; b=fKZX1N50KyBfejf1UbBpjMOzv1pf6hVyoUu5IP5FU+xQ0GF0gYWig/hPDzpaMc1gcpzk+cE/cRAj5oxv+5J61jCo/9bQrZ3CdHfEyUpjjrYAPsgDnFNkNpfIUZcjyNGiNS1C/wBZVLWr96M+Yn8jQXLsShdxXcLW9sxtGtkqgaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245714; c=relaxed/simple;
	bh=l8wslZqsYjoUhW8BVyXUXs6u/mOGOCtbqiMACO0PwU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dpiGxONRCyO97vCwKGdhFxfF7UTVO477uv+PvJj6j1b8Ghau8HUnAFvyl1tzhSuVSF6u90kqkDU+iz/rcWTprDxK2srIPCfATtQYkmOTdN/1LM3IuFd4Rc/OyENBQHOxaCps9eamQFn8BujL8DF+VdonIAgQ5gUvW4UFHwWcs4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VjoClPrW; arc=none smtp.client-ip=95.215.58.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VjoClPrW"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=l8wslZqsYjoUhW8BVyXUXs6u/mOGOCtbqiMACO0PwU0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790245709; v=1; x=1790850509;
 b=VjoClPrWCvgnOWwIXtSz797fRsUN5pJ83ZfVqf9AcQsNnNA9mVbtKOUruHW7OTwYchaA3TW7
 UCidsafO8SmeJtKcZgblqznMXyeZvp/4IwxWLE8CJx5AJPV6D2Y/KsxF/7T8Z2SPN2DZXh130qU
 JLhUak9gPWpsZo6PtMVKPTqg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 23d5a772848b5fc0;
	Thu, 24 Sep 2026 10:28:29 +0000
X-Mizu-Trace-ID: 23d5a772848b5fc0
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so5177e87.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 03:28:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByLDXeCvE/cYpOt40l0Dcj8Qs6HskX9UUcTFVGjtlzxvPG+7sHPsWbsJXETUstK+Gp9LgBN06c=@lists.linux.dev
X-Gm-Message-State: AFuF++n8rEuAs28Fz09o/r7HVPLt3grOAky/WF5acDq4WH/01OIni1C+
	/LpfPbHGS9HVCrhDyhji4Zywlc8cv0/T4roi0dN95Xc8c8ZMn8ToYMU7Y04opGPR2nA281w1kMB
	a7f+lezZS5pw1IgK1YePI3NAGLPqc/11NNrRpeylH
X-Received: by 2002:a05:6512:2249:b0:5b8:c95d:529c with SMTP id
 2adb3069b0e04-5b8dd6d373cmr194835e87.0.1790245707622; Thu, 24 Sep 2026
 03:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260911104715.307500-1-fuad.tabba@linux.dev> <868q5579ol.wl-maz@kernel.org>
 <CA+EHjTw0U0d91Cv4NYEJvUuT=JabwZeeYwpZ2P1xyVeOVX46Ew@mail.gmail.com> <arT5r6Tqg9PnSYLz@willie-the-truck>
In-Reply-To: <arT5r6Tqg9PnSYLz@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 24 Sep 2026 11:27:51 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwKd=0kY1vxmZZ3Wk3iDcVnrdz9fPXekzr=y7eRwUYKaQ@mail.gmail.com>
X-Gm-Features: AclHuK9f1UKfVBh-sHVCnHRjsiBkOb4-h4MYma9pM03DKGJaXn8h00-d7nViPT4
Message-ID: <CA+EHjTwKd=0kY1vxmZZ3Wk3iDcVnrdz9fPXekzr=y7eRwUYKaQ@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, 
	Ben Horgan <ben.horgan@arm.com>, Xi Ruoyao <xry111@xry111.site>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Gavin Shan <gshan@redhat.com>, 
	Yuan Yao <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Thu, 24 Sept 2026 at 11:21, Will Deacon <will@kernel.org> wrote:
[...]
> > I'll probe MPAMIDR_EL1.HAS_HCR once in cpu_hyp_init_context(), next to
> > HAS_MPAM, and test the flag in both trap functions instead.
> >
> > I'll hold off on v4 until Will has had a chance to comment as well.
>
> I'm planning to generalise the logic you added recently in
> gmid_el1_accessible() so that __cpuinfo_store_cpu() stores the values
> in 'struct cpuinfo_arm64' with the overrides already applied. I don't
> think that directly impacts this patch, but it should make the general
> shape of things easier to reason about. I also need it for the parallel
> hotplug work.

In that case, I'll respin this as Marc suggested.

> If you fancy helping with that, please let me know.

Sure! Just let me know how I could help.

Cheers,
/fuad

> Will
