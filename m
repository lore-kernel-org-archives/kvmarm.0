From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4] arm64: kvm: inject SError with user space specified
 syndrome
Date: Mon, 3 Jul 2017 16:12:16 +0200
Message-ID: <CAMJs5B81U1hdv0xw-Opvt_LVKB66tcAnTf8xobZhoB167vBexg@mail.gmail.com>
References: <1498477155-30950-1-git-send-email-gengdongjiu@huawei.com>
 <20170703075018.GA4066@cbox>
 <CAMj-D2C6xwQ3gajppFL8Fws6Hf9b1gwNsNgTu7k-27fauLk5Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A0C40D1D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 10:12:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hbg8tA8wP8Sb for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 10:11:58 -0400 (EDT)
Received: from mail-yb0-f176.google.com (mail-yb0-f176.google.com
 [209.85.213.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 881F540CE9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 10:11:58 -0400 (EDT)
Received: by mail-yb0-f176.google.com with SMTP id 84so55804036ybe.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 07:12:17 -0700 (PDT)
In-Reply-To: <CAMj-D2C6xwQ3gajppFL8Fws6Hf9b1gwNsNgTu7k-27fauLk5Zw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: wuquanming@huawei.com, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dongjiu Geng <gengdongjiu@huawei.com>, Russell King <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@liadead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 3, 2017 at 4:09 PM, gengdongjiu <gengdj.1984@gmail.com> wrote:
> Hi Christoffer,
>   thank you very much for your review.
>
>
> 2017-07-03 15:50 GMT+08:00, Christoffer Dall <cdall@linaro.org>:
>> Hi Dongjiu,
>>
>> It seems you sent this patch twice, once on its own and then part of a
>> series?
> Christoffer, yes, it is. once on its own and then part of a
> series
>

ok, please don't do that in the future. It confuses us on the other end.

>>
>> Also, please use a cover letter when sending patch series.
> Ok, got it, thank you a lot for your suggestion.
>

Thanks, I'll look more closely once you respin into a new series.

-Christoffer
