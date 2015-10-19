From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] vfio: platform: add capability to register a reset
 function
Date: Mon, 19 Oct 2015 15:08:13 +0200
Message-ID: <4603273.vQZIH2Gpzn@wuerfel>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
 <1445184015-24414-2-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521A84117E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 09:06:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 26wAafUA1iOA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Oct 2015 09:06:00 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 816A9410BB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Oct 2015 09:06:00 -0400 (EDT)
In-Reply-To: <1445184015-24414-2-git-send-email-eric.auger@linaro.org>
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

On Sunday 18 October 2015 18:00:12 Eric Auger wrote:
> 
> +struct list_head reset_list;
> +LIST_HEAD(reset_list);
> 

These two should be marked 'static'.

	Arnd
