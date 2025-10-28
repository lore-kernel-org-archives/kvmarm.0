Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474713081C2
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761648085; cv=none; b=S1UeBFtJqUCuEGuEeXhpLa63usFwcwOjmfPOdomUCMuVvdOxmN1HzgshmhC2fDcXTsB3RSyGJBfwy8HRh1HLJVXSKyUpjZX85+8lyL+xCWolSfIH5pX94AM2zt61vwyxLmHKeIEr3+5wkdzBs6aK0W/9LM0Z0l+9wR6pdOcrZc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761648085; c=relaxed/simple;
	bh=/Tw7YIdbXuV+Py6bpAG4b/reVIEI2qovtF58gW1FAC0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MsRgpR/iTm+I17i6z2TBF2Xd3HIH7aorYKh5NY+xVzXPYxsuFERgHTW/V5a9NWFsi31D+LVWntPGWgQMVcbPDvGKq9ABAufUM2moFU2Y4dg/51aIFi306SHFlMzrZKUEdcG2k99bJx6D7STrja1feHStf7OSEQOWtgCxnDxl/3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KKcNPYXh; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KKcNPYXh"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso125691cf.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 03:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761648082; x=1762252882; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xyYFRQojunl/tRzwlh+ac2kk1NsYLl4yZPYrY+iaVBw=;
        b=KKcNPYXhbYGoUPLmoJ3jtxBfg8r/TatqmhAEn0IXBBskrf1dRk2aCl2ZBcjxwRfRZW
         ypnossMy9yj1nbpBkKZ2/YGosKMqsRAj/quRMuQy4P/3RSlRiMtdj7QCOzPc0v1ZDCf/
         6WPdKmqu4F1Q8c9E46qGhWnU/cWpxYcbeL3/J005zq6Tfa+8e/QFeDy8zCUuqgrix/oa
         +a0eyp/96aq9QjYi7HbrMf/RIpcdkSOMPC4h1W3sVR8B4Y3pEiJhDC8vnKYzDgb/V64c
         N/sIehd1hz9iNNUxpMEQ9evrFnHe/SeKl8eNtk2rGkGKK0ILuyqrSN886IXdbu79fKMJ
         DKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761648082; x=1762252882;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyYFRQojunl/tRzwlh+ac2kk1NsYLl4yZPYrY+iaVBw=;
        b=gLov9aXVmgdVt/Ef0iIT5obeXbuVWMbPmqF4PCPyVGcmdHZ7LD9n4o0LLdu83xqrQo
         B4JHwJE3SkwRJvX7SGuzQrgEXAje58ClTWe3ejGeBlFyS/+jAm2bS9QefqG6xmkpsDX4
         ErNZBRUsAw9WV6E0VjdX/1ByXp1jkmRfUTvGeWR3yy0ItRXGkpMRhGKZ2iLEJ1F6iR4Q
         gBZERfI4dE7TEP8A+iSucZcGQUXcnPlVe0PrwO4Fj6zKiAqAhk57U4y41MDawmHiQLt9
         SwZzvXsv8QDwGrv5SUfLuz0z/rvq3LCOK4U5JIsNF51dlBPCITl+tq4yinrlGSVthP81
         t+eA==
X-Gm-Message-State: AOJu0YygqBszrsC9q63CCsm/rNTKa0nu2SWjwOEHBN+UlK7XHe1lVl6L
	7do2BqR3EFOTkOmYzDPqaHhxLQTw2Pz2q+KrDDnyZAQF418rXj972YZlEAloGBGPy9UAeQh6Ors
	mIDdD2F/4JQN5nrzgGV556ak1irBaGvkOLXf4Fx5j
X-Gm-Gg: ASbGncsL3xO1GK+5zXexT8iW7FT4CunIYsHIkPh3S2rgFozEV8wC9ZxQp440rBfnUX7
	6TslE4rv25j98d0UBnKF7S9gbqMPgvGicINesuGO5knXyseNZyn/3PQZ00iYLpvgWJ77Iydcbyw
	d+cPsed8zEz31J01K0PR+XANVteEhbEBqfmjE76Esuo88vl7UvbI4yNwgpwLFpENh0zSxgayThU
	aEYx6fCW16FS8AklAY1StMeQ5Sq9xnkkIJXO5ew8vz/MoQGiVx0Cepcgn0mFL7TnDLPWBsxAh7u
	GZ/wU0hKQdDnFhZ6zyx9sILB
X-Google-Smtp-Source: AGHT+IFFXfImVcBC1aHOTYgWrMceC2H6PeDXVpaOsr5+gplZ8eX17JiVPPiMcYOXVyoXKBIZ0HHBi2NKdR1/MprdqkM=
X-Received: by 2002:a05:622a:5a98:b0:4b7:9c77:6ba5 with SMTP id
 d75a77b69052e-4ed09f7cbd8mr4751271cf.15.1761648081564; Tue, 28 Oct 2025
 03:41:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027113943.1282568-1-tabba@google.com> <20251027113943.1282568-2-tabba@google.com>
 <86zf9bux8m.wl-maz@kernel.org>
In-Reply-To: <86zf9bux8m.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 Oct 2025 10:40:44 +0000
X-Gm-Features: AWmQ_bkrWFTx10BG9y6-HIb1BAzsBhsUUbx3Qvf6bdqolNIIlbJkOOCnpYFIwQ8
Message-ID: <CA+EHjTyBSmKCpiBQPRV4joY6Qxrjywi4zseNzqdXejr+KmPG+g@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] KVM: arm64: Switch reg and val parameter ordering
 in vcpu_write_sys_reg()
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 28 Oct 2025 at 10:38, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 27 Oct 2025 11:39:40 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The vcpu_write_sys_reg() function previously used the signature:
> > void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg);
> >
> > This was inconsistent with related functions and macros such as
> > __vcpu_assign_sys_reg() and __vcpu_rmw_sys_reg(), both of which
> > have the register parameter before the value.
> > '(vcpu, reg, ...)' ordering.
>
> On the other hand, write_sys_reg() is exactly in the same order as
> vcpu_write_sys_reg(). I think that's the model to follow.
>
> The __vcpu_*_sys_reg() helpers are internal things, really, and if
> something has to change, I'd rather change those.

Sure. I'll wait a bit for additional comments on the remaining
patches, and respin changing the order for the __vcpu_*_sys_reg()
helpers.

Thanks,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
