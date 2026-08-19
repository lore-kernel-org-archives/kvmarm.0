Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA0118E02A
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139158; cv=none; b=WCETK/xeWE0mUhv0oIQCC/JesS64ojzWjcyJnJ3buBAvw2q7/syelbMH8T3LSf+QfunYENo+mos+ZS+E/mA6WkP7Oq7auiZAEuaNTby9hX48cWAzzieaWht4JL9ts8PY8jOEkq4M34zaMzaiNrEY2ZlxM/pGqaNSslAQkqpdE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139158; c=relaxed/simple;
	bh=7kuSuoJJdc3sOBEd27Sm92Ikju28wiXHnOLulfVVU6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R7YRNwBfw1cdI0AHkj6ZePh5vkFTBjAN0ASvVdo24fasWMvBQkdem+w8n9N12cdwLKsgUPleR7ncoG/JNvIkWSLoZ9mdtOLylOU8t+F2dGsOyRzin8X04TQ3vGAh2oN+erj4NM9ai1VmjxfKwDfXRf+ZGByxgaXWuSY73yZysrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o0E3kZqm; arc=none smtp.client-ip=95.215.58.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o0E3kZqm"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=7kuSuoJJdc3sOBEd27Sm92Ikju28wiXHnOLulfVVU6Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787139154; v=1; x=1787743954;
 b=o0E3kZqmDvsYI+o8JDeHvy8jWw1vwTlT/i8k1jKv3D9zcK6cfdKJM7p6VD0BdsjxiFrInWeS
 TiC8mPYMQeSwWQUTtS5YtPaPZvpictl0zkSfaS6YLRNcIXNnq7SlkCREqyG5Bf/1W671ciA4s6a
 K2axlhvoZFq/LqA+pvgLuyOc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f50.google.com (209.85.167.50)
	by smtp.migadu.com with ESMTPS id c7ef60e51b9a17f9;
	Wed, 19 Aug 2026 11:32:34 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so5913e87.1
        for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 04:32:30 -0700 (PDT)
X-Gm-Message-State: AOJu0YwgR+eIuJblZlJzeRqXLxA4MkeLF/ZVZxBeCtV0i+zrDVBculds
	VIf4GU9BAPlxe2WzfhCwi5BU5QXTBdaTSjFAafcJVbUOG1BxBJ9kPnqCyQ+Xfs3oVfWXRh+kmlE
	5zMEftK8IeCL/2FUi2GZpsfjtpLdusT1QtjsyOFiy
X-Received: by 2002:a05:6512:3ba5:b0:5ae:b918:79d5 with SMTP id
 2adb3069b0e04-5b47889a5e6mr132588e87.2.1787139149438; Wed, 19 Aug 2026
 04:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260819102809.310708-1-fuad.tabba@linux.dev> <20260819102809.310708-5-fuad.tabba@linux.dev>
 <20260819103933.C86671F00A3A@smtp.kernel.org>
In-Reply-To: <20260819103933.C86671F00A3A@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 19 Aug 2026 12:31:53 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyiRadkDPLt5--zuHySw6=OCZiT4MX_7AwnM5YAe2MUyA@mail.gmail.com>
X-Gm-Features: AcwNN1UAcvP9sDAr8oUrNxlSM1dVpeAVtWPR-2YrrRRiWzlLHdDZ4SeD65PK180
Message-ID: <CA+EHjTyiRadkDPLt5--zuHySw6=OCZiT4MX_7AwnM5YAe2MUyA@mail.gmail.com>
Subject: Re: [PATCH 4/4] KVM: arm64: selftests: Add ITS table save tests
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Aug 2026 at 11:39, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Medium] The guest code writes L1 device table entries using native end=
ianness instead of little-endian, which will cause corrupted data on big-en=
dian guests.

arm64 big-endian has depended on BROKEN since 6.18, and is being
removed [1], so this is fine for a selftest.

> - [Medium] The guest code modifies GITS_BASER immediately after clearing =
GITS_CTLR.Enable without polling for the GITS_CTLR.Quiescent bit.

