Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795734968;
	b=Tk3HpUoQK/rH4gGKOH9DrdxgzczbVvyoWNx3fsUhQ37tDw2tQo/9fRcPHgi8xSOQltdf
	 74OkAg4dXA/RAw3tb5c4Bd3VvBYiRWll9jcPC+84UcqjnlIxb7bI6eBFnzdlCyoNbCbrY
	 dwRvonIu/OW4LfyjnatL3VZzWFXrhNxZmAlsL/vr5m9q3lhDpXXAmbgJSUBQkNJztNywM
	 Vf7Ed4dOXxd4SLA9iluzS2YKLLF7gAQqPffS+piAB3zTa2AyqVKURk799vWuX37hv1cFj
	 kmdda8Pb6UhTF4obBK6Du/UO97DzoaLKqptqAr+B1XRlqEneZrZoK/BtM49hKMslEUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795734968;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BWrRFuEPfNkDDgiMO5F3iE5SYJuRJ+VyIA3mL6UAwNc=;
	b=XQRFbG2kd3pFvb/6kXF+M9wBb//KLdkEB/4XzL55HZsQVs1c9NbuT74bTljOxwcH1pqF
	 qGEOTPyo4t9GSprhXtgsGRsO1h74nKcZOEseSuQ4VpiR1VPbj5AV8gs7F3jsXljyTOozL
	 LWpBHTMZsZ7JUO7OzKpRQgbU+ckN7GFEtFRSW89elo/xlJ6BfzmmuzqX6vwo5PRChLfZo
	 TRmhuWOwxzBAvxdi+pFYgpJfR5cVvFUBJfXBDVH9wsFWqWy+X4aDLZhDEKF0ojH8JO6EP
	 DCPY1E5JWisYb4M0TeBKaJFrnR9aQfcnh5XWviC3XxMlTCL9c29PbB8Dr/dOzYO0Dmw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tailscale.com;
	spf=pass smtp.mailfrom=tailscale.com;
	dkim=pass header.d=tailscale.com header.i=@tailscale.com header.a=rsa-sha256 header.s=google header.b=l7ApsQP2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.53
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9C6606A31C
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 23:16:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB9C6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tailscale.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tailscale.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tailscale.com header.i=@tailscale.com header.a=rsa-sha256 header.s=google header.b=l7ApsQP2
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-71ad2c6491fso4341384eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 15:16:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795734966; cv=none;
        d=google.com; s=arc-20260327;
        b=c+NCMVf0J6cPTr5S+ZZu629cQZUQ8/SSW9G+03GNkkcJOvF78OPX8/yNfYibL+Zd8L
         vFcJSclBZuR6tZH3/Cmc9HHO4i8REmZMXETj01gFsrhM5FASrUoiwA1g5MWoJa9cHugA
         2dLvmFOmalfBVYvx8uh/YM9hSc4yLulrWd9tyAeue1OokewQ8OWkyrZTeuIJ81zbCPK2
         rYoR78jW7p+fKOyhDSqbqQK8CYunNyh5BXQMND47+FdQS5nfg/GqQQx2XOA6l2dyW5vD
         Y2PKoGQrwnVhWCUTCny6vas9IycwQMhs5qkLv6xCFr7QceholuFvN3vtp8TPBZzV5J1y
         +tNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BWrRFuEPfNkDDgiMO5F3iE5SYJuRJ+VyIA3mL6UAwNc=;
        fh=MwM7aLquOB1kuGKS1MAwtxE+G5njDlMB0klNLqCU9+M=;
        b=sSlr79PH94c4/HI1+4JKZwNq2HevlezIDEBH/Pfr9Knvy9N2gm+RdO8pbGkpZBLCHz
         q0T68D0WKRNHc4Q2c7or6mZMu5t24oEWaXw8UKDvNyzIYscMuxM8sr0S1JNQ0vNeTcXU
         jYuM+pBGtaUG0V62zonEORgCbD0jg4qxMbx5afX5che939vKMR2zuiqOA+cxm0BE7Tni
         8gZmbNqZoANxLSoDiSPf3CkfQPHqBbYZc/+8gVyv6dzD7ycc6sM1wRwljhg3g0EBspS5
         2VZn6+zuAH15t0SahxgjcXDd6WkbFCotyhqCpiqbCyki/pR1AwAFDZR+U2PpLjpeZIZ/
         bArw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tailscale.com; s=google; t=1795734966; x=1796339766; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BWrRFuEPfNkDDgiMO5F3iE5SYJuRJ+VyIA3mL6UAwNc=;
        b=l7ApsQP2p2oa8SwrRAAPG7lmPlUBWBi8y+f79MhZ5TvdhxsCiffH2ux1vkgNOZPsPE
         jxdXa/lgW2Ej3Fxbet12MXDVO1Qsc5UVDUggRBZtL4CUzLzOPkfalyij6askiGd6n7nE
         h1FI+wU6LZRShsxkwm5TiL8BaZyMyc8cZcDN2QmoA9NNEHVvZhDWejEtDcEKIAZXiDMY
         0q4TWpmj9vpE41SyyME8xNfNpEffYbp8+7sliuV7lDshk5cSqyEojBqTBlLljt2rxbUy
         m5zcF/l6zjfYDoElTabFkYXDl/exZU/j9cZ8Xp5oYr+A8zEdukNn+xUuzG2WAsD7dA+s
         LkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795734966; x=1796339766;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BWrRFuEPfNkDDgiMO5F3iE5SYJuRJ+VyIA3mL6UAwNc=;
        b=Zwr0F4U7keZu/O7pl8IWSnyHkILVTPh9tSlC2c1SmVJxjNMn6UT8sk6eFFemqpZd2p
         kSTlNF4VUhjxv5IXNlokw9BDrkgZZfG0OWdREC8z3khwgX/f8Pw1JzlbP6LC4FpgCQDE
         E/vEojgSMq6rPr8IZLCM0oWP6dpooo840+mLNwsk09m9FI8co9az/+zAjeQ0jU6BJfLi
         gpG6nHK0TtNBQJu5S5mgt9w/g/cmVPrL2jV/K0L+B8iTZVyVGrqhNoS8gF0o6S9z9Xbe
         jgUkNlGRduJzwTDpQxHETL2fOCbBdw2Xo+JzNNROqqd4U05WkHvpd9vwmi/N7uphtel7
         G82w==
