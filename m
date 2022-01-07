Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784A9C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 11:46:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1014D4B105;
	Fri,  7 Jan 2022 06:46:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 83LJv-LDp6yj; Fri,  7 Jan 2022 06:46:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 034D94B139;
	Fri,  7 Jan 2022 06:46:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62DA849E21
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 21:21:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3krpw5Xki1Ld for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Jan 2022 21:21:27 -0500 (EST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com
 [209.85.219.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B4334B24E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Jan 2022 21:21:27 -0500 (EST)
Received: by mail-yb1-f182.google.com with SMTP id p5so5495741ybd.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Jan 2022 18:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=w70wbEdrZB71eZ7G5vu7np2TisVg/QSyUt9QnspenOc=;
 b=PJzY3wgh+mwzx/EdpWDTNd9qDUJSucxLoxDlCP73jyOvxKm+qXxPYA1o+dMHW2MdVO
 XI0G0g0Ml2Gv3hYdGaLawxZiY4/2rPyx4OdBV5vHL5nSb8/AGkvP6ZnU4ZX1nHR70mbl
 z4QtjCr0pgIwTgGF1JP2jZ9quepjPmmKr2sWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=w70wbEdrZB71eZ7G5vu7np2TisVg/QSyUt9QnspenOc=;
 b=dzQUMS/uGTvM51Iut+eNNbuj03lCHCIyoeJPbrWZxp1xW9gEplzxFLXVm04DtcPubm
 zbGEzHXVXGiiN7t9585fDFmA85xU06rEgHpPxAH9kUTCYOCoONxNGTBKgne/QKUSCQWM
 A3N3IV+7TW1aY8NtCucTD0UETRsGMMQZY2FF/2JjOtSZSax8DahwS+5v7d/Dv6jRYZ5N
 MyugYAy8UQVBP/v1z6fwhsFLs61NcBz4IxnCXO+0AeJlaY98orBXJUxA19L20DGv4cZl
 hQkE1GMgc8BnaV3IjcdlN2UpLBPhljZic8ndsbeQDD3lMA9EsTz9gX7kg1Pu6BPD7Zf2
 NAmg==
X-Gm-Message-State: AOAM532F0d4jF5KoDK9wdRgXexnB/FJDcKRGTbLLU8ViwjnYXoCEgxVR
 OhaKBZSlq2ZIz3yNi8LXCnkUjiAadAor7ljcJ7WbeA==
X-Google-Smtp-Source: ABdhPJyuGGdU1B4YPxYw/nS3nAD5s2wMNZ+axp3cZ+2j8IbHcyK/rE3IBGrNqTjmYE1Q7yj1rCOt5p2M1WYW4AGGLcg=
X-Received: by 2002:a25:5ca:: with SMTP id 193mr70981373ybf.406.1641522086754; 
 Thu, 06 Jan 2022 18:21:26 -0800 (PST)
MIME-Version: 1.0
References: <20211129034317.2964790-1-stevensd@google.com>
 <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
 <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
 <YdcpIQgMZJrqswKU@google.com>
In-Reply-To: <YdcpIQgMZJrqswKU@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Fri, 7 Jan 2022 11:21:15 +0900
Message-ID: <CAD=HUj5v37wZ9NuNC4QBDvCGO2SyNG2KAiTc9Jxfg=R7neCuTw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
To: Sean Christopherson <seanjc@google.com>
X-Mailman-Approved-At: Fri, 07 Jan 2022 06:46:27 -0500
Cc: Chia-I Wu <olv@chromium.org>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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

> > These are the type of pages which KVM is currently rejecting. Is this
> > something that KVM can support?
>
> I'm not opposed to it.  My complaint is that this series is incomplete in that it
> allows mapping the memory into the guest, but doesn't support accessing the memory
> from KVM itself.  That means for things to work properly, KVM is relying on the
> guest to use the memory in a limited capacity, e.g. isn't using the memory as
> general purpose RAM.  That's not problematic for your use case, because presumably
> the memory is used only by the vGPU, but as is KVM can't enforce that behavior in
> any way.
>
> The really gross part is that failures are not strictly punted to userspace;
> the resulting error varies significantly depending on how the guest "illegally"
> uses the memory.
>
> My first choice would be to get the amdgpu driver "fixed", but that's likely an
> unreasonable request since it sounds like the non-KVM behavior is working as intended.
>
> One thought would be to require userspace to opt-in to mapping this type of memory
> by introducing a new memslot flag that explicitly states that the memslot cannot
> be accessed directly by KVM, i.e. can only be mapped into the guest.  That way,
> KVM has an explicit ABI with respect to how it handles this type of memory, even
> though the semantics of exactly what will happen if userspace/guest violates the
> ABI are not well-defined.  And internally, KVM would also have a clear touchpoint
> where it deliberately allows mapping such memslots, as opposed to the more implicit
> behavior of bypassing ensure_pfn_ref().

Is it well defined when KVM needs to directly access a memslot? At
least for x86, it looks like most of the use cases are related to
nested virtualization, except for the call in
emulator_cmpxchg_emulated. Without being able to specifically state
what should be avoided, a flag like that would be difficult for
userspace to use.

> If we're clever, we might even be able to share the flag with the "guest private
> memory"[*] concept being pursued for confidential VMs.
>
> [*] https://lore.kernel.org/all/20211223123011.41044-1-chao.p.peng@linux.intel.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
