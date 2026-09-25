Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB6636D500
	for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.215
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349755; cv=none; b=On+16xbPtrC1YrqjjnhboqrxXtx8SkzqiLe+gn/4Aw0YF5sJXKXA+eZlvXst+KRWdEC3p9miufufd4pwPaank4nvQGHzEflaLwYsgXmZCNYXzJcHW7u1zJJJ8ulP5Pm6bkLuDnhJLjhILnER1dg5Gy1PXmKIP4tR+6n6MJXlaV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349755; c=relaxed/simple;
	bh=z060NorVjkdchyRWUzkmKu19VquiP8XV8AyIxkINsfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TZQbVyFqnARsfEIuHs07zncneIBSwkjxwc66Q536x4ZKX+q8jPaqpgTAKqm7nMeA0NQbfQ1Eera2oBIjpnFPQyrrnJcD6n4YOWjFVO7eV6W11tIuu4+rPWmzPHV1BHuLjh1/ksTpMlDCVnacChicKkLeOGofsljSY1W4WFtw4eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gwGc8/by; arc=none smtp.client-ip=91.218.175.215
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gwGc8/by"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=z060NorVjkdchyRWUzkmKu19VquiP8XV8AyIxkINsfE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790349750; v=1; x=1790954550;
 b=gwGc8/byAQxyaWHoxr27PT5g2L3t2NZFmk+mh4dnRPyIfDxMK1vipZ5iod0Nr5BruxKHh9vf
 8nI5V6Eb+3c41I2fgiJm0d8xMmCO/s3LPffLMLwZz1W/OAeGA4eHlqMF+Hqd0wvtXKfI9qXIQke
 Lzpr/FVCSUqtTiv2D3QR2LtU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 8c1377065b7892f9;
	Fri, 25 Sep 2026 15:22:30 +0000
X-Mizu-Trace-ID: 8c1377065b7892f9
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b8e81e2a0bso5633e87.0
        for <kvmarm@lists.linux.dev>; Fri, 25 Sep 2026 08:22:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzYN854q3w4YBBSF8mf0Wd2EXSmjlmG3BqSMqtNw2vY5/jW2SebX3AtOWG5Khg4BbHoRcRkA/Q=@lists.linux.dev
X-Gm-Message-State: AFuF++nh3NXkr71hMS9bQ/DPkYhlx4T55kPv0qC5/AMbly83r2ZmryKu
	50bpcHNO0r22Hgy+Hu3q2k5TaHhec7smoaTmwoR9/2fU8E01oEr7+K1PgmMNbwUP1PItbEW5d+t
	IEDI/GDhZ3agyZ0WIjJ33LLD/Wno3m76jeX9qVsAz
X-Received: by 2002:a05:6512:ba4:b0:5b8:eb6b:2a52 with SMTP id
 2adb3069b0e04-5b8ed09a59amr43196e87.2.1790349749415; Fri, 25 Sep 2026
 08:22:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260925090619.852995-1-fuad.tabba@linux.dev> <20260925090619.852995-3-fuad.tabba@linux.dev>
 <8733ux4bow.wl-maz@kernel.org>
In-Reply-To: <8733ux4bow.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 25 Sep 2026 16:21:53 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy2hfn0qighn2kZ-Gyy_3nKtwiRCGMrox6K-Yn22ZkP6Q@mail.gmail.com>
X-Gm-Features: AclHuK_gTf2iqS9h2Xa5Ix6rBbxV4n0KGAvJD4FiA9vRXr5yyjusiCbOGjiate0
Message-ID: <CA+EHjTy2hfn0qighn2kZ-Gyy_3nKtwiRCGMrox6K-Yn22ZkP6Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: arm64: Clear HCR_EL2.RW for 32-bit
 non-protected vCPUs
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Quentin Perret <qperret@google.com>, Vincent Donnefort <vdonnefort@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 25 Sep 2026 16:01:35 +0100, Marc Zyngier <maz@kernel.org> wrote:
[...]
> Apologies from repainting the proverbial bike shed, but I find the way
> the above is written very hard to understand, because you are
> describing minute aspects of the code without giving the big picture
> upfront.

Writing commit messages and comments is hard! :) I'm working on it...

>
> I'd rather see something like:
>
> "pKVM maintains its own copy of a per-vcpu HCR_EL2. On initialisation
> of the hypervisor's private vcpu structure, HCR_EL2.RW is set to 1
> unconditionally.  However, nothing forbids userspace to create a
> non-protected, AArch32 guest. Since HCR_EL2.RW==1, entering the guest
> fails with an IL exception.
>
> Make sure HCR_EL2.RW is cleared when the vcpu is AArch32 at EL1, and
> that the HW actually supports this."
>
> which describes the problem without the reader having to dig into
> code. It makes matching the description and the code very easy. At
> least for me, YMMV...

Much clearer, I'll use that for v2, and give the other messages in the
series the same treatment.

[...]
> That's another example: yes, this is all true. But how relevant is it?
> Are you clearing RW just for the sake of vcpu_el1_is_32bit() to work
> and prevent an UNDEF? No. It is so that 32bit guests do work. The
> above really is only paraphrasing the ARM ARM.
>
> What you don't describe is that if ARM64_HAS_32BIT_EL1 is not
> implemented, you let the vcpu walk to the cliff with RW==1, and rely
> on the CPU generating an IL exception. For me, this is the important
> piece of information that needs to be captured.

The comment should say what happens without AArch32 EL1: RW stays set
and the entry fails with the IL exception, rather than EL2 switching
registers that are UNDEFINED there. I'll rewrite it for v2.

[...]

> Other than that, the patch looks great! :)

Sashiko didn't complain... :D

Cheers,
/fuad