KVM's emulated ITS permits the GITS_BASER write whenever
GITS_CTLR.Enable is clear, so the poll is not needed here.

/fuad

[1] https://lore.kernel.org/all/20260811140132.22778-1-will@kernel.org/


> --
>
> --- Patch [4]: [PATCH 4/4] KVM: arm64: selftests: Add ITS table save test=
s ---
> commit 277abfaff8f849d670b2c74f45ab3607f657788b
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: selftests: Add ITS table save tests
>
> This commit adds selftests for KVM_DEV_ARM_ITS_SAVE_TABLES to handle two
> cases where a guest leaves a table in a modified state. It covers a
> GITS_BASER write that drops described collections, and an invalidated L2
> block that causes a device to be skipped.
>
> > diff --git a/tools/testing/selftests/kvm/arm64/vgic_its_save.c b/tools/=
testing/selftests/kvm/arm64/vgic_its_save.c
> > new file mode 100644
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/arm64/vgic_its_save.c
>
> [ ... ]
>
> > +static void guest_shrink_coll_table(void)
> > +{
> > +     unsigned long offset =3D its_baser_offset(GITS_BASER_TYPE_COLLECT=
ION);
> > +     u64 baser;
> > +
> > +     its_set_enable(false);
> > +
> > +     baser =3D readq_relaxed(GITS_BASE_GVA + offset);
>
> [Severity: Medium]
> Is it architecturally valid to read and modify GITS_BASER immediately aft=
er
> clearing GITS_CTLR_ENABLE without first polling for the GITS_CTLR.Quiesce=
nt
> bit?
>
> While KVM's synchronous implementation might tolerate this sequence today=
,
> could this missing poll cause unpredictability on asynchronous hardware o=
r
> future emulators?
>
> > +     baser &=3D ~GITS_BASER_PAGES_MASK;
> > +     writeq_relaxed(baser, GITS_BASE_GVA + offset);
> > +}
>
> [ ... ]
>
> > +/* Turn the already installed device table into an indirect one. */
> > +static void guest_make_device_table_indirect(void)
> > +{
> > +     unsigned long offset =3D its_baser_offset(GITS_BASER_TYPE_DEVICE)=
;
> > +     u64 baser;
> > +
> > +     its_set_enable(false);
> > +
> > +     baser =3D readq_relaxed(GITS_BASE_GVA + offset);
>
> [Severity: Medium]
> Similarly here in guest_make_device_table_indirect(), does this need a
> poll for the Quiescent bit after disabling the ITS and before accessing
> GITS_BASER?
>
> > +     writeq_relaxed(baser | GITS_BASER_INDIRECT, GITS_BASE_GVA + offse=
t);
> > +
> > +     its_set_enable(true);
> > +}
> > +
> > +static void guest_unreachable_device(void)
> > +{
> > +     u64 *l1;
>
> [ ... ]
>
> > +     guest_make_device_table_indirect();
> > +
> > +     /* Both L2 blocks present, so both MAPDs are in range. */
> > +     l1 =3D test_data.device_l1_va;
> > +     l1[0] =3D L1E_VALID_MASK | (test_data.device_l2[0] & L1E_ADDR_MAS=
K);
> > +     l1[1] =3D L1E_VALID_MASK | (test_data.device_l2[1] & L1E_ADDR_MAS=
K);
>
> [Severity: Medium]
> Since the host code later reads this memory using le64toh(), will writing
> these L1 device table entries in native endianness cause data corruption
> when running the selftest on big-endian guests?
>
> Should these entries be converted using cpu_to_le64() before assignment?
>
> > +
> > +     its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_A_ID,
> > +                       test_data.itt_tables, ITT_MAPD_SIZE, true);
> > +     its_send_mapd_cmd(test_data.cmdq_base_va, DEVICE_B_ID,
> > +                       test_data.itt_tables + ITT_SZ, ITT_MAPD_SIZE, t=
rue);
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819102809.31=
0708-1-fuad.tabba@linux.dev?part=3D4
>
