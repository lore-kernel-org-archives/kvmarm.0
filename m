Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792960234;
	b=uT+3GsDACJQVUtMGLD/jGVjvHbp3EMgADpkrDS0KVlK8/e5wv805Ango8JNKJ2G1ev7M
	 ZsO9TV4Gt2yW1ycV1kvA0t9s7IOJ4PLiecMChcmjoKRpndJDRChkLXpPzc76Bn8hDeIxa
	 IClvUsn7lJ8yb5UtH1MuRB+HJGQmjgN4JJrCbB76F87hrgxh/kjuuFYwMikTE7FJ+Ks43
	 RCGRW1vGAa+wTyGH/e5WGRswEk+E1T1+kBH9RFgZ6DZgLzFf/VwPa/i6V5RulNBilMiR7
	 YplSz3Uo/Ahuz+hAJC2UmL6C+1HmXufODrNg0Ik1Cvazif0BV4me8BZKdPMR1zrB5aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792960234;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=xhfm/FnI3dgYatG4alzCY4CMRbBwFdv1fIdjJsOp9rQ=;
	b=OKiVVyVaPBdjLNP+yI4FiCYURD57U5XHymRlHoHvEDZVvrV47opwi3ohizjZ77rPwMXT
	 rmkuCEK3c3zTErxEuc9zfCgO1tgcTNZZPWSXbFjsV1W3Si+Zn3QVGx7UQYf3pHLIn7Ng7
	 pQBCMZqhY1Ew7wssCH1UqDWE2Lu7NiMOQ3CqCcSJWTIOO//k8X/9f4RJ0GJ56cMwf8XO7
	 isVGG870Mt3qu1Hzo4w8EVa9Zpz+lZbK5lKl7vPNcCe03i0LbMUcdq2y9RT6GOP823mHQ
	 HJe6YveHuCdK8oJSqP9ncdq0ZyOqz/jnR9BEprqmc+/bCU8qBmy5mFp2v5dFf29rI1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LPlAB1hK;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC08B606A31F
	for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 20:30:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC08B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LPlAB1hK
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49d05d51553so16082095e9.2
        for <kvmarm@lists.linux.dev>; Sun, 25 Oct 2026 13:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792960232; x=1793565032; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xhfm/FnI3dgYatG4alzCY4CMRbBwFdv1fIdjJsOp9rQ=;
        b=LPlAB1hK9HwOTGfTlelwuM8jC3AvAy24vzyU5Khc1All4WCi+VVZE7VTFRVUSa1wUM
         HHPEJ/K781yRZa8DdrVg356u4+dtKp52bh40OLSe/YO4yj6cGvd0WxI2Zh6T6FJiWNqG
         XNYKvbtB+xK/auPMGVx7NitzFWf5ZMlm8YjIq2/278LF5VpUQnS3hVxZnN7kDSudFrBn
         O1SuWqWu2xS2eyojrhGRHwNCOOpze8DPeQeGC29U85R8Y7fNoi202F1O4rmf58zDvfg5
         lG8XdDPzRGK0JPpYZZRU/eixkD1ICqC+22a7ey3rYIz9tWOV1KXEpSssF1hQoiEfX3k4
         T5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792960232; x=1793565032;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xhfm/FnI3dgYatG4alzCY4CMRbBwFdv1fIdjJsOp9rQ=;
        b=xRMTSYex2eXKnlaP3rQv7rIg3V4bmv/QLvQApbbnCpa1zpEc3yVL6Bn2cQBkEgjcbF
         6xDYxBFrUAvKP+M60FR9wS4zwBjA5ZBAl6GVQNL64I1CjQ7rKgtZyCod8Xzefa2W55lP
         Ao9eXLQCZFjLowKkEy+dsyUHyD66dR1ks2Deccw1bAS7M1cfOuh1DeTR97W3Xvp/Js6Q
         /pOA6MOHXynAV/26WVFkoSDyueQ3d9Vf3rQVsxhLKtHCBCR7g5ptdOuD0vCsHSeKWl23
         NF1mxx3W7FuvQc6bei4nyr5nGm8OqOrGCskMGLc192kggNUS5ot5fyy4I54V4HbYmLME
         8DYA==
X-Forwarded-Encrypted: i=1; AKwUvBzep53ws61PWUZoC59bRplV6DVHwRTSF8SBHTbCAXN7KYNUD6NeAmcPfw5Wtyp4Ux3od61r0Iw=@lists.linux.dev
X-Gm-Message-State: AFq9FYIsppCv5JOLxBkc1dGKLYM+6X2HS8mZ2yr+gcf17xMVZEKzE3k+
	N/PaCc4HQ6cNdKhyiHPh2v9dBMCPIFL2CkYYymnlGVjdVH6v5/N+jpQN
