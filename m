Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FF23A7F5D
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 10:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770289129; cv=pass; b=hASUGTvixsYJwEoSuDVG+xwkRF0nKOMeODfvrpbAm0sf/mNUgwfiv/vfOUCD5DrmYnrNrL/KiSwdnYuKP+uzQJPbYP4xPejhmNge8f3KxCqNCbOsp9fRtGoPMJkNBhWvQUs/HBPWa+BANnA5TZMsPmv2PlVR7tu2sAiLwgmkBcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770289129; c=relaxed/simple;
	bh=eInnJKMahFR6g+uDKXbFT99Bh2LRk+v2OWPd769Xq2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JhVqsgQiBxBfZTP6wHzZsL29alCGpzt0xsUev0bgA7123fD9GmKSaGiA+v392hqVNdgaBqfUEVsvRMswKQkzwTf29l0r9jc1fzeG7Oso+02dg1n8MRLU7Eqrp5KJdrOYVWHJ27lTtGg0Zg84Qp+Q55ErJgyXwJPASlSrgE3bfQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bv8xt/DQ; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bv8xt/DQ"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50299648ae9so372221cf.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Feb 2026 02:58:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770289128; cv=none;
        d=google.com; s=arc-20240605;
        b=ZJI5KStQK4lsmDmHSGQ+Q3m2s8i1w5QpSmSiMFC9UDLHgoGdNKODYjxh7JmtvWetJG
         0GF1lUrkCc583rdL1ElmsBwjLzAecP/SCUc1OBVqbSOXe34bizds4dtx/f88oTe2cmOf
         6dVt+n6VFrveP4DNKBkcYBb/CW3pWvXP0ZVG1MurOs/Vm6x4GTQr5PieCSujsNjQ4WLb
         2EFZju2qGIBX+EQizZSNew3R++csKL7r/nsno0py05nacV/XP4XhHpWQHQ5fn3yp1/tP
         JGCt3A9Xke/fs4DUXvR5X2dQT+Ye7Aq1PbhAM2ih9BeIWqin21QXeSa0jhQhuK1xyXyF
         vvhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=mWdaGHBGoTQV6Nt/HUCcE0KGg84oEg+M9DxtvHa6/t4=;
        fh=IHwzxNa9O/SdYScvk2P4tAL7Teve2V6xCFCyh7XwzOc=;
        b=j2b+CjYwXYFNTS1PKszdYFLlffafCqwTUw5Mc7/e2BXdvG+J5yMECn1k58iHpptj0k
         kATUreO335PPVx23DV3dxppt+scP+rGSRmja+uSTi00aInl+QM125YDErbDCmp+2olmI
         5yifJkz/TrP1kXPTm6vcYyTQB28j1Py4iFQ1vSH91+t1e3f3aNJ3CzYpGw9yzsmhaSxL
         aYZVvq6d0fCYoatvqL3JrKtwK0AmuD25f/tbduTd2WznK5U6Uoc5rYYd6k1JT5JYgPEQ
         s7ZNHAB4WTo2bAszxdf9wy2sTJeIwET3+JZx/6orhZ+gdTfzA/emevkKerkjK2sdrwJ6
         J1xQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770289128; x=1770893928; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWdaGHBGoTQV6Nt/HUCcE0KGg84oEg+M9DxtvHa6/t4=;
        b=Bv8xt/DQl0J8B1G+tD/Rt8LyOyANC9Htm9We6HKr/saYZzmea5caQGU3+nSkM91L/0
         nXVNBBZXprwvkEFeL9Bdxobj5BL3s0z8Mifx3CJNtVQL0+G3/kvXxxp0YVsAgnyVrnWv
         PtwAESzIA7cbV0pxscq4qpBbeaKVfAjbx9dQ1tfdqywVtg+wr0xk1v5XDL05L1fQtbQA
         Ak4YiPBtVv7ag0sR1eXf1UI2o2/mc2IOJv3+47mNdpdW6G9HucRUqtYyNzVvddnXXiis
         EiiM/le8XSGOv7pouIq8fAmQPP2x+OHmcnoioLvbPPruWO3P/qsQuT1mySwOF8eE/Eed
         onrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770289128; x=1770893928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWdaGHBGoTQV6Nt/HUCcE0KGg84oEg+M9DxtvHa6/t4=;
        b=OSxvmvrSrdoiS/6e2ZEINHDDE8anCoFbBQL3Q0SrhWWidnBqnU5/qweJuaZzraW1pU
         O0BEHm18AO9wKEUAtvsZxDqsuEmBv7bQPVQxHhPhw68rEHnZooSwO/sVG3xt5w86ZopW
         YBHFBcSdNd+ZYKBndVAdih/0N9xpBBkDgquA6eFVOFkz3LtfQ9LOyi0OHKMhS2LpD5HK
         DSQuvCxHtZAcc2XHXWEH3TyL5cfcQUAbzZ/nPGQ1UTcCbsfUAe3GW4LqyNfuT0etlCTP
         3oDKDI2Wze0bz+eFjzBI7wzu6ylm/SSXUi8hBNm6/LzDmB2P+yjA0/G0mF29RnXKTTGs
         HrMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1YS8JhsliSP5/CcC2qYNQEH/B7oZ4LpW4c+vUwxl16zjlUBMNV5HN8KdidHkHNShz3K8jPLY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZ/QEnKQfegLzhPQnAlfbbm35riiRwIfQqftPTVP9MFkQlTYKn
	Ty8Zdgaa/BGanSuy1PBdI2DOlPYKo2vrFCL4kFSaQGNk6kYYalHth/8gvyOeJscgQdOnbnVoRnt
	9Z+l8nAmpOygrJdt/eFevlxs+Nk/ZJhL5AaeFOAE9
