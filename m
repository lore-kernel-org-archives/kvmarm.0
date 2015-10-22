From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 2/6] vfio: platform: reset: add
 vfio_platform_reset_private.h
Date: Thu, 22 Oct 2015 12:12:23 +0200
Message-ID: <4144159.DC8Yilf9Tr@wuerfel>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
 <1445506922-6005-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A914411BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 06:09:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wN1HJqkD5rrA for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 06:09:55 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C364F41049
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 06:09:55 -0400 (EDT)
In-Reply-To: <1445506922-6005-3-git-send-email-eric.auger@linaro.org>
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
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thursday 22 October 2015 11:41:58 Eric Auger wrote:
> v2: creation
> - this defines the module_vfio_reset_handler macro as suggested by Arnd
> 
> Although Arnd suggested me to remove the vfio_platform_register_reset
> symbol_get (since the module manager can handle the case where the
> vfio-platform driver is not loaded), I prefered to keep it while
> introducing the macro. The rationale is, when using symbol_get/put
> we are able to release the hold from the reset module on vfio-platform
> as soon as the registration is complete and I think this makes sense.

This makes it highly unusual. I can't think of a good reason to allow
unloading the vfio platform module while a reset module is registered,
that just causes a memory leak (or possibly a crash) when you do
unload the core module while it's used by a reset driver, it
prevents the reset module from getting loaded without loading the
vfio module first (because the autoloading doesn't work), and it
means we don't catch build errors in invalid configurations where you
have only the reset driver but not the vfio driver enabled.

	Arnd
