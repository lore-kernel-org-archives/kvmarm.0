Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792743345;
	b=RtdYBL+g1mzvUvuZPmPbCj/mgpzW6iobUG/u621FAZ0Gqph4gY52/Fa6Vk19bmofgFZ4
	 MQ2b+Ffwe2pOD4JXgokWh2GYYToxFDvtcdDpPV4IzINeMnc+Gyk2uMFp+c2F18rAsIk13
	 dIdUhhVF3NX9T7GRjFu31YdnRCyaSYyRsjVqBPRv55HCTt6OGXQEeM7Z+Al7W9IpT4gSZ
	 uUV3Ab9ZyTtyBrUD4Nobk8aAZE5/PWVBmGtG3Aim67lPHeCO2yfErdqx/tg8PYwr0ye8f
	 dTqrI/ToQmO2qltmGR710fF0u9MKC7Ekk0zYH1rJQPieRdKanqjgwYwqn9CrJsx++Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792743345;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=3Y1UNnJLUfF4IHPLVKAOakcJbI9y7VNgBZgpQW6I5jQ=;
	b=Dcdfng9JZSQg3u3MKd48Rsn1AW5SJIHuUayYGFy4+BfJwRlcKmCNkb6p3kk9iXYt07p4
	 pqJLI9nX32xUSfp6QR0vWBuBCV/9QlcBJytt3D0BvSnpkpY5ZjHVPRndsWii7Iysht+Qj
	 jsJLnF8Z39KWeD/W2OwtP8F61sQQAxNZFLAxM/QhjewdzDvcOH/xpngHhxI0a6ueR+U2Y
	 EbnjStSMg+VxgINMGNWOP63pHDh6Y/+lCkeQ0HcFbMlauOoXDH9cb+o2pbNhiE5ZvRV92
	 EUU2I74f9uif7rIc2xqLVGSandHa6Fxn/WDjrT/O2xVMstrLb6gFu1MPL/DY7ij1AUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ob6ZXa6z;
	arc=none smtp.remote-ip=95.215.58.195
Received: from mta1.migadu.com (out-195.mta1.migadu.com [95.215.58.195])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4E8606A31F
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 08:15:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E4E8606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ob6ZXa6z
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3Y1UNnJLUfF4IHPLVKAOakcJbI9y7VNgBZgpQW6I5jQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792743342; v=1; x=1793348142;
 b=Ob6ZXa6z+Shtn/o70ofJ6MLMuWppAPOomeGXjXF27pEoFqMjHap/51bHj1q4cS1joihbD+XR
 7a19LR11RLuSK/6kKQnQReu9i18iIe24D9R8Spg2UxLC27iKTbcwtx1arADdxUZ3q0y5f1CTeV/
 VWmjmz6DVbYC3mCRtEvQo4Y4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 62f1d22193d5e5ca;
	Fri, 23 Oct 2026 08:15:26 +0000
X-Mizu-Trace-ID: 62f1d22193d5e5ca
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be58ad9600so6020e87.0
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 01:15:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy5FwNV+Sz8PDOFePydDdw1+GVAQaE/ZDP9645kBr2ejazb4/0aMeWujeQaTJ1lBuvh/WmOw1c=@lists.linux.dev
X-Gm-Message-State: AFq9FYJQfSbVekjUvPCenjBceTxVpyVvY0a5uT9AqpptxrOYBlTEKgHR
	dloBfVGDdu1EolCMpwLV2IwJr9kwUhBvh63qnlvZmcOOZcaA75tJwlzuqhTVwnISJsvK9gLXXN9
	btaagvYt5C0bUq9Rp46Uj1RhgRngKYW+VgwQWgwsA
X-Received: by 2002:a05:6512:2399:b0:5b4:74e2:4171 with SMTP id
 2adb3069b0e04-5bfb00b65e4mr104760e87.4.1792743320286; Fri, 23 Oct 2026
 01:15:20 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261022140048.2522787-1-vdonnefort@google.com>
 <20261022140048.2522787-3-vdonnefort@google.com> <20261022173604.3710390-1-fuad.tabba@linux.dev>
 <atsT4c-JLRSxSreo@google.com>
In-Reply-To: <atsT4c-JLRSxSreo@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 23 Oct 2026 09:14:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw6yONFTYBbbwBbV=YvYC2Wcio-yCOf9WCcvTUKWeav=g@mail.gmail.com>
X-Gm-Features: AclHuK8QRPswQkmU_NO-o8BNrXH8cgfaj9wb0MoWlEnDaWgVTOs_RkNMpHxX_IE
Message-ID: <CA+EHjTw6yONFTYBbbwBbV=YvYC2Wcio-yCOf9WCcvTUKWeav=g@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: pkvm: Fix missing reset of GICv3 LRs
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Oct 2026 at 08:59, Vincent Donnefort <vdonnefort@google.com> wrote:
[..]
> > Could you say here what happens to a guest when an LR isn't reset, as I
> > asked on v1? Without this series, on QEMU changed to leave a pending
> > vINTID 100 in the top LR at CPU reset, the guest warns "Unexpected
> > interrupt (irqnr 100)". With only the EOI bit set there, the npVM
> > doesn't print anything in 150 seconds, since the maintenance interrupt
> > is asserted on every entry. With that in the message, could you also
> > bring back the Cc: stable you had on v1?
>
> Sorry I missed that.
>
> Actually I don't know if this should be backported. I believe it was working
> until now because all SoCs do reset their LRs even though they don't have to do
> it.

Fair enough, I'm fine with leaving the Cc: stable off.

Cheers,
/fuad
