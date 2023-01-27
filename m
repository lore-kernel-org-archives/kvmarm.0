Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE8D5234
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 23:38:37 +0000 (UTC)
Received: by mail-qk1-f181.google.com with SMTP id f23so3054522qkg.1
        for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 15:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r3p/T/C5LEjZklM/3McjmH+nwXiuvZ9AZNDnHBso/wI=;
        b=LvPpqflUiyzNIOBtF7ovVHDoam5nkOWs7FwK65q1MQ6uvVWAF23RlNqpLDYoyvsLtc
         SSfyr0GPJ7bFYVrOik+cQjyeO6GED86cC4GDj+OPpjKACcpLC5DsJBghDxZ1eaGEnJM4
         ud53ek8zV1JEZILhRxrYxQEkj9eDxo+6MWhkTzLWIwSj2MNMUJQzZbgqLWYJZ0i3e6Hh
         XyCDym/pvD2zhV4Kyv1RqgfCrZWDIP6wPGcofH3xEocTAoV721FxGal/pY+6IVSFEnau
         2CWs7CA9zSsGY/Rvo+4sVwIOvGArveMa86D6S1fYg09sAmW3NlPmEXS9Yson/kL3GUHi
         xPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r3p/T/C5LEjZklM/3McjmH+nwXiuvZ9AZNDnHBso/wI=;
        b=t/vaBIG8gikXzHiX37UZ+3vdbJ4syQKZz7AugfOLCh0Q9u82tVnaO+PaCQ7wDU45V1
         30nJQjU4q+AmO+Z6svttBoM4k4R3B1/G5uIfEWFoUYw+ok6IkJb/aluxPP1bfUvym2Jr
         KpYxo8hljQtz+oOrPIHlA6rmoAfJIBgdVrorqTOHxTH+oITTAA/1P9IljA7Jyd6jDyjE
         8LUkZxX065xE2HgAbkuCjf9t6Hb91xHZOSQHFjkwajCH12q4L2gJ6fdNsT2/Ksbkvd7b
         F7H2+vWz/gBK72xe0aJYQqNBRhc0GuRWMRDheExCNbtaIYHZffI5GHRWZhb6s74icCDo
         TWkQ==
X-Gm-Message-State: AO0yUKVA/sfSRBzEU8x+yp2FRq1hI4FqQ1vS2OIvfWJvqSa1NMtNiEGs
	AyERf6fIKPm/jjFt+Lyx1rGTvbpLF4EX5l2VH7SITQ==
X-Google-Smtp-Source: AK7set9MfTU7CQFxRLAhgQucoy0y3vpnRRQ9+J1NriTODEPbSGW1cQOL8vN3HkxIljjuJtsgbKngsx0hXiWyABVodmw=
X-Received: by 2002:a05:620a:1426:b0:71b:8e29:18fb with SMTP id
 k6-20020a05620a142600b0071b8e2918fbmr424qkj.230.1674862716796; Fri, 27 Jan
 2023 15:38:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230127214353.245671-1-ricarkol@google.com> <20230127214353.245671-5-ricarkol@google.com>
 <Y9RXfxCiKGZNNV3h@google.com>
In-Reply-To: <Y9RXfxCiKGZNNV3h@google.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Fri, 27 Jan 2023 15:38:25 -0800
Message-ID: <CAOHnOrwGbLfS_w_R79-bSUDyARnNKiU5r6afC7sQf_mYtAjdLQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: selftests: aarch64: Test read-only PT memory regions
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 27, 2023 at 3:00 PM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hi Ricardo,
>
> On Fri, Jan 27, 2023 at 09:43:53PM +0000, Ricardo Koller wrote:
> > Extend the read-only memslot tests in page_fault_test to test
> > read-only PT (Page table) memslots. Note that this was not allowed
> > before commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO
> > memslots") as all S1PTW faults were treated as writes which resulted
> > in an (unrecoverable) exception inside the guest.
>
> More of a style nit going forward (don't bother respinning):
>
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../selftests/kvm/aarch64/page_fault_test.c    | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > index 2e2178a7d0d8..54680dc5887f 100644
> > --- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > @@ -829,8 +829,9 @@ static void help(char *name)
> >
> >  #define TEST_RO_MEMSLOT(_access, _mmio_handler, _mmio_exits)                 \
> >  {                                                                            \
> > -     .name                   = SCAT3(ro_memslot, _access, _with_af),         \
> > +     .name                   = SCAT2(ro_memslot, _access),                   \
>
> You should explicitly call out these sort of drive-by/opportunistic
> changes in the commit message as being just that reviewers don't get
> lost figuring out how it relates to the functional change of this
> patch.

Ah, sorry for that. Forgot about mentioning this in the commit message.

Ricardo

>
> --
> Thanks,
> Oliver
