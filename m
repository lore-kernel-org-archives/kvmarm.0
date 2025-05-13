Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86DF24E01D
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 11:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747135096; cv=none; b=ZaSr2g1aWQy27YtGr02XdyxOJqsuhmL56JspDa1HFezfXxntFv/z9IRVfs0EVsS4VLmXS0P5jnR1e3ZXsz1iApewsy4Xpd1SE/ZCwfsS+Z/qhfIvhzK279Jl0uWCo1cwoKMyKbesPF4LP3PSfnBlZoz6C9Qo6naMxbNYnTBA+14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747135096; c=relaxed/simple;
	bh=bt3PcsKgfQ9j3zmMb3mcRAdFY5r4VES5fQ5CB5RXHsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SEY98b/4w5KFlRoON9mUGxXBsY3BCJSrObaadaO7w8OgZEpYdo/cAx+VHncuRQ34gI1oSK0S914meW/QtYFgawpCy77WzVXKKUifGXd3do4GA9y8L5dgW60BfoRXkIV/JWSxWB5Qqmv9FQGPqjFe42Dvwt3HYRppLdmlGnOrQVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=l8Q/S4hn; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="l8Q/S4hn"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86135ad7b4cso295040139f.1
        for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 04:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747135094; x=1747739894; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CO3XD8l6ux1EVBnvjNxNYVBqO7/BMtxK8+QVey7D+08=;
        b=l8Q/S4hnoKuCYAeK+QlqA1LFpqZVPSUPEMQ4Sz1yumt3gbyz0n7udeZ6h9Ymum5Hc1
         K0AJwWcwU0g/TQedmxdYLxA/G768n6vtXZ02wdQLGjQ8PtXgIHkKDj24nfif54aNyaaj
         V6GoLQRYmIC4SNUa7gW/wgYIDGt+JPguu4lLCg/GGHvGwFEev7g/oEKHwPrk6tUHax6Y
         x07gOg3LpMaISRppQrZe9S6uMlZjq5Vnkjo6N1D57yzF6NvvMMlzNhDwT9rCQJ71Igc/
         9SHFSN0HFn5UAzjqhAGmMCH/hIBsjQC5K9oCLLRs/a5bF9D8tronWCKMAIWkKsV30Ofj
         JytQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747135094; x=1747739894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CO3XD8l6ux1EVBnvjNxNYVBqO7/BMtxK8+QVey7D+08=;
        b=RHEeEuS0xKMgw7kGYNtWgHyaJZMyJ4cOe6CBkATjBz2UWoki0O0rgSykfb2fqV2hB5
         g6c/Bc90EyDPL9VNFY3/AS2j3gXFrRKHJ47q61/ZWNQDV2c1xVBKfWhW88RsfBPq75pG
         PZ4Dv1W+8/4j+7or5QUNDATDlRH82BtfH8yyUp9UAWB2Z0mjrtJAycAMUqe53dCucYxB
         ybJoN0Kov3Jzi4pvb+7hGRmgQelTUdts+zzBs1kBcRSiJH23XlWGRKyS30mFNETOenjg
         l3UY0xm4B3eAAsOzDxEDSdx84MgcFzAPaJabLJ4Ij53s4JScbVLPjqhrsLyqVVXSLtX4
         /3cQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIKifK86RjrEKNWw6CWt0vc64TYFu1Y57SrgA/L+oA0s/U+ZwKjZhmAuatwaqeoDY17I+YX0M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwR7mpnSKODkA4rVC/UKthzbzUYEvuqhFX3Cd+kRBf7N6eAKTKb
	F5X7uethABLJadkKDS4DzwrWr9xz6MeUGIju4ytLBVF/pvm3IqWEoMGFrv4sZ1htrhHws2Jf+AO
	CIS6elAlEpjdq8+MR3kJN53TOZ4QfFwI/V/7TaQ==
X-Gm-Gg: ASbGncuBaZQFIdrkX8HTyP1xeCHMAQzFGP1xmXJ5cW66++dVm3h9gWaY1KMVWZQXXL+
	NiiuiPb/PQfAG6ty34EPSrvYMgO0dI7tiqPZVAlwRh9k0ECKaEe7wLSuqyziDHC/nGKvSBomX09
	5p9Ehtob0x5r3yJ8BVvWFdgqP1Wgr+8nkK3g==
