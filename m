Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CFF8BEC
	for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 17:18:45 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id w15so1399883qvs.11
        for <kvmarm@lists.linux.dev>; Tue, 24 Jan 2023 09:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2LfJhFw/HjO85prr/+n24x4Lw1Az/iZVTOQ35U0vJPk=;
        b=YhoP2h9cs4sVzS+YglFxNK6Rcqx0MUi+FwfrQ33wk3UzCGOz8WkUtj2LzXW5IX9yXd
         8mnyP4IRqSQTUvazAsZdKWFmyM8zXk0deXkY5KxAdLc53ki0RzafOvOLvsqsB35/akJk
         uEiGearyMAcRkIKHjuOGK1/mYKxmS5BLD99/vt6s4pPwqc6v/1jgidlCckucMcuEp5gj
         bKfaNcITx+kkfCaGe9FTPZydnUdojwlVP/CrmZdn+nQYyyCOmBDdizYdHn3Xmg96MjU5
         ai/3P/ypTE5JfpVANAk+9XCzAwPwr2KyM8zV6aj6ZhpBDKMlntFz+CkaazfSnXS6vOSX
         BE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2LfJhFw/HjO85prr/+n24x4Lw1Az/iZVTOQ35U0vJPk=;
        b=Yl3HqoNXHdLSZ9EDER0y4tOEGX750xO/HcHI12pDPgy9Yar002dI9Rj1OnA8ODT5O+
         yOlU8ayy1grvaBqICdyIkeViy0wTpMy2RkHvPJ+jDtSu2GaiJqK1iZFmqm9BKpQ2/g/B
         gdvsx1oQde2BO9oXkvbE5S0OvVRam8YxEPrPQEGwrB5Vard2/VsvMhm9RcoPH5MXoM6k
         ykyjd7AIxTRLMRtPY7YLwC3+MN+5b1oVhAyg5ZsnV+Jq271y+nYQXzcwdH+FJQqMgX3J
         RzQRksNMYC/eVUobLviS96LoEfJ8vNi4occukMUZkVkZdC8gQh8tZBJGPE0tgFqrqukU
         oWtg==
X-Gm-Message-State: AFqh2kqP71z5jJ2WqM0UQx12l1FNXjb9jx1Lndf/JLTJrmwa0PUeKATy
	Rw5bPrIfEF2DpbSd1Cp2no49UjEbbcY6dBTLhG88Ow==
X-Google-Smtp-Source: AMrXdXt/fh2hub/gv2zmH5rPavw+lkx8d22y/t4FGs5wmiizn+95CKFFDpttcMeya72+jvskubmaSBZMJYIcUuKB+kE=
X-Received: by 2002:a05:6214:3113:b0:532:2acf:2577 with SMTP id
 ks19-20020a056214311300b005322acf2577mr1237633qvb.5.1674580724279; Tue, 24
 Jan 2023 09:18:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-4-ricarkol@google.com>
 <CANgfPd_PgrZ_4oRDT3ZaqX=3jboD=2qEUKefp4TsKM36p187gw@mail.gmail.com>
 <Y9ALgtnd+h9ivn90@google.com> <Y9ARN5hWlAYVFBoK@google.com>
In-Reply-To: <Y9ARN5hWlAYVFBoK@google.com>
From: Ricardo Koller <ricarkol@google.com>
Date: Tue, 24 Jan 2023 09:18:33 -0800
Message-ID: <CAOHnOrxGu2sU2+-M8+-nMiRc01BQvRug+S2rnBbK6HiCP_BMVw@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: Add kvm_pgtable_stage2_split()
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ben Gardon <bgardon@google.com>, pbonzini@redhat.com, maz@kernel.org, 
	yuzenghui@huawei.com, dmatlack@google.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 9:11 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> On Tue, Jan 24, 2023 at 08:46:58AM -0800, Ricardo Koller wrote:
> > On Mon, Jan 23, 2023 at 05:03:23PM -0800, Ben Gardon wrote:
>
> [...]
>
> > > Would it be accurate to say:
> > > /* No huge pages can exist at the root level, so there's nothing to
> > > split here. */
> > >
> > > I think of "last level" as the lowest/leaf/4k level but
> > > KVM_PGTABLE_MAX_LEVELS - 1 is 3?
> >
> > Right, this is the 4k level.
> >
> > > Does ARM do the level numbering in
> > > reverse order to x86?
> >
> > Yes, it does. Interesting, x86 does
> >
> >       iter->level--;
> >
> > while arm does:
> >
> >       ret = __kvm_pgtable_walk(data, mm_ops, childp, level + 1);
> >
> > I don't think this numbering scheme is encoded anywhere in the PTEs, so
> > either architecture could use the other.
>
> The numbering we use in the page table walkers is deliberate, as it
> directly matches the Arm ARM. While we can certainly use either scheme
> I'd prefer we keep aligned with the architecture.

hehe, I was actually subtly suggesting our x86 friends to change their side.

>
> --
> Thanks,
> Oliver
