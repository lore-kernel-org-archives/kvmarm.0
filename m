From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 00/12] KVM: arm64: GICv3 ITS emulation
Date: Tue, 7 Jun 2016 10:02:37 +0200
Message-ID: <CAMJs5B8h6wj16AMXVmuUa00TRzBJRq3_xMJfMEH67F1GMFJ2AA@mail.gmail.com>
References: <1458958450-19662-1-git-send-email-andre.przywara@arm.com>
 <DB5PR04MB099754E61027226E5210C2399A590@DB5PR04MB0997.eurprd04.prod.outlook.com>
 <32b86adb-cdba-89bb-3f19-e7677f39fa1f@arm.com>
 <DB5PR04MB09977DF578DFB03A582745869A5C0@DB5PR04MB0997.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F4132410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2016 03:58:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1u7hvvBp2MRS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2016 03:58:27 -0400 (EDT)
Received: from mail-yw0-f179.google.com (mail-yw0-f179.google.com
 [209.85.161.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42234410B5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2016 03:58:26 -0400 (EDT)
Received: by mail-yw0-f179.google.com with SMTP id o16so162808435ywd.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Jun 2016 01:02:38 -0700 (PDT)
In-Reply-To: <DB5PR04MB09977DF578DFB03A582745869A5C0@DB5PR04MB0997.eurprd04.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bharat Bhushan <bharat.bhushan@nxp.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Diana Madalina Craciun <diana.craciun@nxp.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Bharat,



On Mon, Jun 6, 2016 at 7:29 AM, Bharat Bhushan <bharat.bhushan@nxp.com> wrote:
> Hi Andre,
>
> On clarification, are V5 version of patches are based on new-GIC emulation patches? How are you testing these patches, kvm-tool?
>
> Hi Christoffer/Peter,
>
> Is someone working on QEMU side patches? We need this feature a bit urgently so if no one is working then we can start working on this.
>
Eric Auger (now with Red Hat) was planning to pick up Pavel's series
and do a respin:

https://lists.gnu.org/archive/html/qemu-devel/2015-11/msg05197.html

If you are ready to commit resources to this *immediately* and if Eric
agrees then it would be good for you to pick up this series, but
should you choose to do so please make sure you can actually commit
resources to the work and to keep up with revisions this time around.

Thanks,
-Christoffer
