From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 4/7] vfio: platform: reset: calxedaxgmac: add reset
 function registration
Date: Fri, 23 Oct 2015 15:09:25 +0200
Message-ID: <9240674.LNN502Hn9c@wuerfel>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
 <1445603835-14506-5-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 458F341CC1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 09:07:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aKh01LYnyhAh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 09:07:21 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5F1D412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 09:07:20 -0400 (EDT)
In-Reply-To: <1445603835-14506-5-git-send-email-eric.auger@linaro.org>
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

On Friday 23 October 2015 14:37:12 Eric Auger wrote:
> This patch adds the reset function registration/unregistration.
> This is handled through the module_vfio_reset_handler macro. This
> latter also defines a MODULE_ALIAS which simplifies the load from
> vfio-platform.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
