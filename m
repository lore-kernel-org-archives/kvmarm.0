Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685D1A840C
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733913214; cv=none; b=gFXA2/LHS3E47d6MlSUNPcIQTuajGIrtkv3ha+FE5I2AyFNZUl75XJ0UFDYxd3BpNwewXv1wQfLJ7xh5soiHluPPW240DrtT664BTmUv/08pG5TxVd4bGwnYxWNAnfSYtdUoAHnxWSW/VNx5NfcFZYaa3pQgWRvpW+LMu90SW48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733913214; c=relaxed/simple;
	bh=Klh/2rs0ugl0MobkIjhQMC3zR6rDn7Fgg36xGZ2/BqU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s8teYbfBBQJZ/jHo72pxGrNbkYG0ZAkDsV2NLVptv0XGdh7BsaNNnNEqs0taIx8NiyhyOINGZA4LViCKy5hBdQ4iisTOzGNArjVJW5R2XcbMWLqdP9VwtOEHe4y7vGjwOnsogdgBAURSpAe5lR7J7EV5ZtzuZlloZ0kXSvMyPhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MzrRZCrE; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MzrRZCrE"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so29265e9.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733913211; x=1734518011; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xejb4B30VvRcDJwNO3f4C7XdZV+B2J5itS09MkCZKps=;
        b=MzrRZCrENDgSc6QTTqCIZT6QKvjIheCRgU9q3ShdWM1iu6G7CJg5MoGewlpgKUie6A
         CdFyWXtvSvO4C4yNKyUHJqjcPWIhD7Db4OmkVNADTbgIufY54ZoaTk2ak9Xl+QS1fcSW
         HV+nROT7Jd2hZMSqkwZrKNbWETkmAAkg83+2BwvXiQplX1umE1KY90X3VO2xEZ3AueQf
         IPLlDXraJi+e+ZwGWN+kGXZljSWt2atbQAdyenJxsdknKzBUiYn38atfRTiO4DXkEX4l
         EQJDzNM82l/L+0MAo2+FUE3N2XAV9BHIJEVxDNE4UYcAALd3P9BkzQuMr2KX2Gs37uag
         sUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733913211; x=1734518011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xejb4B30VvRcDJwNO3f4C7XdZV+B2J5itS09MkCZKps=;
        b=YJMeS8GVpSrcnKne7awlgre4QmdTHKLlNHc/5gogRD4ZLJdu/QpSTOlRSrenlf2ye5
         6QOQPm+B3fMdw4I9AxZo8rDe+66ZdOocFnUZVjxl7B2dD5/zBYY09maJzyBnFdDzTcnL
         bczlwSCf0l9HAM0g9Rn3mSJHsjrpanJJB1Cs1TXGZX+Y8/OxTwCeohDyApVOVERczImi
         yaw+6xmSQwK+LATHFC1PoemZcVEs52lX78DDr5j10RhQ62wsrkkYMEBTNMmv2v4hMmj8
         lB5D7vJSRq3pGruxpHJdiShYfV9+yRylKr2yMbQv23YekRiGV2h4KS+ylHHS6w2zuUeN
         C1lw==
X-Forwarded-Encrypted: i=1; AJvYcCU80LivN8Teveyy8q+XuBR1+XOjqv3lzxO04Xl6nIfucG7Jp0M1WF4I7zknkAmtOJ4t0qwM8WQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzR2tp0OD/lr6S+GpAL9lG0MBAB1W+TsX90wk8l+2Q1qraSAK+j
	FNp449kmWrirCUWHkXfJgTQ1Pf9CJLP8gYrHPhp6i4aD+CafqjSyZW+l64KMMd6TAewhTjIt21c
	TN+ujF0cs2oYQ2gFADOzWCjjVO21OKplPPJTH
X-Gm-Gg: ASbGnctkI4GuJ2Ejte+ot6+Gd8xHFG3u1rtH5haRGQAzXa0osZh0LZsIk3+eip/pjHk
	tXN07eS8KAnqYoMFUlavHbLE4MJBasUYHGQIoU+2YAY5Q1VoisWeK0Rv2dql3pDeL
X-Google-Smtp-Source: AGHT+IEPQlrax4O3EDsziNcytBk/dvrQmghx9+yaCRsduLcL2uYnUAAv4LiQBh3FRM86KVDBUO7qSFBLmZPR9owFjyU=
X-Received: by 2002:a05:600c:490a:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4361c0e320bmr1012235e9.2.1733913211090; Wed, 11 Dec 2024
 02:33:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-11-qperret@google.com>
 <CA+EHjTwHSyQ1FJc7axbLNuBxSWpRVE6brb34nO+F59=QRmfQEg@mail.gmail.com>
 <Z1hhHRdpCZcLs046@google.com> <CA+EHjTw4GX3j_ssN-tWnf780xkvyKO5mBN6fnvXeWvQcBDmcNg@mail.gmail.com>
 <Z1liL3BtoPnSyvlh@google.com> <CA+EHjTw+3oAcp3ujjPmbcu42=95nw8WA=rZHYFL91ZK_Wfs_vA@mail.gmail.com>
 <Z1lmG-3KnOZrOCCa@google.com> <Z1lnwZPrx9GzgFCG@google.com>
