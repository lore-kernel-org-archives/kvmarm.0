From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Sun, 15 May 2016 12:42:19 +0100
Message-ID: <90cab3e7-7eb3-cb76-5312-af68ee5af7eb@arm.com>
References: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
 <CAMJs5B-dGpg++5__cu2WOp40M0xwQjrPFfGhVhiLvnc6AkGiug@mail.gmail.com>
 <7292cb91-39d9-b859-b219-722db5c5dca4@riken.jp>
 <CAMJs5B_Csdt=BPFc36WtjqVwOdn_4+O6MOKCshEHrmepiEgpxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2258A49B34
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 07:39:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hGzg3zWYAd1O for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2016 07:39:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB47D412C2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 07:39:18 -0400 (EDT)
In-Reply-To: <CAMJs5B_Csdt=BPFc36WtjqVwOdn_4+O6MOKCshEHrmepiEgpxA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

On 15/05/2016 12:19, Christoffer Dall wrote:
> On Sunday, May 15, 2016, Itaru Kitayama <itaru.kitayama@riken.jp
> <mailto:itaru.kitayama@riken.jp>> wrote:
>>
>> Below is the boot (with UEFI) log. I'm attaching the .config I'm using.
>> I've been trying to test Julien's ACPI support patch set recently
> merged in the kvmarm tree on Mustang.
>
>
> I don't run anything with ACPI, so haven't tested that particular aspect.
>
> This doesn't immediately look like it's related to the kvmarm patches.
>
> Perhaps you could try with Linux-next as well to see if this was already
> fixed?
>
> Julien, did you test mustang with your ACPI patches?

No, the patch has been tested on Juno-r2 and Seattle.

However, the logs looks very similar to a bug that Steve Capper was 
hunting in Linux 4.6.0-rc3. I believe this has been fixed in a later RC.

kvm-arm-for-4.7 seems to be based on Linux 4.6-rc1 so I would recommend 
you to try Linux-next.

Regards,

-- 
Julien Grall
