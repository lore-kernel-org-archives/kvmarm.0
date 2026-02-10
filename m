Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8CC1F03EF
	for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 19:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770750263; cv=pass; b=Lx39/mJba/mUB+JZV8xJTjrOza/nYS6MD6G350gap9+m6rwdzavSCokPBDaj4sNoeqloON+u5zNVgfz/ftGW7qbC9mch0gQ3PPRoxKp2A8yUeHYM1uh0Pi73K/9M8CDLQGiq5kiLZQzWqq5Qy+EJMKYdEN5koMaWVuvfUkr4KRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770750263; c=relaxed/simple;
	bh=Cg+vuppKBi/qxtrhYUyuaUGpFRMcTtpWku11sjQybv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZObXEHRlCrD+JxTPzTWDTVR76jvhYXN2DCUi0JlIBW16IuYa1yVWW0IX+KOz6K0x9E/T2OzoMWRtoilfKYH96UIwdeC1Vh9p8xp0rfnN4js1/KLzmoZzH3bkgtFuD9qzDJxcNLhOrxn//EcUYGWNbgeBRYFVXP8CldxkBhfEKG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TpYL9KoN; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TpYL9KoN"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50299648ae9so49621cf.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Feb 2026 11:04:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770750261; cv=none;
        d=google.com; s=arc-20240605;
        b=JLDab2rpKUg0AgZGK1WL9VRmyR9JFm54XXuaHoIG4YhTNRU6QSKQN9WCCLA9zArck2
         TU/IezYXbBEcUU+sy19WuM0X/NN9xlDyVoXtVFcYuAbel7l+B50/pZ0jagxoemi/nJ6Z
         V3kgQLMGDZ5XjTX1qPSNNwrmqxRjrXR9iy9dR7zW5e65gDaM0nkC0zyCKHpg46/oiQiA
         zf0N8ZnNZwSl0fwBYc4q/nmhYeyz1NEgoH0vu74LorQVZpLr0mjR6C9NByDfayubfP3t
         XEJNajwg+Lcxc4Vn/WjIeQIAuFd73vphuxOJabVtzSsP0zMPplggYq7EeE0Aay6rayx9
         JzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Cg+vuppKBi/qxtrhYUyuaUGpFRMcTtpWku11sjQybv0=;
        fh=rC0mXg0k12jx5u0Zz+37sza0TWxaSPQzc0UlcT+Cq/4=;
        b=LmZZdp5WgSEDEP496ZYBWfgLC2nTXfDaAGQu7MUEpaEfm2dB974txCXwAlVwtcRN3U
         YLBtgbX7ciGU1iNJffQNUDU5U3ch7+h59wWepL9qlOrEdO3gntiUNZlpLGTvsaqdEPPO
         PpvfGV3UXOOti+PXO7UzUX6yDLZYr9YvMoOZEJ+4DYPJqVtvCW7ee/ph3AruCczJtbsP
         RxorzObTNKI6wZ46lVy/4zCXTpJaDvfg7XDNEH0bQUQSYl60T7tyw4b1kkETQqQHJUGl
         /0oG6nbWJ1PdXkkOSQeGLd8bOTCQL47au2JryT7gxiAUafIHbQEz7MRgF0Dld4/yFzBi
         qwlw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770750261; x=1771355061; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg+vuppKBi/qxtrhYUyuaUGpFRMcTtpWku11sjQybv0=;
        b=TpYL9KoNhcjggQj5I6iS4FvXUL/lNQoudy/EWikPiaJKnXfUnFvBKlLZiiTm7usuYF
         9x4ANG85kBEJ/BzHRec/fF057GN8khl/nhgSb7WQ/2FrXAHSdZiDo0ehxWx1Jt+WuEXa
         Lss5SmMx9JaP9OZCtQLsrfi/gCI1eG7/R6BixaA3wMbdZOzlcJbGUiqYl6UYye5dk5Nz
         BRsxoCEPaGxOfxPQqtoKTAuPt2G6+Byx/q1T8GOTNTCiWq11CKMRlzoKC+bAKT8DDcw+
         P7b3anvY2gzqFdXREfY+JXNKIV+fImXIk6oxySVxU/wFBVku0jgoaMY4MVKMMFp279pm
         ZBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770750261; x=1771355061;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cg+vuppKBi/qxtrhYUyuaUGpFRMcTtpWku11sjQybv0=;
        b=qmBTNwc++Hnc7PKVfPTV2XK0kps1pPvDchnF0KFQHjiJf24zdHffCLM3w7TgECN9Fn
         RBw2iIdfbOSDwlUvj6uAgHTXyUNpsfAKwnEF45WIivFrdMBYzdqfBOFC9xWzqLfoPOy+
         n3a9JOBNiHi4X6F7aYyfZVPlwOMehjF6lsnCJsOQhKbZHGUbRbZVfp3mNRGqcvrSD4T6
         8XAFgY98rWSGkqKO7SL5NKjTeFEl6p2CHfIeM4nA4XVjohsO+gDT4zvxp/+9FtfvzJ1r
         75+6KUR28gH9UpBvbXzBYQ4sOXiRWiKnae11QhYcICmFHdvmZoArJ4feIUJoadMbjCDc
         DB2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVintokP2e//6Vv4hZgDLnOOvnwzaXgHDLS9zZLvhMJ0MASoSrs3FsimOO4cpvGtfQA5e+v5zo=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywk8m6deKvtqlKSeZ/jhP6V1ccbFtACtJ0SACAu4YTCF2X5LeqD
	1ZVJuyajVLE1YQKfAFEYIgGD62pZ7eFclY/t9NoZgwF1Ip5QzQq7uLabKyA2/EoX/MygnL5taPg
	/UI6HpK3J9FKXAv0glZp9TPsJZDD4RlngOWFoAzB7snw4+eIaGVxkAS5Us0k=
