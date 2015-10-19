From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/4] VFIO platform reset module rework
Date: Mon, 19 Oct 2015 15:08:50 +0200
Message-ID: <5564303.6Ntpr32PW1@wuerfel>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Sunday 18 October 2015 18:00:11 Eric Auger wrote:
> This series fixes the current implementation by getting rid of the
> usage of __symbol_get which caused a compilation issue with
> CONFIG_MODULES disabled. On top of this, the usage of MODULE_ALIAS makes
> possible to add a new reset module without being obliged to update the
> framework. The new implementation relies on the reset module registering
> its reset function to the vfio-platform driver.
> 
> The series is available at
> 
> https://git.linaro.org/people/eric.auger/linux.git/shortlog/refs/heads/v4.3-rc5-rework-xgbe-v2
> 
> 

Looks good for the most part, just a few comments on coding style
for patches 1 and 2.

	Arnd
