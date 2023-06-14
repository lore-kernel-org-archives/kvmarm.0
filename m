Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886FD2EC18
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 16:58:00 +0000 (UTC)
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-46e059ec617so293039e0c.1
        for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 09:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686761879; x=1689353879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbbPZyQj/zRNMm09rt0NDUI/1g0HAs04HqoquzS+gs0=;
        b=p+9Jq7EFnCczwqdZtVQcctfkvVaOyjk2B6NgRzfmQmk5d4vI68IwzvFurN+lljEAy4
         F89OyL6ed9X+wceKO/OC1uEOwydC66YBFjuCYmCkx/xa0Ag0rUDEwIJ00llYs/oKg3l8
         WXO0HevvyTuTijUTCrL/EQWbFWdhf9Rzq7u9/52YHrEP8NWbYKoaUTw1qyUBxNoWhULN
         OVxy+3Hwjft87nlppApc7iGn3o/lEgSkgWW7ZZ6v9lmhkTQjeVVw3Av23pqOSBkMO2sT
         Ds1CkVkPx05gA8ANRPnY1BsS9G7Lu/xO5vu275Vyyp5gI64GdKtNihijUr38fWX4HJFV
         An6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686761879; x=1689353879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbbPZyQj/zRNMm09rt0NDUI/1g0HAs04HqoquzS+gs0=;
        b=fNahzjKi9CfwqLsUqqgQgVabBy7xSQVyBgnRh1pTahK13PlrZdphEfmnGOae/VitGt
         xlbz3158cVDxyrO3AIiXMcf3MY42TzcfSqGpUwrm5ZKctUxJvrMi4v7v99DbG5IphjZi
         ntM/zVgKDb81aPA1O2aj3xZnAjmjSECW4z/aj9h7rYFKipG/zv3a3qtHO/aWkR/icV1S
         g+cfjteU3L/MtRbj8UPS5Wi1M+ibrqcGgEVYjicRYdTbUNcgKqH+0fsHVBL3ZmL0UR8h
         FETK1t8ZLsxe1oxjSlPkdeHZa7FS1jVbwGLSeWFSvQxBvZc7JRKpLsGWY4faOURe2d+b
         Sa8w==
X-Gm-Message-State: AC+VfDythxyGlbPLeKTSzbUPrMAtoJX46rcwTh5s0m5SjUkPzeRwc+Kt
	gHTQSUKQW523ILv7EGVfH935BjeLts+tWtXeO8d+CA==
X-Google-Smtp-Source: ACHHUZ6nIKzVAUVzl+Hoo2q7hslSXIyOJcdcAIQPCOok57IYXyBvPoWnN133fLkGoruyGsjlbju9YFOFE31pO682uJE=
X-Received: by 2002:a1f:4c47:0:b0:465:ddcc:c0ec with SMTP id
 z68-20020a1f4c47000000b00465ddccc0ecmr5369269vka.0.1686761879188; Wed, 14 Jun
 2023 09:57:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
 <ZInRNigDyzeuf79e@google.com>
In-Reply-To: <ZInRNigDyzeuf79e@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 14 Jun 2023 09:57:22 -0700
Message-ID: <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 7:39=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Don't put trailing punctation in shortlogs, i.e. drop the period.
>
> s/pinning/getting (or maybe grabbing?), because "pinning" is already way =
too
> overloaded in the context of gup(), e.g. FOLL_PIN vs. FOLL_GET.

Done

> "read-only faults" is somewhat confusing, because every architecture pass=
es a
> non-NULL @writable for read faults.  If it weren't for KVM_ARM_MTE_COPY_T=
AGS,
> this could be "faults to read-only memslots".  Not sure how to concisely =
and
> accurately describe this.  :-/

"Read faults when establishing writable mappings is forbidden" maybe?
That should be accurate, although it's certainly not concise.
