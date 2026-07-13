Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEA3342532
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 22:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783980467; cv=none; b=sFg3onUH5NGC3mZKgr4SThZ66UIVSTsTU9GYyRGaGtWR6rYuwlx/BM3mE/2MfiVH5y6waQlp9osWNOeVJz7cWG80IpILDNsHRKeLqNsOajZkrDKyQXfnpmtf3VIjhgx+1ZEWBhptaOeSSvR2Vi8q8wpVBoznhhz955Q68BnKJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783980467; c=relaxed/simple;
	bh=AgQUtZk4JxfdrpCudYTTgIHshbNR5GKJ4Xji7gE8h5g=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=FreKUwm1Xdk41a7sOM+uDplf8hDUskVcrKQ+I5CFoqBAmdBsA6QrTb0N3PEWxs8zcNUiLIP94A7u3OAbCpBdBwFobWuSdMgLEyC8zEWrZhlZJIoUgS9Iqz0Uj6zFFkk9oPY4LrOLnjRjRmgC3CcoiEjHkF8APd872uAIIhRZsb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DA+jjgX/; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DA+jjgX/"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-451d80641efso3553309fac.2
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 15:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783980465; x=1784585265; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AgQUtZk4JxfdrpCudYTTgIHshbNR5GKJ4Xji7gE8h5g=;
        b=DA+jjgX/Uab+iXxASxRqoCiOF+Myo5oygbgoXCYpG9gcejOaUXdgSZQlr//gM4ZNEC
         dJX/CHG8vmZuhUpGbrFSbP3x2xtB+yQdb/ANqq8fmJ7NJJg7ZoHwquQNnvbMrQaxez2X
         5YcRZ3PvafG96rbB/v7v0rT8fzmLGkZGUf5UptgBLsuZM6yShgxDwfIqAa7CixZqdf1p
         EwZrUGWUltynBtTJ4s+1Fr71bl6t1z2e6cuOm+TT1ALK50gX0oudyWL0rU42Nw+mlPp6
         rDpu896Zds0W3eIUvrzVn7S8x8YIbFxKUmhmXcE/O1mpgM/34kW+hnPJ8qe7K85rRFCa
         t8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783980465; x=1784585265;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AgQUtZk4JxfdrpCudYTTgIHshbNR5GKJ4Xji7gE8h5g=;
        b=BaFKW/Y/a0yg12Tfp5pXxmfdotOCWIAUXpzhjQGmPQGqkB2bYxcbZYnphziXsP3vtS
         XbOJlY8djWCiyrqf30jB5zL0pcC07V3ph+ptQgGMt5TpP3oCQIWAziUC8+fSn1P3YUVY
         Jy2twZ7oov6VhSo8WfRam1qCm5ylEPRNKa1fUPB2Zi2nk8uacH0TB8odMiccJobpitYa
         H/mQrWdwb6Mk1a1TdWL0f2ZSjVC21s15qoNHFVUXSoGF+hzhfoi0hiFEet0qEGICdmsI
         RyftynnfyueDc23UMpR3brHknMVkhJdOdfOsMSJM78VNkIYkl7fG05xlvZ3fXtDkkr9N
         8u5Q==
X-Forwarded-Encrypted: i=1; AFNElJ8yBOSajE2GrrGVT573La5aigRR+GGOzBQ2MLXwezM4OMYpSlrDluvd7Kh1LW5hpPxT7GS4J4k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxV90pJaxNfIUSow8scfBZsG6FpAIRBbeYiVxX9s+nL9TBnmbly
	6nOtdnlzmt9T0fgPQPD7TKXbg5Qh/bm504VOY7p5xc5GIweAVdWPQE35dBNnA+L9XXrP0/XzBqN
	8Ngon2nobPM2mM2rPVDi2vQMEIg==
X-Received: from ilzz15.prod.google.com ([2002:a05:6e02:320f:b0:503:50d1:28d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:150e:b0:489:9e32:16f7 with SMTP id 5614622812f47-4a42afc9e89mr7832478b6e.39.1783980464501;
 Mon, 13 Jul 2026 15:07:44 -0700 (PDT)
Date: Mon, 13 Jul 2026 22:07:43 +0000
In-Reply-To: <20260710163023.agent5-0004@kernel.org> (message from Sasha Levin
 on Fri, 10 Jul 2026 17:03:00 -0400)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnth5m25ys0.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 6.6 v3 0/6] arm64: KVM: Backport VHE-only boot fixes
From: Colton Lewis <coltonlewis@google.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, sashal@kernel.org, oliver.upton@linux.dev, 
	gregkh@linuxfoundation.org, mizhang@google.com, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, ahmed.genidi@arm.com, 
	leo.yan@arm.com, miguel.luis@oracle.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Sasha Levin <sashal@kernel.org> writes:

> On Thu, Jul 09, 2026 at 10:35:57PM +0000, Colton Lewis wrote:
>> Architectural updates retroactively made FEAT_E2H0 optional, meaning
>> hardware can implement FEAT_VHE without FEAT_E2H0. On such CPUs,
>> HCR_EL2.E2H can reset to an unknown state and must be initialized early
>> so later code can reliably detect whether E2H mode is active.

>> Without these fixes, booting 6.6.y as a guest under KVM nested
>> virtualization will hang at boot.

> Queued the series for 6.6, thanks. I also picked up the follow-up
> "arm64: sysreg: Correct sign definitions for EIESB and DoubleLock"
> on top.

Thank you Sasha
