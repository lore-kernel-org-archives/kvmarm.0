Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794948226;
	b=RxIjkN38nl7y7+iEFzpKGssahsE7CnZyU4JC3pK1N4KNCoA9nvwOukBjfIxAbJyt73Rp
	 wEEvb9TqKUH0pVqPaPTPrSCtFefcn6gh5X8JpH4W5N99hKNpbc3BaLgpTyE9KgxuInK8w
	 SgvkQi5f4C7AzoHNQiOUB1coiAflEJNH0g3rjzqc+y7sInDtOinXEvsAwj6+MlzqWuwZN
	 PtaC+NWob2up9H3Y+q0dtT7wq2ZtRWRpXf2WfXMq5IprrDBXLSeXOKn/36J0oeJBYxJ41
	 esScYmI+VF407bgzUrOgMwP7i2izDXWaMyOO9eDxtMjxH5qjhB88R4JS2W211HW+dfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794948226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=4s7Hggd7+AEEhOvi2jMoV+jP1lHkwbJcfKFilHVKaf0=;
	b=JgdJkpyuUgGAwTeAcjDgnUZFlyB6BvGfxpB1fmSzL4bUtzPhk8CbcnV4MxNFVjfN11qw
	 pBS1vMVanlJODq1LEDXNoYyhd11AM5o92Fyvf6aZAjQgpCgj/mIVRmtN6gNK7PYVMovNJ
	 puR7ZrJwhhAT/BlBtZpiyZcn+d4hhQX3Q9Lwp/wj1xFkgLQICzZUux7QaS6Rkg1RJJOCL
	 /AFeAySnT4+kGpgmEbbrgmj93yVDgjhcfiEf6P7x5aQ8uzR7sYb9Ay4fNIHsm9Whi4nnM
	 Fx+1/gPNMyAGqQzQ/Xzh4/s7e70CNDd6eeVoHKNEDtXLTy6ahrnLJD47BL24Mhb6TdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VOOcR4nA;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675C8606A31C
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 20:43:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 675C8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VOOcR4nA
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-5727b04b81eso83982b6e.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 12:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794948225; x=1795553025; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4s7Hggd7+AEEhOvi2jMoV+jP1lHkwbJcfKFilHVKaf0=;
        b=VOOcR4nAaH2p5ZvUhbQx77Lp8x4huUAVw0+hEmW9+dIhKM7LQxFS7hI5vBSfGspeTO
         DbhA0+Z4M/dMhxAnk2AKQ/1WdX4SqfqKH8OndGa/lBl010Mwd/quyHS0O6q1z1b/mktU
         +JfUuEOy0ITw5pFIF/9pW1jtXKO3UlIbJocqTGhVStn2Wvy9ApGZaMfMMFrjc3rhOa96
         JO7/4WcudoUSXR2OZ62pBtzMsrkw8RIDOlpH5wVp2zq+0Zr66oavNeXbb5NfnYrZaCte
         tlVC9JrlOAFHP1fCXqRbYub9YpnGADzUPcIRWukSYB3CjkWDOiMpyCVLCd/CERaNP1NX
         4b7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794948225; x=1795553025;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4s7Hggd7+AEEhOvi2jMoV+jP1lHkwbJcfKFilHVKaf0=;
        b=LjlmyIqTjO4k5qmuvgpO7nr9BMh9yjThlmWqlLt9B4O9URsrDwiJhmmBi7uMeJ/V/C
         q89rv8MtLh5bstp6iqPHpX2a7HAJljyfplXn8e/IeEbHrzMCq8WyNgcJMJJXuUBUVjYa
         AF+oQPvLkzk4NJ0Rwx2+vfh7hodZWz+KlYWKd4KwIcZrp5/F6dOfi2ecIjTLjoWVt/Cg
         bf/E0R6bXpQ5ARLO/76opvXyBWDhv1/2dOnZGC/KWMwPdUlHVghWNUhuo3+1zjmHg+xR
         BKvqs6P8baf0EkAwZBVEwcuLiQi1hIlbP9Z9NOGZHIwXILpZcK2bchJqi1Ocjnbl0cs3
         Etlg==
X-Forwarded-Encrypted: i=1; AL+hErGeoT0P+dx9dPHe796O5QQ8E04+ThzWE677xu4v5eYbdI1hGMpPatN/mLZ+9Ywd7RjmxVmkciE=@lists.linux.dev
X-Gm-Message-State: APuU4Z8dKjEHe+2RTUxaV5p8J/MREAUMBvQbTzo3Ly4DQQLe1nI05FEM
	NvH/qCeEflz/7kPdsK8BjgRRSJacIC3ZtZbl1fPfd5vG+ulminZiLr0G5udqUucydH1g/amd5Lq
	I5i/TDh0DzrHkXddzc/a2ffPJYg==
X-Received: from ilbej27-n2.prod.google.com ([2002:a05:6e02:4e1b:20b0:522:8039:f8b4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1c0b:b0:571:b166:3d76 with SMTP id 5614622812f47-5773c6322b9mr918759b6e.29.1794948224648;
 Tue, 17 Nov 2026 12:43:44 -0800 (PST)
Date: Tue, 17 Nov 2026 20:42:19 +0000
In-Reply-To: <avyNBn24sLjxrfgR@LeoBrasDK>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261116200418.3535619-1-coltonlewis@google.com>
 <20261116200418.3535619-2-coltonlewis@google.com> <avyNBn24sLjxrfgR@LeoBrasDK>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261117204343.4017815-1-coltonlewis@google.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: Fix inverted E2H0 check for HCR_EL2.NV1
From: Colton Lewis <coltonlewis@google.com>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Colton Lewis <coltonlewis@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Leonardo Bras <leo.bras@arm.com> writes:

> Maybe feat_nv2_e2h0_not_res0(). What do you think?

Agreed on renaming it. Since HCR_EL2.NV1 is the bit marked RES0 (while
ID_AA64MMFR4_EL1.E2H0 is the signed ID field controlling it), I renamed
the helper to feat_nv2_nv1_not_res0() in v2.

-- Colton
