Received: from mta0.migadu.com (out-106.mta0.migadu.com [91.218.175.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A984E2F2F
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 11:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732740; cv=none; b=ueNpWGHP/ptUa/Dlt1LStDMpE38hBbiDll8lp7HWrHSyYAZOQRCqvZmXg36FDHvsZjtbEq+0depeG2AJSG5yw5rj2hQtDQBTJr/DQnADZ6VuhYrL+Ey9ZP3lA7luCNEh5K7GFM4JO61sOcIAuwIVicZnN5WPq6s+Pr6RTUItnvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732740; c=relaxed/simple;
	bh=dZ+UU0cW7lO7sc/YWjbCFQdvW29aK3TMctUKE8s0RwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZVrP49vKxDpG5TlOfA9n06r+2XiErRCxIjwuxYZ9mT9ebtWnEt/NxxFw+AOJ+nDEbf6+Q7FxQZ0g4BcnckU67ue1vwVhRnlxaBBweL9/tB1UmNupSbxD1UekN84e7fERlhpOPOrOXzK+W1u05q33/vofwgty094uQ0fW7ZdWPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SLvSqHhp; arc=none smtp.client-ip=91.218.175.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SLvSqHhp"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=dZ+UU0cW7lO7sc/YWjbCFQdvW29aK3TMctUKE8s0RwA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789732736; v=1; x=1790337536;
 b=SLvSqHhpQd1amaVYgTmu7m7b5P4rVkEVYT86jteUIXZUq//jhwxhViWJ70kGs+OQ05RYXu4H
 dpQSFnFpEpkLnWVk5JNprnjkaGbut3b/fzjK1qtYAwcRPYHTxQyJVeCu9RBt9aaHCw30DFfJB1S
 01GtEj8bNtKhlg2CqDr1NoAg=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a35d66219176022e;
	Fri, 18 Sep 2026 11:58:56 +0000
X-Mizu-Trace-ID: a35d66219176022e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b8c42da963so2000e87.0
        for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 04:58:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzrUd8w4fpG6UX2enC/NW49xTGNKWQtdNgRaBfLEZvJAQLDh/KBZiq9KB3llNodXP3FfBbfE9A=@lists.linux.dev
X-Gm-Message-State: AFuF++me0OvtcIDlUFIq9K6ddWIT1AnjbLiMAsnOkxAiHqjsno/QZIWR
	uTgzQL6vzliqIG/Zk8nbGRmnXFZgLbXFcSDwzJ/JoFECeUMFo4DG2eUCy6+ocz1PIFrU4x54u1k
	9QopMJjTaY1gBVcx2AlkrFVSD8cb88VE4JnSLn66C
X-Received: by 2002:a05:6512:3c9f:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b8c0fcad95mr166760e87.0.1789732733287; Fri, 18 Sep 2026
 04:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260918040214.85580-1-ndaugoing@gmail.com> <20260918040214.85580-2-ndaugoing@gmail.com>
 <CA+EHjTx8zzvgqj99TKWfRD58X-M8v+hs9358_r_1zZonFNEsgw@mail.gmail.com> <CAC2BP3K-fvW2s2j2ys+kPMuxrzeMw9yc6MrAk7U7CqCpb2WePQ@mail.gmail.com>
In-Reply-To: <CAC2BP3K-fvW2s2j2ys+kPMuxrzeMw9yc6MrAk7U7CqCpb2WePQ@mail.gmail.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 18 Sep 2026 12:58:17 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx9bTDuTnGgkrCcaAG+1S1Lx6+1BZnuhJcWNTJxWXkAHw@mail.gmail.com>
X-Gm-Features: AcwNN1W8n3dmMVZr53drbRK261wAXv8qWFmrNE31MdA1aY5Yy24oy1p3VG9UCp8
Message-ID: <CA+EHjTx9bTDuTnGgkrCcaAG+1S1Lx6+1BZnuhJcWNTJxWXkAHw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: vgic: Do not remove in-flight LPIs from AP
 list on disable
To: Yuchao Zhang <ndaugoing@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yuchao,

On Fri, 18 Sept 2026 at 12:51, Yuchao Zhang <ndaugoing@gmail.com> wrote:
>
> Hi Fuad,
>
> Thanks a lot for pointing me to that thread! I was not aware of
> Hyunwoo's earlier report and the discussion with Oliver and Marc.
>
> I'll read through the thread and their rationale on the ap_list_lock
> approach. I'm happy to defer to Hyunwoo's effort to avoid duplicate
> work.

I'm not sure you should defer to their effort. It doesn't seem like
Hyunwoo has done any work on this for a while. I just wanted to point
you to the existing discussion.

Cheers,
/fuad

> Thanks again for the pointer!
>
> Best regards,
> Yuchao
>
> Fuad Tabba <fuad.tabba@linux.dev> =E4=BA=8E2026=E5=B9=B49=E6=9C=8818=E6=
=97=A5=E5=91=A8=E4=BA=94 15:22=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Yuchao,
> >
> > On Fri, 18 Sep 2026 12:02:14 +0800, Yuchao Zhang <ndaugoing@gmail.com> =
wrote:
> >
> > [...]
> >
> > > Note: this closes the primary race (the last_lr_irq node itself is no
> > > longer unlinkable while in-flight), but the fold traversal can still
> > > race with a remote flush unlinking a subsequent non-LR node in the
> > > ap_list tail. Fully closing that window needs the fold side to take
> > > references before dropping locks (in the spirit of the prune-side fix
> > > in commit 7258770e5814 ("KVM: arm64: vgic: Handle race between
> > > interrupt affinity change and LPI disabling")) and is left as a
> > > follow-up.
> >
> > This is the same race Hyunwoo reported back in June [1]. You might
> > want to have a look at that thread first: Oliver and Marc's view there
> > was that the fix is to take the ap_list_lock in
> > vgic_v3_fold_lr_state() [2][3], and Hyunwoo posted a draft of that
> > [4].
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/r/aiHrGM1f8czcUby4@v4bel
> > [2] https://lore.kernel.org/r/aiJi5a3JJ-TbWL-s@kernel.org
> > [3] https://lore.kernel.org/r/87a4t99z9n.wl-maz@kernel.org
> > [4] https://lore.kernel.org/r/aiXvwGD1hS6vwLEd@v4bel
