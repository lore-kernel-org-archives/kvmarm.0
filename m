Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BD3A6F16
	for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 12:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269256; cv=pass; b=MppYyMT6dJJGHBfyRLQ0GCVUHp8f4pNwMe1IFhm1ZSeqggUJl1Yzg0MA+1C/YGHhugv2Wq/lERxup4c1FvflfJN4GbrnhbhD4hqwrzFhWI+LDBYImF4BAvkumQReGuIzcTDheDOs7S/tP2tui70rYXLwr0xJbiCGHMcI9Butn4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269256; c=relaxed/simple;
	bh=qP9YpmLhqJ7iKLUEJKEs2FdAVP2Ma0eNZKoPVjwl8pc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KGdlnfEdM9ng7zIDFun1FvQ+IUPUxQjSqD1L7l9i2ZSXG9tlsQhZJyCrK4T9KMLg0Tmw6naRqHpisoG0ujA6ggFL2gE4YCAVrgkhD+HuHv967R4ZHFCfnrWGNnicp3GTBiOCFW2838TMf4ZM0RXPYXzEerdBPH8bKZy++OdZTTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iLkdMBOp; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iLkdMBOp"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5091ed02c54so1073381cf.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Mar 2026 05:34:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774269249; cv=none;
        d=google.com; s=arc-20240605;
        b=XxC89j6YwpYI2d2B6aR7d2u2onZPurFLa8VVCvwuV2lxCWxiLq25+fRPZtz1ysef1f
         jYQEguTkd4sDmOUKkF1rx781/K0OAZDE/8ACK6SNmjrqWGALKbGqIEOw42jVn2MQxtSS
         n7xAwn7+n0RDZccqhcqEOQ57Y4etT9adcxOgQfQVPw1Qk30wbNjMDRrRrtqMhwmdDNfl
         vjXjsJfHqlX2h8EIISL4b58EfKA2RaIVOt8Q5y6PhP+gz0Wgr77HAgzP90RdxR4rf/EY
         w7CHRM2Q4l3xYXOruMlCq+KIMWW9VmUfcMLqAOOVi7CPYD/WGwi1ThCecZAHAvQ9Pxe/
         e70w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YDciruzs8Ey3qf1jOS+c7GPDS8nO7KcVc/iFzTYFC6w=;
        fh=hMJbWRXRkCMKjwl9zYyvoRK5X0mK5MHV2a71AU/VznY=;
        b=b1bTGViqBB82Q3amppX/mWyY/DuTCGcp1NmpWuPJtnGpFzJjGNNn0rmRY7GraVbHIh
         Eti+hWbYu01EeLIFOZOfwYyftfLfjpudeGJSIilTiiRIPqUAXTkJl34K/fwT6nl7AfHN
         G8PMIQsa6B54rPbMWLARoET7P7vWXjFDsnbSHDyB03NOfmhIrwJaTLCUOA9z4HfBjY7j
         8Bhm1tsVDXjvsUrCS5BuFpQWDyz+d/jEViBrhSKsA6hhWzyizX3R+Hpoi1EYyWP2VhLM
         PM+yF9xGU9zJreDytk4GbOLfMBXZSoxiwDBmLiR2iGlqxJ1DAlVmA5BJdUPb+req9oZ/
         9rQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774269249; x=1774874049; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDciruzs8Ey3qf1jOS+c7GPDS8nO7KcVc/iFzTYFC6w=;
        b=iLkdMBOp/Ku/0IcLA9dRjJ7OfSWz7w5quFd/LQevfMNhEY3z+hlQc/cKsOgZj/lt2k
         p7mlRkxucKVz9wc/TzOgkucd7DvEPuz5bAYJ5XBb+/m+/Mxd5fGBWDb31AugdMlNanbu
         6shQ+RBUU0PwZvGSjbYwIjXgWfJIjWCbB1e7UqI3m+e227QmfUGHPd93YheqB49Fxr3g
         r6wGXAoEYV0KGztzrB3V7WeXbaNxWEtvLaqiUODUNjgHg2dq42Wpjj82QSO2kArLrPqu
         W9/lC49ccB21Zj788Y7E+/HaG2qXVmW0Lc4jUXQR0mKx1QF+VeQfQ35HLUbeWG1UWI/I
         oH+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774269249; x=1774874049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YDciruzs8Ey3qf1jOS+c7GPDS8nO7KcVc/iFzTYFC6w=;
        b=gP0rqFl30xyQHDrEQLw3XPpOIm6+YB7Cy/NDMxdDV8de74yURfBuYn7SUL2wJfuUka
         hkNH0MlvYikk5mngcxbP8H9VHzWbPn1Jmoqy/kxFyfj4xploOgquG6gSSRPjSrBS3QYu
         IoUcdkb4f9+K5Jb/l6vLTI2lHKpW/C0dZqJYb6zce3QLH2M/2AINxcqvwFNLXAHqltGc
         ZKrGbXthYb2wZcbrZgd3s8qqZYib6YidjEA7qU1mPVyiDcsUReuTicRIxiLpKCrM0mCq
         sLuU8OyfquhyOSK8Ts0bXT62zKb0VmqDfsfxv7hxfLILTIBiBM4+U7N1xoAXPZQmaZS5
         hl2Q==
