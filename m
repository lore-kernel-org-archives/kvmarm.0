From: Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [RFC QEMU 1/2] arm/virt: Initialize generic timer
 scale factor dynamically
Date: Thu, 8 Nov 2018 15:21:47 +0100
Message-ID: <47f78310-56e7-ba5e-0fb1-99830750e49b@linaro.org>
References: <1541616504-68526-1-git-send-email-bijan.mottahedeh@oracle.com>
	<1541616504-68526-2-git-send-email-bijan.mottahedeh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
In-Reply-To: <1541616504-68526-2-git-send-email-bijan.mottahedeh@oracle.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 11/7/18 7:48 PM, Bijan Mottahedeh wrote:
>  
> +static void set_system_clock_scale(void)
> +{
> +    unsigned long cntfrq_el0;
> +
> +    asm volatile("mrs %0, cntfrq_el0" : "=r"(cntfrq_el0));
> +
> +    if (cntfrq_el0 == 0) {
> +        cntfrq_el0 = GTIMER_SCALE_DEF;
> +    }
> +
> +    system_clock_scale = NANOSECONDS_PER_SECOND / (int)cntfrq_el0;
> +}

This only works for kvm.

For TCG you need to use the default always.  In particular, it won't even
compile for an x86 host.


r~
