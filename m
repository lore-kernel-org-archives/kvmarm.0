Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97632DA762
	for <kvmarm@lists.linux.dev>; Sun,  7 Dec 2025 05:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765084466; cv=none; b=AWDrcadNGWCfWdIdE4aJvp7+H7SzCfsGrHLP68+Q6lcHE16sb0tIRPXHuGGJbswm7VL+Nw89OPjT9cq/r2KBCEOb+MmU5E1aX8P/qgmGWLmJ0rV9ugoD/KqCqExXBmMHfLefRQNhQ5878j56//toE9ENuV0bQK1UiiXdHn8tp34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765084466; c=relaxed/simple;
	bh=RLy871nN+PF6G/1eKPJpSvOsrDqcrcKVOdz8yZpUqkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sz8lAbEtUpWmNEl1rMqEtRu0mx7mpmLrqk1SpA671axe2wiS4v1Muv71eB1mk2JZwbSaGjIfXFzIGdUoVwgDeMrdoz/6GbIl7Ie+Gep/UZyIi3yCgNZJsjt9nBM5TBN2Y43BSbkRghsLCRyNvtnVDnD8vFiNamkENM3oUjqph1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=VqXlN0OC; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="VqXlN0OC"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-65745a436f7so1893340eaf.3
        for <kvmarm@lists.linux.dev>; Sat, 06 Dec 2025 21:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1765084464; x=1765689264; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIr6vMU+1WXTpE+kuQ5XIOvR7lhOKuME2h0aehuNw7U=;
        b=VqXlN0OCnI+KA2oE9oTaRfHwAP7JNT9yquQ+kB1Wq/i7VVn508+C/mAO92xnijTHGR
         /7PY5yIkuViY0R+/nKwrXL5/UGY2tuwamAJgsX4kHV1TKI2Qw22MbFQvv6rozgPBvDOZ
         l1TNJ1dyVaFfLl6G9xh2jD6Yw1pTDaAhWI84kqhx4HQwXS834Lcckp2mdr7qg2fTu1Xs
         7GOXh7ZupdBMLxEEGSA71Ioj72rNEqB//q+AbO0d85vXTafoRZZViKWo9MubarOkf18H
         Klum3Ib97lJOZoxFk9k+VNqxNlYMV7pLZL7VENQDpa4AtB/dnovTpBrD0sI1ZJJuENkD
         fUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765084464; x=1765689264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gIr6vMU+1WXTpE+kuQ5XIOvR7lhOKuME2h0aehuNw7U=;
        b=Sq7HvsAo0Bw+LmS4Ru8mgtWQyBdveuWpmIbb0vPNKhAJLhhprev62M6E3Yg0qn0pIH
         8i7E82O76gOUjszoH5N8+6dliMy0CAMNUpXKLIkeyl3UHZtfT+k5cw+ixus1CaImjzUu
         HodYLl6UsFuK7k6AkO+IPwBNv0P8KcLP/oTQwGqIMmk3bKnUed8PDmpbWAsiSa3bWV2Q
         CAcu9/y6hIdooEyCckzof9rhS2owq2S2qc9VkmAUE+1mn05N2WfTqOmwywCg6/XqTCBk
         SY7IRM+D7/TLqzzukuwA3/BUGTpl9HYwhs0IFHJfh49n2y0MpmZnS45QanEoIJw7I78D
         kk9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVJTxjuGpDYsFGk2jui0PtEwskK2IbKwDDE8YIrIwrihnteTQdrupzBefmXwADQHxugTGRQwz8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyR6oI80txxg3DhZXCQdIJUmeHIrRtsuCTXmHlZOLOvTkCPpo84
	GaKNyj9I4hagPVU7ozXtJbxV2t5J9VyepujsdfQZSx579+vuydev7TRIIwmj9XjLsZhzak/bytS
	yBup38lVSJnulwSMyvQpm9K+pSpbSB5Zlphva7QGO1Q==
X-Gm-Gg: ASbGncupIENA7fRGluBlo669iMbJFWTIPgmJWHpABvb/YOwhhiWkgn56W0dnG46UWSh
	Y+syXDY/Pvo0F1bD92EcC43hcMyImRs3Mr26pB54I26AfLCgpRMeqd1BxFaDmhVeNtShcNx5NcQ
	JEN6u5ussFIvK6p5MUqiQ/PblEOZWKEBsmhwQ1dlGB0NIlDk+Z30xpuOx1CHGGH7iZCKywGmZUq
	hf7FMshRlroT699CP2GjEMMlNM/FXq7+tI+DGvzGTrBZsoKImZYFDtrKzf/Vhg0V0xgulNj
X-Google-Smtp-Source: AGHT+IH3teezYiglKMW0l9sCwPDXKzHK/uYMVzLl99zBL+8tY4BEmXzPQzc7f6ucWRYnVm2fOg07KrRcgASdUHrgci4=
X-Received: by 2002:a05:6820:f030:b0:659:9a49:8f73 with SMTP id
 006d021491bc7-6599a973da4mr2018657eaf.56.1765084463840; Sat, 06 Dec 2025
 21:14:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251205232655.445294-1-seanjc@google.com>
In-Reply-To: <20251205232655.445294-1-seanjc@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Sun, 7 Dec 2025 10:44:13 +0530
X-Gm-Features: AQt7F2qP99gde5P8lRQoinF2DOSDMpaUpigWBx6hvnDvXPL66vGpk9e2egXMZ2I
Message-ID: <CAAhSdy1cPnxjntaR=cwZqG+oVgFpZKM0rKYAEdkHUCToMvN0Ag@mail.gmail.com>
Subject: Re: [PATCH] KVM: Remove subtle "struct kvm_stats_desc" pseudo-overlay
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 6, 2025 at 4:57=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Remove KVM's internal pseudo-overlay of kvm_stats_desc, which subtly
> aliases the flexible name[] in the uAPI definition with a fixed-size arra=
y
> of the same name.  The unusual embedded structure results in compiler
> warnings due to -Wflex-array-member-not-at-end, and also necessitates an
> extra level of dereferencing in KVM.  To avoid the "overlay", define the
> uAPI structure to have a fixed-size name when building for the kernel.
>
> Opportunistically clean up the indentation for the stats macros, and
> replace spaces with tabs.
>
> No functional change intended.
>
> Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Closes: https://lore.kernel.org/all/aPfNKRpLfhmhYqfP@kspp
> Signed-off-by: Sean Christopherson <seanjc@google.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup
