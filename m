Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07B93859F8
	for <kvmarm@lists.linux.dev>; Mon,  2 Mar 2026 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772458902; cv=pass; b=JC7nlOMgz2yJaKWaBjLi3Ndk6J2NYpYIpvW9bKMSk9kEjE9qo77740TFZoZmu7jI0uf/LIR5jDQl1CXW4jzDVbiAHpTfe9X0ONclBdOpaXsxgapD8zulMd4+OaZODA+GT2F0FmUCr7AGoYmv66KegHTw4vtbMTXLKUJHDuYz37c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772458902; c=relaxed/simple;
	bh=PXl4fmRf4KFTLlrWb7QquzM24DQAq44eUvg0F+thef4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TrbY98vdKkaG9BVBwu2dY8DeyniijpzVTJP0+GrxuKPo3/KHRwJaABKZQC1sAa8tDo6FND26yriZi7T9W3Ol1iRTkayvROhD9NcEcpQaEZsm9niu4siRa3b4xtFEqxh2jx5ayRVT4P8662+0M5ZNNZZuPpUsEuUtmt3ypoDOt+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DIaCsSTj; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DIaCsSTj"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-505d3baf1a7so946911cf.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Mar 2026 05:41:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772458900; cv=none;
        d=google.com; s=arc-20240605;
        b=bkF3x9wvvb0szJquf/Aq1sZjA3pHMNajPDoHxeSQG0Lr3Ng8DOlEEtIdHyniOwRrew
         wilm6CvmpPpJqBQhVuadFUeY/eTdwhG/qM35a+sDdn5cUpNIFjOiYB8bDVv6zM5bp5GL
         lrAO5xONQ/l2cXMu9fHWvWQx+poCUMtpZge7EtJPPcCUjTpKd/8aKMiGjz7pM3M3NM31
         lpvyk83Oqps9i7c5wC0BzHrpj6V7OttKM7P5J5gfqixXihdvddVnsAkJWCoo9litibIx
         0Dq8HUBDBQK6kHelEU2taiEfnL5BWhd5BcaHfLTpxWxq+Sl+yZZXTte7UOuCJVCIiEdy
         XcCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NYsmRJcAcMIsFoGcScC1fEs53MfSGQkBZ/HqjJdD1do=;
        fh=E36nwdli//4ABVw8JOU+9AX1y0NHgD/Z3hS/lSV7yjQ=;
        b=COEPD4RdtVgINPwrmz+5YZe9kVLkw03Pm25w8mv4mpxafyVyLKyc3fFZYq56ndnZEN
         InsWyjhcptzFrlvjAU7pOrVCI/czqhJCy4cBQZpDIN3F5VwwIZoIz084hoMMq8gpsN+O
         mY/XbB+3md8Nya+mwIklTQwP3tOUgXjxPEHVLeFjBurkQR9PZZtHocR4MvB0So8sQza1
         /7cipCtR8BcONZUwtPQYXalFMEHzAelJvsx0rH0aj2kJ/mCgUkSx3oYtiEKeD1n8SmZW
         i+C63J4s6HzvxtQGFmChAzCfKDpjT+S31NsJtFQff7QRb81rjX7RxJtH2mgqkvnxSkB3
         BQGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772458900; x=1773063700; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NYsmRJcAcMIsFoGcScC1fEs53MfSGQkBZ/HqjJdD1do=;
        b=DIaCsSTjJKFyTXGiHwJJquB6kGUSOby+3dgu+atNcam8ZGGC3PhaXOuZlY1UVBsg4h
         O26gOU5a6xVpWEGmQ9GKhJIgBuRXfJR2M00q3T1c0+JQnhZXnlsWxnhqQQAXVA6vi8k9
         Da4GofRL/GlxPiH3MIfafAE7Zr6AzIEjOAZWatLRtw0xbkvvQxFX7p2y0E8O8Cv3apy9
         7mF9zzIywVNR1o+Z9xjhdYWTt9vlxjF5aOVwxtBSC5Paf8KnCYluLt3VtsxTiZImwhz2
         Qi4CAZH8nmZmchK1OPNLPOHaqo4hn7UKgfb5szy50KzSfMWRT5RZX204VcUa+Vfnd03m
         qlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772458900; x=1773063700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYsmRJcAcMIsFoGcScC1fEs53MfSGQkBZ/HqjJdD1do=;
        b=Xf0GOlTuYx+COSe2CrulVnXYkH5Kl6dfX9wktdS6SV6xlsPNSG7TbNMnpQLCN7IK02
         qAYlxrc+gV9JQUzDFzSsVr359SieeYk3a4hTRfDfgdd24wv50kV+iU+XwsIGos6oXO0h
         JaWcr6yaF9/VGm22FpSbNuy/lsiuMyf2NIUXXRPaS9kv0iW91UtV4AfZo4mmu6KI0WLM
         M+MoxvIkbLfjWDJNcF8ClWfbjeZ0jp/Z5H/qKy9Wk6TIFx1s+V0IU29gjb5sdUnmucYl
         gwDlnWczrqNXqRN3ASEzMWQIa05obsEGqMs3plDZBYjiwkZkhhat7/jUY3PLhcAia6qM
         vMfA==
