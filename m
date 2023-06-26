Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CA415AC4
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 22:34:12 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-bf0ba82473dso5224459276.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687818851; x=1690410851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Vg4hZm9fpFWiBqixG4Q+f/nHkPQNxqem1yZABI6YEs=;
        b=RIhCNi128w53AsG94gTZ/h7xROjZCN90D5HF+zj6H+mf+tA9uJXzK2gwkVi1+EczUw
         oUhB8sO1YNtH/9Jeg4uefzw7BlrESpAnfXFuChHqiBmudCaqmKnQGCYz4sF8vwUzj4Du
         yfiP/vpIVM+R1H5cU9owGm2ns/rcJIl54qr2vnpafOqlUiXF2q+XgNg4sieRH2Gzwk02
         MSWutXvjPQPJ62sgqKkw621yLOwVbZJtCxCdlkhmQASoOzPzi8FhemFVvuZFJHbsLit/
         5aJuEJv8CebqDMZ8NZ0c2wiDtLloVCC6mrxMRzU5FEG5O8VfzrWvv/Y++EOt/hcJWP1q
         BIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687818851; x=1690410851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Vg4hZm9fpFWiBqixG4Q+f/nHkPQNxqem1yZABI6YEs=;
        b=cyzLBTap13w84u+FkuNCFOrj/Rt8MIwCpAAAkTFJ9sdyVQwAinuqhWeD+jmgkLfZIM
         sjdgViuCutv3L8E76XWgqCOLn5Vi6y5pG5MFbXCm08HPVAFDNMLuybqBdkNRp5MThCa+
         ymoz8oMyWECA7aGxpSR9ye/KplBuuTw0fFaeqZMVOF67GhcPsXfAWZCSK0dTpNQK5Tmo
         hjhI/pL8zhoCiTQSpdaHrKy8zTyvY8eRGDo5NoUlpzA3/2XCIP3CKLDOXjN8kSkU//OW
         2nQsyfDf8+xzzvWnVs4GF+LZrmCgpTtR8yxkxJAeESPj4lQqu/s7/EJyBHusWUVHb9pv
         Xwng==
X-Gm-Message-State: AC+VfDyVNdnZJB9+fRzBCWK7ODZsJutKjCtzrM2BfCm4LgzlMLmgYYej
	b27RkERVz9dfpR5koHII8HTcI0yg7Fw=
X-Google-Smtp-Source: ACHHUZ6By2nwy1N4OsGA0iP40C8/7BpgMrb+W8CG/njrH1qS7qUc13yLXXj+AhZqSxHnuO5I0vzWbc1VeaQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e701:0:b0:c00:3434:f639 with SMTP id
 e1-20020a25e701000000b00c003434f639mr4728541ybh.1.1687818851762; Mon, 26 Jun
 2023 15:34:11 -0700 (PDT)
Date: Mon, 26 Jun 2023 15:34:10 -0700
In-Reply-To: <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230623125416.481755-1-thuth@redhat.com> <20230623125416.481755-3-thuth@redhat.com>
 <ZJWrKtnflTrskPkX@google.com> <fc70263c-b7af-d8e0-14f4-4ffcde67aa3e@redhat.com>
Message-ID: <ZJoSYnZGYrAj11RN@google.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] Link with "-z noexecstack" to avoid
 warning from newer versions of ld
From: Sean Christopherson <seanjc@google.com>
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	"Nico =?iso-8859-1?Q?B=F6hr?=" <nrb@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Laurent Vivier <lvivier@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 23, 2023, Thomas Huth wrote:
> On 23/06/2023 16.24, Sean Christopherson wrote:
> > On Fri, Jun 23, 2023, Thomas Huth wrote:
> > > Newer versions of ld (from binutils 2.40) complain on s390x and x86:
> > > 
> > >   ld: warning: s390x/cpu.o: missing .note.GNU-stack section implies
> > >                executable stack
> > >   ld: NOTE: This behaviour is deprecated and will be removed in a
> > >             future version of the linker
> > > 
> > > We can silence these warnings by using "-z noexecstack" for linking
> > > (which should not have any real influence on the kvm-unit-tests since
> > > the information from the ELF header is not used here anyway, so it's
> > > just cosmetics).
> > > 
> > > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > ---
> > >   Makefile | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index 0e5d85a1..20f7137c 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -96,7 +96,7 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
> > >   autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
> > > -LDFLAGS += -nostdlib
> > > +LDFLAGS += -nostdlib -z noexecstack
> > 
> > Drat, the pull request[1] I sent to Paolo yesterday only fixes x86[2].
> 
> Oops, sorry, I did not notice that patch in my overcrowded mailboxes (or
> forgot about it during KVM forum...) :-/

Heh, you gave a Reviewed-by[*], so either its the latter, or you've got a clone
running around :-)

[*] https://lore.kernel.org/all/916aac4f-97b8-70c2-de39-87438eb4aea4@redhat.com

> > Paolo, want me to redo the pull request to drop the x86-specific patch?
> 
> I can also respin my patch on top of your series later ... the problem
> currently also only seems to happen on x86 and s390x, on ppc64 and aarch64,
> the linker does not complain ... so maybe it's even better to do it
> per-architecture only anyway? Opinions?

I don't think it makes sense to do this per-arch, other architectures likely aren't
problematic purely because of linker specific behavior, e.g. see

https://patches.linaro.org/project/binutils/patch/1506025575-1559-1-git-send-email-jim.wilson@linaro.org
