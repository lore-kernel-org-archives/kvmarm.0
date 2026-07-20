Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046532DECA1
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784574124; cv=none; b=B3pfYVc/641oF/ewzTaLC1z7BqsiUDVoF/HjRFlBsjSSVbVuRmBqCqCZIMSlmP3TNxEeZ1rzwNKzd+iFPNjPzGjL/ewhh+hSX9AB9laCfhJ2yf65Ay0+4fGtycxXcP4bedTj7lEigU6saiI8Vu9zGkQcjS9PIt9yED0d2XDVYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784574124; c=relaxed/simple;
	bh=RoPMbpesKYBTM7BtVesJaXSKr9fkUeGuS8aFoUbVyeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJWSkPDWVm9tVtm2BcFuq+gaJBQ8b42/vem1EAQdwJjv2DWDokxr3u5SDRayDGkPgVdM+nmMo5iLyZnJuQClmgL48QpplCO/4qPyy4+QXIt1YJHpaRgBIvy1xVvkx23Jd65qscjnOZb7RXilDbN+LtWsxqGnYzpFOj611k9CHoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZF4XbQ+S; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZF4XbQ+S"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49555a0e68bso10526055e9.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 12:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784574120; x=1785178920; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LhCePzwoaQC11f7PZvC4LXoD1/F7d5+3LH+i3bZkptQ=;
        b=ZF4XbQ+Sd+/gWBerxeErEsRR6iypkomUwPUltNGHEbqKF6Gkp9P7QXICjoX8zmkipw
         FaorGAx8LPb7orOTyx/QNeeV2Eki9zXR5VMb+wfNtOHxB6rySzfkYJLoCUzWsYi/JwEM
         TIoxLIq4+/23PZOMnEURTzikM3538Jk9xrX2k3ywRufQYPxQIPoshIHpc4mWawgqSqiU
         RUwo8LA/UhvbK9b4VSpWMYj0T0hgfMuKX4ZGJN9M5Swz4J6AgNtV09aexs0apjIDVOuC
         bJICAETcd7jCN8KltFqBGoDqmt3B7P8KvQPBJkqChCv+pNrTXNdMaOje9GGvE9s4zffI
         qMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784574120; x=1785178920;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LhCePzwoaQC11f7PZvC4LXoD1/F7d5+3LH+i3bZkptQ=;
        b=OGirNR6KlscorH4IqJIXzhMWmSTVcMVyLFmubuTokC6QjlG5xJJDBczvwfH0KrYp5J
         Hh2cQJFpZpsXUWpXJAu7PuxId3me7nZ34fpxVaY0hwOVBP6AC4rnwpBvNKn6e+A6u6kQ
         g2jFKE54F/5out67Q7EkYmj1xgMbAD8u+9MzcfRqDoj5aUxmfTfYaNQPK6TDlaToSe1j
         POlLx4RNdiOc/xWWAYIUNrt5UhxFJPFOZZ9HnIbIFH/CXXJ0coWShdv1vrQWy+V9k78n
         q39rGAjEkWQTXSwTl7Qd7AvG0JOgm15u4pdCBWD8rzh6YgUANfm3D+LfIx5MzX/KaSF0
         0h5w==
X-Forwarded-Encrypted: i=1; AHgh+RpC8vshaX9zEfl9nCGDwUl3Ye0Ct5J6FW3xhIZff1jqkJsLumwG98FkYO7oul09fz+dg4mUwcs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxK6h7yFViiKs8EEFcvhQJp0D6MOoMMcRc1kJjL3aGFJVDUug/+
	3lbYFDngpGvF2t6cthtzeOrVssrP4jrBUL71sfphAMh7k0AuTgig2j5u8lBgjyfV2g==
X-Gm-Gg: AfdE7ckHiFq+whbYTNFq5p3p3Ijw2ku+V2VPgbp54lteB3ZSjvLkYCun+QrGgYPKKcf
	lu31qsfp80Cwx5idHN/8o/itlXRgeClFKA35TQ1Xr7RQed1oXVVfljOl5rSkIe/W95f1q2aGgSb
	ImyPRva+dFN/B8jXn9ygzWLkE/Ymqrmr3BE6iYsqJhEEUvhdx1Uk/XUE2TbmjmBFBugXTuHcy7y
	ea9JDqCQ2G91DtApVOQVzpjKLnaN/lk4wd8oXmgZThtCTYzhDHvHhdV2YtluE1PyQRIcw/wS+Ah
	JrzwaXPldrU/P7dji+Jc6AA/G5rsOYT34v07CeWVobNtc36ikwnPKoRy9qKMjvP96pyCuty4VRl
	2ZSFylZTFK/bnZCAP9ZF6PWfSEtDV49kbONnrkvXF0v6m91T6SNclWhkJ5hiWzmwVgZWbi0tToT
	jtgyqM+k3eC0FzV63yq9yPQWM/nyHpoT9l6O1X5IZDxPwC1W5JgvI=
X-Received: by 2002:a05:600c:3b10:b0:495:4aff:5fce with SMTP id 5b1f17b1804b1-4954aff609amr169923055e9.32.1784574119583;
        Mon, 20 Jul 2026 12:01:59 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eeb360sm33723752f8f.34.2026.07.20.12.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:01:59 -0700 (PDT)
Date: Mon, 20 Jul 2026 20:01:55 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-kernel@vger.kernel.org, tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Stop the hyp trace clock worker on disable
Message-ID: <al5wo9x7oUGzlbTo@google.com>
References: <20260720184850.1826630-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720184850.1826630-1-fuad.tabba@linux.dev>

On Mon, Jul 20, 2026 at 07:48:50PM +0100, Fuad Tabba wrote:
> When disabling, hyp_trace_clock_enable() cancels the clock work but then
> falls through into the enable path, which re-schedules it and marks the
> clock running again, so the worker never stops. Return once the work is
> cancelled.
> 
> Fixes: b22888917fa41 ("KVM: arm64: Sync boot clock with the nVHE/pKVM hyp")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260720172923.E4F161F000E9@smtp.kernel.org/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Done here already https://lore.kernel.org/all/alczBmnItMwq8xj4@google.com/

> ---
>  arch/arm64/kvm/hyp_trace.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index 2411b4c32932c..27367843fd211 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -116,6 +116,7 @@ static void hyp_trace_clock_enable(struct hyp_trace_clock *hyp_clock, bool enabl
>  	if (!enable) {
>  		cancel_delayed_work_sync(&hyp_clock->work);
>  		hyp_clock->running = false;
> +		return;
>  	}
>  
>  	ktime_get_snapshot_id(CLOCK_BOOTTIME, &snap);
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> -- 
> 2.39.5
> 
