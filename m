From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 02/13] KVM: extend struct kvm_msi to hold a 32-bit device
 ID
Date: Tue, 09 Jun 2015 10:49:56 +0200
Message-ID: <5576A8B4.3000503@linaro.org>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com> <1432893209-27313-3-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432893209-27313-3-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Reviewed-by: Eric Auger <eric.auger@linaro.org>
On 05/29/2015 11:53 AM, Andre Przywara wrote:
> The ARM GICv3 ITS MSI controller requires a device ID to be able to
> assign the proper interrupt vector. On real hardware, this ID is
> sampled from the bus. To be able to emulate an ITS controller, extend
> the KVM MSI interface to let userspace provide such a device ID. For
> PCI devices, the device ID is simply the 16-bit bus-device-function
> triplet, which should be easily available to the userland tool.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  Documentation/virtual/kvm/api.txt | 8 ++++++--
>  include/uapi/linux/kvm.h          | 4 +++-
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 9fa2bf8..891d64a 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2121,10 +2121,14 @@ struct kvm_msi {
>  	__u32 address_hi;
>  	__u32 data;
>  	__u32 flags;
> -	__u8  pad[16];
> +	__u32 devid;
> +	__u8  pad[12];
>  };
>  
> -No flags are defined so far. The corresponding field must be 0.
> +flags: KVM_MSI_VALID_DEVID: devid is valid, otherwise ignored.
> +devid: If KVM_MSI_VALID_DEVID is set, contains a value to identify the device
> +       that wrote the MSI message. For PCI, this is usually a BFD
> +       identifier in the lower 16 bits.
>  
>  
>  4.71 KVM_CREATE_PIT2
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4b60056..2a23705 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -965,12 +965,14 @@ struct kvm_one_reg {
>  	__u64 addr;
>  };
>  
> +#define KVM_MSI_VALID_DEVID	(1U << 0)
>  struct kvm_msi {
>  	__u32 address_lo;
>  	__u32 address_hi;
>  	__u32 data;
>  	__u32 flags;
> -	__u8  pad[16];
> +	__u32 devid;
> +	__u8  pad[12];
>  };
>  
>  struct kvm_arm_device_addr {
> 