In-Reply-To: <Z1lnwZPrx9GzgFCG@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 10:32:54 +0000
Message-ID: <CA+EHjTzrL9v3DBGRht_-JPpfpd0eW1xYAMcbeNA83B1K64oPgg@mail.gmail.com>
Subject: Re: [PATCH v2 10/18] KVM: arm64: Introduce __pkvm_host_share_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 10:21, Quentin Perret <qperret@google.com> wrote:
>
> On Wednesday 11 Dec 2024 at 10:14:51 (+0000), Quentin Perret wrote:
> > On Wednesday 11 Dec 2024 at 10:07:16 (+0000), Fuad Tabba wrote:
> > > On Wed, 11 Dec 2024 at 09:58, Quentin Perret <qperret@google.com> wrote:
> > > >
> > > > On Tuesday 10 Dec 2024 at 15:51:01 (+0000), Fuad Tabba wrote:
> > > > > On Tue, 10 Dec 2024 at 15:41, Quentin Perret <qperret@google.com> wrote:
> > > > > > > Initially I thought the comment was related to the warning below,
> > > > > > > which confused me.
> > > > > >
> > > > > > It actually is about the warning below :-)
> > > > > >
> > > > > > > Now I think what you're trying to say is that we'll
> > > > > > > allow the share, and the (unrelated to the comment) warning is to
> > > > > > > ensure that the PKVM_PAGE_SHARED_OWNED is consistent with the share
> > > > > > > count.
> > > > > >
> > > > > > So, the only case where the host should ever attempt do use
> > > > > > __pkvm_host_share_guest() on a page that is already shared is for a page
> > > > > > already shared *with an np-guest*. The page->host_share_guest_count being
> > > > > > elevated is the easiest way to check that the page is indeed in that
> > > > > > state, hence the warning.
> > > > > >
> > > > > > If for example the host was trying to share with an np-guest a page that
> > > > > > is currently shared with the hypervisor, that check would fail. We can
> > > > > > discuss whether or not we would want to allow it, but for now there is
> > > > > > strictly no need for it so I went with the restrictive option. We can
> > > > > > relax that constraint later if need be.
> > > > > >
> > > > > > > I think what you should have here, which would work better with the
> > > > > > > comment, is something like:
> > > > > > >
> > > > > > >                 /* Only host to np-guest multi-sharing is tolerated */
> > > > > > > +               if (pkvm_hyp_vcpu_is_protected(vcpu))
> > > > > > > +                       return -EPERM;
> > > > > > >
> > > > > > > That would even make the comment unnecessary.
> > > > > >
> > > > > > I would prefer not adding this here, handle___pkvm_host_share_guest() in
> > > > > > hyp-main.c already does that for us.
> > > > >
> > > > > I understand now, and I agree that an additional check isn't
> > > > > necessary. Could you clarify the comment though? It's the word "only"
> > > > > that threw me off, since to me it implied that the check was enforcing
> > > > > the word "only". Maybe:
> > > > >
> > > > > >                 /* Tolerate host to np-guest multi-sharing. */
> > > >
> > > > I guess 'only' is somewhat important, it is the _only_ type of
> > > > multi-sharing that we allow and the check enforces precisely that. The
> > > > WARN_ON() will be triggered for any other type of multi-sharing, so we
> > > > are really checking that _only_ np-guest multi-sharing goes through.
> > > >
> > > > Perhaps the confusing part is that the code as-is relies on WARN_ON()
> > > > being fatal for the enforcement. Would it help if I changed the 'break'
> > > > statement right after to 'fallthrough' so we proceed to return -EPERM?
> > > > In practice we won't return anything as the hypervisor will panic, but
> > > > I presume it is better from a logic perspective.
> > >
> > > It would, but then we wouldn't be tolerating np-guest multisharing,
> > > but like you said, it's not like we're tolerating it now anyway.
> > >
> > > I wonder if it would be better simply not to allow multisharing at all for now.
> >
> > That would mean turning off MMU notifiers in the host and taking
> > long-term GUP pins on np-guest pages I think. Multi-sharing can be
> > caused by many things, KSM, the zero page ... so we we'd need to turn
> > all of that off (IOW, no MMU notifiers).
> >
> > That's more or less the status quo in Android, but I vote for not going
> > down that path upstream. pKVM should ideally be transparent for np-guest
> > support if at all possible.
>
> And to clarify my suggestion above, we should fallthrough IFF
> host_share_guest_count is 0, but break otherwise to retain multi-sharing
> support. So it's not a simple s/break/fallthrough change, that needs a
> tiny bit of added logic.

I think this would make things clearer. Thanks.

/fuad
