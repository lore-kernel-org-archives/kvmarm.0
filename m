Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D99C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jan 2022 01:10:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38C0D49F17;
	Thu, 13 Jan 2022 20:10:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e0Lbh9DkEvNB; Thu, 13 Jan 2022 20:10:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AA8A49EF6;
	Thu, 13 Jan 2022 20:10:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B598249EED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 20:10:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 25VqRYw1ZNMD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jan 2022 20:10:08 -0500 (EST)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D1F349EE9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 20:10:08 -0500 (EST)
Received: by mail-pj1-f54.google.com with SMTP id
 l10-20020a17090a384a00b001b22190e075so20502381pjf.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jan 2022 17:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dfHTMu5yyfREc50x2Kq3TV4XK0N3u2/ilz/wJ1H6bEc=;
 b=Qp0L93h2Bp9PLGVaYi0WSJZdkp402RO5l/aQCpgeknH84r7jXsj7pSuEYA955i7rn1
 W/p3e5Om59luBvf1WCuy9aMCOrdXM0d9zK5q9FPAIBUu+YPOluPJPYYDgGJHTgZdtQpc
 nUerIZBF1IuHj8vPAaqSwkIRpzapyybW2OQchtN+j/XvAyejjbCFcFTsNN3peB96A/cW
 U3rxmnuP7tXIc4sW/2zfK+HG8geZbnDbbhy93s2AOQI02kxI7/1FPXmzht3IuvE5V4jZ
 2AaVVp/32HkacH3MCRJUeaGvlUbX2c5ey2lnicXWxn/xg22G9auoTekB9x32FSWgUC01
 MK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dfHTMu5yyfREc50x2Kq3TV4XK0N3u2/ilz/wJ1H6bEc=;
 b=DQvck7npnNGJADfZy48PaSFXsYRm0YGt124betsVZ+Sbb+/Dwa1HQsYMRGyiFNTcU+
 YoILgixMEI1mE8LfnpbO8UGFBljI7+nvHeU21dM+ZMW6ndsRyIniJOT19m3o+hamDYWq
 yXbJG1NyvSus+GeN//mmtMzFKc0UMNDrpnz02vd++ok2Cqcu/cuoKT+h3ZL/3kG4c9/q
 XXQKHpuoMATDFb31Ugc3LR4E1UU6PRW5Xy96vmOmEFqhZDdmUGVjhfAlal8hrHIe4bmw
 pt98ka1sNL4msjvOTNMxLquLiq5KYXUeM2MasZuir9m+AuoUmfGH1S3XEzf7uaqKykL+
 wTYw==
X-Gm-Message-State: AOAM530LeWDMx6tDpRs7KNA7ZY9vzDopz0Sl0Mn9TpRJ0flIxFf8X5Rj
 VDoZ90co3tqKp/t7Mo32pbaCsg==
X-Google-Smtp-Source: ABdhPJwJPF9HsoPu5KG5130tnrH/ZAmOSjZe/Jj2K4WwUe35vcCRE5fNeuBHwGHXHuwdjfoMvZZibA==
X-Received: by 2002:a17:902:76c2:b0:149:7fa3:2ace with SMTP id
 j2-20020a17090276c200b001497fa32acemr7109949plt.64.1642122607394; 
 Thu, 13 Jan 2022 17:10:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id y64sm3134915pgy.12.2022.01.13.17.10.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 13 Jan 2022 17:10:06 -0800 (PST)
Date: Fri, 14 Jan 2022 01:10:03 +0000
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <YeDNa+/rF0YEVJAi@google.com>
References: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com>
 <CAJHc60wRrgnvwqPWdXdvoqT0V9isXW5xH=btgdjPWQkqVW31Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJHc60wRrgnvwqPWdXdvoqT0V9isXW5xH=btgdjPWQkqVW31Pw@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Jan 13, 2022, Raghavendra Rao Ananta wrote:
> On Thu, Jan 13, 2022 at 9:21 AM Sean Christopherson <seanjc@google.com> wrote:
> > If restricting updates in the arm64 is necessary to ensure KVM provides sane
> > behavior, then it could be justified.  But if it's purely a sanity check on
> > behalf of the guest, then it's not justified.
> Agreed that KVM doesn't really safeguard the guests, but just curious,
> is there really a downside in adding this thin layer of safety check?

It's more stuff that KVM has to maintain, creates an ABI that KVM must adhere to,
potentially creates inconsistencies in KVM, and prevents using KVM to intentionally
do stupid things to test scenarios that are "impossible".  And we also try to avoid
defining arbitrary CPU behavior in KVM (that may not be the case here).

> On the bright side, the guests would be safe, and it could save the
> developers some time in hunting down the bugs in this path, no?

Yes, but that can be said for lots and lots of things.  This is both a slippery
slope argument and the inconsistency argument above, e.g. if KVM actively prevents
userspace from doing X, why doesn't KVM prevent userspace from doing Y?  Having a
decently defined rule for these types of things, e.g. protect KVM/kernel and adhere
to the architecture but otherwise let userspace do whatever, avoids spending too
much time arguing over what KVM should/shouldn't allow, or wondering why on earth
KVM does XYZ, at least in theory :-)

There are certainly times where KVM could have saved userspace some pain, but
overall I do think KVM is better off staying out of the way when possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
