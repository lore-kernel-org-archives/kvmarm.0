Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACBA339856
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 07:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623708; cv=pass; b=dczQqZRwMzyWsSjjhrx9JlDiQhPAZSdHkH0KVL/r4JEZltuV7IeWPmFEr1Y2u6c2TAwLFY8nXar6GvGYT/7Vzze7Gt88KGkEhImscyBoyNO2Mmyoo1saIFhYP+1wnlfKobq/m833onwAB9TuqqKOM4Ea1lrUcxAcxzIl1l5bCXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623708; c=relaxed/simple;
	bh=BNgryngJw2u1QstkCu3izzlLr8n1gdpbTZu0FT2ckjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b/b5t3FbT/AtmZPwukXtluDJy4cyDnHmRbjjsYXKeme/Li3wA/mh4HCXiITk1QuJbebIjuuQoMJIwNL0F5vfZ1Vq7OnAzbEItXEpYmxdox20QRIIPVW16f23LMF5Y+DKFNEVkHYEcZqALzrqTrA436m4ykxXg8sydHH8byYyWQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BXXjSneN; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BXXjSneN"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-505d3baf1a7so756871cf.1
        for <kvmarm@lists.linux.dev>; Sun, 08 Feb 2026 23:55:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770623707; cv=none;
        d=google.com; s=arc-20240605;
        b=A08XCr40URiRwhiVkyVN1vZU0bCqySpylWhstj8GN+At21xm4LWzObFzsHr4SIRQsJ
         sIAwfMtv6tFHJN9ODXNOEiWqlbY6JXtMD5Z4grI+tpJ4UnHMfMSEIfDTMpZRIWcJdr6v
         KEmlwtkY9enzupRXeSGfx0dCs+hfNA9EyExAFmBBfsXLzed/n6rWeuxl/wxV+giRKFIc
         4EpRR2vd1rTeURyq1pfqLItLt55OPN+M2V5ocwoQmwumNPQG53pqOgAgEnK/nSo2U1te
         T3lBzOtZ/203kxzMw7SRG1YMzd/VW6tR4TVo4ZYM+4eKKDGsDsOZdsf8IdNTpDuP0jGA
         n8gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bV4VvNDh2SQI8LHGQXdw+ZcU4SYXBq/kTx2U2MHQObI=;
        fh=JuQU26Lwd1kWNfphsRgbAUI2j/7qB5yxL0g7ekUsv9I=;
        b=N3e1C3I1Gsgg1S1m7PU4wtO5HnBNBFiGefqMBW6B+Lk+CC1UXcn9Kj+22GMvE3cvzX
         yvn8fLIM1+kDff3L2PYWkK9d/mK30rcn395nBHRD97plutOYRe8iQ7odL7F8rWfLJrNo
         TjnG9EenTQIa7ZfmT+ceJ+TV+efPYQR3YrOh+bK/XKEbuKFWPHl5hes4BeMaTCRVg6hV
         bd6LovEmL7ouKaDyW5QWRuq6P8LPPUTW/BxUOud4uhmQ1+oxfSY2GdpZ9+ZvXZMf8B8J
         FE5Wg8wzSqItxXrPI+nhFT48Y0eQ5IlaFyWc1rZRcOQH4NleKf1O34WJSaL3YG6mw351
         HNIA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770623707; x=1771228507; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bV4VvNDh2SQI8LHGQXdw+ZcU4SYXBq/kTx2U2MHQObI=;
        b=BXXjSneNVslQL/0pmOxmPZdJMPO5XbMJe9D66WirL/JESN2zy8MaJ1nsk7bkzyQrQQ
         qOgqHMAH8+mdKGYGbwldlkrOYR39bCaEgn2cmmN24RocW00gSCy6jSgyWRGH0fr6W3A7
         li1o5Cxbonf2inIo731CRQHdQiTnKfvXC/V6avdnxyNIjN1htbBkBmO1AZmWwqliHgWa
         8oCZgTCMarAxRxan4MzvNhWcmpFXDMMeYROmL0ZCcmxUKD54vLeLK99NGmVZeMM5L5yG
         Q9paghzZFscTht6PviHMqDCPPrBZ6plmHkRayU6iXKzMokq+fkCITyLGJfarCBEKSIer
         2n0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770623707; x=1771228507;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bV4VvNDh2SQI8LHGQXdw+ZcU4SYXBq/kTx2U2MHQObI=;
        b=vi9wTiVz0kCjI3amPcTQSsYICpfQ9eBHNWCTNeOdQ874BbqN0vOA0JwrUsHg6GFamB
         tLH5hRjPuDR3j3FmEqJQhGGM6R+m+1+uXf0plh3QPOjqOYyelMcI8xEdRpjNPSqUkQMa
         WuLKOCmRnJosZ8owQ0Z6Fi/FgrDJNJa/AhKHDZ7xiQWxPL4Y4EFP1SvociUNC58q7gVO
         QowzKx0jPIVxzTXEckjiutCcV3MFrtWmZ3atXRKIaBoq9Tzj6ETOsMzjRyAQr/4eGtpS
         JyR88obn2oak6V6GyTaU7RhgO2ocxYn01D/ssbTOXxDI97U4dT8SreBGOjqCUW6aJFvA
         mW0g==
