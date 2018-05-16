From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH 06/14] ARM: spectre-v2: harden branch predictor on context
 switches
Date: Wed, 16 May 2018 12:33:54 +0100
Message-ID: <0ddd02c0-0af6-e89a-e6ea-b2bd1290dfaf@arm.com>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
 <E1fIuBA-0003pt-00@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <E1fIuBA-0003pt-00@rmk-PC.armlinux.org.uk>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <rmk+kernel@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/05/18 12:01, Russell King wrote:
>  __v7_cr7mp_proc_info:
>  	.long	0x410fc170
>  	.long	0xff0ffff0
> -	__v7_proc __v7_cr7mp_proc_info, __v7_cr7mp_setup
> +	__v7_proc __v7_cr7mp_proc_info, __v7_cr7mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
>  	.size	__v7_cr7mp_proc_info, . - __v7_cr7mp_proc_info
>  
>  	/*
> @@ -649,7 +700,7 @@ ENDPROC(__v7_setup)
>  __v7_cr8mp_proc_info:
>  	.long	0x410fc180
>  	.long	0xff0ffff0
> -	__v7_proc __v7_cr8mp_proc_info, __v7_cr8mp_setup
> +	__v7_proc __v7_cr8mp_proc_info, __v7_cr8mp_setup, proc_fns = HARDENED_BPIALL_PROCESSOR_FUNCTIONS
>  	.size	__v7_cr8mp_proc_info, . - __v7_cr8mp_proc_info

For R-class cores, the mitigation doesn't make much sense since we do not enforce user/kernel
isolation anyway. I believe the same also applies to A-class cores built with !MMU, so you might
want to guard CPU_SPECTRE with MMU in PATCH 05/14.

Cheers
Vladimir
