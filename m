Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.149
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792673385;
	b=lugRVLt7jFX3TKxkuPY7IvBrSnhSkOKieGeo9OV7Hh6zPKYwf9qM0Sb4LSmSaCilH9QF
	 wyVu6hk5agCrQiw0v/hQ2WeezA50brBbjlt4zLB2AR9PUNrgxi12lZQiG+T3t71gvxSMS
	 qTz9GUbKzbkKAbvGaSQeAwzd6KKeqmiIksQ44uvOijhgGju43sjAW1WXiIIRAR/f/2pff
	 RW7UD1p3Rt9lAk3xxJ+EBcWsCHcZaSWa+nwzFa4B9iNejWILHw8C4VXo+vElvuW+YScKB
	 M2x2rA4ler0EQ1rTZ0stiPu6j8fTKLTCaBVJGpt3KnLAMixuN69CExUEHJKgUT4ztHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792673385;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=QvR2u7W5gGpna7paBb3zjwV+s04vzn7FIqIkuyCNIqg=;
	b=C3RF7gJQEhuz3Fx1ngefTW4W/kbG1/PtT4xugfYRGjqvvWVTU8HH3InhKCkrVSLSnjCq
	 WiTSyT+SnX0kuXbIC7iTSd3MVdNCoQmHAWcCrcUM9aKCO+upchYI5oLiy5RZr5+nNWI0E
	 uMEI4Oqn2zAA/rJ1XbYhswThoeuTGDj40xMI2qCDlRBsDGxYMWyCmOe516g4tiAnvOlcp
	 JXlnn7KE08otXdxeap4w4LG+eZ6mEwe8tTIMuEgP/HW/NHpqVnfRbvpEuue+q2fOS0pB+
	 eOdbsQs4243Dw9P5eMsIArQZCdw+vjQOISmj/hrY5bSNHfrue+3z2IVREct/YlHAZ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Y/L4M/Q6";
	arc=none smtp.remote-ip=91.218.175.149
Received: from mta0.migadu.com (out-149.mta0.migadu.com [91.218.175.149])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A07606A329
	for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 12:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17A07606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Y/L4M/Q6
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=QvR2u7W5gGpna7paBb3zjwV+s04vzn7FIqIkuyCNIqg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792673384; v=1; x=1793278184;
 b=Y/L4M/Q6M5QNb7KEpES0AnWCT7P66K5tncm60vOk+Hp3Z5BDw03iIbZ+7P9hV8M4yK5TJ1s+
 jwEgZyXn0oybQE4U3QWXT+QeDdAKwul5LE2S+RtIXtfnvIiyQj4AMjIfoOMNFEaK+kHPCbKt9WF
 4yaympyYjrXt8TtcGfeUcv+I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5f5a7ad3bd950071;
	Thu, 22 Oct 2026 12:49:44 +0000
X-Mizu-Trace-ID: 5f5a7ad3bd950071
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso6437e87.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Oct 2026 05:49:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwNRCmh/P6tesv3kjjb+a/CLmofaCgcHAB3GYM+VES+95nZhx7NmcpcLQoXd51JSQrPduqYUSc=@lists.linux.dev
X-Gm-Message-State: AFq9FYL6FKFqyRw8Y11uCURTr62zVJVWN+95+7tvxwUOvFC0gCY57pai
	i8FwNzxjXjILjjt+u0Vadpnmg9QzKsLmYk4UWBEsM6vrjZz1F4kU2bfgUiznZiaxvM4NacEjqzc
	Rc1qlxUaCuk/vuWd33s1yFdb/wtDPptVanFlPVylH
X-Received: by 2002:a05:6512:10c3:b0:5be:58ad:1ba4 with SMTP id
 2adb3069b0e04-5bfa8491692mr166044e87.6.1792673378383; Thu, 22 Oct 2026
 05:49:38 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261022100319.3046476-1-fuad.tabba@linux.dev> <86ik2uymnc.wl-maz@kernel.org>
In-Reply-To: <86ik2uymnc.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 22 Oct 2026 13:49:02 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzo+NoM0m3cjuVGW0EZjuzRt3pJvwFC5QO6=g8AYTC9pQ@mail.gmail.com>
X-Gm-Features: AclHuK9FL-kWa8J9l8GOe0KfCzxWBz-UvvDfr9Sh7jKLeEaBWko1cn9SH2Ay8_A
Message-ID: <CA+EHjTzo+NoM0m3cjuVGW0EZjuzRt3pJvwFC5QO6=g8AYTC9pQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Don't WARN when L1 sets IMO and FMO differently
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 22 Oct 2026 12:56:07 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> No. Either we fix the bug, or the WARN_ON() stays. There is no
> alternative.

Ack, I'll look into emulation instead, after -rc1.

Cheers,
/fuad
