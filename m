Received: from mail-lr2-f40.google.com (mail-lr2-f40.google.com [74.125.230.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C78A446BE8
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 19:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789500939; cv=pass; b=uKyNHMZ9gHT6MPpP3YSfUpBtlbPZNXUrffUVlih2Yc1FLcN/WBmYYh8j8FMB2xxKbk7obkiebdDLdZKmedTj6xtFh7O0K210neJzpEFxDzhODh77Zz2Mqc69XGGjLO9QFV3FtB81IIifXdi+aiZ7ZqdH/m4O1YC8+z8qLIcBxvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789500939; c=relaxed/simple;
	bh=9iP5wCDaS9EpQ+gfjMA3+Yk2v+5OOuRQACmgXFd/pac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ccx4Adf/b6VXIrEK6e81aqlybpD7WkFQDODaU1/5giRTkvrnBrqzXORJTE2GhduJC2eY80995cjdaQVb/b77qSFjAG8FQcTb862vyVKt5y5XbC3zF5+1UKApnCEKGL/Pzw2+EvyoL5JdHvf/nzpxFbmV1i3ccJCTwByk4nzs73k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AkyjGoGt; arc=pass smtp.client-ip=74.125.230.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AkyjGoGt"
Received: by mail-lr2-f40.google.com with SMTP id 38308e7fff4ca-3a5da7416f9so1728821fa.2
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 12:35:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789500934; cv=none;
        d=google.com; s=arc-20260327;
        b=jgquHQ8CG1JHprUj3cvqr7Fdcj1Du3sutPRa7vw8EEP/L1LCkdnimmKphgyVU1WUs/
         JPxGEX9d78Vc592W22TbIvY6FgFnT9arbPSndGv+tAgJeGnV6HPybwHJpfHbbSDbsbrw
         1aNezZjUjFc9zyGrCMaOewq/+CdJSw80dIB6S6cm4efgOKLlzP81p/LlRJWun/cNsLFt
         Gm4YxzfifKHoasR7ZjGKZzTFIP11cxuMtHxySo40VAjjsMUHgszR+f2dmhgzfq/yaS/d
         IhxQDa2BVbr3nbVfnDZLch4YlNzQjCrnys2RU2TBQFqB6W3JzzrxsRyhdV3u3oTOioOz
         wUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3sluWAJ7si51ldKO+IEOlj7IVd+xFNM1gnjjRPbQIZI=;
        fh=5qWHpPp0yHNHSkcxnKth6cZhL4Mlm4OQy/7w5L8BSXY=;
        b=q4JvtEbgEdmdpBf1M7uRuGhkE9esS8I1OY6v1Hed7JzYXtIv6bX2fXblViVGUPRVP+
         8tcAqCSiIWom1/WsgkOAkJsweAF+l10Wua/sJ9lx0RwhKlgmgGapxBhdoDkc9AM5uHQy
         zru1BUxu5yCCGw+ooHsaKiB95V3r+2o8TDCLfDjeUuSJ/WJi3et4zOhnJw/NQr2+DfoS
         Zj7T/r6AxmC/mf6eKbn+b1qMEpSnngOIt7pojfuzSBRfwaJw8RmpUWK+QEiaxRCnapYg
         F2Y/EGmXFaCOiSX7gVHJYbKdGLTUDcN0g0C4cOATlgEyq+Xsmm1/sOW6cgfbjs9cD7Km
         ZIsA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789500934; x=1790105734; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3sluWAJ7si51ldKO+IEOlj7IVd+xFNM1gnjjRPbQIZI=;
        b=AkyjGoGteUSBLUq33mfpaEwYHWAgdL4oCPO/H+BoaTyoYco1BK7TZchyuwRQ7Kseco
         /a4Ros/+fGG016h0ee9wN1/CEh1vmcg2VqKpbsNKwIQk/ra2gQLN/+Fdci8053oWZKcG
         GmTKc53PzK7lsmc1W23zhehOH83ibgJsMveNLsuHwbhKxyJEwQa6iCVFpQ1PL1l16kSp
         0K69Cl/Q8SWhOMvKBNHfehCPi1aa6zEkjC9PPGGfQ6ThbE9R9FTz6Y5ceTXJ4MS4LrQm
         m/LTRDaOjvExbngU/Do9M6aKNo9RN0sw5PJMNx2UPzVuF9aYNrZWN+y88ZddB8CYJwcu
         XzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789500934; x=1790105734;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3sluWAJ7si51ldKO+IEOlj7IVd+xFNM1gnjjRPbQIZI=;
        b=Ytm/SMZ4EFOIgHXjPkfTvFskTXv1VeMLvE7H1GsYhulYfNrIcGgnrppFwkUUGcMbkB
         qPZ1rEZ2HORsIpsTouEXbND6cr96cMHkunDs36CYfuNuWn/MJfSXiNBeIXJuVjildIEB
         p2j+dbwHOkBDHab2tVohAaxYJHIs7dhnSHTXHuYyjNjJ6IUZHg++FlrbniJD3M3uvQix
         cQxMwpP4Eb6BmqznJc3zEmWnAdFGMt8YArOXI99ZSEt9Tr0/umt4vMsnCDook/q/cUW0
         ryaAnDW/IsxrLRuG/x/5fWxqAHNhsmI0BBWOplT8ZMkhFP035uhaAfk7gcgtPcaf9nzo
         ioVg==
X-Forwarded-Encrypted: i=1; AKwUvBxeF5syCgJf+eaBtgFo5dXidx3CS5jfWK56kVlLoBwhf1qjOsB0etyvZnmys/qcmPBiAA0Ho5s=@lists.linux.dev
X-Gm-Message-State: AFuF++mBG3tpWZZBD3UAYxbRaakSmsAotLW/dpNq+w0AGtLojQOt4O2d
	XuMsfElXlBj5pzstB0NUZ1ivubC5RWkSQ3OcBZhWtqOEwNRNMABsQ1G7CsF6vOLNy9VbCy35jBp
	3XkW4B7HYLSwzQgyyqZgNB+n7g6i8PKKWQ5pWXqNU
X-Gm-Gg: AYBFou0W/FGiFQ/7IvIYV8jwkshK76PxI0Syu9QLDFUbIPldPdzahGil/ZheB077Lpi
	Wi4jcGUqZKpC0qsZxZzPJKaONa0I9yAT/rPjz/xNk3OJk9X5psUJocdNfpNMJZmeS7UtE1T1zFg
	nKPFzrpfpXWfPjnW/svNA7H7wqpFVfLnE1x3ooXLiifxTXo89IeunJIgMYwZTdC3J4CM1YE0IXE
	vm4OxApqFonckvuUmjF5+hdxlnRvIKi9c4JkGsotqguQDni/jwTc2A7Rh3Keoo9AxHd6RsttMVQ
	lg2nmCHMdLANKKxhEsj9pyQA7hfEDq/4vZDTeq2E4KARbqkwrGNSk80Ouvc8Pn+c
X-Received: by 2002:a05:651c:a114:20b0:3a4:9e46:235c with SMTP id
 38308e7fff4ca-3a5c89b031emr21060911fa.14.1789500933920; Tue, 15 Sep 2026
 12:35:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260912083611.2513845-1-suzuki.poulose@arm.com> <20260912083611.2513845-8-suzuki.poulose@arm.com>
In-Reply-To: <20260912083611.2513845-8-suzuki.poulose@arm.com>
From: Alper Gun <alpergun@google.com>
Date: Tue, 15 Sep 2026 12:35:22 -0700
X-Gm-Features: AcwNN1VS3YvKKCCRg1vDnBVkoWj-7p2fofNqSox_wrQ014s5kEA5YUvjF8gr3LY
Message-ID: <CABpDEukTAc1m=g+rZRPPqaTwrvhUJPsFRWpFd0PxZsyWw5mR=Q@mail.gmail.com>
Subject: Re: [PATCH v18 7/7] firmware: arm_rmm: Add wrappers for Realm related
 RMI commands
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org, 
	will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com, 
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com, 
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com, 
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com, 
	sdonthineni@nvidia.com, fj0570is@fujitsu.com, WeiLin.Chang@arm.com, 
	lpieralisi@kernel.org, enju.kohei@fujitsu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 1:37=E2=80=AFAM Suzuki K Poulose <suzuki.poulose@ar=
m.com> wrote:
[...]
> +/**
> + * rmi_rtt_destroy() - Destroy an RTT
> + * @rd: PA of the RD
> + * @ipa: Base of the IPA range described by the RTT
> + * @level: RTT level
> + * @out_rtt: Pointer to write the PA of the RTT which was destroyed
> + * @out_top: Pointer to write the top IPA of non-live RTT entries, from =
entry
> + * at which the RTT walk terminated.
> + *
> + * Destroys an RTT. The RTT must be non-live, i.e. none of the entries i=
n the
> + * table are in ASSIGNED or TABLE state.
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux erro=
r code.
> + */
> +static inline long rmi_rtt_destroy(unsigned long rd,
> +                                  unsigned long ipa,
> +                                  long level,
> +                                  unsigned long *out_rtt,
> +                                  unsigned long *out_top)
> +{
> +       struct arm_smccc_1_2_regs regs =3D {
> +               SMC_RMI_RTT_DESTROY, rd, ipa, level
> +       };
> +       long ret =3D rmi_sro_execute(&regs);
> +
> +       if (ret !=3D RMI_SUCCESS)
> +               return ret;
> +
> +       if (out_rtt)
> +               *out_rtt =3D regs.a1;
> +       if (out_top)
> +               *out_top =3D regs.a2;
> +
> +       return RMI_SUCCESS;
> +}

Doesn't out_top (regs.a2) need to be populated on RMI_ERROR_RTT as well?
realm_tear_down_rtt_level() checks next_addr > addr under case
RMI_ERROR_RTT: to determine whether the RTT is missing or has child tables
that need recursive teardown.

Thanks,
Alper
