Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A486FB7
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 19:58:21 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id l10-20020a17090270ca00b0019caa6e6bd1so2564017plt.2
        for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 11:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lATDuswOZbF3zLZuGn25g5w5EeOK39dFmfATzQI6x48=;
        b=WjkAmKeEgiP2hEXlbY746mkX3ZhOMGDC4P9c79ltVgkK2cIemHwqXcH6WrYyLHRdQF
         TPDAxjgYxRcgOZ9Cw42YNQatNy0fLX/b4SjlpRmVjocgTwZ+/NHLb7um96NikQlj0ehi
         z61VCGlKVn6yqKg+7X6pk7a0r38wnJVjrHrAZelDuyus9u6bCJc1ucQYnC0gwEUNfBwL
         13s742XTOtNhDMUSovA7LDI9gfjrAbYLiDVYULHMN2GVGPzYnZOpwz34E6zS9Nxlczcd
         dm/+tCl7gL4ogIAyiGwzVItI4JYWQw4a5Yck0h70zIDUUba1T72R6HIZu+LfmJQ/sl0T
         Hf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lATDuswOZbF3zLZuGn25g5w5EeOK39dFmfATzQI6x48=;
        b=6y/6ZWbMYxrPrybl47P40/wxyHtnU8FRhsohm1oIE3wWWu7d+BDWLEkE2y2vtEa/Mw
         DWxb060onaXKZCA850Azp6tSNzkHUjy2lOvB+txoSNI80zqsoZN7+oxL3LuTitlRFAng
         HPlO1aNQxTw1bRuopQI5HO8UPFBwggoF4f9HNrql304sY09R/5n67t5JLROb1j6yntXJ
         zqet8sbk8mHAk+5xu9j2bwx58L+azlrvidtr3faSqiJO4ljw0M0pA2GSX/IgTSOXVdHS
         9r8MjxtF4kp12wNyz0XW507KW+JMzmgRc2vnwdWUk5xRqwHPdXOj+up6GPLDKVqLag+H
         XCNw==
X-Gm-Message-State: AO0yUKVFH7ODYZrETbd/IgeXL6SZ8rP1XiAy/fYTL3xx9115m8h5MbC0
	3u70/CQetm+RnDGP0yyY9lQ/7Ez53qw=
X-Google-Smtp-Source: AK7set/ODb8D8144x2HqvMvJqO9rb7VbrC4eAbsdwQguwGwUJ87CVxuU31/KcwKltggxqLDvzZUouJLJe5k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:1993:0:b0:5a8:bdd2:f99c with SMTP id
 141-20020a621993000000b005a8bdd2f99cmr1974028pfz.1.1677182300738; Thu, 23 Feb
 2023 11:58:20 -0800 (PST)
Date: Thu, 23 Feb 2023 11:58:19 -0800
In-Reply-To: <CAOUHufbwcqx21T=zmvYpnX_Mnd2A0KkPORbtxnJEwKuUKVSPzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-6-yuzhao@google.com>
 <Y/elw7CTvVWt0Js6@google.com> <CAOUHufbAKpv95k6rVedstjD_7JzP0RrbOD652gyZh2vbAjGPOg@mail.gmail.com>
 <Y/e6Z+KIl6sYJoRg@google.com> <CAOUHufbwcqx21T=zmvYpnX_Mnd2A0KkPORbtxnJEwKuUKVSPzA@mail.gmail.com>
Message-ID: <Y/fFWyYPu5Jf0de1@google.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm: multi-gen LRU: use mmu_notifier_test_clear_young()
From: Sean Christopherson <seanjc@google.com>
To: Yu Zhao <yuzhao@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michael Larabel <michael@michaellarabel.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	linux-mm@google.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023, Yu Zhao wrote:
> On Thu, Feb 23, 2023 at 12:11=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> >
> > On Thu, Feb 23, 2023, Yu Zhao wrote:
> > > > As alluded to in patch 1, unless batching the walks even if KVM doe=
s _not_ support
> > > > a lockless walk is somehow _worse_ than using the existing mmu_noti=
fier_clear_flush_young(),
> > > > I think batching the calls should be conditional only on LRU_GEN_SP=
TE_WALK.  Or
> > > > if we want to avoid batching when there are no mmu_notifier listene=
rs, probe
> > > > mmu_notifiers.  But don't call into KVM directly.
> > >
> > > I'm not sure I fully understand. Let's present the problem on the MM
> > > side: assuming KVM supports lockless walks, batching can still be
> > > worse (very unlikely), because GFNs can exhibit no memory locality at
> > > all. So this option allows userspace to disable batching.
> >
> > I'm asking the opposite.  Is there a scenario where batching+lock is wo=
rse than
> > !batching+lock?  If not, then don't make batching depend on lockless wa=
lks.
>=20
> Yes, absolutely. batching+lock means we take/release mmu_lock for
> every single PTE in the entire VA space -- each small batch contains
> 64 PTEs but the entire batch is the whole KVM.

Who is "we"?  I don't see anything in the kernel that triggers walking the =
whole
VMA, e.g. lru_gen_look_around() limits the walk to a single PMD.  I feel li=
ke I'm
missing something...
