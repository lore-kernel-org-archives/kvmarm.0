From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] VFIO: platform: AMD xgbe reset module
Date: Thu, 15 Oct 2015 15:59:56 +0200
Message-ID: <5270338.MbsQ1bGczu@wuerfel>
References: <1444836792-2405-1-git-send-email-eric.auger@linaro.org>
 <7287273.XGFpHqQ9fN@wuerfel> <20151015121228.GA965@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8706413DD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 09:57:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id InF3HpDpZwNQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2015 09:57:52 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3102F41294
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2015 09:57:51 -0400 (EDT)
In-Reply-To: <20151015121228.GA965@cbox>
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
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, suravee.suthikulpanit@amd.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 15 October 2015 14:12:28 Christoffer Dall wrote:
> > 
> > enum vfio_platform_op {
> >       VFIO_PLATFORM_BIND,
> >       VFIO_PLATFORM_UNBIND,
> >       VFIO_PLATFORM_RESET,
> > };
> > 
> > struct platform_driver {
> >         int (*probe)(struct platform_device *);
> >         int (*remove)(struct platform_device *);
> >       ...
> >       int (*vfio_manage)(struct platform_device *, enum vfio_platform_op);
> >         struct device_driver driver;
> > };
> > 
> > This would integrate much more closely into the platform driver framework,
> > just like the regular vfio driver integrates into the PCI framework.
> > Unlike PCI however, you can't just use the generic driver framework to
> > unbind the driver, because you still need device specific code.
> > 
> Thanks for these suggestions, really helpful.
> 
> What I don't understand in the latter example is how VFIO knows which
> struct platform_driver to interact with?

This would assume that the driver remains bound to the device, so VFIO
gets a pointer to the device from somewhere (as it does today) and then
follows the dev->driver pointer to get to the platform_driver.
 
> Also, just so I'm sure I understand correctly, VFIO_PLATFORM_UNBIND is
> then called by VFIO before the VFIO driver unbinds from the device
> (unbinding the platform driver from the device being a completely
> separate thing)?

This is where we'd need a little more changes for this approach. Instead
of unbinding the device from its driver, the idea would be that the
driver remains bound as far as the driver model is concerned, but
it would be in a quiescent state where no other subsystem interacts with
it (i.e. it gets unregistered from networking core or whichever it uses).

	Arnd
