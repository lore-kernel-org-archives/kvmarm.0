From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v3 4/4] target-arm: Add the GICv2m to the virt board
Date: Tue, 26 May 2015 13:55:46 +0100
Message-ID: <CAFEAcA-NVfKXNOUo=3Li298wys-KFw1Vn9mVHbh+bc0aJ2efEQ@mail.gmail.com>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
 <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
 <55646D0F.9040801@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA16520DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:46:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3u6wzacq6Lc8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2015 08:46:27 -0400 (EDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
 [209.85.213.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23CCB520DB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 08:46:26 -0400 (EDT)
Received: by igbpi8 with SMTP id pi8so58272807igb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2015 05:56:06 -0700 (PDT)
In-Reply-To: <55646D0F.9040801@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 26 May 2015 at 13:54, Eric Auger <eric.auger@linaro.org> wrote:
> Reviewed-by: Eric Auger <eric.auger@linaro.org>
>
> The only question I have is related to mid-term virt strategy about
> GICv3 integration. Are we going to reuse that memory map for the machine
> instantiating the GICv3? If yes, shouldn't we put the GICv2M somewhere
> else to leave space for GICv3 redistributors, assuming we reuse the
> shared distributor region. I understood the memory map is difficult to
> change once applied once.

I wouldn't expect that you'd have a GICv2M at all in a
system with a GICv3 in it, would you?

-- PMM
