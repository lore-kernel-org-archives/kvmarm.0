From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM KVM guest virtual address to host virtual address Look up
Date: Fri, 15 Jan 2016 12:17:54 +0000
Message-ID: <CAFEAcA_cSpFSZX02PJTCvQV6uB75_SbhBkLb1_2Z3uyy+BhBxA@mail.gmail.com>
References: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
 <CAFEAcA-rOAGxVrEs5q--z5BFq2YR0ExK8cmQn2PX1s+cCo27hA@mail.gmail.com>
 <q70d9pc1o02g0mosm9n96cvw.1452856464824@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0C049A19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 07:14:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6PycHNG3ZA-v for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 07:14:00 -0500 (EST)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com
 [209.85.213.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C13849A0B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 07:14:00 -0500 (EST)
Received: by mail-vk0-f52.google.com with SMTP id a123so267402055vkh.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 04:18:14 -0800 (PST)
In-Reply-To: <q70d9pc1o02g0mosm9n96cvw.1452856464824@email.android.com>
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

On 15 January 2016 at 11:14, hiwu <hiwu@derytech.com.tw> wrote:
> I want to trap some ldr,str instruction in guest VM for debug. Therefore, I
> have to emulate guest ldr,str in host. Without guest VA to host VA, I cannot
> emulate ldr,str instruction in host.

That sounds like you want "load/store value from guest VA", not "translate
guest VA to host VA". Try cpu_ldl_data and friends (though note that
if you use them to access an invalid address they'll cause a guest
exception).

thanks
-- PMM
