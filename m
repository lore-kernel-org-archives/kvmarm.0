Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015786;
	b=2sFxdWJsj1CDnmE6yur5tPXsnGa54eQ+OvAoKo0EixuQKYa5CxqP0EUwGMY5gfUiBpwg
	 LyFOmuK2mQOM8kZ+MpHHG0qymvEtkYih8kcuLd8K1Rdy7Km4LIg7OkTgTJJxS4Et4IIA8
	 Z/rgpYIL5X5TagjpZlJogGGrfMDuS3+/eo9UlAJ4mFD+WB5HDJy/W9TWLi2/UKxOQMJhd
	 gP/OF7gahhOdlapxtDy6vR8d/eoehC+J6C25Suo39FwhZ3oAp+1t2BZ74CNmPE9rRTI2Z
	 kY477Dgjhnuww3aww0HmGUfLU6KXTRsUA9Xp/2nhS3OhYh3mzANY5wsGHNEafM69C/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015786;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition;
	bh=RbuRo9+4LwWGk450hUbm5Deje65UJPyjigHbG1aZxJM=;
	b=hZsj41VlEWlxhx5EZ3bHwqenH1L3jSf+kCtC0RdmjjaJE9pCcBdoyB42Tb13qHeDBBKk
	 E4/w8b2sCuWF9JREr2DqXkwENLACC7GhlTrgQjrmILnEaMZgHjA7untQkjHGiLYb2wiPA
	 ydArqtklcBWYKMh69VUjMC1rOio65gZUSrqt16B0abli5Qa/UwRr076nM8UugQnMZZxmx
	 toshlnpj0WB9aVgPlxOiKlWJMvFaN1zqfFAhPcgYnOoTXnlC/BAoSrRRQCHz1u4Jiq/tx
	 2aEzQuGNkXnmJH5Pk4M27P3C3aU/b0QJVrYIFQKZX/08Vr0cH8hadCEPUgSm0QY7nyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pereq.eu;
	spf=pass smtp.mailfrom=cryspen.com;
	dkim=pass header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LIZc3zMx;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868B660A2609
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 868B660A2609
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pereq.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cryspen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=pereq.eu header.i=@pereq.eu header.a=rsa-sha256 header.s=google header.b=LIZc3zMx
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c51239b0e3bso20193166b.2
        for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 07:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pereq.eu; s=google; t=1795015784; x=1795620584; darn=lists.linux.dev;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RbuRo9+4LwWGk450hUbm5Deje65UJPyjigHbG1aZxJM=;
        b=LIZc3zMxPinJTK/o0uIzcdFFRyh4yrpvDDdife2Ri2Pakt3ig9+U4XU8uYdgmJgs6E
         6ZU/w94A3SCtfTx5EjRKWgT+26/ZvUgepkoR9GdD9Dz7ERVLjXBS+YNf4oXkSqLC3jsn
         U9/zz9+CPqQZwBuXVDbi9gY+K5KmKIFV9/ArIWOhN8Q3yNfi8v/6GafT3UWD+Lvznm20
         Cr/ghBaJ4qaAEU4Qx16/mYFZd8sZqM7oi0QrAw2lXtITuUCeqiQ4ZRVFc7SdLMhFRvNo
         +XRr1Rg+iQMayZlyvDO+DGtdS8pQuUt6sRXpej0yslAct8ySGV2g478jS0iOXWER9LTY
         bpiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795015784; x=1795620584;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RbuRo9+4LwWGk450hUbm5Deje65UJPyjigHbG1aZxJM=;
        b=kU6BFlAW8H9tIjTzGwZPzs4d8U4xiQJvihOXlUQcNyHQP17wheN1QjhBasm5/+W/Bb
         pXvZeulaEIZPMc/NBEEQwC2MbXlpbNLd/rYKlktqFlRkrq1UL7JgRtIe3P2Xw7K0H6qv
         3RZkClDpruX7lLQoYDcsjZVjwi8Dg45F8u5k6InMjHCMmmYI51rJP6N5oP/IOK+hdwCQ
         YbzVNWG+D7+62gLddFJF+k499Xr0txyr2iXeHi+GnLfH+ePEk6Qv2RKLpfa2gKPOsq2v
         JOsH6BVaokm2oG9VbZoxeINQYbxbyl2FETnhqsg5dJ6+fHYqFrQuIxxeoyPKBX+hycOS
         thvg==