X-Google-Smtp-Source: AGHT+IF0TFlq7FI2UFso/yWVI99zcgMhkSX+i8735DmLyH2X4sWMpcDOU2yubNACzzbHeqk7+uSqM/W5xKTfdB5E+cI=
X-Received: by 2002:a05:6e02:2282:b0:3d6:cbed:330c with SMTP id
 e9e14a558f8ab-3da7e1efc2amr168845325ab.11.1747135093673; Tue, 13 May 2025
 04:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512180407.659015-1-mlevitsk@redhat.com> <20250512180407.659015-7-mlevitsk@redhat.com>
In-Reply-To: <20250512180407.659015-7-mlevitsk@redhat.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 13 May 2025 16:48:02 +0530
X-Gm-Features: AX0GCFuh9Grm7ZDwE_uX_FG0oRRGo90WBh2IG8oJVp8cnWQQL4gcnv0Sdw9D2vw
Message-ID: <CAAhSdy3H8LaDHJq6H0rFirsWhC8tnE+bWwmWFtO8Eag-kcXcSA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] RISC-V: KVM: use kvm_trylock_all_vcpus when
 locking all vCPUs
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Sebastian Ott <sebott@redhat.com>, Shusen Li <lishusen2@huawei.com>, 
	Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-arm-kernel@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>, 
	Borislav Petkov <bp@alien8.de>, Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Alexander Potapenko <glider@google.com>, kvmarm@lists.linux.dev, 
	Keisuke Nishimura <keisuke.nishimura@inria.fr>, Zenghui Yu <yuzenghui@huawei.com>, 
	Peter Zijlstra <peterz@infradead.org>, Atish Patra <atishp@atishpatra.org>, 
	Joey Gouly <joey.gouly@arm.com>, x86@kernel.org, Marc Zyngier <maz@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Andre Przywara <andre.przywara@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>, linux-riscv@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-kernel@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	kvm-riscv@lists.infradead.org, Ingo Molnar <mingo@redhat.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 11:35=E2=80=AFPM Maxim Levitsky <mlevitsk@redhat.co=
m> wrote:
>
> Use kvm_trylock_all_vcpus instead of a custom implementation when locking
> all vCPUs of a VM.
>
> Compile tested only.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

For KVM RISC-V:
Tested-by: Anup Patel <anup@brainfault.org>
Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kvm/aia_device.c | 34 ++--------------------------------
>  1 file changed, 2 insertions(+), 32 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
> index 39cd26af5a69..6315821f0d69 100644
> --- a/arch/riscv/kvm/aia_device.c
> +++ b/arch/riscv/kvm/aia_device.c
> @@ -12,36 +12,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
>
> -static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
> -{
> -       struct kvm_vcpu *tmp_vcpu;
> -
> -       for (; vcpu_lock_idx >=3D 0; vcpu_lock_idx--) {
> -               tmp_vcpu =3D kvm_get_vcpu(kvm, vcpu_lock_idx);
> -               mutex_unlock(&tmp_vcpu->mutex);
> -       }
> -}
> -
> -static void unlock_all_vcpus(struct kvm *kvm)
> -{
> -       unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
> -}
> -
> -static bool lock_all_vcpus(struct kvm *kvm)
> -{
> -       struct kvm_vcpu *tmp_vcpu;
> -       unsigned long c;
> -
> -       kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
> -               if (!mutex_trylock(&tmp_vcpu->mutex)) {
> -                       unlock_vcpus(kvm, c - 1);
> -                       return false;
> -               }
> -       }
> -
> -       return true;
> -}
> -
>  static int aia_create(struct kvm_device *dev, u32 type)
>  {
>         int ret;
> @@ -53,7 +23,7 @@ static int aia_create(struct kvm_device *dev, u32 type)
>                 return -EEXIST;
>
>         ret =3D -EBUSY;
> -       if (!lock_all_vcpus(kvm))
> +       if (kvm_trylock_all_vcpus(kvm))
>                 return ret;
>
>         kvm_for_each_vcpu(i, vcpu, kvm) {
> @@ -65,7 +35,7 @@ static int aia_create(struct kvm_device *dev, u32 type)
>         kvm->arch.aia.in_kernel =3D true;
>
>  out_unlock:
> -       unlock_all_vcpus(kvm);
> +       kvm_unlock_all_vcpus(kvm);
>         return ret;
>  }
>
> --
> 2.46.0
>
