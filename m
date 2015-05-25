From: Pavel Fedin <p.fedin@samsung.com>
Subject: Re: [PATCH v3 4/4] target-arm: Add the GICv2m to the
	virt	board
Date: Mon, 25 May 2015 16:09:58 +0300
Message-ID: <011b01d096ec$1a395e80$4eac1b80$@samsung.com>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
	<1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-reply-to: <1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
Content-language: ru
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: 'Christoffer Dall' <christoffer.dall@linaro.org>, qemu-devel@nongnu.org
Cc: kvmarm@lists.cs.columbia.edu, eric.auger@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

>  typedef struct MemMapEntry {
> @@ -88,6 +90,7 @@ typedef struct VirtBoardInfo {
>      int fdt_size;
>      uint32_t clock_phandle;
>      uint32_t gic_phandle;
> +    uint32_t v2m_phandle;
>  } VirtBoardInfo;

 Could you rename v2m_phandle to something more neutral like msi_phandle ? It will also be
used by GICv3 ITS implementation.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
