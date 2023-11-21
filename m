Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B862F12B76
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 04:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1f7ENtfO"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cf5ceadfd8so130855ad.0
        for <kvmarm@lists.linux.dev>; Mon, 20 Nov 2023 20:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700542184; x=1701146984; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ci0fDn2VKn2ROb4P5+ApgEIrDRCxD8DQOtt7YsYQPr8=;
        b=1f7ENtfO93oLgtp4vQI/dZFfnMh4rtRnsumJXlyhsU1afnNP9/wdZJ3vu7/wIeSRaw
         NQq0zJhTbU3jIDJGM4HMUpG8LAcbs75yZg+mWcz0H/uRFYCsf1Z32p50BeJ2aT4VtZK8
         AbkvmVvZkbx4lCM4B17uR1K38AKm4RyPPIHZZFI0ybChabj0cfu1b4CnDVPCMhiynkUr
         MhsZHUBvOP5w/GUqQCC1e747aBw7L1fy65uBID/oWAdvSMrRV21KgmioaYUcjTxh5zqV
         D6Pdu19F4fSOyH+2IZZuX1aS0zxCM58ygeMmrQGidahZIbIoLPuIYUK9MBpr4tQI0XtQ
         2U6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700542184; x=1701146984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ci0fDn2VKn2ROb4P5+ApgEIrDRCxD8DQOtt7YsYQPr8=;
        b=nC3t61zCiVd/ZkmmP0WfHFEfNaloQRnI5LZXZom5rjQxDWIzeTcuIbV4juIO+F9mOY
         KFKzfNYY+946WUj87DaIKygqVZgPrBIpTTuXHMdadqeTz/BblEVaMcea+fSuJYrK5hkI
         0lTA+s3AYKGLPhn+m+AigoR8ha9G2sLSC00ibj4BEVEN9wEfDAlsiDXb8af5aM4Odzjo
         rCGGBgp4IvtrtMaTjR63T5mYjbbOCbdm0xmL/qitYQ6jsXlf24qk+KY6rcjRouKhE9ua
         ar3/WqGUPWIqqXxj6U9C9Bnn2TrPIOfHqo1jItqlLEZe8+kkPFoR0MUmNJUG+nxDNmQB
         SQ3w==
X-Gm-Message-State: AOJu0YwPNbTw09HfOUlg31nVd/PFYJxl/n/y/2AQ7Y9ExyYA/z/UF4Zj
	nP+foRJOwt12VSfQbeqYX10BX17yGcOfvfSCtzTQmA==
X-Google-Smtp-Source: AGHT+IEjrSf5kIzKqR8y96cakBbXvSTNzic/DeMBLkOBk4msBIIG12CS40E/lkAesfcKoKMOnN0ye5jmEfxbmJlxJ94=
X-Received: by 2002:a17:902:c454:b0:1cf:6d46:9f2b with SMTP id
 m20-20020a170902c45400b001cf6d469f2bmr136702plm.23.1700542183669; Mon, 20 Nov
 2023 20:49:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230823131350.114942-1-alexandru.elisei@arm.com> <20230823131350.114942-21-alexandru.elisei@arm.com>
In-Reply-To: <20230823131350.114942-21-alexandru.elisei@arm.com>
From: Peter Collingbourne <pcc@google.com>
Date: Mon, 20 Nov 2023 20:49:32 -0800
Message-ID: <CAMn1gO67Lz_Xw5SCrq3fF4rOCSw3sXYK8qC77TTGnJeWd0b0Sg@mail.gmail.com>
Subject: Re: [PATCH RFC 20/37] mm: compaction: Reserve metadata storage in compaction_alloc()
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, 
	maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, arnd@arndb.de, akpm@linux-foundation.org, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, bristot@redhat.com, vschneid@redhat.com, 
	mhiramat@kernel.org, rppt@kernel.org, hughd@google.com, steven.price@arm.com, 
	anshuman.khandual@arm.com, vincenzo.frascino@arm.com, david@redhat.com, 
	eugenis@google.com, kcc@google.com, hyesoo.yu@samsung.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexandru,

On Wed, Aug 23, 2023 at 6:16=E2=80=AFAM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> If the source page being migrated has metadata associated with it, make
> sure to reserve the metadata storage when choosing a suitable destination
> page from the free list.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  mm/compaction.c | 9 +++++++++
>  mm/internal.h   | 1 +
>  2 files changed, 10 insertions(+)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index cc0139fa0cb0..af2ee3085623 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -570,6 +570,7 @@ static unsigned long isolate_freepages_block(struct c=
ompact_control *cc,
>         bool locked =3D false;
>         unsigned long blockpfn =3D *start_pfn;
>         unsigned int order;
> +       int ret;
>
>         /* Strict mode is for isolation, speed is secondary */
>         if (strict)
> @@ -626,6 +627,11 @@ static unsigned long isolate_freepages_block(struct =
compact_control *cc,
>
>                 /* Found a free page, will break it into order-0 pages */
>                 order =3D buddy_order(page);
> +               if (metadata_storage_enabled() && cc->reserve_metadata) {
> +                       ret =3D reserve_metadata_storage(page, order, cc-=
>gfp_mask);

At this point the zone lock is held and preemption is disabled, which
makes it invalid to call reserve_metadata_storage.

Peter

> +                       if (ret)
> +                               goto isolate_fail;
> +               }
>                 isolated =3D __isolate_free_page(page, order);
>                 if (!isolated)
>                         break;
> @@ -1757,6 +1763,9 @@ static struct folio *compaction_alloc(struct folio =
*src, unsigned long data)
>         struct compact_control *cc =3D (struct compact_control *)data;
>         struct folio *dst;
>
> +       if (metadata_storage_enabled())
> +               cc->reserve_metadata =3D folio_has_metadata(src);
> +
>         if (list_empty(&cc->freepages)) {
>                 isolate_freepages(cc);
>
> diff --git a/mm/internal.h b/mm/internal.h
> index d28ac0085f61..046cc264bfbe 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -492,6 +492,7 @@ struct compact_control {
>                                          */
>         bool alloc_contig;              /* alloc_contig_range allocation =
*/
>         bool source_has_metadata;       /* source pages have associated m=
etadata */
> +       bool reserve_metadata;
>  };
>
>  /*
> --
> 2.41.0
>
