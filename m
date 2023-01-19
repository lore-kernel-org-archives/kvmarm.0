Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A3DA950
	for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 18:26:34 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id e202so3641563ybh.11
        for <kvmarm@lists.linux.dev>; Thu, 19 Jan 2023 10:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6VWrds5+dcyT0rgINmTYYWINCVZd2T1PEujEHrsOcLw=;
        b=A6TDGupcab5kBFctEX907rvmeNwH7TSFDFaHTIVyeD6PCreG08fGa15PQ7ZMqoS+1m
         Kxbe26YgQAvS6hpbgLxITj1eUcRA8mIo1x+Mapl67QqS5wyfrfuzRCU1tnxWZ0TS289l
         w3u3MCioCSxlocWRtMKRdepquBJ0iHc8nYrd/K5h7zL2JXs5cWFUvxAeTGvuzHlMKRgk
         egdpFD/bkXLZwSYHG+Z0kzwbLNaNF2PleWXHewOXJKxTE0H7QO7vqhNkuBSN+9K0BgW4
         CUQWNgNvG4kQ6jAFI0ws+04L11xvj5+5tglT7p+FQ3rESyEpFyu6RBShjx3VyQd9khW6
         qgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6VWrds5+dcyT0rgINmTYYWINCVZd2T1PEujEHrsOcLw=;
        b=2fzXjXtf8kHm1n6upiMEyojCw9F+wOThJXOQ1hjc9tyAcfIN0yUZpft+TWQFlkjUQm
         5sdpE28QCCw7rm9y0EM5qs3rjiiRH79eEDuY2t/4wudSEqwbFhyuAAYWInFttO+0qsAC
         84pc59kpfVs/YZDGiLtupgWMfD3PWDdbWEXJ4nJhutajpolPJLvS4g3svILB+08ljyB3
         /aUxB09kbbRP4M5x+EsXaVhGYTcKkUslr0TkSFhfwgx/dxxgJOzMh4onPIqZUBdWn5bj
         4S4SjSJcMstFyQ8iTOX1pmBD3wxfb/JUOLZz180Sr1GEUNJu6Swgj1DH3n4lPhOqNvhF
         B7JQ==
X-Gm-Message-State: AFqh2kpmuFPSsyZmRlhcBpKCy5UoR0ro4Vepqp81jS0vi60tlq50jE3m
	Nuddn7nAoBRBpX+kllQTnCrMVxPLS+xRr+hebMXykg==
X-Google-Smtp-Source: AMrXdXtwLTB5KOOpcHVBzvFcacNzq2MmR9bQGZt/ij36G6vo5gOSujCeJE0W7g6T7dRw7IL5u3KJsp+ZIGFjXU2FYsA=
X-Received: by 2002:a25:1984:0:b0:7fe:e7f5:e228 with SMTP id
 126-20020a251984000000b007fee7f5e228mr146711ybz.582.1674152793200; Thu, 19
 Jan 2023 10:26:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230119173559.2517103-1-dmatlack@google.com> <20230119173559.2517103-5-dmatlack@google.com>
 <Y8mJQH4VqC76sX7k@google.com>
In-Reply-To: <Y8mJQH4VqC76sX7k@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 19 Jan 2023 10:26:06 -0800
Message-ID: <CALzav=fN40q2QCcBuUdTg2z2sJLeRo9u4UCaW5grX5LC-bKqkg@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: x86/mmu: Rename kvm_flush_remote_tlbs_with_address()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 19, 2023 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 19, 2023, David Matlack wrote:
> > Rename kvm_flush_remote_tlbs_with_address() to
> > kvm_flush_remote_tlbs_range(). This name is shorter, which reduces the
> > number of callsites that need to be broken up across multiple lines, and
> > more readable since it conveys a range of memory is being flushed rather
> > than a single address.
>
> FYI, this conflicts with Hou's series, which I'm in the process of queueing for
> v6.3.
>
> https://lore.kernel.org/all/cover.1665214747.git.houwenlong.hwl@antgroup.com

Ack. I can resend on top of Hou's once it's queued.
