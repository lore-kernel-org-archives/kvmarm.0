Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864F8268C45
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 18:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739557574; cv=none; b=Iy5qxZxLVnLmVhyxYVMI/v5XH1QeEMW3DeYpF1jOtp4W78Pnjau6g8gemE58jF7YnfiLoQMQsC5y0ERZACih8/LXd3DJVV65P6hQecZetppwpmkfmvxYYjl5xgb+UpF1f1VT5oeTI0BjUAQVLIoeosZLxGQNmqYF9olaCMgCrZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739557574; c=relaxed/simple;
	bh=8/DTlY3pk3a6G5GXzvpYerG+E5kgBFJPd3Pov9X0qd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efE9oC65P00ZDal3pg7MrB0SB/QF5gB6xmlg2HPD7mWRaMaIH6mb0gh7dmAP0sz9IqrrMUBkM5f18Z9o3Y/G5EHdjfMqZ9SBXwObmnLarKy/fmRv6Bs65qOKDa9OPDYE48OymOIz2uh5Sf4JKXU4qRb7Qxi2lSwfNAaPL8b52BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ARQd3heW; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ARQd3heW"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6e1b11859a7so12813156d6.1
        for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 10:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739557571; x=1740162371; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8/DTlY3pk3a6G5GXzvpYerG+E5kgBFJPd3Pov9X0qd0=;
        b=ARQd3heWPsY99JEICLvLWbaCptcPQrsIjEiSgiiJwXf8hrWxn5743Bf93f0iBqjPXg
         ycdoaAt50PgO1x1uyKf82xISko0JvE4jOj3NppDYYQMYMBLRYgG7BG8Lvt+hVqdmrKWl
         Gq43tLfMvHCnBmPnzLsZnFTQZjq/mwk5ereR6krd5AUcePvNf3zMwgpyQ/6KPkpz9IDz
         C1jiDQFgGvURZxfyTxQ5kXkDc9jZjQhHry1rlIQl0yjUio8dfoxj4J0u1h4sPjgKV1aS
         I6cMrjawZqyymeluNb9xTvoTsGP9JXKdkdgrAcJbXUAVQtZauoGHMJ1l6EOC6vufYOvE
         T5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739557571; x=1740162371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8/DTlY3pk3a6G5GXzvpYerG+E5kgBFJPd3Pov9X0qd0=;
        b=vdfSvoUk3I5LaQ1COQ1JRIqDmKgEgP9/9Psv6+PfscQ/4nkmtJDOunqZ9FktvtdpIj
         H3voS4Kgj8sA2GPQylWR9/lfeXm29bBLGS9UPfA4zFIuYKfEB0d5vXE4OXYrBVKeYOeX
         cr0rb9m3ZPy6FEc9fwpD/bbgM9ePCD5UMewYuTE2az1/2kBhd6QjX9NBezJgLa6lpFHj
         BMcUzdoaZX10M+D55eZjkbmbFzlgfm4iLzA8OOrzVRUFgbS2V1Oa3NaOenkxx/WMAPzR
         PBx1e1iIIrqxjDNLIC2tk+UFtQlr9fS9EuFrge+ShfEmq874w1THNmpbeX7kb+OJMzvG
         77lA==
X-Forwarded-Encrypted: i=1; AJvYcCWM5tIImimI2MZ85IXkD3B74cC6cMYlGVohkyF05pvf4oJcJCdXDpaw4GcG4NC0nuI4EEacwCE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxF6Jef+3Sls/5B02BFpsSCq6xB8hWwAejZ44/VbTSMfvEFiAHV
	IolZJw36I5KTNRK67W+oP3lgF60mTURksxjkgegwmuyMXeNM1jcresjdlWXdeLwrymL+JVM+3oO
	A4GLuDXmsdMngjzm5LnIwtUFRmPo+XrKHn2nw
X-Gm-Gg: ASbGncvqEKT3yrOU1AF8Hc+ljatpdZXsPttvavc+/NRLHaA3ZE3O4maJEHt+eAK5LJi
	DxPsredZGBMeGdg9GwKftM3yW/kxXUr9cDYDsMwbbJi8c300HrSzSIAeOpnhPgLZIgTZE0587ow
	==