X-Forwarded-Encrypted: i=1; AL+hErEEvTi0fyC0QflRJLCnk2j3by9GHChxtEgCaP2vf0UalpDx4IwWYf5IAtIeoIFf/MMmFO4TYdk=@lists.linux.dev
X-Gm-Message-State: APuU4Z/KcpygPB+EeEHt1fPU5Cgi+lJXCpDBh95iL5HClAP0jF58hloO
	ZwI5jhS3FYj5zRMP7cchv1kKFh+f50tisA/6rV5eQPbHC3Ucfxsp/D/Fy+/sBlr5ViwSRZQWB9K
	LpvgoOGHlkR3yql5VJIv1s/ezkt3Nlxyx5lb3H0F1Ew==
X-Gm-Gg: AZFdTZeTboO//P6QBLI7qlmY2G6qALBZ461mdM+4Kw1dgtDECViT0kvIKGnJk2q9zfF
	/R9FCaG5CK6uH+GkAYDDR/u34V+Q3Cs0hSlAaEdtZG34xTBxP4+vA68zJjEuwRfszK4UNTSfPoA
	95dDLnA8q2ECQZ36oMmMPVeNMX0IkMV2+AgJABH6B4eLts96gc1O4g/QvZb2LLRaJjQFaM7w5s5
	o1xzsnPFGELt2g8oVjnIZLy+mTP1gjgFutwdh8SJS0IHKDVe+PTb9hk3eIVLeW0Y04EjFeLo8Q1
	EghFRCkOQzm5vkoeCgeUwAOc3HFEkfbRGPpwFyg4iMq0fukUn43I9o0VwQRDAzMVlOLOSSZjkOu
	AWu8+Juy6JIewnLUJSHCjcgFX3vVmKRWzi7YLC0NiiiR1sm1SFHRvcGzmnJ+b0uEmZX4pMlhxv+
	43uaWqs9pm9TOmYWg=
X-Received: by 2002:a05:6820:6706:b0:712:b60d:2ed1 with SMTP id
 006d021491bc7-71b39468d77mr11717331eaf.10.1795734966468; Thu, 26 Nov 2026
 15:16:06 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261126-bradfitz-kvm_lpi_active-v1-1-9ff28176bf66@tailscale.com> <86y0agx9om.wl-maz@kernel.org>