X-Gm-Gg: AYBFou1WMxEbAGZHryIV6SPZ7D9rQoyDD9M0RQrL5Zc9TWlQ1KdjbGEsvBDDxSJbZIe
	nChSAfbOHKKct1rC+qYbq9QhzLQjWHKje85mzCZLkWl2wPGGyIxSqq7jsHJqVxrSAzRGUT2kjxB
	iywaFJuww85YEV6pgVPHDkUdnFrBwSCgemeesonnvevjoAu+lEH/Vz9aAgfSEF72Wt4rtkrR44L
	D4aBrJWwPGPG2vUxiGCC0ZLNbSB4U+H6OC6ueQRFig0xZdHVCR8O+np9HGWDBRG7YBQU5feVmSp
	20L4A4+ayGdevlOvUDgVDe2+mwmO+Ynzotlfy6uFGAeX+i/MX7/c/suD8Hk10C3XQ1rmV6I37pA
	TByyUruDYcZ/rQMRgBtc3X0IxfFa+oTwEJSwFUku+OG+sYFgD3ZDamT+iLjfm3DtKqcl4Nq4aj0
	8G/pQRsLggDOQjiC3HX0B7uTn3fk5YOtnBE0KI9/s66bDHgsyXeEExNV0dsJB09vXAl2/kUtcOj
	EmJszyIs9XR3pf3+pk6PFCjNMy8YIjSbzdvspDyTY2faVRe3y2ayDOkBAF+Ivg/OLSFnOeO1dOK
	fZZCGtg0JP1vVo46tX1IDRgFUynCtZFekvMLxS8rOIN+S157sseQsDI8fVk284X0k6gksf4L6l2
	+9ynZPZyWbBCGyj2Brx1r+2f/0uHtE9/7ABbR9azieGSIWSZkiZyIEf+Yns7/3MlZA6ZfG0UYdw
	Y+
X-Received: by 2002:a05:600c:4583:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4a35acc2773mr98426965e9.32.1792960232061;
        Sun, 25 Oct 2026 13:30:32 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a9cc-4401-09c3-9199-30c4-c6a3.310.pool.telefonica.de. [2a02:3100:a9cc:4401:9c3:9199:30c4:c6a3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3cfasm12003158f8f.17.2026.10.25.13.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 13:30:31 -0700 (PDT)
Date: Sun, 25 Oct 2026 21:30:29 +0100
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] KVM: arm64: Preserve level IRQ re-pending
Message-ID: <at5k-_Ign30fPuHE@gmail.com>
References: <20261022064628.4206-1-kmehltretter@gmail.com>
 <atxWfRsNNK8vdeSr@kernel.org>
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
In-Reply-To: <atxWfRsNNK8vdeSr@kernel.org>

On Fri, Oct 23, 2026 at 11:55:57PM +0100, Oliver Upton wrote:
> > The exact alternative is to stop and synchronize the target vCPU
> > before applying such a write, as the active-state accessors do. Is the
> > conservative replay acceptable here, or should ISPENDR pay that
> > synchronization cost?
> 
> Yes, just kick the target vCPU out and sync the LRs back into the VGIC
> state. That's consistent with the approach we're taking everywhere else
> where this sort of issue arises.
> 
> If we're lucky the vCPU is just poking at its own redistributor and the
> synchronization is free.

That makes sense. In my current v2, vgic_mmio_write_spending() uses
vgic_access_active_prepare() and vgic_access_active_finish() under
config_lock, and drops the extra struct vgic_irq flag.

> 
> > The issue was reproduced with Zephyr, NuttX and RT-Thread guests. On a
> > Raspberry Pi 400 host with a GIC-400, each GICv2 guest handled the SPI
> > once before the fix and twice afterwards.
> 
> Have you configured these guests in such a way to reproduce the issue?
> What exactly are they doing that is susceptible to this issue?
> 

Yes, the runs used a small test harness in each guest. Each test
configures unused SPI 150 as level-sensitive, pends it from thread
context, and pends it once more from the ISR before deactivation:

- Zephyr (qemu_cortex_a53): k_irq_set_pending() -> GICD_ISPENDR.
- NuttX (qemu-armv8a): up_set_irq_type(IRQ_HIGH_LEVEL) and
  up_trigger_irq() -> GICD_ISPENDR.
- RT-Thread (qemu-virt64-aarch64, pic.gicv2_eoimode=1):
  rt_pic_irq_set_state_raw() -> GICD_ISPENDR.

A driver that hits the same pattern is RT-Thread's
components/drivers/mailbox/mailbox-pic.c, which amp.dtsi configures with
level-high SPIs and rings via GICD_ISPENDR. 

pic_mbox_isr() reads MAILBOX_ISTATE once at entry and clears only those
bits at exit.

Sending on another channel while pic_mbox_isr() is active sets the new
MAILBOX_ISTATE bit and writes GICD_ISPENDR. Without this RFC fix,
deactivation drops the second pending state on both GICv2 and GICv3 and
leaves the new channel bit stuck.

Thanks,
Karl
