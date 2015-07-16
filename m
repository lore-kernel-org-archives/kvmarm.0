From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v4 0/2] arm/arm64: KVM: Optimize arm64 fp/simd,
 saves 30-50% on exits for non-VHE
Date: Thu, 16 Jul 2015 11:23:08 -0700
Message-ID: <55A7F68C.6020903@samsung.com>
References: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
 <20150716155253.GU7845@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D15358B47
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 14:11:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CI+1DOnYo7Mu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jul 2015 14:11:24 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A68E58B46
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 14:11:23 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRL00JTNF2UGW50@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 16 Jul 2015 14:23:18 -0400 (EDT)
In-reply-to: <20150716155253.GU7845@cbox>
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
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/16/2015 08:52 AM, Christoffer Dall wrote:
> On Fri, Jul 10, 2015 at 06:19:05PM -0700, Mario Smarduch wrote:
>> This is a followp to previous iteration but implemented on top of VHE patches. 
>> Only non-VHE path is addressied by this patch. In second patch 32-bit handler 
>> is updated to keep exit handling consistent with 64-bit code, and nothing
>> has changed.
>>
> Why not simply preserve this the way it was in v3 and have it merged
> first - after all we have reviewed it and I thought it was more or less
> ready to be merged - I suspect the VHE patches may have a way to go
> still ?

Definitely, that's a better path. After looking at VHE patches,
I would probably leave V3 the way it is (keeping deactivate_xxxx:
symmetric). Marc has Reviewed V3 and you commented either way was
fine with you, so V3 should be ok.

Jumping on VHE is little too much at this time, thanks for the
alternative I kind of got myself into a jam here.

- Mario

> 
> -Christoffer
> 