X-Gm-Gg: AZuq6aI3B96WAagbwBPeGsSQgU5C61gJjyjLS6UZYEsjfcJhCvFuZv2Uvsp3VGv9VZH
	MhSehJ/+1+AaQBlSCndPRqb05B180sC9kYx/AkNCK/jcD5L5T1o42XRmlb3i8ilRTw3FRfV9JW1
	XmC01W9zn/6zfUAa111cCvW7FyKxxvSDHYzCX+LCpLbJ7SA57nMNyQT46WWK726zSA3MWoB1Zjy
	clRX4DQHDtvRoUGLXkYlaUtshDf0YPYkHsHn8HPNs/K2YG+SP7OGBVlwM1oV1Es0TZaDBSWSX5s
	1ckv+M1P
X-Received: by 2002:ac8:57d4:0:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-50681649998mr676271cf.14.1770750260223; Tue, 10 Feb 2026
 11:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260119124629.2563-1-will@kernel.org> <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
In-Reply-To: <f151a8ba-b76c-4037-b1aa-b6b52e92b7e1@oss.qualcomm.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Feb 2026 19:03:43 +0000
X-Gm-Features: AZwV_Qg7DEwIPIYYUoq3HN6VEITAaYrvLGvacgWieQ6FB2D3Scit4MG1Lwsu5qQ
Message-ID: <CA+EHjTyDy_fw3Vhj+kf9e50He2W_zj=sdmTRhBy0GAx=8HQ0yg@mail.gmail.com>
Subject: Re: [PATCH v2 00/35] KVM: arm64: Add support for protected guest
 memory with pKVM
To: Trilok Soni <trilokkumar.soni@oss.qualcomm.com>
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Trilok,

On Tue, 10 Feb 2026 at 18:58, Trilok Soni
<trilokkumar.soni@oss.qualcomm.com> wrote:
>
> On 1/19/2026 4:45 AM, Will Deacon wrote:
> > Hi folks,
> >
> > It's back and it's even bigger than before!
> >
> > Although the first patch has been picked up as a fix (thanks, Oliver),
> > review feedback has resulted in some additional patches being included
> > in the series. If you'd like to see the first version, it's available
> > here:
>
> Is it possible to test this patch series w/ the QEMU or it will require
> real SOC platform?

QEMU works just fine. Just make sure you use the kvmtool patches [1]
Will mentioned in v1, and to book the kernel with
`kvm-arm.mode=protected`.

Cheers,
/fuad

[1] https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/log/?h=pkvm

>
> ---Trilok Soni
