From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v2] sysbus: add irq_routing_notifier
Date: Mon, 27 Apr 2015 17:01:01 +0200
Message-ID: <553E4F2D.7060808@redhat.com>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>	<CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>	<553DF2AA.2070102@linaro.org>	<553E11E7.7070704@redhat.com>	<553E297F.4020706@linaro.org>	<553E3B7E.9080009@redhat.com>
 <CAEgOgz6eFLhkwm7qto=j=p3L5+cz5s_McUyZUcqeN265CgXSdg@mail.gmail.com>
 <553E4E05.1010405@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B95EA4E9C6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 10:52:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A36l+HKpgPFc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Apr 2015 10:52:46 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 049D44E9C4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Apr 2015 10:52:45 -0400 (EDT)
In-Reply-To: <553E4E05.1010405@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Patch Tracking <patches@linaro.org>, eric.auger@st.com, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 27/04/2015 16:56, Eric Auger wrote:
> Peter, Paolo,
> 
> After your feedbacks, I feel I need to spend some more time on the
> original check() track. I would prefer not to introduce any patch that
> will make issue in the future.

Peter, see the other threads between me and Eric.  See in particular
http://lists.gnu.org/archive/html/qemu-devel/2015-04/msg02749.html
starting at "The notifier actually is not even necessary" and the
replies from there.

If you have any idea, please help.

Paolo
