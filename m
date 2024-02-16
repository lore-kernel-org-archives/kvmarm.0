Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F6C77F24
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708085523; cv=none; b=bLS5gO5MoRVl3M2oAcObZVoWCXP7hLuzu9iTe2huuLxAxDf2xE/aINuhl39+LpcAU+EcBBg1UPIvYLeABVVFSUlWeBNdiFlFxrnHcTOsG0PV5MIHohfcKIsuOWMOHjx5yn1hWmCraE2Lp14bTcbr1cQ+VPl90aW1fXrMyyGiPgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708085523; c=relaxed/simple;
	bh=MvmRRYiTUcZL/Mxyg214q2eqECSORLkadybowCqrG7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bzB3tNZRoqP7OB9g0r3dWTV72zzn2rLza4w9JSXvIVuKb6m/buVws+pH4RKT5m+e4nG1ghkecYvNLbPcDFxwCG7Z3XThO4KV4wZJYm5AjVQSwZtu7YDZTSvcqSDU+EU1bqTYUePA/iDNicrnhJEmzPZYKTr9uaxQKZqcgbDWMUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LV/cJqIx; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LV/cJqIx"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-42dd91764bfso182381cf.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 04:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708085520; x=1708690320; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wLi1l31Rv/In00dLQqYlpWOYSiLb2Mt2TNzX1nrNc6E=;
        b=LV/cJqIx0auWIl4tGD1PFo6gYnrXDMMKNy0xe2TGV8R86olgz4SFnMtRjIIRQbe+Yk
         NzUNob43KeWOBiEWcbtrQKxglxEDxpdt0QBhHcKG3hNOCMGxY0vcaXblWE6E9Fk+R1tG
         uVl9E3ERSH6vJ0VCIZ2DFlXYHFGrYvQJrOydh0TuekP6Fy246eksAGY1PXJAQnLCFkgO
         k0LDgIZDe/bOP1mqW+I50TUgAM4fvpsblxWxBmhyIOrcYOX4Tgr7JKteVwiH5M1yq6vo
         67OoBlOreTTxiOBhh/CZX4PARScwu6ZhmbvqGdUewI1GGMeY/7L4uDFP69m93uNaUyb1
         iCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708085520; x=1708690320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wLi1l31Rv/In00dLQqYlpWOYSiLb2Mt2TNzX1nrNc6E=;
        b=kAXAsvWUbYG67ZOq+tWJ/xLiHcESD2gUJ8UdqoSjW3bk1S4HEXS/IrZ6tbZaMbq0t0
         1ZNL5vYIzCYU+exYhTbH6ZhZlmeepkj71aZDTTPsH5xGL02dXk3w1SexPAoInBd/99I2
         hT+9QahDGp0axMq0858KzTUFkawNHP0mQMkuh1TJ7eiSYa3o3S0B0mLcoDNbVhDLc3GA
         h29NOwuDqq22hcFCgGpNZwBPaY3lAQGkKyjTQcLQ447Ai/9b0aYsYsFsHxc7emlPbdoQ
         wK3ixcI/Wg5n4pkGE5W/7hzOtXzptD1W+MPQr2g+6icQKCqAc2sYZNxRORQF/aTzm+Ku
         IF8g==
X-Forwarded-Encrypted: i=1; AJvYcCVaXiLUg2hTzb1Qteq7up+LQFbCACXzwaTckObLy33/F6hkTsj9lQ1nNhIF0zXpdOuZtQy0ce0v20ki8TNbJ8jrMepRIIBI
X-Gm-Message-State: AOJu0Yye1vspIgTSBSyshbtWHi988F/qZlNMzaxLk051xGfVVuQ7LiND
	4PcAlyyHmWwdKWqNDizEpJfPirZ2mhFExPvkAG7UHG9v+2tvHNv6kwwe0uO/L4GyrJH/eXpb9pI
	eevbmw6Hy3dGHTTs8CwepiuycgpzMT5h1Dkrq
X-Google-Smtp-Source: AGHT+IGLPaBpSGFDDcoFqQO/wufRql0dF0nAXv+epRl1mmbYxbxNkcZbV+cEwNzRxFlivBLJlrfaCcfCfUtCqTpdwjY=
X-Received: by 2002:ac8:6756:0:b0:42c:73ec:383a with SMTP id
 n22-20020ac86756000000b0042c73ec383amr263884qtp.10.1708085520267; Fri, 16 Feb
 2024 04:12:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-28-jean-philippe@linaro.org> <CAFgf54pysSxKHcJVP6=dWPxmS3qi=eEMNQMF7SPiaiaeA-Kc_g@mail.gmail.com>
 <20240123195053.GC40099@myrica>
In-Reply-To: <20240123195053.GC40099@myrica>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 16 Feb 2024 12:11:48 +0000
Message-ID: <CAFgf54r3nNez_Rp0xOYWcTKvO9tcx313Q5-_dotT341qQOHm1w@mail.gmail.com>
Subject: Re: [RFC PATCH 27/45] KVM: arm64: smmu-v3: Setup domains and page
 table configuration
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org, joro@8bytes.org, 
	robin.murphy@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, dbrazdil@google.com, 
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev, 
	Daniel Mentz <danielmentz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 7:50=E2=80=AFPM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> On Mon, Jan 15, 2024 at 02:34:12PM +0000, Mostafa Saleh wrote:
> > > +static void smmu_tlb_inv_range(struct kvm_iommu_tlb_cookie *data,
> > > +                              unsigned long iova, size_t size, size_=
t granule,
> > > +                              bool leaf)
> > > +{
> > > +       struct hyp_arm_smmu_v3_device *smmu =3D to_smmu(data->iommu);
> > > +       unsigned long end =3D iova + size;
> > > +       struct arm_smmu_cmdq_ent cmd =3D {
> > > +               .opcode =3D CMDQ_OP_TLBI_S2_IPA,
> > > +               .tlbi.vmid =3D data->domain_id,
> > > +               .tlbi.leaf =3D leaf,
> > > +       };
> > > +
> > > +       /*
> > > +        * There are no mappings at high addresses since we don't use=
 TTB1, so
> > > +        * no overflow possible.
> > > +        */
> > > +       BUG_ON(end < iova);
> > > +
> > > +       while (iova < end) {
> > > +               cmd.tlbi.addr =3D iova;
> > > +               WARN_ON(smmu_send_cmd(smmu, &cmd));
> >
> > This would issue a sync command between each range, which is not needed=
,
> > maybe we can build the command first and then issue the sync, similar
> > to what the upstream driver does, what do you think?
>
> Yes, moving the sync out of the loop would be better. To keep things
> simple I'd just replace this with smmu_add_cmd() and add a smmu_sync_cmd(=
)
> at the end, but maybe some implementations won't consume the TLBI itself
> fast enough, and we need to build a command list in software. Do you thin=
k
> smmu_add_cmd() is sufficient here?

Replacing this with smmu_add_cmd makes sense.
We only poll the queue at SYNC, which is the last command, so it
doesn't matter the pace
of the TLBI consumption I believe?

One advantage of building the command list first, is that we also
avoid MMIO access for the queue which can be slow.

Thanks,
Mostafa
