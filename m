Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BB0C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 18:21:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8600960187
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 18:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8600960187
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EC554B0D0;
	Wed, 18 Aug 2021 14:21:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lr6i9WNWuUH9; Wed, 18 Aug 2021 14:21:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 115174B0B3;
	Wed, 18 Aug 2021 14:21:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5042E4B1B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 09:06:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ubozN+EatQKV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 09:06:44 -0400 (EDT)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com
 [209.85.221.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE4FE4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 09:06:44 -0400 (EDT)
Received: by mail-vk1-f169.google.com with SMTP id j196so3423374vkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 06:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=745PA0ZZ7OzUNLEhPL+IlI/BkoDSTjzvZeg48uD4JuY=;
 b=iVGh25w/k1FK9GhtXmwM+KO0ASfGHg1oe/CFf00QPoqZZ+D7Ix/R5L9ptwTiX7pM5I
 DQZJkQDTzFoSsQdOmcAjZsiLam5EP50tuOpGNEj8LfR3DxercJwFB+9fHzgExAg0SDQv
 tnOEfHVHzMtZeRMuMnp8UQuwwPH2msamcXHwhvR+mgZaE0nn/1S3pwGD18WLBD1hjG+0
 20xlUl+gDnTYUybv4qy7KCWkLot+VRnfWMBo8ppu6p/9PukK2+L225m7xgQZBtGZpN8E
 bKLWRaICEwMvkPQVgheqshrY8q6IahpJeRwXLWGSqbDPjDVfi4Z7l0RyMSu9n5tlSdRf
 ww0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=745PA0ZZ7OzUNLEhPL+IlI/BkoDSTjzvZeg48uD4JuY=;
 b=Y+tEbrAEscSgmvKYzzb60KV56S+xbnfuG7m5TmBb1lyT2+Bq8I3PmONLvCGXYPtJUk
 dnbQG55VpWX3A2t6rvim2QC9+XmvDavQEAhy/Lst0aTE8cuuO3kcBJKEeVcmpkpryHkc
 HFIY647/vLwHzQhORZBz6ntS3BONqrsw11la6OTspu0vxdJaZ6M2dtK8qNhZ7dGMrgAz
 gKfGMGHYRbMUpqZeyThlZDMBYBDIWqdlDWRpqofsdvduiEZxHfFVJlUNSHpf91PfSd+k
 RFD0rLk8Nhs0g6nzwKuroFRuRlwSh6b1EkKwpSzVOiVRRtPzBZnWa30pAYsGBdlX/dX0
 J3fA==
X-Gm-Message-State: AOAM532b7bCe29+zMGYnSPY6TOmTYKcovjNYBYyqNz48LOpcF1C0kQf3
 af2JH9zfhIgz+wM2TPbgwICZlBNteX63NQfA6bdcpA==
X-Google-Smtp-Source: ABdhPJxgFxIGOrHHNxJmG8sJsBiqUe3my7E9+QbhnZGL+8yHBT6snx1ff2yxzyts352+2QHr+/SL84/H+SRKVG7yED4=
X-Received: by 2002:a1f:3808:: with SMTP id f8mr2318802vka.2.1629205604191;
 Tue, 17 Aug 2021 06:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
 <20210809152448.1810400-4-qperret@google.com>
In-Reply-To: <20210809152448.1810400-4-qperret@google.com>
From: Andrew Walbran <qwandor@google.com>
Date: Tue, 17 Aug 2021 14:06:32 +0100
Message-ID: <CA+_y_2EFZjEQEvX-ipy7Z40jDaeD8hd7YnxswkgGCp8VM4eHGw@mail.gmail.com>
Subject: Re: [PATCH v4 03/21] KVM: arm64: Provide the host_stage2_try() helper
 macro
To: Quentin Perret <qperret@google.com>
X-Mailman-Approved-At: Wed, 18 Aug 2021 14:21:08 -0400
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6031177081538323196=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============6031177081538323196==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000005331c405c9c0fd55"

--0000000000005331c405c9c0fd55
Content-Type: multipart/alternative; boundary="0000000000004e3fad05c9c0fd01"

--0000000000004e3fad05c9c0fd01
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Aug 2021 at 16:24, Quentin Perret <qperret@google.com> wrote:

> We currently unmap all MMIO mappings from the host stage-2 to recycle
> the pages whenever we run out. In order to make this pattern easy to
> re-use from other places, factor the logic out into a dedicated macro.
> While at it, apply the macro for the kvm_pgtable_stage2_set_owner()
> calls. They're currently only called early on and are guaranteed to
> succeed, but making them robust to the -ENOMEM case doesn't hurt and
> will avoid painful debugging sessions later on.
>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c | 40 +++++++++++++++------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d938ce95d3bd..74280a753efb 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -208,6 +208,25 @@ static inline int __host_stage2_idmap(u64 start, u64
> end,
>                                       prot, &host_s2_pool);
>  }
>
> +/*
> + * The pool has been provided with enough pages to cover all of memory
> with
> + * page granularity, but it is difficult to know how much of the MMIO
> range
> + * we will need to cover upfront, so we may need to 'recycle' the pages
> if we
> + * run out.
> + */
> +#define host_stage2_try(fn, ...)                                       \
> +       ({                                                              \
> +               int __ret;                                              \
> +               hyp_assert_lock_held(&host_kvm.lock);                   \
> +               __ret = fn(__VA_ARGS__);                                \
> +               if (__ret == -ENOMEM) {                                 \
> +                       __ret = host_stage2_unmap_dev_all();            \
> +                       if (!__ret)                                     \
> +                               __ret = fn(__VA_ARGS__);                \
> +               }                                                       \
> +               __ret;                                                  \
> +        })
> +
>  static int host_stage2_idmap(u64 addr)
>  {
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R |
> KVM_PGTABLE_PROT_W;
> @@ -223,22 +242,7 @@ static int host_stage2_idmap(u64 addr)
>         if (ret)
>                 goto unlock;
>
> -       ret = __host_stage2_idmap(range.start, range.end, prot);
> -       if (ret != -ENOMEM)
> -               goto unlock;
> -
> -       /*
> -        * The pool has been provided with enough pages to cover all of
> memory
> -        * with page granularity, but it is difficult to know how much of
> the
> -        * MMIO range we will need to cover upfront, so we may need to
> 'recycle'
> -        * the pages if we run out.
> -        */
> -       ret = host_stage2_unmap_dev_all();
> -       if (ret)
> -               goto unlock;
> -
> -       ret = __host_stage2_idmap(range.start, range.end, prot);
> -
> +       ret = host_stage2_try(__host_stage2_idmap, range.start, range.end,
> prot);
>  unlock:
>         hyp_spin_unlock(&host_kvm.lock);
>
> @@ -257,8 +261,8 @@ int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
>                 return -EINVAL;
>
>         hyp_spin_lock(&host_kvm.lock);
> -       ret = kvm_pgtable_stage2_set_owner(&host_kvm.pgt, start, end -
> start,
> -                                          &host_s2_pool, pkvm_hyp_id);
> +       ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_kvm.pgt,
> +                             start, end - start, &host_s2_pool,
> pkvm_hyp_id);
>         hyp_spin_unlock(&host_kvm.lock);
>
>         return ret != -EAGAIN ? ret : 0;
> --
> 2.32.0.605.g8dce9f2422-goog
>
>
Reviewed-by: Andrew Walbran <qwandor@google.com>

