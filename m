Received: from mta0.migadu.com (out-96.mta0.migadu.com [91.218.175.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDE93E121A
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790623067; cv=none; b=eHNVks4SYvzoFUjqdoQs5iGDRMatAIZJh7MwsgkQXXI0qBgWPbmj/JpdGysfee7g//f2upyZgU37hzAZXkBviihyyL1Y409aq0hUdA1fD7QByPt3ptl18D9jMm2u0bJxC1hO2pzCp4w7mO1K5/Q6BoigHAJkMopYOGgolMsFpl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790623067; c=relaxed/simple;
	bh=4aE+Hss1/Jbe7wEGLMDMGvYVtcJjmEg9Q79wOsQKUHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HyhRXJTxkpJ8IX+vg3p56rur+WHzLt3OJhn9utcEfoMmDkpBDpCswdcH65M7osQs6Bfdvu6r/8VlO6j0eBKgvGcL1IkJFBUQ+FBOr9uHToDAiwwFc1WzHEj3HN1vNq3l25Vznc99YUeUEH/Lzt1AMDJPZOQujtGYlRoKV482fxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g13UdM3b; arc=none smtp.client-ip=91.218.175.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g13UdM3b"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=4aE+Hss1/Jbe7wEGLMDMGvYVtcJjmEg9Q79wOsQKUHY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790623062; v=1; x=1791227862;
 b=g13UdM3bOFbKg74HryOu/toca11ir8lv3s2ixQkXbgALbbr6OEOJHlbzINr2Wzv14ytFdQc8
 MeZaAW7k622VSoRXfN1HWyS2m7dive0ReKgC71BOmjsPNdWi2520dbs1r6S5r1szmjrvNKZ5uWk
 QISIhrIENTPkbG9HQ4iFeAWA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d02afa55e4f00786;
	Mon, 28 Sep 2026 19:17:42 +0000
X-Mizu-Trace-ID: d02afa55e4f00786
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b8c42da963so1654e87.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 12:17:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw4pM+VCibAYroeQYxqHEYXeaDnD4iGMOkGccVNH4SANaWFTZbo9n2LqvwIQqVBwYKvF+31Ptg=@lists.linux.dev
X-Gm-Message-State: AFq9FYKgrvPgOlbixDnAXlKpCmHYeul6oBLyB8HlC5N7fT6BS5fNfa4/
	J1q/Dl7J/CaM5K60GI8qkesrsTdbwrd8hEPL8SlhrHul6AZEUM3LqaW7YqvkSMcAPYLs05b6Gmi
	sRH2xEP2GQCi8TpdPTZXPEroKs18yHMc6RCbPmTdH
X-Received: by 2002:a05:6512:65db:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5ba2e78e166mr10617e87.9.1790623057450; Mon, 28 Sep 2026
 12:17:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260928064643.3265087-1-fuad.tabba@linux.dev>
 <20260928064643.3265087-2-fuad.tabba@linux.dev> <arqeRSIoEwurSrya@kernel.org>
In-Reply-To: <arqeRSIoEwurSrya@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 28 Sep 2026 20:17:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy1rqqBGW_jiBwjdg1b6hphE1KwqvS1i5SDM040d5Cbjg@mail.gmail.com>
X-Gm-Features: AclHuK_rws_wTRAdrWEqO4myn_hhtXgz82YRIViNS-gJjlNQ2cw7YcPYJoEgtSM
Message-ID: <CA+EHjTy1rqqBGW_jiBwjdg1b6hphE1KwqvS1i5SDM040d5Cbjg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Don't WARN on an unsupported TLBI OS
 from vEL1
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, 28 Sep 2026 18:05:09 +0100, Oliver Upton <oupton@kernel.org> wrote:
[...]
> So the FGUs don't actually require any hardware support, they're just a
> representation of our UNDEF emulation that can be applied even on
> non-FGT. That's actually the way we had them wired before the whole
> config.c rewrite.
>
> Can you look into reinstating the FGUs?

Will do. The FGT entries never make it into the xarray without
ARM64_HAS_FGT, so the FGU check in triage_sysreg_trap() has nothing to
match on those CPUs. v3 drops that gate and leaves handle_tlbi_el1()
alone.

AFAICT that skip has been there since the FGT forwarding
infrastructure went in, before the FGUs existed, so I'll write it up
as making the FGUs work on non-FGT hosts.

Cheers,
/fuad
