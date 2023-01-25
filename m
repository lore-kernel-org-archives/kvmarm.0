Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC08E10E5
	for <kvmarm@lists.linux.dev>; Wed, 25 Jan 2023 02:19:54 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so590546pjb.4
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 18:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sxlIvtDzxqsw9xKk15YZymubLIPz2ce8m4nZ6o2rlno=;
        b=QrISVRH/ok+70p7lcmGUQ3rxG+VIiPRW9lTxKzlScvIb963BD+BQPe13i3qbUkNQnV
         V88oRqKVkl2o3REbPASeDrot+TLJdDuZcPqrC/Q/N/2Mkz+KYK3NrpKawx9zYSuqSh70
         1SjEAjqHMr77AMQo9pw4lWcS0WZfMhfImWP+X8jGenxNl+acf/mowRb1DVECft3DZDu8
         RewTYA7y2SA8Pt5qJZtbc3Ab4wQ0+90+0rEuvLNhmXC39E6eeldUxbqzqgofhaAHtZp3
         Lk+xuxEW+bmrlWLnuf1RGxZ+D9ERcpIJ+52oIa37SN+V1cPxs4wZFb8GY4BBu/40uSqU
         85Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxlIvtDzxqsw9xKk15YZymubLIPz2ce8m4nZ6o2rlno=;
        b=3l3/xQSNtfuTsIycOiT+ruzKBQxGRHg0C8HxBqKWPsXTL24endVXgMD4rbQowSIyQ9
         nQU4b/1wZE+KbwFPjIByHk9XC5EvvFDyeI8W7CXjFzhfkN7dlgIR7dVifg+GKzMCUQ9u
         eExqYBigOUdZveAaiGT604p7mp85YXPM3qxIvo/mi/DbLGDZ50svZ/RcU9Ftp7slQlaM
         +ejiEG8p204dDiz50Lh7dEWs2tZ4M5WQAJTGFp5Tlv4tU/K0j2AKwwHZV1lTfDRVCkCc
         v6UNHerR2Eg3uZBczeVafAQX5CV1A+ovgwyYDxYhbmnvG/e09U/bWMJvQ4FNkAX94BeB
         VaNg==
X-Gm-Message-State: AO0yUKU0lwddDutO4FXsYmj9/S/D1jt+f/FHOgIOdKY4Js9lKPFeNqFJ
	4G1HASY8gJuU1iO/f6Qy+5tJgg==
X-Google-Smtp-Source: AK7set8AKxJM1PHSBKVE6deFS0mz7/47MnLQ9LeR0ToWCL/gcMgJ4IQX8zQF+B+FrRtJTG2JR3Dy1w==
X-Received: by 2002:a17:90b:1955:b0:229:f4e9:75c7 with SMTP id nk21-20020a17090b195500b00229f4e975c7mr482766pjb.0.1674613193803;
        Tue, 24 Jan 2023 18:19:53 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id l11-20020a17090a384b00b00226369149cesm256246pjf.21.2023.01.24.18.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 18:19:53 -0800 (PST)
Date: Tue, 24 Jan 2023 18:19:49 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev,
	maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
	oliver.upton@linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit
 overflows
Message-ID: <Y9CRxb2YvPtX340D@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com>

On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> > @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> >
> >         pmu_reset_stats();
> 
> This isn't directly related to the patch.
> But, as bits of pmovsclr_el0 are already set (although interrupts
> are disabled), I would think it's good to clear pmovsclr_el0 here.
> 
> Thank you,
> Reiji
> 

There's no need in this case as there's this immediately before the
pmu_reset_stats();

	report(expect_interrupts(0), "no overflow interrupt after counting");

so pmovsclr_el0 should be clear.

> 
> >
> > -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > +       write_regn_el0(pmevcntr, 0, pre_overflow);
> > +       write_regn_el0(pmevcntr, 1, pre_overflow);
> >         write_sysreg(ALL_SET, pmintenset_el1);
> >         isb();
> >