X-Gm-Message-State: AOJu0YzrlGamVRxWyy54gvFpC8fqxAO0ZnxsXocc1oLEFAGmSRoSfXtF
	Mh8WhWOqQE1JJGzfbULVepHuf4L/1iRN3MZhsycO5fnE4yV1+ZHNDcR7yZ5Wqh5wCaoiLD+SYCV
	efCPPQWifAfYObHNoek0DJaRJAxCy6o6iJGz7PkqT
X-Gm-Gg: ATEYQzwj2XqGuhf515P8Tjx1FAf91wDq609AgQ4dQO5abBfFoTs9VR8mGDM1woAg6c8
	oZ1FeioSV+MXnreYCcq4eG72v2n0Abj2U3ztNz1NKzWEcxpgnvwi2wXxo24eHFBH8Uh4N43UMS+
	6Vhp97DEruLPHgP2XWRUCP6snOLoJcJQ4Vi7n6j+A1Lnz+mL8adg8OAMgA/TwP0n8KWOGCKTcrx
	9DSGRAOsp0r1M09V5KhVBGvMCRUwUOvYWgKFXUsKJZghH9wOvdKrMY28KnTZFuYFN56J5EkJ1Lf
	+oLU0yc7YPz/xmS41iRE6aKvIdC67yuOigHPbvnHpw==
X-Received: by 2002:ac8:574b:0:b0:509:25c5:42b4 with SMTP id
 d75a77b69052e-50b480c27a5mr24589311cf.13.1774269248302; Mon, 23 Mar 2026
 05:34:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org> <177426391593.2932170.8726976984414575226.b4-ty@kernel.org>
In-Reply-To: <177426391593.2932170.8726976984414575226.b4-ty@kernel.org>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 23 Mar 2026 12:33:55 +0000
X-Gm-Features: AQROBzA3qYHe3s8BaZ2dHYM9ZdaRsKXyWNR-mfM5AIq5nZXyLzrP-udG8vd73pg
Message-ID: <CAFgf54rsCocMTaP=OPfFq7BCwoxQKcEkcyad16BtnZ11XxyKxg@mail.gmail.com>
Subject: Re: [PATCH 0/5] KVM: arm64: pkvm; Rework aspects of the PSCI relay
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 23, 2026 at 11:05=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Sat, 21 Mar 2026 21:24:14 +0000, Marc Zyngier wrote:
> > Having recently spent some quality time debugging [1], I ended up
> > reading too much of the PSCI relay code and felt that it could do with
> > a bit of spring cleaning.
> >
> > To be clear, this series doesn't really fix anything. It simply adjust
> > things to my own taste, which may or may not be everyone's.
> >
> > [...]
>
> Applied to next, thanks!
>
> [1/5] KVM: arm64: pkvm: Move error handling to the end of kvm_hyp_cpu_ent=
ry
>       commit: 4ebfa3230b40728638a6acceb709f900f920f921
> [2/5] KVM: arm64: pkvm: Simplify BTI handling on CPU boot
>       commit: 1536a0b1386850b67a9ea840e57b7b475e895fed
> [3/5] KVM: arm64: pkvm: Turn __kvm_hyp_init_cpu into an inner label
>       commit: ba64e273eac3d7ec4a2b621b3620c4d3b0399858
> [4/5] KVM: arm64: pkvm: Use direct function pointers for cpu_{on,resume}
>       commit: 59c6e12d40a5b05038b68bcdb4690456fee68e8a
> [5/5] KVM: arm64: Remove extra ISBs when using msr_hcr_el2
>       commit: 54a3cc145456272b10c1452fe89e1dcf933d5c39
>

Maybe a bit late, but I tested with pKVM(nvhe and hvhe) that it
boots/powers off + hotplug through sysfs

Tested-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> Cheers,
>
>         M.
> --
> Without deviation from the norm, progress is not possible.
>
>
