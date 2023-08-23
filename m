Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7CB1F17F
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 23:38:50 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-48d11f47ee6so1395481e0c.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 16:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692833930; x=1693438730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZO+KG5SZiqTJzrTe4qbDf++hcu2xNBSHjZPSg9a/xEU=;
        b=6D+mHd3IWBZKLdtdzYNiMB6DOZFCi7JVeFDt/lv3fYYQymcqj8phGrx+ok2GI0EFP6
         cFv+lQF7btCFFf36r062ahQEDaD2gN8P0Zr/PeE10lOYsrlhAMWiBin6pMvNM/N61rnf
         cOxB/2IbI5gQOPsnOZ9KQxi1Ws4YTiU8GUL2gU6eqrGr09m5p8psQ50V5NBPpENSVVtL
         UStcfj/IBcusR1NfFsAVC0RAem7W7Ex/bQ6+v55ywOohE7KRXA933vEfW2fmt7lNQf8u
         X6nI+7RSZpmeMn7EVBSKO9T+tg3KEZhOWkDG7LtHV8O+thUnM0hyHoqZ/AYZCf32FPRm
         vN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692833930; x=1693438730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZO+KG5SZiqTJzrTe4qbDf++hcu2xNBSHjZPSg9a/xEU=;
        b=gXZvTZ5liQ+WsXrjzTZ2ebi3R/tYHWUbcaVnhXPoEhbemla/NzqA0GPFaOWUh1cLew
         C3x5KGreCy5unwtqrqKGpi70NzDd3u5PYkE420Vy+Y8pi86pQncqPj79gsgwVp0zzeAQ
         L8bD8zGbZhM6x5wGN9CQFN5U971kcFm5s9kJH3fPA1wjI9JgYin4J3ex5bDnLTpelrK9
         bNZ44OjKnWrH6XkURG0p0UAvZnm60Gtb9zaVFRE5sYib+T4zuoa4HZ7YLT7Zj+9uxwsp
         fjeswMmy0y/41nuwMb1ODZ0jVDN0Z0stZNVkdTiwqTzopJMlfCGfyrJ1TDywM0WNKpUU
         tUgg==
X-Gm-Message-State: AOJu0Ywx7oC0DNdw5F7h8NABRs5RpKhtWg0SBC8HTbOz0tz8GSsCHdg+
	KqkZhXE5d8tpalVLVuIukY7yM4P6z9sVaSADAuTSFg==
X-Google-Smtp-Source: AGHT+IF4vsULjLW/zRCh3C4yJKU8FcP6P7QTILApdW/ZpmC/o073sGFstB8anaNRyNqf/nv2pnGJr9AWsWpdMgY+/FI=
X-Received: by 2002:a1f:e3c3:0:b0:48c:fdfe:aa41 with SMTP id
 a186-20020a1fe3c3000000b0048cfdfeaa41mr12395044vkh.0.1692833929618; Wed, 23
 Aug 2023 16:38:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZIn6VQSebTRN1jtX@google.com> <CAF7b7mqfkLYtWBJ=u0MK7hhARHrahQXHza9VnaughyNz5_tNug@mail.gmail.com>
 <ZNpsCngiSjISMG5j@google.com> <CAF7b7mo0gGGhv9dSFV70md1fNqMvPCfZ05VawPOB=xFkaax8AA@mail.gmail.com>
 <ZNrKNs8IjkUWOatn@google.com> <CAF7b7mp=bDBpaN+NHoSmL-+JUdShGfippRKdxr9LW0nNUhtpWA@mail.gmail.com>
 <ZNzyHqLKQu9bMT8M@google.com> <CAF7b7mpOAJ5MO0F4EPMvb9nsgmjBCASo-6=rMC3kUbFPAh4Vfg@mail.gmail.com>
 <ZN60KPh2uzSo8W4I@google.com> <CAF7b7mo3WDWQDoRX=bQUy-bnm7_3+UMaQX9DKeRxAZ+opQCZiw@mail.gmail.com>
 <ZOaGF6pE5xk7C1It@google.com>
In-Reply-To: <ZOaGF6pE5xk7C1It@google.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 23 Aug 2023 16:38:13 -0700
Message-ID: <CAF7b7mpPcbxLKhPvLwVg4mwSbXRQ-zRhz8Osj-CVqhMnG6NRkw@mail.gmail.com>
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
To: Sean Christopherson <seanjc@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, bgardon@google.com, dmatlack@google.com, 
	ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2023 at 3:20=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> I don't anticipate anything beyond the memory fault case.  We essentially=
 already
> treat incomplete exits to userspace as KVM bugs.   MMIO is the only other=
 case I
> can think of where KVM doesn't complete an exit to usersapce, but that on=
e is
> essentially getting grandfathered in because of x86's flawed MMIO handlin=
g.
> Userspace memory faults also get grandfathered in because of paravirt ABI=
s, i.e.
> KVM is effectively required to ignore some faults due to external forces.

Well that's good to hear. Are you sure that we don't want to add even
just a dedicated u8 to indicate the speculative exit reason though?
I'm just thinking that the different structs in speculative_exit will
be mutually exclusive, whereas flags/bitfields usually indicate
non-mutually exclusive conditions.
