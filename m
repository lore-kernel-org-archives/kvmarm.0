Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1027A12B
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 10:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765881869; cv=pass; b=Pl5kV4G832d9N5X+kMLl8C5fIbUcXQLXEUalf5uejfRAjQf6C9aH+8P1Uuea5TiDyKhH1dla2nJIX7IyDo9HAzmaPJv2jrpmtkwHAB9v7pt22InZ0VlCfgq8dwggjwKmCwo4z8N7OCz0FCoDAXIbVQ1fbzPQ2MGxfxLc4NtoyN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765881869; c=relaxed/simple;
	bh=cP7f2mu/2oIFIpeTf68vgI8d/5RHd41Rdoit1bN2YiE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KCCy0jGEGQZ334c1F76sTBCKcqPL7Y+hCeGVS8NmDm6zDB9U1dbuO0yL6YJZO+pWM3BvC5fhr29cKLj/05dxYKWNk2/eujNVlm4MCC5ioXFZpo2tunu1dkStMaEJtTP9rKNVwQ7DweEkhu5QdulhMsy0REDkiBdZ+UyZEZtXkjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3+H+JmwJ; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3+H+JmwJ"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4edb8d6e98aso367001cf.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 02:44:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765881866; cv=none;
        d=google.com; s=arc-20240605;
        b=OGMsghqA256RFDQJmfS7zhzpssjRkSKAbZvD8F0oEyo0yj6Mq5pALOwK1WblZuDMOw
         PkfV/kXxht3OCRdJ8WFA+QW4+OC9zXVKxC2pIK7ogqpypr1h4KsNZdHfl7LoFGDcbPSv
         8zODgxoRGK3bZ36U+NUnYLpCtpk9cXRbKH+ZnP74440TRu8HoLJtqiZk+uxMca38hh24
         V+lvif2l3L3kUHMAjsDnQ/zTerI5D0I5LPX3RTOB76ac1Oey5GbmcUiALkrYzsYKhlIV
         WAvTg/vECNIxs5pfKTdYgZajvPQsOJuSBu2LfvsSBTOuYA2PH9OK0chll5BN1QSiao7V
         UbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1bLnyMwbJt24z0SAwK1Vw8LDbfVkEjMUM7xGF0eU5NM=;
        fh=8IhdHqGOUn/WDCmJEEs/7WPKhkv9tjkGzk0zCCkuak0=;
        b=f0wSB71y0xwOIaDXjXB4bmR3zWdy31g7CyX99aMnwpisnweYw0tiA92EmGHgi5XfhM
         8lpSFsgI7vpMyZIWKCa121xjIoj0XeF4U8C6DFmLTUVVe+l3qr0cBfPQkd83pARYPxTA
         K9xqX+xKfImCjwpUC5Sj1M9ETT5WhsPOlZfMUjsUHKHOriVjbJTN0HEp0SPVCGsruZ5F
         7OaXE24CmS4JgvIJgVkR0x2PGv5d9BSLBwK97bjUm8Sc+1XF/IYGAKk7bLifBZvGIUcR
         COLwqgwUfgFJz8iWTymf8yQsc13FmOeTxBuScFB7aYTZfmdn0uRBxyqpWI3eAxl7VWru
         Mg/w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765881866; x=1766486666; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1bLnyMwbJt24z0SAwK1Vw8LDbfVkEjMUM7xGF0eU5NM=;
        b=3+H+JmwJxW6ccj4qRj15Rv1mzVqoc4kyZEVNxLdMz8h81g3sYCjMO8+hKw7c+GjbSm
         EoSaChnpKG28iJBC6mQ3nRZz5pB3VNpjCuGoq+gBECd/HZoSyyJXgPz311ORIT2/QuLS
         ErO+118k5SvOjRdQoEAxadWW5xQ2tsd0XxoeOtphcPhiRPNBI7g6xKuo6inZ3dJIcmIu
         2gKBsggtFcjrac3FjpFZq5KmFSHoAGcdhE3BRblrMqVO5TmlVFeaIGZtas7vDUxCuSSF
         FUA0ycrm75q+HC+JX/pt7egWBsYHnIz1WBgq6C2NpfDHcumdBo2EXbQuWF/FuhjWShHp
         CrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765881866; x=1766486666;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bLnyMwbJt24z0SAwK1Vw8LDbfVkEjMUM7xGF0eU5NM=;
        b=h9CBggRLQvuO0XINeywDvnnZd2UMVOuUXmkeCgTlD7tgYcdsQHW6TNnao9+w1eXlsq
         VLOWbKylkq8kLQ16XC6Sgd7469zRpzF7koK9Pka882gcWvagIvszrMKNcIK0+7MvGPD3
         ar86A6opp9DlhcvbkA06LXB9TpfrST7rVz30ZbgcTxR+PZ1FuQzbNZyQ6GJofBlXyRkL
         p6vnVp8Teg5tLuDgC29jzi83pucBPnQGeYi1FlYw5qG8DIvH6V1AOzNiYCYiu1r4Y7CY
         m5lgsQk0xVSd1v5YczukTcFeJZ4ywrID4RPGESxHKwUQlghbPyhBAlIP8JMSCIsph6ba
         qlLA==