X-Forwarded-Encrypted: i=1; AL+hErFhcEkCsVfBlafSGUJOR/mBsPMclUK/LG24Afe2yHCc5MCL07eBFh6KITYjSx7R8FSQ9YRskKY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/2DtPkMu1g3X030byqgAulzsbW31y82jtQxc4xg/dMH632stNb
	NNqOoH6CnBgFzD6jqQQhjQAjXolY3gnuP8h560CC9gNAHQKgXNTJFAdbWsD0tWEZGpQ=
X-Gm-Gg: AYBFou3AHv5Zz8nAlejIo+0fpaohiPchxZZPO3HWSps1SxZuYanwMobcBHt+DZzcjD7
	N6/RpHxyn9PKqjQal29mLJcc48k7zDm02xo4A5akDlHkGgCpygylXPmJ/V+6DTQbN5jlLsqgIpL
	NWagUT9vIbtSrWi6Kscb3gg502V7scaZTmwad0JhLmWqOHqaC678aB/3QFlc1/meYBHBX7mVd6K
	iR6XhSd3B8IrxOS+l3Bmc8tY9K9pMc9Gha7loVEPr83l0rvklxOEd89DsrR4Mko/GG8zZa29i5K
	UxSFOvGe30IKiNbxE8Q4j7Kbx+GPAFNkX4QxsMdZqe/4qoJu6lXHxnxTyG4DFP04yMuZcMNebqf
	L4hPBJeCrxOdc0UcVzXndb5pLpupkJVxlIdVa+1yMn3ps1SN9QYoMWFp29aj341/LGlIv/kzamL
	G8ZltinZVJEURblO3Cdfc9/Cbpl4kSR2AjlaFhsOALkz//8IIQdlJPMQv8Ej+DGP/N0lX6Hbljz
	T47b94jer668a4fitKfz3eIHmnA+GQnwYksyIvdDOg6/Cq66+P/sllLDmqYCIuW6JebdXCGa5xd
	xbnvAph1+Ap1ValpRKg=
X-Received: by 2002:a17:907:94d3:b0:c4d:31ad:f641 with SMTP id a640c23a62f3a-c510debf622mr278697866b.3.1795015783648;
        Wed, 18 Nov 2026 07:29:43 -0800 (PST)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c51231bc1a2sm15878866b.5.2026.11.18.07.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 07:29:43 -0800 (PST)
Date: Wed, 18 Nov 2026 18:29:39 +0300
From: Dan Carpenter <dan@pereq.eu>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?iso-8859-1?Q?Cl=E9ment?= Blaudeau <clement@cryspen.com>
Subject: [PATCH 0/3] KVM: arm64: nv: trap forwarding bugs
Message-ID: <cover.1795014776.git.dan@pereq.eu>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This was detected as part of our Formal Analysis work at Pereq.

Regular KVM and nested virt traps have been getting out of sync.  Fix a
couple bugs and add a boot time check to prevent future bugs.

Dan Carpenter (3):
  KVM: arm64: nv: Forward PIR_EL2, PIRE0_EL2 and POR_EL2 traps
  KVM: arm64: nv: Forward CNTP_TVAL_EL02 and CNTV_TVAL_EL02 traps
  KVM: arm64: nv: Report EL2 registers with no trap forwarding

 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/emulate-nested.c   | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c         | 23 +++++++++++++++++++++--
 3 files changed, 31 insertions(+), 4 deletions(-)

-- 
2.53.0

