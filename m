Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FECC8828
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 22:52:20 +0000 (UTC)
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-48713d11531so3155504e0c.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 15:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692053539; x=1692658339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUxtb4YcEahALEPzkewfUVlfVRSRxTtCx1V6b30IuOk=;
        b=M2gZPj3hUNjjGTYRuuz+l20p4fc6MnM6kZ2Abp8ZLMXqfIeWjk2eowsijdKzm1RvJ0
         W+XJG2Bh9oveiyhYPVXgGAP6SlN7hqyNW24dCy4CcITleCNYaL5gpaNLn1GY4NumXHYB
         M6j95HfVYuGuFB8wo+cAeunyax1nHyuFevnBSZ/RCLoNaWA8dV9nlRB+LHLr6f8mR98A
         oXazUil6qim5dY1/Pjwe9/8UY40LVunC7/KwGDdF0DHs0GRIa4xNEE3zX+wBPMrh+HET
         7NLvAK3YieZgbq3UZkwHxaZ2jDYjIrNpxcxlvkt7BimiXe+DclF8hZkBUcAbFCu/JsTk
         4K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692053539; x=1692658339;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUxtb4YcEahALEPzkewfUVlfVRSRxTtCx1V6b30IuOk=;
        b=RbrOSAlf60uXzz89DJlgQrKOXTB34L4P7l6A6PmEeLqoU6qf/q2kjWh+42OSv3g+lO
         WzPPxk1y3kg7qVMtzPEafOqMDVjvB5K1y1dSmqVkiLKSv5rfNb4SVjhYnLEgqonCvDCv
         mjRGAfjJsLrl19tk3fGToPRMqiPXeQv6pT5DiCl888epP0afYB0N0K2MhoGVHkuYaRbe
         6cYIdlNz5EITsUgtzzpdURO7TxZQmUbR5wKXXRm01pCb3pKgpQ2Oa4jVqnkpGTURSK8i
         VDSvp08Pk1OtzPIJCa/gH816rT9wmfaz1JREcZR79mzi8xKNuBDu2CvPACF454bJfWW2
         d+tQ==
X-Gm-Message-State: AOJu0Yya6YOnFtdhSJzc1YcRl6pW+xpIisPd9Gq6S+et3XPe9DUUX1vX
	2XOspjzdFBzsdrWxE6Ke4AYDIFR+g7UIlK4Mx38lVA==
X-Google-Smtp-Source: AGHT+IEBlezrcdJgN+kx2LoFv3RPdtEDtUnoizkwRg6/nCDXUKk/DIw1owQilkE6tQ8UuBt9YzqGXi+WEg47isn22Rg=
X-Received: by 2002:a05:6122:d02:b0:487:e3da:f096 with SMTP id
 az2-20020a0561220d0200b00487e3daf096mr378821vkb.0.1692053539010; Mon, 14 Aug
 2023 15:52:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-5-amoorthy@google.com>
 <d5ebb72d-393d-f61b-6a6f-760c6a5d7469@gmail.com>
In-Reply-To: <d5ebb72d-393d-f61b-6a6f-760c6a5d7469@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Mon, 14 Aug 2023 15:51:42 -0700
Message-ID: <CAF7b7mrOc+kxJsGE-M0EnbJfUD+xx9vohspZ+cZzzG5mzv6L6w@mail.gmail.com>
Subject: Re: [PATCH v4 04/16] KVM: Add docstrings to __kvm_write_guest_page()
 and __kvm_read_guest_page()
To: Robert Hoo <robert.hoo.linux@gmail.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 7:41=E2=80=AFPM Robert Hoo <robert.hoo.linux@gmail.=
com> wrote:
>
> Agree, and how about one step further, i.e. adjust the param's sequence.
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2c276d4d0821..db2bc5d3e2c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2992,7 +2992,7 @@ static int next_segment(unsigned long len, int offs=
et)
>    */
>   static int __kvm_read_guest_page(struct kvm_memory_slot *slot,
>                                   struct kvm_vcpu *vcpu,
> -                                gfn_t gfn, void *data, int offset, int l=
en)
> +                                gfn_t gfn, int offset, void *data, int l=
en)

There are a lot of functions/callsites in kvm_main.c which use the
"offset, data, len" convention. I'd prefer to switch them all at the
same time for consistency, but I think that's too large of a change to
splice in here: so I'll leave it as is for now.
