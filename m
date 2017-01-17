From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH 0/3] KVM/ARM updates for 4.10-rc4
Date: Tue, 17 Jan 2017 17:49:24 +0100
Message-ID: <20170117164923.GB2386@potion>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1484F401A1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 11:47:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Hd18LgyoNx7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 11:47:35 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D6F6400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 11:47:35 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

2017-01-13 11:31+0000, Marc Zyngier:
> Radim, Paolo,
> 
> Here's the KVM/ARM updates for 4.10-rc4. Two timer fixes, and one vgic
> fix for a deadlock that's been reported this week (which should land
> into stable).

Pulled to kvm/master, thanks.
