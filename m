Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268364;
	b=F++sYvKlTda8FxEE0rtmSfcpCwG+f/zlZYEunkN1GxppMsERGCle5UaJSMzsdUvtSkIR
	 3BDC9tsZ6KtDYc0J5sAov8VET3aWthWsyG1oiqO1k4+GS7eukz7q0WDi51oDnYXoXaAin
	 4cJyfZ37RB13aUe5V/GEo9hVGUQu+ctGAb1JzIqszAuEZKN8s3y0Qs4hWpZynwN5eV3mE
	 mwjJmTAZgRd5wgY8N4vq5QplNWMDm5X0DnWaCPaEAaI7Fv+NAOGfPk/jcuccJ94nvKHAd
	 T9tEve2eBNRcL9pek2L3lUcosqIWf96yIqlWJ8nmAZ5vXOfiu8W/+61TvrTqXtxUgXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268364;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=CwhmwwstFNj5j10OWiKD2vxusMpjkpm5sJ4KEs5Li5g=;
	b=AlO2lRBzXYeoBDASbwPFQQnMy0Oo5QVObYvGycxc4AoxkUrDulzMzvt85adKK2zDhK5G
	 InL0MG6txWyyl7Ps/Qt0fV5etN7ieFPH6FA3JJ+lmGnWEi+MRJAHVBUN6/mqWrnWLTEaH
	 si+EnGhZjIyzhPiNuGO11IOvPl682g5hoPCEAUxh+o+XL4LR3YMdEQTXoU+46uPQzeSzh
	 v2at8LA6NbNLiqqEIOQ1wBQbO6zACFsCJ9U0rSaRvWFuKiVPm3Zu0scF7wI+9Xp6fvuQp
	 ojROv9IUFKEK22DCoacbbY3CcGvIO+YKb8pOa1nPxQYcfH/qfoh6rUG3Sa25aeOXzmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cQq2SEPn;
	arc=none smtp.remote-ip=91.218.175.26
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E7F606A338
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 10:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2E7F606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cQq2SEPn
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=nHdmsnjBfSxwIaneBQeFmfOSq68GBVeIj65sbAMafCU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793268360; v=1; x=1793873160;
 b=cQq2SEPn+Jf/ZWFJatP4k8UfUzMA0vRvsYRQwjOexyPzuuQX0xi2tnTLd4AIVQQi5+INRPZq
 nGVmU6h6UM3d9wY9RtrVEopN9yaihH3lkBvLXjW+gsDeVkA4/x+JYu8rIMD4bZs2PH7PmlqahHU
 teutKOSBGhR3hODSnqEwCsak=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fa188af9fb3718cd;
	Thu, 29 Oct 2026 10:06:00 +0000
X-Mizu-Trace-ID: fa188af9fb3718cd
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5bfca2a2af4so5464e87.1
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 03:05:56 -0700 (PDT)
X-Gm-Message-State: AFq9FYL27EY6LbFRWVmtQg2xa3kClNjjjiT7wFMf7PrwJIfp88kBPAVF
	qYw++wZJ+hGHsstOOvF3XiW4vRkI0OFwxLjYVGhC2J1wDVBxKHRq1WCHBv5HEwXfwcEMXuydD3F
	zUCKXRjRg9JU3tGHLJNIczrvsoJ+d7DrNGtLdlDyx
X-Received: by 2002:a05:6512:138f:b0:5bf:d10c:ab94 with SMTP id
 2adb3069b0e04-5bfd1821c8dmr108375e87.11.1793268355473; Thu, 29 Oct 2026
 03:05:55 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029090522.64662-1-oupton@kernel.org>
In-Reply-To: <20261029090522.64662-1-oupton@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 29 Oct 2026 10:05:19 +0000
X-Gmail-Original-Message-ID: <CA+EHjTz-kXVbzcjtMte8B26f0Undr+kWjF2-d0B8TLT8n03hJg@mail.gmail.com>
X-Gm-Features: AclHuK-zARc41Snck-YLig2gcZHoGmmDIC8y2XoXzzXzf5M8gD2OxXTNVUK6Dxo
Message-ID: <CA+EHjTz-kXVbzcjtMte8B26f0Undr+kWjF2-d0B8TLT8n03hJg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Respect HA when computing translated TCR
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Thu, 29 Oct 2026 09:05:22 +0000, Oliver Upton <oupton@kernel.org> wrote:
[...]
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
[...]
> @@ -29,7 +29,8 @@ static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
>                (tcr & TCR_EL2_TG0_MASK) |
>                (tcr & TCR_EL2_ORGN0_MASK) |
>                (tcr & TCR_EL2_IRGN0_MASK) |
> -              (tcr & TCR_EL2_T0SZ_MASK);
> +              (tcr & TCR_EL2_T0SZ_MASK) |
> +              ((tcr & TCR_EL2_HA) ? TCR_HA : 0);
>  }

Should you forward SH0 in this patch as well? It's missing here, so
the walks are Non-shareable, and looking at the ARM ARM, this would
make every hardware Access flag update CONSTRAINED UNPREDICTABLE
(R_WLTNL, and the IsWBShareable() check in AArch64_S1Translate()). An
L1 that programmed SH0 as Inner Shareable could then take an
unsupported atomic update fault.

HPD isn't forwarded either, although at.c reads it from TCR_EL2 for an
E2H=0 guest. Was that intentional?

Cheers,
/fuad
