From: Julien Grall <julien.grall@citrix.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Thu, 10 Sep 2015 17:30:17 +0100
Message-ID: <55F1B019.6050800@citrix.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
 <1440604845-28229-4-git-send-email-marc.zyngier@arm.com>
 <55F08731.3050402@citrix.com> <55F15353.2000800@arm.com>
 <55F1AE75.6000405@citrix.com> <55F1B011.6090204@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F97B411E3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 12:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hCAfRmSFP4YM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2015 12:30:45 -0400 (EDT)
Received: from SMTP02.CITRIX.COM (smtp02.citrix.com [66.165.176.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97600411AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2015 12:30:45 -0400 (EDT)
In-Reply-To: <55F1B011.6090204@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Ian Campbell <ian.campbell@citrix.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jiang Liu <jiang.liu@linux.intel.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/09/15 17:30, Marc Zyngier wrote:
> On 10/09/15 17:23, Julien Grall wrote:
>> On 10/09/15 10:54, Marc Zyngier wrote:
> 
> [...]
> 
>>> In the meantime, can you give the following patch a shot? My Mustang is 
>>> wired to a 4kB CPU interface, so I'll need your help to test it.
>>
>> I applied the two patches on top of linus/master and I'm able to boot
>> correctly on X-gene. Thank you!
> 
> Thanks for testing. Can I put your Tested-by tag on the patch when I
> send it to Thomas?

Sure:

Tested-by: Julien Grall <julien.grall@citrix.com>

Regards,

-- 
Julien Grall
