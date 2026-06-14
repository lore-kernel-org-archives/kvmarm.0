Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EDF2FFF81
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781444554; cv=pass; b=uko9uzIWRwMGuYZ8an1n4AF0i7lEhHSxJpXVX1kUtgmcLBYJgjXeVtqRQu/2PCcj1AN9SiLryanCUmmWZuR410iic5qtMPbmDMuHR/l3GfWiky/fdVFqZm6cncwIPtbaUNwjpMrflUGMqgyMXldxKvV8eKt2ZLYzPxUMXSRioo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781444554; c=relaxed/simple;
	bh=GZktqlIc7XCW0YItNOYzOeMsAX5U07cLkN9odjgxDWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QmtGyk96qG71x4VJxDkhs/ajdAJLG8gCmzMM9WxnAIAcqxVzM0icQpn8gEATQD/RwJBhFLzaEnctTmrA53ZyGyQ5opNRf5grKdRF71VWG58b/fQvis7XP4Pv2YnJ9rw3L4uU/gPFG8wUReirnfR9Fi3MmFB4C02RvhtJS8nlVbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ngpqN/4n; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ngpqN/4n"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5177d1ff061so518611cf.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 06:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781444552; cv=none;
        d=google.com; s=arc-20240605;
        b=XvwXz6UI3xLyCmFjgaCQi6Xty/CU7xQ17rBMC7pMOTv0uiFbFVCfIYkKcE4VUXuv6b
         hoxU0zXtEgz4J2T8ykOJgV9SV+irXNwgoMq4dKAiT5wFTvjD0KRXQJTZhG1vXWbA5Uz1
         Ro7sGDgI2bHLAtrfIZVEODiQPkW395j9aVnj4vfTd4Yl/94IFuKSimiz4Rk0mN6qH6sq
         MWFJASmqnXvHf0NIRcUqDI2fCCTJ/JEzCalHcSqxWv3YypLIKtQMyQFdKCY2sL3HAsoO
         UGKjuU+HUjs+C7dWPmU85mngmhrK2DU/br1Hmv4E3IBgfO1wD+ziMxtai1aILPXO5sj5
         Sy3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JLah7fYtiuLTEFemTA3gEAagpPzLuYOeSVTlCpqkCOc=;
        fh=38GrZxIx1Fh+28oEe1/tLmP4tw+QgY2Xd1jmp9aksto=;
        b=c5TXL5Ipyolc/47aOrdwHz2vPTxhmNxmcXZPdJj06BikrmN5DPIHJyYXuMSuEaA67A
         KKxutYq+xtHm87BQ5r3ylEflFYGNbtS/FPCKRALpvqAD29xPteD31uZ3l6MOlht2JX2h
         mjRoqBCR6pvoB0ZCVCwmYJMCVkjv6xV3gwmCdcD2k3PwCqt+W3lzrbOfiulThyRA1qyH
         60DQiqvsClHF15WSI3YFWyCeWFrRxHLnbVFrr5HoeM4viPVRg1xcCc2MoRsrgkXGDe/R
         OePsLEmLzRvFxlcCVkovNivrpMwXUCdtyk1eX1mk2JeVNxyB0u8pj0alq2X0npp876jf
         tOoQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781444552; x=1782049352; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JLah7fYtiuLTEFemTA3gEAagpPzLuYOeSVTlCpqkCOc=;
        b=ngpqN/4nSdZp86chQf4z3VBc2yQ3tpL1jlJnXn3yCN7M0xG2aM2lVnF/5ob786H+9Z
         MfahMDmZ2mU7OtCdlPA8rT5TQy03qUSSUgOw63bmHug5QJjZmtxXoXEDBKPPxknuB4kG
         +nwU8fSaCXGkim3hj6iMbBayLs9yvK2STOx0DFitUC5KUn4O4lIL+zRCvfqKZ3S6reYn
         4lipkty0LlCFxE9vfqdVE8ahT+KXOT2hIDvpddxXM4LjzsJe4NKFh4dJprPNT9fiPOf8
         7x4o1Nu4j00vL6O6jb4Lw+dp06VrgfkkG1uFnIL62DfBH8cU7E5OvK0HOJYe0arMNhPc
         X1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781444552; x=1782049352;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JLah7fYtiuLTEFemTA3gEAagpPzLuYOeSVTlCpqkCOc=;
        b=pklqtxtuMiTuHzNR+4L7xmU/GwKm1JTyz1TVPCGv8E813KtWqiqMJ6u6OfNavvwXiL
         V1rGXaJ4Fz0KNozIEeLJiwn423O/d/Ljhb/0TD6xvRMfwVEANOdpgtpYGFsjG+9+Xili
         YSLYBoI1B7Onar1Ym7guJQ9TxUZ2nf0n987XolyB+OTQLJdprYROYvWc/zJM7jnuWzV9
         1OxBw6C0iLJfJocf7jTCOvUmA9RC0okfvju6kA9JzBSTXmive95hYlmDOXQBSh37r0pV
         UQ7rdzK5eOToXuw9iI/tUGzTYDPlPhkbT0qK393TxDWrSZTBwTvU/OmQSIGfd1EI0yuC
         ep1A==
