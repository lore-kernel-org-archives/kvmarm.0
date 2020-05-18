Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73A2C433E1
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 10:43:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F21D207F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 10:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vq33VVii"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F21D207F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9744B1B0;
	Mon, 18 May 2020 06:43:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yoHCBsytljHB; Mon, 18 May 2020 06:43:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD89D4B19D;
	Mon, 18 May 2020 06:43:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2288D4B184
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 05:19:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q0ZMzgTav+lS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 05:18:59 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35D484B17D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 05:18:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1589793539;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wUvuFHtpRP2kms7NhYOoam9/bRncTEMEMk1lIVn22aw=;
 b=Vq33VVii1K/miBGCsqvx9ahU2CHfM24JmQIMcnBAtbe1CgIKRThZkimjM4uD04XWbKNokE
 pJEPaQ5gAugdbFGWumebcSEeaiEOvU3Y7bZoTVSCpyx9II2vt9v0It1FpseQ4UpLziTlby
 clwfmYnoBKNcxei7IOmocX2vB5s4FkU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-P8oJKAlTOBOfmZqe2XRZ5g-1; Mon, 18 May 2020 05:18:57 -0400
X-MC-Unique: P8oJKAlTOBOfmZqe2XRZ5g-1
Received: by mail-wm1-f69.google.com with SMTP id f9so2006903wml.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 02:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
 :message-id:mime-version;
 bh=wUvuFHtpRP2kms7NhYOoam9/bRncTEMEMk1lIVn22aw=;
 b=fgL3K/DZHtXWcMmNZ59xeLaClum9r6XoZCOsQGkqc5i67Wrd/L+PDy7vZBjDQugBBw
 18wueWTeC+0XWppbJ/h8fhNG/kBEWTh1odOdBkOgLTuJxS5qpwDmFqFVmQqjS7mMFnV7
 0jgDotoBVSyHQlduyMDQqmCqdYN7/wGNtB4J7ThpHK9bI15WilTF3Mar529WbtJxMZbn
 pcDfD6I6v8FdL16CzAT3Ap97JOF+q7/FYDELa/Gb9gwTOxbtyEmQZVktAnTHN4A5XRj0
 +W10Uvkw0S5iXacDnZrB6NQxhDEZPg4UCiZTgyenX8dJxbQQbD8aC3rxeKEtFdQjkNF1
 rKdQ==
X-Gm-Message-State: AOAM533t63PXbpg5Qb7oHL8sz7WqKeNGc2W8nHmGqso4q5Wydui8CBFZ
 OEoP3t6Fc1hz5b0P4JshK130ibeeI0TyNHnIo7kUtylhkDj1j9EdoaNXzrH6te2J4LRYtsjsG5h
 Qx5wsqFVMD+5GGRP0gnK6al/g
X-Received: by 2002:a1c:acc8:: with SMTP id
 v191mr19179738wme.154.1589793535932; 
 Mon, 18 May 2020 02:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi7pOADLN/te5X0J+pmMiiuSIEST5v0Ejiqlgn996sQFmMXUsyHPVUkRkXSpo0mOyUHs5dug==
X-Received: by 2002:a1c:acc8:: with SMTP id
 v191mr19179715wme.154.1589793535716; 
 Mon, 18 May 2020 02:18:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
 by smtp.gmail.com with ESMTPSA id z11sm15011531wrr.32.2020.05.18.02.18.54
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 May 2020 02:18:55 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Anastassios Nanos <ananos@nubificus.co.uk>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <CALRTab-mEYtRG4zQbSGoAri+jg8xNL-imODv=MWE330Hkt_t+Q@mail.gmail.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <87y2ppy6q0.fsf@nanos.tec.linutronix.de>
 <CALRTab-mEYtRG4zQbSGoAri+jg8xNL-imODv=MWE330Hkt_t+Q@mail.gmail.com>
Date: Mon, 18 May 2020 11:18:53 +0200
Message-ID: <87o8qlvbwi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Mon, 18 May 2020 06:43:03 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
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

Anastassios Nanos <ananos@nubificus.co.uk> writes:

> Moreover, it doesn't involve *any* mode switch at all while printing
> out the result of the  addition of these two registers -- which I
> guess for a simple use-case like this it isn't much.
> But if we were to scale this to a large number of exits (and their
> respective handling in user-space) that would incur significant
> overhead.

Eliminating frequent exits to userspace when the guest is already
running is absolutely fine but eliminating userspace completely, even
for creation of the guest, is something dubious. To create a simple
guest you need just a dozen of IOCTLs, you'll have to find a really,
really good showcase when it makes a difference. 

E.g. I can imagine the following use-case: you need to create a lot of
guests with the same (or almost the same) memory contents and allocating
and populating this memory in userspace takes time. But even in this
use-case, why do you need to terminate your userspace? Or would it be
possible to create guests from a shared memory? (we may not have
copy-on-write capabilities in KVM currently but this doesn't mean they
can't be added).

Alternatively, you may want to mangle vmexit handling somehow and
exiting to userspace seems slow. Fine, let's add eBPF attach points to
KVM and an API to attach eBPF code there.

I'm, however, just guessing. I understand you may not want to reveal
your original idea for some reason but without us understanding what's
really needed I don't see how the change can be reviewed.

-- 
Vitaly

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
