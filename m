From: Alexander Spyridakis <a.spyridakis@virtualopensystems.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix PSCI affinity info return value for
 non valid cores
Date: Fri, 4 Sep 2015 18:32:34 +0200
Message-ID: <CAJRNFK+0HHjZ4DaZPeAUR0bJziztX=PW5uCL57erEcD5UHerDw@mail.gmail.com>
References: <1441379184-16749-1-git-send-email-a.spyridakis@virtualopensystems.com>
 <55E9BECD.6040302@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58B7C412DD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 12:32:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n9Mdy3AsnfHd for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2015 12:32:30 -0400 (EDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
 [209.85.217.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A1FF41278
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2015 12:32:30 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so14242198lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Sep 2015 09:32:55 -0700 (PDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com.
 [209.85.215.46])
 by smtp.googlemail.com with ESMTPSA id j5sm409441lbq.43.2015.09.04.09.32.54
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 04 Sep 2015 09:32:54 -0700 (PDT)
Received: by lamp12 with SMTP id p12so16458238lam.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Sep 2015 09:32:54 -0700 (PDT)
In-Reply-To: <55E9BECD.6040302@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, KVM General <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 4 September 2015 at 17:54, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Seems sound to me. Out of curiosity, how was this found?

Hello Mark,

This issue came up when testing some basic bare metal tests with KVM,
which originally were meant for the multi-threading TCG effort
(https://git.virtualopensystems.com/dev/tcg_baremetal_tests.git).
While shutting down the system the test relies on PSCI to find out if
all secondary cores are powered-off by incrementally polling PSCI for
every cpu id. In the case of QEMU/TCG everything was fine, but with
KVM there was no error response for non-existing cores, and so the
system could not shut down properly.

Kind regards.
