From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC/RFT PATCH v2 0/3] KVM: Introduce KVM_MEM_UNCACHED
Date: Thu, 14 May 2015 11:37:46 +0100
Message-ID: <CAFEAcA_EEA=TZ1jxL_rptAx5_sGa8NLMffePAw3eb-3pBgdg5w@mail.gmail.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <20150514103150.GA12812@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 269C651440
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 06:29:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id isB1dffGqS1D for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 06:28:59 -0400 (EDT)
Received: from mail-ig0-f170.google.com (mail-ig0-f170.google.com
 [209.85.213.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51C515143F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 06:28:59 -0400 (EDT)
Received: by igbhj9 with SMTP id hj9so69144173igb.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 03:38:07 -0700 (PDT)
In-Reply-To: <20150514103150.GA12812@localhost.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, Laszlo Ersek <lersek@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 14 May 2015 at 11:31, Andrew Jones <drjones@redhat.com> wrote:
> Forgot to (4): switch from setting userspace's mapping to
> device memory to normal, non-cacheable. Using device memory
> caused a problem that Alex Graf found, and Peter Maydell suggested
> using normal, non-cacheable instead.

Did you check that non-cacheable is definitely the correct
kind of Normal memory attribute we want? (ie not write-through).

-- PMM
