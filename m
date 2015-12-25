From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: kvmarm tags kvm-arm-for-4.2, 4.3, and v4.4-rc6 does not boot on
 Mustang
Date: Fri, 25 Dec 2015 19:50:13 +0900
Message-ID: <567D1F65.5040008@riken.jp>
References: <567918E6.8020001@riken.jp> <20151222144135.GB5631@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4E440BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Dec 2015 05:47:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 906Tl6bIRn5D for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Dec 2015 05:47:21 -0500 (EST)
Received: from postman.riken.jp (postman4.riken.jp [134.160.33.86])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6566B40B58
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Dec 2015 05:47:21 -0500 (EST)
In-Reply-To: <20151222144135.GB5631@cbox>
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

Hi Christoffer,
After some investigations, it seems newer kernels does not boot on the
Mustang board which I have access (in the Linaro Server Lab).

I am using the Fedora 23 userland, 4.2.x Fedora kernels do boot, but
4.4.x Fedora kernels do not (they are downloaded from the Koji site or
own-built ones using fedpkg). I am not sure at this moment, the F/W
is too old or not.

Itaru

On 12/22/15 11:41 PM, Christoffer Dall wrote:
> On Tue, Dec 22, 2015 at 06:33:26PM +0900, Itaru Kitayama wrote:
>> Hi,
>> I have been trying to test one of the recent tags in kvmarm git tree,
>> kvm-arm-for-4.2, 4.3, and v4.4-rc6 on Mustang, but none of them seem
>> to enter the linux boot process. Has anyone verified any of these work
>> on Mustang? If so can I have a working .config to continue testing?
>>
> Just use mainline tags instead of the kvm-arm-specific ones.
>
> Any recent kernel, like v4.3 or v4.4-rc6 boots just fine on my Mustang
> with defconfig.
>
> -Christoffer
