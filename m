From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [RFC PATCH v5 0/3] vfio: platform: return device properties for a
 platform device
Date: Fri, 2 Oct 2015 23:53:07 +0100
Message-ID: <CAFEAcA84seKfSh94XFJZxBeBzRd=twj2QaFvjMeDKYhrWQu7Nw@mail.gmail.com>
References: <1443604077-3155-1-git-send-email-b.reynal@virtualopensystems.com>
 <1443814099.26107.124.camel@redhat.com> <20151002202844.GD32011@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C22241294
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 18:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C0FlnADD2YL0 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 18:51:42 -0400 (EDT)
Received: from mail-vk0-f50.google.com (mail-vk0-f50.google.com
 [209.85.213.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 621814126B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 18:51:42 -0400 (EDT)
Received: by vkgd64 with SMTP id d64so68865767vkg.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Oct 2015 15:53:26 -0700 (PDT)
In-Reply-To: <20151002202844.GD32011@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, iommu@lists.linux-foundation.org, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 October 2015 at 21:28, Christoffer Dall
<christoffer.dall@linaro.org> wrote:
> We discussed this for the purposes of ARM during SFO15 last week, and
> basically arrived at the conclusion that the resonable thing to do is to
> rely on sysfs device tree parsing in userspace.  We don't have a great
> solution for ACPI yet, but we also don't know of any ACPI-only devices
> that want platform device passthrough yet.

I wasn't hugely happy with that approach though:
 * it's DT specific and just won't work on ACPI platforms; implementing
   features with a "needs DT" dependency seems like it will come back to
   bite us later
 * I don't really want to build in a lot of infrastructure into
   QEMU to either build the DTC compiler into it or else introduce
   a runtime dependency on the dtc binary, if this is just going
   to be a stopgap solution until somebody says "has to work on
   ACPI" and we need to do it some other way

On the other hand I don't exactly have a better approach to suggest
(except "don't do device passthrough for platform devices, insist
on a real bus like PCI"...)

thanks
-- PMM
