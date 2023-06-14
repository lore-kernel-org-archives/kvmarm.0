Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F80DDF66
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 14:55:40 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-56ff505b001so10869467b3.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 07:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686754540; x=1689346540;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7V1DfK2IiNfiJ6A9SuA09e99aiPu5hGJBrKQriatKLw=;
        b=P3MJs55SHNPYRuHaaMsHn7wTydBbtDLmyHmFaHlY00+Zsx/vpA1eWmbCy+31JY9O9d
         fPEj7wT13n2EsFmgJr1tVO76JqXBemecB2BJ4Q+glLjBKS8wyKknqMLkBK26AXQib+8R
         556IGwUSbS9id7HU8dSYrqSp1MvONdbsTf8xeNYcQLz9hXcNaKA5PbpzneJmTeEuTx/6
         p0Sk7nx7XhSvZLkT8+W+hwOhZwTZMV7PsLUKEHTr0r8/lChG1W0+HdGS3grExB6OgVYD
         nm/x+eu6SGbTlFLiuR5C2RGUhS/Ye1ySxvX1IhVPX7dDEAefa3RUUD79vF9L+2vJEPYV
         nIyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686754540; x=1689346540;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7V1DfK2IiNfiJ6A9SuA09e99aiPu5hGJBrKQriatKLw=;
        b=CnniHVkRlrdFaloM9ldCzbI2aqtyOI7Gr3dF+nw88Fzn2GHMRoNxNtXZpmxp/k/05l
         WVX2pwsHdxRqrtjBw78lHtvvpITBkrMqWGr54r8DF7pe116cA447y9iZB1PLBQn8cGUm
         qLe9gz+EqNvGe0J7dWLoIKsjlH1YPnRnh/shMzvp9C1jVnw7+o1/tDeAk7+AWwyOqkjI
         3qIMxen0njrakQb5fojJ56xIKRHizjpW/sL62f/m1i4NTdhD7g9h+xShWmnK8enhNlxR
         em4cDTsMUCYHxS/IonzAlWRSdf7WMZyHMsGSBGtqZGrI4L69LyfqkB1C6exiD9surF3G
         sJkg==
X-Gm-Message-State: AC+VfDxrKg/jX97OQpyD0S1LP8cE9iRaB+oJnWt3AO5e+ON4FeAFEgGG
	0ghxlp01o1rzvGjZkaiD4VC5wxnIeCQ=
X-Google-Smtp-Source: ACHHUZ4x4vYdjzA2A3pDYEJjuL0yEXwvNt0xX4mlDqJgLaXjHTWwuIQdyLc2u+d/ANXqk8y0MkWXtA6Ao74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af65:0:b0:56d:7a5:2889 with SMTP id
 x37-20020a81af65000000b0056d07a52889mr881984ywj.7.1686754539956; Wed, 14 Jun
 2023 07:55:39 -0700 (PDT)
Date: Wed, 14 Jun 2023 07:55:38 -0700
In-Reply-To: <CAF7b7mr+suxFe63GXJWMK_XX8J1kp5Pi2yg_bNUi_0h0ub_4Jw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-4-amoorthy@google.com>
 <20230603165802.GL1234772@ls.amr.corp.intel.com> <CAF7b7mr+suxFe63GXJWMK_XX8J1kp5Pi2yg_bNUi_0h0ub_4Jw@mail.gmail.com>
Message-ID: <ZInU6leiv1z6EAPO@google.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
From: Sean Christopherson <seanjc@google.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: Isaku Yamahata <isaku.yamahata@gmail.com>, oliver.upton@linux.dev, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05, 2023, Anish Moorthy wrote:
> On Sat, Jun 3, 2023 at 9:58=E2=80=AFAM Isaku Yamahata <isaku.yamahata@gma=
il.com> wrote:
> >
> > UPM or gmem uses size instead of len. Personally I don't have any stron=
g
> > preference.  It's better to converge. (or use union to accept both?)
>=20
> I like "len" because to me it implies a contiguous range, whereas
> "size" does not: but it's a minor thing. Converging does seem good
> though.

Eh, I don't think we need to converge the two.  "size" is far more common w=
hen
describing the properties of a file (the gmem case), whereas "length" is of=
ten
used when describing the number of bytes being accessed by a read/write.  I=
.e.
they're two different things, so using different words to describe them isn=
't a
bad thing.

Though I suspect by "UPM or gmem" Isakue really meant "struct kvm_memory_at=
tributes".
I don't think we need to converge that one either, though I do agree that "=
size"
isn't the greatest name.  I vote to rename kvm_memory_attributes's "size" t=
o either
"nr_bytes" or "len".
