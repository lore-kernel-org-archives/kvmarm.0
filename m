Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF65E364029
	for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 10:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781433405; cv=pass; b=RqPDz97Kq6XMYBeg/fL1lkaBw3OdBeAG5QDferb9a61WVXDUo31KvUPpqCTCckpHYpdqpl34QJHI6ij/Xy2FJH0JSq4F/AtR035kWGf1TdJd5+Ru7nO6FQd0K8/4f0anI1seCdhkWsK9oE6z0+tAq6SIGO6whSUq5WULrENCKKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781433405; c=relaxed/simple;
	bh=LNZzSVh5t+Rz1ZtSfa+00Lh6/l3vF/F0/XGMgP1krc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jh0A2oCidYlsMSwxlH0Vfuy/P6fHNiKkbVEIbzVC4ihxLGvYKro6kdjQhlCDB+LudAHqdYTyodAa7XzIA6qVNr+ofjoppQmwq9WFFmLkDt/l+dMgqaYRd7jRR+tjETk2CfgZDQF0slaYM/6EV8CO5uqu2qIYPjVeMaoeGK2SYOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IxFom/dm; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IxFom/dm"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5177d1ff061so489231cf.1
        for <kvmarm@lists.linux.dev>; Sun, 14 Jun 2026 03:36:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781433402; cv=none;
        d=google.com; s=arc-20240605;
        b=cKMMM91DIYqiBdufCsmsc3ZdJGTMGnQQyw+ibsXWkR1N8rGnA0snDaGcMgIsE2s+Dh
         UtTgD2KOqDCPMR5NbTbMdvqxFmvaaIIwZ+rq6biP92oM150QN8leuzwjzXJZF57Xnbr7
         FLopCR4MhLMrpWe7tTbQIHBorL+EjcXSK//HC0Z85SNb8DZUFTLt6+jxad0FQNNdRqtY
         ebeUU523f+tdH0aeQQUssMlr8bm6i+/tyk3KUcLK31jvBW4XM9/NXpgJexbvviCe3GcN
         u+mlQ/cmGKPIoQ0rz3rj9AmpT0DSYmZLBQcbZ3z1SDlP/rNuzSCHpiU0/vsJy7jXLcSF
         WqHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zsDo/ZOVPfEdPqS3LglFyoYCxHooaqSGHDtP1XDlcEk=;
        fh=MCrHQQuE64HVHGB8TJoQoV/DCpiOGh/N0C+vw9CDMZ0=;
        b=XToYzoipbrf6grzIkhT0dCzHQXapg8M/4FHD30zZf+I1EwcuDT5MRN/MMPYKd7CvpZ
         BhCr5cBnIWI5CeIv9rTXCRSpyVoHWSO1VQLZUENNAK6eqvndQvkemKcrqRC3VAqNaBYr
         k7p8KJzBYRsj1foCsBD12SrIWysV82Xdee9k0ti9LSWMPMrpKenAoXjtcOY8fiwL7PZ2
         6HYHqyPemP0kDDJpJWl4JWyshKIARwCDvIYRh4i3TqE4WhWQwz1lpNdtrIl/7aTZm9CK
         sJ7K6NoExuAp8nUvDRpLEAL3lJJ0CqxoxNPX+XjxqgctVtUmqkO0+EmKGXiKzfSaOsrP
         +8AQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781433402; x=1782038202; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zsDo/ZOVPfEdPqS3LglFyoYCxHooaqSGHDtP1XDlcEk=;
        b=IxFom/dmFGNj1vtWVpzvQu1fHBIBNDx3oabg+Ada7r+ovFGOLjKh/ed7fAfIW02lto
         76kZhMpxr1tn2/y0h3KLW1Sd6PEV30uJ/fqk02Rvm2t29BvZuxCgU4EGMxlpC1+EPxqP
         AEK7UT/vCdg29l9e8tyWS63BsnAUbnJCP43NnLyceJkagtzHXZarw4QF4SnNGiTG7R/U
         N9j2r0ydZaHJdbqCLu+Z5Gk1sKYLeCySV3aLw3WcAPU/E7/wcOmYFRM/EMQ3uuZxgY02
         MSFFO0wIJiZTYRUZ1FitnTDH7cFbrvo/UUwcJFuZNZpeI1QpHFedXA70yHf57nBawhN1
         rl5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781433402; x=1782038202;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsDo/ZOVPfEdPqS3LglFyoYCxHooaqSGHDtP1XDlcEk=;
        b=biaONvAfJ5zg3zFYTMiLQL23nmKzPq1vBheCYfHYzk1AGCgQssW/C8mAljDw6DtoTj
         2qInK8FSct0nM2BcN+qlEuBjLxYbSJnxzY2luD0qJecuAKVfZInqElTTRZa0lSnTf0Y4
         ujWFehXmzI9KHk523ZURda4Xh019DhDkOe54dyu9syug2QwoNC2DNjJ2DVRVxGATXur9
         rzmsmX4f5Reh05ak8eXH36pZWCCknG6asth+PrcCuxyYzr1aAJNRi2phMQnQK5wdCUeU
         xynIKWEDiOWDo4SHpEbyHPO366C7rWkO5QRpmA+Q/mJkoFWXUue7MR5vC4NFu11sz1Lk
         peOw==
