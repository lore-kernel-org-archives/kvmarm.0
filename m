From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 1/7] vfio: platform: introduce vfio-platform-base module
Date: Fri, 23 Oct 2015 15:04:43 +0200
Message-ID: <8949689.8EqFqDRsZI@wuerfel>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org> <1445603835-14506-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445603835-14506-2-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@linaro.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 14:37:09 Eric Auger wrote:
> To prepare for vfio platform reset rework let's build
> vfio_platform_common.c and vfio_platform_irq.c in a separate
> module from vfio-platform and vfio-amba. This makes possible
> to have separate module inits and works around a race between
> platform driver init and vfio reset module init: that way we
> make sure symbols exported by base are available when vfio-platform
> driver gets probed.
> 
> The open/release being implemented in the base module, the ref
> count is applied to the parent module instead.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> 
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