--0000000000004e3fad05c9c0fd01
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdiBkaXI9Imx0ciI+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfcXVv
dGUiPjxkaXYgZGlyPSJsdHIiIGNsYXNzPSJnbWFpbF9hdHRyIj5PbiBNb24sIDkgQXVnIDIwMjEg
YXQgMTY6MjQsIFF1ZW50aW4gUGVycmV0ICZsdDs8YSBocmVmPSJtYWlsdG86cXBlcnJldEBnb29n
bGUuY29tIj5xcGVycmV0QGdvb2dsZS5jb208L2E+Jmd0OyB3cm90ZTo8YnI+PC9kaXY+PGJsb2Nr
cXVvdGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjBweCAwcHggMHB4IDAuOGV4
O2JvcmRlci1sZWZ0OjFweCBzb2xpZCByZ2IoMjA0LDIwNCwyMDQpO3BhZGRpbmctbGVmdDoxZXgi
PldlIGN1cnJlbnRseSB1bm1hcCBhbGwgTU1JTyBtYXBwaW5ncyBmcm9tIHRoZSBob3N0IHN0YWdl
LTIgdG8gcmVjeWNsZTxicj4NCnRoZSBwYWdlcyB3aGVuZXZlciB3ZSBydW4gb3V0LiBJbiBvcmRl
ciB0byBtYWtlIHRoaXMgcGF0dGVybiBlYXN5IHRvPGJyPg0KcmUtdXNlIGZyb20gb3RoZXIgcGxh
Y2VzLCBmYWN0b3IgdGhlIGxvZ2ljIG91dCBpbnRvIGEgZGVkaWNhdGVkIG1hY3JvLjxicj4NCldo
aWxlIGF0IGl0LCBhcHBseSB0aGUgbWFjcm8gZm9yIHRoZSBrdm1fcGd0YWJsZV9zdGFnZTJfc2V0
X293bmVyKCk8YnI+DQpjYWxscy4gVGhleSYjMzk7cmUgY3VycmVudGx5IG9ubHkgY2FsbGVkIGVh
cmx5IG9uIGFuZCBhcmUgZ3VhcmFudGVlZCB0bzxicj4NCnN1Y2NlZWQsIGJ1dCBtYWtpbmcgdGhl
bSByb2J1c3QgdG8gdGhlIC1FTk9NRU0gY2FzZSBkb2VzbiYjMzk7dCBodXJ0IGFuZDxicj4NCndp
bGwgYXZvaWQgcGFpbmZ1bCBkZWJ1Z2dpbmcgc2Vzc2lvbnMgbGF0ZXIgb24uPGJyPg0KPGJyPg0K
UmV2aWV3ZWQtYnk6IEZ1YWQgVGFiYmEgJmx0OzxhIGhyZWY9Im1haWx0bzp0YWJiYUBnb29nbGUu
Y29tIiB0YXJnZXQ9Il9ibGFuayI+dGFiYmFAZ29vZ2xlLmNvbTwvYT4mZ3Q7PGJyPg0KU2lnbmVk
LW9mZi1ieTogUXVlbnRpbiBQZXJyZXQgJmx0OzxhIGhyZWY9Im1haWx0bzpxcGVycmV0QGdvb2ds
ZS5jb20iIHRhcmdldD0iX2JsYW5rIj5xcGVycmV0QGdvb2dsZS5jb208L2E+Jmd0Ozxicj4NCi0t
LTxicj4NCsKgYXJjaC9hcm02NC9rdm0vaHlwL252aGUvbWVtX3Byb3RlY3QuYyB8IDQwICsrKysr
KysrKysrKysrKy0tLS0tLS0tLS0tLTxicj4NCsKgMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlv
bnMoKyksIDE4IGRlbGV0aW9ucygtKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS9oeXAvbnZoZS9tZW1fcHJvdGVjdC5jIGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvbWVt
X3Byb3RlY3QuYzxicj4NCmluZGV4IGQ5MzhjZTk1ZDNiZC4uNzQyODBhNzUzZWZiIDEwMDY0NDxi
cj4NCi0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL21lbV9wcm90ZWN0LmM8YnI+DQorKysg
Yi9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9tZW1fcHJvdGVjdC5jPGJyPg0KQEAgLTIwOCw2ICsy
MDgsMjUgQEAgc3RhdGljIGlubGluZSBpbnQgX19ob3N0X3N0YWdlMl9pZG1hcCh1NjQgc3RhcnQs
IHU2NCBlbmQsPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgcHJvdCwgJmFtcDtob3N0X3MyX3Bvb2wpOzxicj4NCsKgfTxicj4NCjxi
cj4NCisvKjxicj4NCisgKiBUaGUgcG9vbCBoYXMgYmVlbiBwcm92aWRlZCB3aXRoIGVub3VnaCBw
YWdlcyB0byBjb3ZlciBhbGwgb2YgbWVtb3J5IHdpdGg8YnI+DQorICogcGFnZSBncmFudWxhcml0
eSwgYnV0IGl0IGlzIGRpZmZpY3VsdCB0byBrbm93IGhvdyBtdWNoIG9mIHRoZSBNTUlPIHJhbmdl
PGJyPg0KKyAqIHdlIHdpbGwgbmVlZCB0byBjb3ZlciB1cGZyb250LCBzbyB3ZSBtYXkgbmVlZCB0
byAmIzM5O3JlY3ljbGUmIzM5OyB0aGUgcGFnZXMgaWYgd2U8YnI+DQorICogcnVuIG91dC48YnI+
DQorICovPGJyPg0KKyNkZWZpbmUgaG9zdF9zdGFnZTJfdHJ5KGZuLCAuLi4pwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8Kg
IMKgIMKgIMKgKHvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBcPGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgaW50IF9fcmV0O8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBoeXBfYXNzZXJ0X2xvY2tfaGVsZCgmYW1wO2hvc3Rfa3ZtLmxvY2sp
O8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoF9fcmV0ID0gZm4oX19WQV9BUkdTX18pO8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoX19y
ZXQgPT0gLUVOT01FTSkge8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoF9fcmV0
ID0gaG9zdF9zdGFnZTJfdW5tYXBfZGV2X2FsbCgpO8KgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoIV9fcmV0KcKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgXDxicj4NCivCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoF9fcmV0ID0gZm4oX19W
QV9BUkdTX18pO8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIFw8YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqB9wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBcPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgX19yZXQ7wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgXDxicj4NCivCoCDCoCDCoCDCoCB9KTxi
cj4NCis8YnI+DQrCoHN0YXRpYyBpbnQgaG9zdF9zdGFnZTJfaWRtYXAodTY0IGFkZHIpPGJyPg0K
wqB7PGJyPg0KwqAgwqAgwqAgwqAgZW51bSBrdm1fcGd0YWJsZV9wcm90IHByb3QgPSBLVk1fUEdU
QUJMRV9QUk9UX1IgfCBLVk1fUEdUQUJMRV9QUk9UX1c7PGJyPg0KQEAgLTIyMywyMiArMjQyLDcg
QEAgc3RhdGljIGludCBob3N0X3N0YWdlMl9pZG1hcCh1NjQgYWRkcik8YnI+DQrCoCDCoCDCoCDC
oCBpZiAocmV0KTxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gdW5sb2NrOzxicj4N
Cjxicj4NCi3CoCDCoCDCoCDCoHJldCA9IF9faG9zdF9zdGFnZTJfaWRtYXAocmFuZ2Uuc3RhcnQs
IHJhbmdlLmVuZCwgcHJvdCk7PGJyPg0KLcKgIMKgIMKgIMKgaWYgKHJldCAhPSAtRU5PTUVNKTxi
cj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGdvdG8gdW5sb2NrOzxicj4NCi08YnI+DQotwqAg
wqAgwqAgwqAvKjxicj4NCi3CoCDCoCDCoCDCoCAqIFRoZSBwb29sIGhhcyBiZWVuIHByb3ZpZGVk
IHdpdGggZW5vdWdoIHBhZ2VzIHRvIGNvdmVyIGFsbCBvZiBtZW1vcnk8YnI+DQotwqAgwqAgwqAg
wqAgKiB3aXRoIHBhZ2UgZ3JhbnVsYXJpdHksIGJ1dCBpdCBpcyBkaWZmaWN1bHQgdG8ga25vdyBo
b3cgbXVjaCBvZiB0aGU8YnI+DQotwqAgwqAgwqAgwqAgKiBNTUlPIHJhbmdlIHdlIHdpbGwgbmVl
ZCB0byBjb3ZlciB1cGZyb250LCBzbyB3ZSBtYXkgbmVlZCB0byAmIzM5O3JlY3ljbGUmIzM5Ozxi
cj4NCi3CoCDCoCDCoCDCoCAqIHRoZSBwYWdlcyBpZiB3ZSBydW4gb3V0Ljxicj4NCi3CoCDCoCDC
oCDCoCAqLzxicj4NCi3CoCDCoCDCoCDCoHJldCA9IGhvc3Rfc3RhZ2UyX3VubWFwX2Rldl9hbGwo
KTs8YnI+DQotwqAgwqAgwqAgwqBpZiAocmV0KTxicj4NCi3CoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGdvdG8gdW5sb2NrOzxicj4NCi08YnI+DQotwqAgwqAgwqAgwqByZXQgPSBfX2hvc3Rfc3RhZ2Uy
X2lkbWFwKHJhbmdlLnN0YXJ0LCByYW5nZS5lbmQsIHByb3QpOzxicj4NCi08YnI+DQorwqAgwqAg
wqAgwqByZXQgPSBob3N0X3N0YWdlMl90cnkoX19ob3N0X3N0YWdlMl9pZG1hcCwgcmFuZ2Uuc3Rh
cnQsIHJhbmdlLmVuZCwgcHJvdCk7PGJyPg0KwqB1bmxvY2s6PGJyPg0KwqAgwqAgwqAgwqAgaHlw
X3NwaW5fdW5sb2NrKCZhbXA7aG9zdF9rdm0ubG9jayk7PGJyPg0KPGJyPg0KQEAgLTI1Nyw4ICsy
NjEsOCBAQCBpbnQgX19wa3ZtX21hcmtfaHlwKHBoeXNfYWRkcl90IHN0YXJ0LCBwaHlzX2FkZHJf
dCBlbmQpPGJyPg0KwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0dXJuIC1FSU5WQUw7PGJyPg0K
PGJyPg0KwqAgwqAgwqAgwqAgaHlwX3NwaW5fbG9jaygmYW1wO2hvc3Rfa3ZtLmxvY2spOzxicj4N
Ci3CoCDCoCDCoCDCoHJldCA9IGt2bV9wZ3RhYmxlX3N0YWdlMl9zZXRfb3duZXIoJmFtcDtob3N0
X2t2bS5wZ3QsIHN0YXJ0LCBlbmQgLSBzdGFydCw8YnI+DQotwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgJmFtcDtob3N0X3MyX3Bv
b2wsIHBrdm1faHlwX2lkKTs8YnI+DQorwqAgwqAgwqAgwqByZXQgPSBob3N0X3N0YWdlMl90cnko
a3ZtX3BndGFibGVfc3RhZ2UyX3NldF9vd25lciwgJmFtcDtob3N0X2t2bS5wZ3QsPGJyPg0KK8Kg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgc3RhcnQsIGVuZCAtIHN0
YXJ0LCAmYW1wO2hvc3RfczJfcG9vbCwgcGt2bV9oeXBfaWQpOzxicj4NCsKgIMKgIMKgIMKgIGh5
cF9zcGluX3VubG9jaygmYW1wO2hvc3Rfa3ZtLmxvY2spOzxicj4NCjxicj4NCsKgIMKgIMKgIMKg
IHJldHVybiByZXQgIT0gLUVBR0FJTiA/IHJldCA6IDA7PGJyPg0KLS0gPGJyPg0KMi4zMi4wLjYw
NS5nOGRjZTlmMjQyMi1nb29nPGJyPg0KPGJyPjwvYmxvY2txdW90ZT48ZGl2Pjxicj48L2Rpdj48
ZGl2PlJldmlld2VkLWJ5OiBBbmRyZXcgV2FsYnJhbiAmbHQ7PGEgaHJlZj0ibWFpbHRvOnF3YW5k
b3JAZ29vZ2xlLmNvbSI+cXdhbmRvckBnb29nbGUuY29tPC9hPiZndDvCoDwvZGl2PjwvZGl2Pjwv
ZGl2Pg0K
--0000000000004e3fad05c9c0fd01--

