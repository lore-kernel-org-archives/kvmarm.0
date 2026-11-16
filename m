Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794847627;
	b=NOlg3seo00RcixNJw0M6oYWayK+HVoypt9MXmsLArXFfjGvZm4UaKiVmyl/iXYJBnrXs
	 yAGvvEVqn4YT8FPpZHQFR0SXO+FFbncjS+SpeQjb7vgMIRz4WsQ5SV2K5wvqyxazbbFu1
	 XennkSE9pJIcr3EY89ZhGEe/0/+PlIp3g8pW712y9w2bjNHYotpLKljlY7ZeWg+NSsJ/q
	 V9C8uFervdfZRQcjtV4cW5HdhKDuViZ22yWSsg1eNkmlEZAaILKCPJAPtjWCZZAQYXg2s
	 I2ckvnx1dmeKai+hAE7Z/kjS6zhWnJSBckpUBrPmM2bGT3DHp9IJ6ooRphAYGGPLsYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794847627;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=qNp1q27pSiTWfYgGJSTKqOtkXv+RytUsmXHc6vFuLzY=;
	b=khxYOPEgTidGFHUGUIT87TlPy+3alsMqZNpL9ddcoYrj2ue/aCzY8iZ8v+M7adsaZyYU
	 Gsif4bCVAwigrCr+0Jh25+8YdTIfx8fm8OMPVC1Jqk9eNRN80mJAMd0UKfdn0GHEGW1mc
	 RQX0xjpBde0Q+ODMdtwbFStAQxfyc64EtS2Uj+Flyqn4r5r9OHwLIEHsT6Oed4bLryiE9
	 jEmgCmLWCHp7Pc70jelzm2QKvShHOmyACM4Nk4BCk31d8FSN/k1SWVqb5TCxxW81L3fk8
	 zAYg+jghvOH7q8qfRuSZJYziTxXpdl60LUoeMkWPwPpCyDuo3WKN56ccVhL6py9Q4yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NWbACTL5;
	arc=none smtp.remote-ip=95.215.58.188
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDC4606A31C
	for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 16:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECDC4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NWbACTL5
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qNp1q27pSiTWfYgGJSTKqOtkXv+RytUsmXHc6vFuLzY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794847624; v=1; x=1795452424;
 b=NWbACTL5TjFUpQcCV5hNKmYqRw/SogWUQ2GAgjyCHOV+ll6+j74Nyt2GwVPLZxTIJv96X/Dn
 htA90sl98AnFMvKNM2dvz55WFxZweYpkgRb+vK7jmxpP4lgsrh7ZvKf9T59o5zxjVoJa9Vsxm95
 zNuF9czddpAQ2IxCWDdeTkO4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4059d987bcc4b414;
	Mon, 16 Nov 2026 16:47:04 +0000
X-Mizu-Trace-ID: 4059d987bcc4b414
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5be58ad9600so11740e87.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Nov 2026 08:47:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGTimyZGwkXbot9+OQBnzyoL/+NuxQB6L4d6nUSleIf5NtplASksPuMn8NMenLW47ap+UC1CiE=@lists.linux.dev
X-Gm-Message-State: APuU4Z/hD7qK5MAminENlT9ixxdOJc3DRDmaBwls/jZkG/uBX9H6DY0m
	5HSWn0BJKtyCyvfZxzMAtJAq+IP29qeGWoqlx6bzBWrF+6BLQ5gw+EWHmYDYwMG1kQXD9LM0zHH
	VRUqCPQqsB7jPJyOODKtNa2GVO4BvISN/BtrE7tQ/
X-Received: by 2002:a05:6512:2312:b0:5bf:ec8f:c361 with SMTP id
 2adb3069b0e04-5c17e46b73fmr254876e87.14.1794847622967; Mon, 16 Nov 2026
 08:47:02 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261116110549.1863653-1-fuad.tabba@linux.dev>
 <avro44jUWOARFzul@google.com> <CA+EHjTxWuiyjmUc3vH_KxRtS_3oX5w=CE76LdsLcrqC+RzLGfg@mail.gmail.com>
 <avsNdPissIDAb1hA@google.com> <CA+EHjTwuvhAPWje63TJRR_d+VHT0xwORktQ4zxrcV7KMaHxupQ@mail.gmail.com>
 <avsygB0HdGxR6psB@google.com>
In-Reply-To: <avsygB0HdGxR6psB@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 16 Nov 2026 16:46:26 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzZAWPv99UF_2jKUteF=ZvhfWqBJx=dHi+-tFxBMoUfLQ@mail.gmail.com>
X-Gm-Features: AclHuK_WgZd3Hq9hZ3t4qbB4b45pul1ULpwp4wH19UYyqHf6wDD32zLK2i7M2yE
Message-ID: <CA+EHjTzZAWPv99UF_2jKUteF=ZvhfWqBJx=dHi+-tFxBMoUfLQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/virt: pkvm: Zero and clean memory before sharing
 it with the host
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Mostafa Saleh <smostafa@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Nov 2026 at 16:42, Vincent Donnefort <vdonnefort@google.com> wrote:
[...]
> While I don't disagree with having the memset in CMOs in the guest, I still
> believe the hypervisor should do it as well.
>
> Linux is not the only virtualised guest and they all should be able to trust the
> hypervisor to do the right thing for them, which it doesn't.

I agree, and I think that that's the consensus [1].

This fix is for the guest part.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260923130031.GE1540250@ziepe.ca/
