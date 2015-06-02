From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 0/4] machvirt dynamic sysbus device instantiation
Date: Tue, 2 Jun 2015 16:40:55 +0100
Message-ID: <CAFEAcA9kZu-OXF9bnEaiYJVH1arZpqL7F=6pALoHhYk9-cJxTg@mail.gmail.com>
References: <1433244554-12898-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFDD52C90
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2015 11:31:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qy8PR2P7tqHG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jun 2015 11:31:22 -0400 (EDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
 [209.85.213.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96BE852BE4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2015 11:31:21 -0400 (EDT)
Received: by igbyr2 with SMTP id yr2so89991290igb.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Jun 2015 08:41:15 -0700 (PDT)
In-Reply-To: <1433244554-12898-1-git-send-email-eric.auger@linaro.org>
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
Cc: Patch Tracking <patches@linaro.org>, eric.auger@st.com, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 2 June 2015 at 12:29, Eric Auger <eric.auger@linaro.org> wrote:
> This series enables machvirt to dynamically instantiate sysbus
> devices from command line (using -device option).
>
> All those sysbus devices are plugged onto a platform bus. This latter
> device is instantiated in machvirt and takes care of the binding of
> children sysbus devices on a machine init done notifier. The device
> tree node generation for children dynamic sysbus device also happens
> on a subsequent notifier that must be executed after the above one.
> machvirt registers that notifier before the platform bus creation to
> make sure notifiers are executed in the right order: dt generation
> after actual QOM binding.
>
> Few sysbus devices are supposed to be instantiated that way. VFIO
> devices belong to them.
>
> Node creation really is architecture specific. On ARM the dynamic
> sysbus device node creation is implemented in a new C module,
> hw/arm/sysbus-fdt.c and not in the machine file.
>
> Machvirt transformations and sysbus-fdt are largely inspired from Alex work.
>
> The patch series can be found at:
> http://git.linaro.org/people/eric.auger/qemu.git,
> branch official_dynsysbus_v13-target-arm.next
>
> Best Regards

This has been on list a fair while and got plenty of review
(thanks to everybody who helped with that). I'm not really
very happy about the whole concept of mmio passthrough, but
some people need it, so we're stuck with it.

Applied to target-arm.next, thanks.

-- PMM