--0000000000005331c405c9c0fd55
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmgYJKoZIhvcNAQcCoIIPizCCD4cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggz0MIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
NLKLRXC2UkITUqkLDDBMBgNVHSAERTBDMEEGCSsGAQQBoDIBKDA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMIGaBggrBgEFBQcB
AQSBjTCBijA+BggrBgEFBQcwAYYyaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vY2EvZ3NhdGxh
c3Izc21pbWVjYTIwMjAwSAYIKwYBBQUHMAKGPGh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20v
Y2FjZXJ0L2dzYXRsYXNyM3NtaW1lY2EyMDIwLmNydDAfBgNVHSMEGDAWgBR8zApo16LrHixyG9HN
XZVvjfvyYzBGBgNVHR8EPzA9MDugOaA3hjVodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2NhL2dz
YXRsYXNyM3NtaW1lY2EyMDIwLmNybDANBgkqhkiG9w0BAQsFAAOCAQEAJZz81Ay9V97/pdWQKMlY
/Qku3gwyyzEfaZz7QTjClOWkncwBR4WF63koFYe6vpd9RBX1upBOk5vhr9n6mXjmLxLfxWqU/xsq
sIJJDk19oBSQvbt138wyZBe6UYYgQhQ3ZvU/9vTXB9geysqPfJbr27MYJ0ZFrCDlQdW49MksZ1x6
6lozqMEFN/tTBhma7G7hGCHF/4rP3XXH/o4f5ftfL23dA+4F9sPwugH2sjEt7Dn/7eCFhT4Hbf7/
P/Sxi49Xlra8e/bCTotvMPt76LN69+0lcZzcc/oNJJttsCLBqBZ7ABTSiTQaLp4UwTgTYMg7eBqD
oJF2uULm2EfP8cT7HzGCAmowggJmAgEBMGgwVDELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
bFNpZ24gbnYtc2ExKjAoBgNVBAMTIUdsb2JhbFNpZ24gQXRsYXMgUjMgU01JTUUgQ0EgMjAyMAIQ
AdV711V3BM5Q4YSSMDl1STANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgd2mBPeWi
i2avxLSEJch6xY2st54lmTHgqo08pgHcgGwwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwODE3MTMwNjQ0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGXChOQlMaEL+DXneyC3WV07GVJp
t3IaHmop7KzPMnNl16y+5STt/wy4QLTmGmPe626zbl31HkKOtkII8cQ4Q4ezCHjzBlaLa3+yjow4
aJPXp2/ZRvG7hHzlQTlYGilvH0DY9C5fh0BiCht6pGxlpXmMi6BdKxsQDjr0L7lQZHInRJG0k/Fv
9ipx/5LzlqnuhRYGd7W8pHDUYY90C6BPZZVQhGdmDrUTQHgrww/iHbn/3+Bx0pcKFDmgl/PRlTdB
R31QRuqcslmEvK3Wmwpev306u1TbVXBg2BUIGi2zBfzBvqI7u3sw185YXeuSgMUlJNk0yRQ9SP07
IVFJrB/nLz8=
--0000000000005331c405c9c0fd55--

--===============6031177081538323196==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6031177081538323196==--
