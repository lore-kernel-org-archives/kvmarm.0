From: Stuart Yoder <stuart.yoder@freescale.com>
Subject: kvm status on lsk-3.14
Date: Wed, 2 Sep 2015 16:56:46 +0000
Message-ID: <BY2PR0301MB0743E324B8112812CC532C2587690@BY2PR0301MB0743.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C14B41479
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 12:56:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svy7uG2OjYFH for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Sep 2015 12:56:27 -0400 (EDT)
Received: from na01-bl2-obe.outbound.protection.outlook.com
 (mail-bl2on0146.outbound.protection.outlook.com [65.55.169.146])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 985C6413E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Sep 2015 12:56:27 -0400 (EDT)
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Chris,

On the Linaro wiki there is an ARMv8 status page
https://wiki.linaro.org/LSK/ARMv8

...that seems a bit out of date.  It reports that KVM
support on the Linaro 3.14 kernel had a "target" of
release 14.10 (last October).

I see ~70 "arm64:" + "kvm:" patches added or backported
to the Linaro 3.14 kernel.  Is KVM considered 'supported'
in the latest lsk-3.14? If yes, are there any known
limitations or anything missing?

We have a customer interested in 3.14 on 
ARMv8 and would like to understand what I can say
about KVM support on the Linaro 3.14 kernel.

Thanks,
Stuart