X-Forwarded-Encrypted: i=1; AFNElJ+RTpcpCiqnw+yrw/LBN5/3l6I4mk3rCAZHUGRXlldh3WUJEF6xqiAov25rC2nITrhkgZv5j/o=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxXgk/KssIR/942bQzX7DRmaQG2ZVk18JTR1fAQ0ldychrwzmi
	ewQZGPHbqRE03pGIDJ9bYWIZDy8C2t/AHwQ8/18UpxPPYeQlMtaHjb4kqgywvCUpPu+SBhMfOmk
	eQOIg4hjQ6ANVxwbjmZgX2dg5DDLhBMMRypCrj+CE5Z5oOxCyvk/dnAoxdUs=
X-Gm-Gg: Acq92OFObnX9Rsl559aG5LjJd+1fOhDavZ+oZRuG/E8jwUXWqjExiRoCSFNwc6LutiF
	H3KJGTbVd3kdT7Wi4hJxjY0b7XwcMBZOS7mcnV1R2iLB2wKmpBr0+FCAZeDU4ENlVlsHp6u2HAW
	QwjZcAz7msnNHqd74NFJ2xOZdPix2hvmgbkPN/JeJV2C5MhlpLFdgRtbAFhMxv0xAmuWZLEqzPl
	HeE3fyZR9aSZfKdDo81Fk/MVQ75K0dKVffywxpmXJYm24QOF40D15NOV0kDMVggOIDdHHZGLUW7
	Jg2Sxt8K
X-Received: by 2002:a05:622a:6090:b0:517:5ac7:332e with SMTP id
 d75a77b69052e-519549b32a9mr10811971cf.6.1781444552000; Sun, 14 Jun 2026
 06:42:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612142245.1015744-1-vdonnefort@google.com> <20260612142245.1015744-3-vdonnefort@google.com>
In-Reply-To: <20260612142245.1015744-3-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 14 Jun 2026 14:41:55 +0100
X-Gm-Features: AVVi8Ce55XY55qGAc1MY-9DTVQT1ODXvHLyZg22-O5uoTZdWRAfvKU2_oGA58AA
Message-ID: <CA+EHjTxSRYnR8wAaaCd=b3KBeTp6reLuKxQKg9XQVdwU+7+1gQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kernel-team@android.com, qerret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Fri, 12 Jun 2026 at 15:22, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> kvm_define_hypevents.h is used to define the kernel-side structures for
> hypervisor events. It doesn't need to be used anywhere else than in
> hyp_trace.c.
>
> Move it to arch/arm64/kvm/

nit: rename and move

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
>
> diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/kvm/define_hypevents.h
> similarity index 100%
> rename from arch/arm64/include/asm/kvm_define_hypevents.h
> rename to arch/arm64/kvm/define_hypevents.h
> diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
> index c4b3ee552131..821bc93ecdd1 100644
> --- a/arch/arm64/kvm/hyp_trace.c
> +++ b/arch/arm64/kvm/hyp_trace.c
> @@ -391,7 +391,7 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
>
>  static const char *__hyp_enter_exit_reason_str(u8 reason);
>
> -#include <asm/kvm_define_hypevents.h>
> +#include "define_hypevents.h"
>
>  static const char *__hyp_enter_exit_reason_str(u8 reason)
>  {
> --
> 2.54.0.1136.gdb2ca164c4-goog
>
