From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: kvmarm tags kvm-arm-for-4.2, 4.3, and v4.4-rc6 does not boot on
 Mustang
Date: Fri, 15 Jan 2016 13:11:13 +0900
Message-ID: <56987161.4010701@riken.jp>
References: <567918E6.8020001@riken.jp> <20151222144135.GB5631@cbox>
 <567D1F65.5040008@riken.jp> <20151227143303.GA8044@cbox>
 <5680671D.5070408@riken.jp> <20151229145358.GA26657@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7993A49A77
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2016 23:07:05 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k4cqQHIZiZFe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2016 23:07:03 -0500 (EST)
Received: from postman.riken.jp (postman2.riken.jp [134.160.33.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B64F949A6D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2016 23:07:03 -0500 (EST)
In-Reply-To: <20151229145358.GA26657@cbox>
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
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Using newer F/W, I was just able to boot a 4.4.0 kernel with KVM.

[    0.669879] kvm [1]: interrupt-controller@780c0000 IRQ5
[    0.674062] kvm [1]: timer IRQ3
[    0.676033] kvm [1]: 8-bit VMID
[    0.677961] kvm [1]: Hyp mode initialized successfully

Itaru

On 12/29/15 11:53 PM, Christoffer Dall wrote:
> On Mon, Dec 28, 2015 at 07:33:01AM +0900, Itaru Kitayama wrote:
>> Does your Mustang boot via UEFI? Mine does. Mainline v4.4-rc6ish
>> seems to have an issue with libstub.
>>
> No, I use u-boot.
>
> Sorry I can't be of any help then.
>
> -Christoffer
