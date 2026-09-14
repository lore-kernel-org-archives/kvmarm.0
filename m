Received: from mta0.migadu.com (out-126.mta0.migadu.com [91.218.175.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FD33E7635
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 08:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.126
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373641; cv=none; b=LdPs0WSLUYGDbpklB3lzuAhknbZRo3BeZ2ECOulXCB94neg930Jhn/3ZOesHW4X3oMPs0GijpJaEOCmP4otzrmjyLuuqlSLZ8xj3eqImzsFaRPU1Ry8MO8hUAJuSunTZq4IJS3q+kdfy7jqC34B4iXpH78317cd4kNWbXYcvx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373641; c=relaxed/simple;
	bh=Ti/1G47FS/EQWMQAM+XxbuqCWRXpU8JeCwn0rHreoas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Stwqrr//Ptgdm1IZjqneeqaj5UapOasui2Q2S91zpoDcdr+Gi+cMrjKe6T71b8zG6OUdjyEBzfEsc3Tg/oZx7/8gP/2w3OCNJ2VuYFGpCGFgG5jmuJ9azoOmH7rtVQOdPXQQP+EDTWFF3KsY6T1VUFfAkdVuC0q4zMH0jzu5qYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DPnw6wFB; arc=none smtp.client-ip=91.218.175.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DPnw6wFB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Ti/1G47FS/EQWMQAM+XxbuqCWRXpU8JeCwn0rHreoas=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789373638; v=1; x=1789978438;
 b=DPnw6wFBDqYmbpOeDZ6VeQNdBDM7/bnBeNwisFl/PhKirfhzwOPo1uUH6D/p84yw4QR6bURg
 HEOgs+uY7ik7x5uJfKzImvoz6xIZ6BcGBIlNOuusbhUCXhF7vG84sBRYNMw5W2fXV7nLS+Ire/I
 jGHMkxt2tlTOcoA+sKNzXiwg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 724d3f8055b7a3a2;
	Mon, 14 Sep 2026 08:13:48 +0000
X-Mizu-Trace-ID: 724d3f8055b7a3a2
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so5625e87.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 01:13:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzplQcvcRTKrN3o4I0HHK6wpP9M3LzNVvnaDSR0JGKXW3D6DcE/8X/FFiAaWcM3MKuUgK52GXY=@lists.linux.dev
X-Gm-Message-State: AFuF++n/G9E87KWFHQhthbgMJu6wLQcWg4u2HBdA7Ho6ywkBTFnqCjbq
	O6JEImyptR0EU2GcXoSADlp3J0USBpmudsFgrwBMfgbh+OUATAqWIu1jdapSMMOnqA39auuhBS5
	cTbklCdgP+aKKREt0CZ7nSmfe/IhxHHO2b5u9k1GP
X-Received: by 2002:a05:6512:6205:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b8ae4b243cmr24745e87.8.1789373626863; Mon, 14 Sep 2026
 01:13:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914065136.3418404-1-fuad.tabba@linux.dev> <20260914070536.877D91F000FF@smtp.kernel.org>
In-Reply-To: <20260914070536.877D91F000FF@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 14 Sep 2026 09:13:10 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyjXoxb6gZO4+X_cDh+z6e9cY75nZGsWFeOAOvBp+D0bg@mail.gmail.com>
X-Gm-Features: AcwNN1UbQngGq-eYS1JXmeVvwbf0ZeR8W8FV59mmOoiAMGh32I9FP1sww3CFOi0
Message-ID: <CA+EHjTyjXoxb6gZO4+X_cDh+z6e9cY75nZGsWFeOAOvBp+D0bg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Pin the host vCPU before adjusting its PC
 under pKVM
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Sashiko, this one pierced.

[...]

> [Severity: Critical]
> This is a pre-existing issue, but does this create a double-fetch (TOCTOU)
> vulnerability that allows the host kernel to leak arbitrary EL2 memory?

[...]

> If that bit is set, it updates the PSR_TCO_BIT in the vCPU's CPSR, which gets
> written back to host-accessible memory in host_vcpu->arch.ctxt.regs.pstate. By
> shifting the base address and observing the result, the host could leak
> EL2-private or protected guest memory bit by bit.

The read in enter_exception64() is unvalidated on both paths. With a
hyp vCPU loaded, the handler adjusts the host copy and nothing checks
host_vcpu->kvm at all, so no race is needed. On the unloaded path the
pin in this patch narrows the window rather than opening it. What
leaks is one bit per probe (bit 1 of the word at a host-chosen hyp
linear address, through PSR_TCO) on MTE-capable hardware, or a hyp
panic on an unmapped address.

I'll send a v2 with a separate patch ahead of this one that gets the
VM through a get/put pair at the read site, and drop the VM pin from
this patch, since it then has nothing to protect.

Cheers,
/fuad
