Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83AD8BEC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 18:00:14 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id ss4so41095367ejb.11
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 10:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CR+eHZCmsOLVBVRRoVChzcJ1AsBE6lpJW9PrVgj0s6g=;
        b=Cw9Uwe174EgmcP/g2cdQN1+pRybaMlnnAYILSsNY+vuKby8RRfgI1dnaPXI+gE9hQ4
         cS/fqaYsYCl9yWS8Ay34UpMeiINfEOLW/Rahvho2fg/OnL6hAQ1E2DWdohi84leH1qDf
         MFGPb6vAW3ckr+0elwyuygSwMNf3FLT1vXlJxyPJ+lfdd/k9n69yQT2wmkRx4kSiWXNo
         aI2W090+PQsyPBmwI9SxxYZsadOhAhMtCoWGryybeLpMKLqhirXqnAVeT5P1k+u35ywA
         iHmxHNcGoTtxsCoePJz8ilgyv9Gx2nm0iXNocygop9bMKa5ANJI4wV4AYhjHIQvKP7Ae
         YLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CR+eHZCmsOLVBVRRoVChzcJ1AsBE6lpJW9PrVgj0s6g=;
        b=R27W8WOBzvpdpSwu1qUVRpdyHpN3MocK39XQHh7YAt8xEPhZirxekTIFgvqBRJSgmK
         ZyUz0TF0WS2RDNGwzf4YgZzxRc7ayfiRNJ75OJJHHTwXDwlPwCsETCpf6XqDoWOn2Dfk
         AUkEyNn2vNCt4zKRrqHQKyhf+9W1m6CTwgHjrJ1l9cJj+tkExQbUEw4uGAw8kcVOx/Ce
         T/pCDVZye6+rp+ceTSHNKtTscovGvSZogx6bLuxT4fcGs2HiNvVVg/BUuRCR79aJnBHt
         /s+rYLGxzBUlsalcjdImvHxGo/kTRBKrPWzNVvdvezI3fxTZ3zQtK/qc7q38yyIiH8uM
         5Fyg==
X-Gm-Message-State: AFqh2kptPHOCnrM8SJk7CI4j3dkdj3A3prZ+t477jH7GRoqZSNlQH+Cl
	wfytdgUhBmQZSaHUX2SVmYLqaa4tIwKt0lnGPTF1wg==
X-Google-Smtp-Source: AMrXdXsyAdxT43V4WRGbyl0sxPk45SihpP4dVySllPpRGdgMUYJr09b/AHZjrbtjI9nYF3SnZ7hc/fywRlBC5zkQsgI=
X-Received: by 2002:a17:906:2e94:b0:84d:ac8:ec37 with SMTP id
 o20-20020a1709062e9400b0084d0ac8ec37mr3361379eji.138.1674583212949; Tue, 24
 Jan 2023 10:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-2-ricarkol@google.com>
 <CANgfPd9gMoR=F3uKhDtjsUV0efuoNvCLV0o0WoJKm9zx_PaKsQ@mail.gmail.com>
 <Y88sq1cQUzVj9B4D@google.com> <Y9AIMtJEgEjoVWQA@google.com>
In-Reply-To: <Y9AIMtJEgEjoVWQA@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Tue, 24 Jan 2023 10:00:01 -0800
Message-ID: <CANgfPd94DiuhuU7FhAWgPYDcR_YgJC91ORiTtZY2LEuB8Wno7g@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
To: Ricardo Koller <ricarkol@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com, maz@kernel.org, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 8:32 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Tue, Jan 24, 2023 at 12:56:11AM +0000, Oliver Upton wrote:
> > On Mon, Jan 23, 2023 at 04:51:16PM -0800, Ben Gardon wrote:
> > > On Thu, Jan 12, 2023 at 7:50 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > >
> > > > Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
> > > > indicate that the walk is on a removed table not accesible to the HW
> > > > page-table walker. Then use it to avoid doing break-before-make or
> > > > performing CMOs (Cache Maintenance Operations) when mapping a removed
> > >
> > > Nit: Should this say unmapping? Or are we actually going to use this
> > > to map memory ?
> >
> > I think the *_REMOVED term feels weird as it relates to constructing a
> > page table. It'd be better if we instead added flags to describe the
> > operations we intend to elide (i.e. CMOs and TLBIs).
>
> What about KVM_PGTABLE_WALK_ELIDE_BBM and KVM_PGTABLE_WALK_ELIDE_CMO?

I like this, but please don't use elide in the code. I'm all for
vocabulary, but that's not a common enough word to expect everyone to
know. Perhaps just SKIP?

>
> > That way the
> > implementation is generic enough that we can repurpose it for other use
> > cases.
>
> Aha, good point. I actually have a use case for it (FEAT_BBM).
>
> >
> > --
> > Thanks,
> > Oliver