In-Reply-To: <86y0agx9om.wl-maz@kernel.org>
From: Brad Fitzpatrick <bradfitz@tailscale.com>
Date: Thu, 26 Nov 2026 15:15:55 -0800
X-Gm-Features: Aa3M54rQby0v4QzOGwyotbdQYWTk2b1yNxvx7ILnWqoqPCMk8Ods5BwBk5a9gjU
Message-ID: <CAMkNuKA0ogr-1pkL8Zg+cS_pwsF37mL=He7V-XowhvtUpWL5DA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: GICv3: Keep active LPIs in the LRs
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2026 at 12:45=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> Hi Brad,
>
> On Thu, 26 Nov 2026 01:42:04 +0000,
> Brad Fitzpatrick via B4 Relay <devnull+bradfitz.tailscale.com@kernel.org>=
 wrote:
> >
> > From: Brad Fitzpatrick <bradfitz@tailscale.com>
> >
> > Since commit 73c9726975af ("KVM: arm64: GICv3: Drop LPI active state
> > when folding LRs"), the active state of a virtual LPI is discarded on
> > every exit. If the guest has acknowledged an LPI but not yet EOI'd it
> > when an exit happens, the LPI is then pruned from the ap_list, and the
> > guest's subsequent EOI targets an INTID that is not in any LR. KVM then
> > relies on the virtual CPU interface performing the priority drop
> > regardless.
> >
> > That doesn't hold for Apple's emulated GICv3 interface, as exposed by
> > macOS Virtualization.framework to a Linux guest running with nested
> > virtualization (M3 and later, e.g. "tart run --nested"). There, an EOI
> > of a vLPI that has no LR leaves the corresponding ICH_AP1R0_EL2 bit set=
.
> > The running priority of the vCPU stays at the LPI's priority forever,
> > and since Linux uses the same priority for all of its interrupts,
> > nothing is ever delivered to that vCPU again. The nested guest's CPU
> > spins on WFI, with KVM seeing pending interrupts and waking it up over
> > and over (about 30k WFI exits per second), while the guest itself
> > reports a hard lockup on that CPU. With a 2-vCPU Debian guest, this
> > happens within the first minute of boot, every time.
>
> [...]
>
> This is a known bug on Apple HW running MacOS, which has been reported
> a number of times to Apple (both directly and through hypervisor
> vendors), and resulted in a deafening silence.
>
> The nature of the bug is unclear: either the host hypervisor is buggy,
> and it needs to be fixed, or the HW is buggy, and the host hypervisor
> needs to work around the bug (working around that bug in each and
> every guest is not an acceptable outcome).
>
> The other bug is of course in the spec, where the provided pseudocode
> for aarch64/support/VirtualWriteEOIR1 is remarkably buggy. But for
> that generation of older ARM specification, the pseudocode is not
> authoritative, and it is the text that matters. Dozen of
> implementations got it right, and it is surprising that Apple didn't.
>
> The proposed fix breaks all sorts of other things, and can prevent
> pending interrupts from making it into the LRs, as we now have active
> LPIs occupying LRs for no good reasons. And to be brutally honest,
> carrying hacks that make the vgic even harder to maintain is not
> something I want to entertain anymore. If this problem is to be
> solved, it must be done on the host hypervisor, and nowhere else.
>
> The workaround I can offer is to set "kvm-arm.vgic_v3_group1_trap=3D1"
> on the Linux kernel command line. This will ask the L0 hypervisor to
> forward ICC_IAR1_EL1/ICC_EOIR1_EL1 traps to KVM, which will itself
> emulate the HW. This is expensive (each interrupt will result in about
> 4 extra full context switches in MacOS), but your guest will hopefully
> work reliably (assuming that MacOS implements trap forwarding
> correctly). This is exactly what the host hypervisor should implement
> if the HW is buggy.

Thanks! That works great. It's indeed a bit slower (12% fewer IOPS, 5
to 10% less disk throughput, 5% less networking throughput), but the
absolute numbers are still so ridiculously fast compared to the host's
actual hardware, that it's a drop in the bucket for us. And even with
the trap enabled on a recent kernel, it's still faster than the old
6.17 kernel.

I whipped up a workaround at the Proxmox layer instead that probes
whether macOS is still busted and conditionally sets the trap flag:

https://github.com/bradfitz/pve-on-macos-nested-virt-fix

We'll use that in the meantime. Maybe others will find it useful too.

>
> Feel free to additionally report the issue to Apple (once more).

I'll poke some contacts at Apple and make sure they're aware.

Thanks again!

- Brad
