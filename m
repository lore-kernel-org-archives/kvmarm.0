Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F015F7473
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 22:08:05 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id m7-20020a924b07000000b003170cef3f12so6188336ilg.22
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 14:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678140485;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O2cEi75bvpWmHU9egbpkR6oY/ujBMoJwfRR97U/i4FI=;
        b=AZW/wYSQI/0cMhcJDHbqcNA4uJo74U3fqrAa/4Ys3S6ysIcE7zcvKSAJ0b6ELHNRzs
         uC5c1TcUc1qo+SKzXcDQyXcDnXtl8fDUYViyrshryjJtiobn/uNURwAxGtCK+svqZf6x
         r0lZhDSFur/YhXzdF6cE1jLRtV6Pq/ijrKNgOritasuRN3BCFe+C2+nY/afgg91EqRCJ
         9hjEXt1XktFVNQmCCKQzfWfIEL7jSHdlV5O4EquZI9ebc91U+2R6dhDXBc4UtYf3eusI
         7YUMqMPyWitfNxrIt4LocjqEMXlGomxFvqSYRDfHCQUkMop9PNZ2dB793heP5TNN7TH3
         WmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678140485;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O2cEi75bvpWmHU9egbpkR6oY/ujBMoJwfRR97U/i4FI=;
        b=czoTs98MZaRo0qw9tAZl9Oywj9nuZFPZSL5yCjcXrQJMcNWt7qF+EKeaydzzaoWF0D
         wFEpdxFYsUyYLp2G9thJ71kCCYc9tDpxxrJYnn63FoxPUJGpPmabRAbTHbJcAuTSkHMf
         DN+jTR5HtYOxfQXS15+HtuvhO5R3mHtMehLXv0d99D6/jFEnQKxlfPmfM0ZDulO7SL4c
         9BCnvZrDLGtpvz5hlSFs4InYOT5mYC57UcVU4D4DlhTlABW9Cs6Fjl+LOK6pDz/xVv1Y
         mradCwvtw4Udkikw8aM5VqVjA/G2/JdrmUqG5b7jBZDA9drXizyHIdynM+xd50ZsXAfP
         XkBw==
X-Gm-Message-State: AO0yUKUrkygP9mwDdZ/e/vL0x2AXbrrJab2xorD4utXcg5+0d+Wla+aR
	VuBcbfypl1ddodywXHaskeBd4Z+QyiKAvBh56g==
X-Google-Smtp-Source: AK7set84D89LW2JBMKLJQ8HQvLSBXW2i45PmvFm623iO6ZX1ecHaKF8zMs78U1/PZFK33LnTbyLGYk2ngqBmMTJYlg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:8d87:0:b0:744:f5bb:6e60 with SMTP
 id b7-20020a5d8d87000000b00744f5bb6e60mr6404696ioj.1.1678140485037; Mon, 06
 Mar 2023 14:08:05 -0800 (PST)
Date: Mon, 06 Mar 2023 22:08:04 +0000
In-Reply-To: <20230216142123.2638675-16-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:22 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntedq18rej.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 15/16] KVM: arm64: selftests: Augment existing timer test
 to handle variable offsets
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hi Marc,

First of all, thanks for your previous responses to my comments. Many of
them clarified things I did not fully understand on my own.

As I stated in another email, I've been testing this series on ECV
capable hardware. Things look good but I have been able to reproduce a
consistent assertion failure in this selftest when setting a
sufficiently large physical offset. I have so far not been able to
determine the cause of the failure and wonder if you have any insight as
to what might be causing this and how to debug.

The following example reproduces the error every time I have tried:

mvbbq9:/data/coltonlewis/ecv/arm64-obj/kselftest/kvm# ./aarch64/arch_timer  
-O 0xffff
==== Test Assertion Failure ====
   aarch64/arch_timer.c:239: false
   pid=48094 tid=48095 errno=4 - Interrupted system call
      1  0x4010fb: test_vcpu_run at arch_timer.c:239
      2  0x42a5bf: start_thread at pthread_create.o:0
      3  0x46845b: thread_start at clone.o:0
   Failed guest assert: xcnt >= cval at aarch64/arch_timer.c:151
values: 2500645901305, 2500645961845; 9939, vcpu 0; stage; 3; iter: 2

Observations:

- Failure always occurs at stage 3 or 4 (physical timer stages)
- xcnt_diff_us is always slightly less than 10000, or 10 ms
- Reducing offset size reduces the probability of failure linearly (for
   example, -O 0x8000 will fail close to half the time)
- Failure occurs with a wide range of different period values and
   whether or not migrations happen

