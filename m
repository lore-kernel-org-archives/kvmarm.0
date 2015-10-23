From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/7] vfio: platform: add capability to register a reset
 function
Date: Fri, 23 Oct 2015 15:07:37 +0200
Message-ID: <5723752.hDK15zeNcm@wuerfel>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
 <1445603835-14506-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF36412EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 09:05:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CR3Q8GpMEl7I for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 09:05:05 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5255412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 09:05:05 -0400 (EDT)
In-Reply-To: <1445603835-14506-3-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 14:37:10 Eric Auger wrote:
> +
> +void vfio_platform_unregister_reset(const char *compat)
> +{
> +       struct vfio_platform_reset_node *iter, *temp;
> +
> +       mutex_lock(&driver_lock);
> +       list_for_each_entry_safe(iter, temp, &reset_list, link) {
> +               if (!strcmp(iter->compat, compat)) {
> +                       list_del(&iter->link);
> +                       break;
> +               }
> +       }
> +
> +       mutex_unlock(&driver_lock);
> +}
> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
> 

This is slightly unsafe in case you ever get two drivers that register
with the same compat string. If we care about that, we could pass
and compare both the string and the function pointer, or the
vfio_platform_reset_node.

	Arnd
