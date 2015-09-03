From: Kevin Hilman <khilman@kernel.org>
Subject: Re: kvm status on lsk-3.14
Date: Thu, 03 Sep 2015 13:38:21 -0700
Message-ID: <7hio7rnsqq.fsf@deeprootsystems.com>
References: <BY2PR0301MB0743E324B8112812CC532C2587690@BY2PR0301MB0743.namprd03.prod.outlook.com>
 <20150903085223.GD5171@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15E6F42612
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 16:38:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JTiecLTCTngy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2015 16:38:00 -0400 (EDT)
Received: from mail-pa0-f51.google.com (mail-pa0-f51.google.com
 [209.85.220.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0656141D24
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2015 16:37:59 -0400 (EDT)
Received: by pacwi10 with SMTP id wi10so1025602pac.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Sep 2015 13:38:23 -0700 (PDT)
In-Reply-To: <20150903085223.GD5171@cbox> (Christoffer Dall's message of "Thu,
 3 Sep 2015 10:52:23 +0200")
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
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>, Stuart Yoder <stuart.yoder@freescale.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Christoffer Dall <christoffer.dall@linaro.org> writes:

> On Wed, Sep 02, 2015 at 04:56:46PM +0000, Stuart Yoder wrote:
>> Chris,
>> 
>> On the Linaro wiki there is an ARMv8 status page
>> https://wiki.linaro.org/LSK/ARMv8
>> 
>> ...that seems a bit out of date.  It reports that KVM
>> support on the Linaro 3.14 kernel had a "target" of
>> release 14.10 (last October).
>> 
>> I see ~70 "arm64:" + "kvm:" patches added or backported
>> to the Linaro 3.14 kernel.  Is KVM considered 'supported'
>> in the latest lsk-3.14? If yes, are there any known
>> limitations or anything missing?
>
> We've backported most of the functionality and fixes up until 4.0, I
> believe.
>
>> 
>> We have a customer interested in 3.14 on 
>> ARMv8 and would like to understand what I can say
>> about KVM support on the Linaro 3.14 kernel.
>> 
>
> The biggest weakness is probably lack of testing for virtualization
> purposes.  I'm not aware of anyone haveing done any serious testing on
> LSK with KVM.
>
> Cc'ing Kevin for his comments on the testing and status aspect.

We're not doing any thorough testing, but at kernelci.org we are doing
basic boot testing of KVM guest on a few platforms (x86, arm, arm64.)
Boot results/logs are available at kernelci.org[1]

Kevin

[1] http://kernelci.org/job/lsk/branch/local:linux-linaro-lsk-v3.14/
