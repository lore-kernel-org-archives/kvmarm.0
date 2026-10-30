Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.75
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793358266;
	b=TfP8TbpK37aVqPEJjzS59CUaEhiAJ/tH97fk+zg6t+4lqhj2221sWYG845Y0GMbLKBYF
	 wfieG8Z49Lt8KSgex+x0/1ptOs2BIPSzaQo1DNcLEubcpgE+lMw2r2HGVAfReCumUPDS7
	 Z22GJ9C7c90Q5LQKgvhcxJbfoKzTFeZNraeXIDKvdGn/L6iXLzL8mhcJ/lY2Ek6XG2lHT
	 vh2mNpISH87abPU/192OpcFYqayWHHydQhNLk5x8Zii1zkvq897x2Gq01rRxEkTnsluMX
	 sgo9aJz3z7uwt/y7uN3eDG4IkwUMUsdHDR3USSgfhWtuYfQkk62wbSCkArfVJWI84QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793358266;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Gm-Message-State:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=fvcGFYgqB3GVPo+Rt2PaeXa/wfSi2Kzem6/zERsM2nk=;
	b=OvwFe0a2wJbdBtDguuS60NLsJiRs/67jrjkYjNTpYKv3T4B7f1hwDakHsdK+B4SQwqXA
	 CYk1lRR7Gg9HnHLRaJjpzLJupdx7AB6PBLmXJZpxzWF6Kg2pZ9hcwx6KQcHEWBD6xLbUb
	 Io7rz7icHqMmuT744U7kAKtJxIylV4jLilzIK+OF8K3T6lvl0ir2J2m761m+DUucagEHA
	 Koe6Z7ggE7zbUCzGAoP9L1j+sIl3TcApdczopCzqpeFUJaoFefVlLcTtKv0NnqYQjoHJE
	 GEshLfa+J07kZFjkhCsUTKAYuuPcpAKkkWetnBh2m15FucaCvQINphsXyVRv7MP0kpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Nc2cJ5xr;
	arc=none smtp.remote-ip=91.218.175.75
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0865E606A31F
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 11:04:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0865E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Nc2cJ5xr
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=fvcGFYgqB3GVPo+Rt2PaeXa/wfSi2Kzem6/zERsM2nk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793358262; v=1; x=1793963062;
 b=Nc2cJ5xrwj8ulVCs7IUmIH/I0VpFt9daKNIOeTo23HWpXW0wTMGcacZOwYsS6KJ7PDR5EKgw
 L3tQ4TBYp25+1i0vX1KuYmVg0ZJ+e75E6CTnWM13vQiqJ6SUkp7u3lFfzPuNRAz+m2wMA8+BP8V
 a7MP5FYfQcvV3gUD2tm5lcR4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f084fa5ca3f15207;
	Fri, 30 Oct 2026 11:04:22 +0000
X-Mizu-Trace-ID: f084fa5ca3f15207
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be3b2f17c1so4645e87.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 04:04:22 -0700 (PDT)
X-Gm-Message-State: AFq9FYKvwxdyV93+HouzwUIFzuQHpiJROFxVhobXemrs85GUGXwMSy8g
	z6mvqIsJHWV2AIMg8C9AtmNctVwVbPxBiuTodkTsTQEPWljBiB4bxX8rfQfsbZW3kygoaJYeb86
	v/OUGxMfKXQhxjt2gA5+Iodw+tHK7KYDqnOsIC7ch
X-Received: by 2002:a05:6512:118f:b0:5bf:c2cc:a8f4 with SMTP id
 2adb3069b0e04-5bfd141c99cmr359766e87.6.1793358261575; Fri, 30 Oct 2026
 04:04:21 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029223732.103785-1-oupton@kernel.org>
In-Reply-To: <20261029223732.103785-1-oupton@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 30 Oct 2026 11:03:45 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzPK75GZdYq-th3wn5fSZ_GFwgN=vHYsWNoszaCmp-WcQ@mail.gmail.com>
X-Gm-Features: AclHuK9P5Fb6hDdNlEoFCsuMJZFSVwtBXU51ha56Pr6qOtEHQcEFMPmMrNWd6SE
Message-ID: <CA+EHjTzPK75GZdYq-th3wn5fSZ_GFwgN=vHYsWNoszaCmp-WcQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] KVM: arm64: TCR_EL2 fixes, FEAT_LPA2=NI for NV
To: Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>, Steffen Eiden <seiden@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Thu, 29 Oct 2026 22:37:27 +0000, Oliver Upton <oupton@kernel.org> wrote:
[...]
> Tested on Neoverse-V2 running a guest with FEAT_E2H0.

Tested on QEMU, booting a guest hypervisor running with FEAT_E2H0,
plus the nested at, hello_el2 and get-reg-list selftests. No
regressions.

On QEMU's max CPU (52-bit IPA limit), the E2H0 guest hypervisor's KVM
init doesn't complete within 20 minutes, with or without this series:
on every TLBI ALLE1IS, KVM unmaps the nested stage-2s over 52 bits,
while the guest only sees 48. I've posted a fix for that [1], and the
testing above was with it applied.

For the series:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261030105139.3543230-1-fuad.tabba@linux.dev/
