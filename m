Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792664946;
	b=vk9ud7gH+miS0VemolW/rZA++t5u9Q6azLRWvRTSZ2sNkwisuZ4VcK76Hm8ZOfGefl3Z
	 o58yVSiIsKfADRJYbz3uGgDAO6/oqAI9uCYj0cNhoDr2exWg2VvTEGYTc1uZDNr8Iko2d
	 9lM/a83VngKl4KZ2a7FMubutHu4BGWZhnb0wBxi/aSBtEyGxXwlycQEysrP+9PVx13jCd
	 gTJseZOaMXCYB/ExwwzevR1FTdnVT0tIRJpFa3I0Be6C4dO5wLNdzkuawqgc71qict0TV
	 umIUew2l0+lo1B9htX6t+zRO0N+VMBps4sqn5rWQJE9ILSq9v0GLa8WYVPRHWpyCPeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=cn7Jiy+rfx7L3qxqqL0r7yhmrZU1rqORsCCwAHiY62s=;
	b=o8B4h8kEZOYRpaZPRo0nt7fagDUZbIoBf786On67UwVEDMEoCU3uZ/57yLrE6agO5gsv
	 4ik7uKlDYTKyRDDLss2r2QfKnFv8Gjr47FK+/APq3oh9rbfTubGbXw3kk23QDXIW9B03e
	 EqhMIzINEIDWkL1OiCMaN9U2mWJtOwfvGVDGXYTqQuVGNLTqwIxrhCMaFHcow4ueRdkQf
	 JQzwQjEQVLuZOfmHfFMrM7tgYU7rE2ZObHiX2X98xFk0iMrFU/VaAuFgl8OCou25bblJh
	 L/7gUXtd1eTR38PJrVznpwtuwJruPPWDfJsHuDSiz40Wh9hzWvj3Pw+5Qg+1rlZd+HQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=LRVIqZ6+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.172
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3746606A31B
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 10:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3746606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=LRVIqZ6+
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-8ab432273c5so16234917b3.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 03:29:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792664945; cv=none;
        d=google.com; s=arc-20260327;
        b=gs3qiXU/GNszGi24kZGHhJw2Z+U138YEw5yeXVNJ//Zr2jBJTmKb7dwBccYzlHzsDr
         umdkEEM0WSNJuHpSkts1KTRcgRSflThsbRhd69S7OyOcjRlgMA0qrAVGqhDCYzqnvshw
         MNqlAevkuyEiT+M6ip6FAo4TZy8C40MoLtHbdGP35lj/0JjIRPFE02uz/qh40hGkG0av
         xqE8KEb760iv2HnLEsdKy46U9z+9c14yoSP0/F0ZBOUZfZ1A/ICKooizugkOls7LaUDL
         bJQCpb3S6ZhicevgFomvI1TWe6jejSLgKNDnJT4aQL4wBnoTI6TA3ipnm75pqw3IPXjR
         9UTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cn7Jiy+rfx7L3qxqqL0r7yhmrZU1rqORsCCwAHiY62s=;
        fh=aBH0n3s5qRwophBEgmqK46ep1lSyFbSAB6Sb6MNKy48=;
        b=bo1aH88e9FytqqRq5vVaRom/Q8tPgECqPHVzci14mfU05MQuc9g0oshlDfjaFMnuVp
         Lzc6pTLzm8nl798tF3PMhWQ3U+Iq83bzU61Djv/NS/DVOP+KwYMDDagVk7N/l+dijBaY
         DDUrs/mNUZ1En6zGIDstSy5SE2UeK4+P1dF9l2LlNwyN7LB6WcZd9WSGB28QOi+gjdmP
         /9dL2jEcNO3gZYQOuY5+oqYEOjFInVeAijoqts23mSji9weMMULiNB6abd1Jo76ewzfR
         y7PlSKDxLwLyCH+45g0mg95KAwV5QPdfL8F79vTNmf2hmF6A/3CbMOmBKsLF15yq54g2
         BQ5A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792664945; x=1793269745; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cn7Jiy+rfx7L3qxqqL0r7yhmrZU1rqORsCCwAHiY62s=;
        b=LRVIqZ6+32mkzW1dL+CBoc5l8Rcr5Yjgg0z0Q7HR+9xyVJnGb0wZB2zOBwXxd78/PD
         B8VqebDTSoO56BzDHZ/Gv6EzyVP6jw29yjr+pT/LAi5U+gKyNHoqC6JLnhYqV4T3GzrF
         FyiB41/8DT4sxIKm3Ehi8E+Cw8uH6iE2HljhDbqrSo5kWgpSokDjvpYkwkcPcUDEgwb4
         fsdzKqRZCkhAsNrgXt4VOyJG5r1N6ay1LCN4am0dh8leHICLvO/jGT1GgqDuoDqp+Voh
         nppvBV6Av/OP9ZNFjcFBYThw+ZvEV3mIEc6FpIeyUffhYC+jji22KIR3k/r/bcdA+aao
         HmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792664945; x=1793269745;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cn7Jiy+rfx7L3qxqqL0r7yhmrZU1rqORsCCwAHiY62s=;
        b=fpmph8+HkN1fJ5htrJ4+laLpfXD2BdDGi0PpvLtau5jRiOKGN0qR0eOO/bG5dTs/w3
         TNdBia9qULA0jppf7uXLLldAQpg3+fBzQv5ifgWkppjio5wrjdYapMJ8q1exrpIoS2em
         ZD+Oy9Eu9BbE8adSKeBSfNZRiiFJmZlNXxyD8J+M/CKRxGshCqZEf/1JEdsSiIBhihhy
         wzr5Xvj9ZgoHMAIEVmjOOfxDhz/HIGIxuvqmGnK/QYTd8ryRjxAXpSJyFEaqNVEb4BYn
         dVkJ2lLbZ+q3pywq4uv0vXnI4vZwL6CgX9ufxlL3PjN57v7bH7pUwEjHWAGeSkeqMzK+
         3K0A==
