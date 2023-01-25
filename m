Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EA033F0
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 14:17:13 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id b6so13462984pgi.7
        for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 06:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ReVu+PCJ9uQlg1KFmeKSSoqjffPWvxnjud26226RPUY=;
        b=Gh8M3v5k6vXk2RSjppLMe5XCwjVnLXy0HtEDSA7jZPbSalQNCvggk5+LhpuDExEIkz
         sYZro5sKMmqoL4gSzvnVuQ2n1G7UyDUEGCPkupuJewluCCwEbHPeiC8JkX3npGCGJJUg
         PbmB1MWAi8fKqLf0WCvj6sk4HpTJn1NMlax5AbUNuGT3+eAGHX56ZZTYUbzPQNs7jYif
         9wWRLo5ZUQaqE2dXeOOvzPu8oZdYJjn0aox1MqBdfaDaD4yiAYlOowlSn5juGPv/jkO8
         SqgVxJm/fO3pUxmJaYk/dgyP+o+JrWnYJgTg0wD7LZsGsGIZBUZ213DKAkg94md7qSPH
         cHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ReVu+PCJ9uQlg1KFmeKSSoqjffPWvxnjud26226RPUY=;
        b=AGZ0uImn5mFOz0XP7mhR4ylv7yPBw4jmKa9lZGi1h4UOsr3S7BhJn75POejYoZ/nLY
         67ZA8idWjUzle+iHIMur4NpPaq/Nshq8glHdXImt5VFsol/iwa51S+900NTVnz71BAGt
         hq6wrX6/2C90ZYrkeoY4DfgUFR2X7PrUVzk4TGDYmRFYhBx9Yrx88tuZa56tKO1Wv1X0
         aMIZc7FFcZVUh1Bh1eaFrVOUFX7PtA2Ng7otku9MHsU7ZR4I0mMEh53AYUdQVCKyuT5G
         sauqs51AxS+hXsLW9U754t/YKJrMJlIgQP9MwBX6ALf7Sd8Q3CCXObxK00cjKBmmIbJT
         AW0w==
X-Gm-Message-State: AO0yUKXsx3FfxXfDQAy7cFeoaSkzukqGKoTWYb4r/D5AzmGgVX4miR06
	GBMtNZ7VOGQVkpjQRnfXNsA8xg==
X-Google-Smtp-Source: AK7set/7+CxnNLwdtSUfIvLtR83xajY7Nn9O4wzHZvSigazZuAvJSODKrHXtx0pV/2V5NDrnnbmbEw==
X-Received: by 2002:a05:6a00:23cb:b0:581:bfac:7a52 with SMTP id g11-20020a056a0023cb00b00581bfac7a52mr725774pfc.1.1674656233189;
        Wed, 25 Jan 2023 06:17:13 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id z28-20020a056a001d9c00b00580cc63dce8sm799363pfw.77.2023.01.25.06.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:17:12 -0800 (PST)
Date: Wed, 25 Jan 2023 06:17:09 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Reiji Watanabe <reijiw@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
	alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y9E55cTs+iAK31ns@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
 <Y9CRxb2YvPtX340D@google.com>
 <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
 <12974616-10ac-e44b-7bd2-0db68fb63eb5@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12974616-10ac-e44b-7bd2-0db68fb63eb5@redhat.com>

On Wed, Jan 25, 2023 at 08:55:50AM +0100, Eric Auger wrote:
> Hi,
> 
> On 1/25/23 05:11, Reiji Watanabe wrote:
> > On Tue, Jan 24, 2023 at 6:19 PM Ricardo Koller <ricarkol@google.com> wrote:
> >> On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
> >>> Hi Ricardo,
> >>>
> >>> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> >>>> @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >>>>
> >>>>         pmu_reset_stats();
> >>> This isn't directly related to the patch.
> >>> But, as bits of pmovsclr_el0 are already set (although interrupts
> >>> are disabled), I would think it's good to clear pmovsclr_el0 here.
> >>>
> >>> Thank you,
> >>> Reiji
> >>>
> >> There's no need in this case as there's this immediately before the
> >> pmu_reset_stats();
> >>
> >>         report(expect_interrupts(0), "no overflow interrupt after counting");
> >>
> >> so pmovsclr_el0 should be clear.
> > In my understanding, it means that no overflow *interrupt* was reported,
> > as the interrupt is not enabled yet (pmintenset_el1 is not set).
> > But, (as far as I checked the test case,) the both counters should be
> > overflowing here. So, pmovsclr_el0 must be 0x3.
> 
> I would tend to agree with Reiji.  The PMOVSSET_EL0<idx> will impact the
> next test according to aarch64/debug/pmu/AArch64.CheckForPMUOverflow and
> I think the overflow reg should be reset.

Ahh, right. The overflow interrupt could fire as soon as they are
enabled again. OK, will add a fix in the next version.

> 
> Eric
> >
> > Or am I misunderstanding something?
> >
> > Thank you,
> > Reiji
> >
> >
> >>>> -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >>>> -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> >>>> +       write_regn_el0(pmevcntr, 0, pre_overflow);
> >>>> +       write_regn_el0(pmevcntr, 1, pre_overflow);
> >>>>         write_sysreg(ALL_SET, pmintenset_el1);
> >>>>         isb();
> >>>>
> 
