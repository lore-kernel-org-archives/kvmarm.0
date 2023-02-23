Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA2AD26
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 22:29:31 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536bf635080so153047717b3.23
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 14:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=jFLVngoi/Pj7Xk/eCMq8tP4XJF8j3XFIqui52VpZPJAx8/hzuaONFGRRlzWa63/fl2
         SI0zjjKiFIWT+aprJz02CYJUfUx98g+UHDfC3TX6FeRrVNpx+gWh0hoj6KpylXckrr1y
         mhgYsE7Ml2cAyM19Koccmums5UiRkyLacJtP7LIYLhSdhQ+SP8DzK4ojMk1tNUDxqrej
         lHtSqE9qBy/5aWUEMn6SWBHVDHtxWYr/kS48QW/qokIF0v57KN64O2gMahbQRqZS0Do2
         aLFvN2ReyBaxCQnkp5QjUOftRkEe38BLAKCyX0OEee59d7wYuuO4dmogDSO5Opz9qfIE
         FBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9eEgAqxwwT4oBExX9UxWqccj7ZXr1sZAWCiBgAFhOg=;
        b=2P/X4uCGtn/0MasqKO9xP+5ufTK0507t76pfp0u7HWf8UhCtKgffK0op5FWs7FrQl4
         3VxSyx5lhggmCKkan+fj3HLe1YE1tXpdDryMXe/HcukCgnIBnG9Bi2wGfQMKx72rso9q
         DYT7z27hUU7N/Iz+E1MPC7G3I5nHlhhsJtNc94yzDvEy9V7cy3qh5V9qbbudmQXZOY6o
         Boq68/kduJp4fsfZiImlEhS6Zsk5xnxPhFjFUvc4VU0TJC/kqHYRQ32+9QfkLqegJfop
         4TTRt3RshY4yOaIMmKVF6Hxn8JldNatggyOUrrINZrYF27r7vViLPXPPgaI7WgQQlfg/
         C4yA==
X-Gm-Message-State: AO0yUKVl8dk7JjB+4U96SNfxaTKLdxOF7yF3W8wLv6VWsAn1AxlXvMXy
	b4kSqWBR9bh/fofJCXvY+WY84+pNs0MuTxGqPw==
X-Google-Smtp-Source: AK7set9GbtJblkfY1G9F3ZARNAI1ilgRjyI3NMnBus6IJ5uQtMRl+4SsjQVspoqe81g0EBTPNyvyx8p3Qeo9QafF2g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1183:b0:a27:3ecc:ffe7 with
 SMTP id m3-20020a056902118300b00a273eccffe7mr2945020ybu.3.1677191370715; Thu,
 23 Feb 2023 14:29:30 -0800 (PST)
Date: Thu, 23 Feb 2023 22:29:29 +0000
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:07 +0000)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt4jrc9fsm.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 00/16] KVM: arm64: Rework timer offsetting for fun and profit
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, 
	ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello Marc,

This patch is of special interest to me as I was working on my own
ECV/CNTPOFF implementation, although mine was more narrow and doesn't
address any of your other goals. As far as I can tell at the moment,
your patch can cover the uses of mine, so I will dedicate
myself to reviewing and testing yours. Please include me on any future
rerolls of this patch.

Marc Zyngier <maz@kernel.org> writes:

> This series aims at satisfying multiple goals:

> - allow a VMM to atomically restore a timer offset for a whole VM
>    instead of updating the offset each time a vcpu get its counter
>    written

> - allow a VMM to save/restore the physical timer context, something
>    that we cannot do at the moment due to the lack of offsetting

> - provide a framework that is suitable for NV support, where we get
>    both global and per timer, per vcpu offsetting


If I am understanding your changes correctly, you introduce some VM-wide
timers with no hardware backing and a new API to access them from
userspace. This is useful both because it makes the code simpler (no
need to manually keep registers in sync), and so CNT{V,P}OFF can be
appropriately virtualized with NV. Is that a fair summary of the
important bits?

> This has been moderately tested with nVHE, VHE and NV. I do not have
> access to CNTPOFF-aware HW, so the jury is still out on that one. Note
> that the NV patches in this series are here to give a perspective on
> how this gets used.

> I've updated the arch_timer selftest to allow offsets to be provided
> from the command line, but the arch_test is pretty flimsy and tends to
> fail with an error==EINTR, even without this series. Something to
> investigate.

I can help you with testing because I have access to CNTPOFF-aware
hardware and emulators. Is there anything you are especially interested
to try out?
