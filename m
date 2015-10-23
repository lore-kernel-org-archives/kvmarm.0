From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] VFIO: platform: reset: AMD xgbe reset module
Date: Fri, 23 Oct 2015 14:55:38 +0200
Message-ID: <4421151.hWFIfrRvFW@wuerfel>
References: <1445604253-15384-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7812410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:53:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NscE2OXy1tJM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:53:09 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BEC9A410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:53:08 -0400 (EDT)
In-Reply-To: <1445604253-15384-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 14:44:13 Eric Auger wrote:
> This patch introduces a module that registers and implements a low-level
> reset function for the AMD XGBE device.
> 
> it performs the following actions:
> - reset the PHY
> - disable auto-negotiation
> - disable & clear auto-negotiation IRQ
> - soft-reset the MAC
> 
> Those tiny pieces of code are inherited from the native xgbe driver.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---

The code looks ok to me, just two small style issues.
>  
>  	  If you don't know what to do here, say N.
> +config VFIO_PLATFORM_AMDXGBE_RESET
> +	tristate "VFIO support for AMD XGBE reset"
> +	depends on VFIO_PLATFORM
> +	help
> +	  Enables the VFIO platform driver to handle reset for AMD XGBE
> +
> +	  If you don't know what to do here, say N.

Please add an empty line before the newly introduced option.

> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);

Best remove those macros and put the strings in here directly to
make it easier to grep for.

	Arnd