X-Forwarded-Encrypted: i=1; AFNElJ+lcf6o8TkfqARipv5kCq2tAk5x+JrE8YQMfdNfRy/T6Ku8wYEkcW/vu/5kOYFi3CBJFDHfT00=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy45z5IdOnlu+DExQBI53WokcbfopqiMPa9RJjfYHhx0hCy9uEM
	UPtdjbUcLx7eT43wL39FHRYjw+no0vd6e5Z7rEAYLuQ7LOAYt5uUhL/l1s9FqwN9rcqEUuRP04c
	OKPYUcS2TBTB3U/qw12VSNqXxI6wJvosAU2og5n8k
X-Gm-Gg: Acq92OHnZ15NdKIVoqjSqE7v0aJN0LHw4j8FtA8t5jgw4uklEU3ZR/yMhpxn9KRNzj6
	Pz5MPJlyfRYYvlf4kYi0vnK2Zvb9W6hgl1o3L2NoGDAJkDupR8bqyODeMrCG/grOgxkF0V+BAXO
	zrARyew6Q9mi6tnRPZdlyb+unHmU0NR7ILWxb6QvOEzKlH62WfUgrLR7wxDg+yidcilGty6Hzr3
	rNaworjtp2HoY4T47vkBXuFMsnReeNME5dKir2ba1GxJDtgDdOAnS2ivvd0p/q+sKAG/wpMT0pq
	kNzpf+Mz
X-Received: by 2002:ac8:5c83:0:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-519549b2989mr10393391cf.10.1781433401238; Sun, 14 Jun 2026
 03:36:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612113414.1022901-1-tabba@google.com> <20260612115044.16E3B1F000E9@smtp.kernel.org>
 <CA+EHjTyFFf__9iGFAyAkechiX+gaiK9ksdfgxLSFe8RcAY=HGA@mail.gmail.com> <87pl1t8q24.wl-maz@kernel.org>
In-Reply-To: <87pl1t8q24.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 14 Jun 2026 11:36:03 +0100
X-Gm-Features: AVVi8Cf25BgmHVzixnH72Pp4x2je53tjyX44xbNfRJni2U2FbMN2z1y0gR_1GS0
Message-ID: <CA+EHjTzNPabfo3bnuMuBKKz5T3w=BdTdSkZ7eD3VGZAiyrhJNA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 14 Jun 2026 at 09:46, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 12 Jun 2026 14:19:10 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Fri, 12 Jun 2026 at 12:50, <sashiko-bot@kernel.org> wrote:
> > >
> > > Could this cause the guest kernel's exception decoding logic to fail or
> > > panic?
> >
> > You're right -- the architecture mandates setting IL here. Like you
> > said, this is pre-existing, and I'll submit a separate patch to fix
> > it. But first, Marc: was there a specific reason for not setting it,
> > or is it just an omission?
>
> Just a plain bug. The normal KVM code is usually careful to construct
> the new ESR based on the source of the exception, meaning that we
> always convert ESR_EL2 into ESR_EL1, and propagate IL amongst other
> things. This is obviously not the case here.
>
> It'd be worth auditing the rest of the code and make sure this is the
> only case of IL not being correctly set.

Thanks Marc. I'll do that and fix it on the respin.

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Jazz isn't dead. It just smells funny.
