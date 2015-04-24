From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/2] irq: add get_gsi callback
Date: Fri, 24 Apr 2015 14:04:18 +0200
Message-ID: <553A3142.90105@redhat.com>
References: <1429778977-1632-1-git-send-email-eric.auger@linaro.org>
 <5538BBD3.9040404@redhat.com> <5538BE19.6030009@linaro.org>
 <5538C246.20304@redhat.com> <553A0657.6050100@linaro.org>
 <553A08D3.3020609@redhat.com> <553A0A4D.905@linaro.org>
 <553A0CF5.9030304@redhat.com> <553A115E.1050705@linaro.org>
 <553A14D3.1030300@redhat.com> <553A301D.3070503@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF71B4E679
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 07:56:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7qsRfNUIqQcX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2015 07:56:11 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C713A4E678
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2015 07:56:11 -0400 (EDT)
In-Reply-To: <553A301D.3070503@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, peter.maydell@linaro.org, agraf@suse.de
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 24/04/2015 13:59, Eric Auger wrote:
> > Then I would go for the other solution (the notifier, just adding the
> > callback to SysbusDeviceClass).  But I still do not understand why you
> > didn't have exactly the same problem :) unless you were walking the list
> > to find the relevant VFIOINTp.
> 
> Yes I was walking the list ;-)
> 
> So is my understanding coherent: revert to first patch but moving
> notifier in class

Yes.

Paolo
