Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9BD289E16
	for <kvmarm@lists.linux.dev>; Sun,  5 Oct 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759676220; cv=none; b=KjZ9WXiQqq3dc8Zwh1QNZmciUTb/hmKWLvsfirz3ZLa5hRlyvjepsXwqHMvoB+sB2iV3alOGkevPeprnqcweqbdx+SGtTJw3AjfbEF1a384q8E9Fr5KFazg/l5j2EGwmG2IYNW8Wsd1BO0M5pQ3JlBcp4blpSPsUkyJdTyaf4QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759676220; c=relaxed/simple;
	bh=Y+L7oxTglEs6TaCqZRGlKflLvr+9eNVWa1dQwDozuzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b7y1V17pQmk4LEOSQM0T4OETZ+tozqLZ/etXZszR4dQqbmoN33LEpUBKMAP0Vol/DzCKtDKkrYLPfxNWUu8QABO3y1/mHUio4Fh9e08bHG698+OhrKxIvpF6fXguWEvuzrqO9USFNO2wNcb5kR2ekSKo4QUTU6hPTV3M5TUaE5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/gVkemH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/gVkemH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF1FC113D0
	for <kvmarm@lists.linux.dev>; Sun,  5 Oct 2025 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759676220;
	bh=Y+L7oxTglEs6TaCqZRGlKflLvr+9eNVWa1dQwDozuzA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=h/gVkemHyk7NBmLosH9fbxJZ7kpNS6zu0xluG4bFqvLGYOGUZDp6b8uTHIegJJFR1
	 e1V5c2Jode7NctLrza9M3X0VUiIcJSVrxiadM7eAbXtF/1peBo+2F5iz/m2u79Aay5
	 RQ/d6zAAJBKImTcpGCVc/KAT0ucR63DQh9aWlVqUkXVVN7Y+maoYXuI99qHtv7o/KW
	 QBB+gp+zOfrZJQPH/3aWxjtNcHTAX3ecR2nybTTsw8Pfmz+fD86YwL99u0wy6G7T2J
	 Y2duyHIJwnwdg37eqvy9J1z1XtRCOuVvNmJ6nxOTYMbYTtsMVW/ge7zM7ipeE16HEK
	 A+78z8xQfxCHA==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-374d1db213cso21876001fa.0
        for <kvmarm@lists.linux.dev>; Sun, 05 Oct 2025 07:57:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWaJSZB8B7CKbM3iqtzpP/o8e90nPRdRGFfjC70odFCCZX6ZKeD16EEYMu7ezqLvNwhDbC8epA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4N2LowfXQf2mTUNMG0oXfkC0VGbh+4Ii0wJcmUBNdZ+KaSAqO
	AsBluh2T2P8IuBgyMubhgL6jXkwiJ6FURloWiwSkStqMxRIXmKm6l/XHnO+7lQ+2vbRjBylYgOC
	JPmrCk5OVRpbwHSkeQBpGz3X/Dg8zPY8=
X-Google-Smtp-Source: AGHT+IH7twvgnWuXM008bvuQkIdqZ77ZYuE4LRpBwjrRe3xkGR35VYjfgbhseLv8khD47pSwTdtdIDoHVJz+SLkG1xQ=
X-Received: by 2002:a05:651c:2112:b0:352:b6c0:d33e with SMTP id
 38308e7fff4ca-374c36fe0aemr30436501fa.11.1759676218449; Sun, 05 Oct 2025
 07:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251003184054.4286-1-will@kernel.org>
In-Reply-To: <20251003184054.4286-1-will@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 5 Oct 2025 16:56:47 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFmXZCPiB+oMsOjoqhwi4hBykamerki5dMOZMy2uouUMw@mail.gmail.com>
X-Gm-Features: AS18NWDdh4ZAp5XFFokXYmAoqAnRwM3Raujv5rpRowuKAB4ovo24Z1H_fbAUyiE
Message-ID: <CAMj1kXFmXZCPiB+oMsOjoqhwi4hBykamerki5dMOZMy2uouUMw@mail.gmail.com>
Subject: Re: [STABLE 6.6.y] [PATCH] KVM: arm64: Fix softirq masking in FPSIMD
 register saving sequence
To: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kenneth Van Alstyne <kvanals@kvanals.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Oct 2025 at 20:41, Will Deacon <will@kernel.org> wrote:
>
> Stable commit 28b82be094e2 ("KVM: arm64: Fix kernel BUG() due to bad
> backport of FPSIMD/SVE/SME fix") fixed a kernel BUG() caused by a bad
> backport of upstream commit fbc7e61195e2 ("KVM: arm64: Unconditionally
> save+flush host FPSIMD/SVE/SME state") by ensuring that softirqs are
> disabled/enabled across the fpsimd register save operation.
>
> Unfortunately, although this fixes the original issue, it can now lead
> to deadlock when re-enabling softirqs causes pending softirqs to be
> handled with locks already held:
>
>  | BUG: spinlock recursion on CPU#7, CPU 3/KVM/57616
>  |  lock: 0xffff3045ef850240, .magic: dead4ead, .owner: CPU 3/KVM/57616, .owner_cpu: 7
>  | CPU: 7 PID: 57616 Comm: CPU 3/KVM Tainted: G           O       6.1.152 #1
>  | Hardware name: SoftIron SoftIron Platform Mainboard/SoftIron Platform Mainboard, BIOS 1.31 May 11 2023
>  | Call trace:
>  |  dump_backtrace+0xe4/0x110
>  |  show_stack+0x20/0x30
>  |  dump_stack_lvl+0x6c/0x88
>  |  dump_stack+0x18/0x34
>  |  spin_dump+0x98/0xac
>  |  do_raw_spin_lock+0x70/0x128
>  |  _raw_spin_lock+0x18/0x28
>  |  raw_spin_rq_lock_nested+0x18/0x28
>  |  update_blocked_averages+0x70/0x550
>  |  run_rebalance_domains+0x50/0x70
>  |  handle_softirqs+0x198/0x328
>  |  __do_softirq+0x1c/0x28
>  |  ____do_softirq+0x18/0x28
>  |  call_on_irq_stack+0x30/0x48
>  |  do_softirq_own_stack+0x24/0x30
>  |  do_softirq+0x74/0x90
>  |  __local_bh_enable_ip+0x64/0x80
>  |  fpsimd_save_and_flush_cpu_state+0x5c/0x68
>  |  kvm_arch_vcpu_put_fp+0x4c/0x88
>  |  kvm_arch_vcpu_put+0x28/0x88
>  |  kvm_sched_out+0x38/0x58
>  |  __schedule+0x55c/0x6c8
>  |  schedule+0x60/0xa8
>
> Take a tiny step towards the upstream fix in 9b19700e623f ("arm64:
> fpsimd: Drop unneeded 'busy' flag") by additionally disabling hardirqs
> while saving the fpsimd registers.
>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Sasha Levin <sashal@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org> # 6.6.y
> Fixes: 28b82be094e2 ("KVM: arm64: Fix kernel BUG() due to bad backport of FPSIMD/SVE/SME fix")
> Reported-by: Kenneth Van Alstyne <kvanals@kvanals.org>
> Link: https://lore.kernel.org/r/010001999bae0958-4d80d25d-8dda-4006-a6b9-798f3e774f6c-000000@email.amazonses.com
> Signed-off-by: Will Deacon <will@kernel.org>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