X-Forwarded-Encrypted: i=1; AKwUvBz5ULwLaoyIC/cOsxSeVXHs5/zX0tdR7ZI8eLqR6HsAvZ0JVE+nFPAAaZ5Jm6FV2BCTaQqzYmY=@lists.linux.dev
X-Gm-Message-State: AFq9FYKFQYFNxYHv+d4Dy3pxAq2+7PumzbSecjTzMrUQsBg3NrINHZrW
	BALVWjKg+PHr54WMr2qgQoE73kptRZvkNnUWNupylx4AFeLK0ySpyT3h8WsscxrONX/rBonUbG2
	rA84PZpcN74ktZscGf+XbXMRXuk/wJ8gSIzl3qlf3IQ==
X-Gm-Gg: AYBFou1N8JDX5M77vfj7w4zUy03CCQpu6LoWOQbeDk5fHEm1AP24FGteg84MmB9tyh2
	h6kQd8f54PMWTOzmFPaC2WIYB7VqinJPDkQkXW/cZACbs6LEuz4sMOF9v80F+qJrrpkVwNU66HF
	uim8YV0iEHdefSkkiQcgvEkB9QFwBMSRTpVkihHNxpufsLFTI8xOAuwfTSIU4vUzVkgwS1dNvVf
	neuRFyqkZXa/yhoZZiXKp8vrDBfVW2NXSkqt+46blo4QvWD5R3dVp32Su+ABpE6XfnK1kHWq3jb
	AW6IJbr9guRj3Tp9yeh+aZrY1HziZHMZ3HyATOIHnE4KowCaDVTWGKB0rhk79tJ7DW06aLwhjeU
	I0fIeuh9UCpNU0t6d0zt5l6JOj/3Z3WZv2coQEOi+lVWyWm1YqZi6f56Slq7/H+06D7eH0MjdJl
	PU0QBjl7SApnbB+zt4C8XX
X-Received: by 2002:a05:690c:698b:b0:7db:ccda:a409 with SMTP id
 00721157ae682-8b133c990ebmr26039097b3.9.1792664944827; Thu, 22 Oct 2026
 03:29:04 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261010133725.642498-1-eric.auger@redhat.com> <20261010133725.642498-4-eric.auger@redhat.com>
In-Reply-To: <20261010133725.642498-4-eric.auger@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 22 Oct 2026 11:28:52 +0100
X-Gm-Features: AclHuK88Pi0Irsvl-VdYfD4usULDFkmX6lTQYJ4Rpq4T7jFaUE3PDSXIv2XVoCo
Message-ID: <CAFEAcA8HS9a3eyrs7iOE3xZ9MyHHr9w5UmReAz==yy-cgyY-Fg@mail.gmail.com>
Subject: Re: [PATCH v10 03/26] target/arm: Enforce MPIDR into isar.idregs[] storage
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	kvmarm@lists.linux.dev, shaju.abraham@nutanix.com, khushit.shah@nutanix.com, 
	yangjinqian1@huawei.com, cohuck@redhat.com, richard.henderson@linaro.org, 
	sebott@redhat.com, skolothumtho@nvidia.com, philmd@oss.qualcomm.com, 
	maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com, 
	armbru@redhat.com, berrange@redhat.com, abologna@redhat.com, 
	jdenemar@redhat.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 10 Oct 2026 at 14:37, Eric Auger <eric.auger@redhat.com> wrote:
>
> At the moment MPIDR_EL1 has no real storage. Instead cpu
> mp_affinity field stores the Aff0-Aff2 bits only and the
> ID register is reconstructed when needed. There is also
> an mp-affinity property used for TCG only.
>
> Keep the mp-affinity property and its associated storage
> while making sure the MPIDR_EL1 full register is stored
> in cpu->isar.idregs[] as other ID registers.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
