Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822FFC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 17:57:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C79A4B9D1;
	Fri,  9 Dec 2022 12:57:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C8ZDUGLaZGSm; Fri,  9 Dec 2022 12:57:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EEC2C4B984;
	Fri,  9 Dec 2022 12:57:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AABB04B984
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:57:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pxi+XF+IqlQE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 12:57:42 -0500 (EST)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com
 [209.85.128.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87DD64B975
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 12:57:42 -0500 (EST)
Received: by mail-yw1-f171.google.com with SMTP id
 00721157ae682-3b48b139b46so61754987b3.12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 09:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=bMZ9vaUyXosUBjlo9WUDdUBep5JMYYDWXkYuJRTyBRc=;
 b=PNNz0qgco2CC6vK8iX8A8CdQ9XYG/eiYEJI0PFBFwEDrAJkafbZh+wNNez+eyMKsNW
 dyYIVM2JUEXFIo3AsWaRZNjWiZwyFaVdNR0pQpuSKF0S76DLKWQFl1oZGEBDU5afM86c
 4MHyLC00G+IV14UOCOsjUR6HTn+tapMh3yj6v/QPIYSR6ep3HNH6Adic+iJisjvPkwA/
 hLPuSxDfDTXFbxYKTocYksmV9tgslNTPcnfgAPbkxh/jMNo9/8AxKFzwYVG9ZAJJI+XR
 ZLWDlt7dnT+fbIaDz/1md454IG3J2J19ANvQ4CvzY4M0DlboF2jrnlXjyCT1tHR69aMt
 lUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=bMZ9vaUyXosUBjlo9WUDdUBep5JMYYDWXkYuJRTyBRc=;
 b=weI0k8wI6UjOqXZ4Gxv/AsDka5Ef5+DJnm2Ioi5M/WMQWtFwqEB8m1z2i/pU16XxZX
 HZmMvswFQy1jIEbXlBhUk7g6tIKsygd9FUNw3A5P7Dw70lXr2n2Zs68qmaZEinQInHBK
 BWNxEuVN5EUYh4F3Z3TkS6drhV7eBdOK8+KZ+WHkZ7+4cuJAz2sLnpp3OFd8KlV5VMQ2
 0vAKtIzCyHwVubDXcppbuOMoD45kKQLR8obzqUdLWQ2g3prJSzQqIkrAxVY80qdREjLh
 dHIMw+n+qA1DHzBqqBAYfqIOdoVJTipYSZAWTAXXSsoQytM+t/7Zd8lZMBwwO3x0sQCv
 Me0Q==
X-Gm-Message-State: ANoB5pkLI2ZDXonUufebed/hJSkNeUZLDZPze1HcheGCMqikYIaS43n9
 VJjXHx8NTranIHFsHMJMjunsJUtLi8cOdgS8WQr1bQ==
X-Google-Smtp-Source: AA0mqf7ZLFzH7tn8G3mgBGvDrhVn7KNrvvpffIzBOW371A0vYuDJaiDqvxR+ZPRcFAJZ2LX4aVuYJ3WS6sGEmfbkAcg=
X-Received: by 2002:a81:148d:0:b0:36a:75b3:fdda with SMTP id
 135-20020a81148d000000b0036a75b3fddamr7388556ywu.168.1670608661842; Fri, 09
 Dec 2022 09:57:41 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-24-dmatlack@google.com>
 <Y5NxCYz9XV3hgGYX@google.com>
In-Reply-To: <Y5NxCYz9XV3hgGYX@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 9 Dec 2022 09:57:15 -0800
Message-ID: <CALzav=f-qDqJcvPEo1ZxxVizAE77crMFsbKUVif5B-mNgGEHyQ@mail.gmail.com>
Subject: Re: [RFC PATCH 23/37] KVM: MMU: Move VM-level TDP MMU state to struct
 kvm
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Ben Gardon <bgardon@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, xu xin <cgel.zte@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Arnd Bergmann <arnd@arndb.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
 Colin Cross <ccross@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
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

On Fri, Dec 9, 2022 at 9:32 AM Oliver Upton <oliver.upton@linux.dev> wrote:
>
> Hey David,
>
> On Thu, Dec 08, 2022 at 11:38:43AM -0800, David Matlack wrote:
> > Move VM-level TDP MMU state to struct kvm so it can be accessed by
> > common code in a future commit.
> >
> > No functional change intended.
>
> Could you instead introduce a structure to hold all of the MMU state and
> stick that in struct kvm? If the goal is to eventually supersede all
> uses of the arm64 pgtable library we are going to need the ability to
> operate outside of a KVM VM context.

This patch does introduce a tdp_mmu struct to hold all of the TDP MMU
state. Did you have something else in mind?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
