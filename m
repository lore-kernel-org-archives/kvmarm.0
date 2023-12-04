Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91398C8F9
	for <kvmarm@lists.linux.dev>; Mon,  4 Dec 2023 08:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2SvPfDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701679684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1O1GHkZ2Qe7CcODotGlaFEj1pA1PKM1puCHikGn9aeQ=;
	b=S2SvPfDuELzRzONtyUTByXhBQgumhnCzcKZPkn+brvRTulegrbRXsBazaf7e/p5mQNPuag
	YiPtKPPXmiZ7ANnhClO/Z6l3a9GQ0cEztDzBKQurulZR8VXocl7oUqnGTbcxANN+3hO6Zw
	l5nMYxKUh0zZuYOWPeMEccbHY+Pa7aQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-rDbHhTYFOkO8Tt_XYVe8iQ-1; Mon, 04 Dec 2023 03:48:03 -0500
X-MC-Unique: rDbHhTYFOkO8Tt_XYVe8iQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50bf00775ecso1043628e87.0
        for <kvmarm@lists.linux.dev>; Mon, 04 Dec 2023 00:48:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701679681; x=1702284481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1O1GHkZ2Qe7CcODotGlaFEj1pA1PKM1puCHikGn9aeQ=;
        b=bntd97copX5tSq+ajpYovWNQ6REkueS6vp32Om8WTg/TmlrVbkBXn0VI2sGBP8dodG
         +ok+NYXnKDdwh+q6qtvWKpuCKwkxY2sFuMdv6Ktm0+UazhnIEDlAttZYr2zYCtF9ucVI
         99lx8b4BYo8WSxeLiwGchck5WFawmn9b4iaUU90J/3taXkhK9L/GfYbMilE4+yTM6jqV
         8shoDyqXoNaolcNcqXQDs7NumTlYcW5gK+PS3HGrm9Ez+KTDUVxJhJH1AWQ15XacONeS
         5HF92lGEpisGrpJ7RcpGK5kZK5U+3svAe+7T5/68cpKNh6OiYtMFqSqN6eT8VSeBD156
         cZwA==
X-Gm-Message-State: AOJu0YxMDwAlLZQWBJl9z/d3Te4wyV8Hlkxz6OGQMveqcAJysZZYcOEY
	87Fc7NLB0U8QutC24i64SIyacFzVJL4KK1k65RNDPz5G9DbKj1oDbBMVjCMxTYbJk1c9aQhozyJ
	KIkRBOg0iXzOaKZavNGPkIjVOedjRRUEt
X-Received: by 2002:a05:6512:31c4:b0:50b:d764:9682 with SMTP id j4-20020a05651231c400b0050bd7649682mr3453488lfe.102.1701679681543;
        Mon, 04 Dec 2023 00:48:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFNpyZl3CwMVFLh53IQjaLkzKjbxZ1SQYuv9EPSLS5561Kpl2BVkIh6xEnVf/SBfcuxpc2n7FrGmD2cINj4zVM=
X-Received: by 2002:a05:6512:31c4:b0:50b:d764:9682 with SMTP id
 j4-20020a05651231c400b0050bd7649682mr3453465lfe.102.1701679681197; Mon, 04
 Dec 2023 00:48:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231102143507.840-1-jiangkunkun@huawei.com> <87msvt6cc7.wl-maz@kernel.org>
 <1fb8353e-e9c4-2570-c2ca-ec537c18ac4d@huawei.com> <86edh228xx.wl-maz@kernel.org>
 <952bd5dc-dd20-acc3-d77e-c9b14e5728d3@huawei.com> <87fs0k94og.wl-maz@kernel.org>
 <CACGkMEt5sapZjpyBSM5oX_=k1AcefEe5D4wtX=HqtHy4AD3j_g@mail.gmail.com>
In-Reply-To: <CACGkMEt5sapZjpyBSM5oX_=k1AcefEe5D4wtX=HqtHy4AD3j_g@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 4 Dec 2023 16:47:49 +0800
Message-ID: <CACGkMEub4f0FWsrJzSK4e+9cC6LUNFm3vAcfSkpsp6pD=WM5qA@mail.gmail.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: GICv4: Support shared VLPI
To: Marc Zyngier <maz@kernel.org>
Cc: Kunkun Jiang <jiangkunkun@huawei.com>, dongli.zhang@oracle.com, cohuck@redhat.com, 
	stefanha@redhat.com, mst@redhat.com, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	"open list:IRQCHIP DRIVERS" <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, wanghaibin.wang@huawei.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 4, 2023 at 4:39=E2=80=AFPM Jason Wang <jasowang@redhat.com> wro=
te:
>
> On Sat, Dec 2, 2023 at 8:20=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
> >
> > Hi Kunkun,
> >
> > On Wed, 08 Nov 2023 09:45:51 +0000,
> > Kunkun Jiang <jiangkunkun@huawei.com> wrote:
> > >
> > > Hi Marc,
> > >
> > > On 2023/11/6 23:33, Marc Zyngier wrote:
> > > > On Mon, 06 Nov 2023 14:59:01 +0000,
> > > > Kunkun Jiang <jiangkunkun@huawei.com> wrote:
> > > >> The virtio-pci driver write entry1-6
> > > >> massage.data in the msix-table and trap to QEMU for processing. Th=
e
> > > >> massage.data is as follow:
> > > >>> entry-0 0
> > > >>> entry-1 1
> > > >>> entry-2 1
> > > >>> entry-3 1
> > > >>> entry-4 1
> > > >>> entry-5 1
> > > >>> entry-6 1
>
> It looks like a bug from the driver. It should only use vector 0 and 1
> in this case.
>
> Could you please check the queue_msix_vector for each queue in this case?

Or did you actually mean queue_msix_vector here? I'm not familiar with
ARM but 0 doesn't seem to be a good message.data anyhow.

Thanks

