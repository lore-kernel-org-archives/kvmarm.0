From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v4 0/7] VFIO platform reset module rework
Date: Fri, 23 Oct 2015 17:51:12 +0200
Message-ID: <562A5770.5080903@linaro.org>
References: <1445615245-31124-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445615245-31124-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 10/23/2015 05:47 PM, Eric Auger wrote:
> This series fixes the current implementation by getting rid of the
> usage of __symbol_get which caused a compilation issue with
> CONFIG_MODULES disabled. On top of this, the usage of MODULE_ALIAS makes
> possible to add a new reset module without being obliged to update the
> framework. The new implementation relies on the reset module registering
> its reset function to the vfio-platform driver.
> 
> The series is available at
> 
> https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.3-rc6-rework-v3
argh,

https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.3-rc6-rework-v4

But scatterbrained as I am, I am pretty sure I will do a new respin.

Thanks for your patience :-(

Eric
> 
> Best Regards
> 
> Eric
> 
> v3 -> v4:
> - Remove the EXPORT_SYMBOL_GPL(vfio_platform_calxedaxgmac_reset) later
>   in [6/7], to keep the functionality working all along the series
> - Add Arnd R-b (I dared to keep them despite the above change)
> - vfio_platform_unregister_reset gets the reset function to do a double
>   check on the compat and the function pointer too
> - __vfio_platform_register_reset turned to 'void'
> 
> v2 -> v3:
> - use driver_mutex instead of reset_mutex
> - style fixes: single mutex_unlock
> - use static nodes; vfio_platform_register_reset now is a macro
> - vfio_platform_reset_private.h removed since reset_module_(un)register
>   disappear. No use of symbol_get anymore.
> - new patch introducing vfio-platform-base
> - reset look-up moved back at vfio-platform probe time
> - new patch featuring dev_info/dev_warn
> 
> v1 -> v2:
> * in vfio_platform_common.c:
>   - move reset lookup at load time and put reset at release: this is to
>     prevent a race between the 2 load module loads
>   - reset_list becomes static
>   - vfio_platform_register/unregister_reset take a const char * as compat
>   - fix node link
>   - remove old combo struct and cleanup proto of vfio_platform_get_reset
>   - add mutex to protect the reset list
> * in calxeda xgmac reset module
>   - introduce vfio_platform_reset_private.h
>   - use module_vfio_reset_handler macro
>   - do not export vfio_platform_calxedaxgmac_reset symbol anymore
>   - add a pr_info to show the device is reset by vfio reset module
> 
> 
> 
> Eric Auger (7):
>   vfio: platform: introduce vfio-platform-base module
>   vfio: platform: add capability to register a reset function
>   vfio: platform: introduce module_vfio_reset_handler macro
>   vfio: platform: reset: calxedaxgmac: add reset function registration
>   vfio: platform: add compat in vfio_platform_device
>   vfio: platform: use list of registered reset function
>   vfio: platform: add dev_info on device reset
> 
>  drivers/vfio/platform/Makefile                     |   6 +-
>  .../platform/reset/vfio_platform_calxedaxgmac.c    |   5 +-
>  drivers/vfio/platform/vfio_amba.c                  |   1 +
>  drivers/vfio/platform/vfio_platform.c              |   1 +
>  drivers/vfio/platform/vfio_platform_common.c       | 119 +++++++++++++++------
>  drivers/vfio/platform/vfio_platform_private.h      |  40 ++++++-
>  6 files changed, 130 insertions(+), 42 deletions(-)
> 
