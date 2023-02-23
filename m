Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB8C7E
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 18:35:10 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id o6so17337258vsq.10
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 10:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R3aoaYb7nna45J2CiXmr0/OoCloNPGdL3kFyB1h4mtg=;
        b=jCj+dZoFxxzUaMPmvj5JpARz5KC7OAzmfEjBubRdgSgpZo0gPgbIIaMDk8TdKd6ac2
         1u/B51AGOkz6IDZyF96vCHj9MWL4W8T8cCEfO1KDEv652fn8V5t294GBY+/Y9lJyetLN
         GAnxFpn2GsWeExejnqMX0i/qSBTWbgzLOY47ucp3r/0Q7IWIyGfs+oyPY6FmIEHthFxp
         x1V6a3CHzQXzc/AiUlVpspoHDTQ52AKGsA7RaEhRwMTWU5QbHFFJAg1qM6/m/E8iGAA4
         zRRqE9AWRBrMW/CVP69peHcgoVq+PjLM4Q2whQa/QhbAIhXI5S9sJDYuZ0HNey8baXK5
         PyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R3aoaYb7nna45J2CiXmr0/OoCloNPGdL3kFyB1h4mtg=;
        b=PUeiuiXLrp4E1OeUNEqXFNR29JBt3ooXV0f7GZDjMACt9xzIvmdMxjVuSSpURj4tdy
         fPZ//69rit/TFjOc6DbN2B5EBwz65/C+2nmeSaXCciw1bEvqJ/YD2Ee6yfOSF3RZf6Jg
         6z65DWAEzC9HLGJmT/7LHQFKR6CZoT3pvgU75Snp0mrYdi2x5F1u5BD2BShVdg4Ew3KK
         MAkhtafegq1rdqHQjIwu7X4XnEoEB82lNfxlSqz/bsIaL3HPJTpE+S+WA6gIVSFmYwRv
         2IPu0u49TCqLDka9nHu8iOAXtYnnmStLATKAWF6t0pQe8DzCoWs7AGrYaROoevXGPJoZ
         nwWw==
X-Gm-Message-State: AO0yUKWE129UUsMQRiLoWOOD9c2Z2PWMicBQLEWKncfDnvmkMh2dUECC
	/FBEdRmHf1l79h02KPoynqshpLD5NNp0LfcIFWVNdQ==
X-Google-Smtp-Source: AK7set8MziVNDnEwhirxCtSzQkzlR2xXTlIFkFvt+M2EKaxLcFqsJW8+RDdsr+GQsS2XXD8mHYrFd1HoPptf+lvr4nU=
X-Received: by 2002:a67:fdc8:0:b0:402:9ba2:bc62 with SMTP id
 l8-20020a67fdc8000000b004029ba2bc62mr510076vsq.6.1677177309518; Thu, 23 Feb
 2023 10:35:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com> <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
 <Y/ed0XYAPx+7pukA@google.com> <CAOUHufYw9Mc-w1E-Jkqnt869bVJ0AxOB5_grSEMcdMdDODDdCw@mail.gmail.com>
 <Y/evPJg9gvXxO1hs@google.com>
In-Reply-To: <Y/evPJg9gvXxO1hs@google.com>
From: Yu Zhao <yuzhao@google.com>
Date: Thu, 23 Feb 2023 11:34:31 -0700
Message-ID: <CAOUHufYx8JUT0T11jxuqknHzUHOYm7kLm_JfgP3LmRrFe=E20Q@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org, linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 11:24=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Feb 23, 2023, Yu Zhao wrote:
> > On Thu, Feb 23, 2023 at 10:09=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > I'll take a look at that series. clear_bit() probably won't cause a=
ny
> > > > practical damage but is technically wrong because, for example, it =
can
> > > > end up clearing the A-bit in a non-leaf PMD. (cmpxchg will just fai=
l
> > > > in this case, obviously.)
> > >
> > > Eh, not really.  By that argument, clearing an A-bit in a huge PTE is=
 also technically
> > > wrong because the target gfn may or may not have been accessed.
> >
> > Sorry, I don't understand. You mean clear_bit() on a huge PTE is
> > technically wrong? Yes, that's what I mean. (cmpxchg() on a huge PTE
> > is not.)
> >
> > > The only way for
> > > KVM to clear a A-bit in a non-leaf entry is if the entry _was_ a huge=
 PTE, but was
> > > replaced between the "is leaf" and the clear_bit().
> >
> > I think there is a misunderstanding here. Let me be more specific:
> > 1. Clearing the A-bit in a non-leaf entry is technically wrong because
> > that's not our intention.
> > 2. When we try to clear_bit() on a leaf PMD, it can at the same time
> > become a non-leaf PMD, which causes 1) above, and therefore is
> > technically wrong.
> > 3. I don't think 2) could do any real harm, so no practically no proble=
m.
> > 4. cmpxchg() can avoid 2).
> >
> > Does this make sense?
>
> I understand what you're saying, but clearing an A-bit on a non-leaf PMD =
that
> _just_ got converted from a leaf PMD is "wrong" if and only if the intent=
ed
> behavior is nonsensical.

Sorry, let me rephrase:
1. Clearing the A-bit in a non-leaf entry is technically wrong because
we didn't make sure there is the A-bit there --  the bit we are
clearing can be something else. (Yes, we know it's not, but we didn't
define this behavior, e.g., a macro to designate that bit for non-leaf
entries. Also I didn't check the spec -- does EPT actually support the
A-bit in non-leaf entries? My guess is that NPT does.)
