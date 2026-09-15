Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1238283CAF
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 10:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.127
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466681; cv=none; b=bp3I92KKgjxLWzowvP8hmVhX3Mfu8HLvlcPkc1T3ebVtw/YEtzEvpZEuqhHwg1oXtaEn0SNrlGpD0ei7lHwVn/+caHa8omFWn/x0vUg1QmPrqKpXnQ/673/9AjZ0G/jGpFsamHwgXNQAp/kdjDlYeduDfnWjgP2wwI/2iiFfjb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466681; c=relaxed/simple;
	bh=eGS9ZAELcTkTuNTgyKM0hpB2EjXGms+wAcOSiSmEqTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQcxHghkiJSDc2usk87mvFYMPXWXeN/p/ai5Ne91EDKWAZLUn5VQc2BWOQ3nESurxMEwa7TRGtVfpzQ9FLO+2o1M0u88Q5ERtK9oLpEcGeuN1CLukjzHva4gHx+C4EHo7NT+lkAvcbjrQcijDyg0nfXBk+Gb9QjgMPSBDaRshzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M/gzquCj; arc=none smtp.client-ip=91.218.175.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M/gzquCj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eGS9ZAELcTkTuNTgyKM0hpB2EjXGms+wAcOSiSmEqTU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789466677; v=1; x=1790071477;
 b=M/gzquCjL1sR5OmX3viuzPR/u3F3ID2HqTqDWhnEtQmRgx9FqLkf/HSf9tAEyQWWbQxAU8GU
 /HoMDDWW5UiH242hKU1lZlgu/MR/fcEtWsYUfpofEz4KH1QWTH/JBxbJgqoRkH9XaP/ET2+OoPq
 fWDRG5FHRXlUF/Dkk0BvBRtc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 43a15f6528c278ea;
	Tue, 15 Sep 2026 10:04:37 +0000
X-Mizu-Trace-ID: 43a15f6528c278ea
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b17359so3756e87.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 03:04:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwZLAVaGaLCu1wiChanMpc1SOtLE2W/SUeKdnqdUcSDKFZIJo/DL2xKAPlFPga1Hg+/ZgD2Q80=@lists.linux.dev
X-Gm-Message-State: AFuF++kAEK8JtBDLTYbZFCHVdl+/VRMqXsXCsvkdolBewoxHfqXoff/Z
	cJdmRanNMh1oZgOzTgiRJ1jjwoQI4tkePeIVhXCYfqRpCB8pOA4vzIkKM6mLxUQ3dkWZv3qitC8
	DfVf7IfuNT4SBAxbgcrLMcS5wfpVMh93j3q6zYjhW
X-Received: by 2002:a05:6512:2251:b0:5b6:bcb:26c4 with SMTP id
 2adb3069b0e04-5b8b2d57c88mr125735e87.16.1789466675623; Tue, 15 Sep 2026
 03:04:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915070418.3209779-1-fuad.tabba@linux.dev>
 <20260915070418.3209779-2-fuad.tabba@linux.dev> <aqj1GKamuBraiub0@google.com>
In-Reply-To: <aqj1GKamuBraiub0@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 11:03:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxujn0EwJM49FaAuXjbyTWmvgzk89orO+8WLSn63u8WtQ@mail.gmail.com>
X-Gm-Features: AcwNN1VTCK-3nqI9-Q-RK2JyK41FQVwFdhMt-rabRiLORS8vzlwPjlPh4CVwNWw
Message-ID: <CA+EHjTxujn0EwJM49FaAuXjbyTWmvgzk89orO+8WLSn63u8WtQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Validate the host vCPU's VM before
 reading it under pKVM
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Sept 2026 at 08:34, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> Beside those nits:
>
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

Nits addressed, and I'll respin this as part of a consolidated series,
as requested by Marc.

Thanks for the review!
/fuad

> --
> Vincent