X-Forwarded-Encrypted: i=1; AJvYcCVxYAPQRlwOKsbuDZzUxkX53EdLvlyCcHtsgGHBnwhrPI6jdO+ckSQdZsKUCOfua9BoMgVZOGg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPbbYPMdaOGnps2twGCrEMS7NTf8TS8Y0C8K2JrsKuaEp3Pnjz
	T3wFRZvY65eoV0+jArdfEqdy/oI/T6X7L5MxVvxhlazCbT5VX+QDJo8fwm0PBQp8KXO3uoFq0EH
	ulL4LFytqQJYwhFOutobXJb2mOD2f/tn+UQtYDFkbA+MjHjILzWwv3heKhLg=
X-Gm-Gg: AZuq6aL8SCuZUqT/2T+hcAfHUzvs0UbK5gHHzMF/Cq+JFCu7hDtuL9iBG0HuL0dYilI
	OSkZsOpJ1ckyQN78vb1qHlj8rk4RoDEz+h3b6c6H9aPgsDukf9NbI77p0Rg/Z59h7qzGA1cJYmI
	LWs11xYEzg1e8fFMJC5kzI0jV2xE5ZzhFQ3FyNKbqk9fiB9ClCzlQHK358pBfjeoHEb+ujCYT8S
	gIT8OGKq0kInaPeJ3N90eKUIxHzMJ6ILl/0WyjqOlBXuLivt6Anc0DXCMUDT3sLnjjFQOKAaEbp
	MSka4vM=
X-Received: by 2002:a05:622a:190f:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5064b037245mr5687441cf.17.1770623706972; Sun, 08 Feb 2026
 23:55:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
 <CA+EHjTxhekJXyc7PbcXNhcByVp5mYqi56B6RXUukJfgE-QzrMg@mail.gmail.com> <0015e5ecd6e9170184ae7309c48f09ae5d64645f.camel@arm.com>
In-Reply-To: <0015e5ecd6e9170184ae7309c48f09ae5d64645f.camel@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Feb 2026 07:54:28 +0000
X-Gm-Features: AZwV_Qg_ig_q9lhC9p681Uohkb4hSAHj_Y9px81RoSgO1zhvrj9J-6CbFicBHg4
Message-ID: <CA+EHjTxX4Ag0kq7tvNZGs4XMRNaaKxwuSXjN-+B3AjC=r7mVkQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>, 
	"will@kernel.org" <will@kernel.org>, nd <nd@arm.com>, 
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Thanks Sascha,

On Thu, 5 Feb 2026 at 18:24, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> On Thu, 2026-02-05 at 10:58 +0000, Fuad Tabba wrote:
> > Hi Sascha,
> >
> > I would like to review and test this series. Do you have it in a
> > branch somewhere, since it's not trivial to apply it to kvmtool
> > master
> > as this is based on the nv series.
> >
> > Cheers,
> > /fuad
>
> Hi Fuad,
>
> Thanks a lot for taking a look - that's really appreciated.
>
> I've pushed this series (based on v4 of the NV series) to:
> https://gitlab.arm.com/linux-arm/kvmtool-sb/-/tree/gicv5_support_v2
>
> I've also pushed the my latest version of the changes (based on v5 of
> the NV series) here:
> https://gitlab.arm.com/linux-arm/kvmtool-sb/-/tree/gicv5_support_next
> Currently, the only noteworthy change is that --help now mentions gicv5
> & gicv5-its for --irqchip.

Got it, and it builds fine.

> As I've said in the cover letter, you'll need to only apply this series
> up to and including "arm64: Update timer FDT for GICv5" if you're
> working with the posted GICv5 PPI patches. Going beyond that results in
> a UAPI mismatch as more of the GICv5 support is added to KVM.

Ack.

> I've pushed v4 of the GICv5 PPI KVM series to:
> https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_ppi_support_v4
>
> There is a more complete but WIP set of KVM changes (GICv5 + IRS + ITS
> w/ PPIs, SPIs, and LPIs) at:
> https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_support_wip
> This latter set can be used with the complete kvmtool series to run an
> actually useful guest.

Ack.

> Lorenzo Pieralisi has created a useful page on how to run with the FVP
> (but note that you'll want the 11.30 release for virtualisation
> support). https://linaro.atlassian.net/wiki/x/CQAF-wY

