Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D869A37CD5A
	for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773770585; cv=pass; b=Bd1pIH5crWCz06Yv8YL01LQN1oKWuMUE9KfgbXvEjAdXBBrWZajtgRsgUglvosQTFU+MQGKV5/tJNzNFVb/jLoyYB+keLT5Oibn24oH3Ky3kqs/3HOFJSxMe9h8iGCaFF7oq3I1zAwGeNaoNXF4Z0vIITjGXxwuXi71uQn6vWdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773770585; c=relaxed/simple;
	bh=bD7vMP1uxdtIIi1MxBEapxPw33V0WN5HHK2qHHZHQ64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MaIvUA3M7ox7G+iG9ujwHCgKSxWQvzgWAI7szZeXTeJrwVUTtEFKF5Ue3gEQlix580TYPdnwljVkoqqtr8Ef8HGaHP1/zEhxeehefxDpOJX6+ilz+Y931GnajjJJBcPPrL5zif4KK2VaLdID+zGWwuy5I19PYapZ2ZLWUn+HFGw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FRy6PXAk; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FRy6PXAk"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50906a98ffeso66571cf.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Mar 2026 11:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773770582; cv=none;
        d=google.com; s=arc-20240605;
        b=IfUrnBoJuvBnl8xATcJglb4ALBrrySuI7mmAKubSUnAYwUP0FAk4oqcV6eXV9Oic7i
         YIwdsMRsCw6P2bGpay+Mmotz9XtrSAWlAosWZjPz1AsjFeh67cQ23rn5fykYtPRY5x0F
         dUiUkpMXpmdcS1Qvyt4C9TfEAbpUhx+zyWvdR+J0pP0uyzDtdLAUftnSN7sSWLWQXVAu
         4GndP8N/py+nHn5GSUTxJV3bhrsV/Ti7saUSjy+f3c6O3c4r2vgHZKzw+XD1HusQX0qi
         SuK7rHdg2RU6ZZzvNvUNEEp4AY6knd0kt7wSLyn83784f0GuckRv+khqCufb3VxPVmyU
         9WAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1V79m/qtPd2CPkeGy9ve7l8GZ9xh9SScmUR42+dIKPU=;
        fh=clnHTzAvt4aYOa2Pra7MMfnGJgWCg3sy4xV9cvJ65Tc=;
        b=cqH1Azcw8Wx/PhFr/lHMA9TZNcVobC19/bk8mgrB0ez96w8f7EeYsQ6F6fvp91ehFC
         AumdvW18CsONACda2YiPjyJFDDMaLyN2AVetpQNrxyB4fJzFUQ1C0MLXiRbZAmff5/qZ
         Tkss7wzeqe8jcsiIiLvzlKAfJ7uMSev9YtYHVR1LPbu3FFVGq6IgNldSD7poJeiwwvVI
         Q8BZJZ7XPlIeB7U+r4z6iERetb7V0zc9fsG/4piqZDwtkbWpTR90SH4Il1Jf9um1yjh5
         NF6Wvs0itvsuo/FwqSbIkRTQ2KMjWRy7mXRgRGJgE18FtxSU9MukQGCPf1p6pMhyf+Lu
         fudQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773770582; x=1774375382; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1V79m/qtPd2CPkeGy9ve7l8GZ9xh9SScmUR42+dIKPU=;
        b=FRy6PXAkdebY3RlZlqM8E1lu00zZWKeL5YGiH2K9aSyotXzuayIjHDhxjTkim9Qw2d
         BhcIpOnfKiC2pTI3ggM0aMD7q59CujFRYcBrRKmwCBb5hGl98Vctm1AWccnQ/uJpsxj2
         VrGbNMZvcoIhNU8PT0tH3Z2oHEIAE5s2r1SNF7UQd1d3vvliEZlTUufrP8llIQ78k+05
         SrkV4pT63OVRIxw2OYIC70Sw8Zw7HlvByYr7vz8wA+6EIyf1OpBDDvtoJ9uHsW4HHzrl
         UZq7WXo0O1bDeWAsygTCEGPC1huAtT/tUqD+nVkKK2b5mzSffZyVpvjKlI/I/ZXOsxor
         NwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773770582; x=1774375382;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V79m/qtPd2CPkeGy9ve7l8GZ9xh9SScmUR42+dIKPU=;
        b=o0qQtMRKsDZbS7v+HcpDghc8rgb34Rxk51i9d7cfnJ65u04FrnbFDWAptP2E23t8SB
         OnRUXfA1miS/+atTIFArr+jppwB8Q4WVIUxZSJi9R+45Islc6il+LCPJzOg+pF0ijp9P
         r4cQeo/hXNGqqlNiBQe8ogvGMPcn0GWi9ifWeChboJs3PLOopTrY+Twj4KLJC5tvbuDZ
         i9+GBR+EtCBKhkFMQxP5GRgQJHs/kiQtmJ8XqdkkpxCtPC39wvlEnu7I8dvE9V2FfAYP
         nFFMAukxD5rE/dKAM+Bg2B57vSfbGf4C96l+ITOTtqBvMZ4gn/RNE7xYQ4e1XsBm7sfr
         F7xA==
