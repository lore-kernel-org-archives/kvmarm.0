Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792877335;
	b=E4MhZgWlnDmUHKnOIfSeN4uYGUr1OoOQGAzTRTazcTUcsWWmJ+j3bbG/2AJbyCvlTvmV
	 KX31WNhLBgQT8EMZfxBwQTk7UgQ7xyJ8+Zx4gbXQc5Hggq8Eq+cgRe4Zu+y7HNy+Z5y65
	 HlR4BQu2Uh7q3oVDh4d7Ng4/Jl3eiVsXoHjNJ3biWfvntnOXnRJIpSZXHXWddTB1rhx00
	 zCBrnGr0J6vjfOE59CDTnHppuozGxTbGT5xEliXbbjiTefQhXQN0iskwg5gkFVMgt9Opk
	 0ULIp2EFTKxWHlBMGxxmNquIBMnSMv+ftTkP03Mk9NYMnqdA9tpGQlU/FJpZu8IsImw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792877335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WKjXGirCGBWaGZ6gv0IsyrzVZH7S81bL8FiRWNXjU/Q=;
	b=R3jkbqCdn/pQ4JscrFYmxbLF2d8z0d7oQSHGl8UEJCsvP/gu+se7kpcVl/4uPB59/q2R
	 kMdzzDM+kvkV9V0nNNnAb7uF1ypCc8sth82+9zr60R1uagqYXZ+TTClUJX2NZykPn08Tj
	 1TKqBOS/XcDFNXycBEvdzLZCELUAErFNmG3rRuyLtWGbTusQCzt1Sp1vbXvYgq5g+P4S+
	 wQ+/ziS6zZz3yzEkoU8NGH9/wI57YCpEvF6yhPOZiCwrhXudaq6yb+9Jjl9nQe5jnwe7B
	 Z1CXT4RQLLvVPk9aGQo7OgXJTYOao5m82pVjmb4HLgGANP40eXwx/N6d51SWpC7Mxuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CCijbW32;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47F0606A31B
	for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 21:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E47F0606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CCijbW32
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so13541645e9.3
        for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 14:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792877333; x=1793482133; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WKjXGirCGBWaGZ6gv0IsyrzVZH7S81bL8FiRWNXjU/Q=;
        b=CCijbW32Z/JmH6t/CQnoNI2tCIX1OeTQQiSM8uHIN1d9vR0wMANdHs9HbvpGS5qG13
         xgS0sCE2Xkga51E9s9LtBEaim/6/IOxHHo4wd+48p9Jv6O9u71TGrcvSCItspQ2cV1+T
         3LjjVRWD03McpGkm1Sbr4OTdtxXUVJmabERbAXjuUgsTB6jYXbTwcLWebaZzo0YzoIT1
         akN9JqMRJDDvFXwposqlJYQ2s+HcHpbPc67gIC3Sx2L8uKrazlbw1K+gBKOBK+w7gjpt
         BFGWHRAy3MqgIwqrnQ47jeY+ivbmcZOWDMUSrseWvD3IyxZGfBiZzPlDh7viVXYtrA5B
         wZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792877333; x=1793482133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WKjXGirCGBWaGZ6gv0IsyrzVZH7S81bL8FiRWNXjU/Q=;
        b=NlR44FUpk5b0XrMDfTKSEdzlHTJTeWm+EPOlwC5IRiKTcg8xMUlCfn6ZuvLofCawdN
         xFEvZCwPHIjBd6/pzVZSnn9+9yqWYR5eh/ljMZiMDhSzZiwV/4FXyKt1iZBR7M9VU8J9
         KBdgxrBh7pLWBbOvnVy7mLXXSuVs5OgS0+7rWPwm6Qc8DZ+hHwcF6QAKfZjc3JEqvmHb
         bFSmpJZ8SrjLjD/1cdmsIjJ9q9Be+nMRfS9p8sLsw1AMx7oRo3FfKAQ3CCj1KdOCefL8
         Wf9kbT0FLvkP6VYOAcHuVA8iSZbglPU3nBA4DGYLzVID2sRxmboJBNY9Df7O67k9lXW8
         qOVA==
X-Forwarded-Encrypted: i=1; AKwUvByJudg/MGWp4IuAE9UJnm8WKzQSrLETEFPIo9I4WBG+IQnrG4PN4gj/bSqIrWqqEG9RxxyHgg4=@lists.linux.dev
X-Gm-Message-State: AFq9FYKj5WLEKM6+9bzb+OgqjPGOBjB+Ee4qahAZNUIKz30yzfJMULfb
	DdO7E//hLmqAtvoJEuCoPtMkFrI/EYmSEc8yCk9bVxbGNEXEFET2QHED
