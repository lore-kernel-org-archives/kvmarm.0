From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 6/7] vfio: platform: use list of registered reset function
Date: Fri, 23 Oct 2015 16:23:06 +0200
Message-ID: <5844194.uTAR9RVtmZ@wuerfel>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org> <4934120.DeNtNjTIFs@wuerfel> <562A3FFC.4050504@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <562A3FFC.4050504@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@linaro.org>, b.reynal@virtualopensystems.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 16:11:08 Eric Auger wrote:
> Hi Arnd,
> On 10/23/2015 03:12 PM, Arnd Bergmann wrote:
> > On Friday 23 October 2015 14:37:14 Eric Auger wrote:
> >> Remove the static lookup table and use the dynamic list of registered
> >> reset functions instead. Also load the reset module through its alias.
> >> The reset struct module pointer is stored in vfio_platform_device.
> >>
> >> We also remove the useless struct device pointer parameter in
> >> vfio_platform_get_reset.
> >>
> >> This patch fixes the issue related to the usage of __symbol_get, which
> >> besides from being moot, prevented compilation with CONFIG_MODULES
> >> disabled.
> >>
> >> Also usage of MODULE_ALIAS makes possible to add a new reset module
> >> without needing to update the framework. This was suggested by Arnd.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> Reported-by: Arnd Bergmann <arnd@arndb.de>
> >>
> >>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > but doesn't this need to come before patch 4/7?
> Well I don't think so. In [4] we introduce the dynamic registration
> method but until this patch we still use the old lookup method in the
> static table. I tested and the reset lookup still works in [4].
> If we put this one before the registration, the functionality will be
> lost here.
> 

Ok, I see. I was getting confused by the removal of the EXPORT_SYMBOL
statement there and thought it would break the __get_symbol call.

	Arnd
