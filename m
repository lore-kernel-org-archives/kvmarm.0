Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED3F30274D
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070163; cv=none; b=baBH8RrRzF87Q3tRgQyQM6XoFyEkw7f/Kk2KgRjzQsaRreqiF2lenDcUBO75fdSw7HlDkwhyF3itQXVRrCKS90uaiFTyyNFMZVoLJB2YMCYPQ9Bf/psLOlQipouqSFBruook+JpF0U29GCGcWb0I1pcxilfTO/idijNiFzrdoc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070163; c=relaxed/simple;
	bh=cBClqqcoRnjq1tJUyrLKGJx+LO26OjFSc7Ag8ZACa0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fCGhvZHxevukUBFZvI5KmaBkBaLrcFT1OaMc5FmjSDK7eGRAebiVRpi50Af2F9V9RBWG/myS+32/guMXFAZL9nHdSUJyUizCIs2hAl7TsImB4phiAtCiPbSCTkSEQYGQXl2Yu4SBB9G37SftxYFffhsDS1bziU/d7y91ZIaqc9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Tl7Z2vPa; arc=none smtp.client-ip=95.215.58.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Tl7Z2vPa"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=cBClqqcoRnjq1tJUyrLKGJx+LO26OjFSc7Ag8ZACa0Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792070159; v=1; x=1792674959;
 b=Tl7Z2vPazwZndTvgO71FO0DwoIUK14tlO3ZehR3VzIUl5hyBBWdIsiVHtFSTAIo6SmAb3coG
 GyJUDeG+xnRUewLmKLIHxfZD3/HJ0dlELgOrjCsB0ZPSIJGlI2oWr3ftpEnKt7L2MI9ZuvEOOOf
 BfZc/zRTEltb15tMzjeICbj4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 38ee5fb49b29f50f;
	Thu, 15 Oct 2026 13:15:59 +0000
X-Mizu-Trace-ID: 38ee5fb49b29f50f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so4210e87.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 06:15:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxGo+32iPexb1Fu0CaGF/Ll4uS2M788VteuLOpKt+ZWiblttWac1582emRj4niSU6UAPvep0ls=@lists.linux.dev
X-Gm-Message-State: AFq9FYJzDx2Q2zWRidMYx+Q6b+vqk7LI6fNm9IqLo+LpYFzu1/dfrPGJ
	I5pdC5kL6g2FyPBD31OrDbg0FUIZkIIuHWAiRwSvoY4LtyFGai1Vk62tk4TJuQLi9+cM/UhKk4o
	4s5F71ATmS2px9gXZcH18qB9sOcRt1FNVTjjJUJ4c
X-Received: by 2002:a05:6512:2211:b0:5bc:ce5b:96f3 with SMTP id
 2adb3069b0e04-5be3e11d7c9mr81883e87.4.1792070154180; Thu, 15 Oct 2026
 06:15:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261015100539.1011760-6-maz@kernel.org> <20261015125716.2650737-1-fuad.tabba@linux.dev>
 <86ld7z150j.wl-maz@kernel.org>
In-Reply-To: <86ld7z150j.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 15 Oct 2026 14:15:17 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw=CsL7XdMdV2g41ThRMQe1_Vh=HL5E50pOBT3ZWQ=PtQ@mail.gmail.com>
X-Gm-Features: AclHuK81C1k155nk4IeQL38Uum0spopA4W4U08O1g0zocLSDFFuwHaItMqtONv8
Message-ID: <CA+EHjTw=CsL7XdMdV2g41ThRMQe1_Vh=HL5E50pOBT3ZWQ=PtQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] KVM: arm64: Add helpers to halt a vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Oct 2026 at 14:13, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 15 Oct 2026 13:57:16 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > Hi Marc,
> >
> > On Thu, 15 Oct 2026 11:05:37 +0100, Oliver Upton <oupton@kernel.org> wrote:
> > [...]
> > > Signed-off-by: Oliver Upton <oupton@kernel.org>
> > > Link: https://patch.msgid.link/20260929212925.31775-2-oupton@kernel.org
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> >
> > Should this one have a Cc: stable too? Patch 6 is tagged for stable and
> > calls kvm_pause_vcpu() and kvm_resume_vcpu(), so it won't build in
> > stable without this patch.
>
> My take is that there is no need to backport this patch at all. A
> valid backport of patch #6 should simply halt the full VM, not just a
> single vcpu.

Makes sense, so this will be resolved on the backport itself.

/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