X-Gm-Gg: AZuq6aJhygoO9Du9ycyuOJDfsrlB1HlgVjshVOLRVYILHNTWuI6ehwF1ICHJ62atYC+
	BgCkabcKse7gP53HfzvjP8ZFwg9rx6qecBdDyYdfJ3mPA5pnBXrQAaSnbb159fRepnf7XKzZ8mq
	JzlKod0GE2tuYgJhscu5KKl4eVANJwqkSzioipSyvNMtn3L/MR6SbAyFFF+XK+lOJs+NjyYMMJ6
	pWEZ0MHkoIUnJSPb9gTAu3pwdtuKiOZ6YcUBd2/jWrQB58RZl30zKPKBpeu5/y/3g5brQiN
X-Received: by 2002:a05:622a:1a9e:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-5062b0a3b84mr6534461cf.6.1770289127426; Thu, 05 Feb 2026
 02:58:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260116182606.61856-1-sascha.bischoff@arm.com>
In-Reply-To: <20260116182606.61856-1-sascha.bischoff@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Feb 2026 10:58:11 +0000
X-Gm-Features: AZwV_Qj2DbaENVW72ogYB2HV7TiFDfYeQJXErbOTc52O5rdL0EP2dF1kO889FaM
Message-ID: <CA+EHjTxhekJXyc7PbcXNhcByVp5mYqi56B6RXUukJfgE-QzrMg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2 00/17] arm64: Support GICv5-based guests
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "will@kernel.org" <will@kernel.org>, 
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>, nd <nd@arm.com>, 
	"maz@kernel.org" <maz@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Timothy Hayes <Timothy.Hayes@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Sascha,

I would like to review and test this series. Do you have it in a
branch somewhere, since it's not trivial to apply it to kvmtool master
as this is based on the nv series.

Cheers,
/fuad

On Fri, 16 Jan 2026 at 18:27, Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:
>
> This series adds support for GICv5-based guests. The GICv5
> specification can be found at [1]. There are under-reiew Linux KVM
> patches at [2] which add support for PPIs, only. Future patch series
> will add support for the GICv5 IRS and ITS, as well as SPIs and
> LPIs. Marc has very kindly agreed to host the full *WIP* set of GICv5
> KVM patches which can be found at [3].
>
> v1 of this series can be found at [4].
>
> This series is based on the Nested Virtualisation series at [5]. The
> previous version of this series was accidentally based on an older
> version - apologies!
>
> As in v1, the GICv5 support for kvmtool has been staged such that the
> initial changes just support PPIs (and go hand-in-hand with those
> currently under review at [2]). As of "arm64: Update timer FDT for
> GICv5" the support is sufficient to run small tests with the arch
> timer or PMU.
>
> Changes in v2:
> * Used gic__is_v5() in more places to avoid explicit checks for gicv5
>   & gicv5-its configs.
> * Fixed gic__is_v5() addition leaking across changes.
> * Cleaned up FDT generation a little.
> * Actually based the series on [5] (Sorry!).
>
> Thanks,
> Sascha
>
> [1] https://developer.arm.com/documentation/aes0070/latest
> [2] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@arm.com
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/gicv5-full
> [4] https://lore.kernel.org/all/20251219161240.1385034-1-sascha.bischoff@arm.com/
> [5] https://lore.kernel.org/all/20250924134511.4109935-1-andre.przywara@arm.com/
>
> Sascha Bischoff (17):
>   Sync kernel UAPI headers with v6.19-rc5 with WIP KVM GICv5 PPI support
>   arm64: Add basic support for creating a VM with GICv5
>   arm64: Simplify GICv5 type checks by adding gic__is_v5()
>   arm64: Introduce GICv5 FDT IRQ types
>   arm64: Generate GICv5 FDT node
>   arm64: Update PMU IRQ and FDT code for GICv5
>   arm64: Update timer FDT IRQsfor GICv5
>   irq: Add interface to override default irq offset
>   arm64: Add phandle for each CPU
>   Sync kernel headers with v6.19-rc5 for GICv5 IRS and ITS support in
>     KVM
>   arm64: Add GICv5 IRS support
>   arm64: Generate FDT node for GICv5's IRS
>   arm64: Update generic FDT interrupt desc generator for GICv5
>   arm64: Bump PCI FDT code for GICv5
>   arm64: Introduce gicv5-its irqchip
>   arm64: Add GICv5 ITS node to FDT
>   arm64: Update PCI FDT generation for GICv5 ITS MSIs
>
>  arm64/fdt.c                  |  22 ++++-
>  arm64/gic.c                  | 179 ++++++++++++++++++++++++++++++++---
>  arm64/include/asm/kvm.h      |  12 ++-
>  arm64/include/kvm/fdt-arch.h |   2 +
>  arm64/include/kvm/gic.h      |   9 ++
>  arm64/include/kvm/kvm-arch.h |  30 ++++++
>  arm64/pci.c                  |  16 +++-
>  arm64/pmu.c                  |  23 +++--
>  arm64/timer.c                |  20 +++-
>  include/kvm/irq.h            |   1 +
>  include/linux/kvm.h          |  20 ++++
>  include/linux/virtio_ids.h   |   1 +
>  include/linux/virtio_net.h   |  36 ++++++-
>  include/linux/virtio_pci.h   |   2 +-
>  irq.c                        |  16 +++-
>  powerpc/include/asm/kvm.h    |  13 ---
>  riscv/include/asm/kvm.h      |  27 +++++-
>  x86/include/asm/kvm.h        |  35 +++++++
>  18 files changed, 416 insertions(+), 48 deletions(-)
>
> --
> 2.34.1
>
