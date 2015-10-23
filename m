From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 2/7] vfio: platform: add capability to register a reset
 function
Date: Fri, 23 Oct 2015 18:02:49 +0200
Message-ID: <4009334.qMnorDxQCK@wuerfel>
References: <1445615245-31124-1-git-send-email-eric.auger@linaro.org>
 <1445615245-31124-3-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DF7D411E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 12:00:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rgLahMMTuGqt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 12:00:21 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4A354113E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 12:00:21 -0400 (EDT)
In-Reply-To: <1445615245-31124-3-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Friday 23 October 2015 17:47:20 Eric Auger wrote:
> In preparation for subsequent changes in reset function lookup,
> lets introduce a dynamic list of reset combos (compat string,
> reset module, reset function). The list can be populated/voided with
> vfio_platform_register/unregister_reset. Those are not yet used in
> this patch.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
