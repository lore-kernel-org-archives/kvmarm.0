From: "Chalamarla, Tirumalesh" <Tirumalesh.Chalamarla@caviumnetworks.com>
Subject: Re: [PATCH] arm64/kvm: Add generic v8 KVM target
Date: Mon, 29 Jun 2015 17:13:37 +0000
Message-ID: <F37C68A5-E48F-462C-AD18-0F3C096348C7@caviumnetworks.com>
References: <1434531646-4873-1-git-send-email-suzuki.poulose@arm.com>
 <CAFEAcA92uymQ3LjPQnuFiwvjSgc+jY54VrfK_Sh4v1DJ+=OPpw@mail.gmail.com>
 <558A6A84.5020603@arm.com> <20150624085128.GA22785@cbox>
 <558A7936.7020109@arm.com> <20150625123034.GE28244@cbox>
 <558BF6C9.3000009@arm.com> <558C05A9.8080201@arm.com>
 <CAFEAcA_ULz=ugQW=NmthzqYRtvcfwteQTh0DonHRN6U5NykEtQ@mail.gmail.com>
 <20150626095318.GG28244@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEE2856A1E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 13:02:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OULlFqH4egHt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jun 2015 13:02:30 -0400 (EDT)
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0064.outbound.protection.outlook.com [207.46.100.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51CD056A1C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jun 2015 13:02:30 -0400 (EDT)
In-Reply-To: <20150626095318.GG28244@cbox>
Content-Language: en-US
Content-ID: <CCDE09FA6AAEB447907F18C18037366A@namprd07.prod.outlook.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "timur@codeaurora.org" <timur@codeaurora.org>, "vgandhi@codeaurora.org" <vgandhi@codeaurora.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu


> On Jun 26, 2015, at 2:53 AM, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> 
> On Thu, Jun 25, 2015 at 02:49:08PM +0100, Peter Maydell wrote:
>> On 25 June 2015 at 14:44, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> It should always be possible to emulate a "known" CPU on a generic host,
>>> and it should be able to migrate. The case we can't migrate is when we
>>> let the guest be generic (which I guess should really be unknown, and
>>> not generic).
>>> 
>>> So if the user specify "-cpu cortex-a57" on the command line, the guest
>>> should be able to migrate from an A72 to an A53. if the user specified
>>> "-cpu host", the resulting guest won't be able to migrate.
>>> 
>>> Does it make sense?
>> 
>> Yes. We've always said "-cpu host" won't be cross-host migratable
>> from a QEMU point of view.
>> 
> ok, this makes sense.  It's basically up to userspace to mandate that
> trying to migrate something that used unknown cpu (via -cpu host or
> whatever) cannot be migrated.
> 

Will this also prevents migrating between same implementations, if no how is this identified.
This seems to be making emulation a requirment for ARM64 KVM. 


Thanks,
Tirumalesh. 
 

> -Christoffer
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
