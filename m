Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9004B78B55
	for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 12:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708085955; cv=none; b=XJgt5DFOUdzS7j70N3iZJCmWLQxo+rAJabRh1YHrtrSg8iuXT3rLr56jS/MtVo+t4CVFU7GHvYXhCBIyNQDI3AYsy9Ok2LBBOOqt/1tUg/BkSdPM/NaAcNPi3GWdD/SjcOushvcDR/9TkTlJyWqk4TlZiZpMglZR6d4gkiT+nlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708085955; c=relaxed/simple;
	bh=PSJKhP9hWq4+Lbowvz+bBMW640SsgQDWr5Updtqd93I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b9sJtRDjII33msAyvM8Pe/C2Yqk/mh2vGu307yi3IWtd4mH3k79crQiLBcTcWCtn2iPv3J7Lo2rVbjWUnaKJUDxlQyLt4SZQmmGw6Xsiu9RU5r+EN9CppgPY6z2tK6Xf2RmYVZTcF2RH8xd+r8+yuhxDMQlVjiFbpD4pg2yT/tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3Q2Xvi6; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3Q2Xvi6"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-42dd91764bfso183571cf.1
        for <kvmarm@lists.linux.dev>; Fri, 16 Feb 2024 04:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708085952; x=1708690752; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNyrI9uKcDxqRatKZxhTwLZVrTwEVmRpCuf7a7BL5/8=;
        b=V3Q2Xvi6o6NILeaXRxBjAiZ936QeRCiAE6ksMrUsPavJ2aktVf3E+q1MmbI7xQazmz
         QvYn1ZON5pKnIC+S9ilhnOYrF0blyZTRdbsG1E2c82Ur5irFffnDPuIbYo9jPUmGyYbM
         ZYROYXVJmyyg/ZIxRQ5i8Xvqlv6kzehwnZAiiBSu9X5mE4jDAxoWC/TLT5GE+7zuQTVI
         jzESbcupOn3klKN8Jh3QplwDp3eDDvxaXvXG//4ZevsXl8QUrY/IQiDmrDBXXL1wC1At
         5kYqAZUUEL5GcM/HRIr2aMSZbffbp7Lu2EO8pPEY2hYrBIr5qvHjASHhUdma4GO8OMR9
         69OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708085952; x=1708690752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BNyrI9uKcDxqRatKZxhTwLZVrTwEVmRpCuf7a7BL5/8=;
        b=H6cFHLTCfJAZPgi1CA2ZOnwlpNhxSxwJhxIOOBhsz+GfZuYRTdqH8uCNHALiHLwunM
         7vEsWe8J0+h5BBBt/eW76BZmbQq/HXcnJJHfNMjGnBGRlv1hGq7pE0pXBq7QADRfIMC9
         WjVrjZ8duVMWvYjBp4VItLEs5yaUuCPjigHAsvbxg+8D/D2HDFAtTQtVUK5ayG/+1Pin
         JfZVcJTn6u0lKPHoqAi4bW4Qts2RPhL/lcAxwgc2b8G7UXAf6afY5y668c1CM+/FR0+S
         LLO+hZxpLnVOqElLC4PVN90brAiW3hd5gzYOwbunNz741DDxH/9/ZpmQePF9zRI6Om+O
         WkWA==
X-Forwarded-Encrypted: i=1; AJvYcCXptxgkyT5Oq1tCJVjNvRcbe9tbZmESTjYwkW4nrjMDE+NJa1mW0QiF8IMMjMGOsznvJTgBmL/H2RGIcCVFO70KkQdinTsQ
X-Gm-Message-State: AOJu0YxoUlW4sDaC5yAlpiOhLuKqikJJ4GH0j5o+VJMXzW5r1EKzTa7R
	T5IsOl2IQcW+nEb9RcBohInF+LQwaCRxrm1Wd7eelrWyTkQl+/m5Q/Z8IF10wzmylkegiuzpYww
	V3OyTwJuw66pKLmWTr6oIv+W8scd7oSRdH9e7
X-Google-Smtp-Source: AGHT+IGkvkQyFc975szvjCF4iZYQJ1TRr3+sPw4K2/bF+uoQenC5Yx4J51IhUjufqlwpfdMzAh8/JCCTPqF/G7/nb3I=
X-Received: by 2002:a05:622a:292:b0:42c:6905:c449 with SMTP id
 z18-20020a05622a029200b0042c6905c449mr314267qtw.12.1708085952265; Fri, 16 Feb
 2024 04:19:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-25-jean-philippe@linaro.org> <CAFgf54qcTAru0Nvy1wH_tJMadOSW7Y3zEip5RTm+mtSa54Bymg@mail.gmail.com>
 <20240123194530.GA40099@myrica>
In-Reply-To: <20240123194530.GA40099@myrica>
From: Mostafa Saleh <smostafa@google.com>
Date: Fri, 16 Feb 2024 12:19:01 +0000
Message-ID: <CAFgf54pAtSLWjaqhZShxzKkOLWFkjXmsmMk1P0TdXOUWhn00sg@mail.gmail.com>
Subject: Re: [RFC PATCH 24/45] KVM: arm64: smmu-v3: Setup stream table
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org, joro@8bytes.org, 
	robin.murphy@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, yuzenghui@huawei.com, dbrazdil@google.com, 
	ryan.roberts@arm.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 7:45=E2=80=AFPM Jean-Philippe Brucker
<jean-philippe@linaro.org> wrote:
>
> Hi Mostafa,
>
> On Tue, Jan 16, 2024 at 08:59:41AM +0000, Mostafa Saleh wrote:
> > > +__maybe_unused
> > > +static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 si=
d)
> > > +{
> > > +       struct arm_smmu_cmdq_ent cmd =3D {
> > > +               .opcode =3D CMDQ_OP_CFGI_STE,
> > > +               .cfgi.sid =3D sid,
> > > +               .cfgi.leaf =3D true,
> > > +       };
> > > +
> > > +       return smmu_send_cmd(smmu, &cmd);
> > > +}
> > > +
> > I see the page tables are properly configured for ARM_SMMU_FEAT_COHEREN=
CY but no
> > handling for the STE or CMDQ, I believe here we should have something a=
s:
> > if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
> >         kvm_flush_dcache_to_poc(step, STRTAB_STE_DWORDS << 3);
> >
> > Similarly in "smmu_add_cmd" for the command queue. Or use NC mapping
> > (which doesn't exist
> > upstream as far as I can see)
>
> Right, the host driver seems to do this. If I'm following correctly we en=
d
> up with dma_direct_alloc() calling pgprot_dmacoherent() and get
> MT_NORMAL_NC, when the SMMU is declared non-coherent in DT/IORT.
>
> So we'd get mismatched attributes if hyp is then mapping these structures
> cacheable, but I don't remember how that works exactly. Might be fine
> since host donates the pages to hyp and we'd have a cache flush in
> between. I'll have to read up on that.

I guess that is not enough, as the hypervisor writes the STE/CMDQ at any ti=
me.

> Regardless, mapping NC seems cleaner, more readable. I'll see if I can ad=
d
> that attribute to kvm_pgtable_hyp_map().

There is a patch for that already in Android
https://android.googlesource.com/kernel/common/+/636c912401dec4d178f6cdf607=
3f546b15828cf7%5E%21/#F0

But I a guess as beginning CMO is enough, I have this POC for it
https://android-kvm.googlesource.com/linux/+/193b027de376317eb8daa4eb207bad=
aa1d6fda4a%5E%21/#F0

Thanks,
Mostafa
