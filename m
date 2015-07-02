From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 2/7] KVM: kvm_host: add kvm_extended_msi
Date: Thu, 2 Jul 2015 18:03:26 +0100
Message-ID: <55956EDE.6030300@arm.com>
References: <1435592237-17924-1-git-send-email-eric.auger@linaro.org>
 <1435592237-17924-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49D1C577E7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 12:52:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cw1VXZdPnWzG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 12:52:12 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08CF577E0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 12:52:11 -0400 (EDT)
In-Reply-To: <1435592237-17924-3-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "p.fedin@samsung.com" <p.fedin@samsung.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

just played a bit with the code and I could make things easier by the
following change:

On 29/06/15 16:37, Eric Auger wrote:
> Add a new kvm_extended_msi struct to store the additional device ID
> specific to ARM. kvm_kernel_irq_routing_entry union now encompasses
> this new struct.
> =

> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> =

> ---
> =

> RFC -> PATCH:
> - reword the commit message after change in first patch (uapi)
> ---
>  include/linux/kvm_host.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> =

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ad45054..e1c1c0d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -304,6 +304,13 @@ struct kvm_s390_adapter_int {
>  	u32 adapter_id;
>  };
>  =

> +struct kvm_extended_msi {
> +	u32     address_lo;     /* low 32 bits of msi message address */
> +	u32     address_hi;     /* high 32 bits of msi message address */
> +	u32     data;           /* 16 bits of msi message data */
> +	u32	devid;		/* out-of-band device ID */
> +};
> +

I got rid of this structure at all, instead using:

 @@ -317,6 +324,7 @@ struct kvm_kernel_irq_routing_entry {
  		} irqchip;
-		struct msi_msg msi;
+		struct {
+			struct msi_msg msi;
+			u32 devid;
+		};
  		struct kvm_s390_adapter_int adapter;
  	};
  	struct hlist_node link;
  };

This re-uses the existing MSI fields in struct msi_msg, so all the extra
code you added in the next patches to set address and data could be
skipped. If needed we can add a flags field here as well to avoid that
extra type.
That simplified a lot for me.

Cheers,
Andr=E9