X-Forwarded-Encrypted: i=1; AJvYcCU/GhAwTsPrycp6KDUWVvqjL64u3ZuyjTj03DXqbzFMFceadqEhvyMMxI331sayo36dO8oy+gA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdofOiNXQNsEaXtvZ3r0aspb3esn77EZ37B62oNJt6lmgCA9Xs
	xiFqLZ7IIkN8lPD07uaJ1R11WECZGahtXXl9q0L2NcfgbRlRK95LVH/+KHZtrpDa0hi1+mlKplQ
	FAMlHk/SkaAw0F84R/RXQj96Kk7sJlIp7NjVELf+u
X-Gm-Gg: AY/fxX4Y2TJbgUuPkvhXcuWjvR06V/kv0gn7wKC61vc7LxGsQPf2MynsFitbiyd7VNA
	yLgxB7S/MJ9hDNbvvj0MBkGU5S8bwrtN6+h/Os9ouK4MdaBeO5PI3xwABtkEvwiHWqtaqsBjLb7
	+y+T68zryD/PE4NGzubn7HtBEsQEinFvqmB1N4Atrfr9PAdZjROmcLAyVY/+7/6ccX8raoRIiA6
	tscg3hPfOIT119VB9D0ZVaChwHX42kljQbB8hqSOuH618WVwtoCeAjk/O3wtNi7qqNLRALVl+vz
	+/aFYu0=
X-Google-Smtp-Source: AGHT+IHz7BFOmePdPYRRE7Q8kvnfHsJmAEebo6Vy9yk0HTVhVqC7xGkfePdaKQeHq/oBf/Snyives1gg5U33ImR9vBw=
X-Received: by 2002:a05:622a:1802:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4f34c9628ddmr2886501cf.11.1765881865974; Tue, 16 Dec 2025
 02:44:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216103053.47224-1-alexandru.elisei@arm.com>
In-Reply-To: <20251216103053.47224-1-alexandru.elisei@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 16 Dec 2025 10:43:49 +0000
X-Gm-Features: AQt7F2pbPUAUSDN-4yptnwHbXr7-_gU3rXIO--1nsFwFxItLyZ6NRgGtQkeKyrM
Message-ID: <CA+EHjTwoimWFrLbL97nhBsKXAdDdSCrcb__MCacVHnk7Hvc2tA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: pKVM fixes
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Alexandru,

On Tue, 16 Dec 2025 at 10:31, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> v2 can be found at [1].
>
> Similar to [2], when trying to run an unprotected VM on FVP with S1PIE enabled
> and kvm-arm.mode=protected, writes to PIRE0_EL1 made by the guest in
> __cpu_setup() are trapped by KVM and the BUG_ON(!r->access) is hit. That's
> because HFGWTR_EL2.nPIRE0_EL1 is an inverse polarity trap and the FGT values for
> the unprotected pKVM VCPU weren't being propagated from kvm_arch_vcpu_load().
>
> Couldn't figure out how to run a protected pKVM VM, so that's untested.

Hopefully this will change soon [1]!

I applied this to the pKVM/Android stack, and tested it with protected
VMs as well as non-protected VMs.

For the series:
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

[1] https://lore.kernel.org/all/aTMPn0dBbSVUwwJ1@willie-the-truck/


>
> Changelog v2->v3:
> * Gathered Reviewed-by tags, thanks!
> * In patch #2, KVM now calls bad_trap() instead of KVM_BUG(). Also changed patch
>   subject to match.
>
> [1] https://lore.kernel.org/kvmarm/20251215114409.212512-1-alexandru.elisei@arm.com/
> [2] https://lore.kernel.org/all/20251112102853.47759-1-alexandru.elisei@arm.com/
>
> Alexandru Elisei (4):
>   KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
>   KVM: arm64: Inject UNDEF for a register trap without accessor
>   KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
>   KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
>
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 3 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 1 -
>  arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
>  arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
>  arch/arm64/kvm/mmu.c                    | 4 ++--
>  arch/arm64/kvm/sys_regs.c               | 5 ++++-
>  7 files changed, 12 insertions(+), 7 deletions(-)
>
>
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> --
> 2.52.0
>