X-Gm-Gg: AYBFou0UyDh2iZwIOjZmJE9m8EOmUl6lkPWVQ1spqP0rMRr21fy0YHckMsYCyfPAgJa
	AHBC6i3ybROXkd1REBbD8zbKOMo1PboszFTA8jpoO+XkFhXbqoJnz0STxWSRs9yrNbJ66ZVf6p5
	zhI11MIaWsosc6J0s5bRyYf3dbHRVddtCtttXeby+WhGBO3MbRiInl4114H1jy7UY/YyG1TIQeA
	jNDlRvB5JB7peCuJd55KU9p1bUjR11KgD1xcdmGhBjcm9cnBpin+nalJLmyBWNvw6yqA9rs6lVA
	I08RZ3a/IGztPRzbuwpwJSsalfrz3mPOKnOGTRAk3ymbUUpnQgWkAjcsTzOyDGI22PpvMEcOTe9
	E07z/6a2eVbqjzHaRJWb6pBU7qTI4HFHpSh9mbTAk/GFnV0meDuCRbL7f4GsycNFAs0BobVCZVQ
	0taBftfnPKx/7NG4YR3OP5RYrRrLMI9wE/R8+Wh/DM/u6WyL8oxf8UorKeic+n7QbVh6NStDbjw
	kp9Ll3o08YrT23RgNmMb63GCVg4PAd4mBu3G2OZyGBnvpejFRrSLpjfKKPCPBQVunfuB/0q/1tm
	hmTb
X-Received: by 2002:a05:600c:1987:b0:4a1:db17:c7e6 with SMTP id 5b1f17b1804b1-4a35ac3a7b1mr41192835e9.2.1792877333059;
        Sat, 24 Oct 2026 14:28:53 -0700 (PDT)
Received: from ASHA ([2001:630:3c1:164:1a66:daff:fe85:4026])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a2e8f25sm77497285e9.14.2026.10.24.14.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 14:28:52 -0700 (PDT)
From: Amir Noohi <amirmnoohi@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Igor Velkov <iav@iav.lv>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <cdall@linaro.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] genirq/manage: Provide irq_set_percpu_irqchip_state()
Date: Sat, 24 Oct 2026 21:28:44 +0000
Message-ID: <20261024212844.3405617-1-amirmnoohi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <87se1v8f2r.wl-maz@kernel.org>
References: <20261024022450.629980-1-amirmnoohi@gmail.com> <20261024022450.629980-2-amirmnoohi@gmail.com> <87se1v8f2r.wl-maz@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Sat, 24 Oct 2026 13:21:00 +0100, Marc Zyngier <maz@kernel.org> wrote:
> It really feels like a leap of faith.
>
> There is nothing that says that it is safe to call this without
> holding the global lock. For all we know, drivers have been relying on
> it for a good decade, and I don't feel confident letting things rip
> just because it (mostly) works with the GIC.
>
> At the very least, something exposed by the irqchip (a per-IRQ flag?)
> should tell you whether it is safe to elide the lock.

Agreed, and v2 does that. There's a new IRQCHIP_PERCPU_STATE_LOCKLESS
flag, and irq_set_percpu_irqchip_state() only skips the descriptor lock
if the chip implementing irq_set_irqchip_state() has it set. Otherwise,
or if there's a bus lock, it just calls irq_set_irqchip_state(), so
drivers that don't opt in see no change.

Only GICv3 sets it, in a separate patch. For SGIs/PPIs/EPPIs its
callback only touches the local redistributor (gic_data_rdist_sgi_base()
and the RWP poll), nothing shared. FWIW, irq-gic.c, irq-gic-v3.c and
irq-gic-v5.c are the only drivers with both per-CPU devid interrupts and
an irq_set_irqchip_state() callback. KVM's own timer chip (GICv5, no HW
deactivation) doesn't set it either, so those keep the lock.

On GICv2 in QEMU it still takes the lock like mainline does (333k vs
321k acquisitions in lock_stat, within 4%), and on GICv3 it doesn't
take it at all. arch_timer, arch_timer_edge_cases, vgic_irq and
vgic_init pass on the Altra. Under QEMU with lockdep, DEBUG_PREEMPT and
DEBUG_ATOMIC_SLEEP, the selftests pass on GICv3 (VHE and nVHE) and
GICv2 (the vGICv3 ones skip there). No splats.

I made it a chip flag since it's about the callback, but I can make it
per-IRQ if you prefer.

Thanks,
Amir