X-Gm-Message-State: AOJu0YzyDRwWHX+wEP5ZPfJl3+e60OXSCW5CWwPwP6Gocuh1KtGxpeWP
	HTgQy9J1uKT5jR9pygH20OyHaHzjTUwbgeJpImd6SFaNeVjNVeGtix7Kt9wqSkzyw+mUmz3jeT1
	rF96Oe+Lj5FaH4DyNPVvr72uJCdI7ToaLdJ6vSfow
X-Gm-Gg: ATEYQzwqZZsOAmTFXFsxaScWcLF6vnNpWbeJeJAiR0YemKfqmWQHFbYXy3yQ2VMUNyO
	BgwUhcWnB2cM6wSiX/kzz2blFWxn0WNh2j9vl5C/6h0X7LxVBU524hAp4/8ryC2x3zFR6DnVUx0
	xP6rd8vRdj08Fh6Gjvyl3w5sJ0eY2Zio0O5SOaJ4yZsc7rfBITQN03rqSUSQGiSbHvLhDa3LRoB
	JXiyBOyDlUWUFFwlENyWZlM71iED4ws+qvBpC2klOQCOdoJ180uTuNojl9XU18rTEElDZPyE9Ax
	2hDGRxHv
X-Received: by 2002:a05:622a:178f:b0:509:14f0:bff2 with SMTP id
 d75a77b69052e-50b148054aamr1140381cf.12.1773770581019; Tue, 17 Mar 2026
 11:03:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <CA+EHjTyBtM5idopKisJf_e10aRifubtKEpbkjkEnmrOqa9-SPw@mail.gmail.com>
 <CA+EHjTy=MCgeKoi9sA_eDuiODucOdMP5m4CAciUW=rStgJggmQ@mail.gmail.com>
 <86tsue6ezy.wl-maz@kernel.org> <CA+EHjTxF9fLtjdTtJontFuziRsgGMeE0bvEjHYqr64hDK3wLVg@mail.gmail.com>
In-Reply-To: <CA+EHjTxF9fLtjdTtJontFuziRsgGMeE0bvEjHYqr64hDK3wLVg@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Mar 2026 18:02:23 +0000
X-Gm-Features: AaiRm53dTl6Qirg4e0url9XntUW8jOUcL89COPt1hC5dsOyIpA9_l2n6qMF9Tr8
Message-ID: <CA+EHjTxUmBOK6fMmYcw3QR8V5rb-KM9vCN-deCeeB2QvDAOO2w@mail.gmail.com>
Subject: Re: [PATCH 00/17] KVM: arm64: More user_mem_abort() rework
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Mar 2026 at 17:50, Fuad Tabba <tabba@google.com> wrote:
>
> <snip>
>
> > > > The series in hack/user_mem_abort-rework is different from this one.
> > > > Here are the first few patches:
> > >
> > > And I just realized it's because they're based on _my_ patches ... doh! :D
> >
> > I thought I was clear when I wrote "I've added my on take on top of
> > it", but maybe not. In any case, I didn't feel the need to redo what
> > you had already done -- I don't think I'd have come up with something
> > better.
>
> You were clear. It's the reader's fault, not the author's.
>
> I'll send you one more patch that might be worth adding, but this
> looks great! Much easier to reason about. Thanks.

On a second thought, let's stop here. I was thinking of going ahead
with guest_memfd abort, but let's see how this one goes and take it
from there.

Thanks again for this!
/fuad

> For the series:
> Tested-by: Fuad Tabba <tabba@google.com>
>
> (might as well repeat it here)
> Reviwed-by: Fuad Tabba <tabba@google.com>
>
> Cheers,
> /fuad
>
>
> >
> > In any case, I'd appreciate your feedback!
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
