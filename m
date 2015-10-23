From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 6/7] vfio: platform: use list of registered reset function
Date: Fri, 23 Oct 2015 15:12:16 +0200
Message-ID: <4934120.DeNtNjTIFs@wuerfel>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org> <1445603835-14506-7-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445603835-14506-7-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@linaro.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 14:37:14 Eric Auger wrote:
> Remove the static lookup table and use the dynamic list of registered
> reset functions instead. Also load the reset module through its alias.
> The reset struct module pointer is stored in vfio_platform_device.
> 
> We also remove the useless struct device pointer parameter in
> vfio_platform_get_reset.
> 
> This patch fixes the issue related to the usage of __symbol_get, which
> besides from being moot, prevented compilation with CONFIG_MODULES
> disabled.
> 
> Also usage of MODULE_ALIAS makes possible to add a new reset module
> without needing to update the framework. This was suggested by Arnd.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> 
> 
Reviewed-by: Arnd Bergmann <arnd@arndb.de>

but doesn't this need to come before patch 4/7?

	Arnd
