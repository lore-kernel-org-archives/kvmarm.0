Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA57127147C
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 10:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748428133; cv=none; b=gqbkcxHEFhOTb7knnmSAsMuGlDUvU4GHVoGWdcFDcUdW5z2t8xY7W/QAgZ9NHlJ4FbqrPuCZfV6p5ocht96xe5UhwFElg26KyoTbunrvoBJYdXFLO/Ubi2USZ4RuHTRlkJi5C0SHc3plYSnR30lK2zA3bOuQrPy0frdTEExH68Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748428133; c=relaxed/simple;
	bh=pevQLIwlYhcrh9j/PEoiFM8IoOPUhaa8Z8UX5eKAVSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FgbQL1We9Gu6Z9/POFoRaVR7hWLt8wZOeLCO1F8oto5IhYvUpQ0CdgTkJh4mY+ySOjl65orwnl8RaaGIQ5W+40gC9ASL5W4gsFMEhpqA+yKb823C7O21sVZ+RyAS4yUwPaZ4/tkvb4NOTQAT+FZnhU0ZPbmIpkxV9O8BV3zEXdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n1qXbrVr; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n1qXbrVr"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6fab5dfe095so13712286d6.1
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 03:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748428130; x=1749032930; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPM+otKwF7DxF026kJrXJ2nOt14z8mTLc7lr53b8T9c=;
        b=n1qXbrVrZokH0QThy7oMXz+G6ADpvJhr0au4ANy5pBvBXNWS8RJSuyry+igksTFdXC
         fKsXJ6jAGeQMtaQuyvxq9dUry2vxp7+1FUqLU8qoPRFo72vROt2TUiY9UocToYdsLIbM
         FJPumC9CSqqIixaM5bAGKQFdYwh5szyje2qKH1O5v4e5LLf8p7eYhhGF7XtfFvAHuKV5
         W5qK7F7wrph2IpvWyIaoSh/sZ9OcXR1Xzf8mY09Hbrkkk6qwbg4j/46wrP3BKHO7dHK4
         ryuyzcauhY9ssiG8TQJnRmGgR9xZi9iaHxOtSVd513AUhIf5/nmRfSH0BrAlE7PSRUgJ
         Vczg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748428130; x=1749032930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPM+otKwF7DxF026kJrXJ2nOt14z8mTLc7lr53b8T9c=;
        b=QhtwZ22mgiObrqaUsY3Ym1LwNm+383NKUQ62vYR9wlVRTX1quz5A2bfS9qHsTm+Z/U
         CIMz0BuvfIkPS74Hyq7tWC1YYxR5rAMCH8VXHemtaURzVjrgprEjihxwsc6EHEy8LnUP
         Rt19u8a3kUQ7w90lasGCL1HYKx4ZL7PP0jOMgrdmd3hAOFrrGdWR9Cig2fvNwUmt8ADn
         Xhpjhsjzwwj5PCYP3+qWuIjiNkeh0v6QeDpvjFIn6DcPdM7oviesaNxYEiWEJPrW+Iu6
         /leFtWiPAqxEqvEKUBc8p+KFiuXqqlahc+h37oKlWq7sQH45fsr4GuPLJ/js9FqPi08y
         ebOg==
X-Gm-Message-State: AOJu0YwUVSmbbjVS1kvjN7T6D2r0YnXBEac4hwzs9ShAHafScJk+XVia
	NdXZL6hgRq0ch+KJffewZCAQbTm0CLGcdlk8UVpJDXHtWxVSaMTQZ0PLmCGWIVDYfGchmdpmM3u
	xPp1DQdCWEXSHDQIsGXdR1p5gzbdenpSX/HTcjoQ+txqLjGsePKTWgm0L
X-Gm-Gg: ASbGncvzrXWEKXacOJ9tZl6IzkrG0sgoYca0AZXyjzognU97B2ArpQJn+kfPzc6ScjI
	EJ8UhG17ViGQcl2Af1agDk4NmAqNH0RZuxDRsz3xoZEVx74k1wtzFsaj3vXkrq1MHejVFu4xi/1
	LxqU0GzX9dIFcxDuuACXsuQI4cUXqMMaf72si7kL57ypNKzClgc4TrtTrqe5GnIOtrhzHrEs/kj
	A==
