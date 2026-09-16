Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2B94CA294
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789558303; cv=none; b=LasD7f+1IhY7ChTqAlbokhKdbN/Mrs2g5jLeRjrIR1BAImmzzRGd6qLjxa+Oc1IxRp3WCAybEw4mEBD3ZISIAloj/4+G8RklCP2GlDqGTag2hCe1DdWt89JdicrcxAgJHn5FosG/fJ1dmEM2UHP1MZDPQfUgn8O1zKoMlzoxeQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789558303; c=relaxed/simple;
	bh=H9/X4Q083/Be4Ty8+X1bHX6F/upo2FhttV8SucE1Kc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zd0e/rVGnvnEwiwqaaGqivjMSOdlZ3enobGM2uVoZqb5qaJx2y1gKvf6LZWHPzCen6Th78mrJMGjL3BdpjDIagqR2Neb/UDGLCJ1Cmau8WKMQhQzyRLzgBCSEVcwyRlOAR3QHUH0DLRyGLz/ZxHtE+Azn/P6Maiyx/hcmgsPQvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B8EGr3dj; arc=none smtp.client-ip=91.218.175.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B8EGr3dj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=H9/X4Q083/Be4Ty8+X1bHX6F/upo2FhttV8SucE1Kc4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789558290; v=1; x=1790163090;
 b=B8EGr3dj8bpoZp26aBGa5MslAKW3HKx/WMQHcXBVENXz2AApPMTTfofKeRf97bSIG/ojbJRf
 9j3Bdo9+z7Uuh7f3FtWy8g+b7ExNtlwxOj2ljjVNCZItu0Ya/Y9wCVzr5YsMQbFEz4xnZckvTT8
 kJBoldI8Zm1SqHfVvfcYwxpM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 63c654108f12582e;
	Wed, 16 Sep 2026 11:31:30 +0000
X-Mizu-Trace-ID: 63c654108f12582e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so5879e87.1
        for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 04:31:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByrK1XxUwk9BKdkSsyVo3hBJSZ8lKvl3ZZoGYnk/dteKnaplrOde96F6nS+QGHh/1QXEkfwTQk=@lists.linux.dev
X-Gm-Message-State: AFuF++kJTbB99UUFpgHqrrxHcnSLk+qUd4zqVehzQ80/qxX8zdSWJnEM
	6JDELNznt8TGgA/RHYu3zrUmOguETctP5dEbPyHAgJLz2h43I4i+gIJGtokeaz6JLR/MJ50Zdns
	lcy7wTiz5hs8sqDaoSTv9ZkYLOPrSYQE44sIjdUzt
X-Received: by 2002:a05:6512:1348:b0:5b8:b19a:6d1d with SMTP id
 2adb3069b0e04-5b8b63618f4mr78123e87.10.1789558287151; Wed, 16 Sep 2026
 04:31:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
 <20260915123846.2317931-4-fuad.tabba@linux.dev> <aqp25JLeqyCKtCQH@e143914.arm.com>
In-Reply-To: <aqp25JLeqyCKtCQH@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 16 Sep 2026 12:30:50 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzrLF3Hg5ydxyH42_5MuVy8UgX_2i+9j=b9iGv4HXQO8w@mail.gmail.com>
X-Gm-Features: AcwNN1Vz9eSWek0wyBJeKGdLSTjp1eCz6MDTP6a0k4XXrJwyuhhk-6TSflZWtaw
Message-ID: <CA+EHjTzrLF3Hg5ydxyH42_5MuVy8UgX_2i+9j=b9iGv4HXQO8w@mail.gmail.com>
Subject: Re: [PATCH 3/7] KVM: arm64: Validate the host-provided vgic model in pKVM
To: Joey Gouly <joey.gouly@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	vdonnefort@google.com, qperret@google.com, Sascha.Bischoff@arm.com, 
	steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

On Wed, 16 Sept 2026 at 12:00, Joey Gouly <joey.gouly@arm.com> wrote:
[...]
> > +       if (vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> > +               vgic_model = 0;
> > +       hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;
>
> A bit confused by what is expected by writing 0 here? I would have maybe
> expected to refuse running this VM? What happens if the host writes some
> garbage here, so vgic_model=0, but then tries to access gic-v3
> registers?

0 is vgic_model for a VM with no in-kernel irqchip, which pKVM runs.
An unsupported model is treated the same, as a protected VM's features
are masked rather than rejected.

At EL2 the model only selects the GICv5 world-switch path (GICv3 is
saved and restored under the gicv3_cpuif static key) and gates
__vgic_v3_perform_cpuif_access(), which returns 0 for anything but V3
and leaves a trapped ICC_* access to the host. A host that writes a
model it doesn't have gets a guest without a working GIC, which it can
do anyway, but can't make EL2 run the GICv5 path on a GICv3 machine.

I'll say so in the comment if I respin.

Cheers,
/fuad