I set that up recently. I had to make a couple of changes to the
gicv5.yaml, but it boots fine.

> Please let me know if you have any issues, and I'll do my best to help.
> Thanks in advance for any review comments you have, and for your time
> in general!

Thank you!
/fuad

> Thanks,
> Sascha
>
> >
> > On Fri, 16 Jan 2026 at 18:27, Sascha Bischoff
> > <Sascha.Bischoff@arm.com> wrote:
> > >
> > > This series adds support for GICv5-based guests. The GICv5
> > > specification can be found at [1]. There are under-reiew Linux KVM
> > > patches at [2] which add support for PPIs, only. Future patch
> > > series
> > > will add support for the GICv5 IRS and ITS, as well as SPIs and
> > > LPIs. Marc has very kindly agreed to host the full *WIP* set of
> > > GICv5
> > > KVM patches which can be found at [3].
> > >
> > > v1 of this series can be found at [4].
> > >
> > > This series is based on the Nested Virtualisation series at [5].
> > > The
> > > previous version of this series was accidentally based on an older
> > > version - apologies!
> > >
> > > As in v1, the GICv5 support for kvmtool has been staged such that
> > > the
> > > initial changes just support PPIs (and go hand-in-hand with those
> > > currently under review at [2]). As of "arm64: Update timer FDT for
> > > GICv5" the support is sufficient to run small tests with the arch
> > > timer or PMU.
> > >
> > > Changes in v2:
> > > * Used gic__is_v5() in more places to avoid explicit checks for
> > > gicv5
> > >   & gicv5-its configs.
> > > * Fixed gic__is_v5() addition leaking across changes.
> > > * Cleaned up FDT generation a little.
> > > * Actually based the series on [5] (Sorry!).
> > >
> > > Thanks,
> > > Sascha
> > >
> > > [1] https://developer.arm.com/documentation/aes0070/latest
> > > [2]
> > > https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@arm.com
> > > [3]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv5-full
> > > [4]
> > > https://lore.kernel.org/all/20251219161240.1385034-1-sascha.bischoff@arm.com/
> > > [5]
> > > https://lore.kernel.org/all/20250924134511.4109935-1-andre.przywara@arm.com/
> > >
> > > Sascha Bischoff (17):
> > >   Sync kernel UAPI headers with v6.19-rc5 with WIP KVM GICv5 PPI
> > > support
> > >   arm64: Add basic support for creating a VM with GICv5
> > >   arm64: Simplify GICv5 type checks by adding gic__is_v5()
> > >   arm64: Introduce GICv5 FDT IRQ types
> > >   arm64: Generate GICv5 FDT node
> > >   arm64: Update PMU IRQ and FDT code for GICv5
> > >   arm64: Update timer FDT IRQsfor GICv5
> > >   irq: Add interface to override default irq offset
> > >   arm64: Add phandle for each CPU
> > >   Sync kernel headers with v6.19-rc5 for GICv5 IRS and ITS support
> > > in
> > >     KVM
> > >   arm64: Add GICv5 IRS support
> > >   arm64: Generate FDT node for GICv5's IRS
> > >   arm64: Update generic FDT interrupt desc generator for GICv5
> > >   arm64: Bump PCI FDT code for GICv5
> > >   arm64: Introduce gicv5-its irqchip
> > >   arm64: Add GICv5 ITS node to FDT
> > >   arm64: Update PCI FDT generation for GICv5 ITS MSIs
> > >
> > >  arm64/fdt.c                  |  22 ++++-
> > >  arm64/gic.c                  | 179
> > > ++++++++++++++++++++++++++++++++---
> > >  arm64/include/asm/kvm.h      |  12 ++-
> > >  arm64/include/kvm/fdt-arch.h |   2 +
> > >  arm64/include/kvm/gic.h      |   9 ++
> > >  arm64/include/kvm/kvm-arch.h |  30 ++++++
> > >  arm64/pci.c                  |  16 +++-
> > >  arm64/pmu.c                  |  23 +++--
> > >  arm64/timer.c                |  20 +++-
> > >  include/kvm/irq.h            |   1 +
> > >  include/linux/kvm.h          |  20 ++++
> > >  include/linux/virtio_ids.h   |   1 +
> > >  include/linux/virtio_net.h   |  36 ++++++-
> > >  include/linux/virtio_pci.h   |   2 +-
> > >  irq.c                        |  16 +++-
> > >  powerpc/include/asm/kvm.h    |  13 ---
> > >  riscv/include/asm/kvm.h      |  27 +++++-
> > >  x86/include/asm/kvm.h        |  35 +++++++
> > >  18 files changed, 416 insertions(+), 48 deletions(-)
> > >
> > > --
> > > 2.34.1
> > >
>
