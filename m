From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM KVM guest virtual address to host virtual address Look up
Date: Fri, 15 Jan 2016 15:38:45 +0000
Message-ID: <CAFEAcA9aPFKMSuF8RSxnf1cxqrMf_BtgZDfonQige+9O1RWkNg@mail.gmail.com>
References: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
 <CAFEAcA-rOAGxVrEs5q--z5BFq2YR0ExK8cmQn2PX1s+cCo27hA@mail.gmail.com>
 <q70d9pc1o02g0mosm9n96cvw.1452856464824@email.android.com>
 <CAFEAcA_cSpFSZX02PJTCvQV6uB75_SbhBkLb1_2Z3uyy+BhBxA@mail.gmail.com>
 <569911BC.3090102@derytech.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67C9749A36
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:34:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a-Gk-um6zKwN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:34:51 -0500 (EST)
Received: from mail-vk0-f44.google.com (mail-vk0-f44.google.com
 [209.85.213.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AEFCB49A12
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:34:51 -0500 (EST)
Received: by mail-vk0-f44.google.com with SMTP id n1so145838491vkb.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 07:39:05 -0800 (PST)
In-Reply-To: <569911BC.3090102@derytech.com.tw>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: hiwu <hiwu@derytech.com.tw>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 15 January 2016 at 15:35, hiwu <hiwu@derytech.com.tw> wrote:
> Hi Peter:
>
> The guest's load/store instructions, which I want to debug, do not cause a
> guest exception.
> ARM KVM only provides the guest' r15 register (pc) value.  To get the guest
> instruction for
> emulating in host, "translate guest VA to host VA" is required. How to
> implement
> "translate guest VA to host VA" in host ?

It occurs to me that I've been assuming you're doing this in
userspace in QEMU, but are you doing this in the kernel itself?
(If so, my previous answers are not relevant.)

thanks
-- PMM