X-Forwarded-Encrypted: i=1; AJvYcCVGj0hYk5g8iklXp1tJJl1eaGiNsr1Zm0MtoqyzVA6XQRZrHduUemZswYxLVESRsmHPSL2ySTs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFBHrTUPYopKIf+HJ/LbusJjNl00t/oPswNndZJqFkrnClI48Y
	apNdlRMJlbVpOTg4qjxw89aw/dSTatm3ARL2aAmgtxENpgzT226umnYVxCv4BceHCgxhWV4zgD8
	+c93Kck5tiyN8uIKOXT6QzY1sk/ZOlKcqcNMtdVxO
X-Gm-Gg: ATEYQzwL5epeGNI7rhxGsSbsH8eiBHHgB81zxUnmNvk5ZeQ0g+G6/M6UQ4leJTJ6LRK
	ESlxgY24dq/vRAc7DueE8y0RbiK/HI4T8/TunTadAMgWLRw5rVth67URLZx+/m3DLcppYuJjkca
	AkB7iMazJgTZu6E0hJhdS0l9q5NDvXZQlp96dmXzf2NLUmNVjeXeDurykuZNW8gm3caiccVW9r7
	MVqULMCScWrvSIMbCsnSbmdrXN5YWTKuszPAYrd5ij1qGmtsoZgaXGZAUEP4Iww1RsqYUh7IVpw
	xtb3GW/3
X-Received: by 2002:ac8:5746:0:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-5076186e697mr19981111cf.19.1772458899149; Mon, 02 Mar 2026
 05:41:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260302115653.1517326-1-maz@kernel.org> <20260302115653.1517326-3-maz@kernel.org>
In-Reply-To: <20260302115653.1517326-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Mar 2026 13:41:02 +0000
X-Gm-Features: AaiRm52IOKVuzwHscJ5ASw0VIGWLHTbRWdjOZ5cjYVQDzmb7A0iR2ZLSC-C0T3I
Message-ID: <CA+EHjTyjzHu-b+rnkj6ZkJjFABtT-pHcNvK9McNESpL41Y7ZKQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] arm64: Add a helper setting a feature field to
 its safe value
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc.

On Mon, 2 Mar 2026 at 11:57, Marc Zyngier <maz@kernel.org> wrote:
>
> In order to make the code more readable, add a simple helper
> setting a given field to its safe value, and update the only
> user so far. More will be added later.
>
> Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/kernel/cpufeature.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 28fc77443ccd3..102c5bac4d502 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -926,6 +926,11 @@ static u64 arm64_ftr_set_value(const struct arm64_ftr_bits *ftrp, s64 reg,
>         return reg;
>  }
>
> +static u64 arm64_ftr_set_safe_value(const struct arm64_ftr_bits *ftrp, s64 reg)
> +{
> +       return arm64_ftr_set_value(ftrp, reg, ftrp->safe_val);
> +}
> +
>  s64 arm64_ftr_safe_value(const struct arm64_ftr_bits *ftrp, s64 new,
>                                 s64 cur)
>  {
> @@ -1066,9 +1071,8 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>                 if (ftrp->visible)
>                         user_mask |= ftr_mask;
>                 else
> -                       reg->user_val = arm64_ftr_set_value(ftrp,
> -                                                           reg->user_val,
> -                                                           ftrp->safe_val);
> +                       reg->user_val = arm64_ftr_set_safe_value(ftrp,
> +                                                                reg->user_val);
>         }
>
>         val &= valid_mask;
> --
> 2.47.3
>
