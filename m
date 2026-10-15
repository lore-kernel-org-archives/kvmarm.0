Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249BA50AC16
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072843; cv=none; b=tur095nOAmYXWGrCV94Eb6OyTTJX/d6IFnZ1qoPy7tB/4rbR93kbEaN63fMzGXXo58PUThr1t7NanpnW5y4dqr+COKSQXdjerIPg8m6TzuVQGHZ2U1NY8IJhi+N/YTGZo5bpssd7/bVPetdhVwP5jEdQmnjWHpzHziY4UpSJoZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072843; c=relaxed/simple;
	bh=6Ntld4Igh2eWgn+gJwrpP12iCF/OrSpwwkSoEGWK6QQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uFQE6jzelmpVsLLIj/HFRycYTCKY85UJaHQQZlf9qULdNkzDHlyXU7cthMXabC166y1tHKKCizs4R0N0RPPOL/i+U3gyDfk/pFJdktwBpGYzj4gg2WMjZ1XhJQjqmZcxAi6babLd9NlWHTjLSye6zr/i9h9LkOQ/YCdntpxLUh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DVwpF+uT; arc=none smtp.client-ip=95.215.58.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DVwpF+uT"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=6Ntld4Igh2eWgn+gJwrpP12iCF/OrSpwwkSoEGWK6QQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792072839; v=1; x=1792677639;
 b=DVwpF+uTYPBQ/hyBGF5FXq7n57tFcOhgyXMJPQXHOgbhu0VW8fdzYFCDcI7yDbXTDHQKmgdq
 zr9Yvg5Ah8WnSQ1vOkyoqViB7mENUJIyNTo8Zhu9k/Vrj7MGxTbYMcfu5ZTqW9dQehmIhvcCEce
 lzPaqrcUSmP01q9A2IPj3ji0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c1b121afdcd2b8cc;
	Thu, 15 Oct 2026 14:00:38 +0000
X-Mizu-Trace-ID: c1b121afdcd2b8cc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so6237e87.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 07:00:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxAbN9TU58Wvn9Dy4I8qonVHdIc//Z8y5MPGSgYF43k+xiuIY0NlI2UEfLebDvBmgDpbeCH1TQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYJiI1pPk1rKPPC3YT4NAJyZokSVrtivTXHVEeIcBk2oMiItMRFx
	Zqa4ctztY5RISy4EEmw7Pm3+57w7pmR8v9I+Pn7wACpQpkIu3BPME1VShpAhCKKDX12+GBjQThX
	nT6DAShi6bnc2476ZekOb8Ga6MBpYwYcxwqTEjvoY
X-Received: by 2002:a05:6512:3196:b0:5be:3607:3a97 with SMTP id
 2adb3069b0e04-5be3e077786mr116198e87.0.1792072832985; Thu, 15 Oct 2026
 07:00:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261015100539.1011760-3-maz@kernel.org> <20261015125713.2650696-1-fuad.tabba@linux.dev>
 <86ik33137e.wl-maz@kernel.org>
In-Reply-To: <86ik33137e.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 15 Oct 2026 14:59:56 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz2nsHkYkXOprZ9obYmTQeKrcue1S686CwCjWvLhtjmvQ@mail.gmail.com>
X-Gm-Features: AclHuK_p_jA27OTWFMOxJa5ERUC2ySPYnnuaQE4YLlcy6i2zl-d3p83lu3UB5OY
Message-ID: <CA+EHjTz2nsHkYkXOprZ9obYmTQeKrcue1S686CwCjWvLhtjmvQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] KVM: arm64: Move OUTSIDE_GUEST_MODE publication past
 context being saved
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Oct 2026 at 14:52, Marc Zyngier <maz@kernel.org> wrote:
[...]
> I don't really want to make this vgic specific, as there could be
> more. But I can more precisely describe what state were talking about:
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b46fafdd3494..7ce9f3bfa7fff 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1390,8 +1390,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>                 kvm_arch_vcpu_ctxsync_fp(vcpu);
>
>                 /*
> -                * All the state has been synchronised, let advertise
> -                * we're outside of the guest.
> +                * The state that was pushed into the CPU on entering
> +                * the guest has been synchronised back, let's
> +                * advertise we're outside of the guest.
>                  */

lgtm,
/fuad
