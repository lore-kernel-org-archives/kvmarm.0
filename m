Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227A053C3B9
	for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790694695; cv=none; b=qAEzMFBnihnTzzQazchTG0OI2WvDDea8JUqqXlf+Qx4N4NvY7lDKJbBmlVkq5HBL5n211Qxex3CE4y9upfrI4ipIK7ryktT7oj49Iddo5Q+Fbl6E6YUxw4CIaywapV/0NxMj1hPncCjV9Xu1h/8vqt/grQXVx3hRRZhJ+MC4Pas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790694695; c=relaxed/simple;
	bh=Guq7vvdBrs+2LAbftC06J/zCNpDu/2cevbftm5NnBUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DxADuz7kW13BwWzFevXJbr4W6TSi1Kd2jGFPhwmPHGCCrhKXP4cK3FsOgfALFTaHonCwOnZ0mW2zWjmi1vTlIr3CRsGxCQ+wS8sgj4E4KCEbjhsXtN0JrTx8lqEj/GOg5GucGFu4CWR2bGU012qsGqeGzhKX4e2k12D8EBx9faw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dyJ3YK8Y; arc=none smtp.client-ip=95.215.58.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dyJ3YK8Y"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Guq7vvdBrs+2LAbftC06J/zCNpDu/2cevbftm5NnBUc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790694686; v=1; x=1791299486;
 b=dyJ3YK8YiZ9ssznua/WiL+hfWVWWe6RKwSsnfrP1PCOKJ0J1CCSunUoomymOVHqAo4lk0GQQ
 UkxAJptjHU5kxe4lnOdodgKJxkGHgLWpdCDjPuJZT+8A9i1YF9bCN5mONFyO40pGu4hsudmsSNS
 C6IMO2XMPKzfzWWkx35BEMIs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9d1a381991e6242e;
	Tue, 29 Sep 2026 15:11:26 +0000
X-Mizu-Trace-ID: 9d1a381991e6242e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5b8f42bb8a9so8175e87.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Sep 2026 08:11:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxYG+pATUZTg8QSOyFg3azd8EQi1BqgmG+lFM83MVycSFGNXN8TeH2skOI5jWfkaGNh+2ilyhc=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ0G8yaXRL9yE8vEPvCwAT0pD0D1ycMIc+YqMEz4aLG3mmrsgjx
	vZ83R3jG+EczJEVngpDhmBY2zxnldx8/g07iUtLZyhPDl/nOuK+cpnDHdJomHYTVpC9doyWNXO/
	WbF2K76s6ZdHyAWHNfE4r0VZwv+2z+lA/iqh7hNn8
X-Received: by 2002:a05:6512:39ca:b0:5b8:eb6b:2a62 with SMTP id
 2adb3069b0e04-5ba2e7e1189mr155370e87.4.1790694681036; Tue, 29 Sep 2026
 08:11:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260929090031.3829185-1-fuad.tabba@linux.dev>
 <20260929090031.3829185-2-fuad.tabba@linux.dev> <lfkiqqw72uqjih442pozc3gsydxwmdj3kacgl7c2572kxzx3sf@vivqilohtwqn>
In-Reply-To: <lfkiqqw72uqjih442pozc3gsydxwmdj3kacgl7c2572kxzx3sf@vivqilohtwqn>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 29 Sep 2026 16:10:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwrOhVHQ+Kv2dbimsZknRttscwmr+nfurgyL31hzxVwwg@mail.gmail.com>
X-Gm-Features: AclHuK-bF-Gg2TRO1voI3bbJx08FqrvL74I7XxHF_wOtMWk4sUktlPjaZGhwxI4
Message-ID: <CA+EHjTwrOhVHQ+Kv2dbimsZknRttscwmr+nfurgyL31hzxVwwg@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: Apply the fine-grained UNDEFs without FEAT_FGT
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Venkata Rao Kakani <venkata.kakani@oss.qualcomm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Sept 2026 at 15:54, Wei-Lin Chang <weilin.chang@arm.com> wrote:
[...]
> This reads a bit mechanical to me, can I suggest:
>
> ```
> FGUs don't actually require hardware support, so don't gate fgt trap
> config insertion on FGT. This is the only action required to allow FGUs
> always, as kvm_calculate_traps() already computes the FGU bits with or
> without FEAT_FGT.
>
> This also fixes a spurious WARN when a TLBI OS is run on a guest in vEL1
> without FEAT_TLBIOS on non FEAT_FGT hardware. In this configuration the
> course-grained HCR_EL2.TTLBOS trap reaches the handler handle_tlbi_el1(),
> which expects an EL1 TLBI only from vEL2. With FGUs enabled the UNDEF
> will be injected without needing the specific handler.
> ```

I cannot write commit messages! :) Thanks for the suggestion and the
review. I'll reword if I respin.

Cheers,
/fuad
