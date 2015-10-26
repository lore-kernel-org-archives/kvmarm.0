From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v3] VFIO: platform: reset: AMD xgbe reset module
Date: Mon, 26 Oct 2015 11:22:48 +0100
Message-ID: <562DFEF8.5090904@linaro.org>
References: <201510241614.F4vZ38k0%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5721641172
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 06:20:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EGk8RXLjJfkf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2015 06:20:05 -0400 (EDT)
Received: from mail-wi0-f177.google.com (mail-wi0-f177.google.com
 [209.85.212.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC95340FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 06:20:04 -0400 (EDT)
Received: by wicll6 with SMTP id ll6so106984414wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 03:22:52 -0700 (PDT)
In-Reply-To: <201510241614.F4vZ38k0%fengguang.wu@intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kbuild test robot <lkp@intel.com>
Cc: thomas.lendacky@amd.com, kvm@vger.kernel.org, arnd@arndb.de, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, kbuild-all@01.org, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Dear all,

I think the problem comes from the fact this patch applies on top of
"VFIO platform reset module rework",
https://lkml.org/lkml/2015/10/23/385. This is where
module_vfio_reset_handler macro is introduced. Maybe I should have
reverted the patch into RFC after decision to rework the framework.

Best Regards

Eric


On 10/24/2015 10:41 AM, kbuild test robot wrote:
> Hi Eric,
> 
> [auto build test ERROR on asm-generic/master -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
> 
> url:    https://github.com/0day-ci/linux/commits/Eric-Auger/VFIO-platform-reset-AMD-xgbe-reset-module/20151024-000245
> config: arm-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:122:27: error: expected declaration specifiers or '...' before string constant
>     module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
>                               ^
>>> drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:122:51: error: expected declaration specifiers or '...' before 'vfio_platform_amdxgbe_reset'
>     module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
>                                                       ^
> --
>>> /kbuild/src/defs/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:122:27: error: expected declaration specifiers or '...' before string constant
>     module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
>                               ^
>>> /kbuild/src/defs/drivers/vfio/platform/reset/vfio_platform_amdxgbe.c:122:51: error: expected declaration specifiers or '...' before 'vfio_platform_amdxgbe_reset'
>     module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
>                                                       ^
> 
> vim +122 drivers/vfio/platform/reset/vfio_platform_amdxgbe.c
> 
>    116		if (!count)
>    117			pr_warn("%s MAC SW reset failed\n", __func__);
>    118	
>    119		return 0;
>    120	}
>    121	
>  > 122	module_vfio_reset_handler("amd,xgbe-seattle-v1a", vfio_platform_amdxgbe_reset);
>    123	
>    124	MODULE_VERSION("0.1");
>    125	MODULE_LICENSE("GPL v2");
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
