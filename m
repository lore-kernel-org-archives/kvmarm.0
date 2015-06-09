From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Enable the KVM-VFIO device
Date: Tue, 09 Jun 2015 18:09:53 +0100
Message-ID: <55771DE1.7050405@arm.com>
References: <1433517709-6872-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433517709-6872-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>, Kim Phillips <kim.phillips@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 05/06/15 16:21, Eric Auger wrote:
> From: Kim Phillips <kim.phillips@linaro.org>
> 
> The KVM-VFIO device is used by the QEMU VFIO device. It is used to
> record the list of in-use VFIO groups so that KVM can manipulate
> them.
> 
> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> - previously included in KVM-VFIO IRQ forward control v6 series.
>   Rationale to put it aside is the unavailability of the kvm-vfio device
>   causes produces a warning when launching the QEMU VFIO platform device
>   that can puzzle some users (although not blocking):
>   "Failed to create KVM VFIO device: No such device"

Applied to queue.

	M.
-- 
Jazz is not dead. It just smells funny...
