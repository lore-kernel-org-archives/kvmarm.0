From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Wed, 9 Mar 2016 12:35:26 +0100
Message-ID: <56E00A7E.4080101@semihalf.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E767C41390
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 06:35:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NtNrs+Ph1oi8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 06:35:32 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E0DDB412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 06:35:31 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id l68so188434954wml.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 09 Mar 2016 03:35:36 -0800 (PST)
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

Forgive me if anybody already asked this question for previous series 
versions.

The review is still pending so it is worth to ask. What is your idea for 
saving and restoring vITS state? I notice device, itte and collection 
linked lists which are essential for vITS state. Of course it is not 
feasible to transfer these list to e.g. QEMU using 
KVM_{GET|SET}_DEVICE_ATTR.

Regards,
Tomasz
