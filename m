From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: Nested Virtualization on ARM v8.0
Date: Mon, 29 Oct 2018 09:35:53 +0100
Message-ID: <20181029083553.GA9901@C02W217FHV2R.local>
References: <CAPtinC099M+AdQZGb46xAVJ5JfVUZ-ZriYe1fu-vvm9jc5SVRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61D6A4A2B2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 04:35:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id STZWopYy5PLG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Oct 2018 04:35:57 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DAE4A2AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Oct 2018 04:35:57 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAPtinC099M+AdQZGb46xAVJ5JfVUZ-ZriYe1fu-vvm9jc5SVRA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vishnu Pajjuri <vishnu.socialac@gmail.com>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vishnu,

[ You already asked this question and received a reply off-list on
  Friday, but I'll repeat Marc's reply here on the list for the record.

  Also, I'm assuming you had difficulty with your e-mail and therefore
  sent from both your private and corporate e-mail client.  Please be
  careful about this in the future. ]

On Mon, Oct 29, 2018 at 12:06:16PM +0530, Vishnu Pajjuri wrote:
> Hi all,
>      I'm trying Nested Virtualization feature on eMAG(ARMv8) platform,
> could you please tell us the setup details in detail. Means how you guys
> ran Nested Virtualization on ARM platform.

You need minimum an Armv8.3 CPU to run nested virtualization.

> Also could you please tell us the kernel version and kernel source from any
> git repo(mention kernel parameters if used any) and QEMU version and QEMU
> source from git repo with parameters passed.

You can find patches including documentation and all the information you
need on the mailing list archives of both the kvmarm list and the
linux-arm-kernel list.

> 
> If you guys have any VM disks used to verify this feature, could you please
> share those details as well. Share if any other details required
> 

All you need is a suitable AArch64 file system, and you can create or
download whichever one you prefer and populate it with the tools you
need.

We (upstream Linux developers) are not in the business of supplying
binaries, file systems, distros or anything like that.

Please attempt to follow one of the numerous guides available online,
and if you have specific questions we will be happy to help.


Thanks,

    Christoffer
