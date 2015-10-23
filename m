From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3] VFIO: platform: reset: AMD xgbe reset module
Date: Fri, 23 Oct 2015 18:02:15 +0200
Message-ID: <4674490.OAKeLluVeG@wuerfel>
References: <1445615913-31825-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445615913-31825-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, thomas.lendacky@amd.com, Suravee.Suthikulpanit@amd.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@linaro.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 17:58:33 Eric Auger wrote:
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

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
