From: Linu Cherian <linucherian@gmail.com>
Subject: Re: [PATCH V2 1/2] KVM: arm/arm64: Enable KVM_CAP_NR_MEMSLOTS on
 arm/arm64
Date: Sun, 26 Feb 2017 10:00:14 +0530
Message-ID: <CAGOz-0ZK3HmepGyWMZqEWzCpmvZKNMXOBW5fw=nRtT-pz+e8RQ@mail.gmail.com>
References: <1486538141-30627-1-git-send-email-linucherian@gmail.com>
 <1486538141-30627-2-git-send-email-linucherian@gmail.com>
 <20170223101027.GA1409@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6891D40C43
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Feb 2017 23:29:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nVRhU0OaZ3-d for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Feb 2017 23:29:10 -0500 (EST)
Received: from mail-yw0-f194.google.com (mail-yw0-f194.google.com
 [209.85.161.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70BF240A80
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Feb 2017 23:29:10 -0500 (EST)
Received: by mail-yw0-f194.google.com with SMTP id 203so3925348ywz.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Feb 2017 20:30:15 -0800 (PST)
In-Reply-To: <20170223101027.GA1409@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: sunil.goutham@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Linu Cherian <linu.cherian@cavium.com>, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 23, 2017 at 3:40 PM, Christoffer Dall <cdall@linaro.org> wrote:
> On Wed, Feb 08, 2017 at 12:45:40PM +0530, linucherian@gmail.com wrote:
>> From: Linu Cherian <linu.cherian@cavium.com>
>>
>> Return KVM_USER_MEM_SLOTS for userspace capability query on
>> NR_MEMSLOTS.
>
> This feature seems to be undocumented (I cannot find it in
> Documentation/virtual/kvm/api.txt).
>
> Can we add documentation for it?
>
> What does user space do currently without this capability?  Does it just
> rely on some default?
>

Yes, without this capability,  qemu userspace take the default value of 32.
Will give it a try on the documentation part as a separate patch.
