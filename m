From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 3/7] vfio: platform: introduce
 module_vfio_reset_handler macro
Date: Fri, 23 Oct 2015 15:09:04 +0200
Message-ID: <3721718.lcvGuESNdi@wuerfel>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
 <1445603835-14506-4-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54FC941CC1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 09:06:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Uv8xar2lETc5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 09:06:33 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97213412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 09:06:33 -0400 (EDT)
In-Reply-To: <1445603835-14506-4-git-send-email-eric.auger@linaro.org>
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
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 14:37:11 Eric Auger wrote:
> +static int __init reset ## _module_init(void)                  \
> +{                                                              \
> +       vfio_platform_register_reset(compat, reset);            \
> +       return 0;                                               \
> +};                                                             \
> 

I would make this 'return vfio_platform_register_reset(...)', so loading
the driver fails if the handler cannot get registered. Alternatively,
change the return type of vfio_platform_register_reset to 'void'
so it can never fail.

	Arnd