X-Google-Smtp-Source: AGHT+IE2MBfXrh2pPNKnu5xPskQVXuxIGACW0lcXCrwydnw01xsBlJMRiX8UyXtGVlJBsgYuIqcq/rmdSbFUWhrAaH0=
X-Received: by 2002:a05:6214:4214:b0:6fa:c41e:cc70 with SMTP id
 6a1803df08f44-6fac41ed6b7mr1758756d6.22.1748428119770; Wed, 28 May 2025
 03:28:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250523194722.4066715-1-oliver.upton@linux.dev> <20250523194722.4066715-6-oliver.upton@linux.dev>
In-Reply-To: <20250523194722.4066715-6-oliver.upton@linux.dev>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 28 May 2025 12:28:02 +0200
X-Gm-Features: AX0GCFuqo7ZNxWaDrV25pmfr_3Q-U8pasM8cRQqGf1TpcbGpNVMOpQtB602UFNg
Message-ID: <CAG_fn=U37fM9y8iT8XPRWAwa3ygNOPtNaQgFLw9-gDQ_vc+r0g@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: arm64: vgic-init: Plug vCPU vs. VGIC creation race
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2025 at 9:47=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> syzkaller has found another ugly race in the VGIC, this time dealing
> with VGIC creation. Since kvm_vgic_create() doesn't sufficiently protect
> against in-flight vCPU creations, it is possible to get a vCPU into the
> kernel w/ an in-kernel VGIC but no allocation of private IRQs:
>
>   Unable to handle kernel NULL pointer dereference at virtual address 000=
0000000000d20
>   Mem abort info:
>     ESR =3D 0x0000000096000046
>     EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>     SET =3D 0, FnV =3D 0
>     EA =3D 0, S1PTW =3D 0
>     FSC =3D 0x06: level 2 translation fault
>   Data abort info:
>     ISV =3D 0, ISS =3D 0x00000046, ISS2 =3D 0x00000000
>     CM =3D 0, WnR =3D 1, TnD =3D 0, TagAccess =3D 0
>     GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
>   user pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000103e4f000
>   [0000000000000d20] pgd=3D0800000102e1c403, p4d=3D0800000102e1c403, pud=
=3D0800000101146403, pmd=3D0000000000000000
>   Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
>   CPU: 9 UID: 0 PID: 246 Comm: test Not tainted 6.14.0-rc6-00097-g0c90821=
f5db8 #16
>   Hardware name: linux,dummy-virt (DT)
>   pstate: 814020c5 (Nzcv daIF +PAN -UAO -TCO +DIT -SSBS BTYPE=3D--)
>   pc : _raw_spin_lock_irqsave+0x34/0x8c
>   lr : kvm_vgic_set_owner+0x54/0xa4
>   sp : ffff80008086ba20
>   x29: ffff80008086ba20 x28: ffff0000c19b5640 x27: 0000000000000000
>   x26: 0000000000000000 x25: ffff0000c4879bd0 x24: 000000000000001e
>   x23: 0000000000000000 x22: 0000000000000000 x21: ffff0000c487af80
>   x20: ffff0000c487af18 x19: 0000000000000000 x18: 0000001afadd5a8b
>   x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000001
>   x14: ffff0000c19b56c0 x13: 0030c9adf9d9889e x12: ffffc263710e1908
>   x11: 0000001afb0d74f2 x10: e0966b840b373664 x9 : ec806bf7d6a57cd5
>   x8 : ffff80008086b980 x7 : 0000000000000001 x6 : 0000000000000001
>   x5 : 0000000080800054 x4 : 4ec4ec4ec4ec4ec5 x3 : 0000000000000000
>   x2 : 0000000000000001 x1 : 0000000000000000 x0 : 0000000000000d20
>   Call trace:
>    _raw_spin_lock_irqsave+0x34/0x8c (P)
>    kvm_vgic_set_owner+0x54/0xa4
>    kvm_timer_enable+0xf4/0x274
>    kvm_arch_vcpu_run_pid_change+0xe0/0x380
>    kvm_vcpu_ioctl+0x93c/0x9e0
>    __arm64_sys_ioctl+0xb4/0xec
>    invoke_syscall+0x48/0x110
>    el0_svc_common.constprop.0+0x40/0xe0
>    do_el0_svc+0x1c/0x28
>    el0_svc+0x30/0xd0
>    el0t_64_sync_handler+0x10c/0x138
>    el0t_64_sync+0x198/0x19c
>    Code: b9000841 d503201f 52800001 52800022 (88e17c02)
>    ---[ end trace 0000000000000000 ]---
>
> Plug the race by explicitly checking for an in-progress vCPU creation
> and failing kvm_vgic_create() when that's the case. Add some comments to
> document all the things kvm_vgic_create() is trying to guard against
> too.
>
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Alexander Potapenko <glider@google.com>

This fixes the problem for me, thank you!