X-Google-Smtp-Source: AGHT+IGahO+EoJpVHDz9mbFwHtAtBgh2jW//CnO6047oFzoeAKzVdEu897lF5sKUl3q6+qKe1aK2ZHZslrcLAQtD1ro=
X-Received: by 2002:ad4:5e8d:0:b0:6e6:5d61:4f01 with SMTP id
 6a1803df08f44-6e66ccb10aamr4166886d6.8.1739557571225; Fri, 14 Feb 2025
 10:26:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250212182558.2865232-1-maz@kernel.org> <Z618Rd__s7g8xWNP@linux.dev>
 <CAG_fn=VYXBce+0S7=ZuggNKvn4-b7awWVtq4v9B14U9ivRimkw@mail.gmail.com>
In-Reply-To: <CAG_fn=VYXBce+0S7=ZuggNKvn4-b7awWVtq4v9B14U9ivRimkw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 14 Feb 2025 19:25:34 +0100
X-Gm-Features: AWEUYZkxugIvEIapXiq7ONrYCsVBhyQwzdKS6SZSHOx5KJD3E1IzJKN9kjxUoow
Message-ID: <CAG_fn=W0_ra0waM4ur-ADmaNqHC1JXP--sp3eaP3xivgsdfxuA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] KVM: arm64: Assorted vgic fixes for 6.14
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 11:29=E2=80=AFAM Alexander Potapenko <glider@google=
.com> wrote:
>
> On Thu, Feb 13, 2025 at 5:59=E2=80=AFAM Oliver Upton <oliver.upton@linux.=
dev> wrote:
> >
> > On Wed, Feb 12, 2025 at 06:25:56PM +0000, Marc Zyngier wrote:
> > > Alexander, while fuzzing KVM/arm64, found an annoying set of problems=
,
> > > all stemming from the fact that the vgic can be initialised or
> > > destroyed in parallel with the rest of the guest still being live.
> > >
> > > Yes, this is annoying.
> > >
> > > This second version takes a different approach at the problem,
> > > plugging the glaring hole we have between vgic creation and private
> > > interrupt allocation.
> > >
> > > Although this is more invasive, I'm more confident about this one tha=
n
> > > the initial version I posted a week ago.
> >
> > Much better place now! Here's to the next pile of syzkaller bugs :)
> >
> > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> >
> > > Alex, I'd very much appreciate your testing on this.
> >
> > I too would like to see the tires kicked before we pick this up, if it
> > isn't too much trouble Alex.
>
> I am on it, will report back today or tomorrow.

I am seeing the following crashes, do you think these could be related
to your changes?

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: null-ptr-deref in _raw_spin_lock_irqsave+0xa8/0x174
include/linux/instrumented.h:96
Write of size 4 at addr 0000000000000d20 by task syz.3.8387/5166

CPU: 1 UID: 0 PID: 5166 Comm: syz.3.8387 Not tainted
6.14.0-rc2-00002-g4b305a8c5b85 #159
Hardware name: linux,dummy-virt (DT)
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x94/0xc0 lib/dump_stack.c:120
 print_report+0xf8/0x7d4 mm/kasan/report.c:492
 kasan_report+0xcc/0x128 mm/kasan/report.c:602
 kasan_check_range+0x264/0x2a4
 __kasan_check_write+0x20/0x30 mm/kasan/shadow.c:37
 _raw_spin_lock_irqsave+0xa8/0x174 include/linux/instrumented.h:96
 kvm_vgic_set_owner+0x15c/0x23c arch/arm64/kvm/vgic/vgic.c:611
 kvm_timer_enable+0x174/0x5b0 arch/arm64/kvm/arch_timer.c:1574
 kvm_arch_vcpu_run_pid_change+0x184/0x28c arch/arm64/kvm/arm.c:824
 kvm_vcpu_ioctl+0xa94/0xba8 virt/kvm/kvm_main.c:4366
 __do_sys_ioctl fs/ioctl.c:51 [inline]
...
