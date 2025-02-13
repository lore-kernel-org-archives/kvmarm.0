Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5B1202C31
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739440790; cv=none; b=n/ZPDfakwoO4GrX03CrtO29WPszBJXRi77b5DNohZSP7dDxFUJvobggmvjb7E4dyCSwWDPimszSoYBHVHCHof6fyrXJ9ySJO3TapBiBAotg5pcMcat7HYatFeHsyrJMVc+BFtGGKNXpKj17VymYnHEDHZeDKsXJxrxV4S028Y3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739440790; c=relaxed/simple;
	bh=COJNGekBErJDtHN053nWkTAoSgTTSoO9L+cYR+Xqxy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a+si32QnkAKcZYilpkl5r53FsS5x/w/KO+1xCqQPAbFgoH/lB+i6u340jJOlmp2+5QiUx76WxiBPOM2IdjxJbGR3sX/As3FOimNuRVqs1Lu9y7/J6r2U0Fgq7jijQZxegB2WAAnOc1a6/GjU1+SVhQvrHEvhWdutA1VRzWlcaWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GKhJNr4p; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GKhJNr4p"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6e4289e83ddso189216d6.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 01:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739440788; x=1740045588; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=COJNGekBErJDtHN053nWkTAoSgTTSoO9L+cYR+Xqxy4=;
        b=GKhJNr4pR8Cea3ZBAdGNUREkXQ0Wq35vl3Zq68feONcqf3YC6bLbvShEt+/ywEDL5/
         2MU4xpbfu4j9m1l/MGocKOi74SUuxH2RJmBU7C7rIn3Ei4O6YlnjAhY0U1iJj41gyyvE
         UYfV+ZYB+x9iW/YXzfkY8nOgN14gjORMYiTMG6MCXohwzKC/TyDu1JNxiwMF34NChgG0
         v86IH7T+ggTIGZjva8JKFH28af4qQt0/sd+BiQfpkbrdpEU6G+Oq1Ihy2upSvOA+2Wv1
         mm4T1Ovvo2mmcxO10A6qBQr3EygNDuFzpQNxMX0xjUEV4OpktBZs9oeJrdLXo/3HaASt
         Se9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739440788; x=1740045588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=COJNGekBErJDtHN053nWkTAoSgTTSoO9L+cYR+Xqxy4=;
        b=ELpMSyrVeqU79SpxDO+Pi29J12ZbGgDBKJer2dYkpbNnWBD3HoZPn6A4hs/dRthtna
         odAm7MaJ/GMmHWE3aUjK7kCsLTVyB//PZMt1IKZ5aLOjQDLvs8t5NO03IEFXHzXwo8/E
         iX7jYH3ajOtGthXSNRfr55v10OVYFju16N6pVqrHNMLXifTrXinduo48TtAZZv9vauEG
         t/fk+MG/n9TzIU0+S2cfsHy9rp5DdgyrxmtTUNdVao0Q9ORKuX6oe9ZRx4cQs7ArGu3U
         uqo+1sFYNQ6DVEpJYhMLBo8fCpL7f7zjqeOQwbL1q+uwH5B/O2uhMVprCZfEwaE2Ky9b
         wQLA==
X-Gm-Message-State: AOJu0YxDLLnUh1s1IB/9BdLOq0QV648En/ZkGdAdLk7kJoSDj9hDwvPZ
	T0E+QjYpqdr04HIczlxn7bazrYBZAgzmsLKrLFAmmE5JV0pKZXy4cc4GW50Yq/+yAqbDPRk5waH
	nKEBw0YPCG3QbBCO5c9TLAW8VPNNJKlZheUV3Xg==
X-Gm-Gg: ASbGncsGhwNeaFuDnKSEGRnUMw/CoS41+4zKaE2HcvtoXrHm88BktbmLCcleyoY4peS
	2DwKS0jeKzlg+UK6Y+1E40NG6WXhVryPqdHnnGSz0ReDgyTBSDRnaK0OiMaGyHSdWu60wWtSB
X-Google-Smtp-Source: AGHT+IHjST43iJQwKlW8MuHT3YKNmk3TJzkB+3qglLpmrJHxoQ21YjQ7p9lFzVWUi5QoVF1/vD6V21s991LiGcWOuME=
X-Received: by 2002:a05:6214:cc8:b0:6e4:2975:ce54 with SMTP id
 6a1803df08f44-6e46ed7f367mr40769266d6.3.1739440787956; Thu, 13 Feb 2025
 01:59:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250212173454.2864462-1-maz@kernel.org>
In-Reply-To: <20250212173454.2864462-1-maz@kernel.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 13 Feb 2025 10:59:36 +0100
X-Gm-Features: AWEUYZnv3GWn0jzFu3uoM9Lo2WH4CAyE-PhoCt0q0vIYbO78Rx1ocXlr_cZpyFs
Message-ID: <CADYN=9KWdAm4iKYNN16Uz68XPViDLXGar3uhrM2e2+Dharaosw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Convert timer offset VA when accessed in HYP code
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	Linux Kernel Functional Testing <lkft@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Feb 2025 at 18:35, 'Marc Zyngier' via lkft <lkft@linaro.org> wrote:
>
> Now that EL2 has gained some early timer emulation, it accesses
> the offsets pointed to by the timer structure, both of which
> live in the KVM structure.
>
> Of course, these are *kernel* pointers, so the dereferencing
> of these pointers in non-kernel code must be itself be offset.
>
> Given switch.h its own version of timer_get_offset() and use that
> instead.
>
> Fixes: b86fc215dc26d ("KVM: arm64: Handle counter access early in non-HYP context")
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Tested-by: Anders Roxell <anders.roxell@linaro.org>

Build this patch ontop of next-20250212 and ran kvm-unit-tests on a rockpi4.
And it ran fine without any kernel panic.

Cheers,
Anders
